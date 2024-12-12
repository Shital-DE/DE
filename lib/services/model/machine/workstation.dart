// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Workstation model

class WorkstationByWorkcentreId {
  String? id;
  String? code;

  WorkstationByWorkcentreId({this.id, this.code});

  WorkstationByWorkcentreId.fromJson(Map<String, dynamic> json) {
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

class AllWcWsWithAndroidId {
  String? id;
  String? workcentre;
  String? workstation;
  String? androidId;

  AllWcWsWithAndroidId(
      {this.id, this.workcentre, this.workstation, this.androidId});

  AllWcWsWithAndroidId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workcentre = json['workcentre'];
    workstation = json['workstation'];
    androidId = json['android_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['workcentre'] = workcentre;
    data['workstation'] = workstation;
    data['android_id'] = androidId;
    return data;
  }
}
