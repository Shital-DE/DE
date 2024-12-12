part of 'scan_cubit.dart';

class ScanState {
  String code;
  bool isScan;
  Barcode? barcode;
  List<String>? machinedata;
  //final List<MachineCenterProcess>? machineprocess;
  ScanState({
    required this.code,
    required this.isScan,
    this.barcode,
    this.machinedata,
  });
}

class ProcessLoadedState extends ScanState {
  ProcessLoadedState(
      {required super.code,
      required super.isScan,
      // required super.machineprocess,
      Barcode? barcode});

  // String codeval;
  // bool isScanval;
  // Barcode? barcodeval;
  // List<MachineCenterProcess> machineprocessList;
  // ProcessLoadedState(
  //     {required this.codeval,
  //     required this.isScanval,
  //     this.barcodeval,
  //     required this.machineprocessList})
  //     : super(
  //           code: codeval,
  //           isScan: isScanval,
  //           barcode: barcodeval,
  //           machineprocess: machineprocessList);
}

class OperatorScreenState {
  List<String> reasons;
  OperatorScreenState({required this.reasons});
}

// class MachineprocessState {
//   MachineCenterProcess? machineprocess;
//   MachineprocessState({this.machineprocess});
// }
