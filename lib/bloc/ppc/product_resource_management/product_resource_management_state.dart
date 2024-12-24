// Author : Shital Gayakwad
// Created date : 20 September 2023
// Description : Product resource management state
// Modified date : 12 Oct 2023
// Added machine program verification code

import '../../../services/model/product/product.dart';
import '../../../services/model/product/product_resource_management_model.dart';
import '../../../services/model/product/product_route.dart';

// ============================================================ Programs upload =====================================================

class ProductResourceManagementState {}

class UploadMachineProgramInitialState extends ProductResourceManagementState {
  UploadMachineProgramInitialState();
}

class UploadMachineProgramState extends ProductResourceManagementState {
  final List<ProductMaterData> productData;
  final List<ProductAndProcessRouteModel> productAndProcessRouteDataList;
  final List<FilledProductAndProcessRoute> productList;
  final String token, productId, productRevision, processRouteId, userId;
  UploadMachineProgramState(
      {required this.productData,
      required this.productId,
      required this.token,
      required this.productRevision,
      required this.productAndProcessRouteDataList,
      required this.processRouteId,
      required this.userId,
      required this.productList});
}

class UploadMachineProgramErrorState extends ProductResourceManagementState {
  final String errorMessage;
  UploadMachineProgramErrorState({required this.errorMessage});
}

// ====================================================== Verify machine programs =================================================
class VerifyMachineProgramState extends ProductResourceManagementState {
  final List<UnVerifiedMachinePrograms> unVerifiedPrograms;
  final String token, userId;
  final int index;
  VerifyMachineProgramState(
      {required this.unVerifiedPrograms,
      required this.token,
      required this.userId,
      required this.index});
}

// ====================================================== Verified machine programs =================================================
class VerifiedMachineProgramsState extends ProductResourceManagementState {
  final String token, userId;
  final List<VerifiedMachineProgramsModel> verifiedMachinePrograms;
  final int index;
  VerifiedMachineProgramsState(
      {required this.token,
      required this.verifiedMachinePrograms,
      required this.userId,
      required this.index});
}

//=========================================================================  New Production Product ----------------------------
class NewProductionproductState extends ProductResourceManagementState {
  final String token, userId;
  final List<NewProductionProductmodel> newProductionproduct;
  final int index;
  NewProductionproductState(
      {required this.token,
      required this.newProductionproduct,
      required this.userId,
      required this.index});
}
