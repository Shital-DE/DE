// Author : Shital Gayakwad
// Created Date : 25 Feb 2023
// Description : ERPX_PPC -> User data saved to shared preference
// Modified Date :21 May 2023

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/machine/assigned_machine.dart';
import '../model/user/login_model.dart';

class UserData {
  static Future<bool> saveUserData(
      {required UserLoginModel userLoginModel,
      required List<String> loginCredentials,
      required String userLogId}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> userDataList =
        userLoginModel.data!.map((item) => jsonEncode(item)).toList();
    preferences.setStringList('data', userDataList);
    preferences.setString('token', userLoginModel.token.toString());
    preferences.setStringList('loginCredentials', loginCredentials);
    preferences.setString('userLogId', userLogId);
    return true;
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString('token');
    final List<String> data = preferences.getStringList('data') ?? [];
    List userData = data.map((item) => jsonDecode(item)).toList();
    List<String> loginCredentials =
        preferences.getStringList('loginCredentials') ?? [];
    final String? userLogId = preferences.getString('userLogId');
    Map<String, dynamic> userSavedData = {
      'token': token,
      'data': userData,
      'loginCredentials': loginCredentials,
      'userLogId': userLogId
    };
    return userSavedData;
  }

  static Future<bool> removeUserSession() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    preferences.remove('data');
    preferences.remove('machinedata');
    preferences.remove('barode');
    preferences.remove('userLogId');
    return true;
  }

  static Future<String> authorizeToken() async {
    final data = await UserData.getUserData();
    return data['token'];
  }
}

class MachineData {
  static Future<bool> saveAssignedMachineData(
      List<AssignedMachine> assignedMachineList) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final List<String> dataList =
          assignedMachineList.map((item) => jsonEncode(item)).toList();
      preferences.setStringList('machinedata', dataList);
    } catch (e) {
      //
    }
    return true;
  }

  static Future<List<String>> geMachineData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> machinedata =
        preferences.getStringList('machinedata') ?? [];
    return machinedata;
  }
}
