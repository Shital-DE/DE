//  Author : Shital Gayakwad
// Description : ERPX_PPC -> Product and Process route from machine repository
// Created : 2 Sept 2023

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';

class ProductMachineRoute {
  Future<String> registerProductMachineRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.productMachineRouteInsert, token, payload);
        debugPrint(response.body.toString());
        if (response.body.toString() == 'Inserted successfully') {
          return 'Product route registered successfully';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
