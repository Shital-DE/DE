import '../../../../../services/model/operator/oprator_models.dart';

abstract class OAP {}

class OAPEvent extends OAP {
  final Barcode barcode;
  final Map<String, dynamic> machinedata;
  // final List<String> selectedtoolsItems;
  final List<Tools> selectedtoollist;
  final String processrouteid,
      seqno,
      cprunnumber,
      cpchildid,
      productionstatusid;
  // rejectedresonsid;
  //final int okqty, rejqty;
  OAPEvent(
      {required this.barcode,
      required this.machinedata,
      //  this.selectedtoolsItems = const [],
      required this.selectedtoollist,
      this.processrouteid = '',
      this.seqno = '',
      this.cprunnumber = '',
      this.cpchildid = '',
      // this.rejectedresonsid = ''
      required this.productionstatusid});
}
