// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Workcentre model

class Workcentre {
  String? id;
  String? code;

  Workcentre({this.id, this.code});

  Workcentre.fromJson(Map<String, dynamic> json) {
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
