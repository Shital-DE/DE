// Author : Shital Gayakwad
// Created Date : 30 April 2023
// Description : ERPX_PPC -> Subcontractor repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/common/city_model.dart';
import '../../model/registration/subcontractor_models.dart';

class SubcontractorRepository {
  // All subcontractor list
  Future allSubcontractor({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.subcontractorlist, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => AllSubContractor.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

// Validate subcontractor
  Future validateSubcontractor(
      {required String token, required String id}) async {
    try {
      Map<String, dynamic> payload = {
        'id': id,
      };
      if (payload.isNotEmpty) {
        http.Response? response = await API()
            .postApiResponse(AppUrl.validateSubcontractor, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => AllSubContractor.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

// City list
  Future city({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.city, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => CityModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

// Register subcontractor
  Future registerSubcontractor(
      {required String token,
      required String subcontractorName,
      required String subcontractorId,
      required String address1,
      required String address2}) async {
    try {
      Map<String, dynamic> payload = {
        'name': subcontractorName,
        'address1': address1,
        'address2': address2,
        'subcontractor_id': subcontractorId
      };
      if (payload.isNotEmpty) {
        http.Response? response = await API()
            .postApiResponse(AppUrl.registerSubcontractor, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      //
    }
  }

  // Calibration contractors
  Future<List<CalibrationContractors>> calibrationContractorsData(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.calibrationContractors, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => CalibrationContractors.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
