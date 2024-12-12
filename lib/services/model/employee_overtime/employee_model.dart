/*
// Rohini Mane
// 07-02-2024
*/

class Employee {
  String? id;
  String? employeename;

  Employee({
    this.id,
    this.employeename,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeename = json['employeename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeename'] = employeename;

    return data;
  }
}

class Polist {
  String? id;
  String? ponumber;

  Polist({
    this.id,
    this.ponumber,
  });

  Polist.fromJson(Map<String, dynamic> json) {
    id = json['so_id'];
    ponumber = json['ponumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['so_id'] = id;
    data['ponumber'] = ponumber;

    return data;
  }
}

class Productlist {
  String? id;
  String? productcode;

  Productlist({
    this.id,
    this.productcode,
  });

  Productlist.fromJson(Map<String, dynamic> json) {
    id = json['product_id'];
    productcode = json['product_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = id;
    data['product_code'] = productcode;

    return data;
  }
}

class EmpOvertimeWorkstation {
  String? id;
  String? ws;

  EmpOvertimeWorkstation({
    this.id,
    this.ws,
  });

  EmpOvertimeWorkstation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ws = json['workstation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['workstation'] = ws;

    return data;
  }
}

class EmployeeOvertimedata {
  String? id;
  String? employeeId;
  String? workstationId;
  String? starttime;
  String? endtime;
  String? employeename;
  String? wscode;
  String? pono;
  String? productcode;
  String? remark;

  EmployeeOvertimedata(
      {this.id,
      this.employeeId,
      this.workstationId,
      this.starttime,
      this.endtime,
      this.employeename,
      this.wscode,
      this.pono,
      this.productcode,
      this.remark});

  EmployeeOvertimedata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    workstationId = json['workstation_id'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    employeename = json['employeename'];
    wscode = json['wscode'];
    pono = json['pono'];
    productcode = json['productcode'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['workstation_id'] = workstationId;
    data['starttime'] = starttime;
    data['endtime'] = endtime;
    data['employeename'] = employeename;
    data['wscode'] = wscode;

    data['pono'] = pono;
    data['productcode'] = productcode;
    data['remark'] = remark;
    return data;
  }
}
