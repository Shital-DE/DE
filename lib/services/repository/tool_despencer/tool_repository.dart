import 'dart:convert';

import 'package:de/services/model/employee_overtime/employee_model.dart';
import 'package:http/http.dart' as http;

import '../../model/tool_despencer/tool.dart';
import '../../model/tool_despencer/toolstock.dart';
import '../../session/user_login.dart';

class ToolRepository {
  static Future<List<Employee>> getOperatorList() async {
    try {
      // var url = Uri.parse("${AppUrl.baseUrl}/supervisor/emp/operator-list");
      var url =
          Uri.parse("https://192.168.0.183:8081/supervisor/emp/operator-list");

      final saveddata = await UserData.getUserData();

      http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      // print(data["data"]);
      if (response.statusCode == 200) {
        List<Employee> empList = list.map((e) => Employee.fromJson(e)).toList();
        return empList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Tool>> getToolList() async {
    try {
      // var url = Uri.parse("${AppUrl.baseUrl}/tool/transaction/tool-list");
      var url =
          Uri.parse("https://192.168.0.183:8081/tool/transaction/tool-list");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      // print(data["data"]);
      if (response.statusCode == 200) {
        List<Tool> toolList = list.map((e) => Tool.fromJson(e)).toList();
        return toolList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<String> saveToolIssue(
      {required String toolId, required int qty}) async {
    try {
      final saveddata = await UserData.getUserData();
      // var url = Uri.parse("${AppUrl.baseUrl}/tool/transaction/save-tool-stock");

      var url = Uri.parse(
          "https://192.168.0.183:8081/tool/transaction/save-tool-stock");

      Object body = ToolStock(
              date: DateTime.now().toString(),
              transactiontypeId: 'TTI',
              toolId: toolId,
              employeeId: saveddata['data'][0]['id'].toString(),
              drcr: 'C',
              qty: qty,
              balance: qty)
          .toJson();

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}',
        },
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "fail";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> saveToolDamageEntry(
      {required String toolId, required int qty}) async {
    try {
      final saveddata = await UserData.getUserData();
      // var url = Uri.parse("${AppUrl.baseUrl}/tool/transaction/save-damaged-tool");

      var url = Uri.parse(
          "https://192.168.0.183:8081/tool/transaction/save-damaged-tool");

      Object body = ToolStock(
              date: DateTime.now().toString(),
              transactiontypeId: 'TTI',
              toolId: toolId,
              employeeId: saveddata['data'][0]['id'].toString(),
              drcr: 'C',
              qty: qty,
              balance: qty)
          .toJson();

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}',
        },
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "fail";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ToolStock>> getOperatorHistory(
      {required String employeeId}) async {
    try {
      // var url = Uri.parse("${AppUrl.baseUrl}/tool/transaction/operator-tool-history");
      var url = Uri.parse(
          "https://192.168.0.183:8081/tool/transaction/operator-tool-history");

      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(
        url,
        body: jsonEncode({"employee_id": employeeId}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      if (response.statusCode == 200) {
        List<ToolStock> toolList =
            list.map((e) => ToolStock.fromJson(e)).toList();
        return toolList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
