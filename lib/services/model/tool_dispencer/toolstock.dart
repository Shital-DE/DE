class ToolStock {
  String? id,
      date,
      toolcode,
      transactiontypeId,
      toolId,
      employeeId,
      drcr,
      status,
      reason,
      createdby,
      remark;
  int? qty;

  ToolStock(
      {this.id,
      this.date,
      this.transactiontypeId,
      this.toolId,
      this.toolcode,
      this.employeeId,
      this.drcr,
      this.qty,
      this.status,
      this.reason,
      this.createdby,
      this.remark});

  ToolStock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'].toString();
    transactiontypeId = json['transactiontype_id'];
    toolId = json['tool_id'];
    toolcode = json['toolcode'];
    employeeId = json['employee_id'];
    drcr = json['drcr'];
    qty = json['qty'];
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['transactiontype_id'] = transactiontypeId;
    data['tool_id'] = toolId;
    data['toolcode'] = toolcode;
    data['employee_id'] = employeeId;
    data['drcr'] = drcr;
    data['qty'] = qty;
    data['status'] = status;
    data['reason'] = reason;
    data['createdby'] = createdby;
    data['remark'] = remark;
    return data;
  }
}
