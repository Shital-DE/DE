// ignore_for_file: use_build_context_synchronously

import 'package:de/bloc/ppc/capacity_plan/cubit/plandate_change/plandate_cubit.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/constant.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/custom_datatable.dart';

class POPlanDate extends StatefulWidget {
  const POPlanDate({super.key});

  @override
  State<POPlanDate> createState() => _POPlanDateState();
}

class _POPlanDateState extends State<POPlanDate> {
  TextEditingController searchController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    void onSearchButtonPressed() {
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Change Customer PO Date '),
      body: ListView(
        children: [
          // First Row
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: SizeConfig.blockSizeHorizontal! * 20,
                  margin: EdgeInsets.only(
                      top: 20, left: SizeConfig.screenWidth! / 2.6, right: 20),
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.number,
                    // TextEditingController(text: state.po.toString()),
                    decoration: const InputDecoration(
                      labelText: 'Enter Customer PO',
                      border: OutlineInputBorder(),
                    ),

                    // onChanged: (value) {
                    //   if (value.isNotEmpty) {
                    //     searchController.text = value;
                    //   }
                    // },
                  )),
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                ),
                child: DebouncedButton(
                  onPressed: () async {
                    await BlocProvider.of<PlanDateCubit>(context)
                        .searchPO(po: searchController.text);
                    onSearchButtonPressed();
                  },
                  text: 'Search',
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => const Color(0xFF1978a5))),
                ),
              ),
            ],
          ),

          // Second Row
          BlocBuilder<PlanDateCubit, PlanDateState>(
            builder: (context, state) {
              if (state is POPlanDateLoad) {
                dateController.text = state.so.plandate ?? "";
                return Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: 40, left: SizeConfig.screenWidth! / 2.6),
                        width: SizeConfig.blockSizeHorizontal! * 20,
                        child: TextField(
                          controller:
                              TextEditingController(text: state.so.plandate),
                          // dateController,
                          onTap: () async {
                            DateTime? picked = await dateTimePicker(context);
                            if (picked.toString() != 'null') {
                              dateController.text =
                                  picked.toString().split(' ')[0];
                              state.so.plandate =
                                  picked.toString().split(' ')[0];
                              await BlocProvider.of<PlanDateCubit>(context)
                                  .editallPOPlanDate(
                                      poid: state.so.salesorderid!,
                                      plandate: dateController.text,
                                      po: state.so.salesorder!);
                            } else {
                              dateController.text = state.so.plandate!;
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'PO Date',
                            prefixIcon: Icon(
                              Icons.calendar_month_sharp,
                              color: Color(0XFF01579b),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          textAlign: TextAlign.center,
                        )),
                  ],
                );
              } else {
                return const Text("");
              }
            },
          ),

          // Third Row - DataTable with border
          BlocBuilder<PlanDateCubit, PlanDateState>(
            builder: (context, state) {
              if (state is POPlanDateLoad) {
                return Container(
                    margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
                    width: SizeConfig.screenWidth,
                    // padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: CustomDataTable(
                      columnNames: const [
                        'Product',
                        'Revision No',
                        'LineItemNo',
                        'PO Product Date'
                      ],
                      rows: state.so.salesOrderDetails!
                          .map(
                            (e) => DataRow(cells: [
                              DataCell(CustomText(e.product.toString())),
                              DataCell(CustomText(e.revisionNumber.toString())),
                              DataCell(CustomText(e.lineitemnumber.toString())),
                              DataCell(TextField(
                                readOnly: true,
                                controller:
                                    TextEditingController(text: e.plandate),
                                onTap: () async {
                                  DateTime? picked =
                                      await dateTimePicker(context);
                                  if (picked.toString() != 'null') {
                                    e.plandate =
                                        picked.toString().split(' ')[0];
                                    await BlocProvider.of<PlanDateCubit>(
                                            context)
                                        .editsinglePOProductPlanDate(
                                            soDeails: e,
                                            po: state.po.toString());
                                  } else {
                                    dateController.text = state.so.plandate!;
                                  }
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.calendar_month_sharp,
                                      color: Color(0XFF01579b),
                                    ),
                                    border: InputBorder.none),
                              )),
                            ]),
                          )
                          .toList(),
                    ));
              } else if (state is POLoadError) {
                return Center(
                    child: Text(
                  state.message.toString(),
                  style: const TextStyle(color: Colors.red, fontSize: 20),
                ));
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
