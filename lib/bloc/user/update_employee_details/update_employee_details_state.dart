// Author : Shital Gayakwad
// Description : Employee details update state
// Created Date : 23 August 2024

import '../../../services/model/common/city_model.dart';
import '../../../services/model/common/state_model.dart';
import '../../../services/model/user/login_model.dart';

class UpdateEmployeeDetailsState {}

class UpdateEmployeeDetailsInitialState extends UpdateEmployeeDetailsState {}

class UpdateEmployee extends UpdateEmployeeDetailsState {
  List<UserDataModel> employeeDataList;
  List<CityModel> cityList;
  List<StateModel> stateList;
  List<String> columnNames;
  String token, selectedEmp, loggedInUser;
  int index;
  List<UpdateEmployeeSearchColumns> searchColumnsList;
  UpdateEmployee(
      {required this.employeeDataList,
      required this.columnNames,
      required this.token,
      required this.index,
      required this.selectedEmp,
      required this.cityList,
      required this.stateList,
      required this.loggedInUser,
      required this.searchColumnsList});
}
