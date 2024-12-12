part of 'workstationshift_bloc.dart';

abstract class WorkstationShiftEvent {
  const WorkstationShiftEvent();
}

class GetWorkcentreEvent extends WorkstationShiftEvent {}

class GetWorkstationShiftEvent extends WorkstationShiftEvent {
  String workcentreId;
  GetWorkstationShiftEvent({required this.workcentreId});
}

class SelectShiftEvent extends WorkstationShiftEvent {
  // Checkboxlist checkbox;
  bool value;
  String wsStatusId, workcentreId;
  SelectShiftEvent(
      {required this.value,
      required this.wsStatusId,
      required this.workcentreId});
}
