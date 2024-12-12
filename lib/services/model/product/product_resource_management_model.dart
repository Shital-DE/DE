// Author : Shital Gayakwad
// Created date :12 Oct 2023
// Description : Product resource managements event
// Modified date : 12 Oct 2023

class UnVerifiedMachinePrograms {
  String? product;
  String? revision;
  String? workcentre;
  String? workstation;
  int? processSeqnumber;
  String? instruction;
  String? uploader;
  String? updatedon;
  String? id;
  String? createdby;
  String? pdProductId;
  String? programmdocId;
  String? remark;
  String? workcentreId;
  String? workstationId;
  String? processrouteId;
  bool? verify;
  String? pdfmdocId;

  UnVerifiedMachinePrograms(
      {this.product,
      this.revision,
      this.workcentre,
      this.workstation,
      this.processSeqnumber,
      this.instruction,
      this.uploader,
      this.updatedon,
      this.id,
      this.createdby,
      this.pdProductId,
      this.programmdocId,
      this.remark,
      this.workcentreId,
      this.workstationId,
      this.processrouteId,
      this.verify,
      this.pdfmdocId});

  UnVerifiedMachinePrograms.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    revision = json['revision'];
    workcentre = json['workcentre'];
    workstation = json['workstation'];
    processSeqnumber = json['process_seqnumber'];
    instruction = json['instruction'];
    uploader = json['uploader'];
    updatedon = json['updatedon'];
    id = json['id'];
    createdby = json['createdby'];
    pdProductId = json['pd_product_id'];
    programmdocId = json['programmdoc_id'];
    remark = json['remark'];
    workcentreId = json['workcentre_id'];
    workstationId = json['workstation_id'];
    processrouteId = json['processroute_id'];
    verify = json['verify'];
    pdfmdocId = json['pdfmdoc_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['revision'] = revision;
    data['workcentre'] = workcentre;
    data['workstation'] = workstation;
    data['process_seqnumber'] = processSeqnumber;
    data['instruction'] = instruction;
    data['uploader'] = uploader;
    data['updatedon'] = updatedon;
    data['id'] = id;
    data['createdby'] = createdby;
    data['pd_product_id'] = pdProductId;
    data['programmdoc_id'] = programmdocId;
    data['remark'] = remark;
    data['workcentre_id'] = workcentreId;
    data['workstation_id'] = workstationId;
    data['processroute_id'] = processrouteId;
    data['verify'] = verify;
    data['pdfmdoc_id'] = pdfmdocId;
    return data;
  }
}

class VerifiedMachineProgramsModel {
  String? product;
  String? revision;
  String? workcentre;
  String? workstation;
  int? processSeqnumber;
  String? instruction;
  String? remark;
  String? verifier;
  String? verificationdate;
  String? id;
  String? pdProductId;
  String? mdocId;
  String? workcentreId;
  String? workstationId;
  String? processrouteId;
  bool? verify;
  String? verifyby;

  VerifiedMachineProgramsModel(
      {this.product,
      this.revision,
      this.workcentre,
      this.workstation,
      this.processSeqnumber,
      this.instruction,
      this.remark,
      this.verifier,
      this.verificationdate,
      this.id,
      this.pdProductId,
      this.mdocId,
      this.workcentreId,
      this.workstationId,
      this.processrouteId,
      this.verify,
      this.verifyby});

  VerifiedMachineProgramsModel.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    revision = json['revision'];
    workcentre = json['workcentre'];
    workstation = json['workstation'];
    processSeqnumber = json['process_seqnumber'];
    instruction = json['instruction'];
    remark = json['remark'];
    verifier = json['verifier'];
    verificationdate = json['verificationdate'];
    id = json['id'];
    pdProductId = json['pd_product_id'];
    mdocId = json['mdoc_id'];
    workcentreId = json['workcentre_id'];
    workstationId = json['workstation_id'];
    processrouteId = json['processroute_id'];
    verify = json['verify'];
    verifyby = json['verifyby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['revision'] = revision;
    data['workcentre'] = workcentre;
    data['workstation'] = workstation;
    data['process_seqnumber'] = processSeqnumber;
    data['instruction'] = instruction;
    data['remark'] = remark;
    data['verifier'] = verifier;
    data['verificationdate'] = verificationdate;
    data['id'] = id;
    data['pd_product_id'] = pdProductId;
    data['mdoc_id'] = mdocId;
    data['workcentre_id'] = workcentreId;
    data['workstation_id'] = workstationId;
    data['processroute_id'] = processrouteId;
    data['verify'] = verify;
    data['verifyby'] = verifyby;
    return data;
  }
}

class NewProductionProductmodel {
  String? id;
  String? updatedon;
  String? product;
  String? revision;
  String? description;
  String? pdfmdocid;
  String? workstation;
  int? poqty;
  String? ponumber;
  String? employeename;
  NewProductionProductmodel({
    this.id,
    this.updatedon,
    this.product,
    this.revision,
    this.description,
    this.pdfmdocid,
    this.workstation,
    this.poqty,
    this.ponumber,
    this.employeename,
  });

  NewProductionProductmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedon = json['updatedon'];
    product = json['product'];
    revision = json['revision_no'];
    description = json['description'];
    pdfmdocid = json['pdfmdoc_id'];
    workstation = json['workstation'];
    poqty = json['poqty'];
    ponumber = json['po_number'];
    employeename = json['employeename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updatedon'];
    data['product'] = product;
    data['revision_no'] = revision;
    data['description'] = description;
    data['pdfmdoc_id'] = pdfmdocid;
    data['workstation'] = workstation;
    data['poqty'] = poqty;
    data['po_number'] = ponumber;
    data['employeename'] = employeename;
    return data;
  }
}
