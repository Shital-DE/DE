// Author : Shital Gayakwad
// Description : Employee details update
// Created Date : 23 August 2024

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:de/bloc/user/update_employee_details/update_employee_details_event.dart';
import 'package:de/bloc/user/update_employee_details/update_employee_details_state.dart';
import 'package:de/services/model/user/login_model.dart';
import 'package:de/utils/app_colors.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/user/update_employee_details/update_employee_details_bloc.dart';
import '../../../services/model/common/city_model.dart';
import '../../../services/model/common/state_model.dart';
import '../../../services/repository/user/employee_details_update_repo.dart';
import '../../../services/repository/user/employee_registration_repository.dart';
import '../../../services/repository/user/user_login_repo.dart';
import '../../../utils/constant.dart';
import '../../widgets/appbar.dart';
import '../../widgets/image_utility.dart';

class UpdateEmployeeDetails extends StatefulWidget {
  const UpdateEmployeeDetails({super.key});

  @override
  State<UpdateEmployeeDetails> createState() => _UpdateEmployeeDetailsState();
}

class _UpdateEmployeeDetailsState extends State<UpdateEmployeeDetails> {
  String honorific = '',
      firstname = '',
      middlename = '',
      lastname = '',
      qualification = '',
      mobile = '',
      familyMemberName = '',
      relationWithFamilyMember = '',
      relativeMobileNumber = '',
      currentAddressLine1 = '',
      currentAddressLine2 = '',
      currentpin = '',
      permanentaddress1 = '',
      permanentaddress2 = '',
      permanentpin = '',
      bankaccountnumber = '',
      bankname = '',
      bankifsccode = '',
      employeePfNumber = '',
      familyPfNumber = '',
      pannumber = '',
      aadharnumber = '',
      emailId = '';
  StreamController<String> dateOfBirth = StreamController<String>.broadcast();
  StreamController<String> dateOfJoining = StreamController<String>.broadcast();
  StreamController<String> dateOfLeaving = StreamController<String>.broadcast();
  StreamController<String> panid = StreamController<String>.broadcast();
  StreamController<ImageProvider<Object>> panController =
      StreamController<ImageProvider<Object>>.broadcast();
  StreamController<String> aadharid = StreamController<String>.broadcast();
  StreamController<ImageProvider<Object>> aadharController =
      StreamController<ImageProvider<Object>>.broadcast();
  CityModel currentCity = CityModel();
  StateModel currentState = StateModel();
  CityModel permanentCity = CityModel();
  StateModel permanentState = StateModel();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UpdateEmployeeDetailsBloc>(context)
        .add(GetEmployeeDetailsForUpdate());
  }

  @override
  void dispose() {
    dateOfBirth.close();
    dateOfJoining.close();
    dateOfLeaving.close();
    panid.close();
    panController.close();
    aadharid.close();
    aadharController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<UpdateEmployeeDetailsBloc>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppbar()
            .appbar(context: context, title: 'Update employee details'),
        body:
            BlocBuilder<UpdateEmployeeDetailsBloc, UpdateEmployeeDetailsState>(
                builder: (context, state) {
          if (state is UpdateEmployeeDetailsInitialState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UpdateEmployee &&
              state.employeeDataList.isNotEmpty) {
            double rowHeight = 50, columnWidth = 200, headerHeight = 50;
            return Container(
                width: size.width,
                height: size.height,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: CustomTable(
                  tablewidth: size.width,
                  tableheight: size.height,
                  columnWidth: columnWidth,
                  headerHeight: headerHeight,
                  rowHeight: rowHeight,
                  enableBorder: true,
                  tableBorderColor: Theme.of(context).primaryColorDark,
                  tableheaderColor: Theme.of(context).primaryColorLight,
                  headerStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark),
                  column: state.columnNames
                      .map((e) => ColumnData(
                          width: e == 'Index'
                              ? 70
                              : e == 'E-mail id'
                                  ? columnWidth + 50
                                  : e == 'Company'
                                      ? columnWidth + 50
                                      : e == 'Action'
                                          ? columnWidth + 6
                                          : columnWidth,
                          label: e))
                      .toList(),
                  rows: state.employeeDataList.map((e) {
                    return RowData(
                        rowColor: state.selectedEmp == e.id
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.white,
                        cell: [
                          TableDataCell(
                              width: 70,
                              label: Container(
                                width: 70,
                                height: rowHeight,
                                decoration: cellDecoration(
                                    e: e, state: state, context: context),
                                child: Center(
                                  child: Text(
                                      ((state.employeeDataList.indexOf(e) + 1) +
                                              state.index)
                                          .toString(),
                                      textAlign: TextAlign.center),
                                ),
                              )),
                          TableDataCell(
                              width: columnWidth + 6,
                              label: Container(
                                width: columnWidth + 6,
                                height: rowHeight,
                                decoration: cellDecoration(
                                    e: e, state: state, context: context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    profileButton(
                                        e: e,
                                        state: state,
                                        context: context,
                                        blocProvider: blocProvider),
                                    IconButton(
                                        onPressed: () {
                                          if (state.selectedEmp == e.id) {
                                            clearValues(
                                                blocProvider: blocProvider,
                                                state: state);
                                          } else {
                                            blocProvider.add(
                                                GetEmployeeDetailsForUpdate(
                                                    index: state.index,
                                                    selectedEmp:
                                                        e.id.toString()));
                                          }
                                        },
                                        icon: buttonIcon(
                                            icon: state.selectedEmp == e.id
                                                ? Icons.cancel
                                                : Icons.edit)),
                                    state.selectedEmp == e.id
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: StreamBuilder<String>(
                                                stream: dateOfBirth.stream,
                                                builder: (context,
                                                    dateOfBirthSnapshot) {
                                                  return StreamBuilder<String>(
                                                      stream:
                                                          dateOfJoining.stream,
                                                      builder: (context,
                                                          dateOfJoiningSnapshot) {
                                                        return StreamBuilder<
                                                                String>(
                                                            stream:
                                                                dateOfLeaving
                                                                    .stream,
                                                            builder: (context,
                                                                dateOfLeavingSnapshot) {
                                                              return ElevatedButton(
                                                                onPressed: () {
                                                                  updateConfirmationDialog(
                                                                      context:
                                                                          context,
                                                                      state:
                                                                          state,
                                                                      dateOfBirthSnapshot:
                                                                          dateOfBirthSnapshot,
                                                                      e: e,
                                                                      dateOfJoiningSnapshot:
                                                                          dateOfJoiningSnapshot,
                                                                      dateOfLeavingSnapshot:
                                                                          dateOfLeavingSnapshot,
                                                                      blocProvider:
                                                                          blocProvider);
                                                                },
                                                                child: Text(
                                                                  'UPDATE',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorDark),
                                                                ),
                                                              );
                                                            });
                                                      });
                                                }),
                                          )
                                        : const Text('')
                                  ],
                                ),
                              )),
                          TableDataCell(
                              label: Container(
                            width: columnWidth + 6,
                            height: rowHeight,
                            decoration: cellDecoration(
                                e: e, state: state, context: context),
                            child: Center(
                              child: Text(e.employeeId.toString().trim(),
                                  textAlign: align),
                            ),
                          )),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? honorificWidget(e: e)
                                  : honorificCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? firstnameWidget(e: e)
                                  : firstnameCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? middlenameWidget(e: e)
                                  : middlenameCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? lastnameWidget(e: e)
                                  : lastnameCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? birthdateWidget(e: e)
                                  : birthdateCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? qualificationWidget(e: e)
                                  : qualificationCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? mobileWidget(e: e)
                                  : mobileCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? familymembernameWidget(e: e)
                                  : familyMemberNameCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? relationWithFamilyMemeberWidget(e: e)
                                  : relationWithFamMemCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? relativeMobileNumberWidget(e: e)
                                  : relativeMobileCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? currentAddressLine1Widget(e: e)
                                  : currentAddressLine1Cell(
                                      e: e,
                                      width: columnWidth,
                                      height: rowHeight)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? currentAddressLine2Widget(e: e)
                                  : currentAddressLine2Cell(
                                      e: e,
                                      width: columnWidth,
                                      height: rowHeight)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? currentCityWidget(state: state, e: e)
                                  : currentCityCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? currentPincodeWidget(e: e)
                                  : currentpinCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? currentStateWidget(state: state, e: e)
                                  : currentStateCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? permanentAddressline1Widget(e: e)
                                  : permanentAddress1Cell(
                                      e: e,
                                      width: columnWidth,
                                      height: rowHeight)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? permanentAddressLine2Widget(e: e)
                                  : permanentAddress2Cell(
                                      e: e,
                                      width: columnWidth,
                                      height: rowHeight)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? permanentCityWidget(state: state, e: e)
                                  : permanentCityCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? permanentPinWidget(e: e)
                                  : permanentPinCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? permanentStateWidget(state: state, e: e)
                                  : permanentStateCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? bankAccountNumber(e: e)
                                  : bankAcCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? banknameWidget(e: e)
                                  : banknameCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? bankIFSCCodeWidget(e: e)
                                  : bankIFSCCodeCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? employeePFWidget(e: e)
                                  : employeePFCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? familyPFWidget(e: e)
                                  : familyPFCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? pancardNumber(e: e)
                                  : panCell(
                                      e: e,
                                      state: state,
                                      context: context,
                                      blocProvider: blocProvider)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? adharcardNumber(e: e)
                                  : aadharCell(
                                      e: e,
                                      state: state,
                                      context: context,
                                      blocProvider: blocProvider)),
                          TableDataCell(
                              width: columnWidth + 50,
                              label: state.selectedEmp == e.id
                                  ? emailWidget(e: e)
                                  : emailCell(e: e)),
                          TableDataCell(
                              label: Container(
                                  width: columnWidth + 6,
                                  height: rowHeight,
                                  decoration: cellDecoration(
                                      e: e, state: state, context: context),
                                  child: employeeTypeCell(e: e))),
                          TableDataCell(
                              label: Container(
                                  width: columnWidth + 6,
                                  height: rowHeight,
                                  decoration: cellDecoration(
                                      e: e, state: state, context: context),
                                  child: employeeDepartmentCell(e: e))),
                          TableDataCell(
                              label: Container(
                                  width: columnWidth + 6,
                                  height: rowHeight,
                                  decoration: cellDecoration(
                                      e: e, state: state, context: context),
                                  child: employeeDesignationCell(e: e))),
                          TableDataCell(
                              width: columnWidth + 50,
                              label: Container(
                                  width: columnWidth + 50,
                                  height: rowHeight,
                                  decoration: cellDecoration(
                                      e: e, state: state, context: context),
                                  child: companyCell(e: e))),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? dateOfJoiningWidget(e: e)
                                  : dateOfJoiningCell(e: e)),
                          TableDataCell(
                              label: state.selectedEmp == e.id
                                  ? dateOfLeavingWidget(e: e)
                                  : dateOfLeavingCell(e: e)),
                        ]);
                  }).toList(),
                  footer: state.employeeDataList.isEmpty
                      ? emptySizedbox()
                      : SizedBox(
                          width:
                              (columnWidth * (state.columnNames.length - 2)) +
                                  376,
                          height: headerHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              state.index >= 50
                                  ? backButton(
                                      blocProvider: blocProvider,
                                      state: state,
                                      context: context)
                                  : emptySizedbox(),
                              state.employeeDataList.length >= 50
                                  ? nextButton(
                                      blocProvider: blocProvider,
                                      state: state,
                                      context: context)
                                  : emptySizedbox()
                            ],
                          ),
                        ),
                ));
          } else {
            return const Center(child: Text('No data found!'));
          }
        }));
  }

  Future<dynamic> updateConfirmationDialog(
      {required BuildContext context,
      required UpdateEmployee state,
      required AsyncSnapshot<String> dateOfBirthSnapshot,
      required UserDataModel e,
      required AsyncSnapshot<String> dateOfJoiningSnapshot,
      required AsyncSnapshot<String> dateOfLeavingSnapshot,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const SizedBox(
              height: 25,
              child: Center(
                child: Text('Are you sure?',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenTheme),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.whiteTheme),
                ),
              ),
              updateButton(
                  context: context,
                  state: state,
                  dateOfBirthSnapshot: dateOfBirthSnapshot,
                  e: e,
                  dateOfJoiningSnapshot: dateOfJoiningSnapshot,
                  dateOfLeavingSnapshot: dateOfLeavingSnapshot,
                  blocProvider: blocProvider)
            ],
          );
        });
  }

  ElevatedButton updateButton(
      {required BuildContext context,
      required UpdateEmployee state,
      required AsyncSnapshot<String> dateOfBirthSnapshot,
      required UserDataModel e,
      required AsyncSnapshot<String> dateOfJoiningSnapshot,
      required AsyncSnapshot<String> dateOfLeavingSnapshot,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.redTheme),
      onPressed: () async {
        try {
          FocusScope.of(context).unfocus();
          String response = await EmployeeDetailsUpdateRepo()
              .updateEmployeeData(token: state.token, payload: {
            'createdby': state.loggedInUser.toString().trim(),
            'birthdate': dateOfBirthSnapshot.data != null
                ? dateOfBirthSnapshot.data!.toString().trim()
                : (e.birthdate == null || e.birthdate == 'null')
                    ? 'NULL'
                    : DateTime.parse(e.birthdate.toString().trim())
                        .toLocal()
                        .toString()
                        .substring(0, 10),
            'honorific': honorific.toString().trim() != ''
                ? honorific.toString().trim()
                : (e.honorific.toString().trim() == '' ||
                        e.honorific.toString().trim() == 'null')
                    ? 'NULL'
                    : e.honorific.toString().trim(),
            'lastname': lastname.toString().trim() != ''
                ? lastname.toString().trim()
                : (e.lastname.toString().trim() == '' ||
                        e.lastname.toString().trim() == 'null')
                    ? 'NULL'
                    : e.lastname.toString().trim(),
            'firstname': firstname.toString().trim() != ''
                ? firstname.toString().trim()
                : (e.firstname.toString().trim() == '' ||
                        e.firstname.toString().trim() == 'null')
                    ? 'NULL'
                    : e.firstname.toString().trim(),
            'middlename': middlename.toString().trim() != ''
                ? middlename.toString().trim()
                : (e.middlename.toString().trim() == '' ||
                        e.middlename.toString().trim() == 'null')
                    ? 'NULL'
                    : e.middlename.toString().trim(),
            'currentaddress1': currentAddressLine1.toString().trim() != ''
                ? currentAddressLine1.toString().trim()
                : (e.currentaddress1.toString().trim() == '' ||
                        e.currentaddress1.toString().trim() == 'null')
                    ? 'NULL'
                    : e.currentaddress1.toString().trim(),
            'currentaddress2': currentAddressLine2.toString().trim() != ''
                ? currentAddressLine2.toString().trim()
                : (e.currentaddress2.toString().trim() == '' ||
                        e.currentaddress2.toString().trim() == 'null')
                    ? 'NULL'
                    : e.currentaddress2.toString().trim(),
            'currentcity_id': currentCity.id.toString().trim() != '' &&
                    currentCity.id.toString().trim() != 'null'
                ? currentCity.id.toString().trim()
                : (e.currentcityId.toString().trim() == '' ||
                        e.currentcityId.toString().trim() == 'null')
                    ? 'NULL'
                    : e.currentcityId.toString().trim(),
            'currentpin': currentpin.toString().trim() != ''
                ? currentpin.toString().trim()
                : (e.currentpin.toString().trim() == '' ||
                        e.currentpin.toString().trim() == 'null')
                    ? 'NULL'
                    : e.currentpin.toString().trim(),
            'currentstate': currentState.id.toString().trim() != '' &&
                    currentState.id.toString().trim() != 'null'
                ? currentState.id.toString().trim()
                : (e.currentstate.toString().trim() == '' ||
                        e.currentstate.toString().trim() == 'null')
                    ? 'NULL'
                    : e.currentstate.toString().trim(),
            'permanentaddress1': permanentaddress1.toString().trim() != ''
                ? permanentaddress1.toString().trim()
                : (e.permanentaddress1.toString().trim() == '' ||
                        e.permanentaddress1.toString().trim() == 'null')
                    ? 'NULL'
                    : e.permanentaddress1.toString().trim(),
            'permanentaddress2': permanentaddress2.toString().trim() != ''
                ? permanentaddress2.toString().trim()
                : (e.permanentaddress2.toString().trim() == '' ||
                        e.permanentaddress2.toString().trim() == 'null')
                    ? 'NULL'
                    : e.permanentaddress2.toString().trim(),
            'permanentcity_id': permanentCity.id.toString().trim() != '' &&
                    permanentCity.id.toString().trim() != 'null'
                ? permanentCity.id.toString().trim()
                : (e.permanentcityId.toString().trim() == '' ||
                        e.permanentcityId.toString().trim() == 'null')
                    ? 'NULL'
                    : e.permanentcityId.toString().trim(),
            'permanentpin': permanentpin.toString().trim() != ''
                ? permanentpin.toString().trim()
                : (e.permanentpin.toString().trim() == '' ||
                        e.permanentpin.toString().trim() == 'null')
                    ? 'NULL'
                    : e.permanentpin.toString().trim(),
            'permanentstate': permanentState.id.toString().trim() != '' &&
                    permanentState.id.toString().trim() != 'null'
                ? permanentState.id.toString().trim()
                : (e.permanentstate.toString().trim() == '' ||
                        e.permanentstate.toString().trim() == 'null')
                    ? 'NULL'
                    : e.permanentstate.toString().trim(),
            'qualification': qualification.toString().trim() != ''
                ? qualification.toString().trim()
                : (e.qualification.toString().trim() == '' ||
                        e.qualification.toString().trim() == 'null')
                    ? 'NULL'
                    : e.qualification.toString().trim(),
            'dateofjoining': dateOfJoiningSnapshot.data != null
                ? dateOfJoiningSnapshot.data.toString().trim()
                : e.dateofjoining == null || e.dateofjoining == 'null'
                    ? ''
                    : DateTime.parse(e.dateofjoining.toString().trim())
                        .toLocal()
                        .toString()
                        .substring(0, 10),
            'dateofleaving': dateOfLeavingSnapshot.data != null
                ? dateOfLeavingSnapshot.data.toString().trim()
                : e.dateofleaving == null || e.dateofleaving == 'null'
                    ? 'NULL'
                    : DateTime.parse(e.dateofleaving.toString().trim())
                        .toLocal()
                        .toString()
                        .substring(0, 10),
            'epfnumber': employeePfNumber.toString().trim() != ''
                ? employeePfNumber.toString().trim()
                : (e.epfnumber.toString().trim() == '' ||
                        e.epfnumber.toString().trim() == 'null')
                    ? 'NULL'
                    : e.epfnumber.toString().trim(),
            'fpfnumber': familyPfNumber.toString().trim() != ''
                ? familyPfNumber.toString().trim()
                : (e.fpfnumber.toString().toString() == '' ||
                        e.fpfnumber.toString().toString() == 'null')
                    ? 'NULL'
                    : e.fpfnumber.toString().toString(),
            'pannumber': pannumber.toString().trim() != ''
                ? pannumber.toString().trim()
                : (e.pannumber.toString().trim() == '' ||
                        e.pannumber.toString().trim() == 'null')
                    ? 'NULL'
                    : e.pannumber.toString().trim(),
            'aadharnumber': aadharnumber.toString().trim() != ''
                ? aadharnumber.toString().trim()
                : (e.aadharnumber.toString().trim() == '' ||
                        e.aadharnumber.toString().trim() == 'null')
                    ? 'NULL'
                    : e.aadharnumber.toString().trim(),
            'bankaccountnumber': bankaccountnumber.toString().trim() != ''
                ? bankaccountnumber.toString().trim()
                : (e.bankaccountnumber.toString().trim() == '' ||
                        e.bankaccountnumber.toString().trim() == 'null')
                    ? 'NULL'
                    : e.bankaccountnumber.toString().trim(),
            'bankname': bankname.toString().trim() != ''
                ? bankname.toString().trim()
                : (e.bankname.toString().trim() == '' ||
                        e.bankname.toString().trim() == 'null')
                    ? 'NULL'
                    : e.bankname.toString().trim(),
            'email': emailId.toString().trim() != ''
                ? emailId.toString().trim()
                : (e.email.toString().trim() == '' ||
                        e.email.toString().trim() == 'null')
                    ? 'NULL'
                    : e.email.toString().trim(),
            'mobile': mobile.toString().trim() != ''
                ? mobile.toString().trim()
                : (e.mobile.toString().trim() == '' ||
                        e.mobile.toString().trim() == 'null')
                    ? ''
                    : e.mobile.toString().trim(),
            'nextofkinname': familyMemberName.toString().trim() != ''
                ? familyMemberName.toString().trim()
                : (e.nextofkinname.toString().trim() == '' ||
                        e.nextofkinname.toString().trim() == 'null')
                    ? 'NULL'
                    : e.nextofkinname.toString().trim(),
            'bankifsccode': bankifsccode.toString().trim() != ''
                ? bankifsccode.toString().trim()
                : (e.bankifsccode.toString().trim() == '' ||
                        e.bankifsccode.toString().trim() == 'null')
                    ? 'NULL'
                    : e.bankifsccode.toString().trim(),
            'nextofkinphone': relativeMobileNumber.toString().trim() != ''
                ? relativeMobileNumber.toString().trim()
                : (e.nextofkinphone.toString().trim() == '' ||
                        e.nextofkinphone.toString().trim() == 'null')
                    ? 'NULL'
                    : e.nextofkinphone.toString().trim(),
            'nextofkinrelationwithemployee':
                relationWithFamilyMember.toString().trim() != ''
                    ? relationWithFamilyMember.toString().trim()
                    : (e.nextofkinrelationwithemployee.toString().trim() ==
                                '' ||
                            e.nextofkinrelationwithemployee.toString().trim() ==
                                'null')
                        ? 'NULL'
                        : e.nextofkinrelationwithemployee.toString().trim(),
            'id': e.id.toString().trim()
          });
          if (response == 'Success') {
            Navigator.of(context).pop();
            clearValues(blocProvider: blocProvider, state: state);
            QuickFixUi.successMessage(response, context);
          } else {
            QuickFixUi.errorMessage(response, context);
          }
        } catch (e) {
          //
        }
      },
      child: const Text(
        'Yes',
        style:
            TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteTheme),
      ),
    );
  }

  BoxDecoration cellDecoration(
      {required UserDataModel e,
      required UpdateEmployee state,
      required BuildContext context}) {
    return BoxDecoration(
      border: e.id == state.selectedEmp
          ? Border.all(color: Colors.black.withOpacity(.5), width: 1)
          : null,
    );
  }

  TextButton nextButton(
      {required UpdateEmployeeDetailsBloc blocProvider,
      required UpdateEmployee state,
      required BuildContext context}) {
    return TextButton.icon(
      onPressed: () {
        blocProvider.add(GetEmployeeDetailsForUpdate(index: 50 + state.index));
      },
      label: Text('Next', style: footerButtonStyle(context)),
      icon:
          Icon(Icons.navigate_next, color: Theme.of(context).primaryColorDark),
    );
  }

  TextButton backButton(
      {required UpdateEmployeeDetailsBloc blocProvider,
      required UpdateEmployee state,
      required BuildContext context}) {
    return TextButton.icon(
      onPressed: () {
        blocProvider.add(GetEmployeeDetailsForUpdate(index: 50 - state.index));
      },
      label: Text('Back', style: footerButtonStyle(context)),
      icon: Icon(Icons.navigate_before,
          color: Theme.of(context).primaryColorDark),
    );
  }

  void clearValues(
      {required UpdateEmployeeDetailsBloc blocProvider,
      required UpdateEmployee state}) {
    honorific = '';
    firstname = '';
    middlename = '';
    lastname = '';
    dateOfBirth.add('');
    qualification = '';
    mobile = '';
    familyMemberName = '';
    relationWithFamilyMember = '';
    relativeMobileNumber = '';
    currentAddressLine1 = '';
    currentAddressLine2 = '';
    currentCity = CityModel();
    currentpin = '';
    currentState = StateModel();
    permanentaddress1 = '';
    permanentaddress2 = '';
    permanentCity = CityModel();
    permanentpin = '';
    permanentState = StateModel();
    bankaccountnumber = '';
    bankname = '';
    bankifsccode = '';
    employeePfNumber = '';
    familyPfNumber = '';
    pannumber = '';
    aadharnumber = '';
    emailId = '';
    dateOfJoining.add('');
    dateOfLeaving.add('');
    blocProvider
        .add(GetEmployeeDetailsForUpdate(index: state.index, selectedEmp: ''));
  }

  Text dateOfLeavingCell({required UserDataModel e}) {
    return Text(
        e.dateofleaving == null || e.dateofleaving.toString().trim() == 'null'
            ? ''
            : DateTime.parse(e.dateofleaving.toString())
                .toLocal()
                .toString()
                .substring(0, 10),
        textAlign: align);
  }

  Text dateOfJoiningCell({required UserDataModel e}) {
    return Text(
        e.dateofjoining == null || e.dateofjoining.toString().trim() == 'null'
            ? ''
            : DateTime.parse(e.dateofjoining.toString())
                .toLocal()
                .toString()
                .substring(0, 10),
        textAlign: align);
  }

  Center companyCell({required UserDataModel e}) {
    return Center(
      child: Text(
          e.companyName == null || e.companyName.toString() == 'null'
              ? ''
              : e.companyName.toString().trim(),
          textAlign: align),
    );
  }

  Center employeeDesignationCell({required UserDataModel e}) {
    return Center(
      child: Text(
          e.employeeDesignationDescription == null ||
                  e.employeeDesignationDescription.toString().trim() == 'null'
              ? ''
              : e.employeeDesignationDescription.toString().trim(),
          textAlign: align),
    );
  }

  Center employeeDepartmentCell({required UserDataModel e}) {
    return Center(
      child: Text(
          e.employeeDepartmentDescription == null ||
                  e.employeeDepartmentDescription.toString().trim() == 'null'
              ? ''
              : e.employeeDepartmentDescription.toString().trim(),
          textAlign: align),
    );
  }

  Center employeeTypeCell({required UserDataModel e}) {
    return Center(
      child: Text(
          e.employeeTypeDescription == null ||
                  e.employeeTypeDescription.toString().trim() == 'null'
              ? ''
              : e.employeeTypeDescription.toString().trim(),
          textAlign: align),
    );
  }

  Text emailCell({required UserDataModel e}) {
    return Text(
        e.email == null || e.email.toString() == 'null'
            ? ''
            : e.email.toString().trim(),
        textAlign: align);
  }

  Row aadharCell(
      {required UserDataModel e,
      required UpdateEmployee state,
      required BuildContext context,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
            e.aadharnumber == null || e.aadharnumber.toString().trim() == 'null'
                ? ''
                : e.aadharnumber.toString().trim(),
            textAlign: align),
        SizedBox(
          width: 50,
          child: aadharButton(
              e: e, state: state, context: context, blocProvider: blocProvider),
        ),
      ],
    );
  }

  Row panCell(
      {required UserDataModel e,
      required UpdateEmployee state,
      required BuildContext context,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
            e.pannumber == null || e.pannumber.toString().trim() == 'null'
                ? ''
                : e.pannumber.toString().trim(),
            textAlign: align),
        SizedBox(
          width: 50,
          child: panButton(
              e: e, state: state, context: context, blocProvider: blocProvider),
        ),
      ],
    );
  }

  Text familyPFCell({required UserDataModel e}) {
    return Text(
        e.fpfnumber == null || e.fpfnumber.toString().trim() == 'null'
            ? ''
            : e.fpfnumber.toString().trim(),
        textAlign: align);
  }

  Text employeePFCell({required UserDataModel e}) {
    return Text(
        e.epfnumber == null || e.epfnumber.toString().trim() == 'null'
            ? ''
            : e.epfnumber.toString().trim(),
        textAlign: align);
  }

  Text bankIFSCCodeCell({required UserDataModel e}) {
    return Text(
        e.bankifsccode == null || e.bankifsccode.toString().trim() == 'null'
            ? ''
            : e.bankifsccode.toString().trim(),
        textAlign: align);
  }

  Text banknameCell({required UserDataModel e}) {
    return Text(
        e.bankname == null || e.bankname.toString().trim() == 'null'
            ? ''
            : e.bankname.toString().trim().toUpperCase(),
        textAlign: align);
  }

  Text bankAcCell({required UserDataModel e}) {
    return Text(
        e.bankaccountnumber == null || e.bankaccountnumber.toString() == 'null'
            ? ''
            : e.bankaccountnumber.toString().trim(),
        textAlign: align);
  }

  Text permanentStateCell({required UserDataModel e}) {
    return Text(
        e.permanentStateName == null ||
                e.permanentStateName.toString().trim() == 'null'
            ? ''
            : e.permanentStateName.toString().trim().toUpperCase(),
        textAlign: align);
  }

  Text permanentPinCell({required UserDataModel e}) {
    return Text(
        e.permanentpin == null || e.permanentpin.toString().trim() == 'null'
            ? ''
            : e.permanentpin.toString().trim(),
        textAlign: align);
  }

  Text permanentCityCell({required UserDataModel e}) {
    return Text(
        e.permanentCityName == null ||
                e.permanentCityName.toString().trim() == 'null'
            ? ''
            : e.permanentCityName.toString().trim().toUpperCase(),
        textAlign: align);
  }

  Container permanentAddress2Cell(
      {required UserDataModel e,
      required double width,
      required double height}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      child: Center(
        child: Text(
            e.permanentaddress2 == null ||
                    e.permanentaddress2.toString().trim() == 'null'
                ? ''
                : e.permanentaddress2.toString().trim(),
            textAlign: align),
      ),
    );
  }

  Container permanentAddress1Cell(
      {required UserDataModel e,
      required double width,
      required double height}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      child: Center(
        child: Text(
            e.permanentaddress1 == null ||
                    e.permanentaddress1.toString().trim() == 'null'
                ? ''
                : e.permanentaddress1.toString().trim(),
            textAlign: align),
      ),
    );
  }

  Text currentStateCell({required UserDataModel e}) {
    return Text(
        e.currentStateName == null ||
                e.currentStateName.toString().trim() == 'null'
            ? ''
            : e.currentStateName.toString().trim().toUpperCase(),
        textAlign: align);
  }

  Text currentpinCell({required UserDataModel e}) {
    return Text(
      e.currentpin == null || e.currentpin.toString().trim() == 'null'
          ? ''
          : e.currentpin.toString().trim(),
      textAlign: align,
    );
  }

  Text currentCityCell({required UserDataModel e}) {
    return Text(
        e.currentCityName == null ||
                e.currentCityName.toString().trim() == 'null'
            ? ''
            : e.currentCityName.toString().trim(),
        textAlign: align);
  }

  Container currentAddressLine2Cell(
      {required UserDataModel e,
      required double width,
      required double height}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      child: Center(
        child: Text(
          e.currentaddress2 == null ||
                  e.currentaddress2.toString().trim() == 'null'
              ? ''
              : e.currentaddress2.toString().trim(),
          textAlign: align,
        ),
      ),
    );
  }

  Container currentAddressLine1Cell(
      {required UserDataModel e,
      required double width,
      required double height}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      child: Center(
        child: Text(
            e.currentaddress1 == null ||
                    e.currentaddress1.toString().trim() == 'null'
                ? ''
                : e.currentaddress1.toString().trim(),
            textAlign: align),
      ),
    );
  }

  Text relativeMobileCell({required UserDataModel e}) {
    return Text(
        e.nextofkinphone == null || e.nextofkinphone.toString().trim() == 'null'
            ? ''
            : e.nextofkinphone.toString().trim(),
        textAlign: align);
  }

  Text relationWithFamMemCell({required UserDataModel e}) {
    return Text(
      e.nextofkinrelationwithemployee == null ||
              e.nextofkinrelationwithemployee.toString().trim() == 'null'
          ? ''
          : e.nextofkinrelationwithemployee.toString().trim(),
      textAlign: align,
    );
  }

  Text familyMemberNameCell({required UserDataModel e}) {
    return Text(
        e.nextofkinname == null || e.nextofkinname.toString().trim() == 'null'
            ? ''
            : e.nextofkinname.toString().trim(),
        textAlign: align);
  }

  Text mobileCell({required UserDataModel e}) {
    return Text(
        e.mobile == null || e.mobile.toString().trim() == 'null'
            ? ''
            : e.mobile.toString().trim(),
        textAlign: align);
  }

  Text qualificationCell({required UserDataModel e}) {
    return Text(
        e.qualification == null || e.qualification.toString().trim() == 'null'
            ? ''
            : e.qualification.toString().trim(),
        textAlign: align);
  }

  Text birthdateCell({required UserDataModel e}) {
    return Text(
        e.birthdate == null || e.birthdate.toString().trim() == 'null'
            ? ''
            : DateTime.parse(e.birthdate.toString())
                .toLocal()
                .toString()
                .substring(0, 10),
        textAlign: align);
  }

  Text lastnameCell({required UserDataModel e}) {
    return Text(
        e.lastname == null || e.lastname.toString().trim() == 'null'
            ? ''
            : e.lastname.toString().trim(),
        textAlign: align);
  }

  Text middlenameCell({required UserDataModel e}) {
    return Text(
        e.middlename == null || e.middlename.toString().trim() == 'null'
            ? ''
            : e.middlename.toString().trim(),
        textAlign: align);
  }

  Text firstnameCell({required UserDataModel e}) {
    return Text(
        e.firstname == null || e.firstname.toString().trim() == 'null'
            ? ''
            : e.firstname.toString().trim(),
        textAlign: align);
  }

  Text honorificCell({required UserDataModel e}) {
    return Text(
        e.honorific == null || e.honorific.toString().trim() == 'null'
            ? ''
            : e.honorific.toString().trim(),
        textAlign: align);
  }

  TextAlign get align => TextAlign.center;

  StreamBuilder<String> dateOfLeavingWidget({required UserDataModel e}) {
    return StreamBuilder<String>(
        stream: dateOfLeaving.stream,
        builder: (context, dateOfLeavingSnapshot) {
          return TextFormField(
            controller: TextEditingController(
                text: dateOfLeavingSnapshot.data != null &&
                        dateOfLeavingSnapshot.data != ''
                    ? DateTime.parse(dateOfLeavingSnapshot.data.toString())
                        .toLocal()
                        .toString()
                        .substring(0, 10)
                    : e.dateofleaving == null ||
                            e.dateofleaving.toString().trim() == 'null'
                        ? ''
                        : DateTime.parse(e.dateofleaving.toString())
                            .toLocal()
                            .toString()
                            .substring(0, 10)),
            readOnly: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
            onTap: () async {
              DateTime? pickedDate = await QuickFixUi().dateTimePicker(context);
              if (pickedDate != null) {
                dateOfLeaving.add(pickedDate.toString());
              } else {
                return QuickFixUi.errorMessage('Please select date', context);
              }
            },
          );
        });
  }

  StreamBuilder<String> dateOfJoiningWidget({required UserDataModel e}) {
    return StreamBuilder<String>(
        stream: dateOfJoining.stream,
        builder: (context, dateOfJoiningSnapshot) {
          return TextFormField(
            controller: TextEditingController(
                text: dateOfJoiningSnapshot.data != null &&
                        dateOfJoiningSnapshot.data != ''
                    ? DateTime.parse(dateOfJoiningSnapshot.data.toString())
                        .toLocal()
                        .toString()
                        .substring(0, 10)
                    : e.dateofjoining == null ||
                            e.dateofjoining.toString().trim() == 'null'
                        ? ''
                        : DateTime.parse(e.dateofjoining.toString())
                            .toLocal()
                            .toString()
                            .substring(0, 10)),
            readOnly: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
            onTap: () async {
              DateTime? pickedDate = await QuickFixUi().dateTimePicker(context);
              if (pickedDate != null) {
                dateOfJoining.add(pickedDate.toString());
              } else {
                return QuickFixUi.errorMessage('Please select date', context);
              }
            },
          );
        });
  }

  TextFormField emailWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: emailId != ''
              ? emailId
              : e.email == null || e.email.toString() == 'null'
                  ? ''
                  : e.email.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        emailId = value.toString();
      },
    );
  }

  TextFormField adharcardNumber({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: aadharnumber != ''
              ? aadharnumber
              : e.aadharnumber == null ||
                      e.aadharnumber.toString().trim() == 'null'
                  ? ''
                  : e.aadharnumber.toString().trim()),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        aadharnumber = value.toString();
      },
    );
  }

  TextFormField pancardNumber({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: pannumber != ''
              ? pannumber
              : e.pannumber == null || e.pannumber.toString().trim() == 'null'
                  ? ''
                  : e.pannumber.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        pannumber = value.toString();
      },
    );
  }

  TextFormField familyPFWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: familyPfNumber != ''
              ? familyPfNumber
              : e.fpfnumber == null || e.fpfnumber.toString().trim() == 'null'
                  ? ''
                  : e.fpfnumber.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        familyPfNumber = value.toString();
      },
    );
  }

  TextFormField employeePFWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: employeePfNumber != ''
              ? employeePfNumber
              : e.epfnumber == null || e.epfnumber.toString().trim() == 'null'
                  ? ''
                  : e.epfnumber.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        employeePfNumber = value.toString();
      },
    );
  }

  TextFormField bankIFSCCodeWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: bankifsccode != ''
              ? bankifsccode
              : e.bankifsccode == null ||
                      e.bankifsccode.toString().trim() == 'null'
                  ? ''
                  : e.bankifsccode.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        bankifsccode = value.toString();
      },
    );
  }

  TextFormField banknameWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: bankname != ''
              ? bankname.toUpperCase()
              : e.bankname == null || e.bankname.toString().trim() == 'null'
                  ? ''
                  : e.bankname.toString().trim().toUpperCase()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        bankname = value.toString().toUpperCase();
      },
    );
  }

  TextFormField bankAccountNumber({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: bankaccountnumber != ''
              ? bankaccountnumber
              : e.bankaccountnumber == null ||
                      e.bankaccountnumber.toString() == 'null'
                  ? ''
                  : e.bankaccountnumber.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        bankaccountnumber = value.toString();
      },
    );
  }

  DropdownSearch<StateModel> permanentStateWidget(
      {required UpdateEmployee state, required UserDataModel e}) {
    return DropdownSearch<StateModel>(
      items: state.stateList,
      itemAsString: (item) => item.name.toString().toUpperCase(),
      selectedItem: state.stateList
          .where(
            (pstate) =>
                pstate.name.toString().toUpperCase() ==
                (permanentState.name != '' &&
                        permanentState.name != 'null' &&
                        permanentState.name != null
                    ? permanentState.name.toString().toUpperCase()
                    : (e.permanentStateName == null &&
                            e.permanentStateName != '' &&
                            e.permanentStateName.toString().trim() == 'null')
                        ? ''
                        : e.permanentStateName.toString().trim().toUpperCase()),
          )
          .toList()
          .firstOrNull,
      dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          dropdownSearchDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0)))),
      onChanged: (value) {
        permanentState = value!;
      },
    );
  }

  TextFormField permanentPinWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: permanentpin != ''
              ? permanentpin
              : e.permanentpin == null ||
                      e.permanentpin.toString().trim() == 'null'
                  ? ''
                  : e.permanentpin.toString().trim()),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        permanentpin = value.toString();
      },
    );
  }

  DropdownSearch<CityModel> permanentCityWidget(
      {required UpdateEmployee state, required UserDataModel e}) {
    return DropdownSearch<CityModel>(
      items: state.cityList,
      itemAsString: (item) => item.name.toString(),
      selectedItem: state.cityList
          .where(
            (city) =>
                city.name ==
                ((permanentCity.name != '' &&
                        permanentCity.name != 'null' &&
                        permanentCity.name != null)
                    ? permanentCity.name
                    : (e.permanentCityName == null &&
                            e.permanentCityName != '' &&
                            e.permanentCityName.toString().trim() == 'null')
                        ? ''
                        : e.permanentCityName.toString().trim().toUpperCase()),
          )
          .toList()
          .firstOrNull,
      dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          dropdownSearchDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0)))),
      onChanged: (value) {
        permanentCity = value!;
      },
    );
  }

  Container permanentAddressLine2Widget({required UserDataModel e}) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.black.withOpacity(.5))),
      child: TextFormField(
        controller: TextEditingController(
            text: permanentaddress2 != ''
                ? permanentaddress2
                : e.permanentaddress2 == null ||
                        e.permanentaddress2.toString().trim() == 'null'
                    ? ''
                    : e.permanentaddress2.toString().trim()),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) {
          permanentaddress2 = value.toString();
        },
      ),
    );
  }

  Container permanentAddressline1Widget({required UserDataModel e}) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.black.withOpacity(.5))),
      child: TextFormField(
        controller: TextEditingController(
            text: permanentaddress1 != ''
                ? permanentaddress1
                : e.permanentaddress1 == null ||
                        e.permanentaddress1.toString().trim() == 'null'
                    ? ''
                    : e.permanentaddress1.toString().trim()),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) {
          permanentaddress1 = value.toString();
        },
      ),
    );
  }

  DropdownSearch<StateModel> currentStateWidget(
      {required UpdateEmployee state, required UserDataModel e}) {
    return DropdownSearch<StateModel>(
      items: state.stateList,
      itemAsString: (item) => item.name.toString().toUpperCase(),
      selectedItem: state.stateList
          .where(
            (cstate) =>
                cstate.name.toString().toUpperCase() ==
                ((currentState.name != '' &&
                        currentState.name != null &&
                        currentCity.name != 'null')
                    ? currentState.name.toString().toUpperCase()
                    : ((e.currentStateName == null &&
                            e.currentStateName.toString().trim() == 'null')
                        ? ''
                        : e.currentStateName.toString().trim().toUpperCase())),
          )
          .toList()
          .firstOrNull,
      dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          dropdownSearchDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0)))),
      onChanged: (value) {
        currentState = value!;
      },
    );
  }

  TextFormField currentPincodeWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: currentpin != ''
              ? currentpin
              : e.currentpin == null || e.currentpin.toString().trim() == 'null'
                  ? ''
                  : e.currentpin.toString().trim()),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        currentpin = value.toString();
      },
    );
  }

  DropdownSearch<CityModel> currentCityWidget(
      {required UpdateEmployee state, required UserDataModel e}) {
    return DropdownSearch<CityModel>(
      items: state.cityList,
      itemAsString: (item) => item.name.toString(),
      selectedItem: state.cityList
          .where(
            (city) =>
                city.name ==
                ((currentCity.name != '' &&
                        currentCity.name != null &&
                        currentCity.name != 'null')
                    ? currentCity.name
                    : (e.currentCityName == null &&
                            e.currentCityName.toString().trim() == '' &&
                            e.currentCityName.toString().trim() == 'null')
                        ? ''
                        : e.currentCityName.toString().trim()),
          )
          .toList()
          .firstOrNull,
      dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          dropdownSearchDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0)))),
      onChanged: (value) {
        currentCity = value!;
      },
    );
  }

  Container currentAddressLine2Widget({required UserDataModel e}) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.black.withOpacity(.5))),
      child: TextFormField(
        controller: TextEditingController(
            text: currentAddressLine2 != ''
                ? currentAddressLine2
                : e.currentaddress2 == null ||
                        e.currentaddress2.toString().trim() == 'null'
                    ? ''
                    : e.currentaddress2.toString().trim()),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) {
          currentAddressLine2 = value.toString();
        },
      ),
    );
  }

  Container currentAddressLine1Widget({required UserDataModel e}) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.black.withOpacity(.5))),
      child: TextFormField(
        controller: TextEditingController(
            text: currentAddressLine1 != ''
                ? currentAddressLine1
                : e.currentaddress1 == null ||
                        e.currentaddress1.toString().trim() == 'null'
                    ? ''
                    : e.currentaddress1.toString().trim()),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) {
          currentAddressLine1 = value.toString();
        },
      ),
    );
  }

  TextFormField relativeMobileNumberWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: relativeMobileNumber != ''
              ? relativeMobileNumber
              : e.nextofkinphone == null ||
                      e.nextofkinphone.toString().trim() == 'null'
                  ? ''
                  : e.nextofkinphone.toString().trim()),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        relativeMobileNumber = value.toString();
      },
    );
  }

  TextFormField relationWithFamilyMemeberWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: relationWithFamilyMember != ''
              ? relationWithFamilyMember
              : e.nextofkinrelationwithemployee == null ||
                      e.nextofkinrelationwithemployee.toString().trim() ==
                          'null'
                  ? ''
                  : e.nextofkinrelationwithemployee.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        relationWithFamilyMember = value.toString();
      },
    );
  }

  TextFormField familymembernameWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: familyMemberName != ''
              ? familyMemberName
              : e.nextofkinname == null ||
                      e.nextofkinname.toString().trim() == 'null'
                  ? ''
                  : e.nextofkinname.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        familyMemberName = value.toString();
      },
    );
  }

  TextFormField mobileWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
        text: mobile != ''
            ? mobile
            : e.mobile == null || e.mobile.toString().trim() == 'null'
                ? ''
                : e.mobile.toString().trim(),
      ),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        mobile = value.toString();
      },
    );
  }

  TextFormField qualificationWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: qualification != ''
              ? qualification
              : e.qualification == null ||
                      e.qualification.toString().trim() == 'null'
                  ? ''
                  : e.qualification.toString().trim()),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        qualification = value.toString();
      },
    );
  }

  StreamBuilder<String> birthdateWidget({required UserDataModel e}) {
    return StreamBuilder<String>(
        stream: dateOfBirth.stream,
        builder: (context, dateOfBirthSnapshot) {
          return TextFormField(
            controller: TextEditingController(
                text: dateOfBirthSnapshot.data != null &&
                        dateOfBirthSnapshot.data != ''
                    ? DateTime.parse(dateOfBirthSnapshot.data.toString())
                        .toLocal()
                        .toString()
                        .substring(0, 10)
                    : e.birthdate == null ||
                            e.birthdate.toString().trim() == 'null'
                        ? ''
                        : DateTime.parse(e.birthdate.toString())
                            .toLocal()
                            .toString()
                            .substring(0, 10)),
            readOnly: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
            onTap: () async {
              DateTime? pickedDate = await QuickFixUi().dateTimePicker(context);
              if (pickedDate != null) {
                if (DateTime.now().difference(pickedDate).inDays ~/ 365 < 18) {
                  return QuickFixUi.errorMessage(ageValidationMessage, context);
                } else {
                  dateOfBirth.add(pickedDate.toString());
                }
              } else {
                return QuickFixUi.errorMessage('Please select date', context);
              }
            },
          );
        });
  }

  TextFormField lastnameWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: lastname != ''
              ? lastname
              : e.lastname == null || e.lastname.toString().trim() == 'null'
                  ? ''
                  : e.lastname),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        lastname = value.toString();
      },
    );
  }

  TextFormField middlenameWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: middlename != ''
              ? middlename
              : e.middlename == null || e.middlename.toString().trim() == 'null'
                  ? ''
                  : e.middlename),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        middlename = value.toString();
      },
    );
  }

  TextFormField firstnameWidget({required UserDataModel e}) {
    return TextFormField(
      controller: TextEditingController(
          text: firstname != ''
              ? firstname
              : e.firstname == null || e.firstname.toString().trim() == 'null'
                  ? ''
                  : e.firstname),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: (value) {
        firstname = value;
      },
    );
  }

  DropdownSearch<String> honorificWidget({required UserDataModel e}) {
    return DropdownSearch<String>(
      items: EmployeeWidgets().honorificlist,
      selectedItem: honorific != ''
          ? honorific
          : e.honorific.toString().trim() == '' ||
                  e.honorific.toString().trim() == 'null'
              ? ''
              : e.honorific,
      dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          dropdownSearchDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0)))),
      onChanged: (value) {
        honorific = value.toString();
      },
    );
  }

  IconButton panButton(
      {required UserDataModel e,
      required UpdateEmployee state,
      required BuildContext context,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return IconButton(
        onPressed: () async {
          Map<String, dynamic> panResponse = {};
          ImageProvider<Object>? pan;
          dynamic pandata;
          pandata = await EmployeeDetailsUpdateRepo()
              .viewPan(id: e.pancardmdocid.toString(), token: state.token);
          if (pandata != null && pandata != 500.toString()) {
            Uint8List profileData = pandata;
            pan = MemoryImage(profileData);
          }
          return showPan(
              context: context,
              panController: panController,
              pandata: pandata,
              pan: pan,
              panid: panid,
              panResponse: panResponse,
              state: state,
              e: e,
              blocProvider: blocProvider);
        },
        icon: buttonIcon(
            icon: e.pancardmdocid == null ||
                    e.pancardmdocid.toString().trim() == 'null' ||
                    e.pancardmdocid.toString().trim() == ''
                ? Icons.upload_file_rounded
                : Icons.remove_red_eye));
  }

  Future<void> showPan(
      {required BuildContext context,
      required StreamController<ImageProvider<Object>> panController,
      required pandata,
      required ImageProvider<Object>? pan,
      required StreamController<String> panid,
      required Map<String, dynamic> panResponse,
      required UpdateEmployee state,
      required UserDataModel e,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder<ImageProvider<Object>>(
              stream: panController.stream,
              builder: (context, imageRefreshsnapshot) {
                return AlertDialog(
                  alignment: Alignment.centerLeft,
                  content: SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: ((pandata != null && pandata != 500.toString()) ||
                              imageRefreshsnapshot.data != null)
                          ? Image(
                              image: imageRefreshsnapshot.data == null
                                  ? pan!
                                  : imageRefreshsnapshot.data!)
                          : documentDefaultMessage(
                              message: 'Pan card is not available.')),
                  actions: [
                    StreamBuilder<String>(
                        stream: panid.stream,
                        builder: (context, panSnapshot) {
                          return Center(
                              child: ElevatedButton.icon(
                            label: Text(((pandata != null &&
                                        pandata != 500.toString()) ||
                                    imageRefreshsnapshot.data != null)
                                ? 'Change'
                                : 'Upload'),
                            icon: Icon(
                              Icons.cloud_upload,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              final picker = ImagePicker();
                              panImagePicker(
                                  context: context,
                                  picker: picker,
                                  pandata: pandata,
                                  imageRefreshsnapshot: imageRefreshsnapshot,
                                  panResponse: panResponse,
                                  state: state,
                                  panSnapshot: panSnapshot,
                                  e: e,
                                  pan: pan,
                                  panController: panController,
                                  blocProvider: blocProvider,
                                  panid: panid);
                            },
                          ));
                        })
                  ],
                );
              });
        });
  }

  Future<dynamic> panImagePicker(
      {required BuildContext context,
      required ImagePicker picker,
      required pandata,
      required AsyncSnapshot<ImageProvider<Object>> imageRefreshsnapshot,
      required Map<String, dynamic> panResponse,
      required UpdateEmployee state,
      required AsyncSnapshot<String> panSnapshot,
      required UserDataModel e,
      required ImageProvider<Object>? pan,
      required StreamController<ImageProvider<Object>> panController,
      required UpdateEmployeeDetailsBloc blocProvider,
      required StreamController<String> panid}) {
    return showDialog(
        context: context,
        builder: (imagePickerContext) {
          return AlertDialog(
              alignment: Alignment.centerLeft,
              insetPadding: const EdgeInsets.only(top: 550, left: 220),
              content: SizedBox(
                  width: imagePickerIconSize,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: imagePickerIconSize,
                          height: imagePickerIconSize,
                          decoration:
                              pickerContainerDecoration(context: context),
                          child: IconButton(
                              onPressed: () async {
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.camera);
                                await updatePan(
                                    pickedFile: pickedFile,
                                    context: context,
                                    pandata: pandata,
                                    imageRefreshsnapshot: imageRefreshsnapshot,
                                    panResponse: panResponse,
                                    state: state,
                                    panSnapshot: panSnapshot,
                                    e: e,
                                    pan: pan,
                                    panController: panController,
                                    blocProvider: blocProvider,
                                    panid: panid);
                              },
                              icon: imagePickerIcon(
                                  icon: Icons.camera_alt_rounded)),
                        ),
                        horizontalSpace(),
                        Container(
                            width: imagePickerIconSize,
                            height: imagePickerIconSize,
                            decoration:
                                pickerContainerDecoration(context: context),
                            child: IconButton(
                                onPressed: () async {
                                  final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  await updatePan(
                                      pickedFile: pickedFile,
                                      context: context,
                                      pandata: pandata,
                                      imageRefreshsnapshot:
                                          imageRefreshsnapshot,
                                      panResponse: panResponse,
                                      state: state,
                                      panSnapshot: panSnapshot,
                                      e: e,
                                      pan: pan,
                                      panController: panController,
                                      blocProvider: blocProvider,
                                      panid: panid);
                                },
                                icon: imagePickerIcon(icon: Icons.image)))
                      ])));
        });
  }

  Future<void> updatePan(
      {required XFile? pickedFile,
      required BuildContext context,
      required pandata,
      required AsyncSnapshot<ImageProvider<Object>> imageRefreshsnapshot,
      required Map<String, dynamic> panResponse,
      required UpdateEmployee state,
      required AsyncSnapshot<String> panSnapshot,
      required UserDataModel e,
      required ImageProvider<Object>? pan,
      required StreamController<ImageProvider<Object>> panController,
      required UpdateEmployeeDetailsBloc blocProvider,
      required StreamController<String> panid}) async {
    if (pickedFile != null) {
      File? croppedfile = await ImageUtility()
          .cropImage(pickedFile: pickedFile, context: context);
      QuickFixUi().showProcessing(context: context);
      if (((pandata != null && pandata != 500.toString()) ||
          imageRefreshsnapshot.data != null)) {
        panResponse = await EmployeeDetailsUpdateRepo().updatePancard(
            token: state.token,
            id: panSnapshot.data == null
                ? e.pancardmdocid.toString()
                : panSnapshot.data!,
            profile: croppedfile!);
        if (panResponse['message'] == 'Record updated successfully.') {
          await retriveUpdatedPancard(
              pandata: pandata,
              panResponse: panResponse,
              state: state,
              context: context,
              pan: pan,
              panController: panController,
              blocProvider: blocProvider);
        }
      } else {
        panResponse =
            await UserRegistrationRepository().registerPanCard(documentsData: {
          'emp_name': '${e.firstname} ${e.middlename} ${e.lastname}',
          'emp_id': e.id,
          'pancard': croppedfile!.path,
        }, token: state.token);

        if (panResponse['message'] == 'Record inserted successfully.') {
          panid.add(panResponse['id'].toString());
          final docResponse = await UserRegistrationRepository()
              .documentsRegistration(token: state.token, payload: {
            'id': e.id,
            'profile': e.empprofilemdocid ?? '',
            'pancard': panResponse['id'].toString(),
            'adharcard': e.adharcardmdocid ?? ''
          });
          if (docResponse == 'Updated successfully') {
            await retriveUpdatedPancard(
                pandata: pandata,
                panResponse: panResponse,
                state: state,
                context: context,
                pan: pan,
                panController: panController,
                blocProvider: blocProvider);
          }
        }
      }
    }
  }

  Future<void> retriveUpdatedPancard(
      {required pandata,
      required Map<String, dynamic> panResponse,
      required UpdateEmployee state,
      required BuildContext context,
      required ImageProvider<Object>? pan,
      required StreamController<ImageProvider<Object>> panController,
      required UpdateEmployeeDetailsBloc blocProvider}) async {
    pandata = await EmployeeDetailsUpdateRepo()
        .viewPan(id: panResponse['id'].toString(), token: state.token);
    Navigator.of(context).pop();
    if (pandata != null && pandata != 500.toString()) {
      Uint8List profileData = pandata;
      pan = MemoryImage(profileData);
    }
    panController.add(pan!);
    blocProvider.add(GetEmployeeDetailsForUpdate());
    Navigator.of(context).pop();
  }

  IconButton aadharButton(
      {required UserDataModel e,
      required UpdateEmployee state,
      required BuildContext context,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return IconButton(
        onPressed: () async {
          Map<String, dynamic> aadharResponse = {};

          ImageProvider<Object>? aadhar;
          dynamic aadhardata;
          aadhardata = await EmployeeDetailsUpdateRepo()
              .viewAadhar(id: e.adharcardmdocid.toString(), token: state.token);
          if (aadhardata != null && aadhardata != 500.toString()) {
            Uint8List profileData = aadhardata;
            aadhar = MemoryImage(profileData);
          }
          showAadhar(
              context: context,
              aadharController: aadharController,
              aadhardata: aadhardata,
              aadhar: aadhar,
              aadharid: aadharid,
              aadharResponse: aadharResponse,
              state: state,
              e: e,
              blocProvider: blocProvider);
        },
        icon: buttonIcon(
            icon: e.adharcardmdocid == null ||
                    e.adharcardmdocid.toString().trim() == 'null' ||
                    e.adharcardmdocid.toString().trim() == ''
                ? Icons.upload_file_rounded
                : Icons.remove_red_eye));
  }

  Future<dynamic> showAadhar(
      {required BuildContext context,
      required StreamController<ImageProvider<Object>> aadharController,
      required aadhardata,
      required ImageProvider<Object>? aadhar,
      required StreamController<String> aadharid,
      required Map<String, dynamic> aadharResponse,
      required UpdateEmployee state,
      required UserDataModel e,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder<ImageProvider<Object>>(
              stream: aadharController.stream,
              builder: (context, imageRefreshsnapshot) {
                return AlertDialog(
                  alignment: Alignment.centerLeft,
                  content: SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: ((aadhardata != null &&
                                  aadhardata != 500.toString()) ||
                              imageRefreshsnapshot.data != null)
                          ? Image(
                              image: imageRefreshsnapshot.data == null
                                  ? aadhar!
                                  : imageRefreshsnapshot.data!)
                          : documentDefaultMessage(
                              message: 'Aadhar card is not available.')),
                  actions: [
                    StreamBuilder<String>(
                        stream: aadharid.stream,
                        builder: (context, aadharSnapshot) {
                          return Center(
                              child: ElevatedButton.icon(
                            label: Text(((aadhardata != null &&
                                        aadhardata != 500.toString()) ||
                                    imageRefreshsnapshot.data != null)
                                ? 'Change'
                                : 'Upload'),
                            icon: Icon(
                              Icons.cloud_upload,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              final picker = ImagePicker();
                              aadharImagePicker(
                                  context: context,
                                  picker: picker,
                                  aadhardata: aadhardata,
                                  aadharResponse: aadharResponse,
                                  state: state,
                                  aadharSnapshot: aadharSnapshot,
                                  e: e,
                                  aadhar: aadhar,
                                  aadharController: aadharController,
                                  blocProvider: blocProvider,
                                  aadharid: aadharid,
                                  imageRefreshsnapshot: imageRefreshsnapshot);
                            },
                          ));
                        })
                  ],
                );
              });
        });
  }

  double get imageSize => 600;

  Center documentDefaultMessage({required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black.withOpacity(.4),
                fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.cloud_upload,
            size: 50,
            color: Colors.black.withOpacity(.4),
          )
        ],
      ),
    );
  }

  Future<dynamic> aadharImagePicker(
      {required BuildContext context,
      required ImagePicker picker,
      required aadhardata,
      required Map<String, dynamic> aadharResponse,
      required UpdateEmployee state,
      required AsyncSnapshot<String> aadharSnapshot,
      required UserDataModel e,
      required ImageProvider<Object>? aadhar,
      required StreamController<ImageProvider<Object>> aadharController,
      required UpdateEmployeeDetailsBloc blocProvider,
      required StreamController<String> aadharid,
      required AsyncSnapshot<ImageProvider<Object>> imageRefreshsnapshot}) {
    return showDialog(
        context: context,
        builder: (imagePickerContext) {
          return AlertDialog(
              alignment: Alignment.centerLeft,
              insetPadding: const EdgeInsets.only(top: 550, left: 220),
              content: SizedBox(
                  width: imagePickerIconSize,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: imagePickerIconSize,
                          height: imagePickerIconSize,
                          decoration:
                              pickerContainerDecoration(context: context),
                          child: IconButton(
                              onPressed: () async {
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.camera);
                                await updateAadhar(
                                    pickedFile: pickedFile,
                                    context: context,
                                    aadhardata: aadhardata,
                                    aadharResponse: aadharResponse,
                                    state: state,
                                    aadharSnapshot: aadharSnapshot,
                                    e: e,
                                    aadhar: aadhar,
                                    aadharController: aadharController,
                                    blocProvider: blocProvider,
                                    aadharid: aadharid,
                                    imageRefreshsnapshot: imageRefreshsnapshot);
                              },
                              icon: imagePickerIcon(
                                  icon: Icons.camera_alt_rounded)),
                        ),
                        horizontalSpace(),
                        Container(
                            width: imagePickerIconSize,
                            height: imagePickerIconSize,
                            decoration:
                                pickerContainerDecoration(context: context),
                            child: IconButton(
                                onPressed: () async {
                                  final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  await updateAadhar(
                                      pickedFile: pickedFile,
                                      context: context,
                                      aadhardata: aadhardata,
                                      aadharResponse: aadharResponse,
                                      state: state,
                                      aadharSnapshot: aadharSnapshot,
                                      e: e,
                                      aadhar: aadhar,
                                      aadharController: aadharController,
                                      blocProvider: blocProvider,
                                      aadharid: aadharid,
                                      imageRefreshsnapshot:
                                          imageRefreshsnapshot);
                                },
                                icon: imagePickerIcon(icon: Icons.image)))
                      ])));
        });
  }

  Future<void> updateAadhar(
      {required XFile? pickedFile,
      required BuildContext context,
      required aadhardata,
      required Map<String, dynamic> aadharResponse,
      required UpdateEmployee state,
      required AsyncSnapshot<String> aadharSnapshot,
      required UserDataModel e,
      required ImageProvider<Object>? aadhar,
      required StreamController<ImageProvider<Object>> aadharController,
      required UpdateEmployeeDetailsBloc blocProvider,
      required StreamController<String> aadharid,
      required AsyncSnapshot<ImageProvider<Object>>
          imageRefreshsnapshot}) async {
    if (pickedFile != null) {
      File? croppedfile = await ImageUtility()
          .cropImage(pickedFile: pickedFile, context: context);
      QuickFixUi().showProcessing(context: context);
      if (((aadhardata != null && aadhardata != 500.toString()) ||
          imageRefreshsnapshot.data != null)) {
        aadharResponse = await EmployeeDetailsUpdateRepo().updateAadharcard(
            token: state.token,
            id: aadharSnapshot.data == null
                ? e.adharcardmdocid.toString()
                : aadharSnapshot.data!,
            profile: croppedfile!);
        if (aadharResponse['message'] == 'Record updated successfully.') {
          await retriveUpdatedAadharcard(
              aadhardata: aadhardata,
              aadharResponse: aadharResponse,
              state: state,
              context: context,
              aadhar: aadhar,
              aadharController: aadharController,
              blocProvider: blocProvider);
        }
      } else {
        aadharResponse = await UserRegistrationRepository()
            .registerAadharCard(documentsData: {
          'emp_name': '${e.firstname} ${e.middlename} ${e.lastname}',
          'emp_id': e.id,
          'adharcard': croppedfile!.path,
        }, token: state.token);
        if (aadharResponse['message'] == 'Record inserted successfully.') {
          aadharid.add(aadharResponse['id'].toString());
          final docResponse = await UserRegistrationRepository()
              .documentsRegistration(token: state.token, payload: {
            'id': e.id,
            'profile': e.empprofilemdocid ?? '',
            'pancard': e.pancardmdocid ?? '',
            'adharcard': aadharResponse['id'].toString()
          });
          if (docResponse == 'Updated successfully') {
            await retriveUpdatedAadharcard(
                aadhardata: aadhardata,
                aadharResponse: aadharResponse,
                state: state,
                context: context,
                aadhar: aadhar,
                aadharController: aadharController,
                blocProvider: blocProvider);
          }
        }
      }
    }
  }

  Future<void> retriveUpdatedAadharcard(
      {required aadhardata,
      required Map<String, dynamic> aadharResponse,
      required UpdateEmployee state,
      required BuildContext context,
      required ImageProvider<Object>? aadhar,
      required StreamController<ImageProvider<Object>> aadharController,
      required UpdateEmployeeDetailsBloc blocProvider}) async {
    aadhardata = await EmployeeDetailsUpdateRepo()
        .viewAadhar(id: aadharResponse['id'].toString(), token: state.token);

    Navigator.of(context).pop();
    if (aadhardata != null && aadhardata != 500.toString()) {
      Uint8List profileData = aadhardata;
      aadhar = MemoryImage(profileData);
    }
    aadharController.add(aadhar!);
    blocProvider.add(GetEmployeeDetailsForUpdate());
    Navigator.of(context).pop();
  }

  IconButton profileButton(
      {required UserDataModel e,
      required UpdateEmployee state,
      required BuildContext context,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return IconButton(
        onPressed: () async {
          StreamController<ImageProvider<Object>> profile =
              StreamController<ImageProvider<Object>>.broadcast();
          ImageProvider<Object> employeeProfile;
          Map<String, dynamic> profileResponse = {};
          StreamController<String> profileid =
              StreamController<String>.broadcast();
          dynamic profdata = await UserLoginRepository()
              .employeeProfile(e.empprofilemdocid.toString(), state.token);
          if (profdata != null && profdata != 500.toString()) {
            Uint8List profileData = profdata;
            employeeProfile = MemoryImage(profileData);
          } else {
            employeeProfile = const AssetImage('assets/icon/emp.png');
          }
          profile.add(employeeProfile);
          showProfile(
              context: context,
              profile: profile,
              employeeProfile: employeeProfile,
              profileid: profileid,
              profdata: profdata,
              profileResponse: profileResponse,
              state: state,
              e: e,
              blocProvider: blocProvider);
        },
        icon: buttonIcon(icon: Icons.account_circle));
  }

  Icon buttonIcon({required IconData icon}) => Icon(
        icon,
        color: Theme.of(context).primaryColorDark,
      );

  Future<dynamic> showProfile(
      {required BuildContext context,
      required StreamController<ImageProvider<Object>> profile,
      required ImageProvider<Object> employeeProfile,
      required StreamController<String> profileid,
      required profdata,
      required Map<String, dynamic> profileResponse,
      required UpdateEmployee state,
      required UserDataModel e,
      required UpdateEmployeeDetailsBloc blocProvider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.centerLeft,
            content: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: StreamBuilder<ImageProvider<Object>>(
                          stream: profile.stream,
                          builder: (context, snapshot) {
                            return CircleAvatar(
                              backgroundImage: snapshot.data ?? employeeProfile,
                            );
                          }),
                    ),
                  ),
                  StreamBuilder<String>(
                      stream: profileid.stream,
                      builder: (context, profileidsnapshot) {
                        return Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              final picker = ImagePicker();
                              profileImagePickerDialog(
                                  context: context,
                                  picker: picker,
                                  profdata: profdata,
                                  profileResponse: profileResponse,
                                  state: state,
                                  profileidsnapshot: profileidsnapshot,
                                  e: e,
                                  employeeProfile: employeeProfile,
                                  profile: profile,
                                  blocProvider: blocProvider,
                                  profileid: profileid);
                            },
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(
                                Icons.edit_square,
                                color: AppColors.whiteTheme,
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> profileImagePickerDialog(
      {required BuildContext context,
      required ImagePicker picker,
      required profdata,
      required Map<String, dynamic> profileResponse,
      required UpdateEmployee state,
      required AsyncSnapshot<String> profileidsnapshot,
      required UserDataModel e,
      required ImageProvider<Object> employeeProfile,
      required StreamController<ImageProvider<Object>> profile,
      required UpdateEmployeeDetailsBloc blocProvider,
      required StreamController<String> profileid}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.centerLeft,
            insetPadding: const EdgeInsets.only(top: 290, left: 40),
            content: SizedBox(
              width: imagePickerIconSize,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: imagePickerIconSize,
                    height: imagePickerIconSize,
                    decoration: pickerContainerDecoration(context: context),
                    child: IconButton(
                        onPressed: () async {
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.camera);
                          await updateProfile(
                              pickedFile: pickedFile,
                              context: context,
                              profdata: profdata,
                              profileResponse: profileResponse,
                              state: state,
                              profileidsnapshot: profileidsnapshot,
                              e: e,
                              employeeProfile: employeeProfile,
                              profile: profile,
                              blocProvider: blocProvider,
                              profileid: profileid);
                        },
                        icon: imagePickerIcon(icon: Icons.camera_alt_rounded)),
                  ),
                  horizontalSpace(),
                  Container(
                      width: imagePickerIconSize,
                      height: imagePickerIconSize,
                      decoration: pickerContainerDecoration(context: context),
                      child: IconButton(
                          onPressed: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            await updateProfile(
                                pickedFile: pickedFile,
                                context: context,
                                profdata: profdata,
                                profileResponse: profileResponse,
                                state: state,
                                profileidsnapshot: profileidsnapshot,
                                e: e,
                                employeeProfile: employeeProfile,
                                profile: profile,
                                blocProvider: blocProvider,
                                profileid: profileid);
                          },
                          icon: imagePickerIcon(icon: Icons.image)))
                ],
              ),
            ),
          );
        });
  }

  double get imagePickerIconSize => 50;

  SizedBox horizontalSpace() => const SizedBox(width: 10);

  Icon imagePickerIcon({required IconData icon}) {
    return Icon(
      icon,
      color: AppColors.whiteTheme,
    );
  }

  BoxDecoration pickerContainerDecoration({required BuildContext context}) {
    return BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(50));
  }

  Future<void> updateProfile(
      {required XFile? pickedFile,
      required BuildContext context,
      required profdata,
      required Map<String, dynamic> profileResponse,
      required UpdateEmployee state,
      required AsyncSnapshot<String> profileidsnapshot,
      required UserDataModel e,
      required ImageProvider<Object> employeeProfile,
      required StreamController<ImageProvider<Object>> profile,
      required UpdateEmployeeDetailsBloc blocProvider,
      required StreamController<String> profileid}) async {
    if (pickedFile != null) {
      File? croppedfile = await ImageUtility()
          .cropImage(pickedFile: pickedFile, context: context);
      QuickFixUi().showProcessing(context: context);

      if (profdata != null && profdata != 500.toString()) {
        profileResponse = await EmployeeDetailsUpdateRepo()
            .updateEmployeeProfile(
                token: state.token,
                id: profileidsnapshot.data == null
                    ? e.empprofilemdocid.toString()
                    : profileidsnapshot.data!,
                profile: croppedfile!);

        if (profileResponse['message'] == 'Record updated successfully.') {
          profdata = await retriveUpdatedProfile(
              profileResponse: profileResponse,
              state: state,
              context: context,
              employeeProfile: employeeProfile,
              profile: profile,
              blocProvider: blocProvider);
        }
      } else {
        profileResponse = await UserRegistrationRepository()
            .registerEmployeeProfile(documentsData: {
          'emp_name': '${e.firstname} ${e.middlename} ${e.lastname}',
          'emp_id': e.id,
          'emp_profile': croppedfile!.path,
        }, token: state.token);
        if (profileResponse['message'] == 'Record inserted successfully.') {
          profileid.add(profileResponse['id'].toString());
          final docResponse = await UserRegistrationRepository()
              .documentsRegistration(token: state.token, payload: {
            'id': e.id,
            'profile': profileResponse['id'].toString(),
            'pancard': e.pancardmdocid ?? '',
            'adharcard': e.adharcardmdocid ?? ''
          });
          if (docResponse == 'Updated successfully') {
            profdata = await retriveUpdatedProfile(
                profileResponse: profileResponse,
                state: state,
                context: context,
                employeeProfile: employeeProfile,
                profile: profile,
                blocProvider: blocProvider);
          }
        }
      }
    }
  }

  retriveUpdatedProfile(
      {required Map<String, dynamic> profileResponse,
      required UpdateEmployee state,
      required BuildContext context,
      required ImageProvider<Object> employeeProfile,
      required StreamController<ImageProvider<Object>> profile,
      required UpdateEmployeeDetailsBloc blocProvider}) async {
    dynamic profdata = await UserLoginRepository()
        .employeeProfile(profileResponse['id'].toString(), state.token);
    Navigator.of(context).pop();
    if (profdata != null && profdata != 500.toString()) {
      Uint8List profileData = profdata;
      employeeProfile = MemoryImage(profileData);
    } else {
      employeeProfile = const AssetImage('assets/icon/emp.png');
    }
    profile.add(employeeProfile);
    blocProvider.add(GetEmployeeDetailsForUpdate());
    Navigator.of(context).pop();
    return profdata;
  }

  SizedBox emptySizedbox() => const SizedBox(width: .1, height: .1);

  TextStyle footerButtonStyle(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark);
  }

  Text buttonName({required BuildContext context, required String text}) {
    return Text(
      text,
      style: TextStyle(color: Theme.of(context).primaryColorDark),
    );
  }
}
