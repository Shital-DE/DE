// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Cutting event

import '../../../services/model/operator/oprator_models.dart';

abstract class CuttingEvent {}

// Cutting Production Event
class CuttingProductionEvent extends CuttingEvent {
  final Barcode barcode;
  final String cuttingQty;
  final Map<String, dynamic> machinedata;
  CuttingProductionEvent(
      {required this.barcode,
      required this.cuttingQty,
      required this.machinedata});
}

// Cutting Production Event
class CuttingProductionProcessesEvent extends CuttingEvent {
  final Barcode barcode;
  CuttingProductionProcessesEvent({required this.barcode});
}
