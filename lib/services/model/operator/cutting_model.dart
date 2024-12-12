class CuttingStatus {
  String? id;
  String? starttime;
  String? endtime;
  int? endprocessflag;
  int? endproductionflag;
  int? cuttingqty;

  CuttingStatus(
      {this.id,
      this.starttime,
      this.endtime,
      this.endprocessflag,
      this.endproductionflag,
      this.cuttingqty});

  CuttingStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    endprocessflag = json['endprocessflag'];
    endproductionflag = json['endproductionflag'];
    cuttingqty = json['cuttingqty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['starttime'] = starttime;
    data['endtime'] = endtime;
    data['endprocessflag'] = endprocessflag;
    data['endproductionflag'] = endproductionflag;
    data['cuttingqty'] = cuttingqty;
    return data;
  }
}
