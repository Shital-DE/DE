// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import '../bloc/production/operator/cubit/scan_cubit.dart';
import '../services/model/dashboard/dashboard_model.dart';
import '../services/model/operator/oprator_models.dart';
import '../services/repository/dashboard/dashboard_repository.dart';
import '../services/session/user_login.dart';
import 'route_names.dart';

class ProductionRoute {
  void gotoSupervisorProduction(
      BuildContext context, List<Programs> programsList, ScanState state) {
    Navigator.pushNamed(context, RouteName.production, arguments: {
      'programs': programsList,
      'barcode': state.barcode,
    });
  }

  void gotoQuality(BuildContext context, ScanState state) {
    Navigator.pushNamed(context, RouteName.qualityProductionProcessScreen,
        arguments: {
          'barcode': state.barcode,
        });
  }

  void gotoPacking(BuildContext context, ScanState state) {
    Navigator.pushNamed(context, RouteName.packingScreen, arguments: {
      'barcode': state.barcode,
    });
  }

  void gotoCutting(BuildContext context, ScanState state) {
    Navigator.pushNamed(context, RouteName.cuttingProductionProcessScreen,
        arguments: {
          'barcode': state.barcode,
        });
  }

  Future<void> gotoOperatorScreen(
      {required BuildContext context,
      required Barcode barcode,
      required String processrouteid,
      required String seqno,
      required String cprunnumber,
      required String cpchildid}) async {
    List<String> machinedata = await MachineData.geMachineData();
    List<dynamic> assignedMachineData = jsonDecode(machinedata.toString());
    for (var machineData in assignedMachineData) {
      final machineCheckdata = await DashboardRepository().getDashboardBody(
          workcentreid: machineData['wr_workcentre_id'].toString(),
          workstationid: machineData['workstationid'].toString());
      List<MachineAutomaticCheck> machineCheck = machineCheckdata;
      for (var element in machineCheck) {
        if (element.isautomatic.toString() == 'N') {
          Navigator.pushNamed(
            context,
            RouteName.operatorManualProduction,
            arguments: {'barcode': barcode, 'machinedata': machineData},
          );
        } else if (element.isautomatic.toString() == 'Y') {
          Navigator.pushNamed(context, RouteName.operatorAutoProduction,
              arguments: {
                'barcode': barcode,
                'machinedata': machineData,
                'processrouteid': processrouteid,
                'seqno': seqno,
                'cprunnumber': cprunnumber,
                'cpchildid': cpchildid,
              });
        }
      }
    }
  }
}
