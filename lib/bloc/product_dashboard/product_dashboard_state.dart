// Author : Shital Gayakwad
// Created Date : 23 October 2024
// Description : Product structure state

import '../../services/model/product/product_structure_model.dart';
import '../../view/widgets/product_structure_widget.dart';

class ProductDashboardState {}

class ProductAssetsManagementInitialState extends ProductDashboardState {}

class ProductRegistrationState extends ProductDashboardState {
  List<UOMDataModel> unitOfMeasurementList;
  List<ProductTypeDataModel> productTypeList;
  ProductRegistrationState(
      {required this.unitOfMeasurementList, required this.productTypeList});
}

class ProductStructureState extends ProductDashboardState {
  List<ProductsWithRevisionDataModel> productsList;
  List<List<String>> productTypeList;
  String token, userId;
  ProductStructureState(
      {required this.productsList,
      required this.token,
      required this.userId,
      this.productTypeList = const [
        ['Assembly', ProductTypeStaticDataModel.assemblyId],
        ['Part', ProductTypeStaticDataModel.partId],
        ['Hardware', ProductTypeStaticDataModel.hardwareId],
        ['Consumables', ProductTypeStaticDataModel.consumablesId]
      ]});
}

class ProductInventoryManagementState extends ProductDashboardState {
  final ProductsWithRevisionDataModel productsWithRevisionDataModel;
  List<ProductsWithRevisionDataModel> productsList;
  List<UOMDataModel> unitOfMeasurementList;
  List<CurrentSalesOrdersDataModel> salesOrderDataList;
  String token, userId;
  double currentStock;
  ProductInventoryManagementState(
      {required this.productsWithRevisionDataModel,
      required this.productsList,
      required this.token,
      required this.userId,
      required this.unitOfMeasurementList,
      required this.currentStock,
      required this.salesOrderDataList});
}
