import 'package:de/services/model/operator/oprator_models.dart';

abstract class MachineProgramSequanceEvent {}

class MachineProgramSequanceInitialEvent extends MachineProgramSequanceEvent {
  final Barcode barcode;
  final bool statusofbarcode, prmessagestatuscheck;
  List<String> folderList;

  MachineProgramSequanceInitialEvent({
    required this.prmessagestatuscheck,
    required this.barcode,
    required this.folderList,
    required this.statusofbarcode,
  });
}
