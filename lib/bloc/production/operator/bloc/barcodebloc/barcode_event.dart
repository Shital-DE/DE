part of 'barcode_bloc.dart';

@immutable
abstract class BarcodeEvent {}

class BarcodeLoadEvent extends BarcodeEvent {
  final Barcode? barcode;
  BarcodeLoadEvent(this.barcode);
}

abstract class Operatormanual {}

class OperatorScreenEvent extends Operatormanual {
  final List<String> selectedItems;
  final List<Tools> selectedtoollist;

  final String settingtime, startproductiontime, rejresons;
  final int okqty, rejqty;
  final Barcode barcode;
  final Map<String, dynamic> machinedata;

  OperatorScreenEvent(
      this.selectedItems,
      this.settingtime,
      this.startproductiontime,
      this.okqty,
      this.selectedtoollist,
      this.barcode,
      this.machinedata,
      this.rejqty,
      this.rejresons);
}

abstract class OperatorAutomatic {}

class OperatorAutoScreenEvent extends OperatorAutomatic {
  final Barcode barcode;
  final Map<String, dynamic> machinedata;
  final List<String> selectedItems;
  final List<Tools> selectedtoollist;
  final int okqty;
  final int rejqty;
  OperatorAutoScreenEvent(
    this.barcode,
    this.machinedata,
    this.selectedItems,
    this.selectedtoollist,
    this.okqty,
    this.rejqty,
  );
}
