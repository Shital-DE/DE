// Author : Shital Gayakwad
// Created Date : 26 Feb 2023
// Description : ERPX_PPC -> Dashboard
// Modified data : 21 May 2023

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../routes/route_data.dart';
import '../../routes/route_names.dart';
import '../../services/repository/user/user_login_repo.dart';
import '../../services/session/barcode.dart';
import '../../services/session/user_login.dart';

class Logout {
  Future<dynamic> logOut(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Do you want to logout?'),
          actions: [
            FilledButton(
                onPressed: () async {
                  final data = await UserData.getUserData();
                  String response = await UserLoginRepository().userLogout(
                      token: data['token'], payload: {'id': data['userLogId']});
                  if (response == 'Updated successfully') {
                    await ProductData.removeBorcodeSession();
                    UserData.removeUserSession().then((value) => {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RouteData.getRouteData(
                                        context, RouteName.login, {})),
                            ModalRoute.withName('/'),
                          )
                        });
                  }
                },
                child: const Text('Yes')),
            FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'))
          ],
        );
      },
    );
  }
}
