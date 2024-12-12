// Author : Shital Gayakwad
// Created Date : 26 Feb 2023
// Description : ERPX_PPC -> login bloc
// Modified date : 21 May 2023

// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import '../../../routes/route_names.dart';
import '../../../services/model/machine/assigned_machine.dart';
import '../../../services/model/user/login_model.dart';
import '../../../services/repository/user/user_login_repo.dart';
import '../../../services/repository/machine/assigned_machine.dart';
import '../../../services/session/user_login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<UserLoginEvent, UserLoginstate> {
  final BuildContext context;
  LoginBloc({required this.context}) : super(LoginInitialState()) {
    on<LoginCredentialsEvent>((event, emit) async {
      emit(LoginState(
          username: event.username,
          password: event.password,
          obsecurePassword: event.obsecurePassword,
          submitting: event.submitting));
      final navigator = Navigator.of(context);
      if (event.username != '' &&
          event.password != '' &&
          event.submitting == true) {
        //Getting userdata by sending parameters username and password
        final userData = await UserLoginRepository()
            .userLogin(event.username, event.password);

        if (userData.toString() == 'Server unreachable') {
          emit(LoginErrorState(
              errorMessage: 'Server unreachable',
              username: event.username,
              password: event.password));
        } else if (userData.toString() ==
            'User data not found please check your credentials') {
          emit(LoginErrorState(
              errorMessage: 'User data not found please check your credentials',
              username: event.username,
              password: event.password));
        } else {
          String deviceId = '';
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

            UserLoginModel userLoginModel = userData;
            List<UserDataModel>? employeedata = userLoginModel.data;
            final machinedata = await AssignedmachineRepository()
                .assignedMachine(deviceId, userLoginModel.token.toString());
            List<AssignedMachine> assignedMachine = machinedata;

            // Save user log
            String userLogId = await UserLoginRepository().employeeLogHistory(
                token: userLoginModel.token.toString(),
                payload: {
                  'employee_id': employeedata![0].id.toString().trim(),
                  'androidid': deviceId.toString().trim(),
                  'workcentre_id': assignedMachine.isNotEmpty
                      ? assignedMachine[0].wrWorkcentreId.toString().trim()
                      : '',
                  'workstation_id': assignedMachine.isNotEmpty
                      ? assignedMachine[0].workstationid.toString().trim()
                      : ''
                });

            List<int> bytes =
                utf8.encode(event.password); // Compute the SHA-256 hash
            Digest digest = sha256
                .convert(bytes); // Convert the digest to a hexadecimal string
            String hashedPassword = digest.toString();
            await UserData.saveUserData(
                userLoginModel: userLoginModel,
                loginCredentials: [event.username, hashedPassword],
                userLogId: userLogId.length == 32 ? userLogId : '');

            emit(LoginState(
                username: event.username,
                password: event.password,
                obsecurePassword: ValueNotifier<bool>(true),
                submitting: false));
            navigator.pushNamed(RouteName.dashboard); // Navigating to dashboard
          } catch (e) {
            emit(LoginErrorState(
                errorMessage: 'Something went wrong',
                username: event.username,
                password: event.password));
          }
        }
      }
    });
  }
}
