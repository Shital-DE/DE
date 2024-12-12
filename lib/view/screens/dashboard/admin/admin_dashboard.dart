// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
//  import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../bloc/admindashboard/admindashboard_bloc.dart';
import '../../../../bloc/admindashboard/admindashboard_event.dart';
import '../../../../bloc/admindashboard/admindashboard_state.dart';
import '../../../../routes/route_data.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/dashboard/dashboard_model.dart';
// import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;

// import 'timer_service.dart';
// import '../../../../utils/common/buttons.dart';
// import '../../../../utils/common/quickfix_widget.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Dashboardresponsive extends StatefulWidget {
  final List<Programs> programsList;
  const Dashboardresponsive({super.key, required this.programsList});
  @override
  State<Dashboardresponsive> createState() => _DashboardresponsiveState();
}

class _DashboardresponsiveState extends State<Dashboardresponsive> {
  @override
  Widget build(BuildContext context) {
    return // MaterialApp(
        // home:
        Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      // appBar: AppBar(
      //   title: const Text("Dashboard Demo"),
      // ),
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
              // return Admindashboard(
              //   crossAxisCount: 1,
              //   childAspectRatio: 0.9,
              //   context: context,
              // );
            } else if (constraints.maxWidth > 801 &&
                constraints.maxWidth < 1000) {
              return RouteData.getRouteData(context, RouteName.admindashboard, {
                'crossAxisCount': 2,
                'childAspectRatio': 1.0,
                'context': context,
                'programsList': widget.programsList
              });

              // Admindashboard(
              //     crossAxisCount: 2,
              //     childAspectRatio: 1.0,
              //     context: context,
              //     programsList: widget.programsList);
            } else if (constraints.maxWidth > 1001 &&
                constraints.maxWidth < 1400) {
              return RouteData.getRouteData(context, RouteName.admindashboard, {
                'crossAxisCount': 3,
                'childAspectRatio': 1.0,
                'context': context,
                'programsList': widget.programsList
              });
              // Admindashboard(
              //     crossAxisCount: 3,
              //     childAspectRatio: 1.0,
              //     context: context,
              //     programsList: widget.programsList);
            } else {
              return RouteData.getRouteData(context, RouteName.admindashboard, {
                'crossAxisCount': 4,
                'childAspectRatio': 1.0,
                'context': context,
                'programsList': widget.programsList
              });
              // Admindashboard(
              //     crossAxisCount: 4,
              //     childAspectRatio: 1.0,
              //     context: context,
              //     programsList: widget.programsList);
            }
          },
        ),
      ),

      //  ),
    );
  }
}

class Admindashboard extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final BuildContext context;
  final List<Programs> programsList;

  // final TimerService _timerService = TimerService();

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
    // _timerService.startTimer(() => refreshData(context));

    double screenWidth = MediaQuery.of(context).size.width;

    final blocProvider = BlocProvider.of<ADBBloc>(context);
    blocProvider.add(ADBEvent());
    final blocprovidersecond = BlocProvider.of<ADBsecondBloc>(context);
    blocprovidersecond.add(ADBsecondEvent(
        buttonIndex: 0, selectedCentreBotton: 6, dashboardindex: 0));

    // final blocProviderrr = BlocProvider.of<SocketIoDataBloc>(context);
    // blocProviderrr.add(SocketioEvent());

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
                // debugPrint(MediaQuery.of(context).size.width.toString());

                return Scrollbar(
                  thumbVisibility: true, // Vertical scrollbar visibility
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
                                                  10 // For screens less than 500 width
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
                                                          400, // For screens between 500 and 1000 width
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
                                      // width: 350,
                                      // width:
                                      //     MediaQuery.of(context).size.width - 10,
                                      width: MediaQuery.of(context).size.width <
                                              500
                                          ? MediaQuery.of(context).size.width -
                                              10 // For screens less than 500 width
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
                                                      400, // For screens between 500 and 1000 width
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
                                            // Map color for each data points from the data source
                                            pointColorMapper:
                                                (EfficiencyData data, _) =>
                                                    data.color,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                              isVisible: true,
                                              textStyle: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(255, 0, 0,
                                                    0), // Set text color
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
                                          // majorGridLines:
                                          //     const MajorGridLines(width: 0),
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
                                      //  color: const Color.fromARGB(255, 7, 7, 7),
                                      height: 330,
                                      // width: 400,
                                      // width:
                                      //     MediaQuery.of(context).size.width - 10,
                                      width: MediaQuery.of(context).size.width <
                                              500
                                          ? MediaQuery.of(context).size.width -
                                              10 // For screens less than 500 width
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
                                            // Aligns the chart title to left
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
                                              // Explode all the segments
                                              // explodeAll: true,
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                isVisible: true,
                                                textStyle: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255,
                                                      255,
                                                      255,
                                                      255), // Set text color
                                                ),
                                              ))
                                        ],
                                        legend: const Legend(
                                          isVisible: true,
                                          // Overflowing legend content will be wraped
                                          // overflowMode: LegendItemOverflowMode.scroll
                                          position: LegendPosition.bottom,
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            // Set the color for the legend labels
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

                                  /* Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Total Machine Energy Consumption",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Times',
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Container(
                                                height: 150,
                                                // width: 300,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  //color: Color.fromARGB(255, 168, 168, 168),
                                                  color: const Color.fromARGB(
                                                      255, 250, 247, 247),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${state.totalenergy} kWh",
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 241, 150, 31),
                                                      fontFamily: 'Times',
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),*/
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

                  ///),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 45, 190, 235),
                    backgroundColor: Color.fromARGB(255, 215, 216, 216),
                    // value: 0.50,
                  )),
                );
              }
            }),
            BlocBuilder<ADBBloc, ADBState>(
              builder: (context, state) {
                if (state is ADBLoadingState) {
                  return SingleChildScrollView(
                    // delay: const Duration(seconds: 5),
                    // duration: const Duration(seconds: 250),
                    // gap: 2,
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
                                    // width: 390,
                                    // width: MediaQuery.of(context).size.width -
                                    //     10,
                                    width: MediaQuery.of(context).size.width <
                                            500
                                        ? MediaQuery.of(context).size.width -
                                            10 // For screens less than 500 width
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
                                      primaryXAxis: const DateTimeAxis(
                                          // majorGridLines: MajorGridLines(width: 0),
                                          ), // Set X-axis as DateTime

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
                                      ), // Set Y-axis as Numeric
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
                                            isVisible:
                                                true, // Enable data points
                                            color: Color.fromARGB(255, 176, 206,
                                                235), // Customize the color of the markers
                                            shape: DataMarkerType
                                                .horizontalLine, // Shape of the markers (circle, square, etc.)
                                            // borderWidth:
                                            //     1, // Width of the marker border
                                            // borderColor: Color.fromARGB(
                                            //     255,
                                            //     183,
                                            //     215,
                                            //     216), // Color of the marker border
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
                                // width: 350,
                                // width: MediaQuery.of(context).size.width - 10,
                                width: MediaQuery.of(context).size.width < 500
                                    ? MediaQuery.of(context).size.width -
                                        10 // For screens less than 500 width
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
                                      // Map color for each data points from the data source
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
                                    // width: 300,
                                    // width: MediaQuery.of(context).size.width -
                                    //     10,
                                    width: MediaQuery.of(context).size.width <
                                            500
                                        ? MediaQuery.of(context).size.width -
                                            10 // For screens less than 500 width
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
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(15),
                                    //   //color: Color.fromARGB(255, 168, 168, 168),
                                    //   color: const Color.fromARGB(
                                    //       255, 248, 248, 248),
                                    // ),
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
                                      // header: const Text(
                                      //   "Shop Flor Efficiency",
                                      //   style: TextStyle(fontSize: 15,),
                                      // ),
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
                      // value: 0.50,
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
                                            // color: Colors
                                            //     .white, // Set the background color for data labels
                                            textStyle: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 0, 0,
                                                  0), // Set text color
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
                                        // labelRotation: 90
                                        labelIntersectAction:
                                            AxisLabelIntersectAction
                                                .wrap, // Adjust as needed
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
                                  // color: Color.fromARGB(255, 168, 168, 168),
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
                                                        255,
                                                        0,
                                                        0,
                                                        0), // Set text color
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
                                              // labelRotation: 90
                                              labelIntersectAction:
                                                  AxisLabelIntersectAction
                                                      .wrap, // Adjust as needed
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
                      // debugPrint("++-->>");
                      // debugPrint(
                      //     '${state.productionStatusMap['status']}   @@@@@');
                      // debugPrint(
                      //     '${state.productionStatusMap['machineName']}   @@@@@');
                      return Center(
                        child: SelectCard(
                          workstationstatuslist: workstation,
                          // productionStatusMap: state
                          //     .productionStatusMap, // Pass production status map
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
              backgroundColor: const Color.fromARGB(
                  255, 245, 147, 82), // Button background color
              foregroundColor: Colors.white, // Icon color
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
          : null, // Show bottom navigation bar only if screen width is less than 600
    ));
  }

  List<BottomBarItem> get bottomNavigationBarList {
    return [
      BottomBarItem(
        iconData: Icons.home_outlined,
      ),
      // BottomBarItem(
      //   iconData: Icons.chat_outlined,
      // ),
      BottomBarItem(
        iconData: Icons.notifications_outlined,
      ),
      // BottomBarItem(
      //   iconData: Icons.calendar_month_outlined,
      // ),
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

                            // Perform your async operation here
                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 1,
                                selectedCentreBotton: 1,
                                dashboardindex: 0,
                              ),
                            );

                            // After your async operation completes
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

                            // Perform your async operation here
                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 3,
                                selectedCentreBotton: 3,
                                dashboardindex: 0,
                              ),
                            );

                            // After your async operation completes
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

                            // Perform your async operation here
                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 4,
                                selectedCentreBotton: 4,
                                dashboardindex: 0,
                              ),
                            );

                            // After your async operation completes
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

                            // Perform your async operation here
                            BlocProvider.of<ADBsecondBloc>(context).add(
                              ADBsecondEvent(
                                buttonIndex: 5,
                                selectedCentreBotton: 5,
                                dashboardindex: 0,
                              ),
                            );

                            // After your async operation completes
                            processingDMG.add(false);
                          },
                        );
                      },
                    ),
                    // centresbutton(context, 1, 'CNCL'),
                    // centresbutton(context, 2, 'VMC'),
                    // centresbutton(context, 3, 'I-700'),
                    // centresbutton(context, 4, 'MAZAK'),
                    // centresbutton(context, 5, 'DMG'),
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
///
///
//
//

class SelectCard extends StatelessWidget {
  // final Map<String, int> productionStatusMap;
  const SelectCard({
    super.key,
    required this.workstationstatuslist,
    // required this.productionStatusMap,
  });
  final WorkstationStatusModel workstationstatuslist;

  // final int machinestatus;
  @override
  Widget build(BuildContext context) {
    // final blocprovider = BlocProvider.of<ADBBloc>(context);

    // Get the machine name from the workstationstatuslist

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
                  //getCardItem(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Container(
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            // color: Theme.of(context).colorScheme.primaryContainer,
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
                              // Container(
                              //   margin:
                              //       const EdgeInsets.only(left: 10, top: 10),
                              //   child: listtyleWidget(
                              //     color: _getColorForValue(value: 1),
                              //     operation: _getState(value: 1),
                              //   ),
                              // ),
                              /* BlocBuilder<SocketIoDataBloc, Socketiostate>(
                                builder: (context, state) {
                                  if (state is SocketioLoadingState) {
                                    for (var element
                                        in state.socketIODataList) {
                                      debugPrint(
                                          "+++++++++++++++++++++++++++++++++++++++++");
                                      debugPrint(
                                          "${element.machineName}  ${element.state}");
                                    }
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: SocketIOdata(
                                        socketIOData: state.socketIODataList,
                                      ),
                                    );
                                  } else {
                                    return const Stack();
                                  }
                                },
                              ),*/
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

  // Color _getColorForValue({required int value}) {
  //   switch (value) {
  //     case 0:
  //       return Colors.yellow.shade600; // Idel
  //     case 1:
  //       return Colors.green.shade600; // Production
  //     case 898989:
  //       return Colors.red.shade600; // Offline
  //     case 3:
  //       return Colors.orange.shade600; // Other
  //     default:
  //       return Colors.blue.shade600;
  //   }
  // }

  // String _getState({required int value}) {
  //   switch (value) {
  //     case 0:
  //       return 'Idle'; // Idel
  //     case 1:
  //       return 'Productive'; // Production
  //     case 898989:
  //       return 'Offline'; // Offline
  //     case 3:
  //       return 'Other'; // Other
  //     default:
  //       return '';
  //   }
  // }
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
        // style: ButtonStyle(
        //   backgroundColor: MaterialStateProperty.all<Color>(
        //     isSelected
        //         ? Colors.green
        //         : Theme.of(context).primaryColor, // Set your desired colors
        //   ),
        // ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? color
              : Theme.of(context).primaryColor, // Set color based on selection
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
  // const SocketIOdata({super.key, required this.socketIOData});
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
    debugPrint("section one for socket IO--------------------->>>> 1");
  }

  @override
  void dispose() {
    socketIOData.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Column(
        //   children: [
        // Stack(
        //   children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //  children: [
        StreamBuilder<List<MachineSocketIO>>(
      stream: socketIOData.stream,
      builder: (context, datasocket) {
        debugPrint("section one for socket IO--------------------->>>> 2");
        // debugPrint(datasocket.data!.length.toString());
        debugPrint("+++++++++++++++++++++++++++++++++");
        if (datasocket.hasData) {
          for (var element in datasocket.data!) {
            debugPrint(
                'Machine Name222: ${element.machineName}, State: ${element.state}');
          }
        } else if (datasocket.hasError) {
          debugPrint("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
          debugPrint('Error: ${datasocket.error}');
        } else {
          return const CircularProgressIndicator();
        }

        // debugPrint(datasocket.data![0].state.toString());
        if (datasocket.data!.isNotEmpty) {
          // if()
          return listtyleWidget(
              color: _getColorForValue(value: datasocket.data![0].state),
              operation: _getState(value: datasocket.data![0].state));
        } else {
          return const SizedBox();
        }
      },
    );
    //   ]),
    // ]);
  }

  listtyleWidget({required Color color, required String operation}) {
    debugPrint("section one for socket IO--------------------->>>> 3");
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
    debugPrint("section one for socket IO--------------------->>>> 4");
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
    debugPrint("section one for socket IO--------------------->>>> 5");
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
