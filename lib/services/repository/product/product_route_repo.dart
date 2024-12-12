//  Author : Shital Gayakwad
// Description : ERPX_PPC -> Product and Process route repository
// Created : 24 August 2023

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/product/product_route.dart';

class ProductRouteRepository {
  static String outsourceWcId =
      '402881757458eb2201745cae957a001b'; // Outsource workcentre id
  // Register product and process route
  Future<String> registerProductRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.registerProductProcessRoute, token, payload);
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

  // Get product and process route data to show to user how many route is registered
  Future<dynamic> getProductAndProcessRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      http.Response response = await API()
          .postApiResponse(AppUrl.productProcessRouteData, token, payload);
      List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => ProductAndProcessRouteModel.fromJson(e)).toList();
    } catch (e) {
      return e.toString();
    }
  }

  // Delete product and process route
  Future<String> deleteProductAndProcessRoute(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteProductRocessRoute,
            token: token,
            payload: payload);
        if (response.body.toString() == 'Deleted successfully') {
          return 'Deleted successfully';
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

  // Update product and process route
  Future<String> updateProductAndProcessRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().putApiResponse(
            AppUrl.updateProductAndProcessRoute, token, payload);
        if (response.body.toString() == 'Deleted successfully') {
          return 'Updated successfully';
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

  Future<dynamic> processes({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.processes, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList.map((e) => Process.fromJson(e)).toList();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> filledProductAndProcessRoute({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response = await API()
            .getApiResponse(AppUrl.filledProductAndProcessRoute, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          final data = jsonDecode(response.body);
          List<dynamic> dataList = data['data'];
          return {
            'data': dataList
                .map((e) => FilledProductAndProcessRoute.fromJson(e))
                .toList(),
            'count': data['count']
          };
        }
      }
    } catch (e) {
      return e.toString();
    }
  }
}
