import '../../../../../services/model/operator/oprator_models.dart';

abstract class OMP {}

class OMPEvent extends OMP {
  final List<String> selectedItems;
  final String settingtime, startproductiontime, rejresons;
  final int okqty, rejqty;
  final Barcode barcode;
  final Map<String, dynamic> machinedata;

  OMPEvent(this.selectedItems, this.settingtime, this.startproductiontime,
      this.okqty, this.barcode, this.machinedata, this.rejqty, this.rejresons);
}
