import '../../../../../services/model/common/document_model.dart';
import '../../../../../services/model/operator/oprator_models.dart';

abstract class OAPState {}

class OAPinitialState extends OAPState {}

class OAPLoadingState extends OAPState {
  final Barcode? barcode;
  bool isAlreadyEndProduction;
  final List<DocumentDetails> pdfDetails;
  final List<DocumentDetails> modelsDetails;
  //final List<String> selectedtoolsItems;
  List<Tools> toollist, selectedtoollist;
  final List<OperatorRejectedReasons> operatorrejresons;
  //String settingtime;
  // final int okqty, rejqty;
  // bool getdataflag = false;

  final String token,
      employeeId,
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
      machinename,
      getpreviousproductiontime,
      // rejectedresonsid,
      instruction;
  Map<String, dynamic> productRouteDetails;
  Map<String, dynamic> productbomid;
  //Map<String, dynamic> productiontimedata;
  OAPLoadingState({
    required this.barcode,
    required this.isAlreadyEndProduction,
    required this.token,
    required this.employeeId,
    required this.pdfmdocid,
    required this.pdfRevisionNo,
    required this.modelMdocid,
    required this.modelRevisionNumber,
    required this.productDescription,
    required this.imageType,
    required this.pdfDetails,
    required this.modelsDetails,
    //this.productionstatusid,
    //required this.selectedtoolsItems,
    required this.toollist,
    required this.selectedtoollist,
    // required this.okqty,
    // required this.rejqty,
    required this.operatorrejresons,
    required this.productionstatusid,
    required this.getpreviousproductiontime,
    required this.productbomid,
    required this.productRouteDetails,
    //required this.settingtime,
    required this.workcentreid,
    required this.workstationid,
    // this.getdataflag,
    required this.machineid,
    required this.machinename,
    // required this.rejectedresonsid,
    required this.instruction,
    // required this.productiontimedata
  });
}

class OAPErrorState extends OAPState {
  final String errorMessage;
  OAPErrorState({required this.errorMessage});
}
