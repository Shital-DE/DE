// Author : Shital Gayakwad
// Created Date : 15 November 2024
// Description : Sales orders event

import '../../services/model/sales_order/sales_order_model.dart';

class SalesOrderEvent {}

// All sales orders
class AllOrdersEvent extends SalesOrderEvent {
  String fromdate, todate;
  AllOrdersEvent({this.fromdate = '', this.todate = ''});
}

// Issue stock for assembly
class IssueStockForAsssemblyEvent extends SalesOrderEvent {
  SelectedAssembliesComponentRequirements? selectedProduct;

  IssueStockForAsssemblyEvent({this.selectedProduct});
}
