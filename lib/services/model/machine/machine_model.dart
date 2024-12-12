class MachineStatusModel {
  String? id;
  String? product;
  String? po;
  int? line;
  String? poqty;
  int? okqty;
  int? rejectedQty;
  String? startprocesstime;
  String? endprocesstime;
  String? workstation;
  String? employeename;
  int? endprocessflag;
  String? workcentreId;
  int? jobStatus;
  String? workstationId;
  String? startproductiontime;

  MachineStatusModel(
      {this.id,
      this.product,
      this.po,
      this.line,
      this.poqty,
      this.okqty,
      this.rejectedQty,
      this.startprocesstime,
      this.endprocesstime,
      this.workstation,
      this.employeename,
      this.endprocessflag,
      this.workcentreId,
      this.jobStatus,
      this.workstationId,
      this.startproductiontime});

  MachineStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    po = json['po'];
    line = json['line'];
    poqty = json['poqty'];
    okqty = json['okqty'];
    rejectedQty = json['rejected_qty'];
    startprocesstime = json['startprocesstime'];
    endprocesstime = json['endprocesstime'];
    workstation = json['workstation'];
    employeename = json['employeename'];
    endprocessflag = json['endprocessflag'];
    workcentreId = json['workcentre_id'];
    jobStatus = json['job_status'];
    workstationId = json['workstation_id'];
    startproductiontime = json['startproductiontime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['po'] = po;
    data['line'] = line;
    data['poqty'] = poqty;
    data['okqty'] = okqty;
    data['rejected_qty'] = rejectedQty;
    data['startprocesstime'] = startprocesstime;
    data['endprocesstime'] = endprocesstime;
    data['workstation'] = workstation;
    data['employeename'] = employeename;
    data['endprocessflag'] = endprocessflag;
    data['workcentre_id'] = workcentreId;
    data['job_status'] = jobStatus;
    data['workstation_id'] = workstationId;
    data['startproductiontime'] = startproductiontime;
    return data;
  }
}

class WorkcentreWiseEmpList {
  String? employeeId;
  String? employee;

  WorkcentreWiseEmpList({this.employeeId, this.employee});

  WorkcentreWiseEmpList.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employee = json['employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['employee'] = employee;
    return data;
  }
}
