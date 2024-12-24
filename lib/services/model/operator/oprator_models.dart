class Barcode {
  String? po;
  String? product;
  String? poid;
  String? productid;
  int? lineitemnumber;
  String? dispatchDate;
  String? uomId;
  String? uomCode;
  String? rawmaterial;
  String? rawmaterialissueid;
  double? issueQty;
  String? revisionnumber;

  Barcode(
      {this.po,
      this.product,
      this.poid,
      this.productid,
      this.lineitemnumber,
      this.dispatchDate,
      this.uomId,
      this.uomCode,
      this.rawmaterial,
      this.rawmaterialissueid,
      this.issueQty,
      this.revisionnumber});

  Barcode.fromJson(Map<String, dynamic> json) {
    po = json['po'];
    product = json['part'];
    poid = json['poid'];
    productid = json['productid'];
    lineitemnumber = json['lineitemnumber'];
    dispatchDate = json['dispatch_date'];
    uomId = json['uom_id'];
    uomCode = json['uom_code'];
    rawmaterial = json['rawmaterial'];
    rawmaterialissueid = json['rawmaterialissueid'];
    issueQty = double.parse(json['issued_qty'].toString());
    revisionnumber = json['revision_number'];
  }

  Map<String, dynamic> toJson() {
    return {
      'po': po,
      'part': product,
      'poid': poid,
      'productid': productid,
      'lineitemnumber': lineitemnumber,
      'dispatch_date': dispatchDate,
      'uom_id': uomId,
      'uom_code': uomCode,
      'rawmaterial': rawmaterial,
      'rawmaterialissueid': rawmaterialissueid,
      'issued_qty': issueQty,
      'revision_number': revisionnumber,
    };
  }
}

class MachineCenterProcess {
  String? id;
  String? processname;
  MachineCenterProcess({this.id, this.processname});

  MachineCenterProcess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processname = json['process_name'];
  }
}

class Tools {
  String? id;
  String? toolname;

  Tools({this.id, this.toolname});

  Tools.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toolname = json['toolname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['toolname'] = toolname;
    return data;
  }
}

class OperatorRejectedReasons {
  String? id;
  String? rejectedreasons;

  OperatorRejectedReasons({this.id, this.rejectedreasons});

  OperatorRejectedReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rejectedreasons = json['rejectedreasons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rejectedreasons'] = rejectedreasons;
    return data;
  }
}

class DoneQty {
  DoneQty({
    required this.doneQuantity,
  });
  late final List<DoneQuantity> doneQuantity;

  DoneQty.fromJson(Map<String, dynamic> json) {
    doneQuantity = List.from(json['doneQuantity'])
        .map((e) => DoneQuantity.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['doneQuantity'] = doneQuantity.map((e) => e.toJson()).toList();
    return data;
  }
}

class DoneQuantity {
  DoneQuantity({
    required this.tag,
    required this.count,
  });
  late final String tag;
  late final dynamic count;

  DoneQuantity.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tag'] = tag;
    data['count'] = count;
    return data;
  }
}

class ProductionData {
  String? requestid;
  String? status;
  int? code;
  String? message;
  List<Data>? data;
  int? productiontime;
  int? idletime;
  int? energyconsumed;

  ProductionData(
      {this.requestid,
      this.status,
      this.code,
      this.message,
      this.data,
      this.productiontime,
      this.idletime,
      this.energyconsumed});

  ProductionData.fromJson(Map<String, dynamic> json) {
    requestid = json['requestid'];
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    productiontime = json['productiontime'];
    idletime = json['idletime'];
    energyconsumed = json['energyconsumed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestid'] = requestid;
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['productiontime'] = productiontime;
    data['idletime'] = idletime;
    data['energyconsumed'] = energyconsumed;
    return data;
  }
}

class Data {
  int? srno;
  String? starttime;
  String? endtime;

  Data({this.srno, this.starttime, this.endtime});

  Data.fromJson(Map<String, dynamic> json) {
    srno = json['srno'];
    starttime = json['starttime'];
    endtime = json['endtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['srno'] = srno;
    data['starttime'] = starttime;
    data['endtime'] = endtime;
    return data;
  }
}

class ProgramMdocId {
  String? mdocId;

  ProgramMdocId({this.mdocId});

  ProgramMdocId.fromJson(Map<String, dynamic> json) {
    mdocId = json['mdoc_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mdoc_id'] = mdocId;
    return data;
  }
}

class ProgramListfromMachine {
  final String name;
  final int size;
  final DateTime date;

  ProgramListfromMachine(
      {required this.name, required this.size, required this.date});
}

class Programfoldername {
  final String folername;

  Programfoldername({
    required this.folername,
  });
}

class PendingProductlistforoperator {
  String? id;
  String? runnumber;
  String? capacityplanChildId;
  String? product;
  String? productid;
  String? revisionNo;
  String? lineno;
  String? poid;
  String? ponumber;
  String? rmsid;
  String? description;
  String? toBeProducedQty;

  PendingProductlistforoperator(
      {this.id,
      this.runnumber,
      this.capacityplanChildId,
      this.product,
      this.productid,
      this.revisionNo,
      this.lineno,
      this.poid,
      this.ponumber,
      this.rmsid,
      this.description,
      this.toBeProducedQty});

  PendingProductlistforoperator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    runnumber = json['runnumber'];
    capacityplanChildId = json['capacityplan_child_id'];
    product = json['product'];
    productid = json['product_id'];
    revisionNo = json['revisionNo'];
    lineno = json['lineno'];
    poid = json['poid'];
    ponumber = json['ponumber'];
    rmsid = json['rmsid'];
    description = json['description'];
    toBeProducedQty = json['tobeproducedqty'];
  }
}

class Wcprogramlist {
  String? id;
  String? product;
  String? pdProductId;
  String? mdocId;
  String? revisionNumber;
  String? remark;
  String? workcentreId;
  String? workstationId;
  String? processrouteId;
  int? processSeqnumber;

  Wcprogramlist(
      {this.id,
      this.product,
      this.pdProductId,
      this.mdocId,
      this.revisionNumber,
      this.remark,
      this.workcentreId,
      this.workstationId,
      this.processrouteId,
      this.processSeqnumber});

  Wcprogramlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    pdProductId = json['pd_product_id'];
    mdocId = json['mdoc_id'];
    revisionNumber = json['revision_number'];
    remark = json['remark'];
    workcentreId = json['workcentre_id'];
    workstationId = json['workstation_id'];
    processrouteId = json['processroute_id'];
    processSeqnumber = json['process_seqnumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['pd_product_id'] = pdProductId;
    data['mdoc_id'] = mdocId;
    data['revision_number'] = revisionNumber;
    data['remark'] = remark;
    data['workcentre_id'] = workcentreId;
    data['workstation_id'] = workstationId;
    data['processroute_id'] = processrouteId;
    data['process_seqnumber'] = processSeqnumber;
    return data;
  }
}

class Productprocessseq {
  String? processrouteid;
  String? workcentre;
  String? product;
  int? runtimeminutes;
  int? setupminutes;
  int? seqno;
  String? instruction;

  Productprocessseq(
      {this.processrouteid,
      this.workcentre,
      this.product,
      this.runtimeminutes,
      this.setupminutes,
      this.seqno,
      this.instruction});

  Productprocessseq.fromJson(Map<String, dynamic> json) {
    processrouteid = json['id'];
    workcentre = json['workcentre'];
    product = json['product'];
    runtimeminutes = json['runtimeminutes'];
    setupminutes = json['setupminutes'];
    seqno = json['seqno'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = processrouteid;
    data['workcentre'] = workcentre;
    data['product'] = product;
    data['runtimeminutes'] = runtimeminutes;
    data['setupminutes'] = setupminutes;
    data['seqno'] = seqno;
    data['instruction'] = instruction;
    return data;
  }
}

class MachineProgramListFromERP {
  String? id;
  String? product;
  String? pdProductId;
  String? mdocId;
  String? revisionNumber;
  String? remark;
  String? imagetype;
  String? workcentreId;
  String? workstationId;
  String? processrouteId;
  int? processSeqnumber;

  MachineProgramListFromERP(
      {this.id,
      this.product,
      this.pdProductId,
      this.mdocId,
      this.revisionNumber,
      this.remark,
      this.imagetype,
      this.workcentreId,
      this.workstationId,
      this.processrouteId,
      this.processSeqnumber});

  MachineProgramListFromERP.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    pdProductId = json['pd_product_id'];
    mdocId = json['mdoc_id'];
    revisionNumber = json['revision_number'];
    remark = json['remark'];
    imagetype = json['imagetype_code'];
    workcentreId = json['workcentre_id'];
    workstationId = json['workstation_id'];
    processrouteId = json['processroute_id'];
    processSeqnumber = json['process_seqnumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['pd_product_id'] = pdProductId;
    data['mdoc_id'] = mdocId;
    data['revision_number'] = revisionNumber;
    data['remark'] = remark;
    data['imagetype_code'] = imagetype;
    data['workcentre_id'] = workcentreId;
    data['workstation_id'] = workstationId;
    data['processroute_id'] = processrouteId;
    data['process_seqnumber'] = processSeqnumber;
    return data;
  }
}

class Operatorworkstatuslist {
  String? id;
  String? product;
  String? revisionno;
  String? pdfmdcid;
  String? po;
  int? lineitno;
  int? seqno;
  String? tobeproducedquantity;
  int? producedqty;
  String? workstation;
  String? startprocesstime;
  String? endprocesstime;

  Operatorworkstatuslist(
      {this.id,
      this.product,
      this.revisionno,
      this.pdfmdcid,
      this.po,
      this.lineitno,
      this.seqno,
      this.tobeproducedquantity,
      this.producedqty,
      this.workstation,
      this.startprocesstime,
      this.endprocesstime});

  Operatorworkstatuslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'];
    revisionno = json['revisionno'];
    pdfmdcid = json['pdfmdoc_id'];
    po = json['po'];
    lineitno = json['lineitno'];
    seqno = json['seqno'];
    tobeproducedquantity = json['tobeproducedquantity'];
    producedqty = json['produced_qty'];
    workstation = json['workstation'];
    startprocesstime = json['startprocesstime'];
    endprocesstime = json['endprocesstime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product;
    data['revisionno'] = revisionno;
    data['pdfmdoc_id'] = pdfmdcid;
    data['po'] = po;
    data['lineitno'] = lineitno;
    data['seqno'] = seqno;
    data['tobeproducedquantity'] = tobeproducedquantity;
    data['produced_qty'] = producedqty;
    data['workstation'] = workstation;
    data['startprocesstime'] = startprocesstime;
    data['endprocesstime'] = endprocesstime;
    return data;
  }
}

class ResponseId {
  String? newRequestId;

  ResponseId({this.newRequestId});

  ResponseId.fromJson(Map<String, dynamic> json) {
    newRequestId = json['new_request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new_request_id'] = newRequestId;
    return data;
  }
}

class MachinIpUsername {
  String? machineid;
  String? machinename;
  String? machineip;
  String? machineuser;

  MachinIpUsername(
      {this.machineid, this.machinename, this.machineip, this.machineuser});

  MachinIpUsername.fromJson(Map<String, dynamic> json) {
    machineid = json['machineid'];
    machinename = json['machinename'];
    machineip = json['machineip'];
    machineuser = json['machineuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['machineid'] = machineid;
    data['machinename'] = machinename;
    data['machineip'] = machineip;
    data['machineuser'] = machineuser;
    return data;
  }
}
