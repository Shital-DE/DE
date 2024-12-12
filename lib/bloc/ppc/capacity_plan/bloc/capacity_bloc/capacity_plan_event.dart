part of 'capacity_plan_bloc.dart';

abstract class CapacityPlanEvent {}

class CpInitialEvent extends CapacityPlanEvent {
  CpInitialEvent();
}

// class FromDateGetEvent extends CapacityPlanEvent {
//   FromDateGetEvent();
// }

class CheckPreviousCPDateEvent extends CapacityPlanEvent {
  final String fromDate;
  List<CapacityPlanData> cpList;
  CheckPreviousCPDateEvent({required this.fromDate, required this.cpList});
}

class ToDateGetEvent extends CapacityPlanEvent {
  final String fromDate, toDate;
  ToDateGetEvent({required this.fromDate, required this.toDate});
}

class AddNewProductsCPEvent extends CapacityPlanEvent {
  final String fromDate, toDate;
  int runnumber;
  AddNewProductsCPEvent(
      {required this.fromDate, required this.toDate, required this.runnumber});
}

class SaveCPEvent extends CapacityPlanEvent {
  final String fromDate, toDate;
  List<CapacityPlanData> cpList;
  SaveCPEvent(
      {required this.fromDate, required this.toDate, required this.cpList});
}

class UpdateCPEvent extends CapacityPlanEvent {
  final String fromDate, toDate;
  final int runnumber;
  List<CapacityPlanData> cpList;
  UpdateCPEvent(
      {required this.fromDate,
      required this.toDate,
      required this.runnumber,
      required this.cpList});
}
