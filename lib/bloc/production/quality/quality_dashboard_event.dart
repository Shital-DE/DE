// // Author : Shital Gayakwad
// // Created Date :  March 2023
// // Description : ERPX_PPC -> Quality event

import '../../../services/model/operator/oprator_models.dart';

abstract class QualityEvents {}

// Quality production events
class QualityProductionEvents extends QualityEvents {
  final bool isInspectionStarted;
  final Barcode barcode;
  final String startInspection;

  QualityProductionEvents({
    this.isInspectionStarted = false,
    required this.barcode,
    this.startInspection = '',
  });
}

// Quality processes events
class QualityProductionProcessesEvents extends QualityEvents {
  final Barcode barcode;
  QualityProductionProcessesEvents({required this.barcode});
}
