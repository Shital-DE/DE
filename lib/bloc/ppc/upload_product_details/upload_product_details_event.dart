// Author : Nilesh Desai & Shital Gayakwad
// Created Date : 18 July 2023
// Description : ERPX_PPC -> Production resource management event

import '../../../services/model/product/product.dart';

abstract class UploadproductdetailEvent {}

class ProductData extends UploadproductdetailEvent {
  final String productid, productRevision, productRouteId;
  final bool uploadProgram;
  final List<ProductionInstructions> productionInstructionsList;
  final Map<String, dynamic> selectedProductRoute;
  ProductData(
      {this.productid = '',
      this.uploadProgram = false,
      this.productRevision = '',
      this.productRouteId = '',
      this.productionInstructionsList = const [],
      this.selectedProductRoute = const {}});
}
