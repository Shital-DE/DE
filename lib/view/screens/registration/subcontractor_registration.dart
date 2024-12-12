// Author : Shital Gayakwad
// Created Date : 30 April 2023
// Description : ERPX_PPC -> Subcontractor registration

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../bloc/registration/subcontractor_registration/subcontractor_bloc.dart';
import '../../../bloc/registration/subcontractor_registration/subcontractor_event.dart';
import '../../../bloc/registration/subcontractor_registration/subcontractor_state.dart';
import '../../../services/model/common/city_model.dart';
import '../../../services/model/registration/subcontractor_models.dart';
import '../../../services/repository/registration/subcontractor_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../../utils/responsive.dart';
import '../../widgets/appbar.dart';
// import '../common/internet_connection.dart';
import '../common/server.dart';

class SubcontractorRegistration extends StatelessWidget {
  const SubcontractorRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider =
        BlocProvider.of<SubcontractorRegistrationBloc>(context);
    blocProvider.add(SubcontractorRegistrationInitialEvent(
        subcontractorData: const {},
        address1: '',
        address2: '',
        isCkeckBoxChecked: false));
    return
        // InternetConnectionCheck(
        //     widget:
        Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Subcontractor registration'),
      body: MakeMeResponsiveScreen(
        horixontaltab: subcontractorRegistrationForm(blocProvider),
        verticaltab: subcontractorRegistrationForm(blocProvider),
        windows: subcontractorRegistrationForm(blocProvider),
        linux: QuickFixUi.notVisible(),
        mobile: QuickFixUi.notVisible(),
      ),
      // )
    );
  }

  Center subcontractorRegistrationForm(
      SubcontractorRegistrationBloc blocProvider) {
    return Center(
      child: SingleChildScrollView(
        child: BlocBuilder<SubcontractorRegistrationBloc,
            SubcontractorRegistrationState>(builder: (context, state) {
          if (state is SubcontractorRegistrationInitialState) {
            return const CircularProgressIndicator(
              color: AppColors.appTheme,
            );
          } else if (state is SubcontractorErrorState) {
            return Server().serverUnreachable(
                context: context, screenname: 'subcontractorRegistration');
          }
          if (state is SubcontractorLoadingState) {
            return SizedBox(
              width: 450,
              child: Column(
                children: [
                  // const Text(
                  //   'Subcontractor Registration',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  // ),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: DropdownSearch<AllSubContractor>(
                        items: state.subContractorList,
                        itemAsString: (item) => item.name.toString(),
                        popupProps: const PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              style: TextStyle(fontSize: 18),
                            )),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                label: const Text('Select subcontractor'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onChanged: (value) async {
                          blocProvider.add(
                              SubcontractorRegistrationInitialEvent(
                                  subcontractorData: {
                                'id': value!.id.toString(),
                                'name': value.name.toString(),
                                'address1': value.address1.toString(),
                                'address2': value.address2.toString(),
                                'city': value.city.toString(),
                                'companyId': value.companyId.toString()
                              },
                                  address1: '',
                                  address2: '',
                                  isCkeckBoxChecked: false));

                          List<AllSubContractor> subcontractor =
                              await SubcontractorRepository()
                                  .validateSubcontractor(
                                      token: state.token,
                                      id: value.id.toString());
                          if (subcontractor.isNotEmpty) {
                            subcontractorRegistrationValidation(context);
                          } else {}
                        },
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Address line 1',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      maxLines: 4,
                      onChanged: (value) {
                        blocProvider.add(SubcontractorRegistrationInitialEvent(
                            subcontractorData: state.subcontractorData,
                            address1: value.toString(),
                            address2: '',
                            isCkeckBoxChecked: false));
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: state.isCkeckBoxChecked,
                          onChanged: (value) {
                            blocProvider.add(
                                SubcontractorRegistrationInitialEvent(
                                    subcontractorData: state.subcontractorData,
                                    address1: state.address1,
                                    address2: '',
                                    isCkeckBoxChecked: value!));
                          }),
                      const Text('Address line 2 is same as address line 1')
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Address line 2',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      maxLines: 4,
                      controller: TextEditingController(
                          text: state.isCkeckBoxChecked == true
                              ? state.address1
                              : state.address2),
                      onChanged: (value) {
                        blocProvider.add(SubcontractorRegistrationInitialEvent(
                            subcontractorData: state.subcontractorData,
                            address1: state.address1,
                            address2:
                                value.isEmpty ? state.address1 : state.address2,
                            isCkeckBoxChecked: state.isCkeckBoxChecked));
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: DropdownSearch<CityModel>(
                      items: state.cityList,
                      itemAsString: (item) => item.name.toString(),
                      popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            style: TextStyle(fontSize: 18),
                          )),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              label: const Text('Select city'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      onChanged: (value) {
                        blocProvider.add(SubcontractorRegistrationInitialEvent(
                            subcontractorData: state.subcontractorData,
                            address1: state.address1,
                            address2: state.address2,
                            isCkeckBoxChecked: state.isCkeckBoxChecked));
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: FilledButton(
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      onPressed: () async {
                        if (state.subcontractorData['id'] == null) {
                          return QuickFixUi.errorMessage(
                              'Please select subcontractor', context);
                        } else if (state.address1 == '') {
                          return QuickFixUi.errorMessage(
                              'Please fill address line 1', context);
                        } else if (state.address2 == '' &&
                            state.isCkeckBoxChecked == false) {
                          return QuickFixUi.errorMessage(
                              'Please fill address line 2', context);
                        } else {
                          final registerData = await SubcontractorRepository()
                              .registerSubcontractor(
                                  token: state.token,
                                  subcontractorName:
                                      state.subcontractorData['name'],
                                  subcontractorId:
                                      state.subcontractorData['id'],
                                  address1: state.address1,
                                  address2: state.address2 == ''
                                      ? state.address1
                                      : state.address2);
                          if (registerData.toString() ==
                              'Inserted successfully') {
                            return QuickFixUi.successMessage(
                                'Inserted successfully', context);
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Text('');
          }
        }),
      ),
    );
  }

  Future<dynamic> subcontractorRegistrationValidation(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'The subcontractor has already been registered.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: FilledButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
