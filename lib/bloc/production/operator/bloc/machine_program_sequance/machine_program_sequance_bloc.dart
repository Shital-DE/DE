import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:de/bloc/production/operator/bloc/machine_Program_Sequance/machine_Program_Sequance_event.dart';
import 'package:de/bloc/production/operator/bloc/machine_Program_Sequance/machine_Program_Sequance_state.dart';
import 'package:de/services/model/operator/oprator_models.dart';
import 'package:de/services/repository/operator/operator_repository.dart';
import 'package:de/services/session/user_login.dart';
import 'package:flutter/material.dart';

class MachineProgramSequanceBloc
    extends Bloc<MachineProgramSequanceEvent, MachineProgramSequanceState> {
  final BuildContext context;

  MachineProgramSequanceBloc(this.context)
      : super(MachineProgramSequanceInitial()) {
    on<MachineProgramSequanceInitialEvent>((event, emit) async {
      String employeeId = '';
      String workcentreid = '';
      String workstationid = '';
      String machineid = '';
      String machinename = '';
      bool prmessagestatuscheck = false;

      final saveddata = await UserData.getUserData();
      // Token
      String token = saveddata['token'].toString();

      for (var userdata in saveddata['data']) {
        employeeId = userdata['id'];
      }

      final machinedata = await MachineData.geMachineData();
      for (var element in machinedata) {
        Map<String, dynamic> data = jsonDecode(element);
        workcentreid = data['wr_workcentre_id'];
        workstationid = data['workstationid'].toString();
        machineid = data['machineid'].toString();
        machinename = data['machinename'].toString();
      }

      List<Productprocessseq> productprocessseqlist = await OperatorRepository()
          .productprocessseq(
              workcentreid: workcentreid,
              token: token,
              productid: event.barcode.productid.toString(),
              revisionno: event.barcode.revisionnumber.toString());

      List<Productprocessseq> productprocessList = productprocessseqlist;

      prmessagestatuscheck = await OperatorRepository()
          .prmessagesendStatusCheck(
              event.barcode.productid.toString(),
              event.barcode.revisionnumber.toString(),
              event.barcode.rawmaterialissueid.toString(),
              token,
              event.barcode.poid.toString(),
              event.barcode.lineitemnumber.toString(),
              workcentreid);

      emit(MachineProgramSequanceLoadingState(
        event.barcode,
        productprocessList: productprocessList,
        token: token,
        workcentreid: workcentreid,
        workstationid: workstationid,
        machineid: machineid,
        machinename: machinename,
        prmessagestatuscheck: prmessagestatuscheck,
        employeeid: employeeId,
      ));
    });
  }
}
