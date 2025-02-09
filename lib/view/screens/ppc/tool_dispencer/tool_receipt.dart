import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/ppc/tool_dispencer/bloc/tools_bloc.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/custom_datatable.dart';
import '../../../widgets/custom_dropdown.dart';

class ToolsReceipt extends StatelessWidget {
  const ToolsReceipt({super.key});

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
                            BlocProvider.of<ToolsBloc>(context).add(
                                OperatorWiseToolsEvent(employeeId: value!.id!));
                          },
                          hintText: "Operator");
                    },
                  )),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: BlocBuilder<ToolsBloc, ToolsState>(
              builder: (context, state) {
                return CustomDataTable(
                  columnNames: const [
                    "Tool",
                    "Issue Qty",
                    "Issue date",
                    "Receive Qty",
                    "Action",
                  ],
                  rows: state.toolStock.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item.toolId.toString())),
                      DataCell(Text(item.qty.toString())),
                      DataCell(Text(item.date.toString())),
                      DataCell(Text(item.qty.toString())),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.whiteTheme,
                                  backgroundColor: AppColors.appTheme),
                              onPressed: () {},
                              child: const Text("Receive")),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.whiteTheme,
                                  backgroundColor: AppColors.appTheme),
                              onPressed: () {},
                              child: const Text("Damage"))
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
}
