// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:de/services/model/operator/oprator_models.dart';
import 'package:de/services/repository/operator/operator_repository.dart';
import 'package:de/services/session/barcode.dart';
import 'package:de/services/session/user_login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit()
      : super(ScanState(
          code: '',
          isScan: false,
        ));

  void scanCode({required bool val, required BuildContext context}) async {
    final saveddata = await UserData.getUserData();
    String token = saveddata['token'].toString();
    Map<String, String> barcode =
        await OperatorRepository.scanBarcode(context: context);

    if (barcode.isNotEmpty) {
      Barcode barCode = await OperatorRepository.getBarcodeData(
          token: token,
          year: barcode['year']!,
          documentno: barcode['document_no']!);

      if (barcode.isNotEmpty) {
        // List<String> stringList =
        //     barCode.map((barcode) => barcode.toString()).toList();
        List<Barcode> barcodelist = [barCode];
        final List<String> barcodeDataList =
            barcodelist.map((item) => jsonEncode(item)).toList();
        ProductData.saveBarcodeData(barcodelist: barcodeDataList
            //[
            // barCode.productid.toString(),
            // barCode.rawmaterialissueid.toString(),
            // barCode.poid.toString(),
            // ]
            );
      }
      List<String> machinedata = await MachineData.geMachineData();
      // String workstationid = '';
      machinedata.map((jsonString) {
        // workstationid = jsonDecode(jsonString)['workstationid'];
      }).toList();
      // List<MachineCenterProcess> mprocesslist =
      //     await OperatorRepository.getMachineProcess(
      //         //wsid: workstationid
      //         // '213eff3361214449b188abdd79df628c'
      //         );

      if (val == true) {
        emit(ScanState(
            code: barcode["code"]!,
            isScan: true,
            barcode: barCode,
            machinedata: machinedata));
      }
    }
  }

  void clearForm(bool val) {
    if (val == false) {
      emit(ScanState(
        code: '',
        isScan: false,
      ));
    }
  }
}

class OperatorScreenCubit extends Cubit<OperatorScreenState> {
  OperatorScreenCubit() : super(OperatorScreenState(reasons: []));

  void listReasons() {
    List<String> reason = ['abc', 'def', 'ghi'];
    // print("<<<<<<<<<<<<<reason....>>>>>>>>>>>>>");
    // if (val == false) {
    emit(OperatorScreenState(reasons: reason));
    // }
  }
}
