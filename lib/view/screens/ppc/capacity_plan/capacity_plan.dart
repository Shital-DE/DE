import 'dart:ui';
import 'package:de/bloc/ppc/capacity_plan/bloc/capacity_bloc/capacity_plan_bloc.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/capacity_plan/bloc/graph_bloc/graph_view_bloc.dart';
import '../../../../services/model/capacity_plan/model.dart';
import '../../../../utils/app_theme.dart';
import '../../../widgets/custom_datatable.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/date_range_picker.dart';

class CapacityPlan extends StatefulWidget {
  const CapacityPlan({super.key});

  @override
  State<CapacityPlan> createState() => _CapacityPlanState();
}

class _CapacityPlanState extends State<CapacityPlan> {
  List<DataRow> rows = [];
  TextEditingController rangeDate = TextEditingController();
  DateRangePickerHelper pickerHelper = DateRangePickerHelper();

  @override
  void dispose() {
    rangeDate.dispose();
    rows.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: 'Capacity Plan'),
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight! * 0.075, //45
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 40, top: 8),
                width: SizeConfig.screenWidth! * 0.25, //200,

                child: BlocListener<CapacityPlanBloc, CapacityPlanState>(
                  listener: (context, state) {
                    state is CapacityPlanInitial
                        ? rangeDate.clear()
                        : rangeDate;
                  },
                  child: TextField(
                    controller: rangeDate,
                    onTap: () async {
                      String selectedDates =
                          (await pickerHelper.rangeDatePicker(context))!;
                      if (selectedDates != '') {
                        rangeDate.text = selectedDates;

                        if (!context.mounted) return;
                        BlocProvider.of<CapacityPlanBloc>(context)
                            .add(ToDateGetEvent(
                          fromDate: rangeDate.text.split('TO')[0],
                          toDate: rangeDate.text.split('TO')[1],
                        ));
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
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                width: SizeConfig.screenWidth! * 0.12, //200,

                child: DebouncedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => const Color(0xFF1978a5))),
                  onPressed: () {
                    rangeDate.clear();

                    BlocProvider.of<CapacityPlanBloc>(context)
                        .add(CpInitialEvent());
                  },
                  text: "Clear",
                ),
              ),
              BlocBuilder<CapacityPlanBloc, CapacityPlanState>(
                  builder: (context, state) {
                if (state is CapacityPlanListState ||
                    state is CheckDateInitial && state.cplist.isEmpty != true) {
                  return Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: SizeConfig.screenWidth! * 0.12,
                      child: DebouncedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => const Color(0xFF1978a5))),
                        onPressed: () {
                          List<CapacityPlanData> checkedList = state.cplist
                              .where((e) => (e.checkboxval as bool) == true)
                              .toList();
                          bool routeCheck = checkedList
                              .every((element) => element.route!.isNotEmpty);
                          if (checkedList.isNotEmpty && routeCheck == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (newcontext) => BlocProvider.value(
                                          value:
                                              BlocProvider.of<CapacityPlanBloc>(
                                                  context),
                                          child: CPGenerationView(
                                            checklist: state.cplist
                                                .where((element) =>
                                                    (element.checkboxval
                                                            as bool &&
                                                        element.route!
                                                            .isNotEmpty) ==
                                                    true)
                                                .toList(),
                                            cplist: state.cplist,
                                          ),
                                        )));
                          } else {
                            QuickFixUi.errorMessage(
                                "Select route filled products", context);
                          }
                        },
                        text: "New CP",
                      ));
                } else {
                  return const SizedBox();
                }
              }),
              BlocBuilder<CapacityPlanBloc, CapacityPlanState>(
                  builder: (context, state) {
                if (state is CapacityPlanListState ||
                    state is CheckDateInitial && state.cplist.isEmpty != true) {
                  return Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: SizeConfig.screenWidth! * 0.12,
                      child: DebouncedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => const Color(0xFF1978a5))),
                        onPressed: () {
                          List<CapacityPlanData> checkedList = state.cplist
                              .where((e) => (e.checkboxval as bool) == true)
                              .toList();
                          bool routeCheck = checkedList
                              .every((element) => element.route!.isNotEmpty);
                          if (checkedList.isNotEmpty && routeCheck == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (newcontext) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                                value: BlocProvider.of<
                                                    CapacityPlanBloc>(context)),
                                            BlocProvider<GraphViewBloc>(
                                                create:
                                                    (BuildContext context) =>
                                                        GraphViewBloc())
                                          ],
                                          child: CPUpdateView(
                                            checklist: state.cplist
                                                .where((element) =>
                                                    (element.checkboxval
                                                            as bool &&
                                                        element.route!
                                                            .isNotEmpty) ==
                                                    true)
                                                .toList(),
                                            cplist: state.cplist,
                                          ),
                                        )));
                          } else {
                            QuickFixUi.errorMessage(
                                "Select route filled products", context);
                          }
                        },
                        text: "Update CP",
                      ));
                } else {
                  return const SizedBox();
                }
              }),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.zero,
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight! * 0.72,
          child: BlocBuilder<CapacityPlanBloc, CapacityPlanState>(
            builder: (context, state) {
              if (state is CapacityPlanListState || state is CheckDateInitial) {
                rows = state.cplist
                    .map((e) => DataRow(cells: [
                          DataCell(Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                onChanged: (value) {
                                  setState(() {
                                    e.checkboxval = value!;
                                  });
                                },
                                value: e.checkboxval,
                              ))),
                          DataCell(Text(e.po.toString(),
                              style: AppTheme.tableRowTextStyle())),
                          DataCell(Text(e.productcode.toString(),
                              style: AppTheme.tableRowTextStyle())),
                          DataCell(Text(e.revisionNo.toString(),
                              style: AppTheme.tableRowTextStyle())),
                          DataCell(Text(e.lineitemnumber.toString(),
                              style: AppTheme.tableRowTextStyle())),
                          DataCell(Text(e.orderedqty.toString(),
                              style: AppTheme.tableRowTextStyle())),
                          DataCell(Text(e.plandate.toString(),
                              style: AppTheme.tableRowTextStyle())),
                          DataCell(TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(actions: [
                                        Container(
                                            width: 600,
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: Column(
                                              children: [
                                                DataTable(
                                                    columns: const [
                                                      DataColumn(
                                                          label:
                                                              Text("Sequence")),
                                                      DataColumn(
                                                          label: Text(
                                                              "Workcentre")),
                                                      DataColumn(
                                                          label: Text(
                                                              "Setuptime(min)")),
                                                      DataColumn(
                                                          label: Text(
                                                              "Runtime(Min)")),
                                                    ],
                                                    rows: e.route!
                                                        .map((item) =>
                                                            DataRow(cells: [
                                                              DataCell(Text(item
                                                                  .sequencenumber
                                                                  .toString())),
                                                              DataCell(Text(item
                                                                  .workcentre
                                                                  .toString())),
                                                              DataCell(Text(item
                                                                  .setuptimemins
                                                                  .toString())),
                                                              DataCell(Text(item
                                                                  .runtimemins
                                                                  .toString())),
                                                            ]))
                                                        .toList()),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "close")),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ]);
                                    });
                              },
                              child: Text(
                                "Route",
                                style: AppTheme.tableRowTextStyle().copyWith(
                                    color: e.route?.isNotEmpty == true
                                        ? const Color.fromARGB(
                                            255, 36, 151, 228)
                                        : const Color.fromARGB(
                                            255, 228, 42, 36)),
                              )))
                        ]))
                    .toList();
                return paginatedTable(rows);
              } else if (state is CapacityPlanInitial) {
                rows = paginatedTableList(state, context);
                return paginatedTable(rows);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ]),
    );
  }

  Widget paginatedTable(List<DataRow> rows) {
    return CustomPaginatedTable(
      columnIndexForSearchIcon: 1,
      columnNames: const [
        'Select',
        'PO',
        'Product',
        'RevisionNo',
        'LineItemNo',
        'Qty',
        'PlanDate',
        'Workcentre-Route'
      ],
      rowData: rows,
    );
  }
}

class CPGenerationView extends StatelessWidget {
  final List<CapacityPlanData> checklist, cplist;
  const CPGenerationView(
      {super.key, required this.checklist, required this.cplist});
  @override
  Widget build(BuildContext context) {
    TextEditingController cpDate = TextEditingController();
    DateRangePickerHelper pickerHelper = DateRangePickerHelper();
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 40, top: 8),
                width: SizeConfig.screenWidth! * 0.25, //* 0.16, //200,
                height: SizeConfig.screenHeight! * 0.075, //45

                child: BlocListener<CapacityPlanBloc, CapacityPlanState>(
                  listener: (context, state) {
                    if (state is CheckDateInitial) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(state.message),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      cpDate.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          });
                    }
                  },
                  child: TextField(
                    controller: cpDate,
                    onTap: () async {
                      String cpDates =
                          (await pickerHelper.rangeDatePicker(context))!;

                      if (cpDates != '') {
                        cpDate.text = cpDates;

                        if (!context.mounted) return;
                        BlocProvider.of<CapacityPlanBloc>(context).add(
                            CheckPreviousCPDateEvent(
                                fromDate: cpDates.split('TO')[0].trim(),
                                cpList: cplist));
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
                      hintText: "Select CP Dates",
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DebouncedButton(
                  text: "Save",
                  onPressed: () {
                    if (cpDate.text.isNotEmpty) {
                      BlocProvider.of<CapacityPlanBloc>(context).add(
                          SaveCPEvent(
                              fromDate: cpDate.text.split('TO')[0],
                              toDate: cpDate.text.split('TO')[1],
                              cpList: checklist));
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                              child: AlertDialog(
                                icon: const Icon(Icons.check_circle),
                                content: const Text(
                                  "Capacity Plan Saved",
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        cpDate.clear();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        cplist.clear();
                                        checklist.clear();
                                      },
                                      child: const Text("OK"))
                                ],
                              ),
                            );
                          });
                    } else {
                      QuickFixUi.errorMessage("Select Dates", context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => const Color(0XFF01579b))))
            ],
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            height: SizeConfig.screenHeight! * 0.7,
            child: SingleChildScrollView(
              child: CustomDataTable(
                columnNames: const [
                  'SrNo',
                  'PO',
                  'Product',
                  'LineItemNo',
                  'Qty',
                  'PlanDate',
                ],
                rows: checklist
                    .map((e) => DataRow(cells: [
                          DataCell(Text((checklist.indexOf(e) + 1).toString())),
                          DataCell(Text(e.po.toString())),
                          DataCell(Text(e.productcode.toString())),
                          DataCell(Text(e.lineitemnumber.toString())),
                          DataCell(Text(e.orderedqty.toString())),
                          DataCell(Text(e.plandate.toString())),
                        ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CPUpdateView extends StatelessWidget {
  final List<CapacityPlanData> checklist, cplist;
  const CPUpdateView(
      {super.key, required this.checklist, required this.cplist});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GraphViewBloc>(context).add(GraphViewInitEvent());
    String fromDate = '', toDate = '';
    int runnumber = 0;

    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, right: 30, bottom: 5),
                width: SizeConfig.blockSizeHorizontal! * 25,
                child: BlocBuilder<GraphViewBloc, GraphViewState>(
                  builder: (context, state) {
                    if (state is GraphViewLoadState ||
                        state is GraphViewInitial) {
                      return CustomDropdownSearch<CapacityPlanList>(
                        items: state.cpList!,
                        hintText: "Select CP",
                        itemAsString: (item) => item.capacityPlanName!,
                        onChanged: (e) {
                          fromDate = e!.fromDate!;
                          toDate = e.toDate!;
                          runnumber = e.runnumber!;
                        },
                      );
                    } else {
                      return const Text("data");
                    }
                  },
                ),
              ),
              DebouncedButton(
                  text: "Update",
                  onPressed: () {
                    if (runnumber != 0) {
                      BlocProvider.of<CapacityPlanBloc>(context).add(
                          UpdateCPEvent(
                              fromDate: fromDate,
                              toDate: toDate,
                              runnumber: runnumber,
                              cpList: checklist));
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                              child: AlertDialog(
                                icon: const Icon(Icons.check_circle),
                                content: const Text(
                                  "Capacity Plan Updated",
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        checklist.clear();
                                        cplist.clear();

                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"))
                                ],
                              ),
                            );
                          });
                    } else {
                      QuickFixUi.errorMessage("Select Capacity Plan", context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => const Color(0XFF01579b))))
            ],
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            height: SizeConfig.screenHeight! * 0.7,
            child: SingleChildScrollView(
              child: CustomDataTable(
                columnNames: const [
                  'SrNo',
                  'PO',
                  'Product',
                  'LineItemNo',
                  'Qty',
                  'PlanDate',
                ],
                rows: checklist
                    .map((e) => DataRow(cells: [
                          DataCell(Text((checklist.indexOf(e) + 1).toString())),
                          DataCell(Text(e.po.toString())),
                          DataCell(Text(e.productcode.toString())),
                          DataCell(Text(e.lineitemnumber.toString())),
                          DataCell(Text(e.orderedqty.toString())),
                          DataCell(Text(e.plandate.toString())),
                        ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
