// Author : Shital Gayakwad
// Description : Employee details update event
// Created Date : 23 August 2024

class UpdateEmployeeDetailsEvent {}

class GetEmployeeDetailsForUpdate extends UpdateEmployeeDetailsEvent {
  int index;
  String selectedEmp;
  GetEmployeeDetailsForUpdate({this.index = 0, this.selectedEmp = ''});
}
