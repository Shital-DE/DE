// Author : Shital Gayakwad
// Created Date : 26 Feb 2023
// Description : ERPX_PPC -> Dashboard
// Modified data : 23 April 2024
// Modification description : Changes in navigation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../../bloc/dashboard/dashboard_event.dart';
import '../../../bloc/dashboard/dashboard_state.dart';
import '../../../routes/route_data.dart';
import '../../../routes/route_names.dart';
import '../../../services/model/dashboard/dashboard_model.dart';
import '../../../services/session/barcode.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/responsive.dart';
import '../../widgets/appbar.dart';
import '../../widgets/logout.dart';
import 'admin/admin_dashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final int crossAxisCount = 3;
  final double childAspectRatio = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final blocProvider = BlocProvider.of<DashboardBloc>(context);
    callDashboardBloc(blocProvider: blocProvider, size: size);

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            return;
          }
          final NavigatorState navigator = Navigator.of(context);
          final bool? shouldPop = await Logout().logOut(context);
          if (shouldPop ?? false) {
            navigator.pop();
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState) {
              return MakeMeResponsiveScreen(
                  windows: dashboardScreen(
                      blocProvider: blocProvider,
                      context: context,
                      data: state.data,
                      index: state.selectedIndex,
                      programsList: state.programsList),
                  horixontaltab: dashboardScreen(
                      blocProvider: blocProvider,
                      context: context,
                      data: state.data,
                      index: state.selectedIndex,
                      programsList: state.programsList),
                  mobile: Scaffold(
                    appBar: CustomAppbar()
                        .appbar(context: context, title: 'Dashboard'),
                    body: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Dashboardresponsive(
                          programsList: state.programsList,
                        )),
                  ));
            }
            return const Scaffold();
          },
        ));
  }

  callDashboardBloc({required DashboardBloc blocProvider, required Size size}) {
    ProductData.getbarocodeData().then((value) {
      blocProvider
          .add(DashboardMenuEvent(platform: size.width < 900 ? 'Mobile' : ''));
    });
  }

  dashboardScreen(
      {required DashboardBloc blocProvider,
      required BuildContext context,
      required List<UserModule> data,
      required int index,
      required List<Programs> programsList}) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: 'Dashboard'),
      body:
          // SingleChildScrollView(
          //   child:
          SizedBox(
        width: size.width,
        height: size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            data.isNotEmpty &&
                    data.length >= 2 &&
                    data[0].foldername != 'Incorrect password.'
                ? NavigationRail(
                    selectedIndex: index,
                    groupAlignment: -1.0,
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: (value) {
                      final element = data.elementAt(value);
                      if (element.foldername == 'Document') {
                        Navigator.pushNamed(context, RouteName.documents);
                      } else if (element.foldername == 'Registration') {
                        blocProvider.add(DashboardMenuEvent(
                            selectedIndex: value,
                            folder: {
                              'id': data[value].folderId.toString(),
                              'name': data[value].foldername.toString()
                            }));
                        Navigator.pushNamed(context, RouteName.registration,
                            arguments: {
                              'programs': programsList,
                              'folder': {
                                'id': data[value].folderId.toString(),
                                'name': data[value].foldername.toString()
                              }
                            });
                      }
                      blocProvider.add(DashboardMenuEvent(
                          selectedIndex: value,
                          folder: {
                            'id': data[value].folderId.toString(),
                            'name': data[value].foldername.toString()
                          }));
                    },
                    destinations: data
                        .map(
                          (e) => NavigationRailDestination(
                            padding: const EdgeInsets.only(top: 10, left: 5),
                            icon: MyIconGenerator.getIcon(
                                name: e.foldername.toString(),
                                iconColor: Colors.black),
                            label: Text(e.foldername.toString()),
                          ),
                        )
                        .toList())
                : const Text(''),
            data[0].foldername == 'Incorrect password.'
                ? const Center(child: Text('Incorrect hashed password.'))
                : dashboard(context)
          ],
        ),
      ),
      // ),
    );
  }

  SizedBox dashboard(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width - 114,
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState) {
              if (state.selectedIndex == 0 &&
                  state.data.isNotEmpty &&
                  state.data[0].foldername == 'Production') {
                if (state.workcentreid != '') {
                  if (state.isautomatic == 'Y') {
                    return RouteData.getRouteData(
                        context,
                        RouteName.pendingProduction,
                        {'programs': state.programsList});
                  } else if (state.isautomatic == 'N') {
                    return RouteData.getRouteData(
                        context,
                        RouteName.barcodeScan,
                        {'programs': state.programsList});
                  } else {
                    return RouteData.getRouteData(
                        context,
                        RouteName.barcodeScan,
                        {'programs': state.programsList});
                  }
                } else {
                  return defaultScreen(
                      program: state.programsList.isNotEmpty
                          ? state.programsList[0].programname.toString()
                          : '');
                }
              } else if (state.folder['name'] == 'PPC' ||
                  state.folder['name'] == 'Tools') {
                return ppc(context, state);
              } else if (state.folder['name'] == 'Quality') {
                return quality(context, state);
              } else if (state.folder['name'] == 'Account') {
                return const Text('');
              } else if (state.folder['name'] == 'Dashboard') {
                return Dashboardresponsive(
                  programsList: state.programsList,
                );
              } else {
                return defaultScreen(
                    program: state.programsList.isNotEmpty
                        ? state.programsList[0].programname.toString()
                        : '');
              }
            } else {
              return defaultScreen(program: '');
            }
          },
        ));
  }

  Widget defaultScreen({required String program}) {
    if (program == 'Mail') {
      return RouteData.getRouteData(context, RouteName.mailmoduledashbord, {});
    } else {
      return const Center(child: Text('No screen found.'));
    }
  }

  Container ppc(BuildContext context, DashboardLoadingState state) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(50),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth > 1360 ? 10 : (screenWidth > 850 ? 7 : 4),
          crossAxisSpacing: 30,
          mainAxisSpacing: 10,
        ),
        itemCount: state.programsList.length,
        itemBuilder: (context, index) {
          Programs program = state.programsList[index];
          return InkWell(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MyIconGenerator.getIcon(
                              name: state.programsList[index].programname
                                  .toString(),
                              iconColor: Theme.of(context).primaryColor,
                              size: 35))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        program.programname.toString().trim(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (state.programsList[index].programname.toString() ==
                  'Machine Status') {
                Navigator.pushNamed(context, RouteName.machinestatus);
              } else if (state.programsList[index].programname.toString() ==
                  'Capacity plan') {
                Navigator.pushNamed(context, RouteName.capacityPlan);
              } else if (state.programsList[index].programname.toString() ==
                  'Upload product details') {
                Navigator.pushNamed(context, RouteName.uploadproductdetails);
              } else if (state.programsList[index].programname.toString() ==
                  'Product Route') {
                Navigator.pushNamed(context, RouteName.productProcessRoute);
              } else if (state.programsList[index].programname.toString() ==
                  'Outsource') {
                Navigator.pushNamed(context, RouteName.outsourceDashboard);
              } else if (state.programsList[index].programname.toString() ==
                  'Stock') {
                Navigator.pushNamed(context, RouteName.stock);
              } else if (state.programsList[index].programname.toString() ==
                  'Product dashboard') {
                Navigator.pushNamed(
                    context, RouteName.productAssetsManagementScreen);
              } else if (state.programsList[index].programname.toString() ==
                  'Sales orders') {
                Navigator.pushNamed(context, RouteName.assemblySalesOrders);
              } else if (state.programsList[index].programname.toString() ==
                  'Tool Issue') {
                Navigator.pushNamed(context, RouteName.toolIssue);
              } else if (state.programsList[index].programname.toString() ==
                  'Tool Receipt') {
                Navigator.pushNamed(context, RouteName.toolReceipt);
              } else if (state.programsList[index].programname.toString() ==
                  'Tool Stock') {
                Navigator.pushNamed(context, RouteName.toolStock);
              }
            },
          );
        },
      ),
    );
  }

  Container quality(BuildContext context, DashboardLoadingState state) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(50),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth > 1360 ? 10 : (screenWidth > 850 ? 7 : 4),
          crossAxisSpacing: 30,
          mainAxisSpacing: 10,
        ),
        itemCount: state.programsList.length,
        itemBuilder: (context, index) {
          Programs program = state.programsList[index];
          return InkWell(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MyIconGenerator.getIcon(
                              name: state.programsList[index].programname
                                  .toString(),
                              iconColor: Theme.of(context).primaryColor,
                              size: 35))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        program.programname.toString().trim(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (state.programsList[index].programname.toString() ==
                  'Calibration') {
                Navigator.pushNamed(context, RouteName.calibration);
              }
            },
          );
        },
      ),
    );
  }
}
