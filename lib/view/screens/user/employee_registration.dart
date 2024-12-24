// Author : Shital Gayakwad
// Description : Employee registration
// Created Date : 3 May 2023

// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../bloc/user/employee_registration/employee_registration_bloc.dart';
import '../../../services/model/common/city_model.dart';
import '../../../services/model/common/state_model.dart';
import '../../../services/model/registration/machine_registration_model.dart';
import '../../../services/model/user/user_registration_model.dart';
import '../../../services/repository/user/employee_registration_repository.dart';
import '../../../services/session/user_registration.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../../utils/constant.dart';
import '../../../utils/responsive.dart';
import '../../widgets/appbar.dart';
import '../../widgets/image_utility.dart';

class EmployeeRegistration extends StatelessWidget {
  const EmployeeRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = BlocProvider.of<EmpRegBloc>(context);
    provider.add(GetEmployeeData());
    final blocProvider = BlocProvider.of<EmployeeRegistrationBloc>(context);
    return Scaffold(
        appBar: CustomAppbar()
            .appbar(context: context, title: 'Employee registration'),
        body: MakeMeResponsiveScreen(
          horixontaltab: employeeRegister(
              containerWidth: 400,
              conHeight: 50,
              conMargin: 400,
              topMargin: 10,
              blocProvider: blocProvider,
              provider: provider,
              buttonMargin: 100),
          verticaltab: employeeRegister(
              containerWidth: 400,
              conHeight: 50,
              conMargin: 200,
              topMargin: 10,
              blocProvider: blocProvider,
              provider: provider,
              buttonMargin: 0),
          windows: employeeRegister(
              containerWidth: 400,
              conHeight: 50,
              conMargin: 400,
              topMargin: 10,
              blocProvider: blocProvider,
              provider: provider,
              buttonMargin: 100),
          linux: QuickFixUi.notVisible(),
          mobile: QuickFixUi.notVisible(),
        ));
  }

  employeeRegister(
      {required double containerWidth,
      required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider,
      required EmpRegBloc provider,
      required double buttonMargin}) {
    return Center(
      child: SizedBox(
        width: containerWidth + containerWidth + containerWidth,
        child: ListView(
          children: [
            buttonList(
                topMargin: topMargin,
                provider: provider,
                blocProvider: blocProvider,
                buttonMargin: buttonMargin),

            // Employee's personal information
            honorific(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            firstName(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            middleName(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            lastName(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            dateOfBirth(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            qualification(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            mobileNumber(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            familyMember(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            relationWith(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            relativeMobileNumber(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            savePersonalInformation(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider,
                provider: provider),

            // Employee address
            currentAddressHeader(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin),
            currentAddressLine1(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            currentAddressLine2(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            currentCity(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            currentPinCode(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            currentState(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            permanentAddressHeader(conMargin: conMargin, topMargin: topMargin),
            curAddIsSameAsPerAdd(
                conMargin: conMargin, blocProvider: blocProvider),
            permanentAddressLine1(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            permanentAddressLine2(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            permanentCity(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            permanentPincode(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            permanentState(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            saveAddress(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider,
                provider: provider),

            // // Employee documents
            bankAccountNumber(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            bankName(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            bankIFSCCode(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            employeePF(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            familyPFnumber(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            pancardDetails(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                containerWidth: containerWidth,
                blocProvider: blocProvider),
            adharcardDetails(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                containerWidth: containerWidth,
                blocProvider: blocProvider),
            emailId(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            dateOfJoining(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            profile(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            saveDocuments(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                provider: provider,
                blocProvider: blocProvider),

            // // Employment details
            employeeId(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin),
            employeeType(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            department(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            designation(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            selectedCompany(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                blocProvider: blocProvider),
            // register employee
            registerEmployee(
                conHeight: conHeight,
                conMargin: conMargin,
                topMargin: topMargin,
                provider: provider,
                blocProvider: blocProvider),
            verticalSpace(),
            verticalSpace(),
            verticalSpace(),
          ],
        ),
      ),
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> selectedCompany(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 3) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmploymentInfo) {
                return Container(
                  height: conHeight + 10,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<Company>(
                    items: innerState.company,
                    itemAsString: (item) => item.code.toString(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText:
                                innerState.selectedCompany['code'] ?? 'Company',
                            hintStyle: TextStyle(
                                fontWeight:
                                    innerState.selectedCompany['code'] == null
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                color:
                                    innerState.selectedCompany['code'] == null
                                        ? Theme.of(context).hintColor
                                        : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmploymentInfo(
                          selectedemployeeType: innerState.selectedemployeeType,
                          selectedDepartment: innerState.selectedDepartment,
                          selectedDesignation: innerState.selectedDesignation,
                          selectedCompany: {
                            'id': value!.id.toString(),
                            'code': value.code.toString(),
                          }));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> designation(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 3) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmploymentInfo) {
                return Container(
                  height: conHeight + 10,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<Designation>(
                    items: innerState.designation,
                    itemAsString: (item) => item.description.toString(),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(fontSize: 18),
                          onTap: () {},
                        )),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText:
                                innerState.selectedDesignation['description'] ??
                                    'Designation',
                            hintStyle: TextStyle(
                                fontWeight: innerState.selectedDesignation[
                                            'description'] ==
                                        null
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: innerState.selectedDesignation[
                                            'description'] ==
                                        null
                                    ? Theme.of(context).hintColor
                                    : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmploymentInfo(
                          selectedemployeeType: innerState.selectedemployeeType,
                          selectedDepartment: innerState.selectedDepartment,
                          selectedDesignation: {
                            'id': value!.id.toString(),
                            'description': value.description.toString()
                          },
                          selectedCompany: innerState.selectedCompany));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> department(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 3) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmploymentInfo) {
                return Container(
                  height: conHeight + 10,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<Department>(
                    items: innerState.department,
                    itemAsString: (item) => item.description.toString(),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(fontSize: 18),
                          onTap: () {},
                        )),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText:
                                innerState.selectedDepartment['description'] ??
                                    'Department',
                            hintStyle: TextStyle(
                                fontWeight: innerState.selectedDepartment[
                                            'description'] ==
                                        null
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: innerState.selectedDepartment[
                                            'description'] ==
                                        null
                                    ? Theme.of(context).hintColor
                                    : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmploymentInfo(
                          selectedemployeeType: innerState.selectedemployeeType,
                          selectedDepartment: {
                            'id': value!.id.toString(),
                            'code': value.code.toString(),
                            'description': value.description.toString()
                          },
                          selectedDesignation: innerState.selectedDesignation,
                          selectedCompany: innerState.selectedCompany));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> employeeType(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 3) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmploymentInfo) {
                return Container(
                  height: conHeight + 10,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<EmployeeType>(
                    items: innerState.employeeType,
                    itemAsString: (item) => item.description.toString(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText: innerState
                                    .selectedemployeeType['description'] ??
                                'Employee type',
                            hintStyle: TextStyle(
                                fontWeight: innerState.selectedemployeeType[
                                            'description'] ==
                                        null
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: innerState.selectedemployeeType[
                                            'description'] ==
                                        null
                                    ? Theme.of(context).hintColor
                                    : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmploymentInfo(
                          selectedemployeeType: {
                            'id': value!.id.toString(),
                            'code': value.code.toString(),
                            'description': value.description.toString()
                          },
                          selectedDepartment: innerState.selectedDepartment,
                          selectedDesignation: innerState.selectedDesignation,
                          selectedCompany: innerState.selectedCompany));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> employeeId(
      {required double conHeight,
      required double conMargin,
      required double topMargin}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 3) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmploymentInfo) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 3),
                  child: TextField(
                    controller:
                        TextEditingController(text: innerState.employeeId),
                    readOnly: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onChanged: (value) {},
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> registerEmployee({
    required double conHeight,
    required double conMargin,
    required double topMargin,
    required EmpRegBloc provider,
    required EmployeeRegistrationBloc blocProvider,
  }) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 3) {
          return BlocConsumer<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            listener: (context, state) async {
              if (state is SubmittedEmployeeDetails) {
                Navigator.of(context).pop();
                QuickFixUi.successMessage('Inserted successfully', context);
                EmployeeeRegistrationSession
                    .removeEmployeeRegistrationSession();
                registrationSuccessDialog(context, provider, blocProvider);
              }
            },
            builder: (context, innerState) {
              if (innerState is SetEmploymentInfo) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton.icon(
                          onPressed: () async {
                            Map<String, dynamic> empPersonalInfo =
                                await EmployeeeRegistrationSession
                                    .getEmpPersonalInfo();
                            Map<String, dynamic> addressInfo =
                                await EmployeeeRegistrationSession
                                    .getEmployeeAddress();
                            Map<String, dynamic> docInfo =
                                await EmployeeeRegistrationSession
                                    .getDocumentsInfo();

                            if (empPersonalInfo.isEmpty) {
                              return QuickFixUi.errorMessage(
                                  'Personal details not found', context);
                            } else if (addressInfo.isEmpty) {
                              return QuickFixUi.errorMessage(
                                  'Address details not found', context);
                            } else if (docInfo.isEmpty) {
                              return QuickFixUi.errorMessage(
                                  'Document details not found', context);
                            } else if (innerState.selectedemployeeType['id'] ==
                                null) {
                              return QuickFixUi.errorMessage(
                                  'Please select employee type', context);
                            } else if (innerState.selectedDepartment['id'] ==
                                null) {
                              return QuickFixUi.errorMessage(
                                  'Please select department', context);
                            } else if (innerState.selectedDesignation['id'] ==
                                null) {
                              return QuickFixUi.errorMessage(
                                  'Please select designation', context);
                            } else if (innerState.selectedCompany['id'] ==
                                null) {
                              return QuickFixUi.errorMessage(
                                  'Please select company', context);
                            } else {
                              EmployeeeRegistrationSession
                                  .employementInformationSession(
                                      employmentInfo: {
                                    'employee_id': innerState.employeeId,
                                    'type_id':
                                        innerState.selectedemployeeType['id'],
                                    'type_code':
                                        innerState.selectedemployeeType['code'],
                                    'type_description': innerState
                                        .selectedemployeeType['description'],
                                    'dept_id':
                                        innerState.selectedDepartment['id'],
                                    'dept_code':
                                        innerState.selectedDepartment['code'],
                                    'dept_description': innerState
                                        .selectedDepartment['description'],
                                    'desig_id':
                                        innerState.selectedDesignation['id'],
                                    'desig_description': innerState
                                        .selectedDesignation['description'],
                                    'cmpny_id':
                                        innerState.selectedCompany['id'],
                                    'cmpny_code':
                                        innerState.selectedCompany['code'],
                                  }).then((value) {
                                registrationConfirmationDialog(
                                    context, innerState, blocProvider);
                              });
                            }
                          },
                          icon: const Icon(Icons.save_alt_sharp),
                          label: const Text('SUBMIT')),
                      FilledButton.icon(
                          onPressed: () {
                            EmployeeeRegistrationSession
                                .removeEmployeeRegistrationSession();
                            provider.add(GetEmployeeData(selectedIndex: 0));
                            blocProvider.add(GetPersonalInfo());
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text('CLEAR'))
                    ],
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  Future<dynamic> registrationSuccessDialog(BuildContext context,
      EmpRegBloc provider, EmployeeRegistrationBloc blocProvider) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'The employee registration process has been completed successfully.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    provider.add(GetEmployeeData(selectedIndex: 0));
                    blocProvider.add(GetPersonalInfo());
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> registrationConfirmationDialog(BuildContext context,
      SetEmploymentInfo innerState, EmployeeRegistrationBloc blocProvider) {
    return showDialog(
      context: context,
      builder: (newcontext) {
        return AlertDialog(
          content: const Text(
            'Are you completely sure about \nproceeding with the registration?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            FilledButton(
                onPressed: () async {
                  try {
                    Navigator.of(newcontext).pop();
                    QuickFixUi().showProcessing(context: context);
                    String response =
                        await UserRegistrationRepository().registerEmployee(
                      token: innerState.token,
                    );

                    if (response.length == 32) {
                      blocProvider.add(SubmitEmployeeDetails(
                          response: response, token: innerState.token));
                    } else {
                      if (response.toString() ==
                          'duplicate key value violates unique constraint "employee_idx"') {
                        Navigator.of(context).pop();
                        QuickFixUi.errorMessage(
                            'This user is already registered', context);
                      } else {
                        Navigator.of(context).pop();
                        QuickFixUi.errorMessage(response, context);
                      }
                    }
                  } catch (e) {
                    //
                  }
                },
                child: const Text('Yes')),
            FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'))
          ],
        );
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> profile(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin + 250, top: topMargin),
                  child: innerState.empProfilePath == ''
                      ? ElevatedButton.icon(
                          onPressed: () {
                            uploadProfilePicture(
                                context: context,
                                blocProvider: blocProvider,
                                state: innerState);
                          },
                          icon: const Icon(Icons.account_circle),
                          label: const Text('Upload'))
                      : IconButton(
                          onPressed: () {
                            showProfile(
                                context: context,
                                state: innerState,
                                blocProvider: blocProvider);
                          },
                          icon: const Icon(
                            Icons.remove_red_eye,
                            size: 35,
                            color: AppColors.appTheme,
                          )),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  Future<dynamic> showProfile(
      {required BuildContext context,
      required SetEmployeeDocuments state,
      required EmployeeRegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    final file = File(state.empProfilePath);

                    if (await file.exists()) {
                      await file.delete();
                      EmployeeeRegistrationSession.registrationDocumentSession(
                          docInfo: {
                            'bank_ac_number': state.bankAcNumber,
                            'bank_name': state.bankName,
                            'bank_ifsc_code': state.bankIFSCCode,
                            'emp_pf_number': state.employeePF,
                            'family_pf_number': state.familyPFNumber,
                            'pancard_number': state.pancardNumber,
                            'pancard_image_path': state.pancardPath,
                            'aadharcard_number': state.adharcardNumber,
                            'aadharcard_image_path': state.adharcardpath,
                            'email_id': state.emailId,
                            'date_of_joining': state.dateOfJoining,
                            'emp_profile': '',
                          });
                      blocProvider.add(GetEmployeeDocuments(
                          bankAcNumber: state.bankAcNumber,
                          bankName: state.bankName,
                          bankIFSCCode: state.bankIFSCCode,
                          employeePF: state.employeePF,
                          familyPFNumber: state.familyPFNumber,
                          pancardNumber: state.pancardNumber,
                          pancardPath: state.pancardPath,
                          adharcardNumber: state.adharcardNumber,
                          adharcardpath: state.adharcardpath,
                          emailId: state.emailId,
                          dateOfJoining: state.dateOfJoining,
                          empProfilePath: ''));

                      Navigator.of(context).pop();
                      return QuickFixUi.successMessage(
                          'File deleted successfully', context);
                    } else {
                      Navigator.of(context).pop();
                      return QuickFixUi.errorMessage(
                          'Error occurred while deleting an file', context);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 35,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.blue,
                    size: 36,
                  ))
            ],
          ),
          content: Image(
              image: FileImage(File(state.empProfilePath)), key: UniqueKey()),
        );
      },
    );
  }

  Future<dynamic> uploadProfilePicture(
      {required BuildContext context,
      required EmployeeRegistrationBloc blocProvider,
      required SetEmployeeDocuments state}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final picker = ImagePicker();
          return AlertDialog(
            content: SizedBox(
              height: 110,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            await uploadProfile(
                                pickedFile: pickedFile,
                                context: context,
                                blocProvider: blocProvider,
                                state: state);
                          },
                          icon: Icon(
                            Icons.image_rounded,
                            size: 45,
                            color: Colors.pink[400],
                          )),
                      horizontalSpace(),
                      IconButton(
                          onPressed: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.camera);
                            await uploadProfile(
                                pickedFile: pickedFile,
                                context: context,
                                blocProvider: blocProvider,
                                state: state);
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            size: 45,
                            color: Colors.pink[400],
                          ))
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadProfile(
      {required XFile? pickedFile,
      required BuildContext context,
      required EmployeeRegistrationBloc blocProvider,
      required SetEmployeeDocuments state}) async {
    try {
      if (pickedFile != null) {
        File? croppedfile = await ImageUtility()
            .cropImage(pickedFile: pickedFile, context: context);
        final directory = await getApplicationDocumentsDirectory();
        final croppedImagePath =
            "${directory.path}/${DateTime.now().microsecondsSinceEpoch.toString()}.jpg";
        await croppedfile!.copy(croppedImagePath);
        blocProvider.add(GetEmployeeDocuments(
            bankAcNumber: state.bankAcNumber,
            bankName: state.bankName,
            bankIFSCCode: state.bankIFSCCode,
            employeePF: state.employeePF,
            familyPFNumber: state.familyPFNumber,
            pancardNumber: state.pancardNumber,
            pancardPath: state.pancardPath,
            adharcardNumber: state.adharcardNumber,
            adharcardpath: state.adharcardpath,
            emailId: state.emailId,
            dateOfJoining: state.dateOfJoining,
            empProfilePath: croppedImagePath));
        Navigator.of(context).pop();
      }
    } catch (e) {
      return;
    }
  }

  BlocBuilder<EmpRegBloc, EmpRegState> dateOfJoining(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    controller: TextEditingController(
                        text: innerState.dateOfJoining
                            .split('-')
                            .reversed
                            .join('-')),
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: 'Joining date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () async {
                      DateTime? pickedDate =
                          await QuickFixUi().dateTimePicker(context);
                      if (pickedDate != null) {
                        blocProvider.add(GetEmployeeDocuments(
                          bankAcNumber: innerState.bankAcNumber,
                          bankName: innerState.bankName,
                          bankIFSCCode: innerState.bankIFSCCode,
                          employeePF: innerState.employeePF,
                          familyPFNumber: innerState.familyPFNumber,
                          pancardNumber: innerState.pancardNumber,
                          pancardPath: innerState.pancardPath,
                          adharcardNumber: innerState.adharcardNumber,
                          adharcardpath: innerState.adharcardpath,
                          emailId: innerState.emailId,
                          dateOfJoining:
                              pickedDate.toLocal().toString().substring(0, 10),
                          empProfilePath: innerState.empProfilePath,
                        ));
                      }
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> emailId(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.emailId == ''
                            ? 'E-mail id'
                            : innerState.emailId,
                        hintStyle: TextStyle(
                            fontWeight: innerState.emailId == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.emailId == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: '',
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: value.toString(),
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> adharcardDetails(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required double containerWidth,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(builder: (context, outerState) {
      if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
        return BlocBuilder<EmployeeRegistrationBloc, EmployeeRegistrationState>(
          builder: (context, innerState) {
            if (innerState is SetEmployeeDocuments) {
              return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: Row(children: [
                    SizedBox(
                      width: containerWidth - 55,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: innerState.adharcardNumber == ''
                                ? 'Aadhar card number'
                                : innerState.adharcardNumber,
                            hintStyle: TextStyle(
                                fontWeight: innerState.adharcardNumber == ''
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: innerState.adharcardNumber == ''
                                    ? Theme.of(context).hintColor
                                    : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0))),
                        keyboardType: TextInputType.number,
                        onTap: () {
                          blocProvider.add(GetEmployeeDocuments(
                            bankAcNumber: innerState.bankAcNumber,
                            bankName: innerState.bankName,
                            bankIFSCCode: innerState.bankIFSCCode,
                            employeePF: innerState.employeePF,
                            familyPFNumber: innerState.familyPFNumber,
                            pancardNumber: innerState.pancardNumber,
                            pancardPath: innerState.pancardPath,
                            adharcardNumber: '',
                            adharcardpath: innerState.adharcardpath,
                            emailId: innerState.emailId,
                            dateOfJoining: innerState.dateOfJoining,
                            empProfilePath: innerState.empProfilePath,
                          ));
                        },
                        onChanged: (value) {
                          blocProvider.add(GetEmployeeDocuments(
                            bankAcNumber: innerState.bankAcNumber,
                            bankName: innerState.bankName,
                            bankIFSCCode: innerState.bankIFSCCode,
                            employeePF: innerState.employeePF,
                            familyPFNumber: innerState.familyPFNumber,
                            pancardNumber: innerState.pancardNumber,
                            pancardPath: innerState.pancardPath,
                            adharcardNumber: value.toString(),
                            adharcardpath: innerState.adharcardpath,
                            emailId: innerState.emailId,
                            dateOfJoining: innerState.dateOfJoining,
                            empProfilePath: innerState.empProfilePath,
                          ));
                        },
                      ),
                    ),
                    innerState.adharcardpath == ''
                        ? IconButton(
                            onPressed: () {
                              adharcardPhotoUpload(
                                  context: context,
                                  state: innerState,
                                  blocProvider: blocProvider);
                            },
                            icon: const Icon(
                              Icons.attach_file,
                              size: 35,
                              color: AppColors.appTheme,
                            ))
                        : IconButton(
                            onPressed: () {
                              showAdharcard(
                                  context: context,
                                  state: innerState,
                                  blocProvider: blocProvider);
                            },
                            icon: const Icon(
                              Icons.remove_red_eye,
                              size: 35,
                              color: AppColors.appTheme,
                            ))
                  ]));
            } else {
              return const Stack();
            }
          },
        );
      } else {
        return const Stack();
      }
    });
  }

  Future<dynamic> adharcardPhotoUpload(
      {required BuildContext context,
      required SetEmployeeDocuments state,
      required EmployeeRegistrationBloc blocProvider}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final picker = ImagePicker();
          return AlertDialog(
            content: SizedBox(
              height: 110,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            await uploadAdharcard(
                                pickedFile: pickedFile,
                                context: context,
                                state: state,
                                blocProvider: blocProvider);
                          },
                          icon: Icon(
                            Icons.image_rounded,
                            size: 45,
                            color: Colors.pink[400],
                          )),
                      horizontalSpace(),
                      IconButton(
                          onPressed: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.camera);
                            await uploadAdharcard(
                                pickedFile: pickedFile,
                                context: context,
                                state: state,
                                blocProvider: blocProvider);
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            size: 45,
                            color: Colors.pink[400],
                          ))
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'))
                ],
              ),
            ),
          );
        });
  }

  SizedBox horizontalSpace() {
    return const SizedBox(
      width: 10,
    );
  }

  Future<dynamic> showAdharcard(
      {required BuildContext context,
      required SetEmployeeDocuments state,
      required EmployeeRegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    final file = File(state.adharcardpath);
                    if (await file.exists()) {
                      await file.delete();
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: state.bankAcNumber,
                        bankName: state.bankName,
                        bankIFSCCode: state.bankIFSCCode,
                        employeePF: state.employeePF,
                        familyPFNumber: state.familyPFNumber,
                        pancardNumber: state.pancardNumber,
                        pancardPath: state.pancardPath,
                        adharcardNumber: state.adharcardNumber,
                        adharcardpath: '',
                        emailId: state.emailId,
                        dateOfJoining: state.dateOfJoining,
                        empProfilePath: state.empProfilePath,
                      ));
                      EmployeeeRegistrationSession.registrationDocumentSession(
                          docInfo: {
                            'bank_ac_number': state.bankAcNumber,
                            'bank_name': state.bankName,
                            'bank_ifsc_code': state.bankIFSCCode,
                            'emp_pf_number': state.employeePF,
                            'family_pf_number': state.familyPFNumber,
                            'pancard_number': state.pancardNumber,
                            'pancard_image_path': state.pancardPath,
                            'aadharcard_number': state.adharcardNumber,
                            'aadharcard_image_path': '',
                            'email_id': state.emailId,
                            'date_of_joining': state.dateOfJoining,
                            'emp_profile': state.empProfilePath,
                          });
                      Navigator.of(context).pop();
                      return QuickFixUi.successMessage(
                          'File deleted successfully', context);
                    } else {
                      Navigator.of(context).pop();
                      return QuickFixUi.errorMessage(
                          'Error occurred while deleting an file', context);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 35,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.blue,
                    size: 36,
                  ))
            ],
          ),
          content: Image(image: FileImage(File(state.adharcardpath))),
        );
      },
    );
  }

  Future<void> uploadAdharcard(
      {required XFile? pickedFile,
      required BuildContext context,
      required SetEmployeeDocuments state,
      required EmployeeRegistrationBloc blocProvider}) async {
    try {
      if (pickedFile != null) {
        File? croppedfile = await ImageUtility()
            .cropImage(pickedFile: pickedFile, context: context);
        final directory = await getApplicationDocumentsDirectory();
        final croppedImagePath =
            "${directory.path}/${DateTime.now().microsecondsSinceEpoch}.jpg";
        await croppedfile!.copy(croppedImagePath);

        blocProvider.add(GetEmployeeDocuments(
          bankAcNumber: state.bankAcNumber,
          bankName: state.bankName,
          bankIFSCCode: state.bankIFSCCode,
          employeePF: state.employeePF,
          familyPFNumber: state.familyPFNumber,
          pancardNumber: state.pancardNumber,
          pancardPath: state.pancardPath,
          adharcardNumber: state.adharcardNumber,
          adharcardpath: croppedImagePath,
          emailId: state.emailId,
          dateOfJoining: state.dateOfJoining,
          empProfilePath: state.empProfilePath,
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      return;
    }
  }

  BlocBuilder<EmpRegBloc, EmpRegState> pancardDetails(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required double containerWidth,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: Row(
                    children: [
                      SizedBox(
                        width: containerWidth - 55,
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: innerState.pancardNumber == ''
                                  ? 'Pan card number'
                                  : innerState.pancardNumber,
                              hintStyle: TextStyle(
                                  fontWeight: innerState.pancardNumber == ''
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                  color: innerState.pancardNumber == ''
                                      ? Theme.of(context).hintColor
                                      : AppColors.blackColor),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          onTap: () {
                            blocProvider.add(GetEmployeeDocuments(
                              bankAcNumber: innerState.bankAcNumber,
                              bankName: innerState.bankName,
                              bankIFSCCode: innerState.bankIFSCCode,
                              employeePF: innerState.employeePF,
                              familyPFNumber: innerState.familyPFNumber,
                              pancardNumber: '',
                              pancardPath: innerState.pancardPath,
                              adharcardNumber: innerState.adharcardNumber,
                              adharcardpath: innerState.adharcardpath,
                              emailId: innerState.emailId,
                              dateOfJoining: innerState.dateOfJoining,
                              empProfilePath: innerState.empProfilePath,
                            ));
                          },
                          onChanged: (value) {
                            blocProvider.add(GetEmployeeDocuments(
                              bankAcNumber: innerState.bankAcNumber,
                              bankName: innerState.bankName,
                              bankIFSCCode: innerState.bankIFSCCode,
                              employeePF: innerState.employeePF,
                              familyPFNumber: innerState.familyPFNumber,
                              pancardNumber: value.toString(),
                              pancardPath: innerState.pancardPath,
                              adharcardNumber: innerState.adharcardNumber,
                              adharcardpath: innerState.adharcardpath,
                              emailId: innerState.emailId,
                              dateOfJoining: innerState.dateOfJoining,
                              empProfilePath: innerState.empProfilePath,
                            ));
                          },
                        ),
                      ),
                      innerState.pancardPath == ''
                          ? IconButton(
                              onPressed: () {
                                pancardPhotoUpload(
                                    context: context,
                                    state: innerState,
                                    blocProvider: blocProvider);
                              },
                              icon: const Icon(
                                Icons.attach_file,
                                size: 35,
                                color: AppColors.appTheme,
                              ))
                          : IconButton(
                              onPressed: () {
                                showPancard(
                                    blocprovider: blocProvider,
                                    context: context,
                                    state: innerState);
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                size: 35,
                                color: AppColors.appTheme,
                              ))
                    ],
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  Future<dynamic> pancardPhotoUpload(
      {required BuildContext context,
      required SetEmployeeDocuments state,
      required EmployeeRegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final picker = ImagePicker();
        return AlertDialog(
          content: SizedBox(
            height: 105,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () async {
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          await uploadPanCard(
                              pickedFile: pickedFile,
                              context: context,
                              state: state,
                              blocProvider: blocProvider);
                        },
                        icon: Icon(
                          Icons.image_rounded,
                          size: 40,
                          color: Colors.pink[400],
                        )),
                    horizontalSpace(),
                    IconButton(
                        onPressed: () async {
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.camera);
                          await uploadPanCard(
                              pickedFile: pickedFile,
                              context: context,
                              state: state,
                              blocProvider: blocProvider);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.pink[400],
                        ))
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showPancard(
      {required BuildContext context,
      required SetEmployeeDocuments state,
      required EmployeeRegistrationBloc blocprovider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    final file = File(state.pancardPath);
                    if (await file.exists()) {
                      await file.delete();
                      blocprovider.add(GetEmployeeDocuments(
                        bankAcNumber: state.bankAcNumber,
                        bankName: state.bankName,
                        bankIFSCCode: state.bankIFSCCode,
                        employeePF: state.employeePF,
                        familyPFNumber: state.familyPFNumber,
                        pancardNumber: state.pancardNumber,
                        pancardPath: '',
                        adharcardNumber: state.adharcardNumber,
                        adharcardpath: state.adharcardpath,
                        emailId: state.emailId,
                        dateOfJoining: state.dateOfJoining,
                        empProfilePath: state.empProfilePath,
                      ));
                      EmployeeeRegistrationSession.registrationDocumentSession(
                          docInfo: {
                            'bank_ac_number': state.bankAcNumber,
                            'bank_name': state.bankName,
                            'bank_ifsc_code': state.bankIFSCCode,
                            'emp_pf_number': state.employeePF,
                            'family_pf_number': state.familyPFNumber,
                            'pancard_number': state.pancardNumber,
                            'pancard_image_path': '',
                            'aadharcard_number': state.adharcardNumber,
                            'aadharcard_image_path': state.adharcardpath,
                            'email_id': state.emailId,
                            'date_of_joining': state.dateOfJoining,
                            'emp_profile': state.empProfilePath,
                          });
                      Navigator.of(context).pop();
                      return QuickFixUi.successMessage(
                          'File deleted successfully', context);
                    } else {
                      Navigator.of(context).pop();
                      return QuickFixUi.errorMessage(
                          'Error occurred while deleting an file', context);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 35,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.blue,
                    size: 36,
                  ))
            ],
          ),
          content: Image(image: FileImage(File(state.pancardPath))),
        );
      },
    );
  }

  Future<void> uploadPanCard(
      {required XFile? pickedFile,
      required BuildContext context,
      required SetEmployeeDocuments state,
      required EmployeeRegistrationBloc blocProvider}) async {
    try {
      if (pickedFile != null) {
        File? croppedfile = await ImageUtility()
            .cropImage(pickedFile: pickedFile, context: context);
        final directory = await getApplicationDocumentsDirectory();

        final croppedImagePath =
            "${directory.path}/${DateTime.now().microsecondsSinceEpoch}.jpg";
        await croppedfile!.copy(croppedImagePath);
        blocProvider.add(GetEmployeeDocuments(
          bankAcNumber: state.bankAcNumber,
          bankName: state.bankName,
          bankIFSCCode: state.bankIFSCCode,
          employeePF: state.employeePF,
          familyPFNumber: state.familyPFNumber,
          pancardNumber: state.pancardNumber,
          pancardPath: croppedImagePath,
          adharcardNumber: state.adharcardNumber,
          adharcardpath: state.adharcardpath,
          emailId: state.emailId,
          dateOfJoining: state.dateOfJoining,
          empProfilePath: state.empProfilePath,
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      return;
    }
  }

  BlocBuilder<EmpRegBloc, EmpRegState> familyPFnumber(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.familyPFNumber == ''
                            ? 'Family PF number'
                            : innerState.familyPFNumber,
                        hintStyle: TextStyle(
                            fontWeight: innerState.familyPFNumber == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.familyPFNumber == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: '',
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: value.toString(),
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> employeePF(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.employeePF == ''
                            ? 'Employee PF number'
                            : innerState.employeePF,
                        hintStyle: TextStyle(
                            fontWeight: innerState.employeePF == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.employeePF == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: '',
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: value.toString(),
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> bankIFSCCode(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.bankIFSCCode == ''
                            ? 'Bank IFSC code'
                            : innerState.bankIFSCCode,
                        hintStyle: TextStyle(
                            fontWeight: innerState.bankIFSCCode == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.bankIFSCCode == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: '',
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: innerState.bankName,
                        bankIFSCCode: value.toString(),
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> bankName(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.bankName == ''
                            ? 'Bank name'
                            : innerState.bankName,
                        hintStyle: TextStyle(
                            fontWeight: innerState.bankName == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.bankName == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: '',
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: innerState.bankAcNumber,
                        bankName: value.toString(),
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> bankAccountNumber(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 3),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.bankAcNumber == ''
                            ? 'Bank account number'
                            : innerState.bankAcNumber,
                        hintStyle: TextStyle(
                            fontWeight: innerState.bankAcNumber == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.bankAcNumber == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    keyboardType: TextInputType.number,
                    onTap: () {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: '',
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeDocuments(
                        bankAcNumber: value.toString(),
                        bankName: innerState.bankName,
                        bankIFSCCode: innerState.bankIFSCCode,
                        employeePF: innerState.employeePF,
                        familyPFNumber: innerState.familyPFNumber,
                        pancardNumber: innerState.pancardNumber,
                        pancardPath: innerState.pancardPath,
                        adharcardNumber: innerState.adharcardNumber,
                        adharcardpath: innerState.adharcardpath,
                        emailId: innerState.emailId,
                        dateOfJoining: innerState.dateOfJoining,
                        empProfilePath: innerState.empProfilePath,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> saveDocuments({
    required double conHeight,
    required double conMargin,
    required double topMargin,
    required EmpRegBloc provider,
    required EmployeeRegistrationBloc blocProvider,
  }) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 2) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeDocuments) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 3),
                  child: FilledButton(
                      onPressed: () {
                        if (innerState.pancardNumber == '') {
                          return QuickFixUi.errorMessage(
                              'Pan card number not found', context);
                        } else if (innerState.adharcardNumber == '') {
                          return QuickFixUi.errorMessage(
                              'Aadhar card number not found', context);
                        } else if (innerState.adharcardNumber.length > 12 ||
                            innerState.adharcardNumber.length < 12) {
                          return QuickFixUi.errorMessage(
                              'Invalid adhar number', context);
                        } else if (innerState.emailId == '') {
                          return QuickFixUi.errorMessage(
                              'E-mail id not found', context);
                        } else if (innerState.dateOfJoining == '') {
                          return QuickFixUi.errorMessage(
                              'Date of joining not found', context);
                        } else if (innerState.empProfilePath == '') {
                          return QuickFixUi.errorMessage(
                              'Please upload employee profile', context);
                        } else {
                          EmployeeeRegistrationSession
                              .registrationDocumentSession(docInfo: {
                            'bank_ac_number': innerState.bankAcNumber,
                            'bank_name': innerState.bankName == ''
                                ? ''
                                : innerState.bankName
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    innerState.bankName.substring(1),
                            'bank_ifsc_code':
                                innerState.bankIFSCCode.toUpperCase(),
                            'emp_pf_number':
                                innerState.employeePF.toUpperCase(),
                            'family_pf_number':
                                innerState.familyPFNumber.toUpperCase(),
                            'pancard_number':
                                innerState.pancardNumber.toUpperCase(),
                            'pancard_image_path': innerState.pancardPath,
                            'aadharcard_number': innerState.adharcardNumber,
                            'aadharcard_image_path': innerState.adharcardpath,
                            'email_id': innerState.emailId,
                            'date_of_joining': innerState.dateOfJoining,
                            'emp_profile': innerState.empProfilePath,
                          });
                          provider.add(GetEmployeeData(selectedIndex: 3));
                          blocProvider.add(GetEmploymentInfo());
                        }
                      },
                      child: const Text('SAVE & NEXT')),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  Container buttonList(
      {required double topMargin,
      required EmpRegBloc provider,
      required EmployeeRegistrationBloc blocProvider,
      required double buttonMargin}) {
    blocProvider.add(GetPersonalInfo());
    return Container(
      height: 50,
      margin: EdgeInsets.only(
          left: buttonMargin, right: buttonMargin, top: topMargin * 2),
      child: BlocBuilder<EmpRegBloc, EmpRegState>(
        builder: (context, outerstate) {
          if (outerstate is SetEmployeeData) {
            return ListView.builder(
              itemCount: outerstate.buttonList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return BlocBuilder<EmployeeRegistrationBloc,
                    EmployeeRegistrationState>(
                  builder: (context, innerState) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            provider.add(GetEmployeeData(
                              selectedIndex: index,
                            ));
                            if (index == 0) {
                              blocProvider.add(GetPersonalInfo());
                            } else if (index == 1) {
                              blocProvider.add(GetEmployeeAddress());
                            } else if (index == 2) {
                              blocProvider.add(GetEmployeeDocuments());
                            } else if (index == 3) {
                              blocProvider.add(GetEmploymentInfo());
                            } else {}
                          },
                          icon: MyIconGenerator.getIcon(
                            name: outerstate.buttonList[index].toString(),
                            iconColor: outerstate.selectedIndex == index
                                ? AppColors.whiteTheme
                                : AppColors.appTheme,
                          ),
                          style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => outerstate.selectedIndex == index
                                      ? AppColors.greenTheme
                                      : Theme.of(context).colorScheme.surface)),
                          label: Text(
                            outerstate.buttonList[index].toString(),
                            style: TextStyle(
                                color: outerstate.selectedIndex == index
                                    ? AppColors.whiteTheme
                                    : AppColors.appTheme),
                          )),
                    );
                  },
                );
              },
            );
          } else {
            return const Stack();
          }
        },
      ),
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> relativeMobileNumber(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.relativeMobileNo == ''
                            ? 'Family member mobile number'
                            : innerState.relativeMobileNo,
                        hintStyle: TextStyle(
                            fontWeight: innerState.relativeMobileNo == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.relativeMobileNo == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    keyboardType: TextInputType.phone,
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                          selectedHonorific: innerState.selectedHonorific,
                          firstName: innerState.firstName,
                          middleName: innerState.middleName,
                          lastName: innerState.lastName,
                          dateOfBirth: innerState.dateOfBirth,
                          qualification: innerState.qualification,
                          mobileNumber: innerState.mobileNumber,
                          familyMember: innerState.familyMember,
                          relationWith: innerState.relationWith,
                          relativeMobileNo: 'Family member mobile number'));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                          selectedHonorific: innerState.selectedHonorific,
                          firstName: innerState.firstName,
                          middleName: innerState.middleName,
                          lastName: innerState.lastName,
                          dateOfBirth: innerState.dateOfBirth,
                          qualification: innerState.qualification,
                          mobileNumber: innerState.mobileNumber,
                          familyMember: innerState.familyMember,
                          relationWith: innerState.relationWith,
                          relativeMobileNo: value.toString()));
                    },
                  ),
                );
              } else {
                return const Text('');
              }
            },
          );
        }
        return const Stack();
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> relationWith(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.relationWith == ''
                            ? 'Relation with family member'
                            : innerState.relationWith,
                        hintStyle: TextStyle(
                            fontWeight: innerState.relationWith == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.relationWith == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: 'Relation with family member',
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: value.toString(),
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> familyMember(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.familyMember == ''
                            ? 'Family member'
                            : innerState.familyMember,
                        hintStyle: TextStyle(
                            fontWeight: innerState.familyMember == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.familyMember == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: 'Family member',
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: value.toString(),
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> mobileNumber(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.mobileNumber == ''
                            ? 'Mobile number'
                            : innerState.mobileNumber,
                        hintStyle: TextStyle(
                            fontWeight: innerState.mobileNumber == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.mobileNumber == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    keyboardType: TextInputType.phone,
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: 'Mobile number',
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: value.toString(),
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> qualification(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.qualification == ''
                            ? 'Qualification'
                            : innerState.qualification,
                        hintStyle: TextStyle(
                            fontWeight: innerState.qualification == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.qualification == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: 'Qualification',
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: value.toString(),
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> dateOfBirth(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    controller: TextEditingController(
                        text: innerState.dateOfBirth
                            .split('-')
                            .reversed
                            .join('-')),
                    decoration: InputDecoration(
                        hintText: 'Date of birth',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate =
                          await QuickFixUi().dateTimePicker(context);
                      if (pickedDate != null) {
                        if (DateTime.now().difference(pickedDate).inDays ~/
                                365 <
                            18) {
                          return QuickFixUi.errorMessage(
                              ageValidationMessage, context);
                        } else {
                          blocProvider.add(GetPersonalInfo(
                            selectedHonorific: innerState.selectedHonorific,
                            firstName: innerState.firstName,
                            middleName: innerState.middleName,
                            lastName: innerState.lastName,
                            dateOfBirth: pickedDate
                                .toLocal()
                                .toString()
                                .substring(0, 10),
                            qualification: innerState.qualification,
                            mobileNumber: innerState.mobileNumber,
                            familyMember: innerState.familyMember,
                            relationWith: innerState.relationWith,
                            relativeMobileNo: innerState.relativeMobileNo,
                          ));
                        }
                      } else {
                        return QuickFixUi.errorMessage(
                            'Please select date', context);
                      }
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> lastName(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.lastName == ''
                            ? 'Last name'
                            : innerState.lastName,
                        hintStyle: TextStyle(
                            fontWeight: innerState.lastName == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.lastName == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: 'Last name',
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: value.toString(),
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> middleName(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.middleName == ''
                            ? 'Middle name'
                            : innerState.middleName,
                        hintStyle: TextStyle(
                            fontWeight: innerState.middleName == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.middleName == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: 'Middle name',
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: innerState.firstName,
                        middleName: value.toString(),
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> firstName(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.firstName == ''
                            ? 'First name'
                            : innerState.firstName,
                        hintStyle: TextStyle(
                            fontWeight: innerState.firstName == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.firstName == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: 'First name',
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: innerState.selectedHonorific,
                        firstName: value.toString(),
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> honorific(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetPersonalData) {
                return Container(
                  height: conHeight + 5,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 3),
                  child: DropdownSearch<String>(
                    items: innerState.honorificlist,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText: innerState.selectedHonorific == ''
                                ? 'Honorific'
                                : innerState.selectedHonorific,
                            hintStyle: TextStyle(
                                fontWeight: innerState.selectedHonorific == ''
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: innerState.selectedHonorific == ''
                                    ? Theme.of(context).hintColor
                                    : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetPersonalInfo(
                        selectedHonorific: value.toString(),
                        firstName: innerState.firstName,
                        middleName: innerState.middleName,
                        lastName: innerState.lastName,
                        dateOfBirth: innerState.dateOfBirth,
                        qualification: innerState.qualification,
                        mobileNumber: innerState.mobileNumber,
                        familyMember: innerState.familyMember,
                        relationWith: innerState.relationWith,
                        relativeMobileNo: innerState.relativeMobileNo,
                      ));
                    },
                  ),
                );
              } else {
                return const Text('');
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> permanentState(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight + 10,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<StateModel>(
                    items: innerState.stateList,
                    itemAsString: (item) => item.name.toString(),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(fontSize: 18),
                          onTap: () {},
                        )),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText: innerState.perSelectedState['name'] ??
                                'Permanent state',
                            hintStyle: TextStyle(
                                fontWeight:
                                    innerState.perSelectedState['name'] == null
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                color:
                                    innerState.perSelectedState['name'] == null
                                        ? Theme.of(context).hintColor
                                        : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: {
                          'id': value!.id.toString(),
                          'name': value.name.toString()
                        },
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> permanentPincode(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.permanentPincode == ''
                            ? 'Permanent pin code'
                            : innerState.permanentPincode,
                        hintStyle: TextStyle(
                            fontWeight: innerState.permanentPincode == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.permanentPincode == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    keyboardType: TextInputType.number,
                    onTap: () {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: '',
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: value.toString(),
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> permanentCity(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight + 5,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<CityModel>(
                    items: innerState.cityList,
                    itemAsString: (item) => item.name.toString(),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(fontSize: 18),
                          onTap: () {},
                        )),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText: innerState.perSelectedCity['name'] ??
                                'Permanent city',
                            hintStyle: TextStyle(
                                fontWeight:
                                    innerState.perSelectedCity['name'] == null
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                color:
                                    innerState.perSelectedCity['name'] == null
                                        ? Theme.of(context).hintColor
                                        : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: {
                          'id': value!.id.toString(),
                          'name': value.name.toString()
                        },
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> permanentAddressLine2(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.permanentAddressLine2 == ''
                            ? 'Permanent address line 2'
                            : innerState.permanentAddressLine2,
                        hintStyle: TextStyle(
                            fontWeight: innerState.permanentAddressLine2 == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.permanentAddressLine2 == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: '',
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: value.toString(),
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> permanentAddressLine1(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                    left: conMargin,
                    right: conMargin,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.permanentAddressLine1 == ''
                            ? 'Permanent address line 1'
                            : innerState.permanentAddressLine1,
                        hintStyle: TextStyle(
                            fontWeight: innerState.permanentAddressLine1 == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.permanentAddressLine1 == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: '',
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: value.toString(),
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> curAddIsSameAsPerAdd(
      {required double conMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                    margin: EdgeInsets.only(left: conMargin, right: conMargin),
                    child: Row(
                      children: [
                        const Text(
                            'Current address is same as permanent address'),
                        Checkbox(
                            value: innerState.curAddIsSameAsPerAdd,
                            onChanged: (value) {
                              blocProvider.add(GetEmployeeAddress(
                                currentAddLine1: innerState.currentAddLine1,
                                currentAddLine2: innerState.currentAddLine2,
                                curselectedCity: innerState.curselectedCity,
                                currentPinCode: innerState.currentPinCode,
                                curselectedState: innerState.curselectedState,
                                curAddIsSameAsPerAdd: value!,
                                permanentAddressLine1:
                                    innerState.permanentAddressLine1,
                                permanentAddressLine2:
                                    innerState.permanentAddressLine2,
                                perSelectedCity: innerState.perSelectedCity,
                                permanentPincode: innerState.permanentPincode,
                                perSelectedState: innerState.perSelectedState,
                              ));
                            })
                      ],
                    ));
              } else {
                return const Text('');
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> permanentAddressHeader(
      {required double conMargin, required double topMargin}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, state) {
        if (state is SetEmployeeData && state.selectedIndex == 1) {
          return Container(
            margin: EdgeInsets.only(
                left: conMargin, right: conMargin, top: topMargin * 2),
            child: const Text(
              'Permanent Address :',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.appTheme),
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> currentState(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight + 10,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<StateModel>(
                    items: innerState.stateList,
                    itemAsString: (item) => item.name.toString(),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(fontSize: 18),
                          onTap: () {},
                        )),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText: innerState.curselectedState['name'] ??
                                'Current state',
                            hintStyle: TextStyle(
                                fontWeight:
                                    innerState.curselectedState['name'] == null
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                color:
                                    innerState.curselectedState['name'] == null
                                        ? Theme.of(context).hintColor
                                        : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: {
                          'id': value!.id.toString(),
                          'name': value.name.toString()
                        },
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> currentPinCode(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.currentPinCode == ''
                            ? 'Current pin code'
                            : innerState.currentPinCode,
                        hintStyle: TextStyle(
                            fontWeight: innerState.currentPinCode == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.currentPinCode == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    keyboardType: TextInputType.number,
                    onTap: () {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: '',
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: value.toString(),
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> currentCity(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight + 5,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: DropdownSearch<CityModel>(
                    items: innerState.cityList,
                    itemAsString: (item) => item.name.toString(),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(fontSize: 18),
                          onTap: () {},
                        )),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText: innerState.curselectedCity['name'] ??
                                'Current city',
                            hintStyle: TextStyle(
                                fontWeight:
                                    innerState.curselectedCity['name'] == null
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                color:
                                    innerState.curselectedCity['name'] == null
                                        ? Theme.of(context).hintColor
                                        : AppColors.blackColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)))),
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: {
                          'id': value!.id.toString(),
                          'name': value.name.toString()
                        },
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> saveAddress(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider,
      required EmpRegBloc provider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 3),
                  child: FilledButton(
                      onPressed: () {
                        if (innerState.currentAddLine1 == '') {
                          return QuickFixUi.errorMessage(
                              'Current address line 1 is empty', context);
                        } else if (innerState.currentAddLine2 == '') {
                          return QuickFixUi.errorMessage(
                              'Current address line 2 is empty', context);
                        } else if (innerState.curselectedCity['id'] == null) {
                          return QuickFixUi.errorMessage(
                              'Please select current city', context);
                        } else if (innerState.currentPinCode == '') {
                          return QuickFixUi.errorMessage(
                              'Current pin code not found', context);
                        } else if (innerState.curselectedState['id'] == null) {
                          return QuickFixUi.errorMessage(
                              'Please select current state', context);
                        } else if (innerState.permanentAddressLine1 == '') {
                          return QuickFixUi.errorMessage(
                              'Permanent address line 1 is empty', context);
                        } else if (innerState.permanentAddressLine2 == '') {
                          return QuickFixUi.errorMessage(
                              'Permanent address line 2 is empty', context);
                        } else if (innerState.perSelectedCity['id'] == null) {
                          return QuickFixUi.errorMessage(
                              'Please select permanent city', context);
                        } else if (innerState.permanentPincode == '') {
                          return QuickFixUi.errorMessage(
                              'Permanent pin code not found', context);
                        } else if (innerState.perSelectedState['id'] == null) {
                          return QuickFixUi.errorMessage(
                              'Please select permanent state', context);
                        } else {
                          EmployeeeRegistrationSession
                              .employeeAddressSession(addressInformation: {
                            'current_add1': innerState.currentAddLine1
                                    .substring(0, 1)
                                    .toUpperCase() +
                                innerState.currentAddLine1.substring(1),
                            'current_add2': innerState.currentAddLine2
                                    .substring(0, 1)
                                    .toUpperCase() +
                                innerState.currentAddLine2.substring(1),
                            'current_city_id': innerState.curselectedCity['id'],
                            'current_city_name':
                                innerState.curselectedCity['name'],
                            'current_pin_code': innerState.currentPinCode,
                            'current_state_id':
                                innerState.curselectedState['id'],
                            'current_state_name':
                                innerState.curselectedState['name'],
                            'per_add1': innerState.permanentAddressLine1
                                    .substring(0, 1)
                                    .toUpperCase() +
                                innerState.permanentAddressLine1.substring(1),
                            'per_add2': innerState.permanentAddressLine2
                                    .substring(0, 1)
                                    .toUpperCase() +
                                innerState.permanentAddressLine2.substring(1),
                            'per_city_id': innerState.perSelectedCity['id'],
                            'per_city_name': innerState.perSelectedCity['name'],
                            'per_pin_code': innerState.permanentPincode,
                            'per_state_id': innerState.perSelectedState['id'],
                            'per_state_name':
                                innerState.perSelectedState['name'],
                            'cur_add_is_same_as_permanent_add':
                                innerState.curAddIsSameAsPerAdd
                          });
                          provider.add(GetEmployeeData(selectedIndex: 2));
                          blocProvider.add(GetEmployeeDocuments());
                        }
                      },
                      child: const Text('SAVE & NEXT')),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> currentAddressLine2(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.currentAddLine2 == ''
                            ? 'Current address line 2'
                            : innerState.currentAddLine2,
                        hintStyle: TextStyle(
                            fontWeight: innerState.currentAddLine2 == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.currentAddLine2 == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: '',
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: innerState.currentAddLine1,
                        currentAddLine2: value.toString(),
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> currentAddressLine1(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, outerState) {
        if (outerState is SetEmployeeData && outerState.selectedIndex == 1) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, innerState) {
              if (innerState is SetEmployeeAddress) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 2),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: innerState.currentAddLine1 == ''
                            ? 'Current address line 1'
                            : innerState.currentAddLine1,
                        hintStyle: TextStyle(
                            fontWeight: innerState.currentAddLine1 == ''
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: innerState.currentAddLine1 == ''
                                ? Theme.of(context).hintColor
                                : AppColors.blackColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onTap: () {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: '',
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                    onChanged: (value) {
                      blocProvider.add(GetEmployeeAddress(
                        currentAddLine1: value.toString(),
                        currentAddLine2: innerState.currentAddLine2,
                        curselectedCity: innerState.curselectedCity,
                        currentPinCode: innerState.currentPinCode,
                        curselectedState: innerState.curselectedState,
                        curAddIsSameAsPerAdd: innerState.curAddIsSameAsPerAdd,
                        permanentAddressLine1: innerState.permanentAddressLine1,
                        permanentAddressLine2: innerState.permanentAddressLine2,
                        perSelectedCity: innerState.perSelectedCity,
                        permanentPincode: innerState.permanentPincode,
                        perSelectedState: innerState.perSelectedState,
                      ));
                    },
                  ),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> currentAddressHeader(
      {required double conHeight,
      required double conMargin,
      required double topMargin}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, state) {
        if (state is SetEmployeeData && state.selectedIndex == 1) {
          return Container(
            margin: EdgeInsets.only(
                left: conMargin, right: conMargin, top: topMargin * 3),
            child: const Text(
              'Current Address :',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.appTheme),
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<EmpRegBloc, EmpRegState> savePersonalInformation(
      {required double conHeight,
      required double conMargin,
      required double topMargin,
      required EmployeeRegistrationBloc blocProvider,
      required EmpRegBloc provider}) {
    return BlocBuilder<EmpRegBloc, EmpRegState>(
      builder: (context, innerState) {
        if (innerState is SetEmployeeData && innerState.selectedIndex == 0) {
          return BlocBuilder<EmployeeRegistrationBloc,
              EmployeeRegistrationState>(
            builder: (context, outerState) {
              if (outerState is SetPersonalData) {
                return Container(
                  height: conHeight,
                  margin: EdgeInsets.only(
                      left: conMargin, right: conMargin, top: topMargin * 3),
                  child: FilledButton(
                      onPressed: () {
                        if (outerState.selectedHonorific == '') {
                          return QuickFixUi.errorMessage(
                              'Please select honorific', context);
                        } else if (outerState.firstName == '' ||
                            outerState.firstName == 'First name') {
                          return QuickFixUi.errorMessage(
                              'First name not found', context);
                        } else if (outerState.middleName == '' ||
                            outerState.middleName == 'Middle name') {
                          return QuickFixUi.errorMessage(
                              'Middle name not found', context);
                        } else if (outerState.lastName == '' ||
                            outerState.lastName == 'Last name') {
                          return QuickFixUi.errorMessage(
                              'Last name not found', context);
                        } else if (outerState.dateOfBirth == '') {
                          return QuickFixUi.errorMessage(
                              'Date of birth not found', context);
                        } else if (outerState.qualification == '' ||
                            outerState.qualification == 'Qualification') {
                          return QuickFixUi.errorMessage(
                              'Qualification not found', context);
                        } else if (outerState.mobileNumber == '' ||
                            outerState.mobileNumber == 'Mobile number') {
                          return QuickFixUi.errorMessage(
                              'Mobile number not found', context);
                        } else if (outerState.mobileNumber.length < 10 ||
                            outerState.mobileNumber.length > 10) {
                          return QuickFixUi.errorMessage(
                              'Incorrect mobile number', context);
                        } else if (outerState.familyMember == '' ||
                            outerState.familyMember == 'Family member') {
                          return QuickFixUi.errorMessage(
                              'Family member name not found', context);
                        } else if (outerState.relationWith == '' ||
                            outerState.relationWith ==
                                'Relation with family member') {
                          return QuickFixUi.errorMessage(
                              'Relation with family member not found', context);
                        } else if (outerState.relativeMobileNo == '' ||
                            outerState.relativeMobileNo ==
                                'Family member mobile number') {
                          return QuickFixUi.errorMessage(
                              'Relative mobile number not found', context);
                        } else if (outerState.relativeMobileNo.length < 10 ||
                            outerState.relativeMobileNo.length > 10) {
                          return QuickFixUi.errorMessage(
                              'Incorrect relative mobile number ', context);
                        } else {
                          EmployeeeRegistrationSession
                              .personalInformationSession(personalInformation: {
                            'selectedHonorific': outerState.selectedHonorific,
                            'firstName': outerState.firstName
                                    .substring(0, 1)
                                    .toUpperCase() +
                                outerState.firstName.substring(1),
                            'middleName': outerState.middleName
                                    .substring(0, 1)
                                    .toUpperCase() +
                                outerState.middleName.substring(1),
                            'lastName': outerState.lastName
                                    .substring(0, 1)
                                    .toUpperCase() +
                                outerState.lastName.substring(1),
                            'dateOfBirth': outerState.dateOfBirth,
                            'qualification': outerState.qualification
                                    .substring(0, 1)
                                    .toUpperCase() +
                                outerState.qualification.substring(1),
                            'mobileNumber': outerState.mobileNumber,
                            'relativeName': outerState.familyMember
                                    .substring(0, 1)
                                    .toUpperCase() +
                                outerState.familyMember.substring(1),
                            'relationWith': outerState.relationWith
                                    .substring(0, 1)
                                    .toUpperCase() +
                                outerState.relationWith.substring(1),
                            'relativeMobileNumber': outerState.relativeMobileNo
                          });
                          provider.add(GetEmployeeData(selectedIndex: 1));
                          blocProvider.add(GetEmployeeAddress());
                        }
                      },
                      child: const Text('SAVE & NEXT')),
                );
              } else {
                return const Stack();
              }
            },
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  SizedBox verticalSpace() {
    return const SizedBox(
      height: 10,
    );
  }
}
