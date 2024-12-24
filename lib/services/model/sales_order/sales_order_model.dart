// Author : Shital Gayakwad
// Created Date : 15 November 2024
// Description : Sales orders model

class AllSalesOrdersModel {
  String? po;
  String? salesorderId;
  List<ProductsInOrder>? productsInOrder;

  AllSalesOrdersModel({this.po, this.salesorderId, this.productsInOrder});

  AllSalesOrdersModel.fromJson(Map<String, dynamic> json) {
    po = json['po'];
    salesorderId = json['salesorder_id'];
    if (json['products_in_order'] != null) {
      productsInOrder = <ProductsInOrder>[];
      json['products_in_order'].forEach((v) {
        productsInOrder!.add(ProductsInOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['po'] = po;
    data['salesorder_id'] = salesorderId;
    if (productsInOrder != null) {
      data['products_in_order'] =
          productsInOrder!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsInOrder {
  String? product;
  String? revision;
  String? productDescription;
  String? productType;
  int? quantity;
  String? dueDate;
  String? salesorderdetailsId;
  String? productId;
  String? producttypeId;
  bool? action;

  ProductsInOrder(
      {this.product,
      this.revision,
      this.productDescription,
      this.productType,
      this.quantity,
      this.dueDate,
      this.salesorderdetailsId,
      this.productId,
      this.producttypeId,
      this.action});

  ProductsInOrder.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    revision = json['revision'];
    productDescription = json['product_description'];
    productType = json['product_type'];
    quantity = json['quantity'];
    dueDate = json['due_date'];
    salesorderdetailsId = json['salesorderdetails_id'];
    productId = json['product_id'];
    producttypeId = json['producttype_id'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['revision'] = revision;
    data['product_description'] = productDescription;
    data['product_type'] = productType;
    data['quantity'] = quantity;
    data['due_date'] = dueDate;
    data['salesorderdetails_id'] = salesorderdetailsId;
    data['product_id'] = productId;
    data['producttype_id'] = producttypeId;
    data['action'] = action;
    return data;
  }
}

// Selected assemblies data model
class SelectedAssembliesComponentRequirements {
  String? po;
  String? childproduct;
  String? revisionNumber;
  String? productDescription;
  String? parentProduct;
  String? quantity;
  String? duedate;
  int? runnumber;
  String? assemblybomId;
  String? childproductId;
  String? parentproductId;
  String? sodetailsId;

  SelectedAssembliesComponentRequirements(
      {this.po,
      this.childproduct,
      this.revisionNumber,
      this.productDescription,
      this.parentProduct,
      this.quantity,
      this.duedate,
      this.runnumber,
      this.assemblybomId,
      this.childproductId,
      this.parentproductId,
      this.sodetailsId});

  SelectedAssembliesComponentRequirements.fromJson(Map<String, dynamic> json) {
    po = json['po'];
    childproduct = json['childproduct'];
    revisionNumber = json['revision_number'];
    productDescription = json['product_description'];
    parentProduct = json['parent_product'];
    quantity = json['quantity'];
    duedate = json['duedate'];
    runnumber = json['runnumber'];
    assemblybomId = json['assemblybom_id'];
    childproductId = json['childproduct_id'];
    parentproductId = json['parentproduct_id'];
    sodetailsId = json['sodetails_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['po'] = po;
    data['childproduct'] = childproduct;
    data['revision_number'] = revisionNumber;
    data['product_description'] = productDescription;
    data['parent_product'] = parentProduct;
    data['quantity'] = quantity;
    data['duedate'] = duedate;
    data['runnumber'] = runnumber;
    data['assemblybom_id'] = assemblybomId;
    data['childproduct_id'] = childproductId;
    data['parentproduct_id'] = parentproductId;
    data['sodetails_id'] = sodetailsId;
    return data;
  }
}
