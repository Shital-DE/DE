// Author : Shital Gayakwad
// Created date : 20 September 2023
// Description : Product resource managements bloc
// Modified date : 12 - Oct 2023
// Added machine program verification code


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/product/product.dart';
import '../../../services/model/product/product_resource_management_model.dart';
import '../../../services/model/product/product_route.dart';
import '../../../services/repository/product/product_repository.dart';
import '../../../services/repository/product/product_resource_management_repo.dart';
import '../../../services/repository/product/product_route_repo.dart';
import '../../../services/session/user_login.dart';
import 'product_resource_management_event.dart';
import 'product_resource_management_state.dart';

// ============================================================ Machine Programs upload =====================================================

class ProductResourceManagementBloc extends Bloc<ProductResourceManagementEvent,
    ProductResourceManagementState> {
  ProductResourceManagementBloc() : super(UploadMachineProgramInitialState()) {
    // Upload machine program
    on<UploadMachineProgramEvent>((event, emit) async {
      try {
        List<ProductMaterData> productData = [];
        List<ProductAndProcessRouteModel> productAndProcessRouteDataList = [];

        // User data and token
        final saveddata = await UserData.getUserData();

        // Product route filled product list
        Map<String, dynamic> productrouteData = await ProductRouteRepository()
            .filledProductAndProcessRoute(token: saveddata['token'].toString());

        if (event.productId != '') {
          // Product master data
          productData = await ProductRepository().productDataFromMaster(
              id: event.productId.toString(),
              token: saveddata['token'].toString());

          // Product route
          if (event.productRevision != '') {
            productAndProcessRouteDataList = await ProductRouteRepository()
                .getProductAndProcessRoute(token: saveddata['token'], payload: {
              'product_id': event.productId,
              'revision_number': event.productRevision
            });
          }
        }

        emit(UploadMachineProgramState(
            productData: productData,
            token: saveddata['token'].toString(),
            productId: event.productId,
            productRevision: event.productRevision,
            productAndProcessRouteDataList: productAndProcessRouteDataList,
            processRouteId: event.processRouteId,
            userId: saveddata['data'][0]['id'],
            productList: productrouteData['data']));
      } catch (e) {
        emit(
            UploadMachineProgramErrorState(errorMessage: 'Server unreachable'));
      }
    });

    // ====================================================== Verify machine programs =================================================
    on<VerifyMachineProgramEvent>((event, emit) async {
      // User data and token
      final saveddata = await UserData.getUserData();
      List<UnVerifiedMachinePrograms> unVerifiedPrograms =
          await ProductResourceManagementRepository().programsForVerification(
              token: saveddata['token'].toString(), footerIndex: event.index);
      emit(VerifyMachineProgramState(
          unVerifiedPrograms: unVerifiedPrograms,
          token: saveddata['token'].toString(),
          userId: saveddata['data'][0]['id'].toString(),
          index: event.index));
    });

    // ====================================================== Verified machine programs =================================================
    on<VerifiedMachineProgramEvent>((event, emit) async {
      // User data and token
      final saveddata = await UserData.getUserData();
      List<VerifiedMachineProgramsModel> verifiedMachinePrograms =
          await ProductResourceManagementRepository().verifiedPrograms(
              token: saveddata['token'].toString(), footerIndex: event.index);
      emit(VerifiedMachineProgramsState(
          token: saveddata['token'].toString(),
          verifiedMachinePrograms: verifiedMachinePrograms,
          userId: saveddata['data'][0]['id'].toString(),
          index: event.index));
    });

    //======================================== New Product list for cad lab =================
    // this is for new product list which is comes 1st time in production
    on<NewProductionProductEvent>((event, emit) async {
      // User data and token
      final saveddata = await UserData.getUserData();
      List<NewProductionProductmodel> newProductionproductttt =
          await ProductResourceManagementRepository().newProductionproduct(
              token: saveddata['token'].toString(), footerIndex: event.index);
      emit(NewProductionproductState(
          token: saveddata['token'].toString(),
          newProductionproduct: newProductionproductttt,
          userId: saveddata['data'][0]['id'].toString(),
          index: event.index));
    });
  }
}
