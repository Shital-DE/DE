// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Cutting Repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/operator/cutting_model.dart';

class CuttingRepository {
  Future<String> startCutting(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.startCUtting, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> cuttingStatus(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.cuttingStatus, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> cuttingStatus = jsonDecode(response.body);
          return cuttingStatus.map((e) => CuttingStatus.fromJson(e)).toList();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future cuttingLiveStatus(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.cuttingLiveStatus, token, payload);

        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> cuttingStatus = jsonDecode(response.body);
          return cuttingStatus.map((e) => CuttingStatus.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

  Future cuttingQuantity(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.cuttingQuantity, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          final data = jsonDecode(response.body);
          return data[0]['cuttingqty'].toString();
        }
      }
    } catch (e) {
      //
    }
  }

  Future<dynamic> endCutting(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.cuttingEnd, token, payload);

        if (response.body.toString() == 'Updated successfully') {
          return 'Updated successfully';
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> finishCutting(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.finishCUtting, token, payload);

        if (response.body.toString() == 'Updated successfully') {
          return 'Updated successfully';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
