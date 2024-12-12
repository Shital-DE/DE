// Author : Shital Gayakwad
// Created date : 9 Feb 2024
// Description : Purchase order state

// import '../../../services/model/rawmaterialinward/raw_material_inward_model.dart';

class CommonMailState {}

class CommonMailInitialState extends CommonMailState {}

class UploadOrderState extends CommonMailState {
  final List<List<dynamic>> excelData;
  final List<List<dynamic>> rejectedOrders;
  final String token, userId;
  UploadOrderState(
      {required this.excelData,
      required this.token,
      required this.userId,
      required this.rejectedOrders});
}

// class OthersState extends CommonMailState {
//   // final List<SalesOrderModel> allPurchaseOrders;
//   // final List<ProductsInSOModel> productsList;
//   // List<ReservedOrder> reservedStock;
//   final String token, userId;
//   final List<MaterialinwardList> materialinwardlist;
//   final int index;
//   final String searchString;
//   final int range;

//   OthersState({
//     // required this.allPurchaseOrders,
//     // required this.token,
//     // required this.productsList,
//     required this.searchString,
//     required this.range,
//     required this.token,
//     required this.userId,
//     required this.materialinwardlist,
//     required this.index,
//   });
// }

// class StockCheckState extends CommonMailState {
//   final List<ToBeProduceProducts> tobeProduceProducts;
//   final List<IssueProductStock> selectedProductsToIssue;
//   final List<StockIssuedProducts> issuedProducts;
//   final String token, userId;
//   StockCheckState(
//       {required this.tobeProduceProducts,
//       required this.token,
//       required this.selectedProductsToIssue,
//       required this.userId,
//       required this.issuedProducts});
// }
