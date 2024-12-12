import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/model/po/po_models.dart';
import '../../../../../services/repository/outsource/outsource_repository.dart';

part 'inward_event.dart';
part 'inward_state.dart';

class InwardBloc extends Bloc<InwardEvent, InwardState> {
  InwardBloc() : super(const InwardInitial(inwardList: [], check: false)) {
    on<InwardListLoadEvent>((event, emit) async {
      List<InwardChallan> inwardList = await OutsourceRepository.getInwardList(
          subcontractorId: event.subcontractorid);
      emit(InwardListLoadedState(inwardList: inwardList, check: false));
    });

    on<InwardSaveEvent>((event, emit) async {
      await OutsourceRepository.saveInwardChallan(
          inwardchallan: event.inwardData,
          qty: event.qty,
          status: event.status);
      List<InwardChallan> inwardList = await OutsourceRepository.getInwardList(
          subcontractorId: event.subcontractorid);
      emit(InwardListLoadedState(inwardList: inwardList, check: false));
      // emit(InwardListLoadedState(inwardList: inwardList));
    });

    on<FinishedInwardListLoadEvent>((event, emit) async {
      if (event.check == false) {
        List<InwardChallan> inwardList =
            await OutsourceRepository.getInwardList(
                subcontractorId: event.subcontractorid);
        emit(InwardListLoadedState(inwardList: inwardList, check: false));
      } else {
        List<InwardChallan> inwardList =
            await OutsourceRepository.getFinishedInwardList(
                subcontractorId: event.subcontractorid, check: event.check);
        emit(FinishedInwardState(inwardList: inwardList, check: event.check));
      }
    });
  }
}
