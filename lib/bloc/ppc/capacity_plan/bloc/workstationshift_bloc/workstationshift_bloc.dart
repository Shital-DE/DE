import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/model/capacity_plan/model.dart';
import '../../../../../services/repository/capacity_plan/capacity_plan_repository.dart';

part 'workstationshift_event.dart';
part 'workstationshift_state.dart';

class WorkstationShiftBloc
    extends Bloc<WorkstationShiftEvent, WorkstationShiftState> {
  WorkstationShiftBloc()
      : super(const WorkstationShiftInitial(workcentre: [])) {
    on<WorkstationShiftEvent>((event, emit) async {
      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();
      emit(WorkstationShiftLoadState(
          workcentre: workcentre, workstationshift: const [], total: 0));
    });

    on<GetWorkstationShiftEvent>((event, emit) async {
      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();
      List<WorkstationShift> workstationshift =
          await CapacityPlanRepository.workstationShift(
              workcentreId: event.workcentreId);

      int total = 0;
      workstationshift.map(
        (element) {
          element.checkboxlist!.map((e) {
            if (e.shiftStatus == true) {
              total += e.shiftDuration!;
            }
          }).toList();
        },
      ).toList();

      emit(WorkstationShiftLoadState(
          workcentre: workcentre,
          workstationshift: workstationshift,
          total: total));
    });

    on<SelectShiftEvent>((event, emit) async {
      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();

      String result = await CapacityPlanRepository.selectShift(
          value: event.value, wsStatusId: event.wsStatusId);
      if (result == "Success") {
        List<WorkstationShift> workstationshift =
            await CapacityPlanRepository.workstationShift(
                workcentreId: event.workcentreId);

        int total = 0;
        workstationshift.map(
          (element) {
            element.checkboxlist!.map((e) {
              if (e.shiftStatus == true) {
                total += e.shiftDuration!;
              }
            }).toList();
          },
        ).toList();

        emit(WorkstationShiftLoadState(
            workcentre: workcentre,
            workstationshift: workstationshift,
            total: total));
      }
    });
  }
}
