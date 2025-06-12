// Author : Shital Gayakwad
// Created Date : 12 Dec 2024
// Description : Calibration rejected reason
// Modification : 11 June 2025 by Shital Gayakwad.

import 'dart:io';
import 'package:de/utils/app_colors.dart';
import 'package:de/utils/app_theme.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../services/model/quality/calibration_model.dart';

class RejectedInstrumentsPage extends StatelessWidget {
  const RejectedInstrumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(RejectedInstrumentsEvent());
    Size size = MediaQuery.of(context).size;
    return MakeMeResponsiveScreen(
      horixontaltab:
          calibrationHistoryScreen(size: size, blocProvider: blocProvider),
      windows: calibrationHistoryScreen(size: size, blocProvider: blocProvider),
      linux: calibrationHistoryScreen(size: size, blocProvider: blocProvider),
    );
  }

  BlocBuilder<CalibrationBloc, CalibrationState> calibrationHistoryScreen(
      {required Size size, required CalibrationBloc blocProvider}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is CalibrationInitialState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is RejectedInstrumentState &&
          state.rejectedInstrumentsDataList.isNotEmpty) {
        double rowheight = Platform.isAndroid ? 40 : 35,
            tableHeight = state.selectedInstrumentList != null &&
                    state.selectedInstrumentList!.isNotEmpty
                ? ((state.selectedInstrumentList!.length + 1) * rowheight) + 5
                : (((state.rejectedInstrumentsDataList.length + 1) *
                                rowheight) >
                            (size.height - 10)
                        ? (size.height - 10)
                        : ((state.rejectedInstrumentsDataList.length + 1) *
                            rowheight)) -
                    215;

        return ListView(
          children: [
            const SizedBox(height: 5),
            SizedBox(
              height: 50,
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: DropdownSearch<RejectedInstrumentsModel>(
                      items: state.rejectedInstrumentsDataList,
                      itemAsString: (item) =>
                          "${item.instrumentname}  ${item.cardnumber}",
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(
                              "${item.instrumentname}  ${item.cardnumber}",
                              style: AppTheme.labelTextStyle(),
                            ),
                          );
                        },
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          textAlign: TextAlign.center,
                          dropdownSearchDecoration: InputDecoration(
                            hintText: 'Select instrument',
                            hintStyle: AppTheme.labelTextStyle(),
                            contentPadding: const EdgeInsets.only(
                                bottom: 11, top: 11, left: 2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                          )),
                      onChanged: (value) async {
                        if (value != null) {
                          blocProvider.add(RejectedInstrumentsEvent(
                              selectedInstrumentList: [value]));
                        } else {
                          blocProvider.add(RejectedInstrumentsEvent(
                              selectedInstrumentList:
                                  state.rejectedInstrumentsDataList));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: state.selectedInstrumentList != null &&
                            state.selectedInstrumentList!.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              blocProvider.add(CalibrationInitialEvent());
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                blocProvider.add(RejectedInstrumentsEvent());
                              });
                            },
                            icon: const Icon(Icons.cancel))
                        : const Text(""),
                  )
                ],
              ),
            ),
            Container(
              width: size.width,
              height: tableHeight,
              margin:
                  const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 4),
              child: CustomTable(
                  tablewidth: size.width - 10,
                  tableheight: tableHeight,
                  columnWidth:
                      (size.width - 90) / state.tableColumnsList.length,
                  headerHeight: rowheight + 5,
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
                  rows: (state.selectedInstrumentList != null &&
                              state.selectedInstrumentList!.isNotEmpty
                          ? state.selectedInstrumentList
                          : state.rejectedInstrumentsDataList)!
                      .map((e) {
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
                      tableDataCell(
                          text: e.remark == null ? "" : e.remark.toString()),
                    ]);
                  }).toList()),
            ),
          ],
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
