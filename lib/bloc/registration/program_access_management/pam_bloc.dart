// Author : Shital Gayakwad
// Created Date : 28 May 2024
// Description : Program access management

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/registration/program_access_management_model.dart';
import '../../../services/repository/registration/program_access_management_repo.dart';
import '../../../services/session/user_login.dart';
import 'pam_event.dart';
import 'pam_state.dart';

class ProgramAccessManagementBloc
    extends Bloc<ProgramAccessManagementEvent, ProgramAccessManagementState> {
  ProgramAccessManagementBloc() : super(PAMInitialState()) {
    on<PAMDetailsEvent>((event, emit) async {
      // User data
      final data = await UserData.getUserData(); // token and userdata

      // Program access management
      List<ProgramAccessManagementModel> programAccessManagementData =
          await ProgramAccessManagementRepository()
              .programAccessManagementData(token: data['token'].toString());
      emit(PAMDetailsState(
          programAccessManagementData: programAccessManagementData,
          token: data['token'].toString()));
    });
  }
}
