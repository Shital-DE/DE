// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Quality dashboard
//Modified Date :  4 April 2023
// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../../bloc/dashboard/dashboard_event.dart';
import '../../../bloc/documents/documents_bloc.dart';
import '../../../bloc/documents/documents_event.dart';
import '../../../bloc/documents/documents_state.dart';
import '../../../services/model/common/document_model.dart';
import '../../../services/repository/common/documents_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../widgets/appbar.dart';
import '../../widgets/table/custom_table.dart';
import 'product.dart';

class AllDocuments extends StatelessWidget {
  const AllDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<DocumentsBloc>(context);
    final dashblocProvider = BlocProvider.of<DashboardBloc>(context);
    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: 'Documents'),
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          productSearch(dashblocProvider, blocProvider),
          BlocBuilder<DocumentsBloc, DocumentsState>(
            builder: (context, state) {
              if (state is DocumentsLoadingState &&
                  state.documentData.isNotEmpty) {
                double tableHeight =
                    double.parse((state.documentData.length + 1).toString());
                return Container(
                  height: (state.documentData.length + 1) * 50,
                  width: 260 * 5,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: QuickFixUi()
                      .borderContainer(borderThickness: 1.5, radius: 0),
                  child: CustomTable(
                      tablewidth: 260 * 5,
                      tableheight: tableHeight * 50,
                      columnWidth: 260,
                      rowHeight: 50,
                      enableRowBottomBorder: true,
                      enableHeaderBottomBorder: true,
                      headerBorderThickness: 0.5,
                      headerBorderColor: AppColors.blackColor,
                      headerHeight: 50,
                      tableheaderColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      tablebodyColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      headerStyle: const TextStyle(
                          color: AppColors.appTheme,
                          fontWeight: FontWeight.bold),
                      column: [
                        ColumnData(label: 'Product'),
                        ColumnData(label: 'Description'),
                        ColumnData(label: 'PDF version'),
                        ColumnData(label: '3D model version'),
                        ColumnData(label: 'Action'),
                      ],
                      rows: state.documentData
                          .map((e) => RowData(cell: [
                                TableDataCell(
                                    label: Text(
                                  e.productCode.toString().trim(),
                                  textAlign: TextAlign.center,
                                )),
                                TableDataCell(
                                    label: Text(
                                  e.productDescription.toString().trim(),
                                  textAlign: TextAlign.center,
                                )),
                                TableDataCell(
                                    label: Text(
                                  e.pdfRevisionNumber != null
                                      ? e.pdfRevisionNumber.toString().trim()
                                      : 'NA',
                                  style: e.pdfRevisionNumber != null
                                      ? const TextStyle()
                                      : const TextStyle(
                                          color: AppColors.redTheme,
                                          fontWeight: FontWeight.bold),
                                )),
                                TableDataCell(
                                    label: Text(
                                  e.modelRevisionNumber != null
                                      ? e.modelRevisionNumber.toString().trim()
                                      : 'NA',
                                  style: e.modelRevisionNumber != null
                                      ? const TextStyle()
                                      : const TextStyle(
                                          color: AppColors.redTheme,
                                          fontWeight: FontWeight.bold),
                                )),
                                TableDataCell(
                                    label: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    e.pdfMdocId.toString() != ''
                                        ? FilledButton(
                                            child: const Text('PDF'),
                                            onPressed: () async {
                                              if (e.pdfImageType.toString() ==
                                                  'pdf') {
                                                final docData =
                                                    await DocumentsRepository()
                                                        .documents(
                                                            state.token,
                                                            e.pdfMdocId
                                                                .toString());
                                                if (Platform.isAndroid) {
                                                  Documents().pdf(
                                                      context,
                                                      docData,
                                                      e.productCode.toString(),
                                                      e.productDescription
                                                          .toString(),
                                                      e.pdfRevisionNumber
                                                          .toString());
                                                } else {
                                                  Documents().models(
                                                      docData,
                                                      e.productCode.toString(),
                                                      e.productDescription
                                                          .toString(),
                                                      e.pdfImageType
                                                          .toString());
                                                }
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Alert',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .redTheme,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: const SizedBox(
                                                        width: 200,
                                                        height: 20,
                                                        child: Center(
                                                          child: Text(
                                                              'Document not is in PDF format'),
                                                        ),
                                                      ),
                                                      actions: [
                                                        Center(
                                                          child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Container(
                                                                width: 70,
                                                                height: 35,
                                                                color: AppColors
                                                                    .blueColor,
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          )
                                        : const SizedBox(
                                            width: 70,
                                            height: 30,
                                            child: Center(
                                              child: Text(
                                                'NA',
                                                style: TextStyle(
                                                    color: AppColors.redTheme,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    e.modelMdocId != null
                                        ? ElevatedButton(
                                            child: const Text('3D Models'),
                                            onPressed: () async {
                                              final docData =
                                                  await DocumentsRepository()
                                                      .documents(
                                                          state.token,
                                                          e.modelMdocId
                                                              .toString());
                                              Documents().models(
                                                  docData,
                                                  e.productCode.toString(),
                                                  e.productDescription
                                                      .toString(),
                                                  e.modelImageType.toString());
                                            },
                                          )
                                        : const SizedBox(
                                            width: 70,
                                            height: 30,
                                            child: Center(
                                              child: Text(
                                                'NA',
                                                style: TextStyle(
                                                    color: AppColors.redTheme,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                  ],
                                )),
                              ]))
                          .toList()),
                );
              } else if (state is DocumentsLoadingState &&
                  state.documentData.isEmpty &&
                  state.productid != '' &&
                  state.productid != 'NULL') {
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Documents are not available for this product',
                    style: TextStyle(color: AppColors.redTheme),
                  ),
                );
              } else if (state is DocumentsLoadingState &&
                  state.productid == 'NULL') {
                return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ));
              } else {
                return const Stack();
              }
            },
          )
        ])),
      ),
    );
  }

  Container productSearch(
      DashboardBloc dashblocProvider, DocumentsBloc blocProvider) {
    return Container(
        width: 300,
        height: 60,
        margin: const EdgeInsets.all(10),
        child: ProductSearch(
          onTap: () {
            dashblocProvider.add(DashboardMenuEvent(
              selectedIndex: 2,
            ));
            blocProvider.add(DocumentData(productid: 'NULL'));
          },
          onChanged: (value) {
            dashblocProvider.add(DashboardMenuEvent(selectedIndex: 2));
            blocProvider.add(DocumentData(productid: value!.id.toString()));
          },
        ));
  }
}

class Documents {
  Widget documentsButtons(
      {required BuildContext context,
      required Alignment alignment,
      required double topMargin,
      required String token,
      required String pdfMdocId,
      required String product,
      required String productDescription,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelimageType}) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 400,
        height: 60,
        margin: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (pdfMdocId != '')
              ElevatedButton(
                  child: const Text('PDF'),
                  onPressed: () async {
                    final docData =
                        await DocumentsRepository().documents(token, pdfMdocId);
                    pdf(context, docData, product, productDescription,
                        pdfRevisionNo);
                  }),
            if (modelMdocId != '')
              ElevatedButton(
                  child: const Text('3D Model'),
                  onPressed: () async {
                    final docData = await DocumentsRepository()
                        .documents(token, modelMdocId);
                    models(
                        docData, product, productDescription, modelimageType);
                  })
          ],
        ),
      ),
    );
  }

  Widget horizontalVersions(
      {required BuildContext context,
      required double topMargin,
      required String pdfMdocId,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelRevisionNo,
      required List<DocumentDetails> modelsDetails,
      required List<DocumentDetails> pdfDetails,
      required String modelimageType,
      required String product,
      required String productDescription,
      required String token}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            versionAlert(
                modelMdocId: modelMdocId,
                modelRevisionNo: modelRevisionNo,
                pdfMdocId: pdfMdocId,
                pdfRevisionNo: pdfRevisionNo),
            pdfDetails.isEmpty && modelsDetails.isEmpty
                ? const Text('')
                : viewButton(
                    context: context,
                    modelsDetails: modelsDetails,
                    pdfDetails: pdfDetails,
                    imageType: modelimageType,
                    product: product,
                    productDescription: productDescription,
                    token: token)
          ],
        ),
      ),
    );
  }

  Widget verticalVersions(
      {required BuildContext context,
      required double topMargin,
      required String pdfMdocId,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelRevisionNo,
      required List<DocumentDetails> modelsDetails,
      required List<DocumentDetails> pdfDetails,
      required String modelimageType,
      required String product,
      required String productDescription,
      required String token}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: topMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            versionAlert(
                modelMdocId: modelMdocId,
                modelRevisionNo: modelRevisionNo,
                pdfMdocId: pdfMdocId,
                pdfRevisionNo: pdfRevisionNo),
            pdfDetails.isNotEmpty && modelsDetails.isNotEmpty
                ? viewButton(
                    context: context,
                    modelsDetails: modelsDetails,
                    pdfDetails: pdfDetails,
                    imageType: modelimageType,
                    product: product,
                    productDescription: productDescription,
                    token: token)
                : const Text('')
          ],
        ),
      ),
    );
  }

  Widget versionAlert(
      {required String pdfMdocId,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelRevisionNo}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Latest versions = PDF version : ',
          style: TextStyle(
              fontSize: 17,
              color: AppColors.greenTheme,
              fontWeight: FontWeight.bold),
        ),
        Text(
          pdfMdocId != '' ? pdfRevisionNo : 'Pdf not available ',
          style: TextStyle(
              fontSize: 17,
              color:
                  pdfMdocId != '' ? AppColors.greenTheme : AppColors.redTheme,
              fontWeight: FontWeight.bold),
        ),
        const Text(
          ', 3D model version : ',
          style: TextStyle(
              fontSize: 17,
              color: AppColors.greenTheme,
              fontWeight: FontWeight.bold),
        ),
        Text(
          modelMdocId != '' ? modelRevisionNo : '3D model not available ',
          style: TextStyle(
              fontSize: 17,
              color:
                  modelMdocId != '' ? AppColors.greenTheme : AppColors.redTheme,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget viewButton(
      {required BuildContext context,
      required List<DocumentDetails> pdfDetails,
      required List<DocumentDetails> modelsDetails,
      required String product,
      required String token,
      required String productDescription,
      required String imageType}) {
    return TextButton(
        onPressed: () {
          Documents().viewDocumentsVersionwise(context, pdfDetails,
              modelsDetails, product, token, productDescription, imageType);
        },
        child: const Text('Available versions'));
  }

  pdf(BuildContext context, String docData, String product, String description,
      String version) {
    try {
      int? currentPage = 0;
      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Text('Product : ${product.trim()}'),
              const SizedBox(width: 50),
              Text('Product Description : ${description.trim()}'),
              const SizedBox(width: 50),
              Text('Version ${version.trim()}')
            ],
          ),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
              width: 1100,
              height: 600,
              child: PDFView(
                pdfData: base64.decode(docData),
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: true,
                pageSnap: true,
                defaultPage: currentPage,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: false,
                onRender: (pages) {
                  pages = pages;
                },
                onError: (error) {
                  //
                },
                onPageError: (page, error) {},
                onLinkHandler: (String? uri) {},
                onPageChanged: (int? page, int? total) {
                  //
                  currentPage = page;
                },
              )),
        ),
        actions: [
          cancelButton,
        ],
      );

      if (docData.toString() == 'Something went wrong') {
        QuickFixUi.errorMessage('Server has some error', context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    } catch (e) {
      QuickFixUi.errorMessage('Document is not in PDF format', context);
    }
  }

  Future models(String docData, String product, String description,
      String extension) async {
    try {
      final data = base64.decode(docData);
      //
      final String path =
          (await path_provider.getApplicationSupportDirectory()).path;
      final String fileName = Platform.isWindows
          ? '$path/${product.toString().trim()}.${extension.toString().trim()}'
          : '$path/${product.toString().trim()}.${extension.toString().trim()}';
      final File file = File(fileName);
      await file.writeAsBytes(data, flush: true);

      open_file.OpenFile.open(fileName);
    } catch (e) {
      //
    }
  }

  viewDocumentsVersionwise(
      BuildContext context,
      List<DocumentDetails> pdfDetails,
      List<DocumentDetails> modelsDetails,
      String product,
      String token,
      String description,
      String imageType) {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: SizedBox(
        width: 300,
        child: Text('Product : $product'),
      ),
      content: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          children: [
            Container(
              color: AppColors.blueColor,
              height: 60,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      'PDF versions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteTheme),
                    ),
                  ),
                  Center(
                    child: Text(
                      '3D model versions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteTheme),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  height: 180,
                  child: ListView.builder(
                    itemCount: pdfDetails.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: TextButton(
                            onPressed: () async {
                              final docData = await DocumentsRepository()
                                  .documents(token,
                                      pdfDetails[index].mdocId.toString());
                              Documents().pdf(
                                  context,
                                  docData,
                                  product,
                                  description,
                                  pdfDetails[index].revisionNumber.toString());
                            },
                            child: Text(
                              pdfDetails[index].revisionNumber.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            )),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 180,
                  child: ListView.builder(
                    itemCount: modelsDetails.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: TextButton(
                            onPressed: () async {
                              final docData = await DocumentsRepository()
                                  .documents(token,
                                      modelsDetails[index].mdocId.toString());
                              Documents().models(
                                  docData, product, description, imageType);
                            },
                            child: Text(
                              modelsDetails[index].revisionNumber.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
