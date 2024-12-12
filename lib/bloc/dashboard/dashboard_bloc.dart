// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Dashboard bloc
//Modified date : 21 May 2023

import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/model/dashboard/dashboard_model.dart';
import '../../services/repository/dashboard/dashboard_repository.dart';
import '../../services/session/user_login.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardinitialState()) {
    on<DashboardMenuEvent>((event, emit) async {
      List<UserModule> folderdata = [];
      List<Programs> programsList = [];
      String worcentreid = '', isautomatic = '';
      final data = await UserData.getUserData(); // token and employee data

      // program folders
      final userModules = await DashboardRepository().userModules(
          token: data['token'],
          username: data['loginCredentials'][0].toString(),
          password: data['loginCredentials'][1].toString());
      if (userModules.toString() == 'Server unreachable') {
        emit(DashboardError(errorMessage: 'Server unreachable'));
      } else {
        if (userModules != null) {
          folderdata = userModules;
        }

        // programs assigned to user
        programsList = await DashboardRepository().programs(
            token: data['token'].toString(),
            folderId: event.platform == 'Mobile'
                ? 'All'
                : event.folder['id'].toString() == ''
                    ? folderdata[0].folderId.toString()
                    : event.folder['id'].toString(),
            username: data['loginCredentials'][0].toString(),
            password: data['loginCredentials'][1].toString());

        // machine data which is saved in shared preferences
        List<String> machinedata = await MachineData.geMachineData();
        List<dynamic> assignedMachineData = jsonDecode(machinedata.toString());
        for (var machineData in assignedMachineData) {
          worcentreid = machineData['wr_workcentre_id'].toString();
          final machineCheckdata = await DashboardRepository().getDashboardBody(
              workcentreid: machineData['wr_workcentre_id'].toString(),
              workstationid: machineData['workstationid'].toString());
          List<MachineAutomaticCheck> machineCheck = machineCheckdata;
          for (var element in machineCheck) {
            isautomatic = element.isautomatic.toString();
          }
        }

        emit(DashboardLoadingState(
            data: folderdata,
            selectedIndex: event.selectedIndex,
            folder: event.folder,
            programsList: programsList,
            workcentreid: worcentreid,
            isautomatic: isautomatic));
      }
    });
  }
}
