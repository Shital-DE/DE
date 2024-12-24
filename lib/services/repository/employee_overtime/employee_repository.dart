/*
/// * Rohini Mane
/// Created 07-02-2024
*/

import 'dart:convert';
import '../../../utils/app_url.dart';
import '../../api_services/employee/employee_service.dart';
import '../../common/api.dart';
import '../../model/employee_overtime/employee_model.dart';
import '../../model/po/po_models.dart';

class EmployeeRepository {
  static Future<List<Employee>> operatorList() async {
    try {
      List<Employee> list = await EmployeeService.getOperatorList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<EmpOvertimeWorkstation>> workstationList() async {
    try {
      List<EmpOvertimeWorkstation> list =
          await EmployeeService.getEmpOvertimewsList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Polist>> polist({required String token}) async {
    List<dynamic> polist = [];
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        var response = await API().getApiResponse(AppUrl.polist, headers);
        polist = jsonDecode(response.body);
      }
    } catch (e) {
      //
    }
    return polist.map((e) => Polist.fromJson(e)).toList();
  }

  static Future<List<Productlist>> productlistfromsoid({
    required String soid,
    required String token,
  }) async {
    Map<String, dynamic> payload = {};
    List<Productlist> productlist = [];
    try {
      payload = {
        'so_id': soid,
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.productlistfrompoid, token, payload);
        if (response.body.toString() == '[]') {
          return productlist = [];
        } else {
          productlist = [];
          List<dynamic> list = jsonDecode(response.body);
          productlist = list.map((item) => Productlist.fromJson(item)).toList();
          return productlist;
        }
      }
    } catch (e) {
      return productlist = [];
    }
    return productlist;
  }

  static Future<List<EmployeeOvertimedata>> empOvertimedata({
    required String empid,
    required String token,
  }) async {
    Map<String, dynamic> payload = {};

    List<EmployeeOvertimedata> overtimedata = [];
    try {
      payload = {
        'empid': empid,
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.employeeovertimedata, token, payload);

        if (response.body.toString() == '[]') {
          return overtimedata = [];
        } else {
          overtimedata = [];

          List<dynamic> list = jsonDecode(response.body);

          overtimedata =
              list.map((item) => EmployeeOvertimedata.fromJson(item)).toList();
          return overtimedata;
        }
      }
    } catch (e) {
      return overtimedata = [];
    }
    return overtimedata;
  }

  static Future<List<EODdetails>> detailsempOvertimedata({
    required String viewdetailsid,
    required String token,
  }) async {
    Map<String, dynamic> payload = {};

    List<EODdetails> overtimedata = [];
    try {
      payload = {
        'viewdetailsid': viewdetailsid,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.detailsemployeeovertimedata, token, payload);

        if (response.body.toString() == '[]') {
          return overtimedata = [];
        } else {
          overtimedata = [];

          List<dynamic> list = jsonDecode(response.body);
          overtimedata = list.map((item) => EODdetails.fromJson(item)).toList();
          return overtimedata;
        }
      }
    } catch (e) {
      return overtimedata = [];
    }
    return overtimedata;
  }

  static Future sendEmpOvertimeData(
      {required String loginid,
      required String empid,
      required String wsid,
      required String remark,
      required String starttime,
      required String endtime,
      required String token,
      required List<Outsource> productselectedList}) async {
    Map<String, dynamic> payload = {};

    try {
      payload = {
        'loginid': loginid,
        'empid': empid,
        'wsid': wsid,
        'remark': remark,
        'starttime': starttime,
        'endtime': endtime,
        'productselectedlist': productselectedList
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.insertemployeeovertimedata, token, payload);

        if (response.body.toString().length == 32) {
          String returnid = response.body.toString().trim();

          if (productselectedList.isNotEmpty) {
            String responsechild = await insertchildEmpOvertimeData(
              employeeovertimeid: returnid,
              productselectedList: productselectedList,
              token: token,
            );

            if (responsechild == 'Inserted successfully') {
              return "Inserted successfully";
            } else {
              return "Not Inserted successfully";
            }
          } else {
            return "Inserted successfully";
          }
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future insertchildEmpOvertimeData(
      {required String employeeovertimeid,
      required String token,
      required List<Outsource> productselectedList}) async {
    Map<String, dynamic> payload = {};
    String list = jsonEncode(productselectedList);
    try {
      payload = {
        'employeeovertimeid': employeeovertimeid,
        'productselectedlist': list
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.insertchildemployeeovertimedata, token, payload);

        if (response.statusCode == 200) {
          return "Inserted successfully";
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future updateEmpOvertimeData({
    required String id,
    required String empid,
    required String endtime,
    required String token,
  }) async {
    Map<String, dynamic> payload = {};

    try {
      payload = {
        'id': id,
        'empid': empid,
        'endtime': endtime,
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.updateemployeeovertimedata, token, payload);

        if (response.body.toString() == 'Updated successfully') {
          return response.body.toString();
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }
}
