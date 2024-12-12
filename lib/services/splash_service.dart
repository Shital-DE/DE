// Author : Shital Gayakwad
// Created Date : Feb 2023
// Description : ERPX_PPC -> Splash services
// Modified date : 21 May 2023

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../routes/route_names.dart';
import 'session/user_login.dart';

class SplashServices {
  void checkAuthentication(BuildContext context) async {
    final navigator = Navigator.of(context);
    UserData.getUserData().then((value) async {
      if (value['token'] == null || value['token'] == '') {
        await Future.delayed(const Duration(seconds: 2));
        navigator.pushNamed(RouteName.login);
      } else {
        await Future.delayed(const Duration(seconds: 2));
        navigator.pushNamed(RouteName.dashboard);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {}
    });
  }
}
