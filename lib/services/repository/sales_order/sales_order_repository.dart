// Author : Shital Gayakwad
// Created Date : 15 November 2024
// Description : Sales order repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:de/services/common/api.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import '../../../utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../../model/sales_order/sales_order_model.dart';

class SalesOrderRepository {
  // All sales orders
  Future<List<AllSalesOrdersModel>> getAllSalesOrdersData(
      {required String token,
      required String fromdate,
      required String todate}) async {
    try {
      http.Response response = await API().getApiResponse(
          '${AppUrl.assemblyAllSalesOrders}?fromdate=$fromdate&todate=$todate',
          {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AllSalesOrdersModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Generate component requirement
  Future<Map<String, dynamic>> generateAssemblyComponentRequirement(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      http.Response response = await API().postApiResponse(
          AppUrl.generateComponentRequirementUrl, token, payload);
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } catch (e) {
      return {};
    }
  }

  // Discard component requirement
  Future<Map<String, dynamic>> discardAssemblyComponentRequirement(
      {required String token, required Map<String, String> payload}) async {
    try {
      http.Response response = await API().deleteApiResponse(
          url: AppUrl.discardComponentRequirementUrl,
          token: token,
          payload: payload);
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } catch (e) {
      return {};
    }
  }

  // Generated products requirements
  Future<List<SelectedAssembliesComponentRequirements>>
      generatedAssemblyComponentsRequirements({required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.generatedComponentRequirementUrl, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => SelectedAssembliesComponentRequirements.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<String> getDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked.toString() != '') {
        return picked.toString().substring(0, 10);
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
