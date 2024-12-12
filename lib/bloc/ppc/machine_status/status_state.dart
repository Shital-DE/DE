// Author : Shital Gayakwad
// Created Date : 12 April 2023
// Description : ERPX_PPC -> Machine status state

import '../../../services/model/machine/machine_model.dart';
import '../../../services/model/machine/workstation.dart';
import '../../../services/model/registration/machine_registration_model.dart';

abstract class MachineStatusState {}

class MachineInitialState extends MachineStatusState {
  MachineInitialState();
}

class StatusLoadingState extends MachineStatusState {
  final List<IsinHouseWorkcentre> workcentreList;
  final Map<String, dynamic> workcentre, workstation;
  final List<WorkstationByWorkcentreId> workstationsList;
  final List<MachineStatusModel> machineStatus;
  final Map<String, dynamic> selectedPeriod;
  final Map<String, dynamic> isButtonClicked;
  final String monthSelection;
  final List<WorkcentreWiseEmpList> workcentreWiseEmpList;
  final Map<String, dynamic> employee;

  StatusLoadingState(
      this.workcentreList,
      this.workcentre,
      this.workstationsList,
      this.workstation,
      this.machineStatus,
      this.selectedPeriod,
      this.isButtonClicked,
      this.monthSelection,
      this.workcentreWiseEmpList,
      this.employee);
}

class StatusErrorState extends MachineStatusState {
  final String errorMessage;
  StatusErrorState(this.errorMessage);
}
