// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Machine registration event

part of 'machine_register_bloc.dart';

abstract class MachineRegisterEvent {}

class MachineScreenLoadingEvent extends MachineRegisterEvent {
  final bool isAddButtonClicked;
  final String workcentre;
  final String shiftPatternId;
  final String companyId;
  final String companyCode;
  final String defaultmin;
  final String isinhouse;
  final bool isWorkstationVisible;
  final String workcentreid;
  final int index;
  final String workstationcode;
  MachineScreenLoadingEvent(
      this.isAddButtonClicked,
      this.workcentre,
      this.shiftPatternId,
      this.companyId,
      this.companyCode,
      this.defaultmin,
      this.isinhouse,
      this.isWorkstationVisible,
      this.workcentreid,
      this.index,
      this.workstationcode);
}
