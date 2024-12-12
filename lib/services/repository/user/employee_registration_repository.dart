// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../../../view/widgets/image_utility.dart';
import '../../common/api.dart';
import '../../model/common/state_model.dart';
import '../../model/user/user_registration_model.dart';
import '../../session/user_login.dart';
import '../../session/user_registration.dart';

class UserRegistrationRepository {
  // State list
  Future state({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.state, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => StateModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

// Employee type
  Future employeeType({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.employeetype, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => EmployeeType.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

// Employee department
  Future employeeDepartment({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.department, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => Department.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

// Employee designation
  Future employeeDesignation({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.designation, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => Designation.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

//Employee id
  Future employeeId(
      {required String empType,
      required String empDepartment,
      required String token}) async {
    try {
      Map<String, String> payload = {
        'empType': empType,
        'empDepartment': empDepartment
      };
      if (payload.isNotEmpty) {
        String serialNo = '000001';
        http.Response response =
            await API().postApiResponse(AppUrl.employeeId, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          if (response.body.toString() == '[]') {
            if (empDepartment != '' && empType != '') {
              return '${empDepartment.trim()}-${empType.trim()}-$serialNo';
            } else {
              return '';
            }
          } else {
            final data = jsonDecode(response.body);
            int empId =
                int.parse(data[0]['code'].toString().trim().split('-')[2]) + 1;
            String employeeId = empId.toString().padLeft(6, '0');
            if (empDepartment != '' && empType != '') {
              return '${empDepartment.trim()}-${empType.trim()}-$employeeId';
            } else {
              return '';
            }
          }
        }
      }
    } catch (e) {
      //
    }
  }

// register employee
  Future registerEmployee({required String token}) async {
    try {
      final saveddata = await UserData.getUserData(); //User data
      Map<String, dynamic> empPersonalInfo =
          await EmployeeeRegistrationSession.getEmpPersonalInfo();
      Map<String, dynamic> addressInfo =
          await EmployeeeRegistrationSession.getEmployeeAddress();
      Map<String, dynamic> docInfo =
          await EmployeeeRegistrationSession.getDocumentsInfo();
      Map<String, dynamic> employmentInfo =
          await EmployeeeRegistrationSession.getEmployementDetails();
      Map<String, dynamic> payload = {
        'createdby': saveddata['data'][0]['id'].toString().trim(),
        'empPersonalInfo': empPersonalInfo,
        'empAddress': addressInfo,
        'empDocuments': docInfo,
        'empEmployment': employmentInfo,
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerEmployee, token, payload);
        debugPrint(response.body.toString());
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      //
    }
  }

// Employee profile photo registration
  Future registerEmployeeProfile(
      {required Map<String, dynamic> documentsData,
      required String token}) async {
    try {
      final profile = File(documentsData['emp_profile']);
      dynamic cmpressedImage =
          await ImageUtility().imageCompresser(profile: profile);

      Map<String, dynamic> payload = {
        "postgresql_id": documentsData['emp_id'],
        "name": documentsData['emp_name'].toString().toUpperCase(),
        "data": base64Encode(cmpressedImage),
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.employeeProfileRegister, token, payload);
        final data = jsonDecode(response.body);
        if (data['message'] == 'Record inserted successfully.') {
          return data;
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Pan card registration
  Future registerPanCard(
      {required Map<String, dynamic> documentsData,
      required String token}) async {
    try {
      final panImage = File(documentsData['pancard']);
      dynamic cmpressedImage =
          await ImageUtility().imageCompresser(profile: panImage);

      Map<String, dynamic> panpayload = {
        "postgresql_id": documentsData['emp_id'],
        "name": documentsData['emp_name'].toString().toUpperCase(),
        "data": base64Encode(cmpressedImage),
      };

      if (panpayload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.panRegister, token, panpayload);
        final data = jsonDecode(response.body);
        if (data['message'] == 'Record inserted successfully.') {
          return data;
        }
      }
    } catch (e) {
      //
    }
  }

// register aadhar card
  Future registerAadharCard(
      {required Map<String, dynamic> documentsData,
      required String token}) async {
    try {
      final aadharImage = File(documentsData['adharcard']);
      dynamic cmpressedImage =
          await ImageUtility().imageCompresser(profile: aadharImage);

      Map<String, dynamic> panpayload = {
        "postgresql_id": documentsData['emp_id'],
        "name": documentsData['emp_name'].toString().toUpperCase(),
        "data": base64Encode(cmpressedImage),
      };

      if (panpayload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.aadharRegister, token, panpayload);
        final data = jsonDecode(response.body);
        if (data['message'] == 'Record inserted successfully.') {
          return data;
        }
      }
    } catch (e) {
      //
    }
  }

  Future documentsRegistration(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.registerEmpDocs, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return response.body.toString();
        }
      }
    } catch (e) {
      //
    }
  }
}
