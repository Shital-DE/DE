part of 'inward_bloc.dart';

class InwardState extends Equatable {
  final bool check;
  final List<InwardChallan> inwardList;
  const InwardState({required this.inwardList, required this.check});

  @override
  List<Object> get props => [];
}

final class InwardInitial extends InwardState {
  const InwardInitial({required super.inwardList, required super.check});
}

class InwardListLoadedState extends InwardState {
  const InwardListLoadedState(
      {required super.inwardList, required super.check});

  @override
  List<Object> get props => [inwardList];
}

class FinishedInwardState extends InwardState {
  const FinishedInwardState({required super.inwardList, required super.check});

  @override
  List<Object> get props => [inwardList, check];
}
