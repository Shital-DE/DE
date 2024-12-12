// Author : Shital Gayakwad
// Created Date : 26 Nov 2023
// Description : Packing state

import '../../../services/model/common/document_model.dart';
import '../../../services/model/operator/oprator_models.dart';
import '../../../services/model/packing/packing_model.dart';
import '../../../services/model/product/product_route.dart';

class PackingState {}

class PackingInitialState extends PackingState {}

class PackingWorkLogState extends PackingState {
  final Barcode? barcode;
  final String token,
      pdfMdocId,
      productDescription,
      pdfRevisionNo,
      modelMdocId,
      imageType,
      modelRevisionNo,
      packingId,
      workcentre;
  final List<DocumentDetails> modelsDetails;
  final List<DocumentDetails> pdfDetails;
  PackingWorkLogState(
      {required this.barcode,
      required this.token,
      required this.pdfMdocId,
      required this.productDescription,
      required this.pdfRevisionNo,
      required this.modelMdocId,
      required this.imageType,
      required this.modelRevisionNo,
      required this.modelsDetails,
      required this.pdfDetails,
      required this.packingId,
      required this.workcentre});
}

class StockState extends PackingState {
  final String productId, token, userid;
  final List<ProductRevision> revision;
  final List<AvailableStock> availableStock;
  StockState(
      {required this.productId,
      required this.revision,
      required this.token,
      required this.userid,
      required this.availableStock});
}

class PackingErrorState extends PackingState {
  final String errorMessage;
  PackingErrorState({required this.errorMessage});
}
