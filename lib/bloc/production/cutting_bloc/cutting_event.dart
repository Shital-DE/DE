// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Cutting event

import '../../../services/model/operator/oprator_models.dart';

abstract class CuttingEvent {}

class CuttingLoadingEvent extends CuttingEvent {
  final Barcode barcode;
  final String cuttingQty;
  final Map<String, dynamic> machinedata;
  CuttingLoadingEvent(
    this.barcode,
    this.cuttingQty,
    this.machinedata,
  );
}
