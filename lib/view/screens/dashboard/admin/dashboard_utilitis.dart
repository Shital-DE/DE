import 'package:de/utils/app_icons.dart';
import 'package:de/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../../routes/route_names.dart';
import '../../../../services/model/dashboard/dashboard_model.dart';
import '../../../widgets/appbar.dart';

class DashboardUtility extends StatelessWidget {
  final List<Programs> programsList;
  const DashboardUtility({super.key, required this.programsList});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int gridAxisCount = (size.width / 150).round();

    return Scaffold(
        body: SafeArea(
            child: MakeMeResponsiveScreen(
      mobile: Scaffold(
        appBar: CustomAppbar().appbar(context: context, title: 'Dashboard'),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridAxisCount,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
            ),
            itemCount: programsList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (programsList[index].programname.toString().trim() ==
                      'Capacity plan') {
                    Navigator.pushNamed(context, RouteName.capacityPlan);
                  } else if (programsList[index]
                          .programname
                          .toString()
                          .trim() ==
                      'Machine Status') {
                    Navigator.pushNamed(context, RouteName.machinestatus);
                  } else if (programsList[index]
                          .programname
                          .toString()
                          .trim() ==
                      'Documents') {
                    Navigator.pushNamed(context, RouteName.documents);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.error)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyIconGenerator.getIcon(
                          name:
                              programsList[index].programname.toString().trim(),
                          iconColor: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 150,
                        height: 20,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              programsList[index].programname.toString().trim(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            padding: const EdgeInsets.all(10.0),
          ),
        ),
      ),
    )));
  }
}
