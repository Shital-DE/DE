import 'package:de/services/model/operator/oprator_models.dart';

abstract class MachineProgramSequanceState {}

class MachineProgramSequanceInitial extends MachineProgramSequanceState {}

class MachineProgramSequanceLoadingState extends MachineProgramSequanceState {
  final Barcode? barcode;
  final bool prmessagestatuscheck;
  String token,
      employeeid,
      workcentreid = '',
      workstationid = '',
      machineid = '',
      machinename = '';

  List<Productprocessseq> productprocessList;

  MachineProgramSequanceLoadingState(
    this.barcode, {
    required this.employeeid,
    required this.prmessagestatuscheck,
    required this.productprocessList,
    required this.token,
    required this.workcentreid,
    required this.workstationid,
    required this.machineid,
    required this.machinename,
  });
}

class MachineProgramSequanceErrorState extends MachineProgramSequanceState {
  final String errorMessage;
  MachineProgramSequanceErrorState({required this.errorMessage});
}
