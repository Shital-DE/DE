import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../services/model/capacity_plan/model.dart';
import '../../../../../services/repository/capacity_plan/capacity_plan_repository.dart';
part 'graph_view_event.dart';
part 'graph_view_state.dart';

class GraphViewBloc extends Bloc<GraphViewEvent, GraphViewState> {
  GraphViewBloc() : super(const GraphViewInitial([])) {
    on<GraphViewInitEvent>((event, emit) async {
      List<CapacityPlanList> cplist =
          await CapacityPlanRepository.getAllCPList();

      emit(GraphViewInitial(cplist));
    });

    on<GraphViewLoadEvent>((event, emit) async {
      List<CapacityPlanList> cplist =
          await CapacityPlanRepository.getAllCPList();

      List<WorkcentreCP> workcentreList =
          await CapacityPlanRepository.getGraphViewCP(event.runnumber);

      List<ShiftTotal> shiftTotalList =
          await CapacityPlanRepository.shiftTotal();

      emit(GraphViewInitial(cplist));
      emit(GraphViewLoadState(
          wclist: workcentreList, cplist, shiftTotal: shiftTotalList));
    });
  }
}
