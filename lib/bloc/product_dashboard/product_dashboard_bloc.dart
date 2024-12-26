// Author : Shital Gayakwad
// Created Date : 23 October 2024
// Description : Product structure bloc

import 'package:de/bloc/product_dashboard/product_dashboard_event.dart';
import 'package:de/bloc/product_dashboard/product_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/model/product/product_inventory_model.dart';
import '../../services/model/product/product_structure_model.dart';
import '../../services/repository/product/pam_repository.dart';
import '../../services/session/user_login.dart';

class ProductDashboardBloc
    extends Bloc<ProductDashboardEvent, ProductDashboardState> {
  ProductDashboardBloc() : super(ProductAssetsManagementInitialState()) {
    // Product registration
    on<ProductRegistrationEvent>((event, emit) async {
      final saveddata = await UserData.getUserData();
      List<UOMDataModel> unitOfMeasurementList =
          await PamRepository().getUOM(token: saveddata['token'].toString());
      List<ProductTypeDataModel> productTypeList = await PamRepository()
          .getProductType(token: saveddata['token'].toString());
      emit(ProductRegistrationState(
          unitOfMeasurementList: unitOfMeasurementList,
          productTypeList: productTypeList));
    });
    // Product structure
    on<ProductStructureEvent>((event, emit) async {
      // User data
      final saveddata = await UserData.getUserData();

      // Product data
      List<ProductsWithRevisionDataModel> productsList = await PamRepository()
          .getProductsData(token: saveddata['token'].toString());
      emit(ProductStructureState(
          productsList: productsList,
          token: saveddata['token'].toString(),
          userId: saveddata['data'][0]['id']));
    });

    // Product inventory management
    on<ProductInventoryManagementEvent>((event, emit) async {
      ProductCurrentStock? currentStockModel;
      // User data
      final saveddata = await UserData.getUserData();

      // Product data
      List<ProductsWithRevisionDataModel> productsList = await PamRepository()
          .getProductsData(token: saveddata['token'].toString());

      // Unit of measurement
      List<UOMDataModel> unitOfMeasurementList =
          await PamRepository().getUOM(token: saveddata['token'].toString());

      // Current stock
      if (event.productsWithRevisionDataModel.productId != null) {
        currentStockModel = await PamRepository().getCurrentStock(
            token: saveddata['token'].toString(),
            productId: event.productsWithRevisionDataModel.productId.toString(),
            revision: event.revision.toString());
      }

      List<CurrentSalesOrdersDataModel> salesOrderDataList =
          await PamRepository().getSalesOrdersDataForIssueStock(
              token: saveddata['token'].toString());

      emit(ProductInventoryManagementState(
          productsList: productsList,
          token: saveddata['token'].toString(),
          userId: saveddata['data'][0]['id'],
          unitOfMeasurementList: unitOfMeasurementList,
          productsWithRevisionDataModel: event.productsWithRevisionDataModel,
          currentStockModel: currentStockModel ?? ProductCurrentStock(),
          salesOrderDataList: salesOrderDataList));
    });
  }
}
