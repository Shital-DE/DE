// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Assigned machine model

class AssignedMachine {
  String? workstationid;
  String? workstation;
  String? wrWorkcentreId;
  String? workcentre;
  String? androidId;
  String? machineid;
  String? machinename;

  AssignedMachine(
      {this.workstationid,
      this.workstation,
      this.wrWorkcentreId,
      this.workcentre,
      this.androidId,
      this.machineid,
      this.machinename});

  AssignedMachine.fromJson(Map<String, dynamic> json) {
    workstationid = json['workstationid'];
    workstation = json['workstation'];
    wrWorkcentreId = json['wr_workcentre_id'];
    workcentre = json['workcentre'];
    androidId = json['android_id'];
    machineid = json['machineid'];
    machinename = json['machinename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workstationid'] = workstationid;
    data['workstation'] = workstation;
    data['wr_workcentre_id'] = wrWorkcentreId;
    data['workcentre'] = workcentre;
    data['android_id'] = androidId;
    data['machineid'] = machineid;
    data['machinename'] = machinename;
    return data;
  }
}

class CheckTabIsAssignedOrNot {
  String? id;
  String? code;
  String? androidId;

  CheckTabIsAssignedOrNot({this.id, this.code, this.androidId});

  CheckTabIsAssignedOrNot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    androidId = json['android_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['android_id'] = androidId;
    return data;
  }
}
