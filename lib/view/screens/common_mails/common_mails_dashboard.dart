// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration screen

import 'package:de/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../routes/route_data.dart';
import '../../../../routes/route_names.dart';
import '../../../../utils/app_icons.dart';

import '../../../bloc/common_mail/mails/common_mails_bloc.dart';
import '../../../bloc/common_mail/mails/common_mails_event.dart';
import '../../../bloc/common_mail/mails/common_mails_state.dart';

class CommonMails extends StatelessWidget {
  const CommonMails({super.key});
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CommonMailsBloc>(context);
    blocProvider.add(BulkmailsendEvent());
    return MakeMeResponsiveScreen(
      horixontaltab:
          poDashboardWidget(context: context, blocProvider: blocProvider),
      windows: poDashboardWidget(context: context, blocProvider: blocProvider),
      linux: poDashboardWidget(context: context, blocProvider: blocProvider),
    );
  }

  Scaffold poDashboardWidget(
      {required BuildContext context, required CommonMailsBloc blocProvider}) {
    return Scaffold(
      // appBar:
      //     CustomAppbar().appbar(context: context, title: 'Comman Mails orders'),
      body: BlocBuilder<CommonMailsBloc, CommonMailState>(
          builder: (context, state) {
        if (state is UploadOrderState) {
          return RouteData.getRouteData(context, RouteName.mailmodule, {});
        }
        // else if (state is OthersState) {
        //   return RouteData.getRouteData(context, RouteName.rawMinward, {});
        // }
        else {
          return const Center(child: Text('Screen is not assigned.'));
        }
      }),
      bottomNavigationBar: BlocBuilder<CommonMailsBloc, CommonMailState>(
          builder: (context, state) {
        List<String> programsList = [
          'Bulk Mails',
          'Other Mails',
        ];
        return NavigationBar(
          selectedIndex: selectedIndex(state),
          onDestinationSelected: (destination) {
            debugPrint("destination---->>");
            debugPrint(destination.toString());
            if (destination == 0) {
              blocProvider.add(BulkmailsendEvent());
            } else if (destination == 1) {
              // blocProvider.add(OtherEvent());
            }
          },
          destinations: programsList
              .map((e) => NavigationDestination(
                    icon: MyIconGenerator.getIcon(
                        name: e.toString(), iconColor: Colors.black),
                    label: e.toString(),
                  ))
              .toList(),
        );
      }),
    );
  }

  int selectedIndex(CommonMailState state) {
    if (state is UploadOrderState) {
      return 0;
    }
    // else if (state is OthersState) {
    //   return 1;
    // }
    else {
      return 0;
    }
  }
}
