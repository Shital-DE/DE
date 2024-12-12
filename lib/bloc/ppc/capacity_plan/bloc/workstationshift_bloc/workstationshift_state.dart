part of 'workstationshift_bloc.dart';

abstract class WorkstationShiftState extends Equatable {
  final List<WorkcentreCP> workcentre;
  const WorkstationShiftState({required this.workcentre});
}

class WorkstationShiftInitial extends WorkstationShiftState {
  const WorkstationShiftInitial({required super.workcentre});
  @override
  List<Object> get props => [super.workcentre];
}

class WorkstationShiftLoadState extends WorkstationShiftState {
  final int total;
  final List<WorkstationShift> workstationshift;
  const WorkstationShiftLoadState(
      {required super.workcentre,
      required this.workstationshift,
      required this.total});
  @override
  List<Object> get props => [super.workcentre, workstationshift, total];
}
