// Author : Shital Gayakwad
// Created Date : 3 May 2023
// Description : ERPX_PPC -> Employee registration bloc

import 'dart:io';
import 'package:bloc/bloc.dart';
import '../../../services/model/common/city_model.dart';
import '../../../services/model/common/state_model.dart';
import '../../../services/model/registration/machine_registration_model.dart';
import '../../../services/model/user/user_registration_model.dart';
import '../../../services/repository/machine/machine_registration_repository.dart';
import '../../../services/repository/user/employee_registration_repository.dart';
import '../../../services/repository/registration/subcontractor_repository.dart';
import '../../../services/session/user_login.dart';
import '../../../services/session/user_registration.dart';
import '../../../utils/constant.dart';
part 'employee_registration_event.dart';
part 'employee_registration_state.dart';

//------------------------------------------------------------------------------------

class EmpRegBloc extends Bloc<EmpRegEvent, EmpRegState> {
  EmpRegBloc() : super(EmpRegInitial()) {
    on<GetEmployeeData>((event, emit) async {
      List<String> buttonList = [
        'Personal Information',
        'Employee Address',
        'Employee Documents',
        'Employment Information'
      ];
      emit(SetEmployeeData(
        selectedIndex: event.selectedIndex,
        buttonList: buttonList,
      ));
    });
  }
}

//------------------------------------------------------------------------------------
class EmployeeRegistrationBloc
    extends Bloc<EmployeeRegistrationEvent, EmployeeRegistrationState> {
  EmployeeRegistrationBloc() : super(EmployeeRegistrationInitial()) {
    on<GetPersonalInfo>((event, emit) async {
      Map<String, dynamic> empPersonalInfo =
          await EmployeeeRegistrationSession.getEmpPersonalInfo();
      emit(SetPersonalData(
        selectedHonorific: event.selectedHonorific != ''
            ? event.selectedHonorific
            : empPersonalInfo['selectedHonorific'] ?? '',
        firstName: event.firstName != ''
            ? event.firstName
            : empPersonalInfo['firstName'] ?? '',
        honorificlist: EmployeeWidgets().honorificlist,
        middleName: event.middleName != ''
            ? event.middleName
            : empPersonalInfo['middleName'] ?? '',
        lastName: event.lastName != ''
            ? event.lastName
            : empPersonalInfo['lastName'] ?? '',
        dateOfBirth: event.dateOfBirth != ''
            ? event.dateOfBirth
            : empPersonalInfo['dateOfBirth'] ?? '',
        qualification: event.qualification != ''
            ? event.qualification
            : empPersonalInfo['qualification'] ?? '',
        mobileNumber: event.mobileNumber != ''
            ? event.mobileNumber
            : empPersonalInfo['mobileNumber'] ?? '',
        familyMember: event.familyMember != ''
            ? event.familyMember
            : empPersonalInfo['relativeName'] ?? '',
        relationWith: event.relationWith != ''
            ? event.relationWith
            : empPersonalInfo['relationWith'] ?? '',
        relativeMobileNo: event.relativeMobileNo != ''
            ? event.relativeMobileNo
            : empPersonalInfo['relativeMobileNumber'] ?? '',
      ));
    });

    on<GetEmployeeAddress>((event, emit) async {
      final saveddata = await UserData.getUserData(); //User data
      String token = saveddata['token'].toString(); //Token
      final city =
          await SubcontractorRepository().city(token: token); // City list
      final state =
          await UserRegistrationRepository().state(token: token); // state list
      if (city.toString() == 'Server unreachable' &&
          state.toString() == 'Server unreachable') {
        emit(RegistrationErrorState(errorMessage: 'Server unreachable'));
      } else {
        List<CityModel> cityList = city;
        List<StateModel> stateList = state;
        Map<String, dynamic> addressInfo =
            await EmployeeeRegistrationSession.getEmployeeAddress();
        emit(SetEmployeeAddress(
          currentAddLine1: event.currentAddLine1 != ''
              ? event.currentAddLine1
              : addressInfo['current_add1'] ?? '',
          currentAddLine2: event.currentAddLine2 != ''
              ? event.currentAddLine2
              : addressInfo['current_add2'] ?? '',
          cityList: cityList,
          stateList: stateList,
          curselectedCity: event.curselectedCity['id'] != null
              ? event.curselectedCity
              : addressInfo['current_city_id'] != null
                  ? {
                      'id': addressInfo['current_city_id'],
                      'name': addressInfo['current_city_name']
                    }
                  : {},
          currentPinCode: event.currentPinCode != ''
              ? event.currentPinCode
              : addressInfo['current_pin_code'] ?? '',
          curselectedState: event.curselectedState['id'] != null
              ? event.curselectedState
              : addressInfo['current_state_id'] != null
                  ? {
                      'id': addressInfo['current_state_id'],
                      'name': addressInfo['current_state_name']
                    }
                  : {},
          curAddIsSameAsPerAdd:
              addressInfo['cur_add_is_same_as_permanent_add'] == null
                  ? event.curAddIsSameAsPerAdd
                  : addressInfo['cur_add_is_same_as_permanent_add']
                          .toString()
                          .toLowerCase() ==
                      'true',
          permanentAddressLine1:
              addressInfo['cur_add_is_same_as_permanent_add'] == null
                  ? (event.curAddIsSameAsPerAdd == true
                      ? event.currentAddLine1
                      : event.permanentAddressLine1)
                  : (addressInfo['cur_add_is_same_as_permanent_add'] == true
                          ? addressInfo['current_add1']
                          : addressInfo['per_add1']) ??
                      '',
          permanentAddressLine2:
              addressInfo['cur_add_is_same_as_permanent_add'] == null
                  ? (event.curAddIsSameAsPerAdd == true
                      ? event.currentAddLine2
                      : event.permanentAddressLine2)
                  : (addressInfo['cur_add_is_same_as_permanent_add'] == true
                          ? addressInfo['current_add2']
                          : addressInfo['per_add2']) ??
                      '',
          perSelectedCity:
              addressInfo['cur_add_is_same_as_permanent_add'] == null
                  ? (event.curAddIsSameAsPerAdd == true
                      ? event.curselectedCity
                      : event.perSelectedCity)
                  : addressInfo['per_city_id'] != null
                      ? (addressInfo['cur_add_is_same_as_permanent_add'] == true
                          ? {
                              'id': addressInfo['current_city_id'],
                              'name': addressInfo['current_city_name']
                            }
                          : {
                              'id': addressInfo['per_city_id'],
                              'name': addressInfo['per_city_name']
                            })
                      : {},
          permanentPincode:
              addressInfo['cur_add_is_same_as_permanent_add'] == null
                  ? (event.curAddIsSameAsPerAdd == true
                      ? event.currentPinCode
                      : event.permanentPincode)
                  : (addressInfo['cur_add_is_same_as_permanent_add'] == true
                          ? addressInfo['current_pin_code']
                          : addressInfo['per_pin_code']) ??
                      '',
          perSelectedState:
              addressInfo['cur_add_is_same_as_permanent_add'] == null
                  ? (event.curAddIsSameAsPerAdd == true
                      ? event.curselectedState
                      : event.perSelectedState)
                  : addressInfo['per_state_id'] != null
                      ? (addressInfo['cur_add_is_same_as_permanent_add'] == true
                          ? {
                              'id': addressInfo['current_state_id'],
                              'name': addressInfo['current_state_name']
                            }
                          : {
                              'id': addressInfo['per_state_id'],
                              'name': addressInfo['per_state_name']
                            })
                      : {},
        ));
      }
    });
    on<GetEmployeeDocuments>((event, emit) async {
      Map<String, dynamic> docInfo =
          await EmployeeeRegistrationSession.getDocumentsInfo();
      emit(SetEmployeeDocuments(
        bankAcNumber: event.bankAcNumber != ''
            ? event.bankAcNumber
            : docInfo['bank_ac_number'] ?? '',
        bankName:
            event.bankName != '' ? event.bankName : docInfo['bank_name'] ?? '',
        bankIFSCCode: event.bankIFSCCode != ''
            ? event.bankIFSCCode
            : docInfo['bank_ifsc_code'] ?? '',
        employeePF: event.employeePF != ''
            ? event.employeePF
            : docInfo['emp_pf_number'] ?? '',
        familyPFNumber: event.familyPFNumber != ''
            ? event.familyPFNumber
            : docInfo['family_pf_number'] ?? '',
        pancardNumber: event.pancardNumber != ''
            ? event.pancardNumber
            : docInfo['pancard_number'] ?? '',
        pancardPath: event.pancardPath != ''
            ? event.pancardPath
            : docInfo['pancard_image_path'] ?? '',
        adharcardNumber: event.adharcardNumber != ''
            ? event.adharcardNumber
            : docInfo['aadharcard_number'] ?? '',
        adharcardpath: event.adharcardpath != ''
            ? event.adharcardpath
            : docInfo['aadharcard_image_path'] ?? '',
        emailId:
            event.emailId != '' ? event.emailId : docInfo['email_id'] ?? '',
        dateOfJoining: event.dateOfJoining != ''
            ? event.dateOfJoining
            : docInfo['date_of_joining'] ?? '',
        empProfilePath: event.empProfilePath != ''
            ? event.empProfilePath
            : docInfo['emp_profile'] ?? '',
      ));
    });
    on<GetEmploymentInfo>((event, emit) async {
      String employeeId = 'Employee id';
      final saveddata = await UserData.getUserData(); //User data
      String token = saveddata['token'].toString(); //Token
      final employeeType = await UserRegistrationRepository()
          .employeeType(token: token); // Employee type

      final department = await UserRegistrationRepository()
          .employeeDepartment(token: token); // Employee department

      final designation = await UserRegistrationRepository()
          .employeeDesignation(token: token); // Employee designation

      //Company name
      final company = await MachineRegistrationRepository()
          .getCompany(token); // Compny list

      //Employee id
      if ((event.selectedemployeeType['code'] != null &&
              event.selectedDepartment['code'] != null) ||
          (event.selectedemployeeType['code'] != '' &&
              event.selectedDepartment['code'] != '')) {
        employeeId = await UserRegistrationRepository().employeeId(
            empType: event.selectedemployeeType['code'] ?? '',
            empDepartment: event.selectedDepartment['code'] ?? '',
            token: token);
      }
      Map<String, dynamic> employmentInfo =
          await EmployeeeRegistrationSession.getEmployementDetails();
      emit(SetEmploymentInfo(
          employeeType: employeeType,
          department: department,
          designation: designation,
          company: company,
          selectedemployeeType: event.selectedemployeeType['id'] != null
              ? event.selectedemployeeType
              : {
                  'id': employmentInfo['type_id'],
                  'code': employmentInfo['type_code'],
                  'description': employmentInfo['type_description']
                },
          selectedDepartment: event.selectedDepartment['id'] != null
              ? event.selectedDepartment
              : {
                  'id': employmentInfo['dept_id'],
                  'code': employmentInfo['dept_code'],
                  'description': employmentInfo['dept_description']
                },
          employeeId: employmentInfo['employee_id'] ??
              (employeeId == 'Employee id' ? '' : employeeId),
          selectedDesignation: event.selectedDesignation['id'] != null
              ? event.selectedDesignation
              : {
                  'id': employmentInfo['desig_id'],
                  'description': employmentInfo['desig_description']
                },
          selectedCompany: event.selectedCompany['id'] != null
              ? event.selectedCompany
              : {
                  'id': employmentInfo['cmpny_id'],
                  'code': employmentInfo['cmpny_code']
                },
          token: token));
    });

    on<SubmitEmployeeDetails>((event, emit) async {
      emit(SubmittingEmployeeDetails());
      if (event.response.length == 32) {
        Map<String, dynamic> empPersonalInfo =
            await EmployeeeRegistrationSession.getEmpPersonalInfo();
        Map<String, dynamic> profileResponse = {},
            panResopnse = {},
            adharRegister = {};

        // Profile registration
        Map<String, dynamic> empDocuments =
            await EmployeeeRegistrationSession.getDocumentsInfo();
        if (empDocuments['emp_profile'].toString() != '') {
          profileResponse = await UserRegistrationRepository()
              .registerEmployeeProfile(documentsData: {
            'emp_name':
                '${empPersonalInfo['firstName']} ${empPersonalInfo['middleName']} ${empPersonalInfo['lastName']}',
            'emp_id': event.response,
            'emp_profile': empDocuments['emp_profile'],
          }, token: event.token);
        }

        // Pan card registration
        if (empDocuments['pancard_image_path'].toString() != '') {
          panResopnse = await UserRegistrationRepository()
              .registerPanCard(documentsData: {
            'emp_name':
                '${empPersonalInfo['firstName']} ${empPersonalInfo['middleName']} ${empPersonalInfo['lastName']}',
            'emp_id': event.response,
            'pancard': empDocuments['pancard_image_path'],
          }, token: event.token);
        }

        // Aadhar card registration
        if (empDocuments['aadharcard_image_path'] != '') {
          adharRegister = await UserRegistrationRepository()
              .registerAadharCard(documentsData: {
            'emp_name':
                '${empPersonalInfo['firstName']} ${empPersonalInfo['middleName']} ${empPersonalInfo['lastName']}',
            'emp_id': event.response,
            'adharcard': empDocuments['aadharcard_image_path'],
          }, token: event.token);
        }

        if (profileResponse['message'] == 'Record inserted successfully.' ||
            panResopnse['message'] == 'Record inserted successfully.' ||
            adharRegister['message'] == 'Record inserted successfully.') {
          final docResponse = await UserRegistrationRepository()
              .documentsRegistration(token: event.token, payload: {
            'id': event.response,
            'profile': profileResponse['id'].toString(),
            'pancard': panResopnse['id'].toString(),
            'adharcard': adharRegister['id'].toString()
          });
          if (docResponse == 'Updated successfully') {
            final profileFile = File(empDocuments['emp_profile']);
            final pancardFile = File(empDocuments['pancard_image_path']);
            final aadharFile = File(empDocuments['aadharcard_image_path']);
            if (await profileFile.exists() &&
                await pancardFile.exists() &&
                await aadharFile.exists()) {
              await profileFile.delete();
              await pancardFile.delete();
              await aadharFile.delete();
            }
            emit(SubmittedEmployeeDetails());
          }
        }
      }
    });
  }
}
