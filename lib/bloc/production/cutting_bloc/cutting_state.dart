// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Cutting state

import '../../../services/model/common/document_model.dart';
import '../../../services/model/operator/cutting_model.dart';
import '../../../services/model/operator/oprator_models.dart';
import '../../../services/model/product/product_route.dart';

abstract class CuttingState {}

// Cutting initial state
class CuttingInitialState extends CuttingState {
  CuttingInitialState();
}

// Cutting production state
class CuttingProductionState extends CuttingState {
  final Barcode barcode;
  final Map<String, dynamic> pdfdoc, modeldoc, productStatus, machinedata;
  final String token, cuttingQty, employeeid;
  final List<DocumentDetails> pdfDetails;
  final List<DocumentDetails> modelsDetails;
  final List<CuttingStatus> status;
  final int tobeProducedQuantity;
  CuttingProductionState(
      {required this.barcode,
      required this.pdfdoc,
      required this.modeldoc,
      required this.token,
      required this.pdfDetails,
      required this.modelsDetails,
      required this.cuttingQty,
      required this.employeeid,
      required this.productStatus,
      required this.status,
      required this.tobeProducedQuantity,
      required this.machinedata});
}

// Cutting Error state
class CuttingErrorState extends CuttingState {
  final String errorMessage;
  CuttingErrorState(this.errorMessage);
}

// Cutting Production Processes state
class CuttingProductionProcessesState extends CuttingState {
  final Barcode barcode;
  List<ProductAndProcessRouteModel> productProcessRouteList;
  String token, userId, workcentreId, workstationId;
  CuttingProductionProcessesState(
      {required this.barcode,
      required this.productProcessRouteList,
      required this.token,
      required this.userId,
      required this.workcentreId,
      required this.workstationId});
}
