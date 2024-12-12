// Author : Shital Gayakwad
// Created Date : 15 November 2024
// Description : Sales orders state

import '../../services/model/product/product_structure_model.dart';
import '../../services/model/sales_order/sales_order_model.dart';

class SalesOrderState {}

// Initial Sales order state
class InitialSalesOrderState extends SalesOrderState {}

// All sales order state
class AllOrdersState extends SalesOrderState {
  List<AllSalesOrdersModel> allSalesOrdersList;
  List<SelectedAssembliesComponentRequirements> selectedAssembliesDataList;
  String userId, token, fromdate, todate;
  AllOrdersState(
      {required this.allSalesOrdersList,
      required this.userId,
      required this.token,
      required this.selectedAssembliesDataList,
      required this.fromdate,
      required this.todate});
}

// Sales order error state
class SalesOrderErrorState extends SalesOrderState {
  String errorMessage;
  SalesOrderErrorState({required this.errorMessage});
}

// Issue stock for assembly state
class IssueStockForAsssemblyState extends SalesOrderState {
  String token, userId;
  ProductStructureDetailsModel node;
  SelectedAssembliesComponentRequirements selectedProduct;
  // List<Map<String, dynamic>> colorWithDefinitions;

  IssueStockForAsssemblyState({
    required this.node,
    required this.token,
    required this.userId,
    required this.selectedProduct,
    // required this.colorWithDefinitions
  });
}
