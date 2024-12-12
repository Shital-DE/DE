import 'package:de/services/model/operator/oprator_models.dart';

abstract class PendingProductState {}

class PendingProductionInitial extends PendingProductState {}

class PendingProductionLoadingState extends PendingProductState {
  final List<PendingProductlistforoperator> pendingproductlist;
  //final Barcode barcode;
  final bool cpmessagestatuscheck, statusofbarcode;
  final String token, employeeid;
  PendingProductionLoadingState(
      {required this.token,
      required this.employeeid,
      required this.cpmessagestatuscheck,
      required this.pendingproductlist,
      required this.statusofbarcode});
}

class PendingProductionErrorState extends PendingProductState {
  final String errorMessage;
  PendingProductionErrorState({required this.errorMessage});
}
