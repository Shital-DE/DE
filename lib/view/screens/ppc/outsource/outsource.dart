// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:de/view/widgets/custom_datatable.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/appbar/appbar_bloc.dart';
import '../../../../bloc/ppc/outsource_inward/outsource_bloc/outsource_bloc.dart';
import '../../../../services/model/po/po_models.dart';
import '../../../../utils/app_colors.dart';
// import '../../../../utils/constant.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/date_range_picker.dart';
import 'challan_pdf.dart';

class OutsourceScreen extends StatefulWidget {
  const OutsourceScreen({super.key});

  @override
  State<OutsourceScreen> createState() => _OutsourceScreenState();
}

class _OutsourceScreenState extends State<OutsourceScreen> {
  TextEditingController searchController = TextEditingController();
  ToggleOption view = ToggleOption.outsource;

  TextEditingController rangeDate = TextEditingController();
  DateRangePickerHelper pickerHelper = DateRangePickerHelper();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: CustomAppbar().appbar(
        context: context,
        title: "Outsource",
      ),
      body: ListView(children: [
        // Row(
        //   children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: SizeConfig.screenWidth,
          height: SizeConfig.blockSizeVertical! * 8,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(right: 40, top: 7),
              width: SizeConfig.screenWidth! * 0.25, //* 0.16, //200,
              height: SizeConfig.screenHeight! * 0.075, //45
              padding: const EdgeInsets.only(left: 10, bottom: 3, right: 5),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(5),
              //     border: Border.all(width: 0.5)),
              child: TextField(
                controller: rangeDate,
                onTap: () async {
                  String selectedDates =
                      (await pickerHelper.rangeDatePicker(context))!;
                  if (selectedDates != '') {
                    rangeDate.text = selectedDates;

                    Future.microtask(() =>
                        BlocProvider.of<OutsourceBloc>(context)
                            .add(OutsourceListEvent(
                          fromDate: rangeDate.text.split('TO')[0],
                          toDate: rangeDate.text.split('TO')[1],
                          option: view,
                        )));
                  }
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.7),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.7),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  contentPadding: EdgeInsets.only(bottom: 6),
                  icon: Icon(
                    Icons.calendar_month_sharp,
                    color: Color(0XFF01579b),
                  ),
                  hintText: "Select Dates",
                  border: InputBorder.none,
                ),
                readOnly: true,
                textAlign: TextAlign.center,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            BlocConsumer<OutsourceBloc, OutsourceState>(
                listener: (context, state) {
              if (state is OutsourceAllListState) {
                view = state.option;
              }
            }, builder: (context, state) {
              if (state is OutsourceAllListState) {
                return SegmentedButton<ToggleOption>(
                  segments: const [
                    ButtonSegment<ToggleOption>(
                      value: ToggleOption.outsource,
                      label: Text('Outsource'),
                    ),
                    ButtonSegment<ToggleOption>(
                      value: ToggleOption.inhouse,
                      label: Text('Inhouse'),
                    )
                  ],
                  selected: <ToggleOption>{view},
                  onSelectionChanged: (Set<ToggleOption> newSelection) {
                    BlocProvider.of<OutsourceBloc>(context)
                        .add(SelectToggleEvent(
                      option: newSelection.first,
                      fromDate: rangeDate.text.split('TO')[0],
                      toDate: rangeDate.text.split('TO')[1],
                      mainList: state.mainList,
                    ));
                  },
                );
              } else {
                return const SizedBox();
              }
            }),
            //   ],
            // ),
          ]),
          //   )
          // ],
        ),
        // Container(
        //   margin: const EdgeInsets.only(top: 0),
        //   child:
        Container(
          height: 420,
          padding: const EdgeInsets.only(left: 5, right: 5),
          margin: const EdgeInsets.only(top: 10),
          child: BlocBuilder<OutsourceBloc, OutsourceState>(
            builder: (context, state) {
              if (state is OutsourceAllListState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CustomSearchDataTable(
                      columnNames: const [
                        'Select',
                        'PO',
                        'Product',
                        'LineItem',
                        'Qty',
                        'Seq',
                        'Process',
                        'Instruction'
                      ],
                      tableBorder: const TableBorder(
                          top: BorderSide(),
                          bottom: BorderSide(),
                          left: BorderSide(),
                          right: BorderSide()),
                      columnIndexForSearchIcon: 2,
                      rows: state.outsourceList
                          .map((e) => DataRow(cells: [
                                DataCell(
                                  Transform.scale(
                                    scale: 1.5,
                                    child: Checkbox(
                                      value: e.isCheck,
                                      onChanged: (value) {
                                        BlocProvider.of<OutsourceBloc>(context)
                                            .add(CheckListItemEvent(
                                                option: state.option,
                                                isCheckVal: value!,
                                                item: e,
                                                subList: state.outsourceList,
                                                mainList: state.mainList));
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(CustomText(e.salesorder!)),
                                DataCell(
                                    CustomText(e.product! + e.revisionnumber!)),
                                DataCell(
                                    CustomText(e.lineitemnumber.toString())),
                                DataCell(
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: Colors.blue,
                                        )),
                                    controller: TextEditingController(
                                        text: e.quantity.toString()),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        e.quantity = int.parse(value);
                                      } else {
                                        e.quantity = e.quantity;
                                      }
                                    },
                                  ),
                                ),
                                DataCell(CustomText(e.sequence.toString())),
                                DataCell(CustomText(e.process ?? "")),
                                DataCell(//CustomText(e.instruction!)
                                    e.processid!.isEmpty
                                        ? TextField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: 2,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                prefixIcon: Icon(
                                                  Icons.edit,
                                                  size: 16,
                                                  color: Colors.blue,
                                                )),
                                            controller: TextEditingController(
                                                text: e.instruction),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                e.instruction = value.trim();
                                              }
                                            },
                                          )
                                        : const SizedBox())
                              ]))
                          .toList(),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          // ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 20),
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<OutsourceBloc, OutsourceState>(
                  builder: (context, state) {
                    if (state is OutsourceAllListState) {
                      return DebouncedButton(
                        onPressed: () {
                          List<Outsource> challanList = [];
                          state.mainList.map((e) {
                            if (e.isCheck == true) {
                              if (e.instruction!.length < 40) {
                                e.instruction = e.instruction;
                              } else {
                                e.instruction = e.instruction!.substring(0, 40);
                              }
                              challanList.add(e);
                              return e;
                            }
                          }).toList();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Selected Products"),
                                  content: Container(
                                      height: SizeConfig.screenHeight! * 0.7,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: previewChallanProducts(
                                            outsourceList: challanList),
                                      )),
                                  actions: [
                                    DebouncedButton(
                                        text: "Close",
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith((states) =>
                                                    const Color(0XFF01579b))))
                                  ],
                                );
                              });
                        },
                        text: "View Products",
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => AppColors.appTheme)),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal,
                ),
                BlocBuilder<OutsourceBloc, OutsourceState>(
                  builder: (context, state) {
                    if (state is OutsourceAllListState) {
                      return DebouncedButton(
                        onPressed: () {
                          List<Outsource> challanList = [];

                          state.mainList.map((e) {
                            if (e.isCheck == true) {
                              if (e.instruction!.length < 40) {
                                e.instruction = e.instruction;
                              } else {
                                e.instruction = e.instruction!.substring(0, 40);
                              }
                              challanList.add(e);

                              return e;
                            }
                          }).toList();
                          if (challanList.isEmpty) {
                            QuickFixUi.errorMessage(
                                "Select product to proceed", context);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (newcontext) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<OutsourceBloc>(
                                        create: (BuildContext context) =>
                                            OutsourceBloc(),
                                      ),
                                      BlocProvider<AppBarBloc>(
                                        create: (BuildContext context) =>
                                            AppBarBloc(),
                                      ),
                                    ],
                                    child:
                                        ChallanPdf(outsourceList: challanList),
                                  ),
                                ));
                          }
                        },
                        text: "Generate Challan",
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => AppColors.appTheme)),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ))
      ]),
    );
  }
}
