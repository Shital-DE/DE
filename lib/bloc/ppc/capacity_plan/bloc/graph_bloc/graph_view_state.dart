part of 'graph_view_bloc.dart';

abstract class GraphViewState extends Equatable {
  final List<CapacityPlanList>? cpList;
  const GraphViewState(this.cpList);

}

class GraphViewInitial extends GraphViewState {
  const GraphViewInitial(super.cpList);

  @override
  List<Object?> get props => [];
}

class GraphViewLoadState extends GraphViewState {
  final List<WorkcentreCP> wclist;
  final List<ShiftTotal> shiftTotal;
  const GraphViewLoadState(super.cpList, {required this.wclist,required this.shiftTotal,});

  @override
  List<Object?> get props => [cpList, wclist];
}
