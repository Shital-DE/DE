import '../../../../../services/model/common/document_model.dart';
import '../../../../../services/model/operator/oprator_models.dart';

abstract class OAPState {}

class OAPinitialState extends OAPState {}

class OAPLoadingState extends OAPState {
  final Barcode? barcode;
  bool isAlreadyEndProduction;
  final List<DocumentDetails> pdfDetails;
  final List<DocumentDetails> modelsDetails;
  List<Tools> toollist, selectedtoollist;
  final List<OperatorRejectedReasons> operatorrejresons;

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
      instruction;
  Map<String, dynamic> productRouteDetails;
  Map<String, dynamic> productbomid;
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
    required this.toollist,
    required this.selectedtoollist,
    required this.operatorrejresons,
    required this.productionstatusid,
    required this.getpreviousproductiontime,
    required this.productbomid,
    required this.productRouteDetails,
    required this.workcentreid,
    required this.workstationid,
    required this.machineid,
    required this.machinename,
    required this.instruction,
  });
}

class OAPErrorState extends OAPState {
  final String errorMessage;
  OAPErrorState({required this.errorMessage});
}
