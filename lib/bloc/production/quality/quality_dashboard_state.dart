// // Author : Shital Gayakwad
// // Created Date :  March 2023
// // Description : ERPX_PPC -> Quality state

import '../../../services/model/common/document_model.dart';
import '../../../services/model/machine/workcentre.dart';
import '../../../services/model/operator/oprator_models.dart';
import '../../../services/model/quality/quality_models.dart';

abstract class QualityState {}

class QualityInitialState extends QualityState {}

class QualityDashboardState extends QualityState {
  final bool isInspectionStarted;
  final Barcode barcode;
  final String pdfMdocId,
      pdfRevisionNo,
      modelMdocId,
      modelRevisionNo,
      productDescription,
      imageType,
      token,
      startInspection,
      workcentre,
      workstation,
      userid,
      inspectionId;

  final List<DocumentDetails> pdfDetails;
  final List<DocumentDetails> modelsDetails;
  final List<Workcentre> workcentrelist;
  final List<QualityRejectedReasons> rejectedReasonsList;
  QualityDashboardState(
      {required this.isInspectionStarted,
      required this.barcode,
      required this.pdfMdocId,
      required this.pdfRevisionNo,
      required this.modelMdocId,
      required this.modelRevisionNo,
      required this.productDescription,
      required this.imageType,
      required this.token,
      required this.startInspection,
      required this.workcentre,
      required this.workstation,
      required this.userid,
      required this.pdfDetails,
      required this.modelsDetails,
      required this.workcentrelist,
      required this.rejectedReasonsList,
      required this.inspectionId,
      required});
}

class QualityErrorState extends QualityState {
  final String errorMessage;
  QualityErrorState({required this.errorMessage});
}
