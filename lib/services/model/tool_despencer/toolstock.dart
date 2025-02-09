class ToolStock {
  String? id, date, transactiontypeId, toolId, employeeId, drcr;
  int? qty, balance;

  ToolStock(
      {this.id,
      this.date,
      this.transactiontypeId,
      this.toolId,
      this.employeeId,
      this.drcr,
      this.qty,
      this.balance});

  ToolStock.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    date = json['date'];
    transactiontypeId = json['transactiontype_id'];
    toolId = json['tool_id'];
    employeeId = json['employee_id'];
    drcr = json['drcr'];
    qty = json['qty'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['transactiontype_id'] = transactiontypeId;
    data['tool_id'] = toolId;
    data['employee_id'] = employeeId;
    data['drcr'] = drcr;
    data['qty'] = qty;
    data['balance'] = balance;
    return data;
  }
}
