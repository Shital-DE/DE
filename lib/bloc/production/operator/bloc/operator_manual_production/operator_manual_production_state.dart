import '../../../../../services/model/common/document_model.dart';
import '../../../../../services/model/operator/oprator_models.dart';

abstract class OMPState {}

class OMPinitialState extends OMPState {}

class OMPLoadingState extends OMPState {
  final List<String> selectedItems;
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

  Map<String, dynamic> getpreviousproductiontime;
  OMPLoadingState(
      this.selectedItems,
      this.token,
      this.employeeID,
      this.settingtime,
      this.startproductiontime,
      this.okqty,
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
      this.rejresons);
}

class OMPErrorState extends OMPState {
  final String errorMessage;
  OMPErrorState(this.errorMessage);
}
