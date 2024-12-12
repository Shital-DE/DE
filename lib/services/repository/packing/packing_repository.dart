// Author : Shital Gayakwad
// Created Date : 28 Nov 2023
// Description : Packing repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/packing/packing_model.dart';

class PackingRepository {
  // Register stock
  Future<String> registerStock(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.registerStock, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Stock registered successfully.';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload is not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Available stock
  Future<List<AvailableStock>> availableStock({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.availableStock, headers);
        if (response.body.toString() == 'Server unreachable') {
          return [];
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList.map((e) => AvailableStock.fromJson(e)).toList();
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Decrease stock
  Future<String> decreaseStock(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.decreaseStock, token, payload);
        final data = jsonDecode(response.body);
        if (data['error'].toString() == 'Record updated successfully') {
          return 'Used from stock.';
        } else {
          return data['error'].toString();
        }
      } else {
        return 'Payload is not found';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
