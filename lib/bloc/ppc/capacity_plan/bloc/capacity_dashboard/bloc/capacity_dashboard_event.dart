part of 'capacity_dashboard_bloc.dart';

abstract class CapacityDashboardEvent {
  const CapacityDashboardEvent();
}

class CapacityIndex extends CapacityDashboardEvent {
  final int selectedIndex;
  CapacityIndex({this.selectedIndex = 0});
}
