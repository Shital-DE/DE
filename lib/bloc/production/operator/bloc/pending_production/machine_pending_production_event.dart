import 'package:de/services/model/operator/oprator_models.dart';

abstract class PendingProductionEvent {}

class PendingProductionInitialEvent extends PendingProductionEvent {
  //List<PendingProductlistforoperator> pendingproductlist = [];
  List<PendingProductlistforoperator> pendingproductlist;
  final bool statusofbarcode, cpmessagestatuscheck;
  PendingProductionInitialEvent({
    this.pendingproductlist = const [],
    required this.statusofbarcode,
    required this.cpmessagestatuscheck,
  });
}
