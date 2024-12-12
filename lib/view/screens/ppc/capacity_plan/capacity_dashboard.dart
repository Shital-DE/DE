/// Modified 7 June 2023 By Shital Gayakwad Removed Next and CP button and added to  bottom navigation
// Modified 18 Aug 2023 - Rohini Mane
import 'package:de/bloc/ppc/capacity_plan/bloc/capacity_dashboard/bloc/capacity_dashboard_bloc.dart';
import 'package:de/routes/route_names.dart';
// import 'package:de/routes/route_names.dart';
import 'package:de/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../routes/route_data.dart';

class CapacityDashboard extends StatefulWidget {
  const CapacityDashboard({super.key});

  @override
  State<CapacityDashboard> createState() => _CapacityDashboardState();
}

class _CapacityDashboardState extends State<CapacityDashboard> {
  @override
  void dispose() {
    super.dispose();
  }

  //String screenName = RouteName.runTimeMaster;
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CapacityDashboardBloc>(context);

    blocProvider.add(CapacityIndex());
    return Scaffold(
      body: BlocBuilder<CapacityDashboardBloc, CapacityDashboardState>(
        builder: (context, state) {
          if (state is CapacityDashboardLoading) {
            if (state.selectedIndex == 0) {
              return RouteData.getRouteData(context, RouteName.cpBarChart, {});
            } else if (state.selectedIndex == 1) {
              return RouteData.getRouteData(
                  context, RouteName.workcentreShift, {});
            } else if (state.selectedIndex == 2) {
              return RouteData.getRouteData(context, RouteName.newCpPlan, {});
            }
            // else if (state.selectedIndex == 3) {
            //   return RouteData.getRouteData(
            //       context, RouteName.updateCpPlan, {});
            // }
            else if (state.selectedIndex == 3) {
              return RouteData.getRouteData(
                  context, RouteName.cpDragAndDrop, {});
            }
            // else if (state.selectedIndex == 5) {
            //   return RouteData.getRouteData(context, RouteName.poPlanDate, {});
            // }
            else {
              return const SizedBox();
            }
          } else {
            return const SizedBox();
          }
        },
      ),
      // RouteData.getRouteData(context, screenName, {}),
      bottomNavigationBar:
          BlocBuilder<CapacityDashboardBloc, CapacityDashboardState>(
        builder: (context, state) {
          if (state is CapacityDashboardLoading) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: NavigationBar(
                  selectedIndex: state.selectedIndex,
                  onDestinationSelected: (value) {
                    blocProvider.add(CapacityIndex(selectedIndex: value));
                  },
                  destinations: state.navigationItemsList
                      .map((e) => NavigationDestination(
                            icon: MyIconGenerator.getIcon(
                                name: e.toString(), iconColor: Colors.black),
                            label: e.toString(),
                          ))
                      .toList()),
            );
          } else {
            return const Text('');
          }
        },
      ),
    );
  }
}
