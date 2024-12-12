// Author : Shital Gayakwad
// Created Date : 27 May 2023
// Description : ERPX_PPC -> Registration state
part of 'registration_bloc.dart';

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoadingState extends RegistrationState {
  final Map<String, dynamic> folder;
  final List<Programs> programsList;
  final int selectedIndex;
  final List<String> buttonList, employeeRegistrationbuttonList;
  final List<EmployeeName> employeeName;
  final String empName, token;
  final List<EmployeeRole> employeeRole;
  final List<AllUsers> allusersList;
  final List<AllPrograms> allProgramsList;
  final List<AllFolders> allFoldersList;
  final List<ProgramsInFolder> listOfProgramsInFolder;
  final List<ProgramsAssignedToRole> listOfProgramsAssignedToRole;
  final List<ProgramsNotInFolder> listOfProgramsNotInFolder;
  RegistrationLoadingState(
      {required this.folder,
      required this.programsList,
      required this.selectedIndex,
      required this.buttonList,
      required this.employeeName,
      required this.empName,
      required this.token,
      required this.employeeRole,
      required this.allusersList,
      required this.allProgramsList,
      required this.allFoldersList,
      required this.listOfProgramsInFolder,
      required this.listOfProgramsAssignedToRole,
      required this.listOfProgramsNotInFolder,
      required this.employeeRegistrationbuttonList});
}

class RegistrationErrorState extends RegistrationState {
  final String errorMessage;
  RegistrationErrorState({required this.errorMessage});
}
