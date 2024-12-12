// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Tablet repository

// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../common/api.dart';
import '../../model/machine/assigned_machine.dart';
import '../../model/machine/workcentre.dart';
import '../../model/machine/workstation.dart';

class TabletRepository {
  Future workcentreList(String token) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response =
          await API().getApiResponse(AppUrl.workcentre, headers);
      if (response.body.toString() == 'Server unreachable') {
        return 'Server unreachable';
      } else {
        List<dynamic> workcentreList = [];
        workcentreList = jsonDecode(response.body);
        return workcentreList.map((wc) => Workcentre.fromJson(wc)).toList();
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  Future worstationByWcId(
      {required String token, required String workcentreId}) async {
    try {
      if (workcentreId != '') {
        Map<String, dynamic> payload = {
          'workcentre_id': workcentreId.toString().trim(),
        };
        http.Response response = await API()
            .postApiResponse(AppUrl.workstationByWorkcentreId, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> workstationList = jsonDecode(response.body.toString());
          return workstationList
              .map((ws) => WorkstationByWorkcentreId.fromJson(ws))
              .toList();
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  Future<dynamic> checkTabletIsAlreadyRegisteredOrNot(
      String token, String workstationId) async {
    List<dynamic> checkTabIsAssignedList = [];
    try {
      Map<String, dynamic> payload = {
        'workstation_id': workstationId.toString().trim(),
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.checkTabIsRegisteredOrNot, token, payload);
        checkTabIsAssignedList = jsonDecode(response.body.toString());
      }
    } catch (e) {
      return e.toString();
    }
    return checkTabIsAssignedList
        .map((e) => CheckTabIsAssignedOrNot.fromJson(e))
        .toList();
  }

  Future<dynamic> getAllTabletAssignedList(String token) async {
    List<dynamic> allTabAssignedList = [];
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response =
          await API().getApiResponse(AppUrl.allwcwslistWithAndroidId, headers);
      allTabAssignedList = jsonDecode(response.body.toString());
    } catch (e) {
      return e.toString();
    }
    return allTabAssignedList
        .map((e) => AllWcWsWithAndroidId.fromJson(e))
        .toList();
  }

  Future registerTablet(BuildContext context, String androidId,
      String workcentreid, String workstationid, String token) async {
    try {
      Map<String, dynamic> payload = {
        'id': workstationid.toString().trim(),
        'android_id': androidId.toString().trim()
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().putApiResponse(AppUrl.registerTab, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return QuickFixUi.successMessage('Registration Successful', context);
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  Future<String> deleteTablet(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteTab, token: token, payload: payload);
        if (response.body.toString() == 'Deleted successfully') {
          return 'Deleted successfully';
        } else {
          return response.body;
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Deleted false workcentre list
  Future deletedFalseWorkcentreList({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response =
          await API().getApiResponse(AppUrl.deletedFalseWc, headers);

      List<dynamic> data = jsonDecode(response.body);
      return data.map((wc) => Workcentre.fromJson(wc)).toList();
    } catch (e) {
      return e.toString();
    }
  }
}
