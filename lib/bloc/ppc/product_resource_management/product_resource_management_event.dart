// Author : Shital Gayakwad
// Created date : 20 September 2023
// Description : Product resource managements event
// Modified date : 12  Oct 2023
// Added machine program verification code

// ============================================================ Programs upload =====================================================
class ProductResourceManagementEvent {}

class UploadMachineProgramEvent extends ProductResourceManagementEvent {
  final String productId, productRevision, processRouteId;
  UploadMachineProgramEvent(
      {this.productId = '',
      this.productRevision = '',
      this.processRouteId = ''});
}

// ====================================================== Verify machine programs =================================================
class VerifyMachineProgramEvent extends ProductResourceManagementEvent {
  final int index;
  VerifyMachineProgramEvent({this.index = 1});
}

// ====================================================== Verified machine programs =================================================
class VerifiedMachineProgramEvent extends ProductResourceManagementEvent {
  final int index;
  VerifiedMachineProgramEvent({this.index = 1});
}

//================================================ new production Product ==================================
class NewProductionProductEvent extends ProductResourceManagementEvent {
  final int index;
  NewProductionProductEvent({this.index = 1});
}
