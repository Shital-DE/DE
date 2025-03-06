class ToolReport {
  String? toolId;
  String? tool;
  int? qty;
  int? damageQty;
  int? wornoutQty;
  String? drcr;
  String? employeeId;
  String? employeeName;

  ToolReport(
      {this.toolId,
      this.tool,
      this.qty,
      this.drcr,
      this.employeeId,
      this.employeeName});

  ToolReport.fromJson(Map<String, dynamic> json) {
    toolId = json['tool_id'];
    tool = json['tool'];
    qty = json['qty'];
    damageQty = json['damage_qty'];
    wornoutQty = json['wornout_qty'];
    drcr = json['drcr'];
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tool_id'] = toolId;
    data['tool'] = tool;
    data['qty'] = qty;
    data['damage_qty'] = wornoutQty;
    data['wornout_qty'] = wornoutQty;
    data['drcr'] = drcr;
    data['employee_id'] = employeeId;
    data['employee_name'] = employeeName;
    return data;
  }
}
