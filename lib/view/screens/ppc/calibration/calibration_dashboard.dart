// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration screen

// import 'package:de_opc/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../routes/route_data.dart';
import '../../../../routes/route_names.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';

class CalibrationDashboard extends StatelessWidget {
  const CalibrationDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentCalibrationStatusEvent());
    return Scaffold(
        appBar: CustomAppbar().appbar(
            context: context, title: 'Instrument Registry & Calibration Log'),
        body: MakeMeResponsiveScreen(
          horixontaltab: calibrationDashboard(),
          windows: calibrationDashboard(),
          linux: calibrationDashboard(),
        ),
        bottomNavigationBar: BlocBuilder<CalibrationBloc, CalibrationState>(
            builder: (context, state) {
          List<String> programsList = [
            'Instruments Registration',
            'Schedule Calibration',
            'Instrument Type Registration',
            'Calibration Status',
            'Order Instrument',
            'All Orders',
            'Instruments History'
          ];
          return NavigationBar(
              selectedIndex: selectedIndex(state),
              onDestinationSelected: (destination) {
                if (destination == 0) {
                  blocProvider.add(InstrumentsRegistrationEvent());
                } else if (destination == 1) {
                  blocProvider.add(CalibrationScheduleRegistrationEvent());
                } else if (destination == 2) {
                  blocProvider.add(InstrumentTypeRegistrationEvent());
                } else if (destination == 3) {
                  blocProvider.add(InstrumentCalibrationStatusEvent());
                } else if (destination == 4) {
                  blocProvider.add(OrderInstrumentEvent());
                } else if (destination == 5) {
                  blocProvider.add(AllInstrumentOrdersEvent());
                } else if (destination == 6) {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        overlay.size.width - 150,
                        overlay.size.height - 150,
                        20,
                        20,
                      ),
                      items: [
                        PopupMenuItem(
                          value: 'Rejected instruments',
                          child: const Text('Rejected instruments'),
                          onTap: () {
                            blocProvider.add(RejectedInstrumentsEvent());
                          },
                        ),
                        PopupMenuItem(
                          value: 'Instruments history',
                          child: const Text('Instruments history'),
                          onTap: () {
                            blocProvider
                                .add(InstrumentCalibrationHistoryEvent());
                          },
                        ),
                      ]);
                }
              },
              destinations: programsList
                  .map((e) => NavigationDestination(
                        icon: MyIconGenerator.getIcon(
                            name: e.toString(),
                            iconColor: Colors.black,
                            size: 25),
                        label: e.toString(),
                      ))
                  .toList());
        }));
  }

  BlocBuilder<CalibrationBloc, CalibrationState> calibrationDashboard() {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is InstrumentsRegistrationState) {
        return RouteData.getRouteData(
            context, RouteName.instrumentRegistration, {});
      } else if (state is InstrumentTypeRegistrationState) {
        return RouteData.getRouteData(
            context, RouteName.instrumentTypeRegistration, {});
      } else if (state is CalibrationScheduleRegistrationState) {
        return RouteData.getRouteData(
            context, RouteName.calibrationScheduleRegistration, {});
      } else if (state is InstrumentCalibrationStatusState) {
        return RouteData.getRouteData(context, RouteName.calibrationStatus, {});
      } else if (state is OrderInstrumentState) {
        return RouteData.getRouteData(context, RouteName.orderInstrument, {});
      } else if (state is AllInstrumentOrdersState) {
        return RouteData.getRouteData(
            context, RouteName.allInstrumentOrders, {});
      } else if (state is InstrumentCalibrationHistoryState) {
        return RouteData.getRouteData(
            context, RouteName.calibrationHistory, {});
      } else if (state is RejectedInstrumentState) {
        return RouteData.getRouteData(
            context, RouteName.rejectedInstruments, {});
      } else {
        return const Center(
          child: Text(' Calibration'),
        );
      }
    });
  }

  int selectedIndex(CalibrationState state) {
    if (state is InstrumentsRegistrationState) {
      return 0;
    } else if (state is CalibrationScheduleRegistrationState) {
      return 1;
    } else if (state is InstrumentTypeRegistrationState) {
      return 2;
    } else if (state is InstrumentCalibrationStatusState) {
      return 3;
    } else if (state is OrderInstrumentState) {
      return 4;
    } else if (state is AllInstrumentOrdersState) {
      return 5;
    } else if (state is InstrumentCalibrationHistoryState) {
      return 6;
    } else {
      return 0;
    }
  }
}
