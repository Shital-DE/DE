// ignore_for_file: depend_on_referenced_packages

import 'package:de/services/model/operator/oprator_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/app_url.dart';

class OperatorAPIService {
  static Future<Barcode> getBarcodeData(
      {required String year, required String documentno}) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}operator/scanBarcode");
      http.Response response = await http.post(
        url,
        body: jsonEncode(
            <String, String>{"year": year, "document_no": documentno}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);

      Barcode barCode = Barcode.fromJson(data['data']);

      return barCode;
    } catch (e) {
      throw Exception(e);
    }
  }

  //static getProcess({required String wsid}) {

  static Future<List<MachineCenterProcess>> getProcess(
      // {
      //   required String wsid
      //   }
      ) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}operator/machineProcess");
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, String>{
          //"wsid": wsid
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> mprocess = data['data'];
      List<MachineCenterProcess> processlist =
          mprocess.map((e) => MachineCenterProcess.fromJson(e)).toList();

      //    List<MachineCenterProcess>.fromJson(data['data']);
      return processlist;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Tools>> getToolsList({required String wcid}) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}operator/toollist");
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, String>{"wcid": wcid}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> td = data['data'];
      // print("td");
      // print(td);
      // debugPrint(td.toString());
      List<Tools> tlist = td.map((e) => Tools.fromJson(e)).toList();
      return tlist;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<OperatorRejectedReasons>>
      getOperatorrejresonsList() async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}operator/rejectionresons");
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, String>{}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> rej = data['data'];
      // print(data['data'].toString());

      List<OperatorRejectedReasons> rejlist =
          rej.map((e) => OperatorRejectedReasons.fromJson(e)).toList();

      // for (var data in rejlist) {
      //   print(data.rejectedreasons);
      // }

      return rejlist;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> jobStartAPI(
      {required String requestid,
      required String slipId,
      required String productId,
      required String machineId,
      required int toBeProducedQty,
      required String timeStart,
      required String processid}) async {
    try {
      var url =
          Uri.parse("${AppUrl.indURI}/v1/industry40/loadProductionDetails");
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, dynamic>{
          "requestid": requestid.trim(),
          "slipid": slipId.toString().trim(),
          "productid": productId.toString().trim(),
          "machineid": machineId.toString().trim(),
          "tobeproduced": toBeProducedQty,
          "starttime": timeStart.toString().trim(),
          "processid": processid.toString().trim(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint(responseData.toString());
        String td = responseData['status'];
        // debugPrint("11------------==-=-=-=-=-=-==>>>>>>>>>>>>>>>>>>>>>>");
        // debugPrint(td.toString());
        return td;
      } else {
        String responseofAPI = "Job not started";
        return responseofAPI;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> jobStopAPI({
    required String slipId,
    required String productCodeId,
    required int toBeProducedQty,
    required String machineId,
  }) async {
    try {
      var url = Uri.parse("${AppUrl.indURI}/v1/cloud/job-stop");
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, dynamic>{
          "slipId": slipId,
          "productCodeId": productCodeId,
          "toBeProducedQty": toBeProducedQty,
          "machineId": machineId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      //  List<dynamic> td = data['message'];
      String td = data['message'];
      // List<Tools> jobstartresponce = td.map((e) => Tools.fromJson(e)).toList();
      // debugPrint("11------------==-=-=-=-=-=-==>>>>>>>>>>>>>>>>>>>>>>");
      // debugPrint(td.toString());
      return td;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> jobgetdata({
    required String slipId,
    required String productCodeId,
    required int toBeProducedQty,
    required String machineId,
  }) async {
    try {
      var url = Uri.parse("${AppUrl.indURI}/v1/cloud/get-data");
      http.Response response = await http.post(
        url,
        body: jsonEncode(<String, dynamic>{
          "slipId": slipId,
          "productCodeId": productCodeId,
          "toBeProducedQty": toBeProducedQty,
          "machineId": machineId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      //  List<dynamic> td = data['message'];
      String td = data['message'];
      // List<Tools> jobstartresponce = td.map((e) => Tools.fromJson(e)).toList();
      // debugPrint("11------------==-=-=-=-=-=-==>>>>>>>>>>>>>>>>>>>>>>");
      // debugPrint(td.toString());
      return td;
    } catch (e) {
      throw Exception(e);
    }
  }
}
