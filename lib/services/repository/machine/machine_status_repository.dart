// Author : Shital Gayakwad
// Created Date : 12 April 2023
// Description : ERPX_PPC -> Machine status repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/machine/machine_model.dart';

class MachineStatusRepository {
  //Recent 100 records
  Future recent100Record({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response =
          await API().getApiResponse(AppUrl.recent100Records, headers);
      if (response.body.toString() == 'Server unreachable') {
        return 'Server unreachable';
      } else {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MachineStatusModel.fromJson(e)).toList();
      }
    } catch (e) {
      //
    }
  }

//Workcentre status
  Future workcentreStatus(
      {required String token, required String workcentreid}) async {
    try {
      if (workcentreid != '') {
        Map<String, dynamic> payload = {'workcentreid': workcentreid};

        http.Response response = await API()
            .postApiResponse(AppUrl.workcentrestatus, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => MachineStatusModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

//Workstation status
  Future workstationStatus(
      {required String token,
      required String workcentreid,
      required String workstationid}) async {
    try {
      if (workcentreid != '' && workstationid != '') {
        Map<String, dynamic> payload = {
          'workcentreid': workcentreid,
          'workstationid': workstationid,
        };

        http.Response response = await API()
            .postApiResponse(AppUrl.workstationStatus, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => MachineStatusModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

//Periodic workcentre status
  Future periodicWorkcentreStatus(
      {required String token,
      required String workcentreid,
      required String fromDate,
      required String toDate}) async {
    try {
      if (workcentreid != '' && fromDate != '' && toDate != '') {
        Map<String, dynamic> payload = {
          'workcentreid': workcentreid,
          'from': fromDate,
          'to': toDate
        };

        http.Response response = await API()
            .postApiResponse(AppUrl.workcentrePeriodic, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => MachineStatusModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

//Periodic workstation status
  Future periodicWorkstationStatus(
      {required String token,
      required String workcentreid,
      required String workstationid,
      required String fromDate,
      required String toDate}) async {
    try {
      if (workcentreid != '' &&
          workstationid != '' &&
          fromDate != '' &&
          toDate != '') {
        Map<String, dynamic> payload = {
          'workcentreid': workcentreid,
          'workstationid': workstationid,
          'from': fromDate,
          'to': toDate
        };

        http.Response response = await API()
            .postApiResponse(AppUrl.workstationPeriodic, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => MachineStatusModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

//Selected month workcentre status
  Future selectedMonthWorkcentre(
      {required String token,
      required String workcentreid,
      required String date}) async {
    try {
      Map<String, dynamic> payload = {
        'workcentreid': workcentreid,
        'date': date
      };
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.selectedMonthWorkcentreStatus, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => MachineStatusModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

  //Selected month workstation status
  Future selectedMonthWorkstationStatus(
      {required String token,
      required String workcentreid,
      required String workstationid,
      required String date}) async {
    try {
      Map<String, dynamic> payload = {
        'workcentreid': workcentreid,
        'workstationid': workstationid,
        'date': date
      };
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.selectedMonthWorkstationStatus, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => MachineStatusModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

  //Employee list
  Future workcentreEmployeeList(
      {required String token, required String workcentreid}) async {
    try {
      if (workcentreid != '') {
        Map<String, dynamic> payload = {
          'workcentreid': workcentreid,
        };

        http.Response response = await API()
            .postApiResponse(AppUrl.workcentrewiseEmployeeList, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => WorkcentreWiseEmpList.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

  //Workcentre status employee wise
  Future workcentreStatusEmployee(
      {required String token,
      required String workcentreid,
      required String employeeid}) async {
    Map<String, dynamic> payload = {
      'workcentreid': workcentreid,
      'employeeid': employeeid
    };
    if (payload.isNotEmpty) {
      http.Response response = await API()
          .postApiResponse(AppUrl.workcentreStatusByEmployee, token, payload);
      if (response.body.toString() == 'Server unreachable') {
        return 'Server unreachable';
      } else {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MachineStatusModel.fromJson(e)).toList();
      }
    }
  }

  //Workstationwise employeeList
  Future workstationEmployeeList(
      {required String token,
      required String workcentreid,
      required String workstationid}) async {
    Map<String, dynamic> payload = {
      'workcentreid': workcentreid,
      'workstationid': workstationid
    };
    if (payload.isNotEmpty) {
      http.Response response = await API()
          .postApiResponse(AppUrl.workstationwiseEmployeeList, token, payload);
      if (response.body.toString() == 'Server unreachable') {
        return 'Server unreachable';
      } else {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => WorkcentreWiseEmpList.fromJson(e)).toList();
      }
    }
  }

  //Workstation status by employee
  Future workstationStatusBymployee(
      {required String token,
      required String workcentreid,
      required String workstationid,
      required String employeeid}) async {
    Map<String, dynamic> payload = {
      'workcentreid': workcentreid,
      'workstationid': workstationid,
      'employeeid': employeeid
    };
    if (payload.isNotEmpty) {
      http.Response response = await API()
          .postApiResponse(AppUrl.workstationStatusByEmployee, token, payload);
      if (response.body.toString() == 'Server unreachable') {
        return 'Server unreachable';
      } else {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MachineStatusModel.fromJson(e)).toList();
      }
    }
  }

  Stream<bool> delayedStream() async* {
    await Future.delayed(const Duration(seconds: 3));
    yield true;
  }
}
