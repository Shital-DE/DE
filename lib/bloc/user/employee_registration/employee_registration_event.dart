// Author : Shital Gayakwad
// Created Date : 3 May 2023
// Description : ERPX_PPC -> Employee registration event

part of 'employee_registration_bloc.dart';

//------------------------------------------------------------------------------------
abstract class EmpRegEvent {}

class GetEmployeeData extends EmpRegEvent {
  final int selectedIndex;
  GetEmployeeData({
    this.selectedIndex = 0,
  });
}

//------------------------------------------------------------------------------------
abstract class EmployeeRegistrationEvent {}

class GetPersonalInfo extends EmployeeRegistrationEvent {
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
  GetPersonalInfo({
    this.selectedHonorific = '',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.dateOfBirth = '',
    this.qualification = '',
    this.mobileNumber = '',
    this.familyMember = '',
    this.relationWith = '',
    this.relativeMobileNo = '',
  });
}

class GetEmployeeAddress extends EmployeeRegistrationEvent {
  final String currentAddLine1,
      currentAddLine2,
      currentPinCode,
      permanentAddressLine1,
      permanentAddressLine2,
      permanentPincode;
  final Map<String, dynamic> curselectedCity,
      curselectedState,
      perSelectedCity,
      perSelectedState;
  final bool curAddIsSameAsPerAdd;
  GetEmployeeAddress({
    this.currentAddLine1 = '',
    this.currentAddLine2 = '',
    this.curselectedCity = const {},
    this.currentPinCode = '',
    this.curselectedState = const {},
    this.curAddIsSameAsPerAdd = false,
    this.permanentAddressLine1 = '',
    this.permanentAddressLine2 = '',
    this.perSelectedCity = const {},
    this.permanentPincode = '',
    this.perSelectedState = const {},
  });
}

class GetEmployeeDocuments extends EmployeeRegistrationEvent {
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
  GetEmployeeDocuments({
    this.bankAcNumber = '',
    this.bankName = '',
    this.bankIFSCCode = '',
    this.employeePF = '',
    this.familyPFNumber = '',
    this.pancardNumber = '',
    this.pancardPath = '',
    this.adharcardNumber = '',
    this.adharcardpath = '',
    this.emailId = '',
    this.dateOfJoining = '',
    this.empProfilePath = '',
  });
}

class GetEmploymentInfo extends EmployeeRegistrationEvent {
  final String employeeId;
  final Map<String, dynamic> selectedemployeeType,
      selectedDepartment,
      selectedDesignation,
      selectedCompany;
  GetEmploymentInfo(
      {this.employeeId = '',
      this.selectedemployeeType = const {},
      this.selectedDepartment = const {},
      this.selectedDesignation = const {},
      this.selectedCompany = const {}});
}

class SubmitEmployeeDetails extends EmployeeRegistrationEvent {
  final String response, token;
  SubmitEmployeeDetails({required this.response, required this.token});
}
