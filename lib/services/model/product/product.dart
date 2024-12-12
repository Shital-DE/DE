// Author : Shital Gayakwad
// Created Date : 23 April 2023
// Description : ERPX_PPC -> Product repository
// Modified By : Nilesh Desai
// Modified date : 18 July 2023

class AllProductModel {
  String? id;
  String? code;
  String? description;
  String? updatedon;

  AllProductModel({
    this.id,
    this.code,
    this.description,
    this.updatedon,
  });

  AllProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
    updatedon = json['updatedon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['description'] = description;
    data['updatedon'] = updatedon;
    return data;
  }
}

class ProductMaterData {
  String? id;
  String? code;
  String? revisionnumber;
  String? description;
  String? updatedon;

  ProductMaterData({
    this.id,
    this.code,
    this.revisionnumber,
    this.description,
    this.updatedon,
  });

  ProductMaterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    revisionnumber = json['revision_number'];
    description = json['description'];
    updatedon = json['updatedon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['revision_number'] = revisionnumber;
    data['description'] = description;
    data['updatedon'] = updatedon;

    return data;
  }
}

// Production instructions
class ProductionInstructions {
  String? id;
  String? pdProductId;
  String? revisionNumber;
  String? instruction;
  int? processsequencenumber;

  ProductionInstructions(
      {this.id,
      this.pdProductId,
      this.revisionNumber,
      this.instruction,
      this.processsequencenumber});

  ProductionInstructions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pdProductId = json['pd_product_id'];
    revisionNumber = json['revision_number'];
    instruction = json['instruction'];
    processsequencenumber = json['processsequencenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pd_product_id'] = pdProductId;
    data['revision_number'] = revisionNumber;
    data['instruction'] = instruction;
    data['processsequencenumber'] = processsequencenumber;
    return data;
  }
}

// Production instructions with documents
class ProductionInstructionsWithDocuments {
  String? id;
  String? mdocId;
  String? remark;
  String? imagetypeCode;

  ProductionInstructionsWithDocuments(
      {this.id, this.mdocId, this.remark, this.imagetypeCode});

  ProductionInstructionsWithDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mdocId = json['mdoc_id'];
    remark = json['remark'];
    imagetypeCode = json['imagetype_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mdoc_id'] = mdocId;
    data['remark'] = remark;
    data['imagetype_code'] = imagetypeCode;
    return data;
  }
}

class Machinecatergory {
  String? id;
  String? machinecategory;

  Machinecatergory({
    this.id,
    this.machinecategory,
  });

  Machinecatergory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    machinecategory = json['machinecategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['machinecategory'] = machinecategory;

    return data;
  }
}
