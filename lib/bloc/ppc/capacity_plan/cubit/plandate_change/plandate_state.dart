part of 'plandate_cubit.dart';

abstract class PlanDateState extends Equatable {
  const PlanDateState();
}

class PlanDateInitial extends PlanDateState {
  const PlanDateInitial();
  @override
  List<Object?> get props => [];
}

class PODetails extends PlanDateState {
  final SalesOrder so;

  const PODetails({required this.so});

  @override
  List<Object?> get props => [so];
}

class POPlanDateLoad extends PODetails {
  final String? po;
  const POPlanDateLoad({required super.so, this.po});
  @override
  List<Object?> get props => [so];
}

class POLoadError extends PlanDateState {
  final String message;
  const POLoadError({required this.message});
  @override
  List<Object?> get props => [message];
}
