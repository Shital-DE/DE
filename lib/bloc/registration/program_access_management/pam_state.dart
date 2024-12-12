// Author : Shital Gayakwad
// Created Date : 28 May 2024
// Description : Program access management

import '../../../services/model/registration/program_access_management_model.dart';

abstract class ProgramAccessManagementState {}

class PAMInitialState extends ProgramAccessManagementState {}

class PAMDetailsState extends ProgramAccessManagementState {
  final List<ProgramAccessManagementModel> programAccessManagementData;
  final String token;
  PAMDetailsState(
      {required this.programAccessManagementData, required this.token});
}

class PAMErrorState extends ProgramAccessManagementState {}
