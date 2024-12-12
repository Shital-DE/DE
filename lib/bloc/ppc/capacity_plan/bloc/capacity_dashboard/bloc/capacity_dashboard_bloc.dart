import 'package:bloc/bloc.dart';
part 'capacity_dashboard_event.dart';
part 'capacity_dashboard_state.dart';

class CapacityDashboardBloc
    extends Bloc<CapacityDashboardEvent, CapacityDashboardState> {
  CapacityDashboardBloc() : super(CapacityDashboardInitial()) {
    on<CapacityIndex>((event, emit) {
      List<String> navigationItemsList = [
        'Dashboard',
        'Workcentre Shift',
        'New CP',
        'CP Execution',
        // 'PO Date Change',
        // 'Update CP',
      ];
      emit(CapacityDashboardLoading(
          selectedIndex: event.selectedIndex,
          navigationItemsList: navigationItemsList));
    });
  }
}
