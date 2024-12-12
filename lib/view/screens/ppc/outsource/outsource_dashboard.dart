// 13 Sept 2023 - Rohini Mane
import 'package:de/routes/route_names.dart';
import 'package:flutter/material.dart';

import '../../../../routes/route_data.dart';
import '../../../../utils/app_icons.dart';

class OutsourceDashboard extends StatefulWidget {
  const OutsourceDashboard({super.key});

  @override
  State<OutsourceDashboard> createState() => OutsourceDashboardState();
}

class OutsourceDashboardState extends State<OutsourceDashboard> {
  int currentPageIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  String screenName = RouteName.outsource;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RouteData.getRouteData(context, screenName, {}),
        bottomNavigationBar: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: NavigationBar(
              selectedIndex: currentPageIndex,
              onDestinationSelected: (value) {
                setState(() {
                  currentPageIndex = value;
                });
                if (currentPageIndex == 0) {
                  screenName = RouteName.outsource;
                } else if (currentPageIndex == 1) {
                  screenName = RouteName.inward;
                } else if (currentPageIndex == 2) {
                  screenName = RouteName.challanPdf;
                } else if (currentPageIndex == 3) {
                  screenName = RouteName.subcontractorProcess;
                }
              },
              destinations: [
                NavigationDestination(
                  icon: MyIconGenerator.getIcon(
                      name: "Outsource_product", iconColor: Colors.black),
                  label: "Outsource",
                ),
                NavigationDestination(
                  icon: MyIconGenerator.getIcon(
                      name: "Inward", iconColor: Colors.black),
                  label: "Inward",
                ),
                NavigationDestination(
                  icon: MyIconGenerator.getIcon(
                      name: "Challan-PDF", iconColor: Colors.black),
                  label: "Challan-PDF",
                ),
                NavigationDestination(
                  icon: MyIconGenerator.getIcon(
                      name: "Subcontractor-Process", iconColor: Colors.black),
                  label: "Subcontractor-Process",
                )
              ]),
        ));
  }
}
