import '../../../../../services/model/operator/oprator_models.dart';

abstract class OAP {}

class OAPEvent extends OAP {
  final Barcode barcode;
  final Map<String, dynamic> machinedata;
  final List<Tools> selectedtoollist;
  final String processrouteid,
      seqno,
      cprunnumber,
      cpchildid,
      productionstatusid;
  OAPEvent(
      {required this.barcode,
      required this.machinedata,
      required this.selectedtoollist,
      this.processrouteid = '',
      this.seqno = '',
      this.cprunnumber = '',
      this.cpchildid = '',
      required this.productionstatusid});
}
