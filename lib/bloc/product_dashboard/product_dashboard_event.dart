// Author : Shital Gayakwad
// Created Date : 23 October 2024
// Description : Product structure event

import '../../services/model/product/product_structure_model.dart';

class ProductDashboardEvent {}

class ProductRegistrationEvent extends ProductDashboardEvent {}

class ProductStructureEvent extends ProductDashboardEvent {}

class ProductInventoryManagementEvent extends ProductDashboardEvent {
  final ProductsWithRevisionDataModel productsWithRevisionDataModel;

  ProductInventoryManagementEvent(
      {ProductsWithRevisionDataModel? productsWithRevisionDataModel})
      : productsWithRevisionDataModel =
            productsWithRevisionDataModel ?? ProductsWithRevisionDataModel();
}
