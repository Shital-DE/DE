// Author : Nilesh Desai & Shital Gayakwad
// Created Date : 18 July 2023
// Description : ERPX_PPC -> Production resource management bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/machine/workstation.dart';
import '../../../services/model/product/product.dart';
import '../../../services/model/product/product_route.dart';
import '../../../services/repository/product/product_repository.dart';
import '../../../services/session/user_login.dart';
import 'upload_product_details_event.dart';
import 'upload_product_details_state.dart';

class UploadproductdetailBloc
    extends Bloc<UploadproductdetailEvent, UploadproductdetailState> {
  UploadproductdetailBloc() : super(UploadproductdetailInitialState()) {
    on<ProductData>((event, emit) async {
      List<ProductMaterData> productData = [];
      List<ProductRoute> productRouteList = [];
      List<WorkstationByWorkcentreId> workstationList = [];

      //User data
      final saveddata = await UserData.getUserData();
      //Token
      String token = saveddata['token'].toString();
      try {
        final allProductData =
            await ProductRepository().allProductList(token: token);
        final docDataone = await ProductRepository().productDataFromMaster(
            id: event.productid.toString(), token: token);
        productData = docDataone;
        List<AllProductModel> allprodocutsList = allProductData;
        final productRoute = await ProductRepository().productRoute(
            token: token,
            payload: {
              'product_id': event.productid,
              'product_revision': event.productRevision
            });
        productRouteList = productRoute;
        emit(UploadproductdetailLoadingState(
            allprodocutsList: allprodocutsList,
            productData: productData,
            token: token,
            productid: event.productid,
            uploadProgram: event.uploadProgram,
            productRouteList: productRouteList,
            workstationList: workstationList,
            productRevision: event.productRevision,
            productRouteId: event.productRouteId,
            userId: saveddata['data'][0]['id'],
            productionInstructionsList: event.productionInstructionsList,
            selectedProductRoute: event.selectedProductRoute));
      } catch (e) {
        emit(UploadproductdetailError(errorMessage: e.toString()));
      }
    });
  }
}
