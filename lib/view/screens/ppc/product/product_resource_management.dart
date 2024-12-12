// Author : Shital Gayakwad
// Created date : 20 September 2023
// Description : Product resource managements screen

// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../../../bloc/ppc/product_resource_management/product_resource_management_bloc.dart';
import '../../../../bloc/ppc/product_resource_management/product_resource_management_event.dart';
import '../../../../bloc/ppc/product_resource_management/product_resource_management_state.dart';
import '../../../../routes/route_data.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/product/product.dart';
import '../../../../services/model/product/product_route.dart';
import '../../../../services/repository/common/documents_repository.dart';
import '../../../../services/repository/product/product_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';

class ProductResourceManagement extends StatelessWidget {
  const ProductResourceManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider =
        BlocProvider.of<ProductResourceManagementBloc>(context);
    blocProvider.add(UploadMachineProgramEvent());
    double screenWidth = MediaQuery.of(context).size.width;
    StreamController<int> controller = StreamController<int>();
    controller.add(0);
    return MakeMeResponsiveScreen(
      horixontaltab: productResourceManagementWidget(
          context: context,
          blocProvider: blocProvider,
          screenWidth: screenWidth,
          masterColumnWidth: [200, 200, 270, 600],
          productRouteColumnWidth: [79, 170, 160, 320, 90, 100, 350],
          controller: controller),
      windows: productResourceManagementWidget(
          context: context,
          blocProvider: blocProvider,
          screenWidth: screenWidth > 1400 ? 1300 : screenWidth,
          masterColumnWidth: [200, 200, 261, 600],
          productRouteColumnWidth: [79, 170, 160, 310, 90, 100, 350],
          controller: controller),
    );
  }

  StreamBuilder<int> productResourceManagementWidget(
      {required BuildContext context,
      required ProductResourceManagementBloc blocProvider,
      required double screenWidth,
      required List<double> masterColumnWidth,
      required List<double> productRouteColumnWidth,
      required StreamController<int> controller}) {
    return StreamBuilder<int>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List programs = [
              'Upload programs',
              'Unverified programs',
              'Verified programs',
              'Program converter',
              'New Production Product'
            ];
            return Scaffold(
              appBar: CustomAppbar().appbar(
                  context: context, title: 'Product resource management'),
              body: resourceManagementScreen(
                  snapshot: snapshot,
                  blocProvider: blocProvider,
                  screenWidth: screenWidth,
                  masterColumnWidth: masterColumnWidth,
                  productRouteColumnWidth: productRouteColumnWidth,
                  context: context),
              bottomNavigationBar: NavigationBar(
                selectedIndex: snapshot.data!,
                destinations: programs
                    .map(
                      (e) => NavigationDestination(
                        icon: MyIconGenerator.getIcon(
                            name: e, iconColor: Theme.of(context).primaryColor),
                        label: e,
                      ),
                    )
                    .toList(),
                onDestinationSelected: (value) {
                  controller.add(value);
                },
              ),
            );
          } else {
            return const Stack();
          }
        });
  }

  resourceManagementScreen(
      {required AsyncSnapshot<int> snapshot,
      required ProductResourceManagementBloc blocProvider,
      required double screenWidth,
      required List<double> masterColumnWidth,
      required List<double> productRouteColumnWidth,
      required BuildContext context}) {
    switch (snapshot.data) {
      case 0:
        return programsUploadScreen(
          blocProvider: blocProvider,
          screenWidth: screenWidth,
          masterColumnWidth: masterColumnWidth,
          productRouteColumnWidth: productRouteColumnWidth,
        );
      case 1:
        return RouteData.getRouteData(
          context,
          RouteName.verifyMachinePrograms,
          {},
        );
      case 2:
        return RouteData.getRouteData(
          context,
          RouteName.verifiedMachinePrograms,
          {},
        );

      case 3:
        return RouteData.getRouteData(
          context,
          RouteName.programsconverter,
          {},
        );
      case 4:
        return RouteData.getRouteData(
          context,
          RouteName.newproductionproduct,
          {},
        );
      default:
        return const Center(child: Text('Appropriate screen not found'));
    }
  }

  Center programsUploadScreen(
      {required ProductResourceManagementBloc blocProvider,
      required double screenWidth,
      required List<double> masterColumnWidth,
      required List<double> productRouteColumnWidth}) {
    return Center(
      child: ListView(
        children: [
          selectProductWidget(blocProvider: blocProvider),
          masterProductDataTableWidget(
              screenWidth: screenWidth,
              masterColumnWidth: masterColumnWidth,
              blocProvider: blocProvider),
          productRoute(
              screenWidth: screenWidth,
              masterColumnWidth: masterColumnWidth,
              productRouteColumnWidth: productRouteColumnWidth,
              blocProvider: blocProvider)
        ],
      ),
    );
  }

  BlocBuilder<ProductResourceManagementBloc, ProductResourceManagementState>
      selectProductWidget(
          {required ProductResourceManagementBloc blocProvider}) {
    return BlocBuilder<ProductResourceManagementBloc,
        ProductResourceManagementState>(
      builder: (context, state) {
        if (state is UploadMachineProgramState &&
            state.productList.isNotEmpty) {
          return Center(
            child: Container(
              width: 300,
              height: 50,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 30),
              decoration: QuickFixUi().borderContainer(borderThickness: .5),
              child: DropdownSearch<FilledProductAndProcessRoute>(
                items: state.productList,
                itemAsString: (item) => item.product.toString(),
                popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18),
                    )),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        hintText: "Select product", border: InputBorder.none)),
                onChanged: (value) {
                  blocProvider.add(UploadMachineProgramEvent(
                      productId: value!.productId.toString()));
                },
              ),
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  Center productRoute(
      {required double screenWidth,
      required List<double> masterColumnWidth,
      required List<double> productRouteColumnWidth,
      required ProductResourceManagementBloc blocProvider}) {
    return Center(
      child: BlocConsumer<ProductResourceManagementBloc,
          ProductResourceManagementState>(
        listener: (context, state) {
          if (state is UploadMachineProgramState &&
              state.productRevision.toString().trim() != '' &&
              state.productAndProcessRouteDataList.isEmpty) {
            QuickFixUi().showCustomDialog(
                context: context, errorMessage: 'Product route not filled.');
          }
        },
        builder: (context, state) {
          if (state is UploadMachineProgramState &&
              state.productRevision != '' &&
              state.productAndProcessRouteDataList.isNotEmpty) {
            double rowHeight = 50,
                tablehght = ((state.productAndProcessRouteDataList.length + 1) *
                    (rowHeight + .2)),
                tableHeight = Platform.isAndroid
                    ? tablehght < 387
                        ? tablehght
                        : 387
                    : tablehght;
            return Container(
              width: screenWidth,
              height: tableHeight,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: CustomTable(
                tablewidth: screenWidth,
                tableheight: tableHeight,
                showIndex: true,
                rowHeight: rowHeight,
                tableheaderColor: Theme.of(context).colorScheme.errorContainer,
                headerStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold),
                enableRowBottomBorder: true,
                tableOutsideBorder: true,
                tableBorderColor: Theme.of(context).colorScheme.error,
                column: [
                  ColumnData(
                      width: productRouteColumnWidth[0], label: 'Seq. No.'),
                  ColumnData(
                      width: productRouteColumnWidth[1], label: 'Workcentre'),
                  ColumnData(
                      width: productRouteColumnWidth[2], label: 'Workstation'),
                  ColumnData(
                      width: productRouteColumnWidth[3], label: 'Instructions'),
                  ColumnData(
                      width: productRouteColumnWidth[4], label: 'Setup Min.'),
                  ColumnData(
                      width: productRouteColumnWidth[5], label: 'Runtime min'),
                  ColumnData(
                      width: productRouteColumnWidth[6], label: 'Action'),
                ],
                rows: state.productAndProcessRouteDataList
                    .map((e) => RowData(cell: [
                          TableDataCell(
                              width: productRouteColumnWidth[0],
                              label: Text(
                                e.combinedSequence.toString(),
                                textAlign: TextAlign.center,
                              )),
                          TableDataCell(
                              width: productRouteColumnWidth[1],
                              label: Text(
                                e.workcentre == null
                                    ? ''
                                    : e.workcentre.toString(),
                                textAlign: TextAlign.center,
                              )),
                          TableDataCell(
                              width: productRouteColumnWidth[2],
                              label: Text(
                                e.workstation == null
                                    ? ''
                                    : e.workstation.toString(),
                                textAlign: TextAlign.center,
                              )),
                          TableDataCell(
                              width: productRouteColumnWidth[3],
                              label: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: TextButton(
                                    child: Text(
                                      e.instruction == null
                                          ? ''
                                          : e.instruction.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    onPressed: () {
                                      instructionDialog(
                                          context: context,
                                          productProcessRoute: e);
                                    },
                                  ))),
                          TableDataCell(
                              width: productRouteColumnWidth[4],
                              label: Text(
                                e.setuptimemins == null
                                    ? ''
                                    : e.setuptimemins.toString(),
                                textAlign: TextAlign.center,
                              )),
                          TableDataCell(
                              width: productRouteColumnWidth[5],
                              label: Text(
                                e.runtimemins == null
                                    ? ''
                                    : e.runtimemins.toString(),
                                textAlign: TextAlign.center,
                              )),
                          TableDataCell(
                              width: productRouteColumnWidth[6],
                              label: e.isButton == true
                                  ? uploadProgramsButton(
                                      productProcessRoute: e,
                                      state: state,
                                      context: context,
                                      blocProvider: blocProvider,
                                      screenWidth: screenWidth)
                                  : const Text('')),
                        ]))
                    .toList(),
              ),
            );
          } else {
            return const Stack();
          }
        },
      ),
    );
  }

  Future<dynamic> instructionDialog(
      {required BuildContext context,
      required ProductAndProcessRouteModel productProcessRoute}) {
    final ScrollController scrollController = ScrollController();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Instructions',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 17),
          ),
          content: Scrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              child: Text(productProcessRoute.instruction.toString()),
            ),
          ),
          actions: [
            Center(
              child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            )
          ],
        );
      },
    );
  }

  FilledButton uploadProgramsButton(
      {required ProductAndProcessRouteModel productProcessRoute,
      required UploadMachineProgramState state,
      required BuildContext context,
      required ProductResourceManagementBloc blocProvider,
      required double screenWidth}) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) =>
            productProcessRoute.processRouteId.toString().trim() ==
                    state.processRouteId
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.errorContainer),
      ),
      onPressed: () async {
        StreamController<List<ProductionInstructionsWithDocuments>>
            uploadedFilesList =
            StreamController<List<ProductionInstructionsWithDocuments>>();
        StreamController<Map<String, dynamic>> pickedFileData =
            StreamController<Map<String, dynamic>>.broadcast();
        List<ProductionInstructionsWithDocuments> documentsList =
            await ProductRepository()
                .instructionsWithDocuments(token: state.token, payload: {
          'processroute_id': productProcessRoute.processRouteId,
          'sequence': productProcessRoute.processRouteSeq
        });
        blocProvider.add(UploadMachineProgramEvent(
          productId: state.productId,
          productRevision: state.productRevision,
          processRouteId: productProcessRoute.processRouteId.toString(),
        ));

        if (documentsList.isNotEmpty) {
          documentsList.insert(
              0, ProductionInstructionsWithDocuments(id: 'DE_123'));
          uploadedFilesList.add(documentsList);
        }
        Future.delayed(const Duration(milliseconds: 500), () {
          uploadMachineProgramsDialog(
              context: context,
              documentsList: documentsList,
              screenWidth: screenWidth,
              uploadedFilesList: uploadedFilesList,
              productProcessRoute: productProcessRoute,
              pickedFileData: pickedFileData,
              state: state);
        });
        // }
      },
      child: Text(
        'Upload programs',
        style: TextStyle(
            color: productProcessRoute.processRouteId.toString().trim() ==
                    state.processRouteId
                ? AppColors.whiteTheme
                : Theme.of(context).colorScheme.error),
      ),
    );
  }

  Future<dynamic> uploadMachineProgramsDialog(
      {required BuildContext context,
      required List<ProductionInstructionsWithDocuments> documentsList,
      required double screenWidth,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          uploadedFilesList,
      required ProductAndProcessRouteModel productProcessRoute,
      required StreamController<Map<String, dynamic>> pickedFileData,
      required UploadMachineProgramState state}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        double rowHeight = 50,
            tableHeight = (documentsList.length + 2) * rowHeight,
            columnWidth = Platform.isAndroid
                ? ((screenWidth - 150) / 3) - rowHeight
                : (screenWidth / 3) - rowHeight;
        return AlertDialog(
          title: Text(
            'Upload Machine programs',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 18),
          ),
          content: StreamBuilder<List<ProductionInstructionsWithDocuments>>(
              stream: uploadedFilesList.stream,
              builder: (context, newsnapshot) {
                if (newsnapshot.data != null) {
                  tableHeight = (newsnapshot.data!.length + 1) * rowHeight;
                }
                return uploadMachineProgramsTable(
                    screenWidth: screenWidth,
                    tableHeight: tableHeight,
                    rowHeight: rowHeight,
                    columnWidth: [130, columnWidth, columnWidth, columnWidth],
                    newsnapshot: newsnapshot,
                    productProcessRoute: productProcessRoute,
                    pickedFileData: pickedFileData,
                    state: state,
                    uploadedFilesList: uploadedFilesList,
                    context: context);
              }),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  SizedBox uploadMachineProgramsTable(
      {required double screenWidth,
      required double tableHeight,
      required double rowHeight,
      required List<double> columnWidth,
      required AsyncSnapshot<List<ProductionInstructionsWithDocuments>>
          newsnapshot,
      required ProductAndProcessRouteModel productProcessRoute,
      required StreamController<Map<String, dynamic>> pickedFileData,
      required UploadMachineProgramState state,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          uploadedFilesList,
      required BuildContext context}) {
    return SizedBox(
      width: screenWidth,
      height: tableHeight,
      child: CustomTable(
          tablewidth: screenWidth,
          tableheight: tableHeight,
          rowHeight: rowHeight,
          showIndex: true,
          tableheaderColor: Theme.of(context).colorScheme.inversePrimary,
          headerStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          tableOutsideBorder: true,
          enableRowBottomBorder: true,
          tableBorderColor: Theme.of(context).primaryColor,
          column: [
            ColumnData(width: columnWidth[0], label: 'Seq. No.'),
            ColumnData(width: columnWidth[1], label: 'Instructions'),
            ColumnData(width: columnWidth[2], label: 'File path'),
            ColumnData(width: columnWidth[3], label: 'Action'),
          ],
          rows: newsnapshot.hasData || newsnapshot.data != null
              ? newsnapshot.data!
                  .map((elements) => RowData(cell: [
                        sequenceWidget(
                            columnWidth: columnWidth[0],
                            sequence: productProcessRoute.combinedSequence
                                .toString()),
                        instructionWidget(
                            columnWidth: columnWidth[1],
                            instruction:
                                productProcessRoute.instruction.toString()),
                        remarkWidget(
                            remark: elements.remark == null
                                ? ''
                                : elements.remark.toString(),
                            columnWidth: columnWidth[2]),
                        elements.id == 'DE_123'
                            ? uploadProgramWidget(
                                columnWidth: columnWidth[3],
                                pickedFileData: pickedFileData,
                                state: state,
                                productProcessRoute: productProcessRoute,
                                uploadedFilesList: uploadedFilesList)
                            : viewAndDeleteProgramFilesFromDb(
                                columnWidth: columnWidth[3],
                                state: state,
                                elements: elements,
                                context: context,
                                uploadedFilesList: uploadedFilesList,
                                productProcessRoute: productProcessRoute)
                      ]))
                  .toList()
              : [
                  RowData(cell: [
                    sequenceWidget(
                        columnWidth: columnWidth[0],
                        sequence:
                            productProcessRoute.combinedSequence.toString()),
                    instructionWidget(
                        columnWidth: columnWidth[1],
                        instruction:
                            productProcessRoute.instruction.toString()),
                    remarkWidget(remark: '', columnWidth: columnWidth[2]),
                    uploadProgramWidget(
                        columnWidth: columnWidth[3],
                        pickedFileData: pickedFileData,
                        state: state,
                        productProcessRoute: productProcessRoute,
                        uploadedFilesList: uploadedFilesList),
                  ])
                ]),
    );
  }

  TableDataCell remarkWidget(
          {required String remark, required double columnWidth}) =>
      TableDataCell(width: columnWidth, label: Text(remark));

  TableDataCell viewAndDeleteProgramFilesFromDb(
      {required double columnWidth,
      required UploadMachineProgramState state,
      required ProductionInstructionsWithDocuments elements,
      required BuildContext context,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          uploadedFilesList,
      required ProductAndProcessRouteModel productProcessRoute}) {
    return TableDataCell(
        width: columnWidth,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  final docData = await DocumentsRepository()
                      .documents(state.token, elements.mdocId.toString());
                  if (docData != null) {
                    String filePath =
                        elements.remark.toString().replaceAll(r'\', '/');
                    String fileName = path.basename(filePath);
                    String fileExtension =
                        path.extension(elements.remark.toString());
                    final String dirpath =
                        (await path_provider.getApplicationSupportDirectory())
                            .path;
                    final String vertualfilename =
                        '$dirpath/$fileName.$fileExtension';
                    final File file = File(vertualfilename);
                    final data = base64.decode(docData);
                    await file.writeAsBytes(data, flush: true);
                    String content = await file.readAsString();
                    if (Platform.isAndroid) {
                      QuickFixUi().readTextFile(
                          context: context,
                          content: content,
                          filename: fileName);
                    } else {
                      Documents().models(
                          docData,
                          '',
                          elements.remark.toString(),
                          fileExtension.substring(1));
                    }
                  }
                },
                child: const Text('View')),
            IconButton(
                onPressed: () {
                  deleteMachineProgramConfirmationWidget(
                      context: context,
                      state: state,
                      elements: elements,
                      productProcessRoute: productProcessRoute,
                      uploadedFilesList: uploadedFilesList);
                },
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: Theme.of(context).colorScheme.error,
                ))
          ],
        ));
  }

  Future<dynamic> deleteMachineProgramConfirmationWidget(
      {required BuildContext context,
      required UploadMachineProgramState state,
      required ProductionInstructionsWithDocuments elements,
      required ProductAndProcessRouteModel productProcessRoute,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          uploadedFilesList}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text('Do you want to delete it permanently?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
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
                    'postgresql_id': elements.id.toString(),
                    'mongodb_id': elements.mdocId.toString()
                  });
                  if (response == 'Deleted successfully') {
                    List<ProductionInstructionsWithDocuments> documentsList =
                        await ProductRepository().instructionsWithDocuments(
                            token: state.token,
                            payload: {
                          'processroute_id': productProcessRoute.processRouteId,
                          'sequence': productProcessRoute.processRouteSeq
                        });
                    documentsList.insert(
                        0, ProductionInstructionsWithDocuments(id: 'DE_123'));
                    if (documentsList.isNotEmpty) {
                      uploadedFilesList.add(documentsList);
                    }
                    Navigator.of(context).pop();
                    QuickFixUi().showCustomDialog(
                        context: context,
                        errorMessage: 'Program file deleted successfully.');
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

  TableDataCell uploadProgramWidget(
      {required double columnWidth,
      required StreamController<Map<String, dynamic>> pickedFileData,
      required UploadMachineProgramState state,
      required ProductAndProcessRouteModel productProcessRoute,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          uploadedFilesList}) {
    return TableDataCell(
        width: columnWidth,
        label: StreamBuilder<Map<String, dynamic>>(
            stream: pickedFileData.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  (snapshot.data != null && snapshot.data!.isNotEmpty)) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    openProgramFile(
                        filePath: snapshot.data!['filepath'], context: context),
                    deleteProgramFile(
                        filePath: snapshot.data!['filepath'],
                        pickedFileData: pickedFileData,
                        context: context),
                    uploadProgramFileButton(
                        snapshot: snapshot,
                        state: state,
                        productProcessRoute: productProcessRoute,
                        pickedFileData: pickedFileData,
                        context: context,
                        uploadedFilesList: uploadedFilesList)
                  ],
                );
              } else {
                return pickAndSaveFile(
                    pickedFileData: pickedFileData, context: context);
              }
            }));
  }

  ElevatedButton uploadProgramFileButton(
      {required AsyncSnapshot<Map<String, dynamic>> snapshot,
      required UploadMachineProgramState state,
      required ProductAndProcessRouteModel productProcessRoute,
      required StreamController<Map<String, dynamic>> pickedFileData,
      required BuildContext context,
      required StreamController<List<ProductionInstructionsWithDocuments>>
          uploadedFilesList}) {
    return ElevatedButton.icon(
        onPressed: () async {
          File file = File(snapshot.data!['filepath']);
          if (await file.exists()) {
            List<int> fileBytes = await file.readAsBytes();
            String programFileData = base64Encode(fileBytes);
            String response = await ProductRepository()
                .uploadMachinePrograms(token: state.token, payload: {
              'createdby': state.userId,
              'pd_product_id': state.productId,
              'revision_number': state.productRevision,
              'workstation_id': productProcessRoute.workstationId,
              'workcenter_id': productProcessRoute.workcentreId,
              'process_route_id': productProcessRoute.processRouteId,
              'process_seq': productProcessRoute.processRouteSeq,
              'remark': snapshot.data!['remark'],
              'imagetype_code': snapshot.data!['extension'],
              'data': programFileData
            });
            if (response == 'File uploaded successfully.') {
              await file.delete();
              pickedFileData.add({});
              List<ProductionInstructionsWithDocuments> documentsList =
                  await ProductRepository()
                      .instructionsWithDocuments(token: state.token, payload: {
                'processroute_id': productProcessRoute.processRouteId,
                'sequence': productProcessRoute.processRouteSeq
              });
              documentsList.insert(
                  0, ProductionInstructionsWithDocuments(id: 'DE_123'));
              if (documentsList.isNotEmpty) {
                debugPrint(documentsList.toString());
                uploadedFilesList.add(documentsList);
              }
              QuickFixUi()
                  .showCustomDialog(context: context, errorMessage: response);
            } else {
              QuickFixUi()
                  .showCustomDialog(context: context, errorMessage: response);
              await file.delete();
              pickedFileData.add({});
            }
          } else {
            QuickFixUi().showCustomDialog(
                context: context, errorMessage: 'Program file not found');
          }
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload'));
  }

  TableDataCell runtimeMinutesWidget(
      {required List<double> productRouteColumnWidth,
      required String runtimemins}) {
    return TableDataCell(
        width: productRouteColumnWidth[5], label: Text(runtimemins));
  }

  TableDataCell setupMinWidget(
      {required List<double> productRouteColumnWidth,
      required String setuptimemins}) {
    return TableDataCell(
        width: productRouteColumnWidth[4], label: Text(setuptimemins));
  }

  TableDataCell instructionWidget(
      {required double columnWidth, required String instruction}) {
    return TableDataCell(
        width: columnWidth,
        label: Padding(
          padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
          child: Text(instruction),
        ));
  }

  TableDataCell workstationWidget(
      {required List<double> productRouteColumnWidth,
      required String workstation}) {
    return TableDataCell(
        width: productRouteColumnWidth[2], label: Text(workstation));
  }

  TableDataCell workcentreWidget(
      {required List<double> productRouteColumnWidth,
      required String workcentre}) {
    return TableDataCell(
        width: productRouteColumnWidth[1], label: Text(workcentre));
  }

  TableDataCell sequenceWidget(
      {required double columnWidth, required String sequence}) {
    return TableDataCell(width: columnWidth, label: Text(sequence));
  }

  ElevatedButton openProgramFile(
      {required String filePath, required BuildContext context}) {
    return ElevatedButton(
        onPressed: () async {
          File file = File(filePath);
          if (await file.exists()) {
            try {
              String content = await file.readAsString();
              if (Platform.isAndroid) {
                String newFilename = path.basename(filePath);
                return QuickFixUi().readTextFile(
                    context: context, content: content, filename: newFilename);
              } else {
                await OpenFile.open(filePath);
              }
            } catch (e) {
              QuickFixUi().showCustomDialog(
                  context: context, errorMessage: 'Unable to open file.');
            }
          } else {
            QuickFixUi().showCustomDialog(
                context: context, errorMessage: 'File not found.');
          }
        },
        child: const Text('View'));
  }

  IconButton deleteProgramFile(
      {required String filePath,
      required StreamController<Map<String, dynamic>> pickedFileData,
      required BuildContext context}) {
    return IconButton(
        onPressed: () async {
          File file = File(filePath);
          if (await file.exists()) {
            try {
              pickedFileData.add({});
              await file.delete();
              QuickFixUi().showCustomDialog(
                  context: context, errorMessage: 'File deleted successfully.');
            } catch (e) {
              debugPrint(e.toString());
              QuickFixUi().showCustomDialog(
                  context: context, errorMessage: 'Unable to open file.');
            }
          } else {
            QuickFixUi().showCustomDialog(
                context: context, errorMessage: 'File not found.');
          }
        },
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
        ));
  }

  IconButton pickAndSaveFile(
      {required StreamController<Map<String, dynamic>> pickedFileData,
      required BuildContext context}) {
    return IconButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            PlatformFile file = result.files.first;
            String fileName = path.basename(file.path!);
            Directory appDir = await getApplicationDocumentsDirectory();
            String filePath = path.join(appDir.path, fileName);

            File pickedFile = File(file.path!);
            await pickedFile.copy(filePath);

            pickedFileData.add({
              'filepath': filePath,
              'remark': filePath.replaceAll(r'\\', '/'),
              'extension': path.extension(filePath),
            });
          }
        },
        icon: Icon(
          size: 35,
          Icons.file_open,
          color: Theme.of(context).primaryColor,
        ));
  }

  Center masterProductDataTableWidget({
    required double screenWidth,
    required List<double> masterColumnWidth,
    required ProductResourceManagementBloc blocProvider,
  }) {
    return Center(child: BlocBuilder<ProductResourceManagementBloc,
        ProductResourceManagementState>(
      builder: (context, state) {
        if (state is UploadMachineProgramState &&
            state.productData.isNotEmpty) {
          double rowHeight = 60,
              masterTableHeight =
                  (state.productData.length + 1) * (rowHeight + .5);
          return Container(
            width: screenWidth,
            height: masterTableHeight,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: CustomTable(
                tablewidth: screenWidth,
                tableheight: masterTableHeight,
                showIndex: true,
                rowHeight: rowHeight,
                enableRowBottomBorder: true,
                tableOutsideBorder: true,
                tableheaderColor: Theme.of(context).primaryColorLight,
                headerStyle: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
                tableBorderColor: Theme.of(context).primaryColorDark,
                column: [
                  ColumnData(width: masterColumnWidth[0], label: 'Product'),
                  ColumnData(
                      width: masterColumnWidth[1], label: 'Revision Number'),
                  ColumnData(width: masterColumnWidth[2], label: 'Description'),
                  ColumnData(width: masterColumnWidth[3], label: 'Action'),
                ],
                rows: state.productData
                    .map((e) => RowData(cell: [
                          TableDataCell(
                              width: masterColumnWidth[0],
                              label: Text(e.code.toString().trim())),
                          TableDataCell(
                              width: masterColumnWidth[1],
                              label: Text(e.revisionnumber.toString())),
                          TableDataCell(
                              width: masterColumnWidth[2],
                              label: Text(e.description.toString())),
                          TableDataCell(
                              width: masterColumnWidth[3],
                              label: Center(
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateColor
                                            .resolveWith((states) => e
                                                            .revisionnumber
                                                            .toString()
                                                            .trim() ==
                                                        state.productRevision &&
                                                    e.revisionnumber
                                                            .toString()
                                                            .trim() !=
                                                        ''
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : Theme.of(context)
                                                    .primaryColorLight),
                                      ),
                                      onPressed: () {
                                        blocProvider.add(
                                            UploadMachineProgramEvent(
                                                productId: state.productId,
                                                productRevision: e
                                                    .revisionnumber
                                                    .toString()
                                                    .trim()));
                                      },
                                      child: Text(
                                        'Machine Programs',
                                        style: TextStyle(
                                            color: e.revisionnumber
                                                            .toString()
                                                            .trim() ==
                                                        state.productRevision &&
                                                    e.revisionnumber
                                                            .toString()
                                                            .trim() !=
                                                        ''
                                                ? AppColors.whiteTheme
                                                : Theme.of(context)
                                                    .primaryColorDark),
                                      )),
                                ),
                              )),
                        ]))
                    .toList()),
          );
        } else if (state is UploadMachineProgramState &&
            state.productId != '') {
          return const Center(
              child: Text(
            'Product data not found',
            style: TextStyle(
                color: AppColors.redTheme, fontWeight: FontWeight.bold),
          ));
        } else {
          return const Stack();
        }
      },
    ));
  }
}
