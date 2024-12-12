// Author : Shital Gayakwad
// Description : ERPX_PPC ->Product route
// Created : 18 July 2023

// Product route
class ProductRoute {
  String? productid;
  String? productrouteid;
  int? sequencenumber;
  int? runtimeminutes;
  int? setupminutes;
  String? billofmaterialid;
  String? revisionNumber;
  String? workstationid;
  String? workstation;
  String? workcentreid;
  String? workcentre;

  ProductRoute(
      {this.productid,
      this.productrouteid,
      this.sequencenumber,
      this.runtimeminutes,
      this.setupminutes,
      this.billofmaterialid,
      this.revisionNumber,
      this.workstationid,
      this.workstation,
      this.workcentreid,
      this.workcentre});

  ProductRoute.fromJson(Map<String, dynamic> json) {
    productid = json['productid'];
    productrouteid = json['productrouteid'];
    sequencenumber = json['sequencenumber'];
    runtimeminutes = json['runtimeminutes'];
    setupminutes = json['setupminutes'];
    billofmaterialid = json['billofmaterialid'];
    revisionNumber = json['revision_number'];
    workstationid = json['workstationid'];
    workstation = json['workstation'];
    workcentreid = json['workcentreid'];
    workcentre = json['workcentre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productid'] = productid;
    data['productrouteid'] = productrouteid;
    data['sequencenumber'] = sequencenumber;
    data['runtimeminutes'] = runtimeminutes;
    data['setupminutes'] = setupminutes;
    data['billofmaterialid'] = billofmaterialid;
    data['revision_number'] = revisionNumber;
    data['workstationid'] = workstationid;
    data['workstation'] = workstation;
    data['workcentreid'] = workcentreid;
    data['workcentre'] = workcentre;
    return data;
  }
}

// Product revision
class ProductRevision {
  String? productId;
  String? revisionNumber;
  String? productCode;

  ProductRevision({this.productId, this.revisionNumber, this.productCode});

  ProductRevision.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    revisionNumber = json['revision_number'];
    productCode = json['product_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['revision_number'] = revisionNumber;
    data['product_code'] = productCode;
    return data;
  }
}

// Process route
class ProcessRoute {
  String? id;
  String? productrouteId;
  int? setuptimemins;
  int? runtimemins;
  String? pdProductId;
  int? processsequencenumber;
  String? revisionNumber;
  String? instruction;
  String? workcentre;

  ProcessRoute(
      {this.id,
      this.productrouteId,
      this.setuptimemins,
      this.runtimemins,
      this.pdProductId,
      this.processsequencenumber,
      this.revisionNumber,
      this.instruction,
      this.workcentre});

  ProcessRoute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productrouteId = json['productroute_id'];
    setuptimemins = json['setuptimemins'];
    runtimemins = json['runtimemins'];
    pdProductId = json['pd_product_id'];
    processsequencenumber = json['processsequencenumber'];
    revisionNumber = json['revision_number'];
    instruction = json['instruction'];
    workcentre = json['workcentre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productroute_id'] = productrouteId;
    data['setuptimemins'] = setuptimemins;
    data['runtimemins'] = runtimemins;
    data['pd_product_id'] = pdProductId;
    data['processsequencenumber'] = processsequencenumber;
    data['revision_number'] = revisionNumber;
    data['instruction'] = instruction;
    data['workcentre'] = workcentre;
    return data;
  }
}

//Product and process route model to show data to user
class ProductAndProcessRouteModel {
  int? combinedSequence;
  String? workcentre;
  String? workstation;
  String? process;
  String? instruction;
  int? setuptimemins;
  int? runtimemins;
  String? productRouteId;
  String? processRouteId;
  String? workcentreId;
  String? workstationId;
  String? processId;
  bool? isButton;
  int? productRouteSeq;
  int? processRouteSeq;

  ProductAndProcessRouteModel(
      {this.combinedSequence,
      this.workcentre,
      this.workstation,
      this.process,
      this.instruction,
      this.setuptimemins,
      this.runtimemins,
      this.productRouteId,
      this.processRouteId,
      this.workcentreId,
      this.workstationId,
      this.processId,
      this.isButton,
      this.productRouteSeq,
      this.processRouteSeq});

  ProductAndProcessRouteModel.fromJson(Map<String, dynamic> json) {
    combinedSequence = json['combined_sequence'];
    workcentre = json['workcentre'];
    workstation = json['workstation'];
    process = json['process'];
    instruction = json['instruction'];
    setuptimemins = json['setuptimemins'];
    runtimemins = json['runtimemins'];
    productRouteId = json['product_route_id'];
    processRouteId = json['process_route_id'];
    workcentreId = json['workcentre_id'];
    workstationId = json['workstation_id'];
    processId = json['process_id'];
    isButton = json['is_button'];
    productRouteSeq = json['product_route_seq'];
    processRouteSeq = json['process_route_seq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['combined_sequence'] = combinedSequence;
    data['workcentre'] = workcentre;
    data['workstation'] = workstation;
    data['process'] = process;
    data['instruction'] = instruction;
    data['setuptimemins'] = setuptimemins;
    data['runtimemins'] = runtimemins;
    data['product_route_id'] = productRouteId;
    data['process_route_id'] = processRouteId;
    data['workcentre_id'] = workcentreId;
    data['workstation_id'] = workstationId;
    data['process_id'] = processId;
    data['is_button'] = isButton;
    data['product_route_seq'] = productRouteSeq;
    data['process_route_seq'] = processRouteSeq;
    return data;
  }
}

// Process
class Process {
  String? id;
  String? code;

  Process({this.id, this.code});

  Process.fromJson(Map<String, dynamic> json) {
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

// Filled product and process route
class FilledProductAndProcessRoute {
  String? productId;
  String? product;
  String? revisionNumber;
  String? lastUpdated;

  FilledProductAndProcessRoute(
      {this.productId, this.product, this.revisionNumber, this.lastUpdated});

  FilledProductAndProcessRoute.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    product = json['product'];
    revisionNumber = json['revision_number'];
    lastUpdated = json['last_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product'] = product;
    data['revision_number'] = revisionNumber;
    data['last_updated'] = lastUpdated;
    return data;
  }
}
