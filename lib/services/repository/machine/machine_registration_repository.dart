// Author : Shital Gayakwad
// Created Date : 14 March 2023
// Description : ERPX_PPC -> Machine registration repository
// Modified Date :

// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../bloc/registration/machine_registration/machine_register_bloc.dart';
import '../../../utils/app_url.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../common/api.dart';
import '../../model/registration/machine_registration_model.dart';
import '../../session/user_login.dart';

class MachineRegistrationRepository {
  Future isinhouseallWorkcentres(String token) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response =
          await API().getApiResponse(AppUrl.isinhouseWorkcentres, headers);
      if (response.body.toString() == 'Server unreachable') {
        return 'Server unreachable';
      } else {
        List<dynamic> workcentreList = jsonDecode(response.body);
        return workcentreList
            .map((e) => IsinHouseWorkcentre.fromJson(e))
            .toList();
      }
    } catch (e) {
      //
    }
  }

  Future getShiftPattern(String token) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response =
          await API().getApiResponse(AppUrl.shiftPattern, headers);
      if (response.body.toString() == 'Server unreachable') {
        return 'Server unreachable';
      } else {
        List<dynamic> shiftPatternList = jsonDecode(response.body);
        return shiftPatternList.map((e) => ShiftPattern.fromJson(e)).toList();
      }
    } catch (e) {
      //
    }
  }

  Future<List<Company>> getCompany(String token) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response =
          await API().getApiResponse(AppUrl.company, headers);
      if (response.body.toString() == ' Server unreachable') {
        return [];
      } else {
        List<dynamic> companyList = jsonDecode(response.body);
        return companyList.map((e) => Company.fromJson(e)).toList();
      }
    } catch (e) {
      return [];
    }
  }

  Future registerWorkcentre(
      String token,
      String workcentre,
      String shiftPatternId,
      String companyId,
      String companyCode,
      String defaultmin,
      String isinhouse,
      BuildContext context) async {
    try {
      int min = int.parse(defaultmin);
      Map<String, dynamic> payload = {
        'workcentre_code': workcentre.toString().trim(),
        'shiftpattern_id': shiftPatternId.toString().trim(),
        'company_id': companyId.toString().trim(),
        'company_code': companyCode.toString().trim(),
        'defaultmin': defaultmin == '' ? 0 : min,
        'isinhouse': isinhouse == '' ? 'Y' : isinhouse.toString().trim()
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerWorkcentre, token, payload);
        if (response.statusCode == 200) {
          BlocProvider.of<MachineRegisterBloc>(context).add(
              MachineScreenLoadingEvent(
                  false, '', '', '', '', '', '', false, '', -1, ''));
          return QuickFixUi.successMessage(
              'Workcentre registered successfully', context);
        }
      }
    } catch (e) {
      //
    }
  }

  Future registerWorkstation(
      String workcentreid,
      String shiftPatternid,
      String workstationcode,
      String workcentrecode,
      String isihhouse,
      String token,
      BuildContext context) async {
    try {
      final data = await UserData.getUserData();
      String username = '';
      for (var userdata in data['data']) {
        username = userdata['employeeusername'];
      }
      Map<String, dynamic> payload = {
        'createdby': username,
        'wr_workcentre_id': workcentreid,
        'shiftpattern_id': shiftPatternid,
        'code': workstationcode,
        'workstationgroup_code': workcentrecode,
        'isinhouse': isihhouse
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerWorkstation, token, payload);
        if (response.body.toString() == 'success') {
          return QuickFixUi.successMessage(
              'Workstation register successfully', context);
        }
      }
    } catch (e) {
      //
    }
  }
}
