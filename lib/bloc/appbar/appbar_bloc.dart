// Author : Shital Gayakwad
// Created Date : 26 Feb 2023
// Description : ERPX_PPC -> Appbar bloc
// Modified data : 21 May 2023

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import '../../services/model/machine/assigned_machine.dart';
import '../../services/repository/user/user_login_repo.dart';
import '../../services/repository/machine/assigned_machine.dart';
import '../../services/session/user_login.dart';
import 'appbar_event.dart';
import 'appbar_state.dart';

class AppBarBloc extends Bloc<AppbarEvent, AppbarState> {
  AppBarBloc() : super(AppBarInitial()) {
    on<AppbarData>((event, emit) async {
      String deviceId = '',
          workcentre = '',
          wcid = '',
          wsid = '',
          workstation = '',
          employeename = '';
      dynamic profdata;
      final saveddata = await UserData.getUserData(); //User data
      try {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          const androidId = AndroidId();
          deviceId = await androidId.getId() ?? '';
        } else if (Platform.isLinux) {
          final linuxInfo = await deviceInfo.linuxInfo;
          deviceId = linuxInfo.machineId ?? '';
        } else if (Platform.isWindows) {
          final windowsInfo = await deviceInfo.windowsInfo;
          deviceId = windowsInfo.deviceId;
        }
        if (deviceId != '') {
          final machinedata = await AssignedmachineRepository()
              .assignedMachine(deviceId, saveddata['token'].toString());
          List<AssignedMachine> assignedMachine = machinedata;

          // Saving assigned machine data to local storage of the device
          if (assignedMachine.isNotEmpty) {
            await MachineData.saveAssignedMachineData(assignedMachine);
          }
          // Assigned workcentre with workstation
          for (var data in assignedMachine) {
            workcentre = data.workcentre.toString();
            workstation = data.workstation.toString();
            wcid = data.wrWorkcentreId.toString();
            wsid = data.workstationid.toString();
          }
        } else {
          emit(AppBarErrorState(errorName: 'Device id not found'));
        }

        for (var userdata in saveddata['data']) {
          // Employee name
          employeename = '${userdata['firstname']} ${userdata['lastname']}';

          if (userdata['empprofilemdocid'] != null) {
            // Employee profile data
            profdata = await UserLoginRepository().employeeProfile(
                userdata['empprofilemdocid'], saveddata['token'].toString());

            if (profdata != null) {
              if (profdata.toString() == 500.toString()) {
                ImageProvider provider =
                    const AssetImage('assets/icon/emp.png');
                emit(AppbarLoading(
                    workcentreName: workcentre,
                    workstationname: workstation,
                    employeeProfile: provider,
                    employeename: employeename,
                    employeeid: userdata['id'],
                    deviceid: deviceId,
                    wcid: wcid,
                    wsid: wsid,
                    token: saveddata['token'].toString()));
              } else {
                if (Platform.isAndroid) {
                  Uint8List profileData = profdata;
                  ImageProvider<Object> employeeProfile =
                      MemoryImage(profileData);
                  emit(AppbarLoading(
                      workcentreName: workcentre,
                      workstationname: workstation,
                      employeeProfile: employeeProfile,
                      employeename: employeename,
                      employeeid: userdata['id'],
                      deviceid: deviceId,
                      wcid: wcid,
                      wsid: wsid,
                      token: saveddata['token'].toString()));
                } else {
                  ImageProvider provider =
                      const AssetImage('assets/icon/emp.png');
                  emit(AppbarLoading(
                      workcentreName: workcentre,
                      workstationname: workstation,
                      employeeProfile: provider,
                      employeename: employeename,
                      employeeid: userdata['id'],
                      deviceid: deviceId,
                      wcid: wcid,
                      wsid: wsid,
                      token: saveddata['token'].toString()));
                }
              }
            } else {
              emit(AppBarErrorState(errorName: 'Profile photo not found'));
            }
          } else {
            ImageProvider provider = const AssetImage('assets/icon/emp.png');
            emit(AppbarLoading(
                workcentreName: workcentre,
                workstationname: workstation,
                employeeProfile: provider,
                employeename: employeename,
                employeeid: userdata['id'],
                deviceid: deviceId,
                wcid: wcid,
                wsid: wsid,
                token: saveddata['token'].toString()));
          }
        }
      } catch (e) {
        emit(AppBarErrorState(errorName: e.toString()));
      }
    });
  }
}
