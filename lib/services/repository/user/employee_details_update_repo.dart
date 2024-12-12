// Author : Shital Gayakwad
// Description : Employee details update repository
// Created Date : 23 August 2024

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:de/services/model/user/login_model.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../../view/widgets/image_utility.dart';
import '../../common/api.dart';

class EmployeeDetailsUpdateRepo {
  // All employee details
  Future<List<UserDataModel>> allEmployeeDetails(
      {required String token, required int index}) async {
    try {
      http.Response response = await API()
          .getApiResponse('${AppUrl.allEmployeeDetailsUrl}?index=$index', {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UserDataModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Update employee profile
  Future updateEmployeeProfile(
      {required String token,
      required String id,
      required File profile}) async {
    try {
      dynamic cmpressedImage =
          await ImageUtility().imageCompresser(profile: profile);

      Map<String, dynamic> payload = {
        "id": id,
        "data": base64Encode(cmpressedImage),
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.updateEmployeeProfile, token, payload);
        final data = jsonDecode(response.body);
        if (data['message'] == 'Record updated successfully.') {
          return data;
        }
      }
    } catch (e) {
      return {};
    }
  }

  // View aadhar photo
  Future<dynamic> viewAadhar(
      {required String id, required String token}) async {
    try {
      if (id.isNotEmpty) {
        http.Response? response = await API()
            .postApiResponse(AppUrl.viewAadharUrl, token, {'id': id.trim()});
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

  // Update aadhar card
  Future updateAadharcard(
      {required String token,
      required String id,
      required File profile}) async {
    try {
      dynamic cmpressedImage =
          await ImageUtility().imageCompresser(profile: profile);

      Map<String, dynamic> payload = {
        "id": id,
        "data": base64Encode(cmpressedImage),
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.updateAadharcard, token, payload);
        final data = jsonDecode(response.body);
        if (data['message'] == 'Record updated successfully.') {
          return data;
        }
      }
    } catch (e) {
      return {};
    }
  }

  // View pan card
  Future<dynamic> viewPan({required String id, required String token}) async {
    try {
      if (id.isNotEmpty) {
        http.Response? response = await API()
            .postApiResponse(AppUrl.viewPanUrl, token, {'id': id.trim()});
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

  // Update pan card
  Future updatePancard(
      {required String token,
      required String id,
      required File profile}) async {
    try {
      dynamic cmpressedImage =
          await ImageUtility().imageCompresser(profile: profile);

      Map<String, dynamic> payload = {
        "id": id,
        "data": base64Encode(cmpressedImage),
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.updatePancard, token, payload);
        final data = jsonDecode(response.body);
        if (data['message'] == 'Record updated successfully.') {
          return data;
        }
      }
    } catch (e) {
      return {};
    }
  }

  // Update employee details
  Future<String> updateEmployeeData(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.updateEmployeeUrl, token, payload);
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['Message'].toString() == 'Success') {
          return data['Message'];
        } else {
          return 'Record not updated.';
        }
      } else {
        return 'Record not updated.';
      }
    } catch (e) {
      return 'Record not updated.';
    }
  }
}
