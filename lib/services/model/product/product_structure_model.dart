// Author : Shital Gayakwad
// Created Date : 23 October 2024
// Description : Product structure model

class ProductsWithRevisionDataModel {
  String? product;
  List<String>? revisionNumbers;
  String? description;
  String? producttype;
  String? uom;
  String? productId;
  String? producttypeId;
  String? uomId;
  String? updatedon;

  ProductsWithRevisionDataModel(
      {this.product,
      this.revisionNumbers,
      this.description,
      this.producttype,
      this.uom,
      this.productId,
      this.producttypeId,
      this.uomId,
      this.updatedon});

  ProductsWithRevisionDataModel.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    revisionNumbers = json['revision_numbers'].cast<String>();
    description = json['description'];
    producttype = json['producttype'];
    uom = json['uom'];
    productId = json['product_id'];
    producttypeId = json['producttype_id'];
    uomId = json['uom_id'];
    updatedon = json['updatedon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['revision_numbers'] = revisionNumbers;
    data['description'] = description;
    data['producttype'] = producttype;
    data['uom'] = uom;
    data['product_id'] = productId;
    data['producttype_id'] = producttypeId;
    data['uom_id'] = uomId;
    data['updatedon'] = updatedon;
    return data;
  }
}

// Product tree model
class ProductStructureDetailsModel {
  List<BuildProductStructure>? buildProductStructure;

  ProductStructureDetailsModel({this.buildProductStructure});

  ProductStructureDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['build_product_structure'] != null) {
      buildProductStructure = <BuildProductStructure>[];
      json['build_product_structure'].forEach((v) {
        buildProductStructure!.add(BuildProductStructure.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buildProductStructure != null) {
      data['build_product_structure'] =
          buildProductStructure!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BuildProductStructure {
  String? part;
  int? level;
  String? partId;
  List<BuildProductStructure>? children;
  int? leadtime;
  int? quantity;
  String? revision;
  String? description;
  String? parentPart;
  String? producttype;
  String? parentpartId;
  int? reorderLevel;
  String? producttypeId;
  int? minOrderQuantity;
  String? structureTableId;
  String? unitOfMeasurement;
  String? unitOfMeasurementId;
  String? parentPartStructTableId;
  String? oldStructureTableId;
  double? currentstock;
  double? issuedquantity;

  BuildProductStructure({
    this.part,
    this.level,
    this.partId,
    this.children,
    this.leadtime,
    this.quantity,
    this.revision,
    this.description,
    this.parentPart,
    this.producttype,
    this.parentpartId,
    this.reorderLevel,
    this.producttypeId,
    this.minOrderQuantity,
    this.structureTableId,
    this.unitOfMeasurement,
    this.unitOfMeasurementId,
    this.parentPartStructTableId,
    this.oldStructureTableId,
    this.currentstock,
    this.issuedquantity,
  });

  BuildProductStructure.fromJson(Map<String, dynamic> json) {
    part = json['part'];
    level = json['level'];
    partId = json['part_id'];
    if (json['children'] != null) {
      children = <BuildProductStructure>[];
      json['children'].forEach((v) {
        children!.add(BuildProductStructure.fromJson(v));
      });
    }
    leadtime = json['leadtime'];
    quantity = json['quantity'];
    revision = json['revision'];
    description = json['description'];
    parentPart = json['parent_part'];
    producttype = json['producttype'];
    parentpartId = json['parentpart_id'];
    reorderLevel = json['reorder_level'];
    producttypeId = json['producttype_id'];
    minOrderQuantity = json['min_order_quantity'];
    structureTableId = json['structure_table_id'];
    unitOfMeasurement = json['unit_of_measurement'];
    unitOfMeasurementId = json['unit_of_measurement_id'];
    parentPartStructTableId = json['parent_part_struct_table_id'];
    oldStructureTableId = json['old_structure_table_id'];
    currentstock = json['currentstock'] != null
        ? double.tryParse(json['currentstock'].toString())
        : null;
    issuedquantity = json['issuedquantity'] != null
        ? double.tryParse(json['issuedquantity'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['part'] = part;
    data['level'] = level;
    data['part_id'] = partId;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    data['leadtime'] = leadtime;
    data['quantity'] = quantity;
    data['revision'] = revision;
    data['description'] = description;
    data['parent_part'] = parentPart;
    data['producttype'] = producttype;
    data['parentpart_id'] = parentpartId;
    data['reorder_level'] = reorderLevel;
    data['producttype_id'] = producttypeId;
    data['min_order_quantity'] = minOrderQuantity;
    data['structure_table_id'] = structureTableId;
    data['unit_of_measurement'] = unitOfMeasurement;
    data['unit_of_measurement_id'] = unitOfMeasurementId;
    data['parent_part_struct_table_id'] = parentPartStructTableId;
    data['old_structure_table_id'] = oldStructureTableId;
    data['currentstock'] = currentstock;
    data['issuedquantity'] = issuedquantity;
    return data;
  }
}

// Select product
class SelectedProductModel {
  String productid, revision, productTypeId;
  SelectedProductModel(
      {this.productid = '', this.revision = '', this.productTypeId = ''});

  Map<String, dynamic> toJson() {
    return {
      'productid': productid,
      'revision': revision,
      'productTypeId': productTypeId
    };
  }

  factory SelectedProductModel.fromJson(Map<String, dynamic> json) {
    return SelectedProductModel(
        productid: json['productid'] ?? '',
        revision: json['revision'] ?? '',
        productTypeId: json['productTypeId'] ?? '');
  }
}

// Product registration
// Unit of measurement
class UOMDataModel {
  String? id;
  String? uomCode;
  String? uomName;

  UOMDataModel({this.id, this.uomCode, this.uomName});

  UOMDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uomCode = json['uom_code'];
    uomName = json['uom_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uom_code'] = uomCode;
    data['uom_name'] = uomName;
    return data;
  }
}

// Product type
class ProductTypeDataModel {
  String? id;
  String? producttypeCode;
  String? producttypeName;

  ProductTypeDataModel({this.id, this.producttypeCode, this.producttypeName});

  ProductTypeDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    producttypeCode = json['producttype_code'];
    producttypeName = json['producttype_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['producttype_code'] = producttypeCode;
    data['producttype_name'] = producttypeName;
    return data;
  }
}

// Product inventory details model
class ProductInventoryManagementDetailsModel {
  String stockEvent,
      selectedRevisionNumber,
      uomId,
      parentProductId,
      soDetailsId,
      soNumber;
  int quantity;
  ProductInventoryManagementDetailsModel(
      {this.selectedRevisionNumber = '',
      this.stockEvent = '',
      this.quantity = 0,
      this.uomId = '',
      this.parentProductId = '',
      this.soDetailsId = '',
      this.soNumber = ''});
}

// Unit of measurement
class UnitOfMeasurementDataModel {
  String? id;
  String? code;
  String? name;

  UnitOfMeasurementDataModel({this.id, this.code, this.name});

  UnitOfMeasurementDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

// Current sales orders for issue stoxk
class CurrentSalesOrdersDataModel {
  String? product;
  String? revisionNumber;
  String? po;
  String? quantity;
  String? ssSalesorderId;
  String? productId;

  CurrentSalesOrdersDataModel(
      {this.product,
      this.revisionNumber,
      this.po,
      this.quantity,
      this.ssSalesorderId,
      this.productId});

  CurrentSalesOrdersDataModel.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    revisionNumber = json['revision_number'];
    po = json['po'];
    quantity = json['quantity'];
    ssSalesorderId = json['ss_salesorder_id'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['revision_number'] = revisionNumber;
    data['po'] = po;
    data['quantity'] = quantity;
    data['ss_salesorder_id'] = ssSalesorderId;
    data['product_id'] = productId;
    return data;
  }
}

class IssuedStockModel {
  String? issuedQuantity;
  String? issuedOn;
  String? issuedBy;
  String? productLedgerId;
  String? productinventoryId;
  String? parentproductId;
  String? sodetailsId;
  String? uomId;
  String? productionscheduleId;

  IssuedStockModel(
      {this.issuedQuantity,
      this.issuedOn,
      this.issuedBy,
      this.productLedgerId,
      this.productinventoryId,
      this.parentproductId,
      this.sodetailsId,
      this.uomId,
      this.productionscheduleId});

  IssuedStockModel.fromJson(Map<String, dynamic> json) {
    issuedQuantity = json['issued_quantity'];
    issuedOn = json['issued_on'];
    issuedBy = json['issued_by'];
    productLedgerId = json['product_ledger_id'];
    productinventoryId = json['productinventory_id'];
    parentproductId = json['parentproduct_id'];
    sodetailsId = json['sodetails_id'];
    uomId = json['uom_id'];
    productionscheduleId = json['productionschedule_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['issued_quantity'] = issuedQuantity;
    data['issued_on'] = issuedOn;
    data['issued_by'] = issuedBy;
    data['product_ledger_id'] = productLedgerId;
    data['productinventory_id'] = productinventoryId;
    data['parentproduct_id'] = parentproductId;
    data['sodetails_id'] = sodetailsId;
    data['uom_id'] = uomId;
    data['productionschedule_id'] = productionscheduleId;
    return data;
  }
}

// class IssuedStockModel {
//   double? totalIssuedStock;
//   List<IssuedStock>? issuedStock;

//   IssuedStockModel({this.totalIssuedStock, this.issuedStock});

//   IssuedStockModel.fromJson(Map<String, dynamic> json) {
//     totalIssuedStock = json['total_issued_stock'] != null
//         ? double.tryParse(json['total_issued_stock'].toString())
//         : null;

//     // totalIssuedStock = json['total_issued_stock'];
//     if (json['issued_stock'] != null) {
//       issuedStock = <IssuedStock>[];
//       json['issued_stock'].forEach((v) {
//         issuedStock!.add(IssuedStock.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total_issued_stock'] = totalIssuedStock;
//     if (issuedStock != null) {
//       data['issued_stock'] = issuedStock!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class IssuedStock {
//   String? issuedQuantity;
//   String? issuedOn;
//   String? issuedBy;
//   String? productLedgerId;
//   String? productinventoryId;
//   String? parentproductId;
//   String? sodetailsId;
//   String? uomId;
//   String? productionscheduleId;

//   IssuedStock(
//       {this.issuedQuantity,
//       this.issuedOn,
//       this.issuedBy,
//       this.productLedgerId,
//       this.productinventoryId,
//       this.parentproductId,
//       this.sodetailsId,
//       this.uomId,
//       this.productionscheduleId});

//   IssuedStock.fromJson(Map<String, dynamic> json) {
//     issuedQuantity = json['issued_quantity'];
//     issuedOn = json['issued_on'];
//     issuedBy = json['issued_by'];
//     productLedgerId = json['product_ledger_id'];
//     productinventoryId = json['productinventory_id'];
//     parentproductId = json['parentproduct_id'];
//     sodetailsId = json['sodetails_id'];
//     uomId = json['uom_id'];
//     productionscheduleId = json['productionschedule_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['issued_quantity'] = issuedQuantity;
//     data['issued_on'] = issuedOn;
//     data['issued_by'] = issuedBy;
//     data['product_ledger_id'] = productLedgerId;
//     data['productinventory_id'] = productinventoryId;
//     data['parentproduct_id'] = parentproductId;
//     data['sodetails_id'] = sodetailsId;
//     data['uom_id'] = uomId;
//     data['productionschedule_id'] = productionscheduleId;
//     return data;
//   }
// }
