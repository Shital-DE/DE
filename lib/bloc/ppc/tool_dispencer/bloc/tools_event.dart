part of 'tools_bloc.dart';

sealed class ToolsEvent extends Equatable {
  const ToolsEvent();

  @override
  List<Object?> get props => [];
}

class ToolsInitEvent extends ToolsEvent {
  const ToolsInitEvent();
}

class ToolsIssueReceiveEvent extends ToolsEvent {
  final String toolId;
  final int qty;
  const ToolsIssueReceiveEvent({required this.toolId, required this.qty});
}

class ToolsDamageEvent extends ToolsEvent {
  final String toolId;
  final int qty;
  const ToolsDamageEvent({required this.toolId, required this.qty});
}

class OperatorWiseToolsEvent extends ToolsEvent {
  final String employeeId;
  const OperatorWiseToolsEvent({required this.employeeId});
}
