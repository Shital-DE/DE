// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Documents model

class DocumentDetails {
  String? pdProductId;
  String? updatedon;
  String? mdocId;
  String? imagetypeCode;
  String? code;
  String? description;
  String? revisionNumber;

  DocumentDetails(
      {this.pdProductId,
      this.updatedon,
      this.mdocId,
      this.imagetypeCode,
      this.code,
      this.description,
      this.revisionNumber});

  DocumentDetails.fromJson(Map<String, dynamic> json) {
    pdProductId = json['pd_product_id'];
    updatedon = json['updatedon'];
    mdocId = json['mdoc_id'];
    imagetypeCode = json['imagetype_code'];
    code = json['code'];
    description = json['description'];
    revisionNumber = json['revision_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pd_product_id'] = pdProductId;
    data['updatedon'] = updatedon;
    data['mdoc_id'] = mdocId;
    data['imagetype_code'] = imagetypeCode;
    data['code'] = code;
    data['description'] = description;
    data['revision_number'] = revisionNumber;
    return data;
  }
}

class MergedDocumentsData {
  String? productCode;
  String? productDescription;
  String? pdfRevisionNumber;
  String? modelRevisionNumber;
  String? modelImageType;
  String? pdfImageType;
  String? pdfMdocId;
  String? modelMdocId;
  String? modelUpdateTime;
  String? pdfUpdateTime;
  String? productId;

  MergedDocumentsData(
      {this.productCode,
      this.productDescription,
      this.pdfRevisionNumber,
      this.modelRevisionNumber,
      this.modelImageType,
      this.pdfImageType,
      this.pdfMdocId,
      this.modelMdocId,
      this.modelUpdateTime,
      this.pdfUpdateTime,
      this.productId});

  MergedDocumentsData.fromJson(Map<String, dynamic> json) {
    productCode = json['product_code'];
    productDescription = json['product_description'];
    pdfRevisionNumber = json['pdf_revision_number'];
    modelRevisionNumber = json['model_revision_number'];
    modelImageType = json['model_image_type'];
    pdfImageType = json['pdf_image_type'];
    pdfMdocId = json['pdf_mdoc_id'];
    modelMdocId = json['model_mdoc_id'];
    modelUpdateTime = json['model_update_time'];
    pdfUpdateTime = json['pdf_update_time'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_code'] = productCode;
    data['product_description'] = productDescription;
    data['pdf_revision_number'] = pdfRevisionNumber;
    data['model_revision_number'] = modelRevisionNumber;
    data['model_image_type'] = modelImageType;
    data['pdf_image_type'] = pdfImageType;
    data['pdf_mdoc_id'] = pdfMdocId;
    data['model_mdoc_id'] = modelMdocId;
    data['model_update_time'] = modelUpdateTime;
    data['pdf_update_time'] = pdfUpdateTime;
    data['product_id'] = productId;
    return data;
  }
}
