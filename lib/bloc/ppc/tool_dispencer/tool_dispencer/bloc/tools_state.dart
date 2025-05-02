part of 'tools_bloc.dart';

class ToolsState extends Equatable {
  final List<Employee> operator;
  final List<Tool> tools;
  final List<ToolStock> toolStock;
  final String result;
  final List<ToolReport> toolReport;
  final String? selectedToolId;

  const ToolsState(
      {this.operator = const [],
      this.tools = const [],
      this.toolStock = const [],
      this.result = "",
      this.toolReport = const [],
      this.selectedToolId = ""});

  ToolsState copyWith(
      {List<Employee>? operator,
      List<Tool>? tools,
      List<ToolStock>? toolStock,
      String? result,
      List<ToolReport>? toolReport,
      String? selectedToolId}) {
    return ToolsState(
      operator: operator ?? this.operator,
      tools: tools ?? this.tools,
      toolStock: toolStock ?? this.toolStock,
      result: result ?? this.result,
      toolReport: toolReport ?? this.toolReport,
      selectedToolId: selectedToolId ?? this.selectedToolId,
    );
  }

  @override
  List<Object> get props =>
      [operator, tools, toolStock, result, toolReport, selectedToolId!];
}

// final class ToolsInitial extends ToolsState {}
