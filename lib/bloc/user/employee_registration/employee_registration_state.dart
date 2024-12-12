// Author : Shital Gayakwad
// Created Date : 3 May 2023
// Description : ERPX_PPC -> Employee registration state

part of 'employee_registration_bloc.dart';

//------------------------------------------------------------------------------------
abstract class EmpRegState {}

class EmpRegInitial extends EmpRegState {}

class SetEmployeeData extends EmpRegState {
  final int selectedIndex;
  final List<String> buttonList;
  SetEmployeeData({
    required this.selectedIndex,
    required this.buttonList,
  });
}

//------------------------------------------------------------------------------------
abstract class EmployeeRegistrationState {}

class EmployeeRegistrationInitial extends EmployeeRegistrationState {}

class SetPersonalData extends EmployeeRegistrationState {
  final String selectedHonorific,
      firstName,
      middleName,
      lastName,
      dateOfBirth,
      qualification,
      mobileNumber,
      familyMember,
      relationWith,
      relativeMobileNo;
  final List<String> honorificlist;
  SetPersonalData({
    required this.selectedHonorific,
    required this.firstName,
    required this.honorificlist,
    required this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.qualification,
    required this.mobileNumber,
    required this.familyMember,
    required this.relationWith,
    required this.relativeMobileNo,
  });
}

class SetEmployeeAddress extends EmployeeRegistrationState {
  final List<CityModel> cityList;
  final List<StateModel> stateList;
  final String currentAddLine1,
      currentAddLine2,
      permanentAddressLine1,
      currentPinCode,
      permanentAddressLine2,
      permanentPincode;
  final Map<String, dynamic> curselectedCity,
      curselectedState,
      perSelectedCity,
      perSelectedState;
  final bool curAddIsSameAsPerAdd;
  SetEmployeeAddress({
    required this.currentAddLine1,
    required this.currentAddLine2,
    required this.cityList,
    required this.stateList,
    required this.curselectedCity,
    required this.currentPinCode,
    required this.curselectedState,
    required this.curAddIsSameAsPerAdd,
    required this.permanentAddressLine1,
    required this.permanentAddressLine2,
    required this.perSelectedCity,
    required this.permanentPincode,
    required this.perSelectedState,
  });
}

class SetEmployeeDocuments extends EmployeeRegistrationState {
  final String bankAcNumber,
      bankName,
      bankIFSCCode,
      employeePF,
      familyPFNumber,
      pancardNumber,
      pancardPath,
      adharcardNumber,
      adharcardpath,
      emailId,
      dateOfJoining,
      empProfilePath;
  SetEmployeeDocuments({
    required this.bankAcNumber,
    required this.bankName,
    required this.bankIFSCCode,
    required this.employeePF,
    required this.familyPFNumber,
    required this.pancardNumber,
    required this.pancardPath,
    required this.adharcardNumber,
    required this.adharcardpath,
    required this.emailId,
    required this.dateOfJoining,
    required this.empProfilePath,
  });
}

class SetEmploymentInfo extends EmployeeRegistrationState {
  final String employeeId, token;
  final Map<String, dynamic> selectedemployeeType,
      selectedDepartment,
      selectedDesignation,
      selectedCompany;
  final List<EmployeeType> employeeType;
  final List<Department> department;
  final List<Designation> designation;
  final List<Company> company;
  SetEmploymentInfo(
      {required this.employeeId,
      required this.selectedemployeeType,
      required this.selectedDepartment,
      required this.selectedDesignation,
      required this.selectedCompany,
      required this.employeeType,
      required this.designation,
      required this.department,
      required this.company,
      required this.token});
}

class RegistrationErrorState extends EmployeeRegistrationState {
  final String errorMessage;
  RegistrationErrorState({required this.errorMessage});
}

class SubmittingEmployeeDetails extends EmployeeRegistrationState {
  SubmittingEmployeeDetails();
}

class SubmittedEmployeeDetails extends EmployeeRegistrationState {
  SubmittedEmployeeDetails();
}
