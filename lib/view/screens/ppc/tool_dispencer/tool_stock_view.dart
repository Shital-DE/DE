import 'package:de/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/app_colors.dart';
import '../../../widgets/custom_datatable.dart';
import '../../../widgets/custom_dropdown.dart';

class ToolStockView extends StatefulWidget {
  const ToolStockView({super.key});

  @override
  State<ToolStockView> createState() => _ToolStockViewState();
}

class _ToolStockViewState extends State<ToolStockView> {
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 30),
                  width: SizeConfig.screenWidth! * 0.35,
                  child: CustomDropdownSearch(
                      items: const ['a', 'b', 'c'],
                      itemAsString: (i) => i,
                      onChanged: (value) {},
                      hintText: "Select Tool")),
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 30),
                  width: SizeConfig.screenWidth! * 0.15,
                  child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        hintText: "Qty",
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ))),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.whiteTheme,
                        backgroundColor: AppColors.appTheme),
                    onPressed: () {},
                    child: const Text("Submit")),
              ),
            ]),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const CustomDataTable(
                columnNames: ["Tool", "Manufacture", "Total Qty", "Date"],
                rows: [
                  DataRow(cells: [
                    DataCell(Text("drill")),
                    DataCell(Text("aaa")),
                    DataCell(Text("10")),
                    DataCell(Text("01/01/2025")),
                  ])
                ],
              ),
            )
          ],
        ));
  }
}
