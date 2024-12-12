// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Quality Repository

// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../utils/app_url.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../common/api.dart';
import '../../model/quality/quality_models.dart';
import '../../session/user_login.dart';

class QualityInspectionRepository {
  // Start inspection
  Future<dynamic> startInspection(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.startInspection, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return response.body.toString();
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      //
    }
  }

  // If inspection is already started then return id
  Future<String> getproductworkstationJobStatusId(
      {required String token, required Map<String, dynamic> payload}) async {
    String inspectionStatusId = '';
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.inspectionId, token, payload);
        if (response.body.toString() == '[]') {
          inspectionStatusId = '';
        } else {
          final data = jsonDecode(response.body);
          inspectionStatusId = data[0]['id'].toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
    return inspectionStatusId;
  }

// If inspection is already started then returning start inpection id
  Future<String> getInspectionTime(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.inspectionTime, token, payload);
        var data = jsonDecode(response.body);
        dynamic parsedDate =
            DateTime.parse(data[0]['startprocesstime'].toString())
                .toLocal()
                .toString()
                .split('.')[0];

        return parsedDate.toString();
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

// Current database time
  Future<String> currentDatabaseTime(
    String token,
  ) async {
    String time = '';
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.currentDatabaseTime, headers);
        var data = jsonDecode(response.body);
        dynamic parsedDate = DateTime.parse(data[0]['now'].toString())
            .toLocal()
            .toString()
            .split('.')[0];
        time = parsedDate.toString();
      }
    } catch (e) {
      //
    }
    return time;
  }

// Rejected reasons list
  Future<List<QualityRejectedReasons>> rejectedReasons(String token) async {
    List<dynamic> rejectedReasonsList = [];
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.qualityRejectedReasons, headers);
        rejectedReasonsList = jsonDecode(response.body);
      }
    } catch (e) {
      //
    }
    return rejectedReasonsList
        .map((e) => QualityRejectedReasons.fromJson(e))
        .toList();
  }

// End inspection
  Future endInspection(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.endInspection, token, payload);

        if (response.body.toString() == 'Updated successfully') {
          return 'Product inspected successfully';
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

// Short quantity
  Future shortQuantity(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.shortQuantityUrl, token, payload);
        response;
      }
    } catch (e) {
      return e.toString();
    }
  }

// Finally end inspection
  Future finalEndInspection(
      {required BuildContext context,
      required String token,
      required Map<String, dynamic> payload,
      required String message}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.finalEndInspection, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return QuickFixUi.successMessage(message, context);
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

// Change end production flag if quantity is rejected in inspection and need to rework
  Future changeEndProductionFlag(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.changeEndProductionFlag, token, payload);
        return response;
      }
    } catch (e) {
      //
    }
  }

// Inspection status check
  Future<bool> jobInspectionStatusCheck(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.inspectionStatusCheck, token, payload);
        final data = jsonDecode(response.body.toString());
        bool status = bool.parse(data[0]['result']);
        return status;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Quality status
  Future<List<QualityProductStatus>> qualityStatus(
      {required Map<String, dynamic> payload}) async {
    List<dynamic> qualitystatuslist = [];
    try {
      final saveddata = await UserData.getUserData();
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.inspectionStatus, saveddata['token'].toString(), payload);
        if (response.body.isNotEmpty) {
          qualitystatuslist = jsonDecode(response.body);
        } else {
          qualitystatuslist = [];
        }
      }
    } catch (e) {
      //
    }
    return qualitystatuslist
        .map((e) => QualityProductStatus.fromJson(e))
        .toList();
  }
}
