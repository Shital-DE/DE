import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../services/model/capacity_plan/model.dart';
import '../../../../../services/repository/capacity_plan/capacity_plan_repository.dart';
part 'capacity_plan_event.dart';
part 'capacity_plan_state.dart';

class CapacityPlanBloc extends Bloc<CapacityPlanEvent, CapacityPlanState> {
  CapacityPlanBloc() : super(const CapacityPlanInitial(cplist: [])) {
    on<CheckPreviousCPDateEvent>((event, emit) async {
      String data =
          await CapacityPlanRepository.checkDate(fromDate: event.fromDate);
      if (data != "NotFound") {
        DateTime date = DateTime.parse(data);
        DateTime currentDate = DateTime.parse(event.fromDate);

        if (currentDate.isBefore(date) || currentDate.isAtSameMomentAs(date)) {
          emit(CapacityPlanListState(cplist: event.cpList));
          emit(CheckDateInitial(
              cplist: event.cpList,
              message: "select date after ${date.toString().split(' ')[0]}"));
        } else {
          emit(CapacityPlanListState(cplist: event.cpList));
        }
      }
    });

    on<ToDateGetEvent>((event, emit) async {
      List<CapacityPlanData> list = await CapacityPlanRepository.getCPProducts(
          fromDate: event.fromDate, toDate: event.toDate);

      emit(CapacityPlanListState(cplist: list));
    });

    on<AddNewProductsCPEvent>((event, emit) async {
      List<CapacityPlanData> list =
          await CapacityPlanRepository.addNewCPProducts(
              fromDate: event.fromDate,
              toDate: event.toDate,
              runnumber: event.runnumber);

      emit(CapacityPlanListState(cplist: list));
    });

    on<CpInitialEvent>((event, emit) async {
      emit(const CapacityPlanInitial(cplist: []));
    });

    on<SaveCPEvent>((event, emit) async {
      String result = await CapacityPlanRepository.saveCapacityPlan(
        fromDate: event.fromDate,
        toDate: event.toDate,
        list: event.cpList,
      );

      emit(CapacityPlanSaveState(result: result, cplist: const []));
      emit(const CapacityPlanInitial(cplist: []));
    });

    on<UpdateCPEvent>((event, emit) async {
      String result = await CapacityPlanRepository.updateCapacityPlan(
        fromDate: event.fromDate,
        toDate: event.toDate,
        list: event.cpList,
        runnumber: event.runnumber,
      );

      emit(CapacityPlanSaveState(result: result, cplist: const []));
      emit(const CapacityPlanInitial(cplist: []));
    });
  }
}
