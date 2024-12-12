// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/production/production_bloc.dart';
import '../../../routes/route_data.dart';
import '../../../routes/route_names.dart';
import '../../../services/model/dashboard/dashboard_model.dart';
import '../../../services/model/operator/oprator_models.dart';
import '../../../services/repository/operator/operator_repository.dart';
import '../../../services/session/user_login.dart';
import '../../../utils/app_icons.dart';

class Production extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const Production({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<ProductionBloc>(context);
    blocProvider.add(ProductionInitialEvent());
    return BlocBuilder<ProductionBloc, ProductionState>(
      builder: (context, state) {
        if (state is ProductionLoadingState) {
          return Scaffold(
            body: Builder(builder: (context) {
              List<Programs> programsList = arguments['programs'];
              final element = programsList.elementAt(state.selectedIndex);
              if (element.programname == 'Packing Dashboard') {
                return const Center(
                  child: Text('Packing Dashboard'),
                );
              } else if (element.programname == 'Cutting') {
                return Center(
                  child: RouteData.getRouteData(
                      context,
                      RouteName.cuttingScreen,
                      {'barcode': arguments['barcode']}),
                );
              } else if (element.programname == 'QC Dashboard') {
                return Center(
                    child: RouteData.getRouteData(
                        context,
                        RouteName.qualityScreen,
                        {'barcode': arguments['barcode']}));
              } else if (element.programname == 'Outsourse') {
                return const Center(
                  child: Text('Outsourse'),
                );
              } else if (element.programname == 'Operator  Dashboard') {
                return navigateToOperatorScreens(context: context);
              } else {
                return const Center(
                  child: Text(''),
                );
              }
            }),
            bottomNavigationBar: buttomNavigation(
                programsList: arguments['programs'],
                productionLoadingState: state,
                blocProvider: blocProvider,
                context: context),
          );
        } else {
          return const Text('');
        }
      },
    );
  }

  Center navigateToOperatorScreens({required BuildContext context}) {
    double size = 150;
    return Center(
      child: SizedBox(
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: FilledButton(
                  onPressed: () async {
                    List<String> machinedata =
                        await MachineData.geMachineData();
                    List<dynamic> assignedMachineData =
                        jsonDecode(machinedata.toString());
                    for (var machineData in assignedMachineData) {
                      Navigator.pushNamed(
                          context, RouteName.productionAutomatic, arguments: {
                        'barcode': arguments['barcode'],
                        'machinedata': machineData
                      });
                    }
                  },
                  child: const Text(
                    'Operator automatic',
                    textAlign: TextAlign.center,
                  )),
            ),
            SizedBox(
              height: size,
              width: size,
              child: FilledButton(
                  onPressed: () async {
                    List<String> machinedata =
                        await MachineData.geMachineData();
                    List<dynamic> assignedMachineData =
                        jsonDecode(machinedata.toString());
                    List<MachineCenterProcess> mprocesslist =
                        await OperatorRepository.getMachineProcess();
                    for (var machineData in assignedMachineData) {
                      Navigator.pushNamed(
                        context,
                        RouteName.productionManual,
                        arguments: {
                          'barcode': arguments['barcode'],
                          'processList': mprocesslist,
                          'machinedata': machineData
                        },
                      );
                    }
                  },
                  child: const Text('Operator manual',
                      textAlign: TextAlign.center)),
            )
          ],
        ),
      ),
    );
  }

  NavigationBar buttomNavigation(
      {required List<Programs> programsList,
      required ProductionLoadingState productionLoadingState,
      required ProductionBloc blocProvider,
      required BuildContext context}) {
    return NavigationBar(
        selectedIndex: productionLoadingState.selectedIndex,
        onDestinationSelected: (value) {
          blocProvider.add(ProductionInitialEvent(selectedIndex: value));
          if (value == 0) {}
        },
        destinations: programsList
            .map((e) => NavigationDestination(
                  icon: MyIconGenerator.getIcon(
                      name: e.programname.toString(), iconColor: Colors.black),
                  label: e.programname.toString(),
                ))
            .toList());
  }
}
