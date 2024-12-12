part of 'graph_view_bloc.dart';

abstract class GraphViewEvent {
  const GraphViewEvent();
}

class GraphViewInitEvent extends GraphViewEvent {}

class GraphViewLoadEvent extends GraphViewEvent {
  final int runnumber;
  const GraphViewLoadEvent({required this.runnumber});
}
