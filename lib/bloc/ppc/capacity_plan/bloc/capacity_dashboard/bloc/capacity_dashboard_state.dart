part of 'capacity_dashboard_bloc.dart';

abstract class CapacityDashboardState {
  const CapacityDashboardState();
}

class CapacityDashboardInitial extends CapacityDashboardState {}

class CapacityDashboardLoading extends CapacityDashboardState {
  final int selectedIndex;
  final List<String> navigationItemsList;
  CapacityDashboardLoading(
      {required this.selectedIndex, required this.navigationItemsList});
}
