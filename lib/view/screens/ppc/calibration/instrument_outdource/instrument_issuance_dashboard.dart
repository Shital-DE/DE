import 'package:de/routes/route_data.dart';
import 'package:de/routes/route_names.dart';
import 'package:de/utils/app_colors.dart';
import 'package:de/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../widgets/appbar.dart';

class InstrumentIssuanceDashboard extends StatelessWidget {
  const InstrumentIssuanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    CalibrationBloc blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentIssuanceEvent());
    List<String> bottonNavigationList = [
      "Issue instruments",
      "Reclaim instruments",
      "Instrument issuance receipt",
      "Instrument outsource history"
    ];
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppbar()
            .appbar(context: context, title: 'Instrument outsource dashboard'),
        body: state is CalibrationInitialState
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.appTheme,
                ),
              )
            : state is InstrumentIssuanceState
                ? RouteData.getRouteData(
                    context, RouteName.instrumentIssuanceScreen, {})
                : state is InstrumentReclaimState
                    ? RouteData.getRouteData(
                        context, RouteName.instrumentReclaimScreen, {})
                    : state is InstrumentIssuanceReceiptState
                        ? RouteData.getRouteData(
                            context, RouteName.instrumentIssuanceReceipt, {})
                        : state is InstrumentOutsourceHistoryByContractorState
                            ? RouteData.getRouteData(context,
                                RouteName.instrumentOutsourceHistory, {})
                            : const Center(
                                child: Text(""),
                              ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex(state),
          onDestinationSelected: (index) {
            if (index == 0) {
              blocProvider.add(InstrumentIssuanceEvent());
            } else if (index == 1) {
              blocProvider.add(InstrumentReclaimEvent());
            } else if (index == 2) {
              blocProvider.add(InstrumentIssuanceReceiptEvent());
            } else if (index == 3) {
              blocProvider.add(InstrumentOutsourceHistoryByContractorEvent());
            }
          },
          destinations: bottonNavigationList
              .map((element) => NavigationDestination(
                    icon: MyIconGenerator.getIcon(
                        name: element, iconColor: AppColors.appTheme),
                    label: element,
                  ))
              .toList(),
        ),
      );
    });
  }

  int selectedIndex(CalibrationState state) {
    return state is InstrumentIssuanceState
        ? 0
        : state is InstrumentReclaimState
            ? 1
            : state is InstrumentIssuanceReceiptState
                ? 2
                : state is InstrumentOutsourceHistoryByContractorState
                    ? 3
                    : 0;
  }
}
