part of 'scan_cubit.dart';

class ScanState {
  String code;
  bool isScan;
  Barcode? barcode;
  List<String>? machinedata;

  ScanState({
    required this.code,
    required this.isScan,
    this.barcode,
    this.machinedata,
  });
}

class ProcessLoadedState extends ScanState {
  ProcessLoadedState(
      {required super.code, required super.isScan, Barcode? barcode});
}

class OperatorScreenState {
  List<String> reasons;
  OperatorScreenState({required this.reasons});
}
