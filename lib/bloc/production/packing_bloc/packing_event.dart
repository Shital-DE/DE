// Author : Shital Gayakwad
// Created Date : 26 Nov 2023
// Description : Packing event

import '../../../services/model/operator/oprator_models.dart';
import '../../../services/model/product/product_route.dart';

class PackingEvent {}

class PackingProductionEvent extends PackingEvent {
  final Barcode? barcode;
  ProductAndProcessRouteModel? productAndProcessRouteModel;
  PackingProductionEvent(
      {required this.barcode, required this.productAndProcessRouteModel});
}

class PackingProcessesEvent extends PackingEvent {
  final Barcode barcode;
  PackingProcessesEvent({required this.barcode});
}

class StockEvent extends PackingEvent {
  final String productid;
  StockEvent({this.productid = ''});
}
