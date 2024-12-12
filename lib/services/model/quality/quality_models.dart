// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Quality model

class QualityRejectedReasons {
  String? id;
  String? qualityrejreasons;

  QualityRejectedReasons({this.id, this.qualityrejreasons});

  QualityRejectedReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qualityrejreasons = json['qualityrejreasons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['qualityrejreasons'] = qualityrejreasons;
    return data;
  }
}

class QualityProductStatus {
  String? part;
  String? po;
  int? lineitemnumber;
  String? issueQty;
  int? okQty;
  int? reworkqty;
  int? rejectedQty;
  int? shortqty;
  String? startprocesstime;
  String? endprocesstime;
  String? employeename;
  String? workstation;
  int? endprocessflag;
  String? workcentreId;
  int? jobStatus;
  String? id;

  QualityProductStatus(
      {this.part,
      this.po,
      this.lineitemnumber,
      this.issueQty,
      this.okQty,
      this.reworkqty,
      this.rejectedQty,
      this.shortqty,
      this.startprocesstime,
      this.endprocesstime,
      this.employeename,
      this.workstation,
      this.endprocessflag,
      this.workcentreId,
      this.jobStatus,
      this.id});

  QualityProductStatus.fromJson(Map<String, dynamic> json) {
    part = json['part'];
    po = json['po'];
    lineitemnumber = json['lineitemnumber'];
    issueQty = json['tobeproducedquantity'];
    okQty = json['produced_qty'];
    reworkqty = json['reworkqty'];
    rejectedQty = json['rejected_qty'];
    shortqty = json['shortqty'];
    startprocesstime = json['startprocesstime'];
    endprocesstime = json['endprocesstime'];
    employeename = json['employeename'];
    workstation = json['workstation'];
    endprocessflag = json['endprocessflag'];
    workcentreId = json['workcentre_id'];
    jobStatus = json['job_status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['part'] = part;
    data['po'] = po;
    data['lineitemnumber'] = lineitemnumber;
    data['tobeproducedquantity'] = issueQty;
    data['produced_qty'] = okQty;
    data['reworkqty'] = reworkqty;
    data['rejected_qty'] = rejectedQty;
    data['shortqty'] = shortqty;
    data['startprocesstime'] = startprocesstime;
    data['endprocesstime'] = endprocesstime;
    data['employeename'] = employeename;
    data['workstation'] = workstation;
    data['endprocessflag'] = endprocessflag;
    data['workcentre_id'] = workcentreId;
    data['job_status'] = jobStatus;
    data['id'] = id;
    return data;
  }
}
