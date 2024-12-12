// Author : Shital Gayakwad
// Created Date : 27 May 2023
// Description : ERPX_PPC -> Registration bloc

import 'package:bloc/bloc.dart';
import '../../services/model/dashboard/dashboard_model.dart';
import '../../services/model/user/user_model.dart';
import '../../services/repository/dashboard/dashboard_repository.dart';
import '../../services/repository/user/user_repository.dart';
import '../../services/session/user_login.dart';
part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationInitialEvent>((event, emit) async {
      List<String> buttonList = [
        'Register role',
        'Assign user role',
        'Register program',
        'Register folder',
        'Add program to folder',
        'Assign program to role'
      ];

      List<String> employeeRegistrationbuttonList = [
        'Employee registration',
        'Assign login credentials',
        'Update employee details'
      ];

      List<EmployeeRole> employeeRole = [];
      List<AllUsers> allusersList = [];
      List<AllPrograms> allProgramsList = [];
      List<AllFolders> allFoldersList = [];
      List<ProgramsInFolder> listOfProgramsInFolder = [];
      List<ProgramsAssignedToRole> listOfProgramsAssignedToRole = [];
      List<ProgramsNotInFolder> listOfProgramsNotInFolder = [];
      final data = await UserData.getUserData(); // token and userdata

      //  Programs list assigned to users
      List<Programs> programsList = await DashboardRepository().programs(
          token: data['token'].toString(),
          folderId: event.folder['id'].toString(),
          username: data['loginCredentials'][0].toString(),
          password: data['loginCredentials'][1].toString());

      // Employee list with employee full name
      List<EmployeeName> employeeName = await UserRepository()
          .employeeFullName(token: data['token'].toString());

      // Employee roles list
      final userRoledata =
          await UserRepository().employeeRole(token: data['token'].toString());

      // Users list
      final allusers =
          await UserRepository().user(token: data['token'].toString());

      // Programs list
      final allPrograms =
          await UserRepository().allPrograms(token: data['token'].toString());

      //Folders list
      final allFolders =
          await UserRepository().allFolders(token: data['token'].toString());

      // Programs in folder
      final programsInFolder = await UserRepository()
          .programsInFolder(token: data['token'].toString());

      // Programs assigned to role
      final programsAssignedToRole = await UserRepository()
          .programsAssignedToRole(token: data['token'].toString());

      // Programs which is not in folder
      final programsNotInFolder = await UserRepository()
          .programsNotInFolder(token: data['token'].toString());

      if (userRoledata.toString() == 'Server unreachable') {
        emit(RegistrationErrorState(errorMessage: 'Server unreachable'));
      } else {
        employeeRole = userRoledata;
        allusersList = allusers;
        allProgramsList = allPrograms;
        allFoldersList = allFolders;
        listOfProgramsInFolder = programsInFolder;
        listOfProgramsAssignedToRole = programsAssignedToRole;
        listOfProgramsNotInFolder = programsNotInFolder;
      }
      emit(RegistrationLoadingState(
          folder: event.folder,
          programsList: programsList,
          selectedIndex: event.selectedIndex,
          buttonList: buttonList,
          employeeName: employeeName,
          empName:
              '${data['data'][0]['firstname']} ${data['data'][0]['lastname']}',
          token: data['token'].toString(),
          employeeRole: employeeRole,
          allusersList: allusersList,
          allProgramsList: allProgramsList,
          allFoldersList: allFoldersList,
          listOfProgramsInFolder: listOfProgramsInFolder,
          listOfProgramsAssignedToRole: listOfProgramsAssignedToRole,
          listOfProgramsNotInFolder: listOfProgramsNotInFolder,
          employeeRegistrationbuttonList: employeeRegistrationbuttonList));
    });
  }
}
