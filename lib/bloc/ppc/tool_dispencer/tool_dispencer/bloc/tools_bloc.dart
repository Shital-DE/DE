import 'package:bloc/bloc.dart';
import 'package:de/services/model/employee_overtime/employee_model.dart';
import 'package:de/services/model/tool_dispencer/toolreport.dart';
import 'package:de/services/repository/tool_dispencer/tool_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/model/tool_dispencer/tool.dart';
import '../../../../../services/model/tool_dispencer/toolstock.dart';
import '../../../../../services/session/user_login.dart';

part 'tools_event.dart';
part 'tools_state.dart';

class ToolsBloc extends Bloc<ToolsEvent, ToolsState> {
  ToolsBloc() : super(const ToolsState()) {
    on<ToolsInitEvent>(_toolsInitEvent);
    on<ToolsOperatorInitEvent>(_toolsOperatorInitEvent);
    on<ToolsIssueEvent>(_toolsIssueEvent);
    on<ToolsReceiveEvent>(_toolsReceiveEvent);
    on<ToolsStockAddEvent>(_toolsStockAddEvent);
    on<ToolsDamageEvent>(_toolsDamageEvent);
    on<OperatorWiseToolsEvent>(_operatorWiseToolsEvent);
    on<CheckToolAvailableEvent>(_checkToolAvailableEvent);
    on<ToolStockListEvent>(_toolStockListEvent);
    on<ToolReportEvent>(_toolReportEvent);
    on<OperatorMonthReportEvent>(_operatorMonthReportEvent);
    on<ToolSelectionChanged>(_onToolSelectionChanged);
  }

  Future<void> _toolsInitEvent(
      ToolsInitEvent event, Emitter<ToolsState> emit) async {
    List<Employee> operator = await ToolRepository.getOperatorList();
    List<Tool> tools = await ToolRepository.getToolList();

    emit(state.copyWith(operator: operator, tools: tools));
  }

  Future<void> _toolsOperatorInitEvent(
      ToolsOperatorInitEvent event, Emitter<ToolsState> emit) async {
    final saveddata = await UserData.getUserData();
    List<Tool> tools = await ToolRepository.getToolList();
    List<ToolStock> toolHistory = await ToolRepository.getOperatorHistory(
        employeeId: saveddata['data'][0]['id'].toString());

    emit(state.copyWith(toolStock: toolHistory, tools: tools));
  }

  //check stock
  Future<void> _checkToolAvailableEvent(
      CheckToolAvailableEvent event, Emitter<ToolsState> emit) async {
    int balance = await ToolRepository.checkAvailableStock(
        toolId: event.toolId, date: DateTime.now().toString().split(' ')[0]);
    if (balance != 0 && balance > 0) {
      emit(state.copyWith(result: "success"));
    } else {
      emit(state.copyWith(result: "fail"));
    }
  }

  // operator issue
  Future<void> _toolsIssueEvent(
      ToolsIssueEvent event, Emitter<ToolsState> emit) async {
    final saveddata = await UserData.getUserData();
    int balance = await ToolRepository.checkAvailableStock(
        toolId: event.toolId, date: DateTime.now().toString().split(' ')[0]);
    if (balance != 0 && balance > 0 && event.qty <= balance) {
      String result = await ToolRepository.saveToolsIssueAndToolStock(
          issueDate: event.issueDate,
          toolId: event.toolId,
          qty: event.qty,
          transaction: event.transaction,
          drcr: event.drcr);
      List<ToolStock> toolHistory = await ToolRepository.getOperatorHistory(
          employeeId: saveddata['data'][0]['id'].toString());

      emit(state.copyWith(
          result: result, toolStock: toolHistory, selectedToolId: ""));
    } else {
      emit(state.copyWith(result: "fail", selectedToolId: ""));
    }
  }

  //select operator
  Future<void> _operatorWiseToolsEvent(
      OperatorWiseToolsEvent event, Emitter<ToolsState> emit) async {
    List<ToolStock> result =
        await ToolRepository.getOperatorHistory(employeeId: event.employeeId);

    emit(state.copyWith(toolStock: result));
  }

  //tool receive
  Future<void> _toolsReceiveEvent(
      ToolsReceiveEvent event, Emitter<ToolsState> emit) async {
    String result = await ToolRepository.saveToolReceive(
        empId: event.empId,
        toolStock: event.toolStock,
        returnQty: event.returnQty,
        transaction: event.transaction,
        drcr: event.drcr);

    // state.toolStock.removeWhere((element) => element.id == event.toolStock.id);
    List<ToolStock> toolStock =
        await ToolRepository.getOperatorHistory(employeeId: event.empId);
    emit(state.copyWith(result: result, toolStock: toolStock));
  }

  //tool damage entry
  Future<void> _toolsDamageEvent(
      ToolsDamageEvent event, Emitter<ToolsState> emit) async {
    String result = await ToolRepository.saveToolDamageEntry(
        empId: event.empId,
        toolStock: event.toolStock,
        returnQty: event.returnQty,
        transaction: event.transaction,
        drcr: event.drcr,
        reason: event.reason);
    List<ToolStock> toolStock =
        await ToolRepository.getOperatorHistory(employeeId: event.empId);
    emit(state.copyWith(result: result, toolStock: toolStock));
  }

  //tool stock added
  Future<void> _toolsStockAddEvent(
      ToolsStockAddEvent event, Emitter<ToolsState> emit) async {
    String result = await ToolRepository.saveToolsIssueAndToolStock(
        issueDate: DateTime.now().toString(),
        toolId: event.toolId,
        qty: event.qty,
        transaction: event.transaction,
        drcr: event.drcr);

    List<ToolStock> list = await ToolRepository.getToolStockHistory();
    emit(state.copyWith(result: result, toolStock: list, tools: state.tools));
  }

  Future<void> _toolStockListEvent(
      ToolStockListEvent event, Emitter<ToolsState> emit) async {
    if (event.tab == "addstock") {
      List<ToolStock> list = await ToolRepository.getToolStockHistory();

      emit(state.copyWith(toolStock: list));
    } else {
      emit(state.copyWith(toolStock: []));
    }
  }

  //tool report
  Future<void> _toolReportEvent(
      ToolReportEvent event, Emitter<ToolsState> emit) async {
    List<ToolReport> toolReport = await ToolRepository.toolReportDateRange(
        fromdate: event.fromdate, todate: event.todate);

    emit(state.copyWith(toolReport: toolReport));
  }

  Future<void> _operatorMonthReportEvent(
      OperatorMonthReportEvent event, Emitter<ToolsState> emit) async {
    List<ToolStock> list = await ToolRepository.operatorMonthlyReport(
        employeeId: event.employeeId,
        fromdate: event.fromdate,
        todate: event.todate);
    emit(state.copyWith(toolStock: list));
  }

  void _onToolSelectionChanged(
      ToolSelectionChanged event, Emitter<ToolsState> emit) {
    emit(state.copyWith(result: "", selectedToolId: event.toolId));
  }
}
