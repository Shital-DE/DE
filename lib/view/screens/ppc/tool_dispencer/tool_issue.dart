import 'package:de/utils/common/quickfix_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../bloc/ppc/tool_dispencer/bloc/tools_bloc.dart';
import '../../../../services/model/tool_dispencer/tool.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/custom_datatable.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/debounce_button.dart';

class ToolIssue extends StatefulWidget {
  const ToolIssue({super.key});

  @override
  State<ToolIssue> createState() => _ToolIssueState();
}

class _ToolIssueState extends State<ToolIssue> {
  TextEditingController txtQty = TextEditingController();
  TextEditingController txtdate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  String toolId = '';
  Tool? tool;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    txtQty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tool Issue"),
        backgroundColor: AppColors.appbarColor,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, right: 30),
                width: SizeConfig.screenWidth! * 0.35,
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
                          txtQty.text = "";
                        },
                        hintText: "Select Tool");
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30, right: 30),
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
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 30, right: 30),
                width: 150,
                child: TextField(
                  controller: txtdate,
                  readOnly: true,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      border: InputBorder.none,
                      hintText: "Select date"),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2050),
                    );
                    if (pickedDate != null) {
                      txtdate.text = DateFormat('yyyy-MM-dd')
                          .format(pickedDate)
                          .toString();
                    }
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: BlocListener<ToolsBloc, ToolsState>(
                    listener: (context, state) {
                      if (state.result != '') {
                        if (state.result == 'success') {
                          QuickFixUi.successMessage("Success", context);
                        } else {
                          QuickFixUi.errorMessage(
                              "Stock Not Available", context);
                        }
                      }
                    },
                    child: DebouncedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.whiteTheme,
                            backgroundColor: AppColors.appTheme),
                        onPressed: () {
                          if ((txtQty.text != "" && txtQty.text != "0") &&
                              toolId != "") {
                            BlocProvider.of<ToolsBloc>(context).add(
                                ToolsIssueEvent(
                                    issueDate: txtdate.text,
                                    toolId: toolId,
                                    qty: int.parse(txtQty.text)));

                            txtQty.clear();
                            tool = null;
                            toolId = "";
                            txtdate.text = DateFormat('yyyy-MM-dd')
                                .format(DateTime.now())
                                .toString();
                          } else {
                            QuickFixUi.errorMessage(
                                "Enter tool and qty ", context);
                          }
                        },
                        text: "Submit"),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 800,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(border: Border.all(width: 0.5)),
                child: BlocBuilder<ToolsBloc, ToolsState>(
                  builder: (context, state) {
                    return CustomDataTable(
                      columnNames: const ["Tool", "Total Qty"],
                      rows: state.toolStock.map((i) {
                        return DataRow(cells: [
                          // DataCell(Text(i.date.toString())),
                          DataCell(Text(i.toolcode.toString())),
                          DataCell(Text(i.qty.toString())),
                        ]);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
