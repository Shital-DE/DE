import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../bloc/ppc/tool_dispencer/bloc/tools_bloc.dart';
import '../../../../../services/model/tool_dispencer/tool.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/constant.dart';
import '../../../../widgets/custom_datatable.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/date_range_picker.dart';

enum ToggleBtn { addstock, datereport, operatorreport }

class ToolStockView extends StatefulWidget {
  const ToolStockView({super.key});

  @override
  State<ToolStockView> createState() => _ToolStockViewState();
}

class _ToolStockViewState extends State<ToolStockView> {
  TextEditingController txtQty = TextEditingController();
  TextEditingController dateRange = TextEditingController();
  DateRangePickerHelper pickerHelper = DateRangePickerHelper();
  String toolId = '';
  Tool? tool;
  String employeeId = "";
  int month = -1;

  ToggleBtn view = ToggleBtn.addstock;

  @override
  void dispose() {
    txtQty.dispose();
    dateRange.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tool Stock"),
          backgroundColor: AppColors.appbarColor,
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  width: 500,
                  child: SegmentedButton<ToggleBtn>(
                    style: SegmentedButton.styleFrom(
                        selectedBackgroundColor: AppColors.appbarColor),
                    segments: const [
                      ButtonSegment<ToggleBtn>(
                        value: ToggleBtn.addstock,
                        label: Text('Add Stock'),
                      ),
                      ButtonSegment<ToggleBtn>(
                        value: ToggleBtn.datereport,
                        label: Text('Date Report'),
                      ),
                      ButtonSegment<ToggleBtn>(
                        value: ToggleBtn.operatorreport,
                        label: Text('Operator Report'),
                      )
                    ],
                    selected: <ToggleBtn>{view},
                    onSelectionChanged: (Set<ToggleBtn> newSelection) {
                      setState(() {
                        view = newSelection.first;
                      });
                      if (view == ToggleBtn.operatorreport) {
                        BlocProvider.of<ToolsBloc>(context)
                            .add(const ToolStockListEvent(tab: "emp_report"));
                      } else if (view == ToggleBtn.addstock) {
                        BlocProvider.of<ToolsBloc>(context)
                            .add(const ToolStockListEvent(tab: "addstock"));
                      } else {}
                    },
                  ),
                ),
              ],
            ),
            if (view == ToggleBtn.addstock)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    margin: const EdgeInsets.only(right: 30),
                    width: SizeConfig.screenWidth! * 0.28,
                    child: BlocBuilder<ToolsBloc, ToolsState>(
                      builder: (context, state) {
                        return CustomDropdownSearch(
                            items: state.tools,
                            selectedItem: tool != null
                                ? state.tools
                                    .firstWhere((tool) => tool.id == toolId)
                                : null,
                            itemAsString: (i) => i.manufacturertoolcode ?? "",
                            onChanged: (value) {
                              toolId = value!.id!;
                              tool = value;
                            },
                            hintText: "Select Tool");
                      },
                    )),
                Container(
                    margin: const EdgeInsets.only(right: 30),
                    width: SizeConfig.screenWidth! * 0.15,
                    child: TextField(
                        controller: txtQty,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[-.]')),
                        ],
                        decoration: const InputDecoration(
                          hintText: "Qty",
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                        ))),
                Padding(
                  padding: EdgeInsets.zero,
                  child: DebouncedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.whiteTheme,
                          backgroundColor: AppColors.appTheme),
                      onPressed: () {
                        if (txtQty.text != '') {
                          BlocProvider.of<ToolsBloc>(context).add(
                              ToolsStockAddEvent(
                                  toolId: toolId, qty: int.parse(txtQty.text)));

                          QuickFixUi.successMessage("Success", context);
                          txtQty.clear();
                          tool = null;
                        } else {
                          QuickFixUi.errorMessage("Enter Qty", context);
                        }
                      },
                      text: "Submit"),
                ),
              ]),
            if (view == ToggleBtn.datereport)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: dateRange,
                      readOnly: true,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          border: InputBorder.none,
                          hintText: "Select Date Range"),
                      onTap: () async {
                        String selectedDates =
                            (await pickerHelper.rangeDatePicker(context))!;

                        if (selectedDates != '') {
                          dateRange.text = selectedDates;
                          if (!context.mounted) return;
                          BlocProvider.of<ToolsBloc>(context)
                              .add(ToolReportEvent(
                            fromdate: selectedDates.split('TO')[0].trim(),
                            todate: selectedDates.split('TO')[1].trim(),
                          ));
                        }
                      },
                    ),
                  ),
                ],
              ),
            if (view == ToggleBtn.operatorreport)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 40),
                      width: SizeConfig.screenWidth! * 0.3,
                      child: BlocBuilder<ToolsBloc, ToolsState>(
                        builder: (context, state) {
                          return CustomDropdownSearch(
                              items: state.operator,
                              itemAsString: (i) => i.employeename ?? "",
                              onChanged: (value) {
                                employeeId = value!.id!;
                                if (month == -1) {
                                  BlocProvider.of<ToolsBloc>(context).add(
                                      OperatorMonthReportEvent(
                                          employeeId: employeeId,
                                          fromdate: DateFormat("yyyy-MM-dd")
                                              .format(DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  1)),
                                          todate: DateFormat("yyyy-MM-dd")
                                              .format(DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month + 1,
                                                  0))));
                                } else {
                                  BlocProvider.of<ToolsBloc>(context).add(
                                      OperatorMonthReportEvent(
                                          employeeId: employeeId,
                                          fromdate: DateFormat("yyyy-MM-dd")
                                              .format(DateTime(
                                                  DateTime.now().year,
                                                  month,
                                                  1)),
                                          todate: DateFormat("yyyy-MM-dd")
                                              .format(DateTime(
                                                  DateTime.now().year,
                                                  month + 1,
                                                  0))));
                                }
                              },
                              hintText: "Operator");
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.only(right: 40),
                      width: SizeConfig.screenWidth! * 0.1,
                      child: CustomDropdownSearch<String>(
                        items: monthNames.keys.toList(),
                        selectedItem:
                            monthNames.keys.elementAt(DateTime.now().month - 1),
                        itemAsString: (item) => item,
                        onChanged: (item) {
                          month = monthNames[item]!;
                          BlocProvider.of<ToolsBloc>(context).add(
                              OperatorMonthReportEvent(
                                  employeeId: employeeId,
                                  fromdate: DateFormat("yyyy-MM-dd").format(
                                      DateTime(DateTime.now().year,
                                          monthNames[item]!, 1)),
                                  todate: DateFormat("yyyy-MM-dd").format(
                                      DateTime(DateTime.now().year,
                                          monthNames[item]! + 1, 0))));
                        },
                        hintText: "Month",
                      )),
                  SizedBox(
                      child: Text(
                    DateTime.now().year.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ))
                ],
              ),
            if (view == ToggleBtn.addstock)
              Container(
                height: SizeConfig.screenHeight! * 0.65,
                margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 0, color: Colors.white)),
                child: BlocBuilder<ToolsBloc, ToolsState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: CustomDataTable(
                        tableBorder: const TableBorder.symmetric(
                            outside: BorderSide(width: 0.5)),
                        columnNames: const ["Date", "Tool", "Total Qty"],
                        rows: state.toolStock.map((i) {
                          return DataRow(cells: [
                            DataCell(Text(i.date.toString())),
                            DataCell(Text(i.toolcode.toString())),
                            DataCell(Text(i.qty.toString())),
                          ]);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            if (view == ToggleBtn.datereport)
              Container(
                height: SizeConfig.screenHeight! * 0.65,
                margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 0, color: Colors.white)),
                child: BlocBuilder<ToolsBloc, ToolsState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: CustomDataTable(
                        tableBorder: const TableBorder.symmetric(
                            outside: BorderSide(width: 0.5)),
                        columnNames: const [
                          "Employee",
                          "Tool",
                          "Issued Qty",
                          "Damaged Qty",
                          "Wornout Qty"
                        ],
                        rows: state.toolReport.map((i) {
                          return DataRow(cells: [
                            DataCell(Text(i.employeeName.toString())),
                            DataCell(Text(i.tool.toString())),
                            DataCell(Text(i.qty.toString())),
                            DataCell(Text(i.damageQty.toString())),
                            DataCell(Text(i.wornoutQty.toString())),
                          ]);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            if (view == ToggleBtn.operatorreport)
              Container(
                  height: SizeConfig.screenHeight! * 0.6,
                  // decoration: BoxDecoration(border: Border.all()),
                  margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0, color: Colors.white)),
                  child: BlocBuilder<ToolsBloc, ToolsState>(
                      builder: (context, state) {
                    return SingleChildScrollView(
                      child: CustomDataTable(
                        tableBorder: const TableBorder.symmetric(
                            outside: BorderSide(width: 0.5)),
                        columnNames: const [
                          "Date",
                          "Tool",
                          "Qty",
                          "Status",
                          "Reason"
                        ],
                        rows: state.toolStock.map((i) {
                          return DataRow(cells: [
                            DataCell(Text(i.date.toString())),
                            DataCell(Text(i.toolcode.toString())),
                            DataCell(Text(i.qty.toString())),
                            DataCell(Text(i.status.toString())),
                            DataCell(Text(i.reason ?? ""))
                          ]);
                        }).toList(),
                      ),
                    );
                  }))
          ],
        ));
  }
}
