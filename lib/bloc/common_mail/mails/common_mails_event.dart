// Author : Shital Gayakwad
// Created date : 9 Feb 2024
// Description : Purchase order event

// import '../../../services/model/rawmaterialinward/raw_material_inward_model.dart';

class CommonMailEvent {}

class BulkmailsendEvent extends CommonMailEvent {
  final List<List<dynamic>> excelData;
  final List<List<dynamic>> rejectedOrders;
  BulkmailsendEvent(
      {this.excelData = const [], this.rejectedOrders = const []});
}

// class OtherEvent extends CommonMailEvent {
//   // final List<MaterialinwardList> materialinwardlist;

//   final int index;
//   final int range;
//   final String searchString;
//   OtherEvent({
//     this.materialinwardlist = const [],
//     this.range = 0,
//     this.searchString = '',
//     this.index = 1,
//   });
// }

// class StockCheckEvent extends CommonMailEvent {
//   final List<IssueProductStock> selectedProductsToIssue;
//   final List<StockIssuedProducts> issuedProducts;
//   StockCheckEvent(
//       {this.selectedProductsToIssue = const [],
//       this.issuedProducts = const []});
// }
