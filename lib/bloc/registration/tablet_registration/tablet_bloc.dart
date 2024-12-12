// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Tablet registration bloc

// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../services/model/machine/assigned_machine.dart';
import '../../../services/model/machine/workcentre.dart';
import '../../../services/model/machine/workstation.dart';
import '../../../services/repository/common/tablet_repository.dart';
import '../../../services/session/user_login.dart';
import 'package:android_id/android_id.dart';
import 'tablet_event.dart';
part 'tablet_state.dart';

class TabletBloc extends Bloc<TabletEvent, TabletState> {
  final BuildContext context;
  TabletBloc(this.context) : super(TabletLoading()) {
    on<TabletFormEvent>((event, emit) async {
      String deviceId = '';

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
        //Workcentre
        String token = await UserData.authorizeToken();
        final workcentreListData =
            await TabletRepository().workcentreList(token);

        if (workcentreListData.toString() == 'Server unreachable') {
          emit(TabletErrorState(errorMessage: 'Workcentre list not found'));
        } else {}
        List<Workcentre> workcentreList = workcentreListData;

        //Workstation
        List<WorkstationByWorkcentreId> workstationList = [];
        if (event.workcentreId != '') {
          workstationList = await TabletRepository()
              .worstationByWcId(token: token, workcentreId: event.workcentreId);
        }

        //Check if already assigned
        List<CheckTabIsAssignedOrNot> checkTabIsAssignedList = [];
        if (event.workstationId != '') {
          checkTabIsAssignedList = await TabletRepository()
              .checkTabletIsAlreadyRegisteredOrNot(token, event.workstationId);
        }

        //All ws list
        List<AllWcWsWithAndroidId> allTabAssignedList =
            await TabletRepository().getAllTabletAssignedList(token);
        String workstationid = event.workstationId;

        emit(TabletLoaded(
            androidId: deviceId,
            workcentreList: workcentreList,
            workstationList: workstationList,
            checkTabIsAssignedList: checkTabIsAssignedList,
            token: token,
            allTabAssignedList: allTabAssignedList,
            workcentreId: event.workcentreId,
            workstationId: workstationid,
            checkALreadyRegisteredTabletList:
                event.checkALreadyRegisteredTabletList));
      }
    });
  }
}
