part of 'tools_bloc.dart';

sealed class ToolsEvent extends Equatable {
  const ToolsEvent();

  @override
  List<Object?> get props => [];
}

class ToolsInitEvent extends ToolsEvent {
  const ToolsInitEvent();
}

class ToolsOperatorInitEvent extends ToolsEvent {
  const ToolsOperatorInitEvent();
}

class ToolsOperationsEvent extends ToolsEvent {
  final String toolId, transaction, drcr;
  final int qty;

  const ToolsOperationsEvent(
      {required this.toolId,
      required this.qty,
      required this.transaction,
      required this.drcr});
}

class ToolsIssueEvent extends ToolsOperationsEvent {
  final String issueDate;
  const ToolsIssueEvent(
      {required super.toolId,
      required super.qty,
      required this.issueDate,
      super.transaction = "TTI",
      super.drcr = 'C'});
}

class ToolsStockAddEvent extends ToolsOperationsEvent {
  const ToolsStockAddEvent(
      {required super.toolId,
      required super.qty,
      super.transaction = "TTS",
      super.drcr = 'D'});
}

class ToolsReceiveEvent extends ToolsEvent {
  final ToolStock toolStock;
  final String empId, transaction, drcr;
  final int returnQty;
  const ToolsReceiveEvent(
      {required this.empId,
      required this.toolStock,
      required this.returnQty,
      this.transaction = "TTR",
      this.drcr = 'D'});
}

class ToolsDamageEvent extends ToolsEvent {
  final Map<String, String> reason;
  final String remark, empId, transaction, drcr;
  final ToolStock toolStock;
  final int returnQty;
  const ToolsDamageEvent({
    required this.toolStock,
    required this.empId,
    required this.returnQty,
    this.transaction = "TTD",
    this.drcr = 'D',
    required this.reason,
    this.remark = '',
  });
}

class OperatorWiseToolsEvent extends ToolsEvent {
  final String employeeId;
  const OperatorWiseToolsEvent({required this.employeeId});
}

class CheckToolAvailableEvent extends ToolsEvent {
  final String toolId, date;
  const CheckToolAvailableEvent({required this.toolId, required this.date});
}

class ToolStockListEvent extends ToolsEvent {
  final String tab;
  const ToolStockListEvent({required this.tab});
}

class OperatorMonthReportEvent extends ToolsEvent {
  final String employeeId, fromdate, todate;
  const OperatorMonthReportEvent(
      {required this.employeeId, required this.fromdate, required this.todate});
}

class ToolReportEvent extends ToolsEvent {
  final String fromdate, todate;
  const ToolReportEvent({required this.fromdate, required this.todate});
}

class ToolSelectionChanged extends ToolsEvent {
  final String toolId;
  const ToolSelectionChanged(this.toolId);
}
