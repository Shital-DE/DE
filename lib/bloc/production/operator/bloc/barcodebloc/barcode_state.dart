part of 'barcode_bloc.dart';

@immutable
abstract class BarcodeState {}

class BarcodeInitial extends BarcodeState {}

class BarcodeLoadState extends BarcodeState {
  final String barcode;
  BarcodeLoadState(this.barcode);
}

abstract class OperatorManualState {}

class OperatorManualinitialState extends OperatorManualState {}

class OperatorManualLoadingState extends OperatorManualState {
  final List<String> selectedItems;
  final List<Tools> toollist, selectedtoollist;
  final List<DocumentDetails> pdfDetails;
  final List<DocumentDetails> modelsDetails;
  final List<OperatorRejectedReasons> operatorrejresons;
  final int okqty, rejqty;
  final String token,
      employeeID,
      settingtime,
      startproductiontime,
      workcentreid,
      workstationid,
      pdfmdocid,
      pdfRevisionNo,
      modelMdocid,
      modelRevisionNumber,
      productDescription,
      imageType,
      productionstatusid;
  final Barcode barcode;
  bool isAlreadyEndProduction;

  Map<String, dynamic> getpreviousproductiontime;
  Map<String, dynamic> productRouteDetails;
  Map<String, dynamic> productbomid;
  OperatorManualLoadingState(
      this.selectedItems,
      this.token,
      this.employeeID,
      this.settingtime,
      this.startproductiontime,
      this.toollist,
      this.okqty,
      this.selectedtoollist,
      this.workcentreid,
      this.workstationid,
      this.pdfmdocid,
      this.pdfRevisionNo,
      this.modelMdocid,
      this.modelRevisionNumber,
      this.productDescription,
      this.imageType,
      this.barcode,
      this.modelsDetails,
      this.pdfDetails,
      this.rejqty,
      this.operatorrejresons,
      this.productionstatusid,
      this.getpreviousproductiontime,
      this.isAlreadyEndProduction,
      this.productbomid,
      this.productRouteDetails);
}

class OperatormanualyErrorState extends OperatorManualState {
  final String errorMessage;
  OperatormanualyErrorState(this.errorMessage);
}

//////////////////////////////////////////////////////////////////////////////////////////
abstract class OperatorAutomaticState {}

class OperatorAutomaticinitialState extends OperatorAutomaticState {}

class OperatorAutomaticLoadingState extends OperatorAutomaticState {
  final Barcode barcode;
  bool isAlreadyEndProduction;
  final List<DocumentDetails> pdfDetails;
  final List<DocumentDetails> modelsDetails;
  final List<String> selectedItems;
  final List<Tools> toollist, selectedtoollist;
  final List<OperatorRejectedReasons> operatorrejresons;
  String settingtime;
  final int okqty;
  final int rejqty;
  bool getdataflag = false;
  final String token,
      employeeID,
      pdfmdocid,
      pdfRevisionNo,
      modelMdocid,
      modelRevisionNumber,
      productDescription,
      imageType,
      productionstatusid,
      workcentreid,
      workstationid,
      machineid,
      machinename;
  Map<String, dynamic> getpreviousproductiontime;
  Map<String, dynamic> productRouteDetails;
  Map<String, dynamic> productbomid;
  OperatorAutomaticLoadingState(
      this.barcode,
      this.isAlreadyEndProduction,
      this.token,
      this.employeeID,
      this.pdfmdocid,
      this.pdfRevisionNo,
      this.modelMdocid,
      this.modelRevisionNumber,
      this.productDescription,
      this.imageType,
      this.pdfDetails,
      this.modelsDetails,
      this.selectedItems,
      this.toollist,
      this.selectedtoollist,
      this.okqty,
      this.rejqty,
      this.operatorrejresons,
      this.productionstatusid,
      this.getpreviousproductiontime,
      this.productbomid,
      this.productRouteDetails,
      this.settingtime,
      this.workcentreid,
      this.workstationid,
      this.getdataflag,
      this.machineid,
      this.machinename);
}

class OperatorAutomaticErrorState extends OperatorAutomaticState {
  final String errorMessage;
  OperatorAutomaticErrorState(this.errorMessage);
}
