import 'package:de/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/ppc/tool_dispencer/bloc/tools_bloc.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/custom_datatable.dart';
import '../../../widgets/custom_dropdown.dart';

class ToolsReceipt extends StatefulWidget {
  const ToolsReceipt({super.key});

  @override
  State<ToolsReceipt> createState() => _ToolsReceiptState();
}

class _ToolsReceiptState extends State<ToolsReceipt> {
  String employeeId = "";
  // int returnedQty = 0;
  // Map<int, int> returnedQtyMap = {};
  Map<int, TextEditingController> returnQtyController = {};

  @override
  void dispose() {
    returnQtyController.forEach((key, controller) {
      controller.dispose(); // Dispose the controller for this row
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tool Receipt"),
        backgroundColor: AppColors.appbarColor,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 40),
                  width: SizeConfig.screenWidth! * 0.3,
                  child: BlocBuilder<ToolsBloc, ToolsState>(
                    builder: (context, state) {
                      return CustomDropdownSearch(
                          items: state.operator,
                          itemAsString: (i) => i.employeename ?? "",
                          onChanged: (value) {
                            employeeId = value!.id!;
                            BlocProvider.of<ToolsBloc>(context).add(
                                OperatorWiseToolsEvent(employeeId: value.id!));
                          },
                          hintText: "Operator");
                    },
                  )),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(border: Border.all(width: 0.5)),
            child: BlocBuilder<ToolsBloc, ToolsState>(
              builder: (context, state) {
                return CustomDataTable(
                  columnNames: const [
                    "Sr.No",
                    "Tool",
                    "Issue Qty",
                    "Receive Qty",
                    "Action",
                  ],
                  rows: state.toolStock.map((item) {
                    int rowIndex = state.toolStock.indexOf(item);
                    if (!returnQtyController.containsKey(rowIndex)) {
                      returnQtyController[rowIndex] = TextEditingController();
                    }
                    // returnedQtyMap.putIfAbsent(rowIndex, () => 0); // Default to 0
                    return DataRow(cells: [
                      DataCell(
                          Text((state.toolStock.indexOf(item) + 1).toString())),
                      // DataCell(PopupMenuButton(
                      //   position: PopupMenuPosition.under,
                      //   itemBuilder: (context) {
                      //     return item.date!.split(',').map((i) {
                      //       return PopupMenuItem<String>(child: Text(i));
                      //     }).toList();
                      //   },
                      // )),
                      DataCell(Text(item.toolcode.toString())),
                      DataCell(Text(item.qty.toString())),
                      DataCell(BlocBuilder<ToolsBloc, ToolsState>(
                        buildWhen: (previous, current) =>
                            previous.toolStock != current.toolStock,
                        builder: (context, state) {
                          return TextField(
                            controller: returnQtyController[rowIndex],
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(13),
                                // border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.edit,
                                  color: AppColors.appTheme,
                                )),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[-.]')),
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                // setState(() {
                                //   returnedQtyMap[rowIndex] =int.parse(value);
                                // });
                                if (int.parse(returnQtyController[rowIndex]!
                                            .text) >
                                        item.qty! ||
                                    int.parse(returnQtyController[rowIndex]!
                                            .text) ==
                                        0) {
                                  showAlertDialog(context,
                                      message: "Check Quantity");
                                }
                              } else {
                                // returnedQtyMap[rowIndex] = 0;
                              }
                            },
                          );
                        },
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.whiteTheme,
                                  backgroundColor: AppColors.appTheme),

                              //returnedQtyMap[rowIndex] != 0 && returnedQtyMap[rowIndex]! <= item.qty! //onPressed conditions
                              onPressed: returnQtyController[rowIndex]!
                                              .text !=
                                          "" &&
                                      int.parse(returnQtyController[rowIndex]!
                                              .text) !=
                                          0 &&
                                      int.parse(returnQtyController[rowIndex]!
                                              .text) <=
                                          item.qty!
                                  ? () {
                                      if (returnQtyController[rowIndex]!
                                          .text
                                          .isNotEmpty) {
                                        if (int.parse(returnQtyController[
                                                        rowIndex]!
                                                    .text) !=
                                                0 &&
                                            int.parse(returnQtyController[
                                                        rowIndex]!
                                                    .text) <=
                                                item.qty!) {
                                          BlocProvider.of<ToolsBloc>(context)
                                              .add(ToolsReceiveEvent(
                                                  empId: employeeId,
                                                  toolStock: item,
                                                  returnQty: int.parse(
                                                      returnQtyController[
                                                              rowIndex]!
                                                          .text)));

                                          QuickFixUi.successMessage(
                                              "Received Successfully.",
                                              context);
                                          // setState(() {
                                          returnQtyController[rowIndex]!.text =
                                              "";
                                          // });
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text("Returned")),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.whiteTheme,
                                  backgroundColor: AppColors.appTheme),
                              onPressed: returnQtyController[rowIndex]!
                                              .text !=
                                          "" &&
                                      int.parse(returnQtyController[rowIndex]!
                                              .text) !=
                                          0 &&
                                      int.parse(returnQtyController[rowIndex]!
                                              .text) <=
                                          item.qty!
                                  ? () async {
                                      if (returnQtyController[rowIndex]!
                                          .text
                                          .isNotEmpty) {
                                        if (int.parse(returnQtyController[
                                                        rowIndex]!
                                                    .text) !=
                                                0 &&
                                            int.parse(returnQtyController[
                                                        rowIndex]!
                                                    .text) <=
                                                item.qty!) {
                                          Map<String, String>? reasonVal =
                                              await showReasonDialog(context);

                                          if (!context.mounted) return;
                                          if (reasonVal != null) {
                                            BlocProvider.of<ToolsBloc>(context)
                                                .add(ToolsDamageEvent(
                                                    empId: employeeId,
                                                    toolStock: item,
                                                    returnQty: int.parse(
                                                        returnQtyController[
                                                                rowIndex]!
                                                            .text),
                                                    reason: reasonVal));

                                            QuickFixUi.successMessage(
                                                "Received Successfully.",
                                                context);

                                            returnQtyController[rowIndex]!
                                                .text = "";
                                          }
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text("Damage")),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.whiteTheme,
                                  backgroundColor: AppColors.appTheme),
                              onPressed: returnQtyController[rowIndex]!
                                              .text !=
                                          "" &&
                                      int.parse(returnQtyController[rowIndex]!
                                              .text) !=
                                          0 &&
                                      int.parse(returnQtyController[rowIndex]!
                                              .text) <=
                                          item.qty!
                                  ? () {
                                      if (returnQtyController[rowIndex]!
                                          .text
                                          .isNotEmpty) {
                                        if (int.parse(returnQtyController[
                                                        rowIndex]!
                                                    .text) !=
                                                0 &&
                                            int.parse(returnQtyController[
                                                        rowIndex]!
                                                    .text) <=
                                                item.qty!) {
                                          BlocProvider.of<ToolsBloc>(context)
                                              .add(ToolsDamageEvent(
                                                  empId: employeeId,
                                                  toolStock: item,
                                                  returnQty: int.parse(
                                                      returnQtyController[
                                                              rowIndex]!
                                                          .text),
                                                  reason: const {
                                                "reasonType": "wornout"
                                              }));

                                          QuickFixUi.successMessage(
                                              "Received Successfully.",
                                              context);
                                          // setState(() {
                                          returnQtyController[rowIndex]!.text =
                                              "";
                                          // });
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text("Wornout"))
                        ],
                      )),
                    ]);
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String?> showAlertDialog(BuildContext context,
      {required String message}) {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop("");
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  Future<String?> showReasonDialogOld(BuildContext context) {
    String reason = '';
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select Reason"),
            content: DropdownMenu<String>(
              hintText: "select",
              dropdownMenuEntries: toolDamageReasons
                  .map((item) => DropdownMenuEntry(value: item, label: item))
                  .toList(),
              onSelected: (value) {
                reason = value!;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(reason);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  Future<Map<String, String>?> showReasonDialog(BuildContext context) {
    TextEditingController txtRemark = TextEditingController();
    Map<String, String> map = {};
    String reasonType = '';
    return showDialog<Map<String, String>>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select Reason"),
            content: SizedBox(
              width: 400,
              height: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 300,
                    child: DropdownMenu<String>(
                      hintText: "select",
                      dropdownMenuEntries: toolDamageReasons
                          .map((item) =>
                              DropdownMenuEntry(value: item, label: item))
                          .toList(),
                      onSelected: (value) {
                        reasonType = value!;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: txtRemark,
                      decoration: const InputDecoration(
                          hintText: "Remark",
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5)),
                          focusedBorder: OutlineInputBorder()),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    map['reasonType'] = reasonType;
                    map['remark'] = txtRemark.text;
                    Navigator.of(context).pop(map);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }
}
