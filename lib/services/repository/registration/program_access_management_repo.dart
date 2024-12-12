// Author : Shital Gayakwad
// Created Date : 28 May 2024
// Description : Program access management

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/registration/program_access_management_model.dart';

class ProgramAccessManagementRepository {
  // Program access management
  Future<List<ProgramAccessManagementModel>> programAccessManagementData(
      {required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response = await API()
            .getApiResponse(AppUrl.programAccessManagementData, headers);
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => ProgramAccessManagementModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Delete user from role
  Future<String> deleteUserFromRole(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteUserFromRole, token: token, payload: payload);
        if (response.body == 'Updated successfully') {
          return 'Updated successfully';
        } else {
          return response.body;
        }
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete program assigned to role
  Future<String> deleteProgramFromRole(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteProgramAssignedToTheRole,
            token: token,
            payload: payload);
        if (response.body == 'Updated successfully') {
          return 'Updated successfully';
        } else {
          return response.body;
        }
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
