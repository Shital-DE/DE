// ignore_for_file: depend_on_referenced_packages

/*
/// * Rohini Mane
/// Created 16-04-23
/// Modified 27-04-23
*/

import 'dart:convert';
import 'package:de/services/session/user_login.dart';
import 'package:de/utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../../model/capacity_plan/model.dart';
import '../../model/machine/workstation.dart';
import '../../model/po/po_models.dart';

class CapacityPlanService {
  //---------Runtimes Master---------//

  //--------End-Runtimes Master---------//
  //--------Generate-Capacity Plan-------//
  static Future<String> checkDateService({required String fromDate}) async {
    try {
      final saveddata = await UserData.getUserData();
      var url = Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/checkDate");
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      if (data["data"] == "Empty") {
        return "NotFound";
      } else {
        return data["data"];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<CapacityPlanData>> getCPProductsService(
      {required String fromDate, required String toDate}) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/getCPProducts");

      Object body = <String, dynamic>{"fromDate": fromDate, "toDate": toDate};
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      List<CapacityPlanData> cpList =
          list.map((e) => CapacityPlanData.fromJson(e)).toList();

      if (response.statusCode == 200) {
        return cpList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<CapacityPlanData>> addNewCPProductsService(
      {required String fromDate,
      required String toDate,
      required int runnumber}) async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/addNewCPProducts");

      Object body = <String, dynamic>{
        "fromDate": fromDate,
        "toDate": toDate,
        "runnumber": runnumber
      };
      // debugPrint(body.toString());
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      List<CapacityPlanData> cpList =
          list.map((e) => CapacityPlanData.fromJson(e)).toList();

      if (response.statusCode == 200) {
        return cpList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> saveCapcityPlanService(
      {required String fromDate,
      required String toDate,
      required List<CapacityPlanData> list}) async {
    try {
      final saveddata = await UserData.getUserData();
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/saveCapacityPlan");

      Object body = <String, dynamic>{
        "fromDate": fromDate,
        "toDate": toDate,
        "list": list,
        "userid": saveddata['data'][0]['id'].toString()
      };

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

  static Future<String> updateCapcityPlanService(
      {required String fromDate,
      required String toDate,
      required int runnumber,
      required List<CapacityPlanData> list}) async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/updateCapacityPlan");

      Object body = <String, dynamic>{
        "fromDate": fromDate,
        "toDate": toDate,
        "runnumber": runnumber,
        "list": list
      };
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
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

//-------End--Capacity Plan-------//
//--------Show Bar Chart----------//
  static Future<List<CapacityPlanList>> getAllCapacityPlanList() async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/capacityplan_list");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      List<dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<CapacityPlanList> cpList =
            data.map((e) => CapacityPlanList.fromJson(e)).toList();
        return cpList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<WorkcentreCP>> graphViewCP(int runno) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/graph_view_list");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, dynamic>{"runnumber": runno}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      List<dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<WorkcentreCP> cpList =
            data.map((e) => WorkcentreCP.fromJson(e)).toList();
        return cpList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<ProductDragDrop>> cpDragAndDropService(int runno) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/cp_dragdropList");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, dynamic>{"runnumber": runno}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      if (response.statusCode == 200) {
        List<ProductDragDrop> cpList =
            list.map((e) => ProductDragDrop.fromJson(e)).toList();
        return cpList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<WorkstationByWorkcentreId>> cpWorkstationService(
      String workcentreId) async {
    // Workstation
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/workcentre/selected-ws/ws-by-wc_id");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, dynamic>{"workcentre_id": workcentreId}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      // Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = jsonDecode(response.body);
      if (response.statusCode == 200) {
        List<WorkstationByWorkcentreId> wsList =
            list.map((e) => WorkstationByWorkcentreId.fromJson(e)).toList();
        return wsList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<WorkcentreCP>> cpWorkcentreService() async {
    // Workcentre
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/workcentre/wc/cp_workcentre");
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
        List<WorkcentreCP> wsList =
            list.map((e) => WorkcentreCP.fromJson(e)).toList();
        return wsList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveDraggedProductService(
      {required ProductDragDrop product, required String workcenterId}) async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/save-drapdrop-product");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = product.toJson();

      data["workcentre_id"] = workcenterId;
      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {}
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> saveAllDragDropProductService({
    required List<ProductDragDrop> product,
  }) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/ppc/capacityPlan/save-alldrapdrop-product");
      final saveddata = await UserData.getUserData();
      List<Map<String, dynamic>> data = product.map((e) => e.toJson()).toList();

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ProductDragDrop>> getWorkcentreAssignProductService(
      {required String workcentreId, required int runnumber}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/ppc/capacityPlan/getWorkcentreCPProduct");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = {
        "workcentre_id": workcentreId,
        "runnumber": runnumber
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        List<dynamic> list = result["data"];
        // print(list);
        List<ProductDragDrop> pList =
            list.map((e) => ProductDragDrop.fromJson(e)).toList();
        return pList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> deleteWCProductCPService(
      {required String cpChildId}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/ppc/capacityPlan/deleteWorkcentreCPProduct");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = {"cp_child_id": cpChildId};

      http.Response response = await http.delete(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Fail";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> updateWStoCPService(
      {required String workstationId,
      required String capacityplanId,
      required String cpChildId}) async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/update-ws-dragproduct");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = {
        "workstation_id": workstationId,
        "capacityplan_id": capacityplanId,
        "cp_child_id": cpChildId
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Fail";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<SalesOrder> searchPOService({required String po}) async {
    try {
      SalesOrder so = SalesOrder();
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/search-customer-po");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = {"po": po};

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);

        so = SalesOrder.fromJson(result["data"]);
        if (so.isEmpty) {
          return so;
        } else {
          List<dynamic> list = result["data"]["sodetails"];
          so.salesOrderDetails =
              list.map((e) => SalesOrderDetails.fromJson(e)).toList();

          return so;
        }
      } else {
        return so;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> editAllPOPlanDateService(
      {required String po, required String plandate}) async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/update-plandate-so");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = {"salesorderid": po, "plandate": plandate};

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> editSinglePOProductPlanDateService(
      {required SalesOrderDetails soDeails}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/ppc/capacityPlan/update-plandate-sodetail");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = soDeails.toJson();

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<WorkstationShift>> workstationShiftService(
      {required String workcentreId}) async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/workstation-shift");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = {"workcentre_id": workcentreId};

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      Map<String, dynamic> result = jsonDecode(response.body);
      List<dynamic> list = result['data'];
      List<WorkstationShift> workstationShiftList =
          list.map((e) => WorkstationShift.fromJson(e)).toList();

      if (response.statusCode == 200) {
        return workstationShiftList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> selectShiftService(
      {required bool value, required String wsStatusId}) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/update-shift");
      final saveddata = await UserData.getUserData();
      Map<String, dynamic> data = {"value": value, "ws_status_id": wsStatusId};

      http.Response response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );

      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ShiftTotal>> shiftTotalService() async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/ppc/capacityPlan/shift-total-time");
      final saveddata = await UserData.getUserData();

      http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      Map<String, dynamic> result = jsonDecode(response.body);
      List<dynamic> list = result['data'];
      List<ShiftTotal> shiftTotalList =
          list.map((e) => ShiftTotal.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return shiftTotalList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
