// Author : Shital Gayakwad
// Created Date : 30 April 2023
// Description : ERPX_PPC -> Subcontractor bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/common/city_model.dart';
import '../../../services/model/registration/subcontractor_models.dart';
import '../../../services/repository/registration/subcontractor_repository.dart';
import '../../../services/session/user_login.dart';
import 'subcontractor_event.dart';
import 'subcontractor_state.dart';

class SubcontractorRegistrationBloc extends Bloc<SubcontractorRegistrationEvent,
    SubcontractorRegistrationState> {
  SubcontractorRegistrationBloc()
      : super(SubcontractorRegistrationInitialState()) {
    on<SubcontractorRegistrationInitialEvent>((event, emit) async {
      //User data
      final saveddata = await UserData.getUserData();

      //Token
      String token = saveddata['token'].toString();

      //Subcontractor data
      final subContractorData =
          await SubcontractorRepository().allSubcontractor(token: token);

      // City
      final city = await SubcontractorRepository().city(token: token);

      if (subContractorData.toString() == 'Server unreachable' ||
          city.toString() == 'Server unreachable') {
        emit(SubcontractorErrorState('Server unreachable'));
      } else {
        List<AllSubContractor> subContractorList = subContractorData;

        List<CityModel> cityList = city;
        emit(SubcontractorLoadingState(
            subContractorList: subContractorList,
            token: token,
            cityList: cityList,
            subcontractorData: event.subcontractorData,
            address1: event.address1,
            address2: event.address2,
            isCkeckBoxChecked: event.isCkeckBoxChecked));
      }
    });
  }
}
