part of 'tools_bloc.dart';

class ToolsState extends Equatable {
  final List<Employee> operator;
  final List<Tool> tools;
  final List<ToolStock> toolStock;
  final String result;
  final List<ToolReport> toolReport;

  const ToolsState(
      {this.operator = const [],
      this.tools = const [],
      this.toolStock = const [],
      this.result = "",
      this.toolReport = const []});

  ToolsState copyWith(
      {List<Employee>? operator,
      List<Tool>? tools,
      List<ToolStock>? toolStock,
      String? result,
      List<ToolReport>? toolReport}) {
    return ToolsState(
        operator: operator ?? this.operator,
        tools: tools ?? this.tools,
        toolStock: toolStock ?? this.toolStock,
        result: result ?? this.result,
        toolReport: toolReport ?? this.toolReport);
  }

  @override
  List<Object> get props => [operator, tools, toolStock, result, toolReport];
}

// final class ToolsInitial extends ToolsState {}
