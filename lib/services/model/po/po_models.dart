import '../registration/subcontractor_models.dart';

class SalesOrder {
  String? salesorderid;
  String? salesorder;
  String? plandate;
  String? duedate;
  List<SalesOrderDetails>? salesOrderDetails;

  SalesOrder(
      {this.salesorderid,
      this.salesorder,
      this.plandate,
      this.duedate,
      this.salesOrderDetails});

  SalesOrder.fromJson(Map<String, dynamic> json) {
    salesorderid = json['salesorderid'];
    salesorder = json['salesorder'];
    plandate = json['plandate'];
    duedate = json['duedate'];
    if (json['salesOrderDetails'] != null) {
      salesOrderDetails = <SalesOrderDetails>[];
      json['salesOrderDetails'].forEach((v) {
        salesOrderDetails!.add(SalesOrderDetails.fromJson(v));
      });
    }
  }
  bool get isEmpty => salesorderid == null || salesorderid!.isEmpty;
}

class SalesOrderDetails {
  String? sodetailsid;
  String? salesorderId;
  String? productId;
  String? plandate;
  int? lineitemnumber;
  String? revisionNumber;
  String? product;

  SalesOrderDetails(
      {this.sodetailsid,
      this.salesorderId,
      this.productId,
      this.plandate,
      this.lineitemnumber,
      this.revisionNumber,
      this.product});

  SalesOrderDetails.fromJson(Map<String, dynamic> json) {
    sodetailsid = json['sodetailsid'];
    salesorderId = json['salesorder_id'];
    productId = json['product_id'];
    plandate = json['plandate'];
    lineitemnumber = json['lineitemnumber'];
    revisionNumber = json['revision_number'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sodetailsid'] = sodetailsid;
    data['salesorder_id'] = salesorderId;
    data['product_id'] = productId;
    data['plandate'] = plandate;
    data['lineitemnumber'] = lineitemnumber;
    data['revision_number'] = revisionNumber;
    data['product'] = product;
    return data;
  }
}

class Outsource {
  String? salesorderid;
  String? salesorder;
  String? productid;
  String? product;
  String? revisionnumber;
  int? lineitemnumber;
  int? quantity;
  String? duedate;
  String? isinhouse;
  String? processid;
  String? process;
  String? instruction;
  bool isCheck = false;
  int? sequence;

  Outsource(
      {this.salesorderid,
      this.salesorder,
      this.productid,
      this.product,
      this.revisionnumber,
      this.lineitemnumber,
      this.quantity,
      this.duedate,
      this.isinhouse,
      this.processid,
      this.process,
      this.instruction,
      this.sequence,
      required this.isCheck});

  Outsource.fromJson(Map<String, dynamic> json) {
    salesorderid = json['salesorderid'];
    salesorder = json['salesorder'];
    productid = json['productid'];
    product = json['product'];
    revisionnumber = json['revision_number'];
    lineitemnumber = json['lineitemnumber'];
    quantity = json['quantity'];
    duedate = json['duedate'];
    isinhouse = json['isinhouse'];
    processid = json['processid'];
    process = json['process'];
    instruction = json['instruction'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['salesorderid'] = salesorderid;
    data['salesorder'] = salesorder;
    data['productid'] = productid;
    data['product'] = product;
    data['revision_number'] = revisionnumber;
    data['lineitemnumber'] = lineitemnumber;
    data['quantity'] = quantity;
    data['duedate'] = duedate;
    data['isinhouse'] = isinhouse;
    data['processid'] = processid;
    data['process'] = process;
    data['instruction'] = instruction;
    data['sequence'] = sequence;
    return data;
  }
}

class EODdetails {
  String? eodid;
  String? eoid;
  String? poid;
  String? pono;
  String? productid;
  String? productcode;
  int? lineitem;
  String? instruction;
  int? seqno;
  EODdetails({
    this.eodid,
    this.eoid,
    this.poid,
    this.pono,
    this.productid,
    this.productcode,
    this.lineitem,
    this.instruction,
    this.seqno,
  });

  EODdetails.fromJson(Map<String, dynamic> json) {
    eodid = json['eod.id'];
    eoid = json['eod.employee_overtime_id'];
    poid = json['po_id'];
    pono = json['pono'];
    productid = json['product_id'];
    productcode = json['productcode'];
    lineitem = json['lineitem'];
    seqno = json['seqno'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eod.id'] = eodid;
    data['eod.employee_overtime_id'] = eoid;
    data['po_id'] = poid;
    data['pono'] = pono;
    data['product_id'] = productid;
    data['productcode'] = productcode;
    data['lineitem'] = lineitem;
    data['instruction'] = instruction;
    data['seqno'] = seqno;
    return data;
  }
}

class Challan {
  int? outwardchallan;
  String? outsourceid;
  String? outsourcechildid;
  String? outsourcedate;
  String? subcontractorid;
  int? inwardqty;

  Challan(
      {this.outwardchallan,
      this.outsourceid,
      this.outsourcechildid,
      this.outsourcedate,
      this.subcontractorid,
      this.inwardqty = 0});

  Challan.fromJson(Map<String, dynamic> json) {
    outwardchallan = json['outwardchallan_no'];
    outsourceid = json['outsourceid'];
    outsourcechildid = json['outsourcechildid'];
    outsourcedate = json['outsource_date'];
    subcontractorid = json['subcontractor_id'];
    inwardqty = json['sumqty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['outwardchallan_no'] = outwardchallan;
    data['outsourceid'] = outsourceid;
    data['outsourcechildid'] = outsourcechildid;
    data['outsource_date'] = outsourcedate;
    data['subcontractor_id'] = subcontractorid;
    data['sumqty'] = inwardqty;
    return data;
  }
}

class InwardChallan {
  Outsource? outsource;
  Challan? challan;
  InwardChallan(this.outsource, this.challan);
}

class ProcessCapability {
  String? subcontractorName;
  String? processCode;
  String? id;
  String? subcontractorId;
  String? processId;

  ProcessCapability(
      {this.subcontractorName,
      this.processCode,
      this.id,
      this.subcontractorId,
      this.processId});

  ProcessCapability.fromJson(Map<String, dynamic> json) {
    subcontractorName = json['subcontractor_name'];
    processCode = json['process_code'];
    id = json['id'];
    subcontractorId = json['subcontractor_id'];
    processId = json['process_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcontractor_name'] = subcontractorName;
    data['process_code'] = processCode;
    data['id'] = id;
    data['subcontractor_id'] = subcontractorId;
    data['process_id'] = processId;
    return data;
  }
}

class CompanyDetails {
  String? id;
  String? code;
  String? name;
  String? address;
  String? gstin;
  String? pincode;

  CompanyDetails(
      {this.id, this.code, this.name, this.address, this.gstin, this.pincode});

  CompanyDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    address = json['address'];
    gstin = json['gstin'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['address'] = address;
    data['gstin'] = gstin;
    data['pincode'] = pincode;
    return data;
  }
}

class ChallanPDFList {
  Challan? challan;
  AllSubContractor? party;
  String? despatchthrough;
  List<Outsource> outlist;
  ChallanPDFList(
      {required this.challan,
      required this.party,
      required this.despatchthrough,
      required this.outlist});
}
