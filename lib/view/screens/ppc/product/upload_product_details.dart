// Author : Shital Gayakwad
// Created Date : 18 July 2023
// Description : ERPX_PPC -> Production resource management screen
// Modified Date : 8 August 2023 => Implementated functionalities multiple file upload and delete document from database
// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/upload_product_details/upload_product_details_bloc.dart';
import '../../../../bloc/ppc/upload_product_details/upload_product_details_event.dart';
import '../../../../bloc/ppc/upload_product_details/upload_product_details_state.dart';
import '../../../../services/model/product/product.dart';
import '../../../../services/repository/common/documents_repository.dart';
import '../../../../services/repository/product/product_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';
import '../../common/product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ProductDetailsUpload extends StatelessWidget {
  const ProductDetailsUpload({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<UploadproductdetailBloc>(context);
    blocProvider.add(ProductData(productid: ''));
    return Scaffold(
        appBar: CustomAppbar()
            .appbar(context: context, title: 'Production Resource Management'),
        body: MakeMeResponsiveScreen(
            horixontaltab: productionResourceManagementScreen(blocProvider),
            verticaltab: QuickFixUi.notVisible(),
            windows: productionResourceManagementScreen(blocProvider),
            linux: productionResourceManagementScreen(blocProvider),
            mobile: QuickFixUi.notVisible()));
  }

  Center productionResourceManagementScreen(
      UploadproductdetailBloc blocProvider) {
    return Center(
        child: ListView(scrollDirection: Axis.vertical, children: [
      productSearch(blocProvider),
      productDataTable(blocProvider: blocProvider),
      productRoute(blocProvider: blocProvider),
      processRoute(blocProvider: blocProvider)
    ]));
  }

  BlocBuilder<UploadproductdetailBloc, UploadproductdetailState> processRoute(
      {required UploadproductdetailBloc blocProvider}) {
    return BlocBuilder<UploadproductdetailBloc, UploadproductdetailState>(
      builder: (context, state) {
        if (state is UploadproductdetailLoadingState &&
            state.productionInstructionsList.isNotEmpty) {
          double columnWidth = Platform.isAndroid ? 450 : 416;
          double tablewidth = columnWidth * 3;
          double tableHeight =
              (state.productionInstructionsList.length + 1) * 50.3;
          return Center(
            child: Container(
                width: tablewidth,
                height: tableHeight,
                margin: const EdgeInsets.all(10),
                decoration:
                    QuickFixUi().borderContainer(radius: 0, borderThickness: 1),
                child: CustomTable(
                  tablewidth: tablewidth,
                  tableheight: tableHeight,
                  showIndex: true,
                  columnWidth: columnWidth,
                  rowHeight: 50,
                  tableheaderColor: Theme.of(context).primaryColorLight,
                  enableHeaderBottomBorder: true,
                  headerBorderThickness: 1,
                  headerBorderColor: Colors.black,
                  headerStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  enableRowBottomBorder: true,
                  column: [
                    ColumnData(label: 'Sequence Number'),
                    ColumnData(label: 'Instructions'),
                    ColumnData(label: 'Action'),
                  ],
                  rows: state.productionInstructionsList
                      .map((e) => RowData(cell: [
                            TableDataCell(
                                label: Text(
                              e.processsequencenumber.toString(),
                              textAlign: TextAlign.center,
                            )),
                            TableDataCell(
                                label: Text(
                              e.instruction.toString(),
                              textAlign: TextAlign.center,
                            )),
                            TableDataCell(
                                label: ElevatedButton(
                                    onPressed: () async {
                                      StreamController<
                                              List<
                                                  ProductionInstructionsWithDocuments>>
                                          documentsData = StreamController<
                                              List<
                                                  ProductionInstructionsWithDocuments>>();
                                      List<ProductionInstructionsWithDocuments>
                                          documentsList =
                                          await ProductRepository()
                                              .instructionsWithDocuments(
                                                  token: state.token,
                                                  payload: {
                                            'processroute_id': e.id,
                                            'sequence': e.processsequencenumber
                                          });
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        documentsData.add(documentsList);
                                        uploadAndViewPrograms(
                                            context: context,
                                            instructionsList: e,
                                            state: state,
                                            documentsList: documentsList,
                                            documentsData: documentsData);
                                      });
                                    },
                                    child: const Text('Upload'))),
                          ]))
                      .toList(),
                )),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  Future<dynamic> uploadAndViewPrograms(
      {required BuildContext context,
      required ProductionInstructions instructionsList,
      required UploadproductdetailLoadingState state,
      required List<ProductionInstructionsWithDocuments> documentsList,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          documentsData}) {
    StreamController<Map<String, dynamic>> filedata =
        StreamController<Map<String, dynamic>>.broadcast();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Upload and view program file',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          content: StreamBuilder<List<ProductionInstructionsWithDocuments>>(
              stream: documentsData.stream,
              builder: (context, snapshot) {
                double columnWidth = 200;
                double tableWidth = (columnWidth * 4) + 250;
                double tableHeight = snapshot.data != null
                    ? (snapshot.data!.length + 1) * 50
                    : 0;
                return SizedBox(
                  height: snapshot.data != null && snapshot.data!.isNotEmpty
                      ? ((snapshot.data!.length + 1) * 50) + 60
                      : 40,
                  child: Column(
                    children: [
                      registerProgramFile(
                          instructionsList: instructionsList,
                          filedata: filedata,
                          state: state,
                          documentsData: documentsData),
                      viewProgramFiles(
                          snapshot: snapshot,
                          tableWidth: tableWidth,
                          tableHeight: tableHeight,
                          columnWidth: columnWidth,
                          context: context,
                          instructionsList: instructionsList,
                          state: state,
                          documentsData: documentsData)
                    ],
                  ),
                );
              }),
          actions: [
            StreamBuilder<Map<String, dynamic>>(
                stream: filedata.stream,
                builder: (context, snapshot) {
                  return FilledButton(
                      onPressed: () async {
                        if (snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          File file = File(snapshot.data!['filepath']);
                          if (await file.exists()) {
                            await file.delete();
                            filedata.close();
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'));
                })
          ],
        );
      },
    );
  }

  Widget viewProgramFiles(
      {required AsyncSnapshot<List<ProductionInstructionsWithDocuments>>
          snapshot,
      required double tableWidth,
      required double tableHeight,
      required double columnWidth,
      required BuildContext context,
      required ProductionInstructions instructionsList,
      required UploadproductdetailLoadingState state,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          documentsData}) {
    return snapshot.data != null && snapshot.data!.isNotEmpty
        ? Container(
            width: tableWidth,
            height: tableHeight,
            margin: const EdgeInsets.all(10),
            decoration:
                QuickFixUi().borderContainer(radius: 0, borderThickness: 1),
            child: CustomTable(
              tablewidth: tableWidth,
              tableheight: tableHeight,
              showIndex: true,
              columnWidth: columnWidth,
              rowHeight: 50,
              tableheaderColor: Theme.of(context).primaryColorLight,
              enableHeaderBottomBorder: true,
              headerBorderThickness: 1,
              headerBorderColor: Colors.black,
              headerStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              enableRowBottomBorder: true,
              column: [
                ColumnData(label: 'Sequence Number'),
                ColumnData(label: 'Instructions', width: 300),
                ColumnData(label: 'File name', width: 300),
                ColumnData(label: 'Action'),
              ],
              rows: snapshot.data!.map((e) {
                return RowData(cell: [
                  TableDataCell(
                      label: Text(
                    instructionsList.processsequencenumber.toString(),
                    textAlign: TextAlign.center,
                  )),
                  TableDataCell(
                      width: 300,
                      label: Text(
                        instructionsList.instruction.toString(),
                        textAlign: TextAlign.center,
                      )),
                  TableDataCell(
                      width: 300,
                      label: Text(
                        programPath(e),
                        textAlign: TextAlign.center,
                      )),
                  TableDataCell(
                      label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            final docData = await DocumentsRepository()
                                .documents(state.token, e.mdocId.toString());
                            if (docData != null) {
                              Documents()
                                  .models(docData, '', '', e.mdocId.toString());
                            }
                          },
                          child: const Text('View')),
                      IconButton(
                          onPressed: () {
                            deleteProgramsPermanently(
                                context: context,
                                state: state,
                                instructionsData: e,
                                instructionsList: instructionsList,
                                documentsData: documentsData);
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 30,
                            color: Theme.of(context).colorScheme.error,
                          ))
                    ],
                  )),
                ]);
              }).toList(),
            ))
        : const Stack();
  }

  Future<dynamic> deleteProgramsPermanently(
      {required BuildContext context,
      required UploadproductdetailLoadingState state,
      required ProductionInstructionsWithDocuments instructionsData,
      required ProductionInstructions instructionsList,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          documentsData}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Alert',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.error),
          ),
          content: const SizedBox(
            height: 25,
            child: Center(
                child: Text(
              'Do you want to delete it permanently',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )),
          ),
          actions: [
            FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                      (states) => Theme.of(context).colorScheme.error),
                ),
                onPressed: () async {
                  String response = await ProductRepository()
                      .deleteProgramFiles(token: state.token, payload: {
                    'postgresql_id': instructionsData.id.toString(),
                    'mongodb_id': instructionsData.mdocId.toString()
                  });
                  if (response == 'Deleted successfully') {
                    List<ProductionInstructionsWithDocuments> documentsList =
                        await ProductRepository().instructionsWithDocuments(
                            token: state.token,
                            payload: {
                          'processroute_id': instructionsList.id,
                          'sequence': instructionsList.processsequencenumber
                        });
                    documentsData.add(documentsList);
                    Navigator.of(context).pop();
                    QuickFixUi().showCustomDialog(
                        context: context,
                        errorMessage: 'Program file deleted successfully');
                  } else {
                    QuickFixUi().showCustomDialog(
                        context: context, errorMessage: response);
                  }
                },
                child: const Text('Yes')),
            FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                      (states) => AppColors.greenTheme),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
          ],
        );
      },
    );
  }

  String programPath(ProductionInstructionsWithDocuments e) {
    String input = e.remark.toString();
    int count = 5;
    List<String> parts = input.split('/');
    if (parts.length >= count + 1) {
      return '/' + parts.skip(parts.length - count).join('/');
    } else {
      return input;
    }
  }

  Container registerProgramFile(
      {required ProductionInstructions instructionsList,
      required StreamController<Map<String, dynamic>> filedata,
      required UploadproductdetailLoadingState state,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          documentsData}) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 40,
            decoration:
                QuickFixUi().borderContainer(borderThickness: 0.5, radius: 0),
            child: Center(
              child: Text(
                instructionsList.processsequencenumber.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          QuickFixUi.horizontalSpace(width: 10),
          Container(
            width: 400,
            height: 40,
            decoration:
                QuickFixUi().borderContainer(borderThickness: 0.5, radius: 0),
            child: Center(
              child: Text(
                instructionsList.instruction.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          QuickFixUi.horizontalSpace(width: 10),
          StreamBuilder<Map<String, dynamic>>(
              stream: filedata.stream,
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return Row(
                    children: [
                      openProgramFile(snapshot: snapshot, context: context),
                      deleteProgramFile(
                          snapshot: snapshot,
                          filedata: filedata,
                          context: context)
                    ],
                  );
                } else {
                  return pickAndSaveProgramFile(filedata);
                }
              }),
          QuickFixUi.horizontalSpace(width: 10),
          submitProgramFile(
              filedata: filedata,
              state: state,
              instructionsList: instructionsList,
              documentsData: documentsData)
        ],
      ),
    );
  }

  StreamBuilder<Map<String, dynamic>> submitProgramFile(
      {required StreamController<Map<String, dynamic>> filedata,
      required UploadproductdetailLoadingState state,
      required ProductionInstructions instructionsList,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          documentsData}) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: filedata.stream,
        builder: (context, snapshot) {
          return ElevatedButton(
              onPressed: () async {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  File file = File(snapshot.data!['filepath']);
                  if (await file.exists()) {
                    List<int> fileBytes = await file.readAsBytes();
                    String programFileData = base64Encode(fileBytes);
                    String response = await ProductRepository()
                        .uploadMachinePrograms(token: state.token, payload: {
                      'createdby': state.userId,
                      'pd_product_id': state.selectedProductRoute['productid'],
                      'revision_number': state.selectedProductRoute['revision'],
                      'workstation_id':
                          state.selectedProductRoute['workstationid'],
                      'workcenter_id':
                          state.selectedProductRoute['workcentreid'],
                      'process_route_id': instructionsList.id,
                      'process_seq': instructionsList.processsequencenumber,
                      'remark': snapshot.data!['remark'],
                      'imagetype_code': snapshot.data!['extension'],
                      'data': programFileData
                    });
                    List<ProductionInstructionsWithDocuments> documentsList =
                        await ProductRepository().instructionsWithDocuments(
                            token: state.token,
                            payload: {
                          'processroute_id': instructionsList.id,
                          'sequence': instructionsList.processsequencenumber
                        });
                    documentsData.add(documentsList);
                    if (response == 'File uploaded successfully') {
                      await file.delete();
                      filedata.add({});
                      QuickFixUi().showCustomDialog(
                          context: context, errorMessage: response);
                    } else {
                      QuickFixUi().showCustomDialog(
                          context: context, errorMessage: response);
                      await file.delete();
                      filedata.add({});
                    }
                  } else {
                    QuickFixUi().showCustomDialog(
                        context: context,
                        errorMessage: 'Program file not found');
                  }
                } else {
                  QuickFixUi().showCustomDialog(
                      context: context, errorMessage: 'Program file not found');
                }
              },
              child: const Text('Submit'));
        });
  }

  IconButton pickAndSaveProgramFile(
      StreamController<Map<String, dynamic>> filedata) {
    return IconButton(
        padding: const EdgeInsets.only(bottom: 20),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            PlatformFile file = result.files.first;
            File pickedFile = File(file.path!);
            String remark = pickedFile.path.replaceAll(r'\', '/');
            Directory appDir = await getApplicationDocumentsDirectory();
            String filePath = appDir.path + "/" + file.name;
            await pickedFile.copy(filePath);
            if (filePath.contains('.')) {
              filedata.add({
                'filepath': filePath,
                'remark': remark,
                'extension': file.extension
              });
            } else {
              filedata.add(
                  {'filepath': filePath, 'remark': remark, 'extension': ''});
            }
          }
        },
        icon: const Icon(
          Icons.file_open,
          color: AppColors.appTheme,
          size: 40,
        ));
  }

  IconButton deleteProgramFile(
      {required AsyncSnapshot<Map<String, dynamic>> snapshot,
      required StreamController<Map<String, dynamic>> filedata,
      required BuildContext context}) {
    return IconButton(
        onPressed: () async {
          File file = File(snapshot.data!['filepath']);
          if (await file.exists()) {
            filedata.add({});
            await file.delete();
            QuickFixUi().showCustomDialog(
                context: context, errorMessage: 'File deleted successfully.');
          } else {
            QuickFixUi().showCustomDialog(
                context: context, errorMessage: 'File not found.');
          }
        },
        icon: Icon(
          Icons.delete,
          size: 30,
          color: Theme.of(context).colorScheme.error,
        ));
  }

  IconButton openProgramFile(
      {required AsyncSnapshot<Map<String, dynamic>> snapshot,
      required BuildContext context}) {
    return IconButton(
        onPressed: () async {
          await OpenFile.open(snapshot.data!['filepath']);
        },
        icon: Icon(
          Icons.remove_red_eye,
          size: 30,
          color: Theme.of(context).primaryColor,
        ));
  }

  Center productSearch(UploadproductdetailBloc blocProvider) {
    return Center(
      child: Container(
          width: 300,
          height: 60,
          margin: const EdgeInsets.all(10),
          child: ProductSearch(
            onChanged: (value) {
              blocProvider.add(ProductData(productid: value!.id.toString()));
            },
          )),
    );
  }

  BlocConsumer<UploadproductdetailBloc, UploadproductdetailState> productRoute(
      {required UploadproductdetailBloc blocProvider}) {
    return BlocConsumer<UploadproductdetailBloc, UploadproductdetailState>(
      listener: (context, state) {
        if (state is UploadproductdetailLoadingState &&
            state.uploadProgram == true &&
            state.productid != '' &&
            state.productRouteList.isEmpty) {
          QuickFixUi().showCustomDialog(
              context: context, errorMessage: 'Product route is not found');
        }
      },
      builder: (context, state) {
        if (state is UploadproductdetailLoadingState &&
            state.uploadProgram == true &&
            state.productRouteList.isNotEmpty) {
          double columnWidth = Platform.isAndroid ? 332 : 312;
          double tableWidth = columnWidth * 4;
          double tableHeight =
              double.parse((state.productRouteList.length + 1).toString());
          tableHeight = tableHeight * 50.3;
          return Center(
            child: Container(
              height: tableHeight,
              width: tableWidth,
              margin: const EdgeInsets.all(10),
              child: CustomTable(
                tablewidth: tableWidth,
                tableheight: tableHeight,
                showIndex: true,
                tableOutsideBorder: true,
                columnWidth:
                    Platform.isAndroid ? columnWidth - 14 : columnWidth - 10,
                rowHeight: 50,
                tableheaderColor: Theme.of(context).colorScheme.errorContainer,
                headerStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                enableRowBottomBorder: true,
                column: [
                  ColumnData(label: 'Sequence Number'),
                  ColumnData(label: 'Workcentre'),
                  ColumnData(label: 'Workstation'),
                  ColumnData(label: 'Action'),
                ],
                rows: state.productRouteList
                    .map((e) => RowData(cell: [
                          TableDataCell(
                              label: Text(
                            e.sequencenumber.toString(),
                            textAlign: TextAlign.center,
                          )),
                          TableDataCell(
                              label: Text(
                            e.workcentre.toString(),
                            textAlign: TextAlign.center,
                          )),
                          TableDataCell(
                              label: Text(
                            e.workstation.toString(),
                            textAlign: TextAlign.center,
                          )),
                          TableDataCell(
                              label: FilledButton(
                                  onPressed: () async {
                                    try {
                                      List<ProductionInstructions>
                                          productionInstructionsList =
                                          await ProductRepository()
                                              .instructions(
                                                  token: state.token,
                                                  payload: {
                                            'productroute_id': e.productrouteid
                                          });
                                      if (productionInstructionsList
                                          .isNotEmpty) {
                                        blocProvider.add(ProductData(
                                            productid: state.productid,
                                            uploadProgram: state.uploadProgram,
                                            productRevision:
                                                state.productRevision,
                                            productRouteId:
                                                state.productRouteId,
                                            productionInstructionsList:
                                                productionInstructionsList,
                                            selectedProductRoute: {
                                              'productid': e.productid,
                                              'revision': e.revisionNumber,
                                              'workcentreid': e.workcentreid,
                                              'workstationid': e.workstationid
                                            }));
                                      } else {
                                        QuickFixUi().showCustomDialog(
                                            context: context,
                                            errorMessage:
                                                'Fill instructions first');
                                      }
                                    } catch (e) {
                                      QuickFixUi.errorMessage(
                                          e.toString(), context);
                                    }
                                  },
                                  child: const Text('Next'))),
                        ]))
                    .toList(),
              ),
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocConsumer<UploadproductdetailBloc, UploadproductdetailState>
      productDataTable({required UploadproductdetailBloc blocProvider}) {
    return BlocConsumer<UploadproductdetailBloc, UploadproductdetailState>(
      listener: (context, state) {
        if (state is UploadproductdetailLoadingState &&
            state.productData.isEmpty &&
            state.productid != '') {
          QuickFixUi().showCustomDialog(
              context: context, errorMessage: 'Product data not found');
        }
      },
      builder: (context, state) {
        if (state is UploadproductdetailLoadingState &&
            state.productData.isNotEmpty) {
          double tableheight =
              double.parse((state.productData.length + 1).toString());
          double columnWidth = Platform.isAndroid ? 230 : 200;
          double tableWidth = (columnWidth * 4) + 650 - columnWidth;
          return Center(
            child: Container(
              height: (state.productData.length + 1) * 55,
              width: tableWidth,
              margin: const EdgeInsets.all(10),
              decoration:
                  QuickFixUi().borderContainer(radius: 0, borderThickness: 1),
              child: CustomTable(
                  tablewidth: tableWidth,
                  tableheight: tableheight * 55,
                  showIndex: true,
                  columnWidth: columnWidth,
                  rowHeight: 55,
                  tableheaderColor: Theme.of(context).primaryColorLight,
                  enableRowBottomBorder: true,
                  headerStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  column: [
                    ColumnData(label: 'Product'),
                    ColumnData(label: 'Revision Number'),
                    ColumnData(label: 'Description'),
                    ColumnData(width: 600, label: 'Action'),
                  ],
                  rows: state.productData
                      .map((e) => RowData(cell: [
                            TableDataCell(
                                label: Text(
                              e.code.toString(),
                              textAlign: TextAlign.center,
                            )),
                            TableDataCell(
                                label: Text(
                              e.revisionnumber.toString(),
                              textAlign: TextAlign.center,
                            )),
                            TableDataCell(
                                label: Text(
                              e.description.toString(),
                              textAlign: TextAlign.center,
                            )),
                            TableDataCell(
                                width: 600,
                                label: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('BOM & Route',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ))),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateColor
                                                .resolveWith((states) => state
                                                                .uploadProgram ==
                                                            true &&
                                                        state.productRouteList
                                                            .isNotEmpty &&
                                                        e.revisionnumber ==
                                                            state
                                                                .productRevision
                                                    ? AppColors.greenTheme
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface),
                                          ),
                                          onPressed: () {
                                            blocProvider.add(ProductData(
                                                productid: e.id.toString(),
                                                productRevision:
                                                    e.revisionnumber.toString(),
                                                uploadProgram: true));
                                          },
                                          child: Text(
                                            'Programs',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: state.uploadProgram ==
                                                            true &&
                                                        state.productRouteList
                                                            .isNotEmpty &&
                                                        e.revisionnumber ==
                                                            state
                                                                .productRevision
                                                    ? AppColors.whiteTheme
                                                    : AppColors.appTheme),
                                          )),
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('3D Models',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ))),
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('Drawings',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ],
                                  ),
                                )),
                          ]))
                      .toList()),
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }
}
