import 'package:flutter/material.dart';

import '../../../../../routes/route_data.dart';
import '../../../../../routes/route_names.dart';
import '../../../../../services/model/dashboard/dashboard_model.dart';
import '../../../../../utils/app_icons.dart';

class ToolDashboard extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const ToolDashboard({super.key, required this.arguments});

  @override
  State<ToolDashboard> createState() => _ToolDashboardState();
}

class _ToolDashboardState extends State<ToolDashboard> {
  int currentPageIndex = 0;
  List<Programs> programsList = [];
  String screenName = "";
  @override
  void initState() {
    programsList = widget.arguments["programs"];
    // screenName =
    //     programsList.length > 1 ? RouteName.toolReceipt : RouteName.toolIssue;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(t),
        body: programsList.length > 1
            ? const Center(child: Text("1----"))
            : RouteData.getRouteData(context, RouteName.toolIssue, {}),
        bottomNavigationBar: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: programsList.length > 1
                ? NavigationBar(
                    selectedIndex: currentPageIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        currentPageIndex = value;
                      });
                      if (currentPageIndex == 0) {
                        screenName = RouteName.toolReceipt;
                      } else if (currentPageIndex == 1) {
                        screenName = RouteName.toolStock;
                      }
                    },
                    destinations: programsList
                        .map((i) => NavigationDestination(
                              icon: MyIconGenerator.getIcon(
                                  name: i.programname.toString(),
                                  iconColor: Colors.black),
                              label: i.programname.toString(),
                            ))
                        .toList())
                : const SizedBox()));
  }
}
