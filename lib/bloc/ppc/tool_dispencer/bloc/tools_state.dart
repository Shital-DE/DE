part of 'tools_bloc.dart';

class ToolsState extends Equatable {
  final List<Employee> operator;
  final List<Tool> tools;
  final List<ToolStock> toolStock;

  const ToolsState(
      {this.operator = const [],
      this.tools = const [],
      this.toolStock = const []});

  ToolsState copyWith(
      {List<Employee>? operator,
      List<Tool>? tools,
      List<ToolStock>? toolStock}) {
    return ToolsState(
        operator: operator ?? this.operator,
        tools: tools ?? this.tools,
        toolStock: toolStock ?? this.toolStock);
  }

  @override
  List<Object> get props => [operator, tools, toolStock];
}

// final class ToolsInitial extends ToolsState {}
