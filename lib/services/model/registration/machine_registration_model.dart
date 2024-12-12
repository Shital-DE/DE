// Author : Shital Gayakwad
// Created Date : 14 March 2023
// Description : ERPX_PPC ->Machine registration models
// Modified Date :

class IsinHouseWorkcentre {
  String? id;
  String? code;

  IsinHouseWorkcentre({this.id, this.code});

  IsinHouseWorkcentre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    return data;
  }
}

class ShiftPattern {
  String? id;
  String? code;

  ShiftPattern({this.id, this.code});

  ShiftPattern.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    return data;
  }
}

class Company {
  String? id;
  String? companytypeId;
  String? code;
  String? name;
  String? address;
  String? gstin;

  Company(
      {this.id,
      this.companytypeId,
      this.code,
      this.name,
      this.address,
      this.gstin});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companytypeId = json['companytype_id'];
    code = json['code'];
    name = json['name'];
    address = json['address'];
    gstin = json['gstin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companytype_id'] = companytypeId;
    data['code'] = code;
    data['name'] = name;
    data['address'] = address;
    data['gstin'] = gstin;
    return data;
  }
}
