// Author : Shital Gayakwad
// Description : Employee details update bloc
// Created Date : 23 August 2024

import 'package:bloc/bloc.dart';
import 'package:de/services/model/user/login_model.dart';
import '../../../services/model/common/city_model.dart';
import '../../../services/model/common/state_model.dart';
import '../../../services/repository/registration/subcontractor_repository.dart';
import '../../../services/repository/user/employee_details_update_repo.dart';
import '../../../services/repository/user/employee_registration_repository.dart';
import '../../../services/session/user_login.dart';
import 'update_employee_details_event.dart';
import 'update_employee_details_state.dart';

class UpdateEmployeeDetailsBloc
    extends Bloc<UpdateEmployeeDetailsEvent, UpdateEmployeeDetailsState> {
  UpdateEmployeeDetailsBloc() : super(UpdateEmployeeDetailsInitialState()) {
    on<GetEmployeeDetailsForUpdate>((event, emit) async {
      final saveddata = await UserData.getUserData(); //User data
      List<CityModel> cityList = [];
      List<StateModel> stateList = [];
      List<String> columnNames = [
        'Index',
        'Action',
        'Pan card number',
        'Aadhar card number',
        'Employee Id',
        'Honirific',
        'First name',
        'Middle name',
        'Last name',
        'Date of birth',
        'Qualification',
        'Mobile number',
        'Family member',
        'Relation with family member',
        'Family member mobile number',
        'Current address line 1',
        'Current address line 2',
        'Current city',
        'Current pin code',
        'Current state',
        'Permanent address line 1',
        'Permanent address line 2',
        'Permanent city',
        'Permanent pin code',
        'Permanent state',
        'Bank account number',
        'Bank name',
        'Bank IFSC code',
        'Employee PF number',
        'Employee family PF number',
        'E-mail id',
        'Employee type',
        'Department',
        'Designation',
        'Company',
        'Date of joining',
        'Date of leaving'
      ];

      List<UpdateEmployeeSearchColumns> searchColumnsList = [
        UpdateEmployeeSearchColumns(
            displayValue: 'First name', searchValue: 'firstname'),
        UpdateEmployeeSearchColumns(
            displayValue: 'Middle name', searchValue: 'middlename'),
        UpdateEmployeeSearchColumns(
            displayValue: 'Last name', searchValue: 'lastname'),
      ];

      List<UserDataModel> employeeDataList = await EmployeeDetailsUpdateRepo()
          .allEmployeeDetails(
              token: saveddata['token'].toString(), index: event.index);

      if (event.selectedEmp != '') {
        cityList = await SubcontractorRepository()
            .city(token: saveddata['token'].toString());
        stateList = await UserRegistrationRepository()
            .state(token: saveddata['token'].toString());
      }

      emit(UpdateEmployee(
          employeeDataList: employeeDataList,
          columnNames: columnNames,
          token: saveddata['token'].toString(),
          index: event.index,
          selectedEmp: event.selectedEmp,
          cityList: cityList,
          stateList: stateList,
          loggedInUser: saveddata['data'][0]['id'].toString(),
          searchColumnsList: searchColumnsList));
    });
  }
}
