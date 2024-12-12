import 'package:de/bloc/ppc/capacity_plan/bloc/graph_bloc/graph_view_bloc.dart';
import 'package:de/services/model/capacity_plan/model.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:de/view/widgets/custom_datatable.dart';
import 'package:de/view/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../bloc/ppc/capacity_plan/bloc/workstationshift_bloc/workstationshift_bloc.dart';

class BarChartCapacityPlan extends StatefulWidget {
  const BarChartCapacityPlan({Key? key}) : super(key: key);

  @override
  BarChartCapacityPlanState createState() => BarChartCapacityPlanState();
}

class BarChartCapacityPlanState extends State<BarChartCapacityPlan> {
  // late List<WorkcentreCP> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int cpDays = 0;
    BlocProvider.of<GraphViewBloc>(context).add(GraphViewInitEvent());
    SizeConfig.init(context);
    return Scaffold(
        appBar: CustomAppbar().appbar(context: context, title: 'Bar Chart'),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
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
                            BlocProvider.of<GraphViewBloc>(context).add(
                                GraphViewLoadEvent(runnumber: e!.runnumber!));

                            DateFormat format = DateFormat("dd-MM-yyyy");
                            DateTime toDate = format.parse(e.capacityPlanName!
                                .split(' - ')[1]
                                .split(' To ')[1]);
                            DateTime fromDate = format.parse(e.capacityPlanName!
                                .split(' - ')[1]
                                .toString()
                                .split(' To ')[0]);
                            cpDays = toDate.difference(fromDate).inDays;
                          },
                        );
                      } else {
                        return const Text("data");
                      }
                    },
                  ),
                ),
                /*Container(
                  margin: const EdgeInsets.only(left: 30, top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return BlocProvider(
                      //     create: (context) => WorkstationShiftBloc(),
                      //     child: const WorkcentreAvailableTime(),
                      //   );
                      // }));
                    },
                    child: const Text("Workcentre Shift Time"),
                  ),
                )*/
              ],
            ),
            BlocBuilder<GraphViewBloc, GraphViewState>(
                builder: (context, state) {
              if (state is GraphViewLoadState) {
                return SizedBox(
                  height: SizeConfig.screenHeight!,
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.zero,
                          width: SizeConfig.screenWidth! * 0.5,
                          height: SizeConfig.screenHeight! * 0.6,
                          child: SfCartesianChart(
                              primaryXAxis: const CategoryAxis(),
                              tooltipBehavior: _tooltip,
                              legend: const Legend(
                                position: LegendPosition.top,
                                isVisible: true,
                              ),
                              series: <CartesianSeries<WorkcentreCP, String>>[
                                ColumnSeries<WorkcentreCP, String>(
                                    dataSource: state.wclist,
                                    xValueMapper: (WorkcentreCP data, _) =>
                                        data.code,
                                    yValueMapper: (WorkcentreCP data, _) =>
                                        data.wcRequiredTime! / 450,
                                    name: 'Required Time',
                                    color: Colors.blue[600]),
                                ColumnSeries<WorkcentreCP, String>(
                                    dataSource: state.wclist,
                                    xValueMapper: (WorkcentreCP data, _) =>
                                        data.code,
                                    yValueMapper: (WorkcentreCP data, _) =>
                                        data.wcUtilizedTime! / 450,
                                    name: 'Utilized Time',
                                    color: Colors.green[600])
                              ]),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: SizeConfig.screenWidth! * 0.8,
                            height: SizeConfig.screenHeight! * 0.7,
                            // color: Colors.green[600],
                            child: CustomDataTable(
                              tableBorder: const TableBorder(
                                  top: BorderSide(width: 0.7),
                                  bottom: BorderSide(width: 0.7),
                                  right: BorderSide(width: 0.8),
                                  left: BorderSide(width: 0.8),
                                  horizontalInside: BorderSide(width: 0.5)),
                              columnNames: const [
                                "Workcentre",
                                "Shift Time\n(min/day)",
                                "CP Days",
                                "Total Shift\n(min)",
                                "CP Time\n(min)",
                                "Extra Time\n(min)",
                                "No of Shifts"
                              ],
                              rows: state.shiftTotal
                                  .map((e) => DataRow(cells: [
                                        DataCell(Text(e.workcentre!.code!)),
                                        DataCell(Text(e.shiftTotal.toString())),
                                        DataCell(Text(cpDays.toString())),
                                        DataCell(
                                            Text("${e.shiftTotal! * cpDays}")),
                                        DataCell(Text(state.wclist
                                            .where((item) =>
                                                item.id == e.workcentre!.id)
                                            .single
                                            .wcRequiredTime
                                            .toString())),
                                        DataCell(Text(
                                            "${(e.shiftTotal! * cpDays) - state.wclist.where((item) => item.id == e.workcentre!.id).single.wcRequiredTime!}")),
                                        DataCell(Text(
                                            ((e.shiftTotal! * cpDays) / 450)
                                                .toStringAsFixed(4))),
                                      ]))
                                  .toList(),
                            )
                            // Column(
                            //     children: state.shiftTotal.map((e) {
                            //   return CustomText(
                            //       "${e.workcentre!.code.toString()} : ${e.shiftTotal}");
                            // }).toList())
                            )
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            })
          ],
        ));
  }
}

class WorkcentreAvailableTime extends StatelessWidget {
  const WorkcentreAvailableTime({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    BlocProvider.of<WorkstationShiftBloc>(context).add(GetWorkcentreEvent());
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: [
            BlocBuilder<WorkstationShiftBloc, WorkstationShiftState>(
              builder: (context, state) {
                if (state is WorkstationShiftLoadState) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 150, right: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: state.workcentre
                          .map((e) => SizedBox(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<WorkstationShiftBloc>(context)
                                      .add(GetWorkstationShiftEvent(
                                          workcentreId: e.id.toString()));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: const Color.fromARGB(
                                        255, 28, 102, 139)),
                                child: Text(
                                  e.code.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )))
                          .toList(),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 650,
                  margin: const EdgeInsets.only(top: 20),
                  child:
                      BlocBuilder<WorkstationShiftBloc, WorkstationShiftState>(
                    builder: (context, state) {
                      if (state is WorkstationShiftLoadState) {
                        return CustomDataTable(
                            tableBorder: const TableBorder(
                                top: BorderSide(),
                                bottom: BorderSide(),
                                right: BorderSide(),
                                left: BorderSide(),
                                horizontalInside: BorderSide(width: 0.5)),
                            columnNames: const [
                              "Workstation",
                              "Shift 1\n 480 ",
                              "Shift 2\n 450",
                              "Shift 3\n 420"
                            ],
                            rows: state.workstationshift
                                .map((e) => DataRow(cells: [
                                      DataCell(CustomText(
                                          e.workstationDetails!.code!)),
                                      DataCell(Transform.scale(
                                        scale: 1.4,
                                        child: Checkbox(
                                          onChanged: (value) {
                                            context
                                                .read<WorkstationShiftBloc>()
                                                .add(SelectShiftEvent(
                                                    value: value!,
                                                    wsStatusId:
                                                        e.checkboxlist![0].id!,
                                                    workcentreId: e
                                                        .workstationDetails!
                                                        .wrWorkcentreId!));
                                          },
                                          value: e.checkboxlist![0].shiftStatus,
                                        ),
                                      )),
                                      DataCell(Transform.scale(
                                        scale: 1.4,
                                        child: Checkbox(
                                          onChanged: (value) {
                                            context
                                                .read<WorkstationShiftBloc>()
                                                .add(SelectShiftEvent(
                                                    value: value!,
                                                    wsStatusId:
                                                        e.checkboxlist![1].id!,
                                                    workcentreId: e
                                                        .workstationDetails!
                                                        .wrWorkcentreId!));
                                          },
                                          value: e.checkboxlist![1].shiftStatus,
                                        ),
                                      )),
                                      DataCell(Transform.scale(
                                        scale: 1.4,
                                        child: Checkbox(
                                          onChanged: (value) {
                                            context
                                                .read<WorkstationShiftBloc>()
                                                .add(SelectShiftEvent(
                                                    value: value!,
                                                    wsStatusId:
                                                        e.checkboxlist![2].id!,
                                                    workcentreId: e
                                                        .workstationDetails!
                                                        .wrWorkcentreId!));
                                          },
                                          value: e.checkboxlist![2].shiftStatus,
                                        ),
                                      )),
                                    ]))
                                .toList());
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child:
                      BlocBuilder<WorkstationShiftBloc, WorkstationShiftState>(
                    builder: (context, state) {
                      return state is WorkstationShiftLoadState
                          ? CustomText("Total : ${state.total}")
                          : const SizedBox();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
