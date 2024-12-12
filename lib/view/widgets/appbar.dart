// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/appbar/appbar_bloc.dart';
import '../../bloc/appbar/appbar_event.dart';
import '../../bloc/appbar/appbar_state.dart';
import '../../routes/route_data.dart';
import '../../routes/route_names.dart';
import '../../services/repository/user/user_login_repo.dart';
import '../../services/session/user_login.dart';
import '../../utils/common/quickfix_widget.dart';

class CustomAppbar {
  AppBar appbar({required BuildContext context, required String title}) {
    BlocProvider.of<AppBarBloc>(context).add(AppbarData());
    return AppBar(
      automaticallyImplyLeading: Platform.isAndroid ? false : true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Platform.isAndroid ? 16 : 16),
      ),
      actions: [
        BlocBuilder<AppBarBloc, AppbarState>(
          builder: (context, state) {
            if (state is AppbarLoading && state.workcentreName != '') {
              return Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 7),
                    child: Text(
                      '${state.workcentreName.toString().trim()} : ${state.workstationname.toString().trim()}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  )
                ],
              );
            } else {
              return const Text('');
            }
          },
        ),
        BlocBuilder<AppBarBloc, AppbarState>(
          builder: (context, state) {
            if (state is AppbarLoading) {
              return PopupMenuButton(
                  child: Container(
                      margin: Platform.isAndroid
                          ? const EdgeInsets.only(right: 10, bottom: 10)
                          : const EdgeInsets.all(5),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: state.employeeProfile,
                      )),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Center(
                            child: CircleAvatar(
                          backgroundImage: state.employeeProfile,
                          radius: 70,
                        )),
                      ),
                      PopupMenuItem(
                          child: Center(
                        child: Text(
                          state.employeename,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      )),
                      PopupMenuItem(
                          child: Center(
                        child: Row(
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  final data = await UserData.getUserData();
                                  String response = await UserLoginRepository()
                                      .userLogout(
                                          token: data['token'],
                                          payload: {'id': data['userLogId']});
                                  if (response == 'Updated successfully') {
                                    UserData.removeUserSession().then((value) =>
                                        {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        RouteData.getRouteData(
                                                            context,
                                                            RouteName.login,
                                                            {})),
                                            ModalRoute.withName('/'),
                                          )
                                        });
                                  }
                                },
                                child: const Text('Logout')),
                            QuickFixUi.horizontalSpace(width: 10),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'))
                          ],
                        ),
                      ))
                    ];
                  });
            } else {
              return const Text('');
            }
          },
        )
      ],
    );
  }
}
