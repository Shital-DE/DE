// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'capacity_plan_bloc.dart';

abstract class CapacityPlanState extends Equatable {
  const CapacityPlanState({required this.cplist});
  final List<CapacityPlanData> cplist;
}

class CheckDateInitial extends CapacityPlanState {
  final String message;

  const CheckDateInitial({required this.message, required super.cplist});

  @override
  List<Object?> get props => [message, super.cplist];
}

class CapacityPlanInitial extends CapacityPlanState {
  const CapacityPlanInitial({required super.cplist});

  @override
  List<Object?> get props => [super.cplist];
}

class CapacityPlanListState extends CapacityPlanState {
  const CapacityPlanListState({required super.cplist});

  @override
  List<Object?> get props => [super.cplist];
}

class CapacityPlanSaveState extends CapacityPlanState {
  final String result;
  const CapacityPlanSaveState({required this.result, required super.cplist});

  @override
  List<Object?> get props => [result];
}
