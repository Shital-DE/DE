// Author : Shital Gayakwad
// Created Date :  21 Dec 2024
// Description : ERPX_PPC -> Production process widget

import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';

import '../../routes/route_names.dart';
import '../../services/model/operator/oprator_models.dart';
import '../../services/model/product/product_route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';

class ProductionProcessWidget {
  Container processTable(
      {required BuildContext context,
      required List<ProductAndProcessRouteModel> productProcessRouteList,
      required Barcode barcode,
      bool wantAction = false}) {
    Size size = MediaQuery.of(context).size;
    List<String> tableColumnsList = [
      'Sequence number',
      'Instruction',
      'Setup minuts',
      'Runtime minuts',
      wantAction == true ? 'Action' : ''
    ];
    double rowHeight = 45,
        tableHeight = ((productProcessRouteList.length + 1) * rowHeight) >
                (size.height - 150)
            ? (size.height - 150)
            : ((productProcessRouteList.length + 1) * rowHeight),
        instructionWidth =
            ((size.width - 12) - (150 * (wantAction == true ? 4 : 3)));
    return Container(
      width: size.width,
      height: tableHeight,
      margin: const EdgeInsets.all(1),
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
          column: tableColumnsList
              .map((column) => ColumnData(
                  width: column == ''
                      ? .1
                      : column == 'Instruction'
                          ? instructionWidth
                          : 150,
                  label: column))
              .toList(),
          rows: productProcessRouteList.map((row) {
            return RowData(cell: [
              tableDataCell(text: row.combinedSequence.toString()),
              TableDataCell(
                  width: instructionWidth,
                  label: InkWell(
                    onTap: () {
                      QuickFixUi().showCustomDialog(
                          context: context,
                          errorMessage: row.combinedSequence == 900
                              ? 'Final inspection'
                              : row.instruction.toString().trim());
                    },
                    child: Text(
                      row.combinedSequence == 900
                          ? 'Final inspection'
                          : row.instruction.toString().trim(),
                      textAlign: TextAlign.center,
                      style: AppTheme.labelTextStyle(),
                    ),
                  )),
              tableDataCell(
                  text: row.setuptimemins == null
                      ? '0'
                      : row.setuptimemins.toString()),
              tableDataCell(
                  text: row.runtimemins == null
                      ? '0'
                      : row.runtimemins.toString()),
              wantAction == true
                  ? TableDataCell(
                      label: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteName.qualityScreen,
                                arguments: {
                                  'barcode': barcode,
                                  'selected_process': [row]
                                });
                          },
                          child: const Text('Proceed')),
                    ))
                  : TableDataCell(width: .1, label: const Stack())
            ]);
          }).toList()),
    );
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
