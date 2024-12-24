// // Author : Shital Gayakwad
// // Created Date :  March 2023
// // Description : ERPX_PPC -> Quality event

import '../../../services/model/operator/oprator_models.dart';
import '../../../services/model/product/product_route.dart';

abstract class QualityEvents {}

// Quality production events
class QualityProductionEvents extends QualityEvents {
  final bool isInspectionStarted;
  final Barcode barcode;
  final String startInspection;
  ProductAndProcessRouteModel? productAndProcessRouteModel;
  QualityProductionEvents({
    this.isInspectionStarted = false,
    required this.barcode,
    this.startInspection = '',
    this.productAndProcessRouteModel,
  });
}

// Quality processes events
class QualityProductionProcessesEvents extends QualityEvents {
  final Barcode barcode;
  QualityProductionProcessesEvents({required this.barcode});
}
