import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/tool_dispencer/bloc/tools_bloc.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/custom_dropdown.dart';

class ToolIssue extends StatefulWidget {
  const ToolIssue({super.key});

  @override
  State<ToolIssue> createState() => _ToolIssueState();
}

class _ToolIssueState extends State<ToolIssue> {
  TextEditingController txtQty = TextEditingController();
  String toolId = '';
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //         margin: const EdgeInsets.only(top: 40),
          //         padding: const EdgeInsets.only(right: 30),
          //         width: SizeConfig.screenWidth! * 0.3,
          //         child: BlocBuilder<ToolsBloc, ToolsState>(
          //           builder: (context, state) {
          //             return CustomDropdownSearch(
          //                 items: state.operator, //const ['a', 'b', 'c'],
          //                 itemAsString: (i) => i.employeename ?? "",
          //                 onChanged: (value) {},
          //                 hintText: "Operator");
          //           },
          //         )),

          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.only(top: 20, right: 30),
                width: SizeConfig.screenWidth! * 0.35,
                child: BlocBuilder<ToolsBloc, ToolsState>(
                  builder: (context, state) {
                    return CustomDropdownSearch(
                        items: state.tools,
                        itemAsString: (i) => i.manufacturertoolcode ?? "",
                        onChanged: (value) {
                          toolId = value!.id!;
                        },
                        hintText: "Select Tool");
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.only(top: 20, right: 30),
                  width: SizeConfig.screenWidth! * 0.15,
                  child: TextFormField(
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
                padding: const EdgeInsets.only(top: 60),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.whiteTheme,
                        backgroundColor: AppColors.appTheme),
                    onPressed: () {
                      BlocProvider.of<ToolsBloc>(context).add(
                          ToolsIssueReceiveEvent(
                              toolId: toolId, qty: int.parse(txtQty.text)));
                      print(toolId);
                      print(txtQty.text);
                    },
                    child: const Text("Submit")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
