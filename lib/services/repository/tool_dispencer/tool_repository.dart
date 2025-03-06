import 'dart:convert';

import 'package:de/services/model/employee_overtime/employee_model.dart';
import 'package:http/http.dart' as http;

import '../../../utils/app_url.dart';
import '../../model/tool_dispencer/tool.dart';
import '../../model/tool_dispencer/toolreport.dart';
import '../../model/tool_dispencer/toolstock.dart';
import '../../session/user_login.dart';

class ToolRepository {
  static Future<List<Employee>> getOperatorList() async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/supervisor/emp/operator-list");

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
      var url = Uri.parse("${AppUrl.baseUrl}/tool/transaction/tool-list");
      // var url =
      //     Uri.parse("https://192.168.0.183:8081/tool/transaction/tool-list");
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

  static Future<String> saveToolsIssueAndToolStock(
      {required String issueDate,
      required String toolId,
      required int qty,
      required String transaction,
      required String drcr}) async {
    try {
      final saveddata = await UserData.getUserData();
      var url = Uri.parse(
          "${AppUrl.baseUrl}/tool/transaction/save-toolissue-toolstock");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/save-toolissue-toolstock");

      Object body = ToolStock(
              date: issueDate,
              transactiontypeId: transaction,
              toolId: toolId,
              employeeId: saveddata['data'][0]['id'].toString(),
              drcr: drcr,
              qty: qty,
              status: 'A')
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

  static Future<String> saveToolReceive(
      {required String empId,
      required ToolStock toolStock,
      // required String toolId,
      required int returnQty,
      required String transaction,
      required String drcr}) async {
    try {
      final saveddata = await UserData.getUserData();
      var url =
          Uri.parse("${AppUrl.baseUrl}/tool/transaction/save-toolreceipt");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/save-toolreceipt");

      Object body = ToolStock(
              date: DateTime.now().toString(),
              transactiontypeId: transaction,
              toolId: toolStock.toolId,
              employeeId: empId,
              drcr: drcr,
              qty: returnQty, //toolStock.qty,
              status: 'A',
              createdby: saveddata['data'][0]['id'].toString())
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
      {required String empId,
      required ToolStock toolStock,
      required int returnQty,
      // required String reason,
      required Map<String, String> reason,
      required String transaction,
      required String drcr}) async {
    try {
      final saveddata = await UserData.getUserData();
      var url =
          Uri.parse("${AppUrl.baseUrl}/tool/transaction/save-damaged-tool");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/save-damaged-tool");

      Object body = ToolStock(
              date: DateTime.now().toString(),
              transactiontypeId: transaction,
              toolId: toolStock.toolId,
              employeeId: empId, //saveddata['data'][0]['id'].toString(),
              drcr: drcr,
              qty: returnQty,
              reason: reason['reasonType'],
              remark: reason['remark'] ?? "",
              status: reason['reasonType'] == 'wornout' ? 'W' : 'D',
              createdby: saveddata['data'][0]['id'].toString())
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
      var url =
          Uri.parse("${AppUrl.baseUrl}/tool/transaction/operator-tool-history");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/operator-tool-history");

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

  static Future<int> checkAvailableStock(
      {required String toolId, required String date}) async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/tool/transaction/check-available-stock");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/check-available-stock");

      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(
        url,
        body: jsonEncode({"tool_id": toolId, "date": date}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      if (data["data"][0]["balance"] != null) {
        int balance = data["data"][0]["balance"];

        return balance;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<List<ToolStock>> getToolStockHistory() async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/tool/transaction/tool-stock-history");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/tool-stock-history");

      final saveddata = await UserData.getUserData();

      http.Response response = await http.get(
        url,
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

  static Future<List<ToolReport>> toolReportDateRange(
      {required String fromdate, required String todate}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/tool/transaction/from-to-date-toolreport");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/from-to-date-toolreport");

      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(
        url,
        body: jsonEncode({"fromdate": fromdate, "todate": todate}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      if (response.statusCode == 200) {
        List<ToolReport> toolReport =
            list.map((e) => ToolReport.fromJson(e)).toList();
        return toolReport;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<ToolStock>> operatorMonthlyReport(
      {required String employeeId,
      required String fromdate,
      required String todate}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/tool/transaction/operator-monthly-toolreport");

      // var url = Uri.parse(
      //     "https://192.168.0.183:8081/tool/transaction/operator-monthly-toolreport");

      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(
        url,
        body: jsonEncode({
          "employee_id": employeeId,
          "fromdate": fromdate,
          "todate": todate
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      if (response.statusCode == 200) {
        List<ToolStock> toolReport =
            list.map((e) => ToolStock.fromJson(e)).toList();
        return toolReport;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
