// Author : Nilesh Desai & Shital Gayakwad
// Created Date :  18 July 2023
// Description : ERPX_PPC -> Production resource management state

import '../../../services/model/machine/workstation.dart';
import '../../../services/model/product/product.dart';
import '../../../services/model/product/product_route.dart';

abstract class UploadproductdetailState {}

class UploadproductdetailInitialState extends UploadproductdetailState {
  UploadproductdetailInitialState();
}

class UploadproductdetailLoadingState extends UploadproductdetailState {
  final List<AllProductModel> allprodocutsList;
  final List<ProductMaterData> productData;
  final String token, productid, productRevision, productRouteId, userId;
  final bool uploadProgram;
  final List<ProductRoute> productRouteList;
  final List<WorkstationByWorkcentreId> workstationList;
  final List<ProductionInstructions> productionInstructionsList;
  final Map<String, dynamic> selectedProductRoute;
  UploadproductdetailLoadingState(
      {required this.allprodocutsList,
      required this.productData,
      required this.token,
      required this.productid,
      required this.uploadProgram,
      required this.productRouteList,
      required this.workstationList,
      required this.productRevision,
      required this.productRouteId,
      required this.userId,
      required this.productionInstructionsList,
      required this.selectedProductRoute});
}

class UploadproductdetailError extends UploadproductdetailState {
  final String errorMessage;
  UploadproductdetailError({required this.errorMessage});
}
