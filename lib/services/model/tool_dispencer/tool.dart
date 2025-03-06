class Tool {
  String? id;
  String? manufacturertoolcode;
  String? manufacturer;

  Tool({this.id, this.manufacturertoolcode, this.manufacturer});

  Tool.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    manufacturertoolcode = json['manufacturertoolcode'];
    manufacturer = json['manufacturer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['manufacturertoolcode'] = manufacturertoolcode;
    data['manufacturer'] = manufacturer;
    return data;
  }
}
