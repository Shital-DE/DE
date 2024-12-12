// Author : Shital Gayakwad
// Created Date : 30 October 2024
// Description : Product registration

import 'package:de/routes/route_data.dart';
import 'package:de/routes/route_names.dart';
import 'package:de/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/product_dashboard/product_dashboard_bloc.dart';
import '../../../bloc/product_dashboard/product_dashboard_event.dart';
import '../../../bloc/product_dashboard/product_dashboard_state.dart';
import '../../../utils/app_icons.dart';
import '../../widgets/appbar.dart';

class PAMDashboard extends StatelessWidget {
  const PAMDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<ProductDashboardBloc>(context);
    blocProvider.add(ProductInventoryManagementEvent());
    return MakeMeResponsiveScreen(
      horixontaltab:
          pamDashboardWIdget(context: context, blocProvider: blocProvider),
      windows: pamDashboardWIdget(context: context, blocProvider: blocProvider),
      linux: pamDashboardWIdget(context: context, blocProvider: blocProvider),
    );
  }

  Scaffold pamDashboardWIdget(
      {required BuildContext context,
      required ProductDashboardBloc blocProvider}) {
    return Scaffold(
      appBar:
          CustomAppbar().appbar(context: context, title: 'Product dashboard'),
      body: BlocBuilder<ProductDashboardBloc, ProductDashboardState>(
          builder: (context, state) {
        if (state is ProductAssetsManagementInitialState) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else if (state is ProductRegistrationState) {
          return RouteData.getRouteData(
              context, RouteName.productRegistration, {
            'unitOfMeasurementList': state.unitOfMeasurementList,
            'productTypeList': state.productTypeList
          });
        } else if (state is ProductStructureState) {
          return RouteData.getRouteData(
              context, RouteName.productStructure, {});
        } else if (state is ProductInventoryManagementState) {
          return
              // const Center(child: Text('Working on this screen.'));
              RouteData.getRouteData(
                  context, RouteName.productInventoryManagementScreen, {});
        } else {
          return const Center(child: Text('No screen assigned.'));
        }
      }),
      bottomNavigationBar:
          BlocBuilder<ProductDashboardBloc, ProductDashboardState>(
              builder: (context, state) {
        List<String> programsList = [
          'Product registration',
          'Product structure',
          'Product inventory',
        ];
        return NavigationBar(
            selectedIndex: state is ProductRegistrationState
                ? 0
                : state is ProductStructureState
                    ? 1
                    : 2,
            onDestinationSelected: (destination) {
              if (destination == 0) {
                blocProvider.add(ProductRegistrationEvent());
              } else if (destination == 1) {
                blocProvider.add(ProductStructureEvent());
              } else if (destination == 2) {
                blocProvider.add(ProductInventoryManagementEvent());
              }
            },
            destinations: programsList
                .map((e) => NavigationDestination(
                      icon: MyIconGenerator.getIcon(
                          name: e.toString(), iconColor: Colors.black),
                      label: e.toString(),
                    ))
                .toList());
      }),
    );
  }
}
