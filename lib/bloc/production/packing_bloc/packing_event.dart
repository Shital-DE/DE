// Author : Shital Gayakwad
// Created Date : 26 Nov 2023
// Description : Packing event

import '../../../services/model/operator/oprator_models.dart';

class PackingEvent {}

class PackingWorkLogEvent extends PackingEvent {
  final Barcode? barcode;
  PackingWorkLogEvent({required this.barcode});
}

class StockEvent extends PackingEvent {
  final String productid;
  StockEvent({this.productid = ''});
}
