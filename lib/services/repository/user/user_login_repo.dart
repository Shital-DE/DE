// // Author : Shital Gayakwad
// // Created Date : 24 Feb 2023
// // Description : ERPX_PPC -> User Login Repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/user/login_model.dart';

class UserLoginRepository {
  Future userLogin(String username, String password) async {
    try {
      if (username != '' && password != '') {
        Map<String, dynamic> payload = {
          'username': username,
          'password': password,
        };

        if (payload.isNotEmpty) {
          http.Response? response =
              await API().postApiResponse(AppUrl.loginUrl, '', payload);
          if (response.body.toString() ==
              'User data not found please check your credentials') {
            return 'User data not found please check your credentials';
          } else if (response.body.toString() == 'Server unreachable') {
            return 'Server unreachable';
          } else {
            UserLoginModel userLoginModel =
                UserLoginModel.fromJson(jsonDecode(response.body));
            return userLoginModel;
          }
        }
      }
    } catch (e) {
      //
    }
  }

  // Employee profile data
  Future<dynamic> employeeProfile(String empprofilemdocid, String token) async {
    try {
      if (empprofilemdocid.isNotEmpty) {
        Map<String, dynamic> payload = {'id': empprofilemdocid.trim()};
        http.Response? response =
            await API().postApiResponse(AppUrl.empProfilePhoto, token, payload);
        if (response.statusCode != 200) {
          return response.statusCode.toString();
        } else if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          Uint8List profileData = base64.decode(response.body);
          return profileData;
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Employee log history
  Future<String> employeeLogHistory(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response? response =
            await API().postApiResponse(AppUrl.userLoginLog, token, payload);
        if (response.body.toString().length == 32) {
          return response.body.toString();
        } else {
          return '';
        }
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Log out
  Future<String> userLogout(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().putApiResponse(AppUrl.logoutUrl, token, payload);
        return response.body.toString();
      } else {
        return 'Id not found';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
