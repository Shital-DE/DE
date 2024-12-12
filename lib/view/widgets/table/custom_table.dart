// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Custom table
// Modification: 20 Sept 2023 -> Make table scroll horizontally on windows platform

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/app_colors.dart';
import 'table_bloc.dart';

class CustomTable extends StatelessWidget {
  final double tablewidth,
      tableheight,
      rowHeight,
      columnWidth,
      borderThickness,
      headerBorderThickness,
      headerHeight;
  final List<ColumnData> column;
  final List<RowData> rows;
  final bool showIndex,
      enableBorder,
      enableRowBottomBorder,
      showCheckBoxSelection,
      enableHeaderBottomBorder,
      tableOutsideBorder;
  final Color tableheaderColor,
      tablebodyColor,
      tableBorderColor,
      selectedValueColor,
      headerBorderColor;
  final TextStyle headerStyle;
  final Widget footer;
  const CustomTable(
      {super.key,
      required this.tablewidth,
      required this.tableheight,
      required this.column,
      required this.rows,
      this.showIndex = false,
      this.rowHeight = 40,
      this.columnWidth = 100,
      this.tableheaderColor = AppColors.appTheme,
      this.tablebodyColor = AppColors.whiteTheme,
      this.tableBorderColor = Colors.black,
      this.borderThickness = 0,
      this.enableBorder = false,
      this.enableRowBottomBorder = false,
      this.showCheckBoxSelection = false,
      this.selectedValueColor = AppColors.appTheme,
      this.headerStyle = const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      this.enableHeaderBottomBorder = false,
      this.headerBorderThickness = 3,
      this.headerBorderColor = AppColors.appTheme,
      this.tableOutsideBorder = false,
      this.footer = const Stack(),
      this.headerHeight = 45});

  @override
  Widget build(BuildContext context) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalControlller = ScrollController();
    return BlocProvider(
      create: (context) => AppTableBloc(),
      child: Scaffold(
          body: Container(
        width: tablewidth,
        height: tableheight,
        decoration: BoxDecoration(
          border: tableOutsideBorder == true
              ? Border.all(color: tableBorderColor)
              : const Border(),
        ),
        child: Center(
          child: Scrollbar(
            controller: horizontalControlller,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: horizontalControlller,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: verticalController,
                    child: Row(
                      children: [
                        if (showCheckBoxSelection == true)
                          Container(
                            width: rowHeight + rowHeight,
                            height: headerHeight,
                            decoration: BoxDecoration(
                              color: tableheaderColor,
                              border: enableHeaderBottomBorder == true
                                  ? Border(
                                      bottom: BorderSide(
                                        color: headerBorderColor,
                                        width: headerBorderThickness,
                                        style: BorderStyle.solid,
                                      ),
                                    )
                                  : Border.all(
                                      color: enableBorder == true
                                          ? tableBorderColor
                                          : tableheaderColor,
                                      width: borderThickness,
                                      style: BorderStyle.solid,
                                    ),
                            ),
                            child: Center(
                                child: Text(
                              'Select',
                              style: headerStyle,
                            )),
                          ),
                        if (showIndex == true)
                          Container(
                            width: rowHeight,
                            height: headerHeight,
                            decoration: BoxDecoration(
                              color: tableheaderColor,
                              border: enableHeaderBottomBorder == true
                                  ? Border(
                                      bottom: BorderSide(
                                        color: headerBorderColor,
                                        width: headerBorderThickness,
                                        style: BorderStyle.solid,
                                      ),
                                    )
                                  : Border.all(
                                      color: enableBorder == true
                                          ? tableBorderColor
                                          : tableheaderColor,
                                      width: borderThickness,
                                      style: BorderStyle.solid,
                                    ),
                            ),
                            child: Center(
                                child: Text(
                              'Sr. No',
                              style: headerStyle,
                              textAlign: TextAlign.center,
                            )),
                          ),
                        Row(
                          children: column
                              .map((e) => SingleChildScrollView(
                                    child: Container(
                                      height: headerHeight,
                                      width:
                                          e.width == 0 ? columnWidth : e.width,
                                      decoration: BoxDecoration(
                                        color: tableheaderColor,
                                        border: enableHeaderBottomBorder == true
                                            ? Border(
                                                bottom: BorderSide(
                                                  color: headerBorderColor,
                                                  width: headerBorderThickness,
                                                  style: BorderStyle.solid,
                                                ),
                                              )
                                            : Border.all(
                                                color: enableBorder == true
                                                    ? tableBorderColor
                                                    : tableheaderColor,
                                                width: borderThickness,
                                                style: BorderStyle.solid,
                                              ),
                                      ),
                                      child: Center(
                                          child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              e.label,
                                              textAlign: TextAlign.center,
                                              style: headerStyle,
                                            ),
                                          ),
                                          e.action
                                        ],
                                      )),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  // Table content with fixed index column
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        children: [
                          if (showCheckBoxSelection == true)
                            getCheckBoxList(
                              rows,
                              context,
                            ),
                          if (showIndex == true) getIndex(rows),
                          getBody(
                            rows,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: tableheaderColor,
                        border: enableHeaderBottomBorder == true
                            ? Border(
                                bottom: BorderSide(
                                  color: headerBorderColor,
                                  width: headerBorderThickness,
                                  style: BorderStyle.solid,
                                ),
                              )
                            : Border.all(
                                color: enableBorder == true
                                    ? tableBorderColor
                                    : tableheaderColor,
                                width: borderThickness,
                                style: BorderStyle.solid,
                              ),
                      ),
                      child: footer)
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  getIndex(List<RowData> rows) {
    List<Widget> widgets = [];
    for (int count = 0; count < rows.length; count++) {
      widgets.add(
          BlocBuilder<AppTableBloc, AppTableState>(builder: (context, state) {
        return Container(
            height: rowHeight,
            width: rowHeight,
            decoration: BoxDecoration(
              color: state is AppTableScrollDirectionState &&
                      state.selectedRowList.contains(count)
                  ? selectedValueColor
                  : tablebodyColor,
              border: enableRowBottomBorder == true
                  ? Border(
                      bottom: BorderSide(
                        color: tableBorderColor,
                        width: borderThickness,
                        style: BorderStyle.solid,
                      ),
                    )
                  : Border.all(
                      color: enableBorder == true
                          ? tableBorderColor
                          : state is AppTableScrollDirectionState &&
                                  state.selectedRowList.contains(count)
                              ? selectedValueColor
                              : tablebodyColor,
                      width: borderThickness,
                      style: BorderStyle.solid,
                    ),
            ),
            child: Center(child: Text((count + 1).toString())));
      }));
    }

    return Column(children: widgets);
  }

  getCheckBoxList(List<RowData> rows, BuildContext context) {
    List<Widget> widgets = [];
    List<int> selectedRowList = [];
    for (int count = 0; count < rows.length; count++) {
      widgets.add(
        BlocBuilder<AppTableBloc, AppTableState>(builder: (context, state) {
          return Container(
              height: rowHeight,
              width: rowHeight + rowHeight,
              decoration: BoxDecoration(
                color: state is AppTableScrollDirectionState &&
                        state.selectedRowList.contains(count)
                    ? selectedValueColor
                    : tablebodyColor,
                border: enableRowBottomBorder == true
                    ? Border(
                        bottom: BorderSide(
                          color: tableBorderColor,
                          width: borderThickness,
                          style: BorderStyle.solid,
                        ),
                      )
                    : Border.all(
                        color: enableBorder == true
                            ? tableBorderColor
                            : state is AppTableScrollDirectionState &&
                                    state.selectedRowList.contains(count)
                                ? selectedValueColor
                                : tablebodyColor,
                        width: borderThickness,
                        style: BorderStyle.solid,
                      ),
              ),
              child: Center(
                  child: Checkbox(
                value: state is AppTableScrollDirectionState &&
                        state.selectedRowList.contains(count)
                    ? true
                    : false,
                onChanged: (value) {
                  if (state is AppTableScrollDirectionState &&
                      state.selectedRowList.contains(count)) {
                    selectedRowList.remove(count);
                    BlocProvider.of<AppTableBloc>(context)
                        .add(AppTableScrollDirectionEvent(selectedRowList));
                  } else {
                    selectedRowList.add(count);
                    BlocProvider.of<AppTableBloc>(context)
                        .add(AppTableScrollDirectionEvent(selectedRowList));
                  }
                },
              )));
        }),
      );
    }

    return Column(children: widgets);
  }

  getBody(List<RowData> rows) {
    List<Widget> rowWidgets = [];

    for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      RowData row = rows[rowIndex];
      List<Widget> cellWidgets = [];

      for (int cellIndex = 0; cellIndex < row.cell.length; cellIndex++) {
        TableDataCell cell = row.cell[cellIndex];
        cellWidgets.add(
          BlocBuilder<AppTableBloc, AppTableState>(
            builder: (context, state) {
              return Container(
                height: cell.height == 0 ? rowHeight : cell.height,
                width: cell.width == 0 ? columnWidth : cell.width,
                decoration: BoxDecoration(
                  color: row.rowColor == AppColors.whiteTheme
                      ? state is AppTableScrollDirectionState &&
                              state.selectedRowList.contains(rowIndex)
                          ? selectedValueColor
                          : tablebodyColor
                      : row.rowColor,
                  border: enableRowBottomBorder == true
                      ? Border(
                          bottom: BorderSide(
                            color: tableBorderColor,
                            width: borderThickness,
                            style: BorderStyle.solid,
                          ),
                        )
                      : Border.all(
                          color: row.rowColor == AppColors.whiteTheme
                              ? enableBorder == true
                                  ? tableBorderColor
                                  : state is AppTableScrollDirectionState &&
                                          state.selectedRowList
                                              .contains(rowIndex)
                                      ? selectedValueColor
                                      : tablebodyColor
                              : row.rowColor,
                          width: borderThickness,
                          style: BorderStyle.solid,
                        ),
                ),
                child: Center(child: cell.label),
              );
            },
          ),
        );
      }

      rowWidgets.add(Row(children: cellWidgets));
    }

    return Column(children: rowWidgets);
  }
}

class ColumnData {
  final Widget action;
  final String label;
  final double width;
  ColumnData({this.action = const Text(''), this.label = '', this.width = 0});
}

class RowData {
  final Color rowColor;
  final List<TableDataCell> cell;
  RowData({required this.cell, this.rowColor = AppColors.whiteTheme});
}

class TableDataCell {
  final Widget label;
  final double width, height;
  TableDataCell({required this.label, this.width = 0, this.height = 0});
}
