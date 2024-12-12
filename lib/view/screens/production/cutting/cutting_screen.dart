// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Cutting Screen
// Modified date : 28 Sept 2023

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/cutting_bloc/cutting_bloc.dart';
import '../../../../bloc/production/cutting_bloc/cutting_event.dart';
import '../../../../bloc/production/cutting_bloc/cutting_state.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/operator/oprator_models.dart';
import '../../../../services/repository/operator/cutting_repository.dart';
import '../../../../services/repository/product/product_machine_route_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/barcode_session.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';

class CuttingScreen extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const CuttingScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    double parentWidth = MediaQuery.of(context).size.width;
    double parentHeight = MediaQuery.of(context).size.height;
    final blocProvider = BlocProvider.of<CuttingBloc>(context);
    blocProvider.add(CuttingLoadingEvent(arguments['barcode'], '', {}));
    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: 'Cutting screen'),
      body: MakeMeResponsiveScreen(
        horixontaltab: SingleChildScrollView(
          child: Center(
            child: BlocConsumer<CuttingBloc, CuttingState>(
                listener: (context, state) {
              if (state is CuttingLoadingState &&
                  state.productStatus['production_end'] == 1) {
                cuttingFinishedDialog(context: context);
              }
            }, builder: (context, state) {
              if (state is CuttingLoadingState &&
                  state.productStatus['production_end'] == 1) {
                return const Stack();
              } else {
                return Column(
                  children: [
                    BarcodeSession().barcodeData(
                        context: context,
                        parentWidth: parentWidth,
                        barcode: barcode),
                    docButtons(),
                    docHorizontal(),
                    cuttingTable(
                      parentWidth: parentWidth,
                      parentHeight: parentHeight,
                      barcode: barcode,
                      blocProvider: blocProvider,
                      context: context,
                    ),
                    cuttingStatus(parentWidth, parentHeight),
                  ],
                );
              }
            }),
          ),
        ),
        windows: QuickFixUi.notVisible(),
        linux: QuickFixUi.notVisible(),
        mobile: QuickFixUi.notVisible(),
      ),
      // )
    );
  }

  Future<dynamic> cuttingFinishedDialog({required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 30,
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              'Successfully completed the cutting operation.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          actions: [
            Center(
              child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.popAndPushNamed(
                      context,
                      RouteName.dashboard,
                    );
                  },
                  child: const Text('Go back')),
            )
          ],
        );
      },
    );
  }

  BlocBuilder<CuttingBloc, CuttingState> docVertical() {
    return BlocBuilder<CuttingBloc, CuttingState>(
      builder: (context, state) {
        if (state is CuttingLoadingState) {
          return Documents().verticalVersions(
              context: context,
              topMargin: 20,
              pdfMdocId: state.pdfdoc['pdf_mdoc_id'].toString(),
              pdfRevisionNo: state.pdfdoc['pdf_revision_number'].toString(),
              modelMdocId: state.modeldoc['model_mdoc_id'].toString(),
              modelRevisionNo:
                  state.modeldoc['model_revision_number'].toString().trim(),
              modelsDetails: state.modelsDetails,
              pdfDetails: state.pdfDetails,
              modelimageType: state.modeldoc['model_image_type'].toString(),
              product: state.barcode.product.toString(),
              productDescription:
                  state.pdfdoc['product_description'].toString(),
              token: state.token);
        } else {
          return const Text('');
        }
      },
    );
  }

  Container cuttingStatus(double parentWidth, double parentHeight) {
    return Container(
      width: parentWidth,
      height: 700,
      margin: const EdgeInsets.only(top: 20),
      child: BlocBuilder<CuttingBloc, CuttingState>(
        builder: (context, state) {
          if (state is CuttingLoadingState && state.status.isNotEmpty) {
            return CustomTable(
                tablewidth: parentWidth,
                tableheight: parentHeight,
                columnWidth: 333,
                rowHeight: 50,
                enableBorder: true,
                tableheaderColor: Theme.of(context).colorScheme.errorContainer,
                tablebodyColor: Theme.of(context).colorScheme.surface,
                headerStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold),
                tableBorderColor: Theme.of(context).colorScheme.error,
                column: [
                  ColumnData(label: 'Product'),
                  ColumnData(label: 'Start time'),
                  ColumnData(label: 'End time'),
                  ColumnData(label: 'Cutting quantity'),
                ],
                rows: state.status.map((e) {
                  DateTime startdate = DateTime.parse(e.starttime.toString());
                  DateTime? enddate;
                  if (e.endtime != null) {
                    enddate = DateTime.parse(e.endtime.toString());
                  }
                  return RowData(cell: [
                    TableDataCell(
                        label: Text(state.barcode.product.toString())),
                    TableDataCell(label: Text(startdate.toLocal().toString())),
                    TableDataCell(
                        label: Text(e.endtime == null
                            ? ''
                            : enddate!.toLocal().toString())),
                    TableDataCell(label: Text(e.cuttingqty.toString()))
                  ]);
                }).toList());
          } else {
            return const Text('');
          }
        },
      ),
    );
  }

  SizedBox cuttingTable({
    required double parentWidth,
    required double parentHeight,
    required Barcode? barcode,
    required CuttingBloc blocProvider,
    required BuildContext context,
  }) {
    StreamController<String> quantity = StreamController<String>.broadcast();
    return SizedBox(
      width: parentWidth,
      height: 100,
      child: CustomTable(
          tablewidth: parentWidth,
          tableheight: parentHeight,
          columnWidth: 266.5,
          rowHeight: 50,
          enableBorder: true,
          tableheaderColor: Theme.of(context).primaryColorLight,
          tablebodyColor: AppColors.whiteTheme,
          headerStyle: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold),
          tableBorderColor: Theme.of(context).primaryColorDark,
          column: [
            ColumnData(label: 'Produced Quantity'),
            ColumnData(label: 'Start time'),
            ColumnData(label: 'End time'),
            ColumnData(label: 'Cutting status'),
            ColumnData(label: 'Action'),
          ],
          rows: [
            RowData(cell: [
              editQuantity(quantity: quantity),
              TableDataCell(label: BlocBuilder<CuttingBloc, CuttingState>(
                builder: (context, state) {
                  if (state is CuttingLoadingState &&
                      state.productStatus['start_time'] != null &&
                      state.productStatus['end_time'] == null) {
                    DateTime date = DateTime.parse(
                        state.productStatus['start_time'].toString());
                    return Text(date.toLocal().toString());
                  } else {
                    return const Text('');
                  }
                },
              )),
              TableDataCell(label: BlocBuilder<CuttingBloc, CuttingState>(
                builder: (context, state) {
                  if (state is CuttingLoadingState &&
                      state.productStatus['end_time'] == null) {
                    return const Text('');
                  } else {
                    return const Text('');
                  }
                },
              )),
              cuttingStatusTextWidget(),
              TableDataCell(label: BlocBuilder<CuttingBloc, CuttingState>(
                builder: (context, state) {
                  if (state is CuttingLoadingState) {
                    if (state.productStatus['start_time'] != null &&
                        state.productStatus['end_time'] == null) {
                      return endCutting(
                          blocProvider: blocProvider,
                          state: state,
                          context: context,
                          quantity: quantity);
                    }
                    if (state.productStatus['start_time'] != null &&
                        state.productStatus['end_time'] != null) {
                      return Row(
                        children: [
                          startCutting(blocProvider, state, barcode, context),
                          finishCutting(blocProvider, state, context),
                        ],
                      );
                    } else {
                      return startCutting(
                          blocProvider, state, barcode, context);
                    }
                  }
                  return const Text('');
                },
              )),
            ])
          ]),
    );
  }

  TableDataCell cuttingStatusTextWidget() {
    return TableDataCell(label: BlocBuilder<CuttingBloc, CuttingState>(
      builder: (context, state) {
        if (state is CuttingLoadingState &&
            state.productStatus['end_time'] == null) {
          if (state.productStatus['status'] == 0) {
            return Container(
              height: 35,
              width: 100,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Running',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
            );
          }
          if (state.productStatus['status'] == 1) {
            return Container(
              height: 35,
              width: 100,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Completed',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            );
          } else {
            return const Text('Not started');
          }
        }
        return const Text('Not started');
      },
    ));
  }

  TableDataCell editQuantity({required StreamController<String> quantity}) {
    return TableDataCell(label:
        BlocBuilder<CuttingBloc, CuttingState>(builder: (context, state) {
      TextEditingController qty = TextEditingController();
      if (state is CuttingLoadingState) {
        if (state.tobeProducedQuantity < 0) {
          qty.text = '0';
          qty.selection = TextSelection.fromPosition(
            TextPosition(offset: qty.text.length),
          );
        } else {
          qty.text = state.tobeProducedQuantity.toString();
        }
      }
      qty.selection = TextSelection.fromPosition(
        TextPosition(offset: qty.text.length),
      );
      return StreamBuilder<String>(
          stream: quantity.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (state is CuttingLoadingState) {
                if ((state.productStatus['start_time'] != null &&
                        state.productStatus['end_time'] != null) ||
                    state.productStatus.isEmpty) {
                  if (state.tobeProducedQuantity < 0) {
                    quantity.add('0');
                  } else {
                    quantity.add(state.tobeProducedQuantity.toString());
                  }
                } else {
                  qty.text = snapshot.data.toString();
                  qty.selection = TextSelection.fromPosition(
                    TextPosition(offset: qty.text.length),
                  );
                }
              }
            }
            return TextField(
              controller: qty,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              readOnly: state is CuttingLoadingState
                  ? ((state.productStatus['start_time'] != null &&
                              state.productStatus['end_time'] != null) ||
                          state.productStatus.isEmpty)
                      ? true
                      : false
                  : true,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.normal)),
              onTap: () {
                if (state is CuttingLoadingState) {
                  if ((state.productStatus['start_time'] != null &&
                          state.productStatus['end_time'] != null) ||
                      state.productStatus.isEmpty) {
                    QuickFixUi.errorMessage(
                        'Please start cutting process first', context);
                    FocusScope.of(context).unfocus();
                    quantity.add(state.tobeProducedQuantity.toString());
                  } else {
                    quantity.add('0');
                  }
                }
                qty.selection = TextSelection.fromPosition(
                  TextPosition(offset: qty.text.length),
                );
              },
              onChanged: (value) {
                qty.text = value.toString();
                quantity.add(value.toString());
              },
            );
          });
    }));
  }

  BlocBuilder<CuttingBloc, CuttingState> docHorizontal() {
    return BlocBuilder<CuttingBloc, CuttingState>(
      builder: (context, state) {
        if (state is CuttingLoadingState) {
          return Documents().horizontalVersions(
              context: context,
              topMargin: 0,
              pdfMdocId: state.pdfdoc['pdf_mdoc_id'].toString(),
              pdfRevisionNo: state.pdfdoc['pdf_revision_number'].toString(),
              modelMdocId: state.modeldoc['model_mdoc_id'].toString(),
              modelRevisionNo:
                  state.modeldoc['model_revision_number'].toString().trim(),
              modelsDetails: state.modelsDetails,
              pdfDetails: state.pdfDetails,
              modelimageType: state.modeldoc['model_image_type'].toString(),
              product: state.barcode.product.toString(),
              productDescription:
                  state.pdfdoc['product_description'].toString(),
              token: state.token);
        } else {
          return const Text('');
        }
      },
    );
  }

  InkWell startCutting(CuttingBloc blocProvider, CuttingLoadingState state,
      Barcode? barcode, BuildContext context) {
    return InkWell(
      onTap: () async {
        blocProvider.add(
            CuttingLoadingEvent(arguments['barcode'], '', state.machinedata));

        String inspectionStarted = await CuttingRepository()
            .startCutting(token: state.token, payload: {
          'productid': barcode!.productid.toString().trim(),
          'seq': '0',
          'rawmaterialissueid': barcode.rawmaterialissueid.toString().trim(),
          'workcentreid':
              state.machinedata['wr_workcentre_id'].toString().trim(),
          'workstationid': state.machinedata['workstationid'].toString().trim(),
          'employeeid': state.employeeid.toString().trim(),
          'revision_number': barcode.revisionnumber.toString().trim()
        });
        await ProductMachineRoute()
            .registerProductMachineRoute(token: state.token, payload: {
          'product_id': state.barcode.productid,
          'product_revision': state.barcode.revisionnumber,
          'workcentre_id': state.machinedata['wr_workcentre_id'].toString(),
          'workstation_id': state.machinedata['workstationid'].toString()
        });
        if (inspectionStarted == 'Inserted successfully') {
          return QuickFixUi.successMessage(
              'The cutting process has begun', context);
        }
      },
      child: Container(
        width: 100,
        height: 35,
        margin: const EdgeInsets.all(5),
        color: AppColors.greenTheme,
        child: const Center(
          child: Text(
            'Start',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ),
    );
  }

  InkWell finishCutting(CuttingBloc blocProvider, CuttingLoadingState state,
      BuildContext context) {
    return InkWell(
      onTap: () async {
        blocProvider.add(CuttingLoadingEvent(
          arguments['barcode'],
          state.cuttingQty,
          state.machinedata,
        ));
        String finishCutting = await CuttingRepository()
            .finishCutting(token: state.token, payload: {
          'productid': state.barcode.productid.toString(),
          'rawmaterialissueid': state.barcode.rawmaterialissueid.toString(),
          'workcentreid': state.machinedata['wr_workcentre_id'].toString(),
          'revision': state.barcode.revisionnumber.toString()
        });
        if (finishCutting == 'Updated successfully') {
          return QuickFixUi.successMessage(
              'Successfully completed the cutting operation', context);
        }
      },
      child: Container(
        width: 100,
        height: 35,
        margin: const EdgeInsets.all(5),
        color: AppColors.redTheme,
        child: const Center(
          child: Text(
            'Finish',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ),
    );
  }

  StreamBuilder<String> endCutting(
      {required CuttingBloc blocProvider,
      required CuttingLoadingState state,
      required BuildContext context,
      required StreamController<String> quantity}) {
    return StreamBuilder<String>(
        stream: quantity.stream,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () async {
              if (snapshot.data != null && snapshot.data.toString() == '0') {
                return QuickFixUi.errorMessage('Please fill quantity', context);
              } else if (snapshot.data == null &&
                  state.tobeProducedQuantity <= 0) {
                return QuickFixUi.errorMessage(
                    'Quantity should be greater than 0', context);
              } else {
                String endCutting = await CuttingRepository()
                    .endCutting(token: state.token, payload: {
                  'id': state.productStatus['id'],
                  'quantity': snapshot.data == null
                      ? state.tobeProducedQuantity.toString()
                      : snapshot.data.toString()
                });

                if (endCutting == 'Updated successfully') {
                  Future.delayed(const Duration(seconds: 1), () {
                    blocProvider.add(CuttingLoadingEvent(
                        arguments['barcode'],
                        snapshot.data == null
                            ? state.tobeProducedQuantity.toString()
                            : snapshot.data.toString(),
                        {}));

                    FocusScope.of(context).unfocus();
                    return QuickFixUi.successMessage(
                        'The cutting process has been completed with quantity ${state.cuttingQty}',
                        context);
                  });
                }
              }
            },
            child: Container(
              width: 100,
              height: 35,
              margin: const EdgeInsets.all(5),
              color: Colors.orange,
              child: const Center(
                child: Text(
                  'End',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
          );
        });
  }

  BlocBuilder<CuttingBloc, CuttingState> docButtons() {
    return BlocBuilder<CuttingBloc, CuttingState>(
      builder: (context, state) {
        if (state is CuttingLoadingState) {
          return Documents().documentsButtons(
              context: context,
              alignment: Alignment.center,
              topMargin: 10,
              token: state.token,
              pdfMdocId: state.pdfdoc['pdf_mdoc_id'].toString(),
              product: state.barcode.product.toString(),
              productDescription:
                  state.pdfdoc['product_description'].toString(),
              pdfRevisionNo: state.pdfdoc['pdf_revision_number'].toString(),
              modelMdocId: state.modeldoc['model_mdoc_id'].toString(),
              modelimageType: state.modeldoc['model_image_type'].toString());
        } else {
          return const Text('');
        }
      },
    );
  }
}
