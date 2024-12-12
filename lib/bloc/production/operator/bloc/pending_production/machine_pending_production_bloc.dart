// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:de/bloc/production/operator/bloc/pending_production/machine_pending_production_event.dart';
import 'package:de/bloc/production/operator/bloc/pending_production/machine_pending_production_state.dart';
import 'package:de/services/model/operator/oprator_models.dart';
import 'package:de/services/repository/operator/operator_repository.dart';
import 'package:de/services/session/barcode.dart';
import 'package:de/services/session/user_login.dart';
import 'package:flutter/material.dart';

class PendingProductionBloc
    extends Bloc<PendingProductionEvent, PendingProductState> {
  final BuildContext context;
  PendingProductionBloc(this.context) : super(PendingProductionInitial()) {
    on<PendingProductionInitialEvent>((event, emit) async {
      List<PendingProductlistforoperator> pendingproductlist = [];
      String employeeId = '',
          employeeName = '',
          workcentreid = '',
          workstationid = '',
          machineid = '',
          machinename = '';
      bool cpmessagestatuscheck = false;

      final saveddata = await UserData.getUserData();

      String token = saveddata['token'].toString();

      for (var userdata in saveddata['data']) {
        employeeId = userdata['id'];
        employeeName = userdata['firstname'];
      }

      final machinedata = await MachineData.geMachineData();

      for (var element in machinedata) {
        Map<String, dynamic> data = jsonDecode(element);
        workcentreid = data['wr_workcentre_id'];
        workstationid = data['workstationid'].toString();
        machineid = data['machineid'].toString();
        machinename = data['machinename'].toString();
      }

      if (event.statusofbarcode == false) {
        pendingproductlist = await OperatorRepository.pendingproductlist(
            workcentreid: workcentreid, token: token);
      } else if (event.statusofbarcode == true) {
        Barcode barcode = await ProductData.getbarocodeData();

        pendingproductlist =
            await OperatorRepository.productlistfromcapacityplan(
                workcentreid: workcentreid,
                productid: barcode.productid.toString(),
                rmsid: barcode.rawmaterialissueid.toString(),
                poid: barcode.poid.toString(),
                token: token);

        cpmessagestatuscheck = await OperatorRepository()
            .cpmessagesendStatusCheck(
                barcode.productid.toString(),
                barcode.revisionnumber.toString(),
                barcode.rawmaterialissueid.toString(),
                token,
                barcode.poid.toString(),
                barcode.lineitemnumber.toString());
      }

      emit(PendingProductionLoadingState(
          token: token,
          pendingproductlist: pendingproductlist,
          cpmessagestatuscheck: cpmessagestatuscheck,
          employeeid: employeeId,
          statusofbarcode: event.statusofbarcode));
    });
  }
}
