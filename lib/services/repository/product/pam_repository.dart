// Author : Shital Gayakwad
// Created Date : 23 October 2024
// Description : Product structure bloc

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/product/product_inventory_model.dart';
import '../../model/product/product_structure_model.dart';

class PamRepository {
  // Product structure
  // Product list
  Future<List<ProductsWithRevisionDataModel>> getProductsData(
      {required String token}) async {
    try {
      http.Response response = await API().getApiResponse(AppUrl.productData, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => ProductsWithRevisionDataModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Register product Structure
  Future<String> registerProductStructure(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      http.Response response = await API()
          .postApiResponse(AppUrl.registerProductStructure, token, payload);
      if (response.body.toString().length == 32) {
        return response.body.toString();
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['Status code'] == 200) {
          return data['Message'];
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Product structure tree representation
  Future<ProductStructureDetailsModel> productStructureTreeRepresentation(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        final http.Response response = await API().postApiResponse(
            AppUrl.productStructureTreeRepresentationUrl, token, payload);
        final List<dynamic> data = jsonDecode(response.body);
        List<ProductStructureDetailsModel> productStructureList =
            data.map((e) => ProductStructureDetailsModel.fromJson(e)).toList();
        return productStructureList[0];
      } else {
        return ProductStructureDetailsModel();
      }
    } catch (e) {
      return ProductStructureDetailsModel();
    }
  }

  // Update product details
  Future updateProductDetails(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .putApiResponse(AppUrl.updateProductDetails, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete product from product structure
  Future<String> deleteProductFromProductStructure(
      {required String token, required Map<String, String> payload}) async {
    try {
      http.Response response = await API().deleteApiResponse(
          url: AppUrl.deleteProductFromProductStructure,
          token: token,
          payload: payload);
      return response.body.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // Product registration
  // Unit of measurement data list
  Future<List<UOMDataModel>> getUOM({required String token}) async {
    try {
      http.Response response = await API().getApiResponse(AppUrl.uomUrl, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UOMDataModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

// Product type data list
  Future<List<ProductTypeDataModel>> getProductType(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.productTypeurl, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ProductTypeDataModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Product inventory management
  // Register stock
  Future<String> productStockRegister(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      final http.Response response = await API()
          .postApiResponse(AppUrl.registerProductStock, token, payload);

      List<dynamic> data = jsonDecode(response.body);
      // debugPrint(data.toString());
      if (data[0]['message'] == 'success') {
        return data[0]['id'].toString();
      } else {
        return data[0]['message'].toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Current stock
  Future<ProductCurrentStock> getCurrentStock(
      {required String token,
      required String productId,
      required String revision}) async {
    try {
      http.Response response = await API().getApiResponse(
          '${AppUrl.currentProductStock}?product_id=$productId&revision_number=$revision',
          {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      List<dynamic> data = jsonDecode(response.body);
      List<ProductCurrentStock> dataList =
          data.map((e) => ProductCurrentStock.fromJson(e)).toList();
      return dataList[0];
    } catch (e) {
      return ProductCurrentStock();
    }
  }

  // Sales order for issue stock
  Future<List<CurrentSalesOrdersDataModel>> getSalesOrdersDataForIssueStock(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.currentSalesordersForIssueStock, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => CurrentSalesOrdersDataModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Issued stock of selected product
  Future<List<IssuedStockModel>> selectedProductIssuedStock(
      {required String token,
      required String productId,
      required String revision,
      required String parentProductId,
      required String soDetailsId}) async {
    try {
      http.Response response = await API().getApiResponse(
          '${AppUrl.selectedProductIssuedStock}?product_id=$productId&revision_number=$revision&parentproduct_id=$parentProductId&sodetails_id=$soDetailsId',
          {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => IssuedStockModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
