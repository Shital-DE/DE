// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Machine registration bloc

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/machine/workstation.dart';
import '../../../services/model/registration/machine_registration_model.dart';
import '../../../services/repository/common/tablet_repository.dart';
import '../../../services/repository/machine/machine_registration_repository.dart';
import '../../../services/session/user_login.dart';
part 'machine_register_event.dart';
part 'machine_register_state.dart';

class MachineRegisterBloc
    extends Bloc<MachineRegisterEvent, MachineRegisterState> {
  BuildContext context;
  MachineRegisterBloc(this.context) : super(MachineRegisterLoading()) {
    on<MachineScreenLoadingEvent>((event, emit) async {
      //Token
      String token = await UserData.authorizeToken();

      //Is in house workcentres
      final isinhouseWorkcentresdata =
          await MachineRegistrationRepository().isinhouseallWorkcentres(token);

      //Shift pattern
      final shiftpatternListData =
          await MachineRegistrationRepository().getShiftPattern(token);

      //Company name
      final companyListData =
          await MachineRegistrationRepository().getCompany(token);

      if (isinhouseWorkcentresdata.toString() == 'Server unreachable' ||
          shiftpatternListData.toString() == 'Server unreachable' ||
          companyListData.toString() == 'Server unreachable') {
        emit(MachineErrorState('Server unreachable'));
      } else {
        //Is in house workcentres
        List<IsinHouseWorkcentre> isinhouseWorkcentres =
            isinhouseWorkcentresdata;

        //Shift pattern
        List<ShiftPattern> shiftpatternList = shiftpatternListData;

        //Company name
        List<Company> companyList = companyListData;

        //Work stations by workcentre id
        List<WorkstationByWorkcentreId> workstationsList = [];
        if (event.workcentreid != '') {
          final workstationsListData = await TabletRepository()
              .worstationByWcId(token: token, workcentreId: event.workcentreid);
          workstationsList = workstationsListData;
        }

        //Emitting state
        emit(MachineLoaded(
            event.isAddButtonClicked,
            isinhouseWorkcentres,
            shiftpatternList,
            companyList,
            event.workcentre,
            event.shiftPatternId,
            event.companyId,
            event.companyCode,
            event.defaultmin,
            event.isinhouse,
            token,
            event.isWorkstationVisible,
            event.workcentreid,
            event.index,
            workstationsList,
            event.workstationcode));
      }
    });
  }
}
