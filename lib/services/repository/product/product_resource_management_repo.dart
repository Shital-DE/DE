// Author : Shital Gayakwad
// Created date :  12  Oct 2023
// Description : Product resource managements bloc
// Modified date :

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/product/product_resource_management_model.dart';

class ProductResourceManagementRepository {
  Future<List<UnVerifiedMachinePrograms>> programsForVerification(
      {required String token, required int footerIndex}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response = await API().getApiResponse(
            '${AppUrl.unVerifiedPrograms}?footerIndex=$footerIndex', headers);

        if (response.body.toString() == 'Server unreachable') {
          return [];
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList
              .map((e) => UnVerifiedMachinePrograms.fromJson(e))
              .toList();
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> verifyMachinePrograms(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().putApiResponse(AppUrl.verifyPrograms, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<VerifiedMachineProgramsModel>> verifiedPrograms(
      {required String token, required int footerIndex}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response = await API().getApiResponse(
            '${AppUrl.verifiedPrograms}?footerIndex=$footerIndex', headers);
        if (response.body.toString() == 'Server unreachable') {
          return [];
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList
              .map((e) => VerifiedMachineProgramsModel.fromJson(e))
              .toList();
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<NewProductionProductmodel>> newProductionproduct(
      {required String token, required int footerIndex}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response = await API().getApiResponse(
            '${AppUrl.newProductionProduct}?footerIndex=$footerIndex', headers);
        if (response.body.toString() == 'Server unreachable') {
          return [];
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList
              .map((e) => NewProductionProductmodel.fromJson(e))
              .toList();
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> deleteNewproductionProduct(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteNewproductionproduct,
            token: token,
            payload: payload);
        debugPrint(response.body.toString());
        if (response.body.toString() == 'Deleted successfully') {
          return 'Deleted successfully';
        } else {
          final data = jsonDecode(response.body);
          return data["message"];
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
