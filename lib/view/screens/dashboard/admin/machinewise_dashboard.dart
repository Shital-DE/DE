// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:de/bloc/machinewisedashboard/machinewisedashboard_bloc.dart';

import '../../../../bloc/machinewisedashboard/machinewisedashboard_event.dart';
import '../../../../bloc/machinewisedashboard/machinewisedashboard_state.dart';

import '../../../../services/model/dashboard/dashboard_model.dart';
import '../../../../services/repository/dashboard/dashboard_repository.dart';
import '../../../../utils/common/buttons.dart';
import '../../../../utils/common/quickfix_widget.dart';
// import '../../../../utils/constant.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
// import '../../../widgets/date_range_picker.dart';

// ignore: must_be_immutable
class MachinewiseDashboard extends StatelessWidget {
  final WorkstationStatusModel workstationstatuslist;

  MachinewiseDashboard({
    super.key,
    required this.workstationstatuslist,
  });

  final int crossAxisCount = 3;

  StreamController<bool> iscyclerun = StreamController<bool>.broadcast();
  StreamController<bool> isPI = StreamController<bool>.broadcast();
  StreamController<bool> isfeeddata = StreamController<bool>.broadcast();
  TextEditingController dashboardDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WorkstationStatusModel workstationstatus = workstationstatuslist;

    final blocprovider = BlocProvider.of<MachinewiseDashboardBloc>(context);
    blocprovider.add(MWDEvent(
        workstationstatus: workstationstatus, switchIndex: 1, chooseDate: ''));

    return Scaffold(
      appBar: CustomAppbar().appbar(
          context: context, title: "${workstationstatuslist.machinename}"),
      body: Container(
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(0),
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        width: MediaQuery.of(context).size.width,
        child: MakeMeResponsiveScreen(
          //   windows: machinewisedashbord(blocProvider, context),
          windows: machinewisedashbordTablet(context, blocprovider),
          //  horixontaltab: machinewisedashbord(blocProvider, context),
          horixontaltab: machinewisedashbordTablet(context, blocprovider),
          mobile: machinewisedashbordMobile(context, blocprovider),
        ),
      ),
      floatingActionButton: MediaQuery.of(context).size.width > 1300
          ? FloatingActionButton(
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 1000));
                final blocProvider =
                    BlocProvider.of<MachinewiseDashboardBloc>(context);
                blocProvider.add(MWDEvent(
                  workstationstatus: workstationstatuslist,
                  switchIndex: 1,
                  chooseDate: '',
                ));
                dashboardDate.text = '';
              },
              backgroundColor: const Color.fromARGB(
                  255, 245, 147, 82), // Button background color
              foregroundColor: Colors.white, // Icon color
              shape: const CircleBorder(),
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }

  Future<void> refreshData(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final blocProvider = BlocProvider.of<MachinewiseDashboardBloc>(context);
    blocProvider.add(MWDEvent(
      workstationstatus: workstationstatuslist,
      switchIndex: 1,
      chooseDate: '',
    ));
    dashboardDate.text = '';
  }

  machinewisedashbordTablet(
      BuildContext context, MachinewiseDashboardBloc blocprovider) {
    late ZoomPanBehavior feedzomber;
    late ZoomPanBehavior currentchartZoomer;
    late ZoomPanBehavior voltagechartZoomer;
    feedzomber = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true);
    currentchartZoomer = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true);
    voltagechartZoomer = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true);

    StreamController<bool> processing24hr = StreamController<bool>.broadcast();
    // DateRangePickerHelper pickerHelper = DateRangePickerHelper();

    return BlocBuilder<MachinewiseDashboardBloc, MWDState>(
        builder: (context, state) {
      processincycylerun(
          iscyclerun: iscyclerun, isPI: isPI, isfeeddata: isfeeddata);
      if (state is MWDLoadingState) {
        return RefreshIndicator(
          onRefresh: () async {
            await refreshData(context);
          },
          child: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    //  padding: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: workcentreButtons(context),
                        ),
                      ),
                      StreamBuilder<Object>(
                          stream: processing24hr.stream,
                          builder: (context, snapshot) {
                            return Center(
                              child: SizedBox(
                                  height: 60,
                                  width: 375,
                                  child: ShiftButton(
                                    label: "24 hr",
                                    shiftIndex: 4,
                                    isSelected: state.selectedShift == 4,
                                    onPressed: () {
                                      processing24hr.add(true);
                                      BlocProvider.of<MachinewiseDashboardBloc>(
                                              context)
                                          .add(MWDEvent(
                                              switchIndex: 4,
                                              workstationstatus:
                                                  workstationstatuslist,
                                              chooseDate: state.chooseDate));
                                      BlocProvider.of<MachinewiseDashboardBloc>(
                                          context);
                                      processing24hr.add(false);
                                      // Navigator.pushNamed(
                                      //     context, RouteName.machinedashboard,
                                      //     arguments: {
                                      //       'workstationstatuslist':
                                      //           workstationstatuslist
                                      //     });
                                    },
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: snapshot.data != null &&
                                            snapshot.data == true
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : const Text('24 hr'),
                                  )),
                            );
                          }),

                      SizedBox(
                          child: Center(
                        child: Text(
                            // "${state.currentDate}
                            "${state.starttime}  To  ${state.endtime}",
                            style: const TextStyle(
                                //fontFamily: 'Text',
                                fontFamily: AutofillHints.birthday,
                                color: Colors.deepOrange,
                                fontSize: 18)),
                      )),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                          child: Text(
                        'Production Cycle',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Times',
                          fontStyle: FontStyle.normal,
                          fontSize: 30,
                        ),
                      )),

                      SizedBox(
                        height: 200.0,
                        child: ProductionCycleBar(
                            machinename: state.machinename.toString(),
                            uicurrentdate: state.currentDate,
                            productionCycleBarData:
                                state.productionCycleBarData),
                      ),
                      /* SizedBox(
                        height: 70.0,
                        child: state.cs.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8.0),
                                controller: ScrollController(),
                                itemCount: state.cs.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return ProductionCycleBar(
                                      machinename: state.machinename);
                              
                                  /* SizedBox(
                                    width: 350.0 / (state.cs.length),
                                    child: Tooltip(
                                      message:
                                          //'''Shift: ${_getShiftFromUnix(DateTime.fromMillisecondsSinceEpoch(_data['data']['445DnU']['data']['sub_period_data'][index]['ts']))}
                                          // '''Time: ${DateTime.fromMillisecondsSinceEpoch(dataList[index])}
                                          '''Time: ${state.cs[index].x}
                                              state:${state.cs[index].y}''',
                                      // Operation Name:
                                      // Component: ''',
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        margin: const EdgeInsets.all(0.0),
                                        color: state.cs[index].y == 1 ||
                                                state.cs[index].y == 3
                                            ? const Color.fromARGB(255, 0, 95, 3)
                                            : state.cs[index].y != 0 ||
                                                    state.cs[index].y == 2
                                                ? Colors.red
                                                : Colors.yellow,
                                      ),
                                    ),
                                  );*/
                                },
                              )
                            : state.cs.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      width: 320,
                                      height: 150,
                                      color:
                                          const Color.fromARGB(255, 209, 225, 238),
                                      child: Center(
                                          child: StreamBuilder<bool>(
                                              stream: iscyclerun.stream,
                                              builder: (context, newSnap) {
                                                if (newSnap.data != null &&
                                                    newSnap.data == true) {
                                                  return const Text(
                                                      'cycle run not available.',
                                                      style: TextStyle(
                                                          fontFamily: 'Text',
                                                          color: Colors.red,
                                                          fontSize: 18));
                                                } else {
                                                  return const CircularProgressIndicator(
                                                    color: Color.fromARGB(
                                                        255, 45, 190, 235),
                                                    backgroundColor: Color.fromARGB(
                                                        255, 215, 216, 216),
                                                  );
                                                }
                                              })),
                                    ),
                                  )
                                : const Stack(),
                      ),*/
                      // Container(
                      //   width: 700,
                      //   height: 160,
                      //   child: Center(
                      //     child: ColorDisplayWidget(dataList: dataList),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      if ( //state.wstagid != null &&
                          state.wstagid[0].productionTime == "Y")
                        Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                height: 413,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 253, 251, 251),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        'Production Time',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Times',
                                          fontStyle: FontStyle.normal,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          state.productiontimeData.isNotEmpty
                                              ? Container(
                                                  height: 300,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: const Color.fromARGB(
                                                        255, 212, 212, 212),
                                                  ),
                                                  child: SfCircularChart(
                                                    series: <CircularSeries>[
                                                      RadialBarSeries<
                                                          ProductiontimeData,
                                                          String>(
                                                        dataSource: state
                                                            .productiontimeData,
                                                        xValueMapper:
                                                            (ProductiontimeData
                                                                        data,
                                                                    _) =>
                                                                data.x,
                                                        yValueMapper:
                                                            (ProductiontimeData
                                                                        data,
                                                                    _) =>
                                                                data.y,
                                                        dataLabelSettings:
                                                            const DataLabelSettings(
                                                                isVisible:
                                                                    true),
                                                      )
                                                    ],
                                                    legend: const Legend(
                                                        isVisible: true,
                                                        position: LegendPosition
                                                            .auto),
                                                  ))
                                              : state.productiontimeData.isEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Container(
                                                        width: 320,
                                                        height: 150,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 209, 225, 238),
                                                        child: Center(
                                                            child: StreamBuilder<
                                                                    bool>(
                                                                stream:
                                                                    isPI.stream,
                                                                builder: (context,
                                                                    newSnap) {
                                                                  if (newSnap.data !=
                                                                          null &&
                                                                      newSnap.data ==
                                                                          true) {
                                                                    return const Text(
                                                                        'Production & Idle time not available.',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Text',
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize: 17));
                                                                  } else {
                                                                    return const CircularProgressIndicator(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          45,
                                                                          190,
                                                                          235),
                                                                      backgroundColor: Color.fromARGB(
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(
                        height: 20,
                      ),

                      if (state.wstagid[0].feedRate == "Y")
                        Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                height: 413,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // color: const Color.fromARGB(255, 134, 133, 133),
                                  //  color: Color.fromARGB(255, 209, 166, 166),
                                  color:
                                      const Color.fromARGB(255, 253, 251, 251),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1),
                                      child: SizedBox(
                                          //height: 40,
                                          child: Text(
                                        'Feed rate',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Times',
                                          fontStyle: FontStyle.normal,
                                          fontSize: 30,
                                        ),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          state.feedData.isNotEmpty
                                              ? Container(
                                                  height: 300,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    //color: Color.fromARGB(255, 168, 168, 168),
                                                    color: const Color.fromARGB(
                                                        255, 212, 212, 212),
                                                  ),
                                                  child: SfCartesianChart(
                                                      zoomPanBehavior:
                                                          feedzomber,
                                                      // primaryXAxis: const DateTimeAxis(
                                                      //     enableAutoIntervalOnZooming:
                                                      //         true),
                                                      tooltipBehavior:
                                                          TooltipBehavior(
                                                              header: '',
                                                              enable: true),
                                                      // tooltipBehavior: TooltipBehavior(
                                                      //   enable: true,
                                                      //   header: '',
                                                      //   color: const Color.fromARGB(
                                                      //       255, 99, 130, 184),
                                                      //   textStyle: TextStyle(
                                                      //       color: Colors.white),
                                                      //   format: 'Feed : point.y',
                                                      // ),
                                                      primaryXAxis:
                                                          const DateTimeAxis(
                                                        enableAutoIntervalOnZooming:
                                                            true,
                                                        title: AxisTitle(
                                                          text: 'Time',
                                                          textStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      primaryYAxis:
                                                          const NumericAxis(
                                                        title: AxisTitle(
                                                          text: 'Feed',
                                                          textStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      series: <CartesianSeries>[
                                                        // Renders step line chart
                                                        StepLineSeries<FeedData,
                                                                DateTime>(
                                                            dataSource:
                                                                state.feedData,
                                                            xValueMapper:
                                                                (FeedData data,
                                                                        _) =>
                                                                    data.x,
                                                            yValueMapper:
                                                                (FeedData data,
                                                                        _) =>
                                                                    data.y)
                                                      ]))
                                              : state.feedData.isEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Center(
                                                        child: Container(
                                                          width: 300,
                                                          height: 250,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              209, 225, 238),
                                                          child: Center(
                                                              child: StreamBuilder<
                                                                      bool>(
                                                                  stream: isPI
                                                                      .stream,
                                                                  builder: (context,
                                                                      newSnap) {
                                                                    if (newSnap.data !=
                                                                            null &&
                                                                        newSnap.data ==
                                                                            true) {
                                                                      return const Text(
                                                                          'Feed data not available...!',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Text',
                                                                              color: Colors.red,
                                                                              fontSize: 17));
                                                                    } else {
                                                                      return const CircularProgressIndicator(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            45,
                                                                            190,
                                                                            235),
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            216,
                                                                            216),
                                                                      );
                                                                    }
                                                                  })),
                                                        ),
                                                      ),
                                                    )
                                                  : const Stack(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),

                      if (state.wstagid[0].efficiency == "Y")
                        Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                height: 430,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // color: const Color.fromARGB(255, 134, 133, 133),
                                  //color: Color.fromARGB(255, 209, 166, 166),
                                  color:
                                      const Color.fromARGB(255, 253, 251, 251),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        child: Text(
                                      'Efficiency',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Times',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 30,
                                      ),
                                    )),
                                    Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: state.efficiency.isNaN
                                            ? Row(
                                                children: [
                                                  Container(
                                                    height: 300,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      //color: Color.fromARGB(255, 168, 168, 168),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              212,
                                                              212,
                                                              212),
                                                    ),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 120,
                                                      lineWidth: 30,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      progressColor: Colors.red,
                                                      // percent: state.efficiency / 100,
                                                      center: const Text(
                                                        "0 %",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      animation: true,
                                                      animationDuration: 500,
                                                      onAnimationEnd: () {},
                                                      startAngle: 180,
                                                      // header: const Text(
                                                      //   "Efficiency",
                                                      //   style: TextStyle(
                                                      //     fontSize: 30,
                                                      //   ),
                                                      // ),
                                                    ),
                                                  ),
                                                  // const SizedBox(
                                                  //   width: 15,
                                                  // ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Container(
                                                    height: 300,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      //color: Color.fromARGB(255, 168, 168, 168),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              212,
                                                              212,
                                                              212),
                                                    ),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 120,
                                                      lineWidth: 30,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      progressColor: Colors.red,
                                                      percent:
                                                          state.efficiency /
                                                              100,
                                                      center: Text(
                                                        "${state.efficiency}%",
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      animation: true,
                                                      animationDuration: 500,
                                                      onAnimationEnd: () {},
                                                      startAngle: 180,
                                                      // header: const Text(
                                                      //   "Efficiency",
                                                      //   style: TextStyle(fontSize: 30),
                                                      // ),
                                                    ),
                                                  ),
                                                  // const SizedBox(
                                                  //   width: 15,
                                                  // ),
                                                ],
                                              ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),

                      if (state.wstagid[0].currentSpike == "Y")
                        Column(children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 415,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                // color: const Color.fromARGB(255, 134, 133, 133),
                                //  color: Color.fromARGB(255, 209, 166, 166),
                                color: const Color.fromARGB(255, 253, 251, 251),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50.0),
                                    child: SizedBox(
                                        //height: 40,
                                        child: Text(
                                      'Machine Current ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Times',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 30,
                                      ),
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        state.currentspikes.isNotEmpty
                                            ? Container(
                                                height: 300,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  //color: Color.fromARGB(255, 168, 168, 168),
                                                  color: const Color.fromARGB(
                                                      255, 212, 212, 212),
                                                ),
                                                child: SfCartesianChart(
                                                    zoomPanBehavior:
                                                        currentchartZoomer,
                                                    tooltipBehavior:
                                                        TooltipBehavior(
                                                            header: '',
                                                            enable: true),
                                                    // tooltipBehavior: TooltipBehavior(
                                                    //   enable: true,
                                                    //   header: '',
                                                    //   color: const Color.fromARGB(
                                                    //       255, 99, 130, 184),
                                                    //   textStyle: TextStyle(
                                                    //       color: Colors.white),
                                                    //   format: 'Current : point.y',
                                                    // ),
                                                    // primaryXAxis: const DateTimeAxis(),
                                                    primaryXAxis:
                                                        const DateTimeAxis(
                                                      title: AxisTitle(
                                                        text: 'Time',
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    primaryYAxis:
                                                        const NumericAxis(
                                                      title: AxisTitle(
                                                        text:
                                                            'Total Current(Amp)',
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    // legend:
                                                    //     const Legend(isVisible: true),
                                                    series: <CartesianSeries>[
                                                      // Renders step line chart
                                                      StepLineSeries<
                                                              MachineCurrentData,
                                                              DateTime>(
                                                          dataSource: state
                                                              .currentspikes,
                                                          xValueMapper:
                                                              (MachineCurrentData
                                                                          data,
                                                                      _) =>
                                                                  data
                                                                      .timestamp,
                                                          yValueMapper:
                                                              (MachineCurrentData
                                                                          data,
                                                                      _) =>
                                                                  data.currentTotal)
                                                      /*  LineSeries<MachineCurrentData,
                                                      DateTime>(
                                                    name: 'Current Total',
                                                    dataSource: state.currentspikes,
                                                    xValueMapper:
                                                        (MachineCurrentData data,
                                                                _) =>
                                                            data.timestamp,
                                                    yValueMapper:
                                                        (MachineCurrentData data,
                                                                _) =>
                                                            data.currentTotal,
                                                  ),
                                                  LineSeries<MachineCurrentData,
                                                      DateTime>(
                                                    name: 'CR',
                                                    dataSource: state.currentspikes,
                                                    xValueMapper:
                                                        (MachineCurrentData data,
                                                                _) =>
                                                            data.timestamp,
                                                    yValueMapper:
                                                        (MachineCurrentData data,
                                                                _) =>
                                                            data.r,
                                                  ),*/
                                                    ]))
                                            : state.currentspikes.isEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Center(
                                                      child: Container(
                                                        width: 300,
                                                        height: 250,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 209, 225, 238),
                                                        child: Center(
                                                            child: StreamBuilder<
                                                                    bool>(
                                                                stream:
                                                                    isPI.stream,
                                                                builder: (context,
                                                                    newSnap) {
                                                                  if (newSnap.data !=
                                                                          null &&
                                                                      newSnap.data ==
                                                                          true) {
                                                                    return const Text(
                                                                        'current data not available...!',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Text',
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize: 17));
                                                                  } else {
                                                                    return const CircularProgressIndicator(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          45,
                                                                          190,
                                                                          235),
                                                                      backgroundColor: Color.fromARGB(
                                                                          255,
                                                                          215,
                                                                          216,
                                                                          216),
                                                                    );
                                                                  }
                                                                })),
                                                      ),
                                                    ),
                                                  )
                                                : const Stack(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      const SizedBox(
                        height: 20,
                      ),

                      if (state.wstagid[0].energyConsumption == "Y")
                        Column(children: [
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  height: 415,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(
                                        255, 253, 251, 251),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: SizedBox(
                                            //height: 40,
                                            child: Text(
                                          'Machine Voltage ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontFamily: 'Times',
                                            fontStyle: FontStyle.normal,
                                            fontSize: 30,
                                          ),
                                        )),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            children: [
                                              state.voltageData.isNotEmpty
                                                  ? Container(
                                                      height: 300,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 212, 212, 212),
                                                      ),
                                                      child: SfCartesianChart(
                                                        zoomPanBehavior:
                                                            voltagechartZoomer,
                                                        primaryXAxis:
                                                            const DateTimeAxis(
                                                          title: AxisTitle(
                                                            text: 'Time',
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        primaryYAxis:
                                                            const NumericAxis(
                                                          title: AxisTitle(
                                                            text: 'Voltage',
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        legend: const Legend(
                                                            isVisible: true),
                                                        tooltipBehavior:
                                                            TooltipBehavior(
                                                                enable: true),
                                                        series: <CartesianSeries>[
                                                          LineSeries<
                                                              MachineVolatgeData,
                                                              DateTime>(
                                                            name: 'VLL',
                                                            dataSource: state
                                                                .voltageData,
                                                            xValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.timestamp,
                                                            yValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.vllaverage,
                                                          ),
                                                          LineSeries<
                                                              MachineVolatgeData,
                                                              DateTime>(
                                                            name: 'VAR',
                                                            dataSource: state
                                                                .voltageData,
                                                            xValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.timestamp,
                                                            yValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.varphase,
                                                          ),
                                                          LineSeries<
                                                              MachineVolatgeData,
                                                              DateTime>(
                                                            name: 'VAY',
                                                            dataSource: state
                                                                .voltageData,
                                                            xValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.timestamp,
                                                            yValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.vayphase,
                                                          ),
                                                          LineSeries<
                                                              MachineVolatgeData,
                                                              DateTime>(
                                                            name: 'VAB',
                                                            dataSource: state
                                                                .voltageData,
                                                            xValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.timestamp,
                                                            yValueMapper:
                                                                (MachineVolatgeData
                                                                            data,
                                                                        _) =>
                                                                    data.vabphase,
                                                          ),
                                                        ],
                                                      ))
                                                  : state.voltageData.isEmpty
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Center(
                                                            child: Container(
                                                              width: 300,
                                                              height: 250,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  209,
                                                                  225,
                                                                  238),
                                                              child: Center(
                                                                  child: StreamBuilder<
                                                                          bool>(
                                                                      stream: isPI
                                                                          .stream,
                                                                      builder:
                                                                          (context,
                                                                              newSnap) {
                                                                        if (newSnap.data !=
                                                                                null &&
                                                                            newSnap.data ==
                                                                                true) {
                                                                          return const Text(
                                                                              'Voltage data not available...!',
                                                                              style: TextStyle(fontFamily: 'Text', color: Colors.red, fontSize: 17));
                                                                        } else {
                                                                          return const CircularProgressIndicator(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                45,
                                                                                190,
                                                                                235),
                                                                            backgroundColor: Color.fromARGB(
                                                                                255,
                                                                                215,
                                                                                216,
                                                                                216),
                                                                          );
                                                                        }
                                                                      })),
                                                            ),
                                                          ),
                                                        )
                                                      : const Stack(),
                                            ],
                                          ))
                                    ],
                                  )))
                        ]),
                      const SizedBox(
                        height: 20,
                      ),

                      if (state.wstagid[0].energyConsumption == "Y")
                        Column(children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 415,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                //  color: const Color.fromARGB(255, 134, 133, 133),
                                // color: Color.fromARGB(255, 209, 166, 166),
                                color: const Color.fromARGB(255, 253, 251, 251),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      child: Text(
                                    'Energy Consumption',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Times',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 30,
                                    ),
                                  )),
                                  Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: state.machineenergy != 0
                                          ? Row(
                                              children: [
                                                Container(
                                                  height: 300,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    //color: Color.fromARGB(255, 168, 168, 168),
                                                    color: const Color.fromARGB(
                                                        255, 212, 212, 212),
                                                  ),
                                                  child: SfRadialGauge(
                                                      title: const GaugeTitle(
                                                          text: '',
                                                          textStyle: TextStyle(
                                                            color: Colors.red,
                                                            fontFamily: 'Times',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 20,
                                                          ),
                                                          alignment:
                                                              GaugeAlignment
                                                                  .center),
                                                      enableLoadingAnimation:
                                                          true,
                                                      animationDuration: 500,
                                                      axes: <RadialAxis>[
                                                        RadialAxis(
                                                            minimum: 0,
                                                            maximum: 150,
                                                            ranges: <GaugeRange>[
                                                              GaugeRange(
                                                                  startValue: 0,
                                                                  endValue: 50,
                                                                  color: Colors
                                                                      .green,
                                                                  startWidth:
                                                                      10,
                                                                  endWidth: 10),
                                                              GaugeRange(
                                                                  startValue:
                                                                      50,
                                                                  endValue: 100,
                                                                  color: Colors
                                                                      .orange,
                                                                  startWidth:
                                                                      10,
                                                                  endWidth: 10),
                                                              GaugeRange(
                                                                  startValue:
                                                                      100,
                                                                  endValue: 150,
                                                                  color: Colors
                                                                      .red,
                                                                  startWidth:
                                                                      10,
                                                                  endWidth: 10)
                                                            ],
                                                            pointers: <GaugePointer>[
                                                              NeedlePointer(
                                                                value: state
                                                                    .machineenergy,
                                                              )
                                                            ],
                                                            annotations: <GaugeAnnotation>[
                                                              GaugeAnnotation(
                                                                  widget: Text(
                                                                      '${state.machineenergy} kWh',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              25,
                                                                          fontWeight: FontWeight
                                                                              .bold)),
                                                                  angle: 90,
                                                                  positionFactor:
                                                                      0.5)
                                                            ])
                                                      ]),
                                                ),
                                                // const SizedBox(
                                                //   width: 15,
                                                // ),
                                              ],
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: Container(
                                                  width: 300,
                                                  height: 250,
                                                  color: const Color.fromARGB(
                                                      255, 209, 225, 238),
                                                  child: Center(
                                                      child:
                                                          StreamBuilder<bool>(
                                                              stream:
                                                                  isPI.stream,
                                                              builder: (context,
                                                                  newSnap) {
                                                                if (newSnap.data !=
                                                                        null &&
                                                                    newSnap.data ==
                                                                        true) {
                                                                  return const Text(
                                                                      'Energy data not available...!',
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
                                                                        Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            216,
                                                                            216),
                                                                  );
                                                                }
                                                              })),
                                                ),
                                              ),
                                            )),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
          ),
        );
      } else {
        return const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.cyan),
        ));
      }
    });
  }

  machinewisedashbordMobile(
      BuildContext context, MachinewiseDashboardBloc blocprovider) {
    late ZoomPanBehavior feedzomber;
    late ZoomPanBehavior currentchartZoomer;
    late ZoomPanBehavior voltagechartZoomer;
    feedzomber = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true);
    currentchartZoomer = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true);
    voltagechartZoomer = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true);

    StreamController<bool> processing24hr = StreamController<bool>.broadcast();

    return BlocBuilder<MachinewiseDashboardBloc, MWDState>(
        builder: (context, state) {
      processincycylerun(
          iscyclerun: iscyclerun, isPI: isPI, isfeeddata: isfeeddata);

      if (state is MWDLoadingState) {
        return RefreshIndicator(
          onRefresh: () async {
            await refreshData(context);
          },
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                shrinkWrap: true,
                //  padding: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  /*Container(
                    width: MediaQuery.of(context).size.width - 100,
                    //  width: 150,
                    height: 45, // SizeConfig.screenHeight! * 0.06, //45
                    // padding:
                    //     const EdgeInsets.only(left: 10, bottom: 3, right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 0.5)),

                    child: TextField(
                      controller: dashboardDate,
                      onTap: () async {
                        dashboardDate.clear();
                        DateTime? picked = await dateTimePicker(context);
                        if (picked != null) {
                          dashboardDate.text = picked.toString().split(' ')[0];
                          if (!context.mounted) return;
                          BlocProvider.of<MachinewiseDashboardBloc>(context)
                              .add(MWDEvent(
                                  workstationstatus: workstationstatuslist,
                                  switchIndex: 1,
                                  chooseDate: dashboardDate.text));
                        } else {
                          dashboardDate.text = "";
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        icon: Icon(
                          Icons.calendar_month_sharp,
                          color: Color(0XFF01579b),
                        ),
                        hintText: "Select Date",
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                      textAlign: TextAlign.center,
                    ),
                  ),*/

                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: workcentreButtons(context),
                    ),
                  ),
                  StreamBuilder<Object>(
                      stream: processing24hr.stream,
                      builder: (context, snapshot) {
                        return SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width - 100,
                            child: ShiftButton(
                              label: "24 hr",
                              shiftIndex: 4,
                              isSelected: state.selectedShift == 4,
                              onPressed: () {
                                processing24hr.add(true);
                                BlocProvider.of<MachinewiseDashboardBloc>(
                                        context)
                                    .add(MWDEvent(
                                        switchIndex: 4,
                                        workstationstatus:
                                            workstationstatuslist,
                                        chooseDate: state.chooseDate));
                                BlocProvider.of<MachinewiseDashboardBloc>(
                                    context);
                                processing24hr.add(false);
                                // Navigator.pushNamed(
                                //     context, RouteName.machinedashboard,
                                //     arguments: {
                                //       'workstationstatuslist':
                                //           workstationstatuslist
                                //     });
                              },
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child:
                                  snapshot.data != null && snapshot.data == true
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text('24 hr'),
                            ));
                      }),

                  SizedBox(
                      child: Center(
                    child: Text(
                        // "${state.currentDate}
                        "${state.starttime}  To  ${state.endtime}",
                        style: const TextStyle(
                            //fontFamily: 'Text',
                            fontFamily: AutofillHints.birthday,
                            color: Colors.deepOrange,
                            fontSize: 18)),
                  )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                      child: Text(
                    'Production Cycle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Times',
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                    ),
                  )),

                  SizedBox(
                    height: 200.0,
                    child: ProductionCycleBar(
                        machinename: state.machinename.toString(),
                        uicurrentdate: state.currentDate,
                        productionCycleBarData: state.productionCycleBarData),
                  ),
                  /* SizedBox(
                    height: 70.0,
                    child: state.cs.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            controller: ScrollController(),
                            itemCount: state.cs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return ProductionCycleBar(
                                  machinename: state.machinename);

                              /* SizedBox(
                                width: 350.0 / (state.cs.length),
                                child: Tooltip(
                                  message:
                                      //'''Shift: ${_getShiftFromUnix(DateTime.fromMillisecondsSinceEpoch(_data['data']['445DnU']['data']['sub_period_data'][index]['ts']))}
                                      // '''Time: ${DateTime.fromMillisecondsSinceEpoch(dataList[index])}
                                      '''Time: ${state.cs[index].x}
                                          state:${state.cs[index].y}''',
                                  // Operation Name:
                                  // Component: ''',
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    margin: const EdgeInsets.all(0.0),
                                    color: state.cs[index].y == 1 ||
                                            state.cs[index].y == 3
                                        ? const Color.fromARGB(255, 0, 95, 3)
                                        : state.cs[index].y != 0 ||
                                                state.cs[index].y == 2
                                            ? Colors.red
                                            : Colors.yellow,
                                  ),
                                ),
                              );*/
                            },
                          )
                        : state.cs.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 320,
                                  height: 150,
                                  color:
                                      const Color.fromARGB(255, 209, 225, 238),
                                  child: Center(
                                      child: StreamBuilder<bool>(
                                          stream: iscyclerun.stream,
                                          builder: (context, newSnap) {
                                            if (newSnap.data != null &&
                                                newSnap.data == true) {
                                              return const Text(
                                                  'cycle run not available.',
                                                  style: TextStyle(
                                                      fontFamily: 'Text',
                                                      color: Colors.red,
                                                      fontSize: 18));
                                            } else {
                                              return const CircularProgressIndicator(
                                                color: Color.fromARGB(
                                                    255, 45, 190, 235),
                                                backgroundColor: Color.fromARGB(
                                                    255, 215, 216, 216),
                                              );
                                            }
                                          })),
                                ),
                              )
                            : const Stack(),
                  ),*/
                  // Container(
                  //   width: 700,
                  //   height: 160,
                  //   child: Center(
                  //     child: ColorDisplayWidget(dataList: dataList),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  if ( //state.wstagid != null &&
                      state.wstagid[0].productionTime == "Y")
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            height: 413,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(255, 253, 251, 251),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    'Production Time',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Times',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      state.productiontimeData.isNotEmpty
                                          ? Container(
                                              height: 300,
                                              width: 300,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: const Color.fromARGB(
                                                    255, 212, 212, 212),
                                              ),
                                              child: SfCircularChart(
                                                series: <CircularSeries>[
                                                  RadialBarSeries<
                                                      ProductiontimeData,
                                                      String>(
                                                    dataSource: state
                                                        .productiontimeData,
                                                    xValueMapper:
                                                        (ProductiontimeData
                                                                    data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ProductiontimeData
                                                                    data,
                                                                _) =>
                                                            data.y,
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                            isVisible: true),
                                                  )
                                                ],
                                                legend: const Legend(
                                                    isVisible: true,
                                                    position:
                                                        LegendPosition.auto),
                                              ))
                                          : state.productiontimeData.isEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    width: 320,
                                                    height: 150,
                                                    color: const Color.fromARGB(
                                                        255, 209, 225, 238),
                                                    child: Center(
                                                        child: StreamBuilder<
                                                                bool>(
                                                            stream: isPI.stream,
                                                            builder: (context,
                                                                newSnap) {
                                                              if (newSnap.data !=
                                                                      null &&
                                                                  newSnap.data ==
                                                                      true) {
                                                                return const Text(
                                                                    'Production & Idle time not available.',
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
                                                                      Color.fromARGB(
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(
                    height: 20,
                  ),

                  if (state.wstagid[0].feedRate == "Y")
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            height: 413,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // color: const Color.fromARGB(255, 134, 133, 133),
                              //  color: Color.fromARGB(255, 209, 166, 166),
                              color: const Color.fromARGB(255, 253, 251, 251),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 100.0),
                                  child: SizedBox(
                                      //height: 40,
                                      child: Text(
                                    'Feed rate',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Times',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 30,
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      state.feedData.isNotEmpty
                                          ? Container(
                                              height: 300,
                                              width: 700,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                //color: Color.fromARGB(255, 168, 168, 168),
                                                color: const Color.fromARGB(
                                                    255, 212, 212, 212),
                                              ),
                                              child: SfCartesianChart(
                                                  zoomPanBehavior: feedzomber,
                                                  // primaryXAxis: const DateTimeAxis(
                                                  //     enableAutoIntervalOnZooming:
                                                  //         true),
                                                  tooltipBehavior:
                                                      TooltipBehavior(
                                                          header: '',
                                                          enable: true),
                                                  // tooltipBehavior: TooltipBehavior(
                                                  //   enable: true,
                                                  //   header: '',
                                                  //   color: const Color.fromARGB(
                                                  //       255, 99, 130, 184),
                                                  //   textStyle: TextStyle(
                                                  //       color: Colors.white),
                                                  //   format: 'Feed : point.y',
                                                  // ),
                                                  primaryXAxis:
                                                      const DateTimeAxis(
                                                    enableAutoIntervalOnZooming:
                                                        true,
                                                    title: AxisTitle(
                                                      text: 'Time',
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  primaryYAxis:
                                                      const NumericAxis(
                                                    title: AxisTitle(
                                                      text: 'Feed',
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  series: <CartesianSeries>[
                                                    // Renders step line chart
                                                    StepLineSeries<FeedData,
                                                            DateTime>(
                                                        dataSource:
                                                            state.feedData,
                                                        xValueMapper:
                                                            (FeedData data,
                                                                    _) =>
                                                                data.x,
                                                        yValueMapper:
                                                            (FeedData data,
                                                                    _) =>
                                                                data.y)
                                                  ]))
                                          : state.feedData.isEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Center(
                                                    child: Container(
                                                      width: 300,
                                                      height: 250,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              209,
                                                              225,
                                                              238),
                                                      child: Center(
                                                          child: StreamBuilder<
                                                                  bool>(
                                                              stream:
                                                                  isPI.stream,
                                                              builder: (context,
                                                                  newSnap) {
                                                                if (newSnap.data !=
                                                                        null &&
                                                                    newSnap.data ==
                                                                        true) {
                                                                  return const Text(
                                                                      'Feed data not available...!',
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
                                                                        Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            216,
                                                                            216),
                                                                  );
                                                                }
                                                              })),
                                                    ),
                                                  ),
                                                )
                                              : const Stack(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),

                  if (state.wstagid[0].efficiency == "Y")
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            height: 430,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // color: const Color.fromARGB(255, 134, 133, 133),
                              //color: Color.fromARGB(255, 209, 166, 166),
                              color: const Color.fromARGB(255, 253, 251, 251),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    child: Text(
                                  'Efficiency',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Times',
                                    fontStyle: FontStyle.normal,
                                    fontSize: 30,
                                  ),
                                )),
                                Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: state.efficiency.isNaN
                                        ? Row(
                                            children: [
                                              Container(
                                                height: 300,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  //color: Color.fromARGB(255, 168, 168, 168),
                                                  color: const Color.fromARGB(
                                                      255, 212, 212, 212),
                                                ),
                                                child: CircularPercentIndicator(
                                                  radius: 120,
                                                  lineWidth: 30,
                                                  backgroundColor: Colors.grey,
                                                  progressColor: Colors.red,
                                                  // percent: state.efficiency / 100,
                                                  center: const Text(
                                                    "0 %",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  animation: true,
                                                  animationDuration: 500,
                                                  onAnimationEnd: () {},
                                                  startAngle: 180,
                                                  // header: const Text(
                                                  //   "Efficiency",
                                                  //   style: TextStyle(
                                                  //     fontSize: 30,
                                                  //   ),
                                                  // ),
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   width: 15,
                                              // ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                height: 300,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  //color: Color.fromARGB(255, 168, 168, 168),
                                                  color: const Color.fromARGB(
                                                      255, 212, 212, 212),
                                                ),
                                                child: CircularPercentIndicator(
                                                  radius: 120,
                                                  lineWidth: 30,
                                                  backgroundColor: Colors.grey,
                                                  progressColor: Colors.red,
                                                  percent:
                                                      state.efficiency / 100,
                                                  center: Text(
                                                    "${state.efficiency}%",
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  animation: true,
                                                  animationDuration: 500,
                                                  onAnimationEnd: () {},
                                                  startAngle: 180,
                                                  // header: const Text(
                                                  //   "Efficiency",
                                                  //   style: TextStyle(fontSize: 30),
                                                  // ),
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   width: 15,
                                              // ),
                                            ],
                                          ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),

                  if (state.wstagid[0].currentSpike == "Y")
                    Column(children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          height: 410,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // color: const Color.fromARGB(255, 134, 133, 133),
                            //  color: Color.fromARGB(255, 209, 166, 166),
                            color: const Color.fromARGB(255, 253, 251, 251),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .start, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: SizedBox(
                                    //height: 40,
                                    child: Text(
                                  'Machine Current ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Times',
                                    fontStyle: FontStyle.normal,
                                    fontSize: 30,
                                  ),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    state.currentspikes.isNotEmpty
                                        ? Container(
                                            height: 300,
                                            width: 700,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              //color: Color.fromARGB(255, 168, 168, 168),
                                              color: const Color.fromARGB(
                                                  255, 212, 212, 212),
                                            ),
                                            child: SfCartesianChart(
                                                zoomPanBehavior:
                                                    currentchartZoomer,
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                        header: '',
                                                        enable: true),
                                                // tooltipBehavior: TooltipBehavior(
                                                //   enable: true,
                                                //   header: '',
                                                //   color: const Color.fromARGB(
                                                //       255, 99, 130, 184),
                                                //   textStyle: TextStyle(
                                                //       color: Colors.white),
                                                //   format: 'Current : point.y',
                                                // ),
                                                // primaryXAxis: const DateTimeAxis(),
                                                primaryXAxis:
                                                    const DateTimeAxis(
                                                  title: AxisTitle(
                                                    text: 'Time',
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                primaryYAxis: const NumericAxis(
                                                  title: AxisTitle(
                                                    text: 'Total Current(Amp)',
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                // legend:
                                                //     const Legend(isVisible: true),
                                                series: <CartesianSeries>[
                                                  // Renders step line chart
                                                  StepLineSeries<
                                                          MachineCurrentData,
                                                          DateTime>(
                                                      dataSource:
                                                          state.currentspikes,
                                                      xValueMapper:
                                                          (MachineCurrentData
                                                                      data,
                                                                  _) =>
                                                              data.timestamp,
                                                      yValueMapper:
                                                          (MachineCurrentData
                                                                      data,
                                                                  _) =>
                                                              data.currentTotal)
                                                  /*  LineSeries<MachineCurrentData,
                                                  DateTime>(
                                                name: 'Current Total',
                                                dataSource: state.currentspikes,
                                                xValueMapper:
                                                    (MachineCurrentData data,
                                                            _) =>
                                                        data.timestamp,
                                                yValueMapper:
                                                    (MachineCurrentData data,
                                                            _) =>
                                                        data.currentTotal,
                                              ),
                                              LineSeries<MachineCurrentData,
                                                  DateTime>(
                                                name: 'CR',
                                                dataSource: state.currentspikes,
                                                xValueMapper:
                                                    (MachineCurrentData data,
                                                            _) =>
                                                        data.timestamp,
                                                yValueMapper:
                                                    (MachineCurrentData data,
                                                            _) =>
                                                        data.r,
                                              ),*/
                                                ]))
                                        : state.currentspikes.isEmpty
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Container(
                                                    width: 300,
                                                    height: 250,
                                                    color: const Color.fromARGB(
                                                        255, 209, 225, 238),
                                                    child: Center(
                                                        child: StreamBuilder<
                                                                bool>(
                                                            stream: isPI.stream,
                                                            builder: (context,
                                                                newSnap) {
                                                              if (newSnap.data !=
                                                                      null &&
                                                                  newSnap.data ==
                                                                      true) {
                                                                return const Text(
                                                                    'current data not available...!',
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
                                                                      Color.fromARGB(
                                                                          255,
                                                                          215,
                                                                          216,
                                                                          216),
                                                                );
                                                              }
                                                            })),
                                                  ),
                                                ),
                                              )
                                            : const Stack(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  const SizedBox(
                    height: 20,
                  ),

                  if (state.wstagid[0].energyConsumption == "Y")
                    Column(children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 410,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 253, 251, 251),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50.0),
                                    child: SizedBox(
                                        //height: 40,
                                        child: Text(
                                      'Machine Voltage ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Times',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 30,
                                      ),
                                    )),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          state.voltageData.isNotEmpty
                                              ? Container(
                                                  height: 300,
                                                  width: 700,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: const Color.fromARGB(
                                                        255, 212, 212, 212),
                                                  ),
                                                  child: SfCartesianChart(
                                                    zoomPanBehavior:
                                                        voltagechartZoomer,
                                                    primaryXAxis:
                                                        const DateTimeAxis(
                                                      title: AxisTitle(
                                                        text: 'Time',
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    primaryYAxis:
                                                        const NumericAxis(
                                                      title: AxisTitle(
                                                        text: 'Voltage',
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    legend: const Legend(
                                                        isVisible: true),
                                                    tooltipBehavior:
                                                        TooltipBehavior(
                                                            enable: true),
                                                    series: <CartesianSeries>[
                                                      LineSeries<
                                                          MachineVolatgeData,
                                                          DateTime>(
                                                        name: 'VLL',
                                                        dataSource:
                                                            state.voltageData,
                                                        xValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.timestamp,
                                                        yValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.vllaverage,
                                                      ),
                                                      LineSeries<
                                                          MachineVolatgeData,
                                                          DateTime>(
                                                        name: 'VAR',
                                                        dataSource:
                                                            state.voltageData,
                                                        xValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.timestamp,
                                                        yValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.varphase,
                                                      ),
                                                      LineSeries<
                                                          MachineVolatgeData,
                                                          DateTime>(
                                                        name: 'VAY',
                                                        dataSource:
                                                            state.voltageData,
                                                        xValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.timestamp,
                                                        yValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.vayphase,
                                                      ),
                                                      LineSeries<
                                                          MachineVolatgeData,
                                                          DateTime>(
                                                        name: 'VAB',
                                                        dataSource:
                                                            state.voltageData,
                                                        xValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.timestamp,
                                                        yValueMapper:
                                                            (MachineVolatgeData
                                                                        data,
                                                                    _) =>
                                                                data.vabphase,
                                                      ),
                                                    ],
                                                  ))
                                              : state.voltageData.isEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Center(
                                                        child: Container(
                                                          width: 300,
                                                          height: 250,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              209, 225, 238),
                                                          child: Center(
                                                              child: StreamBuilder<
                                                                      bool>(
                                                                  stream: isPI
                                                                      .stream,
                                                                  builder: (context,
                                                                      newSnap) {
                                                                    if (newSnap.data !=
                                                                            null &&
                                                                        newSnap.data ==
                                                                            true) {
                                                                      return const Text(
                                                                          'Voltage data not available...!',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Text',
                                                                              color: Colors.red,
                                                                              fontSize: 17));
                                                                    } else {
                                                                      return const CircularProgressIndicator(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            45,
                                                                            190,
                                                                            235),
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            216,
                                                                            216),
                                                                      );
                                                                    }
                                                                  })),
                                                        ),
                                                      ),
                                                    )
                                                  : const Stack(),
                                        ],
                                      ))
                                ],
                              )))
                    ]),
                  const SizedBox(
                    height: 20,
                  ),

                  if (state.wstagid[0].energyConsumption == "Y")
                    Column(children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          height: 410,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            //  color: const Color.fromARGB(255, 134, 133, 133),
                            // color: Color.fromARGB(255, 209, 166, 166),
                            color: const Color.fromARGB(255, 253, 251, 251),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  child: Text(
                                'Energy Consumption',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Times',
                                  fontStyle: FontStyle.normal,
                                  fontSize: 30,
                                ),
                              )),
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: state.machineenergy != 0
                                      ? Row(
                                          children: [
                                            Container(
                                              height: 300,
                                              width: 300,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                //color: Color.fromARGB(255, 168, 168, 168),
                                                color: const Color.fromARGB(
                                                    255, 212, 212, 212),
                                              ),
                                              child: SfRadialGauge(
                                                  title: const GaugeTitle(
                                                      text: '',
                                                      textStyle: TextStyle(
                                                        color: Colors.red,
                                                        fontFamily: 'Times',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 20,
                                                      ),
                                                      alignment: GaugeAlignment
                                                          .center),
                                                  enableLoadingAnimation: true,
                                                  animationDuration: 500,
                                                  axes: <RadialAxis>[
                                                    RadialAxis(
                                                        minimum: 0,
                                                        maximum: 150,
                                                        ranges: <GaugeRange>[
                                                          GaugeRange(
                                                              startValue: 0,
                                                              endValue: 50,
                                                              color:
                                                                  Colors.green,
                                                              startWidth: 10,
                                                              endWidth: 10),
                                                          GaugeRange(
                                                              startValue: 50,
                                                              endValue: 100,
                                                              color:
                                                                  Colors.orange,
                                                              startWidth: 10,
                                                              endWidth: 10),
                                                          GaugeRange(
                                                              startValue: 100,
                                                              endValue: 150,
                                                              color: Colors.red,
                                                              startWidth: 10,
                                                              endWidth: 10)
                                                        ],
                                                        pointers: <GaugePointer>[
                                                          NeedlePointer(
                                                            value: state
                                                                .machineenergy,
                                                          )
                                                        ],
                                                        annotations: <GaugeAnnotation>[
                                                          GaugeAnnotation(
                                                              widget: Text(
                                                                  '${state.machineenergy} kWh',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              angle: 90,
                                                              positionFactor:
                                                                  0.5)
                                                        ])
                                                  ]),
                                            ),
                                            // const SizedBox(
                                            //   width: 15,
                                            // ),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Container(
                                              width: 300,
                                              height: 250,
                                              color: const Color.fromARGB(
                                                  255, 209, 225, 238),
                                              child: Center(
                                                  child: StreamBuilder<bool>(
                                                      stream: isPI.stream,
                                                      builder:
                                                          (context, newSnap) {
                                                        if (newSnap.data !=
                                                                null &&
                                                            newSnap.data ==
                                                                true) {
                                                          return const Text(
                                                              'Energy data not available...!',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Text',
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      17));
                                                        } else {
                                                          return const CircularProgressIndicator(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    45,
                                                                    190,
                                                                    235),
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    215,
                                                                    216,
                                                                    216),
                                                          );
                                                        }
                                                      })),
                                            ),
                                          ),
                                        )),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
        );
      } else {
        return const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.cyan),
        ));
      }
    });
  }

  processincycylerun(
      {required StreamController<bool> iscyclerun,
      required StreamController<bool> isPI,
      required StreamController<bool> isfeeddata}) {
    iscyclerun.add(false);
    isPI.add(false);
    isfeeddata.add(false);
    Future.delayed(const Duration(seconds: 7), () {
      iscyclerun.add(true);
      isPI.add(true);
      isfeeddata.add(false);
    });
  }

  processinPItime({required StreamController<bool> isPI}) {
    isPI.add(false);
    Future.delayed(const Duration(seconds: 10), () {
      isPI.add(true);
    });
  }

  workcentreButtons(BuildContext context) {
    StreamController<bool> processing1stshift =
        StreamController<bool>.broadcast();
    StreamController<bool> processing2shift =
        StreamController<bool>.broadcast();
    StreamController<bool> processing3shift =
        StreamController<bool>.broadcast();
    return BlocBuilder<MachinewiseDashboardBloc, MWDState>(
      builder: (context, state) {
        if (state is MWDLoadingState) {
          return SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<Object>(
                          stream: processing1stshift.stream,
                          builder: (context, snapshot) {
                            return ShiftButton(
                                label: 'Shift One',
                                shiftIndex: 1,
                                isSelected: state.selectedShift == 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: snapshot.data != null &&
                                        snapshot.data == true
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text('Shift One'),
                                onPressed: () async {
                                  // await refreshData(context);
                                  processing1stshift.add(true);
                                  BlocProvider.of<MachinewiseDashboardBloc>(
                                          context)
                                      .add(MWDEvent(
                                          switchIndex: 1,
                                          workstationstatus:
                                              workstationstatuslist,
                                          chooseDate: state.chooseDate));
                                  BlocProvider.of<MachinewiseDashboardBloc>(
                                      context);
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                  processing1stshift.add(false);
                                });
                          }),
                      StreamBuilder<Object>(
                          stream: processing2shift.stream,
                          builder: (context, snapshot) {
                            return ShiftButton(
                              label: 'Shift Two',
                              shiftIndex: 2,
                              isSelected: state.selectedShift == 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              onPressed: () async {
                                // await refreshData(context);
                                processing2shift.add(true);
                                BlocProvider.of<MachinewiseDashboardBloc>(
                                        context)
                                    .add(MWDEvent(
                                        switchIndex: 2,
                                        workstationstatus:
                                            workstationstatuslist,
                                        chooseDate: state.chooseDate));
                                BlocProvider.of<MachinewiseDashboardBloc>(
                                    context);
                                processing2shift.add(false);
                              },
                              child:
                                  snapshot.data != null && snapshot.data == true
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text('Shift Two'),
                            );
                          }),
                      StreamBuilder<Object>(
                          stream: processing3shift.stream,
                          builder: (context, snapshot) {
                            return ShiftButton(
                              label: 'Shift Three',
                              shiftIndex: 3,
                              isSelected: state.selectedShift == 3,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              onPressed: () async {
                                // await refreshData(context);
                                processing3shift.add(true);
                                BlocProvider.of<MachinewiseDashboardBloc>(
                                        context)
                                    .add(MWDEvent(
                                        switchIndex: 3,
                                        workstationstatus:
                                            workstationstatuslist,
                                        chooseDate: state.chooseDate));
                                BlocProvider.of<MachinewiseDashboardBloc>(
                                    context);
                                processing3shift.add(false);
                              },
                              child:
                                  snapshot.data != null && snapshot.data == true
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text('Shift Three'),
                            );
                          }),
                      // centresbutton(state, context, 1, 'Shift One'),
                      // centresbutton(state, context, 2, 'Shift Two'),
                      // centresbutton(state, context, 3, 'Shift Three'),
                    ],
                  ),
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

  centresbutton(state, BuildContext context, int buttonIndex, String label) {
    // final MachinewiseDashboardBloc = BlocProvider.of<MachinewiseDashboardBloc>(context);
    //  MachinewiseDashboardBloc.add(MWDEvent(
    //     workstationstatus: workstationstatuslist,
    //     switchIndex: buttonIndex,
    //   ));
    if (state is MWDLoadingState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShiftOneButton(
          onPressed: () {
            BlocProvider.of<MachinewiseDashboardBloc>(context).add(MWDEvent(
                workstationstatus: workstationstatuslist,
                switchIndex: buttonIndex,
                chooseDate: state.chooseDate));
          },
          child: QuickFixUi.buttonText(label),
        ),
      );
    }
  }

  // Future<String?> pickDateTime(BuildContext context) async {
  //   // Pick the date
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (pickedDate != null) {
  //     // Pick the time
  //     TimeOfDay? pickedTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //       initialEntryMode: TimePickerEntryMode.dialOnly,
  //       builder: (BuildContext context, Widget? child) {
  //         return MediaQuery(
  //           data: MediaQuery.of(context).copyWith(
  //             alwaysUse24HourFormat: true, // Set to false for 12-hour format
  //           ),
  //           child: child!,
  //         );
  //       },
  //     );

  //     if (pickedTime != null) {
  //       // Combine picked date and time
  //       final DateTime combinedDateTime = DateTime(
  //         pickedDate.year,
  //         pickedDate.month,
  //         pickedDate.day,
  //         pickedTime.hour,
  //         pickedTime.minute,
  //       );

  //       // final String formattedDateTime =
  //       //   DateFormat('dd/MM/yyyy HH:mm:ss').format(combinedDateTime);

  //       // Format the combined date and time
  //       final String formattedDateTime =
  //           DateFormat('dd/MM/yyyy HH:mm:ss').format(combinedDateTime);

  //       // Use the formatted date and time
  //       // print(formattedDateTime); // Output the formatted date and time

  //       // Update your text controller or use the formatted date and time as needed
  //       // dashboardDate.text = DateFormat('dd/MM/yyyy').format(combinedDateTime);
  //       dashboardDate.text = formattedDateTime;
  //       // if (!context.mounted) return;
  //       // BlocProvider.of<MachinewiseDashboardBloc>(context).add(MWDEvent(
  //       //   workstationstatus: workstationstatuslist,
  //       //   switchIndex: 1,
  //       //   chooseDate: dashboardDate.text,
  //       // ));
  //       return dashboardDate.text;
  //     } else {
  //       // dashboardDate.text = "";
  //       return dashboardDate.text;
  //     }
  //   } else {
  //     dashboardDate.text = "";
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
            fontFamily: 'Times',
            fontStyle: FontStyle.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class ColorDisplayWidget extends StatelessWidget {
  final List<int> dataList;

  const ColorDisplayWidget({Key? key, required this.dataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dataList.map((value) {
          Color color = value == 0 ? Colors.yellow : Colors.green;
          return Container(
            width: 10,
            height: 70,
            margin: const EdgeInsets.all(1),
            color: color,
          );
        }).toList(),
      ),
    );
  }
}

class ProductionCycleBar extends StatefulWidget {
  final String machinename, uicurrentdate;
  final List<ProductionCyclevalue> productionCycleBarData;
  const ProductionCycleBar({
    Key? key,
    required this.machinename,
    required this.uicurrentdate,
    required this.productionCycleBarData,
  }) : super(key: key);

  @override
  State<ProductionCycleBar> createState() => _DashboardState();
}

class _DashboardState extends State<ProductionCycleBar> {
  StreamController<List<ProductionCyclevalue>> productionCycleBarData =
      StreamController<List<ProductionCyclevalue>>.broadcast();
  StreamController<OneCycleData> cycleDetails =
      StreamController<OneCycleData>.broadcast();

  double intervalDuration = 0;
  late String machinename;
  late String uicurrentdate;

  @override
  void initState() {
    super.initState();
    machinename =
        widget.machinename; // Initialize machinename with widget value
    uicurrentdate = widget.uicurrentdate;
    productionCycleBarData.add(widget.productionCycleBarData);
  }

  @override
  void dispose() {
    productionCycleBarData.close();
    cycleDetails.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double conWidth = size.width;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime currentTime = DateTime.now().toLocal();
    // debugPrint("cccccccccccccccccccccccccccc--- $currentTime");
    // debugPrint("selected time ------------- $uicurrentdate");
    return MouseRegion(
      onHover: (PointerEvent event) {
        cycleDetails.add(OneCycleData());
      },
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 212, 212, 212),
        backgroundColor: const Color.fromARGB(255, 161, 160, 160),
        body: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<List<ProductionCyclevalue>>(
                    stream: productionCycleBarData.stream,
                    builder: (context, dataList) {
                      if (dataList.data != null && dataList.data!.isNotEmpty) {
                        return Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            decoration: BoxDecoration(
                                color: dataList.data!.last.value == 0
                                    ? Colors.yellow[100]
                                    : dataList.data!.last.value == 1
                                        ? Colors.green[100]
                                        : dataList.data!.last.value == 898989
                                            ? Colors.red[100]
                                            : Colors.orange[100],
                                border: Border.all(
                                    color: _getColorForValue(
                                        value: dataList.data!.last.value),
                                    width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: listtyleWidget(
                                color: _getColorForValue(
                                    value: dataList.data!.last.value),
                                operation: _getState(
                                    value: dataList.data!.last.value)));
                      } else {
                        return const SizedBox();
                      }
                    }),
                buttonRow(
                    currentTime: currentTime,
                    dateFormat: dateFormat,
                    machinename: machinename),
              ],
            ),
            productCyclebar(
                conWidth: conWidth, size: size, currentTime: currentTime),
            StreamBuilder<List<ProductionCyclevalue>>(
                stream: productionCycleBarData.stream,
                builder: (context, dataList) {
                  if (dataList.data != null && dataList.data!.isNotEmpty) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 300,
                        height: 50,
                        margin: const EdgeInsets.only(top: 150),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            listtyleWidget(
                                color: _getColorForValue(value: 1),
                                operation: _getState(value: 1)),
                            listtyleWidget(
                                color: _getColorForValue(value: 0),
                                operation: _getState(value: 0)),
                            listtyleWidget(
                                color: _getColorForValue(value: 3),
                                operation: _getState(value: 3)),
                            listtyleWidget(
                                color: _getColorForValue(value: 898989),
                                operation: _getState(value: 898989))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Stack();
                    // const SizedBox(
                    //     child: Text("Data Not Available now"));
                  }
                }),
            showPopUpView(),
          ],
        ),
      ),
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

  StreamBuilder<OneCycleData> showPopUpView() {
    return StreamBuilder<OneCycleData>(
        stream: cycleDetails.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.startTime != '') {
            double screenWidth = MediaQuery.of(context).size.width;

            double desiredPosition = snapshot.data!.pos;

            double containerWidth = 300.0;

            double leftPosition = desiredPosition < 0
                ? 0
                : (desiredPosition + containerWidth > screenWidth)
                    ? screenWidth - (containerWidth + 20)
                    : desiredPosition;
            DateTime startTime =
                DateTime.parse(snapshot.data!.startTime.toString());
            DateTime endTime =
                DateTime.parse(snapshot.data!.endTime.toString());

            return Stack(
              children: [
                Positioned(
                  left: leftPosition,
                  top: 70, // Position from the top
                  child: Container(
                    width: containerWidth,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _getColorForValue(value: snapshot.data!.value),
                          width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: _getColorForValue(
                                          value: snapshot.data!.value),
                                      radius: 7,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${_getState(value: snapshot.data!.value)} :',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                        formatDuration(
                                            startTime: startTime,
                                            endTime: endTime),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ])),
                        ),
                        Text('Start Time : ${snapshot.data!.startTime}'),
                        Text('End Time : ${snapshot.data!.endTime}'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }

  String formatDuration(
      {required DateTime startTime, required DateTime endTime}) {
    Duration duration = endTime.difference(startTime);
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String formattedDuration = '';

    formattedDuration += '$hours hr ';

    formattedDuration += '$minutes min ';

    formattedDuration += '$seconds sec';

    return formattedDuration;
  }

  Container productCyclebar(
      {required double conWidth,
      required Size size,
      required DateTime currentTime}) {
    return Container(
      width: conWidth,
      height: 100,
      margin: const EdgeInsets.only(top: 50),
      child: StreamBuilder<List<ProductionCyclevalue>>(
        stream: productionCycleBarData.stream,
        builder: (context, dataList) {
          if (dataList.data != null && dataList.data!.isNotEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                DateTime firstTime = DateTime.fromMillisecondsSinceEpoch(
                        dataList.data!.first.ts,
                        isUtc: true)
                    .toLocal();
                DateTime lastTime = DateTime.fromMillisecondsSinceEpoch(
                        dataList.data!.last.ts,
                        isUtc: true)
                    .toLocal();
                Duration totalDuration = lastTime.difference(firstTime);
                double availableWidth = constraints.maxWidth - 20;
                double widthPerMillisecond =
                    availableWidth / totalDuration.inMilliseconds.toDouble();

                double totalWidth = 0.0;
                List<double> segmentWidths = [];

                for (int i = 0; i < dataList.data!.length; i++) {
                  var e = dataList.data![i];
                  DateTime startTime =
                      DateTime.fromMillisecondsSinceEpoch(e.ts, isUtc: true)
                          .toLocal();
                  DateTime endTime = i < dataList.data!.length - 1
                      ? DateTime.fromMillisecondsSinceEpoch(
                              dataList.data![i + 1].ts,
                              isUtc: true)
                          .toLocal()
                      : DateTime.now();

                  Duration duration = endTime.difference(startTime);
                  double durationWidth =
                      duration.inMilliseconds.toDouble() * widthPerMillisecond;

                  durationWidth = durationWidth < 1.0 ? 1.0 : durationWidth;
                  segmentWidths.add(durationWidth);
                  totalWidth += durationWidth;
                }

                double scaleFactor = totalWidth > availableWidth
                    ? availableWidth / totalWidth
                    : 1.0;

                List<Positioned> labels = [];
                double lastLabelPosition = 0.0;
                double minLabelSpacing = 40;

                labels.add(
                  Positioned(
                    left: 1,
                    child: Text(
                      _formatLabel(
                          firstTime,
                          0,
                          totalDuration.inMilliseconds.toDouble(),
                          intervalDuration,
                          lastTime),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );

                lastLabelPosition = minLabelSpacing;
                if (size.width > 700) {
                  for (double interval = intervalDuration;
                      interval <= totalDuration.inMilliseconds.toDouble();
                      interval += intervalDuration) {
                    double labelPosition =
                        interval * widthPerMillisecond / 1.05;

                    if (labelPosition - lastLabelPosition >= minLabelSpacing) {
                      labels.add(
                        Positioned(
                          left: labelPosition,
                          right: 10,
                          child: Text(
                            _formatLabel(
                                firstTime,
                                interval,
                                totalDuration.inMilliseconds.toDouble(),
                                intervalDuration,
                                lastTime),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                      lastLabelPosition = labelPosition;
                    }
                  }
                }
                // Add label for the end time
                double lastLabelPositionEnd =
                    totalDuration.inMilliseconds.toDouble() *
                        widthPerMillisecond *
                        scaleFactor;
                if (lastLabelPositionEnd > availableWidth - 20) {
                  lastLabelPositionEnd = availableWidth - 20;
                }
                if (lastLabelPositionEnd - lastLabelPosition >=
                    minLabelSpacing) {
                  labels.add(
                    Positioned(
                      left: size.width - 68,
                      child: Text(
                        currentTime.toString().substring(11, 19),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }
                return Container(
                  width: constraints.maxWidth,
                  height: 100,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: List.generate(dataList.data!.length, (index) {
                          double adjustedWidth =
                              segmentWidths[index] * scaleFactor;
                          return MouseRegion(
                              onHover: (PointerEvent event) {
                                Offset pos = event.position;
                                cycleDetails.add(OneCycleData());
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  DateTime startTime =
                                      DateTime.fromMillisecondsSinceEpoch(
                                              dataList.data![index].ts,
                                              isUtc: true)
                                          .toLocal();
                                  DateTime endTime =
                                      index < dataList.data!.length - 1
                                          ? DateTime.fromMillisecondsSinceEpoch(
                                                  dataList.data![index + 1].ts,
                                                  isUtc: true)
                                              .toLocal()
                                          : DateTime.now();
                                  cycleDetails.add(OneCycleData(
                                      startTime:
                                          startTime.toString().substring(0, 19),
                                      endTime:
                                          endTime.toString().substring(0, 19),
                                      pos: pos.dx,
                                      value: dataList.data![index].value));
                                });
                              },
                              child: Container(
                                width: adjustedWidth,
                                height: 65,
                                color: _getColorForValue(
                                    value: dataList.data![index].value),
                              ));
                        }),
                      ),
                      SizedBox(
                        width: constraints.maxWidth,
                        height: 25,
                        child: Stack(
                          children: labels,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Container buttonRow(
      {required DateTime currentTime,
      required DateFormat dateFormat,
      required String machinename}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: intervalDuration == 10 * 60 * 1000.0
                    ? const Color.fromARGB(255, 57, 112, 156)
                    : Colors.white),
            onPressed: () async {
              cycleDetails.add(OneCycleData());
              setState(() {
                intervalDuration = 10 * 60 * 1000.0; // 10 minutes
              });
              DateTime startTime =
                  currentTime.subtract(const Duration(hours: 1));
              // debugPrint(startTime.toString());
              List<ProductionCyclevalue> dataList =
                  await DashboardRepository.machinewisecyclerun(
                      starttime: dateFormat.format(startTime),
                      endtime: dateFormat.format(currentTime),
                      machinename: machinename);
              productionCycleBarData.add(dataList);
            },
            child: Text(
              '1 hr',
              style: TextStyle(
                  color: intervalDuration == 10 * 60 * 1000.0
                      ? Colors.white
                      : const Color.fromARGB(255, 57, 112, 156)),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: intervalDuration == 60 * 60 * 1000.0
                    ? const Color.fromARGB(255, 57, 112, 156)
                    : Colors.white),
            onPressed: () async {
              cycleDetails.add(OneCycleData());
              setState(() {
                intervalDuration = 60 * 60 * 1000.0; // 1 hour
              });
              DateTime startTime =
                  currentTime.subtract(const Duration(hours: 8));
              List<ProductionCyclevalue> dataList =
                  await DashboardRepository.machinewisecyclerun(
                      starttime: dateFormat.format(startTime),
                      endtime: dateFormat.format(currentTime),
                      machinename: machinename);

              productionCycleBarData.add(dataList);
            },
            child: Text(
              '8 hr',
              style: TextStyle(
                  color: intervalDuration == 60 * 60 * 1000.0
                      ? Colors.white
                      : const Color.fromARGB(255, 57, 112, 156)),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: intervalDuration == 240 * 60 * 1000.0
                    ? const Color.fromARGB(255, 57, 112, 156)
                    : Colors.white),
            onPressed: () async {
              cycleDetails.add(OneCycleData());
              setState(() {
                intervalDuration = 240 * 60 * 1000.0; // 4 hour
              });
              DateTime startTime =
                  currentTime.subtract(const Duration(hours: 24));

              List<ProductionCyclevalue> dataList =
                  await DashboardRepository.machinewisecyclerun(
                      starttime: dateFormat.format(startTime),
                      endtime: dateFormat.format(currentTime),
                      machinename: machinename);

              productionCycleBarData.add(dataList);
            },
            child: Text(
              '24 hr',
              style: TextStyle(
                  color: intervalDuration == 240 * 60 * 1000.0
                      ? Colors.white
                      : const Color.fromARGB(255, 57, 112, 156)),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
    );
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

  String _formatLabel(DateTime startTime, double interval, double totalDuration,
      double intervalDuration, DateTime lastTime) {
    DateTime currentTime =
        startTime.add(Duration(milliseconds: interval.toInt()));

    return DateFormat('HH:mm:ss').format(currentTime);
  }
}
