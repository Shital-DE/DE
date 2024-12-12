// Author : Shital Gayakwad
// Created Date : 30 April 2023
// Description : ERPX_PPC -> Subcontractor state

import '../../../services/model/common/city_model.dart';
import '../../../services/model/registration/subcontractor_models.dart';

abstract class SubcontractorRegistrationState {}

class SubcontractorRegistrationInitialState
    extends SubcontractorRegistrationState {
  SubcontractorRegistrationInitialState();
}

class SubcontractorLoadingState extends SubcontractorRegistrationState {
  final List<AllSubContractor> subContractorList;
  final String token;
  final List<CityModel> cityList;
  final Map<String, dynamic> subcontractorData;
  final String address1, address2;
  final bool isCkeckBoxChecked;
  SubcontractorLoadingState(
      {required this.subContractorList,
      required this.token,
      required this.cityList,
      required this.subcontractorData,
      required this.address1,
      required this.address2,
      required this.isCkeckBoxChecked});
}

class SubcontractorErrorState extends SubcontractorRegistrationState {
  final String errorMesssage;
  SubcontractorErrorState(this.errorMesssage);
}
