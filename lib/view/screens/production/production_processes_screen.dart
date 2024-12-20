// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Quality process screen

import 'package:de/bloc/production/quality/quality_dashboard_event.dart';
import 'package:de/bloc/production/quality/quality_dashboard_state.dart';
import 'package:de/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/production/quality/quality_dashboard_bloc.dart';
import '../../../routes/route_names.dart';
import '../../../services/model/operator/oprator_models.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/barcode_session.dart';
import '../../widgets/table/custom_table.dart';

class ProductionProcessScreen extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const ProductionProcessScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    final blocProvider = BlocProvider.of<QualityBloc>(context);
    blocProvider.add(QualityProductionProcessesEvents(barcode: barcode!));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Production processes screen'),
      body: BlocBuilder<QualityBloc, QualityState>(builder: (context, state) {
        if (state is QualityProductionProcessesState &&
            state.productprocessseqlist.isNotEmpty) {
          double rowHeight = 45,
              tableHeight =
                  ((state.productprocessseqlist.length + 1) * rowHeight) >
                          (size.height - 150)
                      ? (size.height - 150)
                      : ((state.productprocessseqlist.length + 1) * rowHeight);
          return Container(
            width: size.width,
            height: size.height,
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                BarcodeSession().barcodeData(
                    context: context,
                    parentWidth: size.width - 10,
                    barcode: barcode),
                SizedBox(
                  width: size.width,
                  height: tableHeight,
                  child: CustomTable(
                      tablewidth: size.width - 10,
                      tableheight: tableHeight,
                      columnWidth: 150,
                      headerHeight: rowHeight,
                      rowHeight: rowHeight,
                      headerBorderThickness: .5,
                      tableOutsideBorder: true,
                      enableHeaderBottomBorder: true,
                      enableRowBottomBorder: true,
                      tableheaderColor: AppColors.whiteTheme,
                      tablebodyColor: AppColors.whiteTheme,
                      headerBorderColor: AppColors.blackColor,
                      headerStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      column: state.tableColumnsList
                          .map((column) => ColumnData(
                              width: column == 'Instruction'
                                  ? ((size.width - 12) - (150 * 4))
                                  : 150,
                              label: column))
                          .toList(),
                      rows: state.productprocessseqlist.map((row) {
                        return RowData(cell: [
                          tableDataCell(text: row.seqno.toString()),
                          TableDataCell(
                              width: ((size.width - 12) - (150 * 4)),
                              label: Text(
                                row.instruction.toString().trim(),
                                textAlign: TextAlign.center,
                                style: AppTheme.labelTextStyle(),
                              )),
                          tableDataCell(text: row.setupminutes.toString()),
                          tableDataCell(text: row.runtimeminutes.toString()),
                          TableDataCell(
                              label: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: proceedButton(
                                context: context, barcode: barcode),
                          ))
                        ]);
                      }).toList()),
                ),
              ],
            ),
          );
        } else if (state is QualityProductionProcessesState &&
            state.productprocessseqlist.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No product routes are available.',
                style: AppTheme.labelTextStyle(isFontBold: true),
              ),
              proceedButton(context: context, barcode: barcode),
            ],
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      }),
    );
  }

  ElevatedButton proceedButton(
      {required BuildContext context, required Barcode barcode}) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.qualityScreen, arguments: {
            'barcode': barcode,
          });
        },
        child: const Text('Proceed'));
  }

  TableDataCell tableDataCell({required String text}) {
    return TableDataCell(
        label: Text(
      text.toString().trim(),
      textAlign: TextAlign.center,
      style: AppTheme.labelTextStyle(),
    ));
  }
}
