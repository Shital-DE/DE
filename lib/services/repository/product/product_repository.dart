// Author : Shital Gayakwad
// Created Date : 23 April 2023
// Description : ERPX_PPC -> Product repository
// Modified By : Nilesh Desai
// Modified date : 18 July 2023

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/product/product.dart';
import '../../model/product/product_route.dart';

class ProductRepository {
  // All product list
  Future allProductList({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.allProduct, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList.map((e) => AllProductModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

  // Product data
  Future productDataFromMaster(
      {required String token, required String id}) async {
    try {
      Map<String, dynamic> payload = {
        'id': id.toString().trim(),
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.productDataMaster, token, payload);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> dataList = jsonDecode(response.body);
          return dataList.map((e) => ProductMaterData.fromJson(e)).toList();
        }
      }
    } catch (e) {
      //
    }
  }

// Product route
  Future productRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.productRoute, token, payload);
        List<dynamic> dataList = jsonDecode(response.body);
        return dataList.map((e) => ProductRoute.fromJson(e)).toList();
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  //Product revision
  Future productRevision(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.productRevision, token, payload);

        List<dynamic> dataList = jsonDecode(response.body);
        return dataList.map((e) => ProductRevision.fromJson(e)).toList();
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Product bill of material id
  Future<String> productBillOfMaterialId(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.productBillOfMaterialId, token, payload);
        final data = jsonDecode(response.body);
        return data[0]['id'].toString();
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

// Register product route
  Future<String> ceateAndUpdateProductRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.createProductRoute, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Register process route
  Future<String> registerProcessRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerProcessroute, token, payload);
        return response.body;
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Process route
  Future processRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.processRoute, token, payload);
        List<dynamic> dataList = jsonDecode(response.body);
        return dataList.map((e) => ProcessRoute.fromJson(e)).toList();
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Update product route
  Future<String> updateProductRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .putApiResponse(AppUrl.updateProductRoute, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return 'Updated successfully';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete product route
  Future<String> deleteProductRoute(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteProductRoute, token: token, payload: payload);
        if (response.body.toString() == 'Deleted successfully') {
          return 'Deleted successfully';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Update process route
  Future<String> updateProcessRoute(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .putApiResponse(AppUrl.updateProductProcessRoute, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return 'Updated successfully';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete process route
  Future<String> deleteProcessRoute(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteProductProcessRoute,
            token: token,
            payload: payload);
        if (response.body.toString() == 'Deleted successfully') {
          return 'Deleted successfully';
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Production instruction set
  Future instructions(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.productionInstruction, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => ProductionInstructions.fromJson(e)).toList();
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Upload programs
  Future<String> uploadMachinePrograms(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.uploadMachinePrograms, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return 'File uploaded successfully.';
        } else {
          final data = jsonDecode(response.body);
          return data['message'];
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Program mdoc id
  Future<dynamic> instructionsWithDocuments(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.productioninstructionDocuments, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((e) => ProductionInstructionsWithDocuments.fromJson(e))
              .toList();
        } else {
          List<ProductionInstructionsWithDocuments> list = [];
          return list;
        }
      } else {
        return 'Payload is empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete Program files
  Future<String> deleteProgramFiles(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.deleteMachinePrograms, token: token, payload: payload);
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
