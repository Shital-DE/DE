// // Author : Shital Gayakwad
// // Created Date :  March 2023
// // Description : ERPX_PPC -> Quality event

import '../../../services/model/operator/oprator_models.dart';

abstract class QualityEvents {}

class QualityDashboardEvents extends QualityEvents {
  final bool isInspectionStarted;
  final Barcode barcode;
  final String startInspection;

  QualityDashboardEvents({
    this.isInspectionStarted = false,
    required this.barcode,
    this.startInspection = '',
  });
}
