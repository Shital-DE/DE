// Author : Shital Gayakwad
// Created Date : 12 April 2023
// Description : ERPX_PPC -> Machine status Event

abstract class MachineStatusEvent {}

class MachineStatusLoadingEvents extends MachineStatusEvent {
  final Map<String, dynamic> workcentre;
  final Map<String, dynamic> workstation;
  final Map<String, dynamic> selectedPeriod;
  final Map<String, dynamic> isButtonClicked;
  final Map<String, dynamic> employee;
  final String monthSelection;
  MachineStatusLoadingEvents(
      this.workcentre,
      this.workstation,
      this.selectedPeriod,
      this.isButtonClicked,
      this.monthSelection,
      this.employee);
}
