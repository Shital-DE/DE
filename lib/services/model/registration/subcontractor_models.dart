// Author : Shital Gayakwad
// Created Date : 30 April 2023
// Description : ERPX_PPC -> Subcontractor model

class AllSubContractor {
  String? id;
  String? name;
  String? address1;
  String? address2;
  String? city;
  String? companyId;

  AllSubContractor(
      {this.id,
      this.name,
      this.address1,
      this.address2,
      this.city,
      this.companyId});

  AllSubContractor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['company_id'] = companyId;
    return data;
  }
}

// Calibration contractors
class CalibrationContractors {
  String? id;
  String? name;
  String? address1;
  String? address2;
  String? erpId;
  String? departmentId;

  CalibrationContractors(
      {this.id,
      this.name,
      this.address1,
      this.address2,
      this.erpId,
      this.departmentId});

  CalibrationContractors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address1 = json['address1'];
    address2 = json['address2'];
    erpId = json['erp_id'];
    departmentId = json['department_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address1'] = address1;
    data['address2'] = address2;
    data['erp_id'] = erpId;
    data['department_id'] = departmentId;
    return data;
  }
}
