import 'package:bloc/bloc.dart';
import 'package:de/services/model/employee_overtime/employee_model.dart';
import 'package:de/services/repository/tool_despencer/tool_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../services/model/tool_despencer/tool.dart';
import '../../../../services/model/tool_despencer/toolstock.dart';

part 'tools_event.dart';
part 'tools_state.dart';

class ToolsBloc extends Bloc<ToolsEvent, ToolsState> {
  ToolsBloc() : super(const ToolsState()) {
    on<ToolsInitEvent>(_toolsInitEvent);
    on<ToolsIssueReceiveEvent>(_toolsIssueReceiveEvent);
    on<ToolsDamageEvent>(_toolsDamageEvent);
    on<OperatorWiseToolsEvent>(_operatorWiseToolsEvent);
  }

  Future<void> _toolsInitEvent(
      ToolsInitEvent event, Emitter<ToolsState> emit) async {
    List<Employee> operator = await ToolRepository.getOperatorList();
    List<Tool> tools = await ToolRepository.getToolList();

    emit(state.copyWith(operator: operator, tools: tools));
  }

  Future<void> _toolsIssueReceiveEvent(
      ToolsIssueReceiveEvent event, Emitter<ToolsState> emit) async {
    String result = await ToolRepository.saveToolIssue(
        toolId: event.toolId, qty: event.qty);
    print(result);
    emit(state.copyWith(operator: state.operator, tools: state.tools));
  }

  Future<void> _toolsDamageEvent(
      ToolsDamageEvent event, Emitter<ToolsState> emit) async {
    String result = await ToolRepository.saveToolDamageEntry(
        toolId: event.toolId, qty: event.qty);
    print(result);
    emit(state.copyWith(operator: state.operator, tools: state.tools));
  }

  Future<void> _operatorWiseToolsEvent(
      OperatorWiseToolsEvent event, Emitter<ToolsState> emit) async {
    List<ToolStock> result =
        await ToolRepository.getOperatorHistory(employeeId: event.employeeId);
    print(result);
    emit(state.copyWith(toolStock: result));
  }
}
