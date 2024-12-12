// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Machine registration state

part of 'machine_register_bloc.dart';

abstract class MachineRegisterState {}

class MachineRegisterLoading extends MachineRegisterState {}

class MachineLoaded extends MachineRegisterState {
  final List<IsinHouseWorkcentre> isinhouseWorkcentres;
  final List<ShiftPattern> shiftPatternList;
  final List<Company> companyList;
  final bool isAddButtonClicked;
  final String workcentre;
  final String shiftPatternId;
  final String companyId;
  final String companyCode;
  final String defaultmin;
  final String isinhouse;
  final String token;
  final bool isWorkstationVisible;
  final String workcentreid;
  final int index;
  final List<WorkstationByWorkcentreId> workstationsList;
  final String workstationcode;
  MachineLoaded(
      this.isAddButtonClicked,
      this.isinhouseWorkcentres,
      this.shiftPatternList,
      this.companyList,
      this.workcentre,
      this.shiftPatternId,
      this.companyId,
      this.companyCode,
      this.defaultmin,
      this.isinhouse,
      this.token,
      this.isWorkstationVisible,
      this.workcentreid,
      this.index,
      this.workstationsList,
      this.workstationcode);
}

class MachineErrorState extends MachineRegisterState {
  final String errorMessage;
  MachineErrorState(this.errorMessage);
}
