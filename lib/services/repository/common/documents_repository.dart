// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Document repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/common/document_model.dart';

class DocumentsRepository {
  Future<List<DocumentDetails>> pdfMdocId(String token, String id) async {
    List<dynamic> pdfDetailsList = [];
    try {
      Map<String, dynamic> payload = {
        'id': id.toString().trim(),
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.pdfDetailsUrl, token, payload);
        pdfDetailsList = jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return pdfDetailsList.map((e) => DocumentDetails.fromJson(e)).toList();
  }

  Future<List<DocumentDetails>> modelsMdocId(String token, String id) async {
    List<dynamic> modelDetailsList = [];
    try {
      Map<String, dynamic> payload = {
        'id': id.toString().trim(),
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.modelDetailsUrl, token, payload);
        modelDetailsList = jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return modelDetailsList.map((e) => DocumentDetails.fromJson(e)).toList();
  }

  Future documents(String token, String id) async {
    try {
      Map<String, dynamic> payload = {
        'id': id.toString().trim(),
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.documentsData, token, payload);
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future mergedDocData({required String token, required String id}) async {
    try {
      Map<String, dynamic> payload = {
        'id': id.toString().trim(),
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.mergedDocData, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList.map((e) => MergedDocumentsData.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

  Future documentsfolderdetails(String token, List mdocid) async {
    try {
      Map<String, dynamic> payload = {
        'mdocidlist': mdocid
        // .join().trim(),
      };
      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.mdocidfolder, token, payload);
        return response.body;
      } else {
        return "No Programgs found";
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future program(String token, String mdocid, String foldername) async {
    try {
      Map<String, dynamic> payload = {
        'id': mdocid.toString().trim(),
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.programData, token, payload);
        if (response.statusCode == 200) {
          String responseBody = response.body;

          return responseBody;
        } else {
          throw Exception(
              'API request failed with status code ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<String> getprogramListFromMachine(String machineID) async {
    String programsfrommachines = '';
    // debugPrint("machine programe calling-----------------------------");
    try {
      var url = Uri.parse(
          "http://192.168.0.55:3213/v1/industry40/getProgramFileList?machineid=$machineID");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        programsfrommachines = response.body;
        // debugPrint(responseBody);
        return programsfrommachines;
      } else {
        throw Exception(
            'API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return programsfrommachines;
  }

  Future<String> getProgramFileByID(
      String machineid, String programename) async {
    String datagiven = '';
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://192.168.0.55:3213/v1/industry40/getProgramFileByID'));
      request.body =
          json.encode({"machineid": machineid, "program": programename});
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        datagiven = responseData;
        return responseData.toString();
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return datagiven;
  }
}
