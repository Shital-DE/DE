import '../../../../../services/model/common/document_model.dart';
import '../../../../../services/model/operator/oprator_models.dart';

abstract class OMPState {}

class OMPinitialState extends OMPState {}

class OMPLoadingState extends OMPState {
  final List<String> selectedItems;
  //final List<Tools> toollist, selectedtoollist;
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
      productionstatusid,
      rejresons;
  final Barcode barcode;
  // bool isAlreadyEndProduction;

  Map<String, dynamic> getpreviousproductiontime;
  //Map<String, dynamic> productRouteDetails;
  //Map<String, dynamic> productbomid;
  OMPLoadingState(
      this.selectedItems,
      this.token,
      this.employeeID,
      this.settingtime,
      this.startproductiontime,
      // this.toollist,
      this.okqty,
      //this.selectedtoollist,
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
      //this.isAlreadyEndProduction,
      // this.productbomid,
      // this.productRouteDetails
      this.rejresons);
}

class OMPErrorState extends OMPState {
  final String errorMessage;
  OMPErrorState(this.errorMessage);
}
