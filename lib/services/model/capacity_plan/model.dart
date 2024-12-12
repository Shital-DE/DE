class CapacityPlanData {
  String? salesorderId;
  String? po;
  int? lineitemnumber;
  String? productcode;
  String? revisionNo;
  String? productId;
  double? orderedqty;
  String? plandate;
  bool? checkboxval;
  List<WorkcentreRoute>? route;

  CapacityPlanData(
      {this.salesorderId,
      this.po,
      this.lineitemnumber,
      this.productId,
      this.productcode,
      this.revisionNo,
      this.orderedqty,
      this.checkboxval,
      this.route});

  CapacityPlanData.fromJson(Map<String, dynamic> json) {
    salesorderId = json['salesorder_id'];
    po = json['po'];
    lineitemnumber = json['lineitemnumber'];
    productId = json['product_id'];
    productcode = json['product'] + json['revision_number'];
    revisionNo = json['revision_number'];
    orderedqty = double.parse(json['orderedqty']);
    plandate = json['plandate'];
    checkboxval = json['checkboxval'];
    if (json['workcentre_route'] != null) {
      route = <WorkcentreRoute>[];
      json['workcentre_route'].forEach((v) {
        route!.add(WorkcentreRoute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['salesorder_id'] = salesorderId;
    data['po'] = po;
    data['lineitemnumber'] = lineitemnumber;
    data['product_id'] = productId;
    data['product'] = productcode;
    data['orderedqty'] = orderedqty;
    data['revision_number'] = revisionNo;
    if (route != null) {
      data['workcentre_route'] = route!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkcentreRoute {
  int? sequencenumber;
  String? workcentreId;
  String? workcentre;
  int? setuptimemins;
  int? runtimemins;

  WorkcentreRoute(
      {this.sequencenumber,
      this.workcentreId,
      this.workcentre,
      this.setuptimemins,
      this.runtimemins});

  WorkcentreRoute.fromJson(Map<String, dynamic> json) {
    sequencenumber = json['sequencenumber'];
    workcentreId = json['workcentre_id'];
    workcentre = json['workcentre'];
    setuptimemins = json['setuptimemins'];
    runtimemins = json['runtimemins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sequencenumber'] = sequencenumber;
    data['workcentre_id'] = workcentreId;
    data['workcentre'] = workcentre;
    data['setuptimemins'] = setuptimemins;
    data['runtimemins'] = runtimemins;
    return data;
  }
}

class CapacityPlanList {
  int? runnumber;
  String? capacityPlanName;
  String? fromDate;
  String? toDate;

  CapacityPlanList({this.runnumber, this.capacityPlanName});

  CapacityPlanList.fromJson(Map<String, dynamic> json) {
    runnumber = json['runnumber'];
    capacityPlanName = json['capacity_plan_name'];
    fromDate = json['fromdate'];
    toDate = json['todate'];
  }
}

class WorkcentreCP {
  String? id;
  String? code;

  int? wcRequiredTime;
  int? wcUtilizedTime;

  WorkcentreCP({this.id, this.code, this.wcRequiredTime, this.wcUtilizedTime});

  WorkcentreCP.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];

    wcRequiredTime = json['required_cp_time'];
    wcUtilizedTime = json['utilized_cp_time'];
  }
}

class ProductDragDrop {
  String? cpid;
  String? cpchildId;
  int? runnumber;
  String? salesorderId;
  int? lineitemnumber;
  String? productId;
  String? revisionNumber;
  String? quantity;
  String? workcentreId;
  int? sequencenumber;
  String? po;
  String? product;
  String? workcentre;
  String? workstationId;
  String? workstation;

  ProductDragDrop({
    this.cpid,
    this.cpchildId,
    this.runnumber,
    this.salesorderId,
    this.lineitemnumber,
    this.productId,
    this.revisionNumber,
    this.quantity,
    this.workcentreId,
    this.sequencenumber,
    this.po,
    this.product,
    this.workcentre,
    this.workstationId = "",
  });

  ProductDragDrop.fromJson(Map<String, dynamic> json) {
    cpid = json['cpid'];
    cpchildId = json['cpchild_id'];
    runnumber = json['runnumber'];
    salesorderId = json['salesorder_id'];
    lineitemnumber = json['lineitemnumber'];
    productId = json['product_id'];
    revisionNumber = json['revision_number'];
    quantity = json['quantity'];
    workcentreId = json['workcentre_id'];
    sequencenumber = json['sequencenumber'];
    po = json['po'];
    product = json['product'];
    workcentre = json['workcentre'];
    workstationId = json['workstationId'] ?? "";
    workstation = json['workstation'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cpid'] = cpid;
    data['cpchild_id'] = cpchildId;
    data['runnumber'] = runnumber;
    data['salesorder_id'] = salesorderId;
    data['lineitemnumber'] = lineitemnumber;
    data['product_id'] = productId;
    data['revision_number'] = revisionNumber;
    data['quantity'] = quantity;
    data['workcentre_id'] = workcentreId;
    data['sequencenumber'] = sequencenumber;
    data['po'] = po;
    data['product'] = product;
    data['workcentre'] = workcentre;
    return data;
  }
}

class WorkstationCP {
  String? id;
  String? wrWorkcentreId;
  String? code;

  WorkstationCP({
    this.id,
    this.wrWorkcentreId,
    this.code,
  });

  WorkstationCP.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wrWorkcentreId = json['wr_workcentre_id'];
    code = json['code'];
  }
}

class WorkstationShift {
  WorkstationCP? workstationDetails;
  List<Checkboxlist>? checkboxlist;

  WorkstationShift({this.workstationDetails, this.checkboxlist});

  WorkstationShift.fromJson(Map<String, dynamic> json) {
    workstationDetails = WorkstationCP.fromJson(json);
    if (json['checkboxlist'] != null) {
      checkboxlist = <Checkboxlist>[];
      json['checkboxlist'].forEach((v) {
        checkboxlist!.add(Checkboxlist.fromJson(v));
      });
    }
  }
}

class Checkboxlist {
  String? id;
  String? shiftId;
  bool? shiftStatus;
  int? shiftDuration;

  Checkboxlist({this.id, this.shiftId, this.shiftStatus, this.shiftDuration});

  Checkboxlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftId = json['shift_id'];
    shiftStatus = json['shift_status'];
    shiftDuration = json['shift_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shift_id'] = shiftId;
    data['shift_status'] = shiftStatus;
    data['shift_duration'] = shiftDuration;
    return data;
  }
}

class ShiftTotal {
  WorkcentreCP? workcentre;
  int? shiftTotal;

  ShiftTotal({this.workcentre, this.shiftTotal});

  ShiftTotal.fromJson(Map<String, dynamic> json) {
    workcentre = WorkcentreCP.fromJson(json);
    shiftTotal = json['shift_total'];
  }
}
