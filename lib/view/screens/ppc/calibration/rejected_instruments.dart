// Author : Shital Gayakwad
// Created Date : 12 Dec 2024
// Description : Calibration rejected reason

import 'dart:io';
import 'package:de/utils/app_colors.dart';
import 'package:de/utils/app_theme.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';

class RejectedInstrumentsPage extends StatelessWidget {
  const RejectedInstrumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(RejectedInstrumentsEvent());
    Size size = MediaQuery.of(context).size;
    return MakeMeResponsiveScreen(
      horixontaltab: calibrationHistoryScreen(size: size),
      windows: calibrationHistoryScreen(size: size),
      linux: calibrationHistoryScreen(size: size),
    );
  }

  BlocBuilder<CalibrationBloc, CalibrationState> calibrationHistoryScreen(
      {required Size size}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is RejectedInstrumentState &&
          state.rejectedInstrumentsDataList.isNotEmpty) {
        double rowheight = Platform.isAndroid ? 45 : 35,
            tableHeight = ((state.rejectedInstrumentsDataList.length + 1) *
                        rowheight) >
                    (size.height - 10)
                ? (size.height - 10)
                : ((state.rejectedInstrumentsDataList.length + 1) * rowheight);

        return Container(
          width: size.width,
          height: tableHeight,
          margin: const EdgeInsets.all(5),
          child: CustomTable(
              tablewidth: size.width - 10,
              tableheight: tableHeight,
              columnWidth: (size.width - 52) / state.tableColumnsList.length,
              headerHeight: rowheight,
              rowHeight: rowheight,
              headerStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize: Platform.isAndroid ? 15 : 13),
              tableheaderColor: AppColors.whiteTheme,
              showIndex: true,
              tableOutsideBorder: true,
              enableHeaderBottomBorder: true,
              enableRowBottomBorder: true,
              headerBorderThickness: .5,
              headerBorderColor: AppColors.blackColor,
              column: state.tableColumnsList
                  .map((columnlabel) => ColumnData(label: columnlabel))
                  .toList(),
              rows: state.rejectedInstrumentsDataList.map((e) {
                return RowData(cell: [
                  tableDataCell(text: e.instrumentname.toString()),
                  tableDataCell(text: e.cardnumber.toString()),
                  tableDataCell(text: e.measuringrange.toString()),
                  tableDataCell(
                      text: DateTime.parse(e.rejectedDate.toString())
                          .toLocal()
                          .toString()
                          .substring(0, 10)),
                  tableDataCell(text: e.rejectedby.toString()),
                  tableDataCell(text: e.rejectionReason.toString()),
                ]);
              }).toList()),
        );
      } else {
        return dataNotFoundWidget();
      }
    });
  }

  TableDataCell tableDataCell({required String text}) {
    return TableDataCell(
        label: Text(
      text.toString().trim(),
      textAlign: TextAlign.center,
      style: AppTheme.labelTextStyle(),
    ));
  }

  Center dataNotFoundWidget() => const Center(child: Text('Data not found.'));
}
