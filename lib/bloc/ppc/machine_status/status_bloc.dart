// Author : Shital Gayakwad
// Created Date : 12 April 2023
// Description : ERPX_PPC -> Machine status bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/machine/machine_model.dart';
import '../../../services/model/machine/workstation.dart';
import '../../../services/model/registration/machine_registration_model.dart';
import '../../../services/repository/common/tablet_repository.dart';
import '../../../services/repository/machine/machine_registration_repository.dart';
import '../../../services/repository/machine/machine_status_repository.dart';
import '../../../services/session/user_login.dart';
import 'status_event.dart';
import 'status_state.dart';

class MachineStatusBloc extends Bloc<MachineStatusEvent, MachineStatusState> {
  MachineStatusBloc() : super(MachineInitialState()) {
    on<MachineStatusLoadingEvents>((event, emit) async {
      //User data
      final saveddata = await UserData.getUserData();

      //Token
      String token = saveddata['token'].toString();

      //Workcentre list
      final workcentre =
          await MachineRegistrationRepository().isinhouseallWorkcentres(token);

      //Work stations by workcentre id

      final workstationsListData = await TabletRepository().worstationByWcId(
          token: token, workcentreId: event.workcentre['id'] ?? '');

      //recent 100 records
      final recent100Records =
          await MachineStatusRepository().recent100Record(token: token);

      //Workcentre status
      final workcentreStatus = await MachineStatusRepository().workcentreStatus(
          token: token, workcentreid: event.workcentre['id'] ?? '');

      //workcentrewise employee list
      final workcentrewiseEmployeeList = await MachineStatusRepository()
          .workcentreEmployeeList(
              token: token, workcentreid: event.workcentre['id'] ?? '');

      //workstation status
      final workstationStatus = await MachineStatusRepository()
          .workstationStatus(
              token: token,
              workcentreid: event.workcentre['id'] ?? '',
              workstationid: event.workstation['id'] ?? '');

      //Workcentre periodic data
      final workcentrePeriodic = await MachineStatusRepository()
          .periodicWorkcentreStatus(
              token: token,
              workcentreid: event.workcentre['id'] ?? '',
              fromDate: event.selectedPeriod['From'] ?? '',
              toDate: event.selectedPeriod['To'] ?? '');

      //Workstation periodic data
      final workstatioPeriodic = await MachineStatusRepository()
          .periodicWorkstationStatus(
              token: token,
              workcentreid: event.workcentre['id'] ?? '',
              workstationid: event.workstation['id'] ?? '',
              fromDate: event.selectedPeriod['From'] ?? '',
              toDate: event.selectedPeriod['To'] ?? '');

      // Server error
      if (workcentre.toString() == 'Server unreachable' ||
          workstationsListData.toString() == 'Server unreachable' ||
          recent100Records.toString() == 'Server unreachable' ||
          workcentreStatus.toString() == 'Server unreachable' ||
          workstationStatus.toString() == 'Server unreachable' ||
          workcentrePeriodic.toString() == 'Server unreachable' ||
          workstatioPeriodic.toString() == 'Server unreachable' ||
          workcentrewiseEmployeeList.toString() == 'Server unreachable') {
        emit(StatusErrorState('Server unreachable'));
      } else {
        //Workcentre
        List<IsinHouseWorkcentre> workcentreList = workcentre;

        List<WorkstationByWorkcentreId> workstationsList = [];
        //Work stations by workcentre id
        if (workstationsListData != null) {
          workstationsList = workstationsListData;
        }

        List<MachineStatusModel> machineStatus = [];
        if (event.workcentre.isNotEmpty) {
          if (event.workstation.isNotEmpty) {
            if (event.selectedPeriod.isNotEmpty) {
              // Workstation periodic data
              machineStatus = workstatioPeriodic;
              emit(StatusLoadingState(
                  workcentreList,
                  event.workcentre,
                  workstationsList,
                  event.workstation,
                  machineStatus,
                  event.selectedPeriod,
                  event.isButtonClicked,
                  event.monthSelection,
                  workcentrewiseEmployeeList,
                  event.employee));
            } else if (event.monthSelection != '') {
              //Workstation status
              final selectedMonthWorkstationStatus =
                  await MachineStatusRepository()
                      .selectedMonthWorkstationStatus(
                          token: token,
                          workcentreid: event.workcentre['id'],
                          workstationid: event.workstation['id'],
                          date: event.monthSelection);

              machineStatus = selectedMonthWorkstationStatus;
              emit(StatusLoadingState(
                  workcentreList,
                  event.workcentre,
                  workstationsList,
                  event.workstation,
                  machineStatus,
                  event.selectedPeriod,
                  event.isButtonClicked,
                  event.monthSelection,
                  workcentrewiseEmployeeList,
                  event.employee));
            } else {
              //Workstationwise employee list
              final workstationwiseEmployeeList =
                  await MachineStatusRepository().workstationEmployeeList(
                      token: token,
                      workcentreid: event.workcentre['id'],
                      workstationid: event.workstation['id']);

              //Workstation status
              machineStatus = workstationStatus;
              emit(StatusLoadingState(
                  workcentreList,
                  event.workcentre,
                  workstationsList,
                  event.workstation,
                  machineStatus,
                  event.selectedPeriod,
                  event.isButtonClicked,
                  event.monthSelection,
                  workstationwiseEmployeeList,
                  event.employee));

              if (event.employee['id'] != null) {
                //Workstation status by employee id
                final workstationsStatusByEmployee =
                    await MachineStatusRepository().workstationStatusBymployee(
                        token: token,
                        workcentreid: event.workcentre['id'],
                        workstationid: event.workstation['id'],
                        employeeid: event.employee['id']);

                machineStatus = workstationsStatusByEmployee;
                emit(StatusLoadingState(
                    workcentreList,
                    event.workcentre,
                    workstationsList,
                    event.workstation,
                    machineStatus,
                    event.selectedPeriod,
                    event.isButtonClicked,
                    event.monthSelection,
                    workstationwiseEmployeeList,
                    event.employee));
              }
            }
          } else {
            if (event.selectedPeriod.isNotEmpty) {
              // Workcentre periodic data
              machineStatus = workcentrePeriodic;
              emit(StatusLoadingState(
                  workcentreList,
                  event.workcentre,
                  workstationsList,
                  event.workstation,
                  machineStatus,
                  event.selectedPeriod,
                  event.isButtonClicked,
                  event.monthSelection,
                  workcentrewiseEmployeeList,
                  event.employee));
            } else if (event.monthSelection != '') {
              // Workcentre selected month status
              final selectedMonthWorkcentreStatus =
                  await MachineStatusRepository().selectedMonthWorkcentre(
                      token: token,
                      workcentreid: event.workcentre['id'],
                      date: event.monthSelection);

              machineStatus = selectedMonthWorkcentreStatus;
              emit(StatusLoadingState(
                  workcentreList,
                  event.workcentre,
                  workstationsList,
                  event.workstation,
                  machineStatus,
                  event.selectedPeriod,
                  event.isButtonClicked,
                  event.monthSelection,
                  workcentrewiseEmployeeList,
                  event.employee));
            } else if (event.employee['id'] != null) {
              //Workcentre status by employee id
              final workcentreStatusByEmployee = await MachineStatusRepository()
                  .workcentreStatusEmployee(
                      token: token,
                      workcentreid: event.workcentre['id'],
                      employeeid: event.employee['id']);
              machineStatus = workcentreStatusByEmployee;
              emit(StatusLoadingState(
                  workcentreList,
                  event.workcentre,
                  workstationsList,
                  event.workstation,
                  machineStatus,
                  event.selectedPeriod,
                  event.isButtonClicked,
                  event.monthSelection,
                  workcentrewiseEmployeeList,
                  event.employee));
            } else {
              // Workcentre status
              machineStatus = workcentreStatus;
              emit(StatusLoadingState(
                  workcentreList,
                  event.workcentre,
                  workstationsList,
                  event.workstation,
                  machineStatus,
                  event.selectedPeriod,
                  event.isButtonClicked,
                  event.monthSelection,
                  workcentrewiseEmployeeList,
                  event.employee));
            }
          }
        } else {
          //Recent 100 records
          machineStatus = recent100Records;
          emit(StatusLoadingState(
              workcentreList,
              event.workcentre,
              workstationsList,
              event.workstation,
              machineStatus,
              event.selectedPeriod,
              event.isButtonClicked,
              event.monthSelection,
              workcentrewiseEmployeeList ?? [],
              event.employee));
        }
      }
    });
  }
}
