import 'package:de/services/model/operator/oprator_models.dart';

abstract class MachineProgramSequanceEvent {}

class MachineProgramSequanceInitialEvent extends MachineProgramSequanceEvent {
  final Barcode barcode;
  // List<String> pendingproductlist;
  final bool statusofbarcode, prmessagestatuscheck;
  List<String> folderList;
  // String cprunnumber = '';
  // String cpexcutionid = '';

  MachineProgramSequanceInitialEvent({
    required this.prmessagestatuscheck,
    required this.barcode,
    //this.pendingproductlist = const [],
    required this.folderList,
    required this.statusofbarcode,
    // required this.cprunnumber,
    // required this.cpexcutionid
  });
}
