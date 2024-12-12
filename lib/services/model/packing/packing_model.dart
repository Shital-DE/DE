// Author : Shital Gayakwad
// Created Date : 29 Nov 2023
// Description : Packing model

class AvailableStock {
  String? product;
  String? revision;
  int? stockqty;
  String? boxnumber;
  String? stockUploader;
  String? id;
  String? pdProductId;
  String? updatedon;
  String? updatedby;

  AvailableStock(
      {this.product,
      this.revision,
      this.stockqty,
      this.boxnumber,
      this.stockUploader,
      this.id,
      this.pdProductId,
      this.updatedon,
      this.updatedby});

  AvailableStock.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    revision = json['revision'];
    stockqty = json['stockqty'];
    boxnumber = json['boxnumber'];
    stockUploader = json['stock_uploader'];
    id = json['id'];
    pdProductId = json['pd_product_id'];
    updatedon = json['updatedon'];
    updatedby = json['updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['revision'] = revision;
    data['stockqty'] = stockqty;
    data['boxnumber'] = boxnumber;
    data['stock_uploader'] = stockUploader;
    data['id'] = id;
    data['pd_product_id'] = pdProductId;
    data['updatedon'] = updatedon;
    data['updatedby'] = updatedby;
    return data;
  }
}
