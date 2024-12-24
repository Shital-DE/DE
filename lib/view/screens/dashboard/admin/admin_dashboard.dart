// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../bloc/admindashboard/admindashboard_bloc.dart';
import '../../../../bloc/admindashboard/admindashboard_event.dart';
import '../../../../bloc/admindashboard/admindashboard_state.dart';
import '../../../../routes/route_data.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/dashboard/dashboard_model.dart';

class Dashboardresponsive extends StatefulWidget {
  final List<Programs> programsList;
  const Dashboardresponsive({super.key, required this.programsList});
  @override
  State<Dashboardresponsive> createState() => _DashboardresponsiveState();
}

class _DashboardresponsiveState extends State<Dashboardresponsive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 50 && constraints.maxWidth < 820) {
              return RouteData.getRouteData(context, RouteName.admindashboard, {
                'crossAxisCount': 1,
                'childAspectRatio': 0.9,
                'context': context,
                'programsList': widget.programsList
              });
            } else if (constraints.maxWidth > 801 &&
                constraints.maxWidth < 1000) {
              return RouteData.getRouteData(context, RouteName.admindashboard, {
                'crossAxisCount': 2,
                'childAspectRatio': 1.0,
                'context': context,
                'programsList': widget.programsList
              });
            } else if (constraints.maxWidth > 1001 &&
                constraints.maxWidth < 1400) {
              return RouteData.getRouteData(context, RouteName.admindashboard, {
                'crossAxisCount': 3,
                'childAspectRatio': 1.0,
                'context': context,
                'programsList': widget.programsList
              });
            } else {
              return RouteData.getRouteData(context, RouteName.admindashboard, {
                'crossAxisCount': 4,
                'childAspectRatio': 1.0,
                'context': context,
                'programsList': widget.programsList
              });
            }
          },
        ),
      ),
    );
  }
}

class Admindashboard extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final BuildContext context;
  final List<Programs> programsList;

  const Admindashboard(
      {super.key,
      required this.crossAxisCount,
      required this.childAspectRatio,
      required this.context,
      required this.programsList});

  Future<void> refreshData(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final blocProvider = BlocProvider.of<ADBBloc>(context);
    blocProvider.add(ADBEvent());
    final blocprovidersecond = BlocProvider.of<ADBsecondBloc>(context);
    blocprovidersecond.add(ADBsecondEvent(
        buttonIndex: 0, selectedCentreBotton: 6, dashboardindex: 0));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final blocProvider = BlocProvider.of<ADBBloc>(context);
    blocProvider.add(ADBEvent());
    final blocprovidersecond = BlocProvider.of<ADBsecondBloc>(context);
    blocprovidersecond.add(ADBsecondEvent(
        buttonIndex: 0, selectedCentreBotton: 6, dashboardindex: 0));

    StreamController<bool> iscentraloee = StreamController<bool>.broadcast();
    StreamController<bool> ismachinewiseEnergy =
        StreamController<bool>.broadcast();

    final ScrollController horizontalScrollController = ScrollController();
    final ScrollController verticalScrollController = ScrollController();

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshData(context);
        },
        child: ListView(
          children: [
            BlocBuilder<ADBBloc, ADBState>(builder: (context, state) {
              if (state is ADBLoadingState) {
                return Scrollbar(
                  thumbVisibility: true,
                  thickness: 10,
                  controller: horizontalScrollController,
                  child: SingleChildScrollView(
                    controller: horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: 345,
                        child: Column(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 217, 241, 245),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  state.factoryOee.isNotEmpty
                                      ? SizedBox(
                                          height: 330,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  500
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  10
                                              : MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          1000 &&
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width <
                                                          1400
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      900
                                                  : MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          1401
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          1250
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          400,
                                          child: SfCartesianChart(
                                            title: const ChartTitle(
                                              text: 'Factory OEE',
                                              textStyle: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Times',
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                            primaryXAxis: const DateTimeAxis(),
                                            primaryYAxis: const NumericAxis(
                                              title: AxisTitle(
                                                text: 'OEE in %',
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Times',
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            tooltipBehavior: TooltipBehavior(
                                              enable: true,
                                              header: 'OEE',
                                              color: Colors.white,
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            series: <CartesianSeries>[
                                              SplineAreaSeries<FactoryOEE,
                                                  DateTime>(
                                                dataSource: state.factoryOee,
                                                xValueMapper:
                                                    (FactoryOEE data, _) =>
                                                        data.time,
                                                yValueMapper:
                                                    (FactoryOEE data, _) =>
                                                        data.oee,
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    const Color.fromARGB(
                                                            255, 81, 163, 4)
                                                        .withOpacity(0.9),
                                                    const Color.fromARGB(
                                                            255, 46, 197, 8)
                                                        .withOpacity(0.1),
                                                  ],
                                                  stops: const <double>[
                                                    0.0,
                                                    1.0
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                markerSettings:
                                                    const MarkerSettings(
                                                  isVisible: true,
                                                  color: Color.fromARGB(
                                                      255, 176, 206, 235),
                                                  shape: DataMarkerType
                                                      .horizontalLine,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : state.factoryOee.isEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                width: 320,
                                                height: 150,
                                                color: const Color.fromARGB(
                                                    255, 209, 225, 238),
                                                child: Center(
                                                    child: StreamBuilder<bool>(
                                                        stream:
                                                            iscentraloee.stream,
                                                        builder:
                                                            (context, newSnap) {
                                                          if (newSnap.data !=
                                                                  null &&
                                                              newSnap.data ==
                                                                  true) {
                                                            return const Text(
                                                                'Factory OEE not available.',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Text',
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        17));
                                                          } else {
                                                            return const CircularProgressIndicator(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      45,
                                                                      190,
                                                                      235),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          215,
                                                                          216,
                                                                          216),
                                                            );
                                                          }
                                                        })),
                                              ),
                                            )
                                          : const Stack(),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                      height: 340,
                                      width: MediaQuery.of(context).size.width <
                                              500
                                          ? MediaQuery.of(context).size.width -
                                              10
                                          : MediaQuery.of(context).size.width >
                                                      1000 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1400
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  900
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1401
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      1250
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      400,
                                      child: SfCartesianChart(
                                        title: const ChartTitle(
                                          text: 'Centrewise OEE',
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Times',
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                        series: <CartesianSeries>[
                                          ColumnSeries<EfficiencyData, String>(
                                            dataSource: state.centerOEEData,
                                            xValueMapper:
                                                (EfficiencyData data, _) =>
                                                    data.x,
                                            yValueMapper:
                                                (EfficiencyData data, _) =>
                                                    data.y,
                                            pointColorMapper:
                                                (EfficiencyData data, _) =>
                                                    data.color,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                              isVisible: true,
                                              textStyle: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ],
                                        primaryXAxis: const CategoryAxis(
                                          title: AxisTitle(
                                            text: 'Machine workcentre',
                                            textStyle: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Times',
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                          majorGridLines:
                                              MajorGridLines(width: 0),
                                        ),
                                        primaryYAxis: const NumericAxis(
                                          title: AxisTitle(
                                            text: 'OEE in %',
                                            textStyle: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Times',
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        tooltipBehavior: TooltipBehavior(
                                          enable: true,
                                          header: 'OEE',
                                          color: const Color.fromARGB(
                                              255, 248, 248, 248),
                                          textStyle: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 10,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                      height: 330,
                                      width: MediaQuery.of(context).size.width <
                                              500
                                          ? MediaQuery.of(context).size.width -
                                              10
                                          : MediaQuery.of(context).size.width >
                                                      1000 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1400
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  900
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1401
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      1400
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      400,
                                      child: SfCircularChart(
                                        title: const ChartTitle(
                                            text:
                                                'Centre Wise Energy Consumption in kWh',
                                            borderWidth: 2,
                                            alignment: ChartAlignment.center,
                                            textStyle: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Times',
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14,
                                            )),
                                        series: <CircularSeries>[
                                          DoughnutSeries<CentrewiseenergyData,
                                                  String>(
                                              dataSource:
                                                  state.centrewiseenergyData,
                                              xValueMapper:
                                                  (CentrewiseenergyData data,
                                                          _) =>
                                                      data.x,
                                              yValueMapper:
                                                  (CentrewiseenergyData data,
                                                          _) =>
                                                      data.y,
                                              explode: true,
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                isVisible: true,
                                                textStyle: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ))
                                        ],
                                        legend: const Legend(
                                          isVisible: true,
                                          position: LegendPosition.bottom,
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      )),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blue),
                                                child: const Icon(
                                                  Icons.lightbulb,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  'Energy Usage',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontFamily: 'Times',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 18),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Divider(
                                              thickness: 3.0,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .calendar_today_rounded,
                                                    color: Colors.green,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text.rich(TextSpan(
                                                      text: 'Today\n',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                '${state.totalenergy} kWh',
                                                            style: Theme
                                                                    .of(context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        243,
                                                                        86,
                                                                        86),
                                                                    fontFamily:
                                                                        'Times',
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        23))
                                                      ]))
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    color: Colors.purple,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'This Month\n',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${(state.machineMonthwiseEnergyConsumption / 1000).toStringAsFixed(2)} kWh',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayLarge!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      243,
                                                                      86,
                                                                      86),
                                                                  fontFamily:
                                                                      'Times',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: 23),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 45, 190, 235),
                    backgroundColor: Color.fromARGB(255, 215, 216, 216),
                  )),
                );
              }
            }),
            BlocBuilder<ADBBloc, ADBState>(
              builder: (context, state) {
                if (state is ADBLoadingState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 330,
                      child: Container(
                        color: const Color.fromARGB(255, 224, 224, 248),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            state.factoryEfficency.isNotEmpty
                                ? SizedBox(
                                    height: 330,
                                    width: MediaQuery.of(context).size.width <
                                            500
                                        ? MediaQuery.of(context).size.width - 10
                                        : MediaQuery.of(context).size.width >
                                                    1000 &&
                                                MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    1400
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                910
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    1401
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    1250
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    400,
                                    child: SfCartesianChart(
                                      title: const ChartTitle(
                                        text: 'Factory Efficiency',
                                        textStyle: TextStyle(
                                          color: Colors.red,
                                          fontFamily: 'Times',
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                      primaryXAxis: const DateTimeAxis(),
                                      primaryYAxis: const NumericAxis(
                                        title: AxisTitle(
                                          text: 'efficincy in %',
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Times',
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      tooltipBehavior: TooltipBehavior(
                                        enable: true,
                                        header: 'efficiency',
                                        color: Colors.white,
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      series: <CartesianSeries>[
                                        SplineAreaSeries<FactoryEfficency,
                                            DateTime>(
                                          dataSource: state.factoryEfficency,
                                          xValueMapper:
                                              (FactoryEfficency data, _) =>
                                                  data.endTime,
                                          yValueMapper:
                                              (FactoryEfficency data, _) =>
                                                  data.efficency,
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              const Color.fromARGB(
                                                      255, 20, 137, 206)
                                                  .withOpacity(0.9),
                                              const Color.fromARGB(
                                                      255, 20, 137, 206)
                                                  .withOpacity(0.1),
                                            ],
                                            stops: const <double>[0.0, 1.0],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          markerSettings: const MarkerSettings(
                                            isVisible: true,
                                            color: Color.fromARGB(
                                                255, 176, 206, 235),
                                            shape:
                                                DataMarkerType.horizontalLine,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : state.factoryEfficency.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          width: 320,
                                          height: 150,
                                          color: const Color.fromARGB(
                                              255, 209, 225, 238),
                                          child: Center(
                                              child: StreamBuilder<bool>(
                                                  stream: iscentraloee.stream,
                                                  builder: (context, newSnap) {
                                                    if (newSnap.data != null &&
                                                        newSnap.data == true) {
                                                      return const Text(
                                                          'Factory efficiency not available.',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Text',
                                                              color: Colors.red,
                                                              fontSize: 17));
                                                    } else {
                                                      return const CircularProgressIndicator(
                                                        color: Color.fromARGB(
                                                            255, 45, 190, 235),
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                215, 216, 216),
                                                      );
                                                    }
                                                  })),
                                        ),
                                      )
                                    : const Stack(),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                                height: 330,
                                width: MediaQuery.of(context).size.width < 500
                                    ? MediaQuery.of(context).size.width - 10
                                    : MediaQuery.of(context).size.width >
                                                1000 &&
                                            MediaQuery.of(context).size.width <
                                                1400
                                        ? MediaQuery.of(context).size.width -
                                            910
                                        : MediaQuery.of(context).size.width >
                                                1401
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                1250
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                400,
                                child: SfCartesianChart(
                                  title: const ChartTitle(
                                    text: 'CentreWise efficiency',
                                    textStyle: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Times',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                  series: <CartesianSeries>[
                                    ColumnSeries<EfficiencyData, String>(
                                      dataSource: state.centerEfficencyData,
                                      xValueMapper: (EfficiencyData data, _) =>
                                          data.x,
                                      yValueMapper: (EfficiencyData data, _) =>
                                          data.y,
                                      pointColorMapper:
                                          (EfficiencyData data, _) =>
                                              data.color,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true),
                                    ),
                                  ],
                                  primaryXAxis: const CategoryAxis(
                                    title: AxisTitle(
                                      text: 'Machine workcentre',
                                      textStyle: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Times',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    title: AxisTitle(
                                      text: 'efficiency in %',
                                      textStyle: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Times',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Factory Average Efficiency",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Times',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 288,
                                    width: MediaQuery.of(context).size.width <
                                            500
                                        ? MediaQuery.of(context).size.width - 10
                                        : MediaQuery.of(context).size.width >
                                                    1000 &&
                                                MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    1400
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                910
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    1401
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    1450
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    400,
                                    child: CircularPercentIndicator(
                                      radius: 90,
                                      lineWidth: 20,
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      progressColor: const Color.fromARGB(
                                          255, 112, 193, 231),
                                      percent: state.shopefficiency / 100,
                                      center: Text(
                                        "${state.shopefficiency}%",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      animation: true,
                                      animationDuration: 1000,
                                      onAnimationEnd: () {},
                                      startAngle: 180,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 45, 190, 235),
                      backgroundColor: Color.fromARGB(255, 215, 216, 216),
                    )),
                  );
                }
              },
            ),
            BlocBuilder<ADBsecondBloc, ADBsecondState>(
                builder: (context, state) {
              if (state is ADBsecondLoadingState) {
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: workcentreButtons(context),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        child: Row(
                          children: [
                            state.wsefficiencyData.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color.fromARGB(
                                          255, 248, 248, 248),
                                    ),
                                    height: 350,
                                    width: 350,
                                    child: SfCartesianChart(
                                      title: const ChartTitle(
                                        text: 'Machinewise Efficiency',
                                        textStyle: TextStyle(
                                          color: Colors.red,
                                          fontFamily: 'Times',
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                      series: <CartesianSeries>[
                                        ColumnSeries<EfficiencyData, String>(
                                          dataSource: state.wsefficiencyData,
                                          xValueMapper:
                                              (EfficiencyData data, _) =>
                                                  data.x,
                                          yValueMapper:
                                              (EfficiencyData data, _) =>
                                                  data.y,
                                          pointColorMapper:
                                              (EfficiencyData data, _) =>
                                                  data.color,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                            isVisible: true,
                                            textStyle: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ),
                                      ],
                                      primaryXAxis: const CategoryAxis(
                                        title: AxisTitle(
                                          text: 'Machines',
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Times',
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                        labelIntersectAction:
                                            AxisLabelIntersectAction.wrap,
                                      ),
                                      primaryYAxis: const NumericAxis(
                                        title: AxisTitle(
                                          text: 'Efficiency in %',
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Times',
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      tooltipBehavior: TooltipBehavior(
                                        enable: true,
                                        header: 'Eficiency',
                                        color: const Color.fromARGB(
                                            255, 248, 248, 248),
                                        textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ))
                                : state.buttonIndex != 0
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          width: 320,
                                          height: 150,
                                          color: const Color.fromARGB(
                                              255, 209, 225, 238),
                                          child: Center(
                                              child: StreamBuilder<bool>(
                                                  stream: iscentraloee.stream,
                                                  builder: (context, newSnap) {
                                                    if (newSnap.data != null &&
                                                        newSnap.data == true) {
                                                      return const Text(
                                                          'efficincy Data not available.',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Text',
                                                              color: Colors.red,
                                                              fontSize: 17));
                                                    } else {
                                                      return const CircularProgressIndicator(
                                                        color: Color.fromARGB(
                                                            255, 45, 190, 235),
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                215, 216, 216),
                                                      );
                                                    }
                                                  })),
                                        ),
                                      )
                                    : const Stack(),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 248, 248, 248),
                                ),
                                child: Row(children: [
                                  state.machinewiseenergyData.isNotEmpty
                                      ? SizedBox(
                                          height: 350,
                                          width: 350,
                                          child: SfCartesianChart(
                                            title: const ChartTitle(
                                              text: 'Machinewise Energy in kWh',
                                              textStyle: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Times',
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                            series: <CartesianSeries>[
                                              ColumnSeries<
                                                  MachinewiseenergyData,
                                                  String>(
                                                dataSource:
                                                    state.machinewiseenergyData,
                                                xValueMapper:
                                                    (MachinewiseenergyData data,
                                                            _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (MachinewiseenergyData data,
                                                            _) =>
                                                        data.y,
                                                pointColorMapper:
                                                    (MachinewiseenergyData data,
                                                            _) =>
                                                        data.color,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                  isVisible: true,
                                                  textStyle: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            primaryXAxis: const CategoryAxis(
                                              title: AxisTitle(
                                                text: 'Machines',
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Times',
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              labelIntersectAction:
                                                  AxisLabelIntersectAction.wrap,
                                            ),
                                            primaryYAxis: const NumericAxis(
                                              title: AxisTitle(
                                                text: 'Energy in kWh',
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Times',
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            tooltipBehavior: TooltipBehavior(
                                              enable: true,
                                              header: 'Energy',
                                              color: const Color.fromARGB(
                                                  255, 248, 248, 248),
                                              textStyle: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ))
                                      : state.buttonIndex != 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                width: 320,
                                                height: 150,
                                                color: const Color.fromARGB(
                                                    255, 209, 225, 238),
                                                child: Center(
                                                    child: StreamBuilder<bool>(
                                                        stream:
                                                            ismachinewiseEnergy
                                                                .stream,
                                                        builder:
                                                            (context, newSnap) {
                                                          if (newSnap.data !=
                                                                  null &&
                                                              newSnap.data ==
                                                                  true) {
                                                            return const Text(
                                                                'Energy Data not available.',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Text',
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        17));
                                                          } else {
                                                            return const CircularProgressIndicator(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      45,
                                                                      190,
                                                                      235),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          215,
                                                                          216,
                                                                          216),
                                                            );
                                                          }
                                                        })),
                                              ),
                                            )
                                          : const Stack(),
                                ])),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      )),
                  GridView.count(
                    childAspectRatio: 3 / 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 0.1,
                    mainAxisSpacing: 0.1,
                    children: List.generate(state.workstationstatuslist2.length,
                        (index) {
                      var workstation = state.workstationstatuslist2[index];

                      return Center(
                        child: SelectCard(
                          workstationstatuslist: workstation,
                        ),
                      );
                    }),
                  ),
                ]);
              } else {
                return const Stack();
              }
            }),
          ],
        ),
        //),
      ),
      floatingActionButton: screenWidth > 1300
          ? FloatingActionButton(
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 1000));
                final blocProvider = BlocProvider.of<ADBBloc>(context);
                blocProvider.add(ADBEvent());
                final blocprovidersecond =
                    BlocProvider.of<ADBsecondBloc>(context);
                blocprovidersecond.add(ADBsecondEvent(
                    buttonIndex: 0,
                    selectedCentreBotton: 6,
                    dashboardindex: 0));
              },
              backgroundColor: const Color.fromARGB(255, 245, 147, 82),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.refresh),
            )
          : null,
      bottomNavigationBar: screenWidth < 450
          ? BottomBarDoubleBullet(
              items: bottomNavigationBarList,
              onSelect: (index) {
                switch (index) {
                  case 0:
                    {}
                    break;
                  case 1:
                    {}
                    break;
                  case 2:
                    {}
                    break;
                  case 3:
                    {
                      Navigator.pushNamed(context, RouteName.dashboardUtility,
                          arguments: {'programsList': programsList});
                    }
                    break;
                  default:
                }
              },
            )
          : null,
    ));
  }

  List<BottomBarItem> get bottomNavigationBarList {
    return [
      BottomBarItem(
        iconData: Icons.home_outlined,
      ),
      BottomBarItem(
        iconData: Icons.notifications_outlined,
      ),
      BottomBarItem(
        iconData: Icons.settings_outlined,
      ),
      BottomBarItem(
        iconData: Icons.auto_awesome_mosaic,
      ),
    ];
  }

  workcentreButtons(BuildContext context) {
    StreamController<bool> processingCNC = StreamController<bool>.broadcast();
    StreamController<bool> processingVMC = StreamController<bool>.broadcast();
    StreamController<bool> processingI700 = StreamController<bool>.broadcast();
    StreamController<bool> processingMAZAK = StreamController<bool>.broadcast();
    StreamController<bool> processingDMG = StreamController<bool>.broadcast();
    return BlocBuilder<ADBsecondBloc, ADBsecondState>(
      builder: (context, state) {
        if (state is ADBsecondLoadingState) {
          return SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<bool>(
                      stream: processingCNC.stream,
                      builder: (context, snapshot) {
                        return ShiftButton(
                          label: 'CNCL',
                          shiftIndex: 1,
                          isSelected: state.selectedCentreBotton == 1,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: snapshot.data != null && snapshot.data == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('CNCL'),
                          onPressed: () async {
                            processingCNC.add(true);

                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 1,
                                selectedCentreBotton: 1,
                                dashboardindex: 0,
                              ),
                            );

                            processingCNC.add(false);
                          },
                        );
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: processingVMC.stream,
                      builder: (context, snapshot) {
                        return ShiftButton(
                          label: 'VMC',
                          shiftIndex: 2,
                          isSelected: state.selectedCentreBotton == 2,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: snapshot.data != null && snapshot.data == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('VMC'),
                          onPressed: () async {
                            processingVMC.add(true);
                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 2,
                                selectedCentreBotton: 2,
                                dashboardindex: 0,
                              ),
                            );
                            processingVMC.add(false);
                          },
                        );
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: processingI700.stream,
                      builder: (context, snapshot) {
                        return ShiftButton(
                          label: 'I-700',
                          shiftIndex: 3,
                          isSelected: state.selectedCentreBotton == 3,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: snapshot.data != null && snapshot.data == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('I-700'),
                          onPressed: () async {
                            processingI700.add(true);

                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 3,
                                selectedCentreBotton: 3,
                                dashboardindex: 0,
                              ),
                            );

                            processingI700.add(false);
                          },
                        );
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: processingCNC.stream,
                      builder: (context, snapshot) {
                        return ShiftButton(
                          label: 'MAZAK',
                          shiftIndex: 4,
                          isSelected: state.selectedCentreBotton == 4,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: snapshot.data != null && snapshot.data == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('MAZAK'),
                          onPressed: () async {
                            processingMAZAK.add(true);

                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 4,
                                selectedCentreBotton: 4,
                                dashboardindex: 0,
                              ),
                            );
                            processingMAZAK.add(false);
                          },
                        );
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: processingCNC.stream,
                      builder: (context, snapshot) {
                        return ShiftButton(
                          label: 'DMG',
                          shiftIndex: 5,
                          isSelected: state.selectedCentreBotton == 5,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: snapshot.data != null && snapshot.data == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('DMG'),
                          onPressed: () async {
                            processingDMG.add(true);
                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 5,
                                selectedCentreBotton: 5,
                                dashboardindex: 0,
                              ),
                            );
                            processingDMG.add(false);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SelectCard extends StatelessWidget {
  const SelectCard({
    super.key,
    required this.workstationstatuslist,
  });
  final WorkstationStatusModel workstationstatuslist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(context, RouteName.machinedashboard,
            arguments: {'workstationstatuslist': workstationstatuslist});
      },
      child: Container(
          height: 275,
          width: 375,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          // ),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  workstationstatuslist.machinename.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Times',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Image(
                              width: 90,
                              image: NetworkImage(
                                  'https://tiimg.tistatic.com/fp/1/007/207/vmc-machine-job-work-936.jpg'),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 181,
                                width: 253,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 252, 252, 252),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Product No :- ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: 'Times',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              workstationstatuslist
                                                          .productcode !=
                                                      null
                                                  ? workstationstatuslist
                                                      .productcode
                                                      .toString()
                                                      .trim()
                                                  : '--',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 17, 17, 16),
                                                fontSize: 16,
                                                fontFamily: 'Times',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'PO No:-',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontFamily: 'Times',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              workstationstatuslist.pono != null
                                                  ? workstationstatuslist.pono
                                                      .toString()
                                                      .trim()
                                                  : '--',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 17, 17, 16),
                                                fontSize: 16,
                                                fontFamily: 'Times',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Operation No:-',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontFamily: 'Times',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 110,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              workstationstatuslist.seqno !=
                                                      null
                                                  ? workstationstatuslist.seqno
                                                      .toString()
                                                      .trim()
                                                  : '--',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 17, 17, 16),
                                                fontSize: 16,
                                                fontFamily: 'Times',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'PO QTY:-',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontFamily: 'Times',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              workstationstatuslist.qty != null
                                                  ? workstationstatuslist.qty
                                                      .toString()
                                                      .trim()
                                                  : '--',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 17, 17, 16),
                                                fontSize: 16,
                                                fontFamily: 'Times',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Operator:-',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontFamily: 'Times',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              workstationstatuslist
                                                          .employeename !=
                                                      null
                                                  ? workstationstatuslist
                                                      .employeename
                                                      .toString()
                                                      .trim()
                                                  : '--',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 17, 17, 16),
                                                fontSize: 16,
                                                fontFamily: 'Times',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'StartTime :-',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontFamily: 'Times',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              workstationstatuslist
                                                          .startprocesstime !=
                                                      null
                                                  ? DateTime.parse(
                                                          workstationstatuslist
                                                              .startprocesstime!)
                                                      .toLocal()
                                                      .toString()
                                                      .substring(0, 19)
                                                      .trim()
                                                  : '-',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 17, 17, 16),
                                                fontSize: 16,
                                                fontFamily: 'Times',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Status:- ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontFamily: 'Times',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              workstationstatuslist
                                                          .endprocessflag !=
                                                      null
                                                  ? workstationstatuslist
                                                              .endprocessflag
                                                              .toString() ==
                                                          "1"
                                                      ? 'Completed'
                                                      : 'In-progress'
                                                  : '--',
                                              style: TextStyle(
                                                  color: workstationstatuslist
                                                              .endprocessflag
                                                              .toString() ==
                                                          "1"
                                                      ? Colors.green
                                                      : Colors.orange,
                                                  fontSize: 16,
                                                  fontFamily: 'Times',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
          )),
    );
  }

  listtyleWidget({required Color color, required String operation}) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: CircleAvatar(
            backgroundColor: color,
            radius: 6,
          ),
        ),
        const SizedBox(width: 3),
        Text(operation),
      ]),
    );
  }
}

// ShiftButton widget
class ShiftButton extends StatelessWidget {
  final String label;
  final int shiftIndex;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color color;

  const ShiftButton({
    Key? key,
    required this.label,
    required this.shiftIndex,
    required this.isSelected,
    required this.onPressed,
    required this.color,
    required Widget child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Theme.of(context).primaryColor,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AutofillHints.birthday,
            fontStyle: FontStyle.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class SocketIOdata extends StatefulWidget {
  final List<MachineSocketIO> socketIOData;

  const SocketIOdata({super.key, required this.socketIOData});
  @override
  State<SocketIOdata> createState() => SocketIOdataState();
}

class SocketIOdataState extends State<SocketIOdata> {
  StreamController<List<MachineSocketIO>> socketIOData =
      StreamController<List<MachineSocketIO>>.broadcast();

  @override
  void initState() {
    super.initState();
    socketIOData.add(widget.socketIOData);
  }

  @override
  void dispose() {
    socketIOData.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MachineSocketIO>>(
      stream: socketIOData.stream,
      builder: (context, datasocket) {
        if (datasocket.hasData) {
        } else if (datasocket.hasError) {
        } else {
          return const CircularProgressIndicator();
        }

        if (datasocket.data!.isNotEmpty) {
          return listtyleWidget(
              color: _getColorForValue(value: datasocket.data![0].state),
              operation: _getState(value: datasocket.data![0].state));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  listtyleWidget({required Color color, required String operation}) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: CircleAvatar(
            backgroundColor: color,
            radius: 6,
          ),
        ),
        const SizedBox(width: 3),
        Text(operation),
      ]),
    );
  }

  Color _getColorForValue({required int value}) {
    switch (value) {
      case 0:
        return Colors.yellow.shade600; // Idel
      case 1:
        return Colors.green.shade600; // Production
      case 898989:
        return Colors.red.shade600; // Offline
      case 3:
        return Colors.orange.shade600; // Other
      default:
        return Colors.blue.shade600;
    }
  }

  String _getState({required int value}) {
    switch (value) {
      case 0:
        return 'Idle'; // Idel
      case 1:
        return 'Productive'; // Production
      case 898989:
        return 'Offline'; // Offline
      case 3:
        return 'Other'; // Other
      default:
        return '';
    }
  }
}
