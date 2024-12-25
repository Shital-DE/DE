// Author : Shital Gayakwad
// Created Date : 25 December 2024
// Description : Product inventory model

class ProductCurrentStock {
  String? productId;
  String? revisionNumber;
  double? totalInward;
  double? totalIssued;
  double? currentStock;

  ProductCurrentStock({
    this.productId,
    this.revisionNumber,
    this.totalInward,
    this.totalIssued,
    this.currentStock,
  });

  // Convert from JSON
  ProductCurrentStock.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    revisionNumber = json['revision_number'];
    totalInward = (json['total_inward'] != null)
        ? double.tryParse(json['total_inward'].toString())
        : null;
    totalIssued = (json['total_issued'] != null)
        ? double.tryParse(json['total_issued'].toString())
        : null;
    currentStock = (json['current_stock'] != null)
        ? double.tryParse(json['current_stock'].toString())
        : null;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['revision_number'] = revisionNumber;
    data['total_inward'] = totalInward;
    data['total_issued'] = totalIssued;
    data['current_stock'] = currentStock;
    return data;
  }
}
