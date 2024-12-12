// ignore_for_file: depend_on_referenced_packages

/*
/// * Rohini Mane
/// Created 07-02-2024
*/

import 'dart:convert';
import 'package:de/utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../../model/employee_overtime/employee_model.dart';
import '../../session/user_login.dart';

class EmployeeService {
  static Future<List<Employee>> getOperatorList() async {
    try {
      final saveddata = await UserData.getUserData();
      var url = Uri.parse("${AppUrl.baseUrl}/supervisor/emp/operator-list");
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data['data'];
      List<Employee> operatorList =
          list.map((e) => Employee.fromJson(e)).toList();

      return operatorList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<EmpOvertimeWorkstation>> getEmpOvertimewsList() async {
    try {
      final saveddata = await UserData.getUserData();
      var url =
          Uri.parse("${AppUrl.baseUrl}/supervisor/emp/emp-overtime-ws-list");
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data['data'];

      List<EmpOvertimeWorkstation> wslist =
          list.map((e) => EmpOvertimeWorkstation.fromJson(e)).toList();

      return wslist;
    } catch (e) {
      throw Exception(e);
    }
  }
}
