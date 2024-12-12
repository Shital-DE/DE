// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Quality dashboard
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/quality/quality_dashboard_bloc.dart';
import '../../../../bloc/production/quality/quality_dashboard_event.dart';
import '../../../../bloc/production/quality/quality_dashboard_state.dart';
import '../../../../services/model/machine/workcentre.dart';
import '../../../../services/model/operator/oprator_models.dart';
import '../../../../services/model/quality/quality_models.dart';
import '../../../../services/repository/product/product_machine_route_repository.dart';
import '../../../../services/repository/quality/quality_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/barcode_session.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';

class QualityDashboard extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const QualityDashboard({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    final blocProvider = BlocProvider.of<QualityBloc>(context);
    blocProvider.add(QualityDashboardEvents(barcode: barcode!));
    TextEditingController remarkController = TextEditingController();
    return MakeMeResponsiveScreen(
        horixontaltab: productInspect(
            context: context,
            barcode: barcode,
            blocProvider: blocProvider,
            remarkController: remarkController),
        verticaltab: QuickFixUi.notVisible(),
        windows: QuickFixUi.notVisible(),
        linux: QuickFixUi.notVisible(),
        mobile: QuickFixUi.notVisible());
  }

  Scaffold productInspect(
      {required BuildContext context,
      required Barcode barcode,
      required QualityBloc blocProvider,
      required TextEditingController remarkController}) {
    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Product inspection screen'),
      body: BlocConsumer<QualityBloc, QualityState>(
        listener: (context, state) {
          if (state is QualityErrorState) {
            productAlreadyInspected(context: context, state: state);
          }
        },
        builder: (context, state) {
          if (state is QualityDashboardState) {
            return ListView(children: [
              BarcodeSession().barcodeData(
                  context: context, parentWidth: 1280, barcode: barcode),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  productInspectionStatus(
                      barcode: barcode, context: context, state: state),
                  QuickFixUi.horizontalSpace(width: 10),
                ],
              ),
              startInspection(blocProvider: blocProvider),
              QuickFixUi.verticalSpace(height: 20),
              documents(),
              documentsVersions(),
              QuickFixUi.verticalSpace(height: 10),
              productInspectionReport(
                  context: context,
                  blocProvider: blocProvider,
                  remarkController: remarkController)
            ]);
          } else {
            return const Stack();
          }
        },
      ),
    );
  }

  SizedBox productInspectionStatus(
      {required Barcode barcode,
      required BuildContext context,
      required QualityDashboardState state}) {
    return SizedBox(
      width: 200,
      height: 40,
      child: FloatingActionButton.extended(
        heroTag: 'inspection_status',
        onPressed: () async {
          List<QualityProductStatus> inspectionStatus =
              await QualityInspectionRepository().qualityStatus(payload: {
            'product_id': barcode.productid,
            'rms_issue_id': barcode.rawmaterialissueid,
            'workcentre_id': state.workcentre,
            'revision_number': barcode.revisionnumber
          });
          if (inspectionStatus.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  double columnWidth = 119;
                  double tableWidth = columnWidth * 10;
                  double tableHeight = (inspectionStatus.length + 1) * 50;

                  return AlertDialog(
                    title: Text(
                      'Product inspection status',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    content: SizedBox(
                      width: tableWidth,
                      height: tableHeight,
                      child: CustomTable(
                          tablewidth: tableWidth,
                          tableheight: tableHeight,
                          showIndex: true,
                          columnWidth: columnWidth - 5,
                          rowHeight: 50,
                          tableheaderColor:
                              Theme.of(context).colorScheme.errorContainer,
                          headerStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor),
                          tableOutsideBorder: true,
                          column: [
                            ColumnData(label: 'Product'),
                            ColumnData(label: 'PO No.'),
                            ColumnData(label: 'Line No.'),
                            ColumnData(label: '   PO \nquantity'),
                            ColumnData(label: 'Produced \nquantity'),
                            ColumnData(label: 'Rework \nquantity'),
                            ColumnData(label: 'Rejected \nquantity'),
                            ColumnData(label: 'Start time'),
                            ColumnData(label: 'End time'),
                            ColumnData(label: 'Inspector'),
                          ],
                          rows: inspectionStatus.map((e) {
                            DateTime startTime =
                                DateTime.parse(e.startprocesstime.toString());
                            DateTime endTime = e.endprocesstime != null
                                ? DateTime.parse(e.endprocesstime.toString())
                                : DateTime.now();
                            return RowData(cell: [
                              TableDataCell(
                                  label: Text(
                                e.part.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.po.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.lineitemnumber.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.issueQty.toString(),
                              )),
                              TableDataCell(
                                  label: Text(
                                e.okQty.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.reworkqty.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.rejectedQty.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Column(
                                children: [
                                  Text(
                                    startTime
                                        .toLocal()
                                        .toString()
                                        .substring(0, 10),
                                  ),
                                  Text(
                                    startTime
                                        .toLocal()
                                        .toString()
                                        .substring(11, 19),
                                  ),
                                ],
                              )),
                              TableDataCell(
                                  label: e.endprocesstime != null
                                      ? Column(
                                          children: [
                                            Text(
                                              endTime
                                                  .toLocal()
                                                  .toString()
                                                  .substring(0, 10),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              endTime
                                                  .toLocal()
                                                  .toString()
                                                  .substring(11, 19),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      : const Text('')),
                              TableDataCell(
                                  label: Text(
                                e.employeename.toString(),
                                textAlign: TextAlign.center,
                              )),
                            ]);
                          }).toList()),
                    ),
                    actions: [
                      FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'))
                    ],
                  );
                },
              );
            });
          } else {
            QuickFixUi().showCustomDialog(
                context: context,
                errorMessage: 'This product is not inspected yet');
          }
        },
        label: const Text('Status'),
        icon: const Icon(Icons.stacked_bar_chart),
      ),
    );
  }

  Future<dynamic> productAlreadyInspected(
      {required BuildContext context, required QualityErrorState state}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            state.errorMessage,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          )),
          actions: [
            Center(
              child: FilledButton(
                  onPressed: () {
                    for (int i = 0; i < 2; i++) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('OK')),
            )
          ],
        );
      },
    );
  }

  Container productInspectionReport(
      {required BuildContext context,
      required QualityBloc blocProvider,
      required TextEditingController remarkController}) {
    TextEditingController okQty = TextEditingController();
    TextEditingController shortQty = TextEditingController();
    StreamController<String> reworkQty = StreamController<String>.broadcast();
    TextEditingController selectedWorkcentre = TextEditingController();
    StreamController<String> rejectedQty = StreamController<String>.broadcast();
    TextEditingController rejectedReasonsController = TextEditingController();
    double conWidth = 350;
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        children: [
          QuickFixUi.verticalSpace(height: 30),
          SizedBox(
            width: conWidth + 135,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                okQuantity(conWidth: conWidth, okQty: okQty),
                QuickFixUi.horizontalSpace(width: 10),
                remark(remarkController: remarkController, context: context),
              ],
            ),
          ),
          QuickFixUi.verticalSpace(height: 10),
          shortQuantity(conWidth: conWidth, shortQty: shortQty),
          QuickFixUi.verticalSpace(height: 10),
          reworkQuantity(conWidth: conWidth, reworkQty: reworkQty),
          StreamBuilder(
            stream: reworkQty.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return QuickFixUi.verticalSpace(height: 10);
              } else {
                return const Stack();
              }
            },
          ),
          workcentre(
              conWidth: conWidth,
              reworkQty: reworkQty,
              selectedWorkcentre: selectedWorkcentre),
          QuickFixUi.verticalSpace(height: 10),
          rejectedQuantity(conWidth: conWidth, rejectedQty: rejectedQty),
          StreamBuilder(
            stream: rejectedQty.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return QuickFixUi.verticalSpace(height: 10);
              } else {
                return const Stack();
              }
            },
          ),
          rejectedReasons(
              conWidth: conWidth,
              rejectedQty: rejectedQty,
              rejectedReasonsController: rejectedReasonsController),
          QuickFixUi.verticalSpace(height: 30),
          endInspectionButton(
              remarkController: remarkController,
              okQty: okQty,
              shortQty: shortQty,
              reworkQty: reworkQty,
              selectedWorkcentre: selectedWorkcentre,
              rejectedQty: rejectedQty,
              rejectedReasonsController: rejectedReasonsController),
          QuickFixUi.verticalSpace(height: 30),
        ],
      ),
    );
  }

  BlocBuilder<QualityBloc, QualityState> endInspectionButton(
      {required TextEditingController remarkController,
      required TextEditingController okQty,
      required TextEditingController shortQty,
      required StreamController<String> reworkQty,
      required TextEditingController selectedWorkcentre,
      required StreamController<String> rejectedQty,
      required TextEditingController rejectedReasonsController}) {
    return BlocBuilder<QualityBloc, QualityState>(
      builder: (context, state) {
        if (state is QualityDashboardState) {
          return SizedBox(
              width: 300,
              height: 45,
              child: StreamBuilder<String>(
                  stream: reworkQty.stream,
                  builder: (context, reworkQuantity) {
                    return StreamBuilder<Object>(
                        stream: rejectedQty.stream,
                        builder: (context, rejectedQuantity) {
                          return FilledButton(
                              onPressed: () {
                                if (state.startInspection == '') {
                                  QuickFixUi.errorMessage(
                                      'Start inspection first', context);
                                } else if (okQty.text == '') {
                                  QuickFixUi.errorMessage(
                                      'Ok quantity not found', context);
                                } else if (reworkQuantity.data != null &&
                                    selectedWorkcentre.text == '') {
                                  QuickFixUi.errorMessage(
                                      'Please select workcentre for rework',
                                      context);
                                } else if (rejectedQuantity.data != null &&
                                    rejectedReasonsController.text == '') {
                                  QuickFixUi.errorMessage(
                                      'Please select rejected reason', context);
                                } else {
                                  endInspectionConfirmation(
                                      context: context,
                                      state: state,
                                      remarkController: remarkController,
                                      okQty: okQty,
                                      reworkQty: reworkQuantity.data == null
                                          ? ''
                                          : reworkQuantity.data.toString(),
                                      shortQty: shortQty,
                                      rejectedQuantity: rejectedQuantity.data ==
                                              null
                                          ? ''
                                          : rejectedQuantity.data.toString(),
                                      rejectedResons:
                                          rejectedReasonsController);
                                  reworkQty.close();
                                  selectedWorkcentre.dispose();
                                }
                              },
                              child: const Text(
                                'End Inspection',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ));
                        });
                  }));
        } else {
          return const Stack();
        }
      },
    );
  }

  Future<dynamic> endInspectionConfirmation(
      {required BuildContext context,
      required QualityDashboardState state,
      required TextEditingController remarkController,
      required TextEditingController okQty,
      required TextEditingController shortQty,
      required String reworkQty,
      required String rejectedQuantity,
      required TextEditingController rejectedResons}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: const SizedBox(
            height: 25,
            child: Center(
                child: Text(
              'Are you sure you want to end the inspection?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )),
          ),
          actions: [
            FilledButton(
                onPressed: () async {
                  final response = await QualityInspectionRepository()
                      .endInspection(token: state.token, payload: {
                    'id': state.inspectionId,
                    'ok_quantity': okQty.text,
                    'rework_quantity': reworkQty == '' ? '0' : reworkQty,
                    'rejected_quantity':
                        rejectedQuantity == '' ? '0' : rejectedQuantity,
                    'rejected_reasons': rejectedResons.text,
                    'remark': remarkController.text.toString(),
                  });
                  if (shortQty.text != '') {
                    await QualityInspectionRepository()
                        .shortQuantity(token: state.token, payload: {
                      'product_id': state.barcode.productid.toString(),
                      'rms_issuse_id':
                          state.barcode.rawmaterialissueid.toString(),
                      'issue_quantity': state.barcode.issueQty.toString(),
                      'ok_quantity': okQty.text,
                      'rework_quantity': reworkQty == '' ? '0' : reworkQty,
                      'rejected_quantity':
                          rejectedQuantity == '' ? '0' : rejectedQuantity,
                      'short_quantity': shortQty.text,
                      'employee_id': state.userid,
                      'revision_number':
                          state.barcode.revisionnumber.toString(),
                    });
                  }
                  if (response == 'Product inspected successfully') {
                    okQty.dispose();
                    shortQty.dispose();
                    rejectedResons.dispose();
                    remarkController.dispose();
                    finalEndInspectionConfirmation(
                        context: context, state: state);
                  } else {
                    QuickFixUi().showCustomDialog(
                        context: context, errorMessage: response.toString());
                  }
                },
                child: const Text('Yes')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
          ],
        );
      },
    );
  }

  Future<dynamic> finalEndInspectionConfirmation(
      {required BuildContext context, required QualityDashboardState state}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const SizedBox(
            height: 25,
            child: Center(
                child: Text(
              'Are you sure you want to end the inspection finally?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )),
          ),
          actions: [
            FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                      (states) => Theme.of(context).colorScheme.error),
                ),
                onPressed: () {
                  for (int i = 0; i <= 2; i++) {
                    Navigator.of(context).pop();
                  }
                  QualityInspectionRepository().finalEndInspection(
                      context: context,
                      token: state.token,
                      message: 'Inspection successful.',
                      payload: {
                        'productid': state.barcode.productid,
                        'rmsissueid': state.barcode.rawmaterialissueid,
                        'workcentreid': state.workcentre,
                        'revision_number': state.barcode.revisionnumber
                      });
                },
                child: const Text('Yes')),
            FilledButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                  (states) => AppColors.greenTheme,
                )),
                onPressed: () {
                  for (int i = 0; i <= 2; i++) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('No'))
          ],
        );
      },
    );
  }

  BlocBuilder<QualityBloc, QualityState> rejectedReasons(
      {required double conWidth,
      required StreamController<String> rejectedQty,
      required TextEditingController rejectedReasonsController}) {
    return BlocBuilder<QualityBloc, QualityState>(
      builder: (context, state) {
        if (state is QualityDashboardState) {
          return StreamBuilder<String>(
              stream: rejectedQty.stream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Container(
                      width: conWidth,
                      height: 50,
                      decoration:
                          QuickFixUi().borderContainer(borderThickness: .5),
                      padding: const EdgeInsets.only(left: 20),
                      child: DropdownSearch<QualityRejectedReasons>(
                        items: state.rejectedReasonsList,
                        itemAsString: (item) =>
                            item.qualityrejreasons.toString(),
                        popupProps: const PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps()),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                hintText: "Rejected reasons",
                                border: InputBorder.none)),
                        onChanged: (value) {
                          rejectedReasonsController.text = value!.id.toString();
                        },
                      ));
                } else {
                  return const Stack();
                }
              });
        } else {
          return const Stack();
        }
      },
    );
  }

  Container rejectedQuantity(
      {required double conWidth,
      required StreamController<String> rejectedQty}) {
    return Container(
        width: conWidth,
        decoration: QuickFixUi().borderContainer(borderThickness: .5),
        padding: const EdgeInsets.only(left: 20),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'Rejected quantity'),
          onChanged: (value) {
            rejectedQty.add(value.toString());
          },
        ));
  }

  BlocBuilder<QualityBloc, QualityState> workcentre(
      {required double conWidth,
      required StreamController<String> reworkQty,
      required TextEditingController selectedWorkcentre}) {
    return BlocBuilder<QualityBloc, QualityState>(
      builder: (context, state) {
        if (state is QualityDashboardState) {
          return StreamBuilder<String>(
              stream: reworkQty.stream,
              builder: (context, snapshot) {
                return snapshot.data != null
                    ? Container(
                        width: conWidth,
                        height: 50,
                        decoration:
                            QuickFixUi().borderContainer(borderThickness: .5),
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownSearch<Workcentre>(
                          items: state.workcentrelist,
                          itemAsString: (item) => item.code.toString(),
                          popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps()),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  hintText: "Workcentre",
                                  border: InputBorder.none)),
                          onChanged: (value) {
                            selectedWorkcentre.text = value!.id.toString();
                            QualityInspectionRepository()
                                .changeEndProductionFlag(
                                    token: state.token,
                                    payload: {
                                  'product_id':
                                      state.barcode.productid.toString(),
                                  'rms_issue_id': state
                                      .barcode.rawmaterialissueid
                                      .toString(),
                                  'workcentre_id': value.id.toString(),
                                  'revision_number':
                                      state.barcode.revisionnumber.toString()
                                });
                          },
                        ))
                    : const Stack();
              });
        } else {
          return const Stack();
        }
      },
    );
  }

  Container reworkQuantity(
      {required double conWidth, required StreamController<String> reworkQty}) {
    return Container(
        width: conWidth,
        decoration: QuickFixUi().borderContainer(borderThickness: .5),
        padding: const EdgeInsets.only(left: 20),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'Rework quantity'),
          onChanged: (value) {
            reworkQty.add(value.toString());
          },
        ));
  }

  Container shortQuantity(
      {required double conWidth, required TextEditingController shortQty}) {
    return Container(
        width: conWidth,
        decoration: QuickFixUi().borderContainer(borderThickness: .5),
        padding: const EdgeInsets.only(left: 20),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'Short quantity'),
          onChanged: (value) {
            shortQty.text = value.toString();
          },
        ));
  }

  FloatingActionButton remark(
      {required TextEditingController remarkController,
      required BuildContext context}) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Remark',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              content: Container(
                width: 600,
                decoration: QuickFixUi().borderContainer(borderThickness: .5),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: remarkController,
                  maxLines: 25,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    remarkController.text = value.toString();
                  },
                ),
              ),
              actions: [
                FilledButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Submit')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
              ],
            );
          },
        );
        // }
      },
      child: const Icon(Icons.drive_file_rename_outline_outlined),
    );
  }

  Container okQuantity(
      {required double conWidth, required TextEditingController okQty}) {
    return Container(
        width: conWidth,
        decoration: QuickFixUi().borderContainer(borderThickness: .5),
        padding: const EdgeInsets.only(left: 20),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'OK quantity'),
          onChanged: (value) {
            okQty.text = value.toString();
          },
        ));
  }

  BlocBuilder<QualityBloc, QualityState> documentsVersions() {
    return BlocBuilder<QualityBloc, QualityState>(
      builder: (context, state) {
        if (state is QualityDashboardState) {
          return Documents().horizontalVersions(
              context: context,
              topMargin: 0,
              pdfMdocId: state.pdfMdocId,
              pdfRevisionNo: state.pdfRevisionNo,
              modelMdocId: state.modelMdocId,
              modelRevisionNo: state.modelRevisionNo,
              modelsDetails: state.modelsDetails,
              pdfDetails: state.pdfDetails,
              modelimageType: state.imageType,
              product: state.barcode.product.toString(),
              productDescription: state.productDescription,
              token: state.token);
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<QualityBloc, QualityState> documents() {
    return BlocBuilder<QualityBloc, QualityState>(
      builder: (context, state) {
        if (state is QualityDashboardState) {
          return Documents().documentsButtons(
              context: context,
              alignment: Alignment.center,
              topMargin: 0,
              token: state.token,
              pdfMdocId: state.pdfMdocId,
              product: state.barcode.product.toString(),
              productDescription: state.productDescription,
              pdfRevisionNo: state.pdfRevisionNo,
              modelMdocId: state.modelMdocId,
              modelimageType: state.imageType);
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<QualityBloc, QualityState> startInspection(
      {required QualityBloc blocProvider}) {
    return BlocBuilder<QualityBloc, QualityState>(
      builder: (context, state) {
        if (state is QualityDashboardState) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 400,
                height: 45,
                child: FilledButton(
                    onPressed: () async {
                      if (state.startInspection == '') {
                        String time = await QualityInspectionRepository()
                            .currentDatabaseTime(state.token);
                        QualityInspectionRepository().startInspection(
                          payload: {
                            'product_id': state.barcode.productid.toString(),
                            'rms_issue_id':
                                state.barcode.rawmaterialissueid.toString(),
                            'workcentre_id': state.workcentre,
                            'workstation_id': state.workstation,
                            'employee_id': state.userid,
                            'revision_number':
                                state.barcode.revisionnumber.toString()
                          },
                          token: state.token,
                        );
                        await ProductMachineRoute().registerProductMachineRoute(
                            token: state.token,
                            payload: {
                              'product_id': state.barcode.productid,
                              'product_revision': state.barcode.revisionnumber,
                              'workcentre_id': state.workcentre,
                              'workstation_id': state.workstation
                            });
                        blocProvider.add(QualityDashboardEvents(
                          isInspectionStarted: true,
                          barcode: state.barcode,
                          startInspection: time,
                        ));
                      } else {
                        QuickFixUi.errorMessage(
                            'The inspection is currently underway.', context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith((states) =>
                          state.startInspection != ''
                              ? AppColors.greenTheme
                              : Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      'Start Inspection',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ))),
            QuickFixUi.horizontalSpace(width: 30),
            BlocBuilder<QualityBloc, QualityState>(
              builder: (context, state) {
                if (state is QualityDashboardState) {
                  return Container(
                    width: 400,
                    height: 45,
                    decoration:
                        QuickFixUi().borderContainer(borderThickness: .5),
                    child: Center(
                      child: Text(
                        state.startInspection != ''
                            ? state.startInspection.toString()
                            : '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  );
                } else {
                  return const Stack();
                }
              },
            )
          ]);
        } else {
          return const Stack();
        }
      },
    );
  }
}
