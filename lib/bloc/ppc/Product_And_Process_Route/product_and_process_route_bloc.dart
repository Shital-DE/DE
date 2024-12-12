//  Author : Shital Gayakwad
// Description : ERPX_PPC -> Product and Process route bloc
// Created : 24 August 2023

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/machine/workcentre.dart';
import '../../../services/model/machine/workstation.dart';
import '../../../services/model/product/product_route.dart';
import '../../../services/repository/common/tablet_repository.dart';
import '../../../services/repository/product/product_repository.dart';
import '../../../services/repository/product/product_route_repo.dart';
import '../../../services/session/user_login.dart';
part 'product_and_process_route_event.dart';
part 'product_and_process_route_state.dart';

class ProductAndProcessRouteBloc
    extends Bloc<ProductAndProcessRouteEvent, ProductAndProcessRouteState> {
  ProductAndProcessRouteBloc() : super(ProductAndProcessRouteInitial()) {
    on<GetProductProcessRouteParams>((event, emit) async {
      try {
        String productBillOfMaterialId = '';
        List<ProductRevision> productRevisionList = [];
        List<WorkstationByWorkcentreId> workstationList = [];
        List<Workcentre> workcentreList = [];
        List<ProductAndProcessRouteModel> productAndProcessRouteDataList = [];
        List<Process> processList = [];
        String wkstation = '', workstationid = '';
        Iterable<ProductAndProcessRouteModel> processData = [];
        //User data
        final saveddata = await UserData.getUserData();

        if (event.workcentreid == '402881757458eb2201745cae957a001b') {
          // Outsource workcentre id '402881757458eb2201745cae957a001b'
          processList = await ProductRouteRepository()
              .processes(token: saveddata['token'].toString());
        }

        if (event.productId != '') {
          // Product bill of material
          productBillOfMaterialId = await ProductRepository()
              .productBillOfMaterialId(
                  token: saveddata['token'].toString(),
                  payload: {
                'product_id': event.productId,
              });

          if (productBillOfMaterialId !=
              'RangeError (index): Invalid value: Valid value range is empty: 0') {
            // Product revision
            final revision = await ProductRepository().productRevision(
                token: saveddata['token'].toString(),
                payload: {'product_id': event.productId});
            productRevisionList = revision;

            final workcentre = await TabletRepository()
                .deletedFalseWorkcentreList(
                    token: saveddata['token'].toString());
            workcentreList = workcentre;
            if (event.workcentreid != '') {
              final workstation = await TabletRepository().worstationByWcId(
                  token: saveddata['token'].toString(),
                  workcentreId: event.workcentreid);
              workstationList = workstation;
              if (workstationList.isNotEmpty) {
                wkstation = workstationList[0].code.toString();
                workstationid = workstationList[0].id.toString();
              }
            }

            if (event.productRevision != '' &&
                event.productAndProcessRouteDataList.isEmpty) {
              final response = await ProductRouteRepository()
                  .getProductAndProcessRoute(
                      token: saveddata['token'],
                      payload: {
                    'product_id': event.productId,
                    'revision_number': event.productRevision
                  });
              productAndProcessRouteDataList = response;
            }

            if (event.updateData == '') {
              if (productAndProcessRouteDataList.isNotEmpty) {
                processData = productAndProcessRouteDataList
                    .where((element) => element.processId != null);
              }

              if (event.productAndProcessRouteDataList.isNotEmpty) {
                processData = event.productAndProcessRouteDataList
                    .where((element) => element.processId != null);
              }
            }

            emit(SetProductProcessRouteParams(
                productRevisionList: productRevisionList,
                productId: event.productId,
                productRevision: event.productRevision,
                workcentreid: event.workcentreid,
                workstationid: event.workstationid != ''
                    ? event.workstationid
                    : workstationid,
                workcentreList: workcentreList,
                workstationList: workstationList,
                desciption: event.desciption,
                runtimeMinutes: event.runtimeMinutes,
                setupMinutes: event.setupMinutes,
                token: saveddata['token'].toString(),
                userId: saveddata['data'][0]['id'].toString(),
                productbillofmaterialId: productBillOfMaterialId,
                productAndProcessRouteDataList:
                    event.productAndProcessRouteDataList.isEmpty
                        ? productAndProcessRouteDataList
                        : event.productAndProcessRouteDataList,
                sequencenumber: event.sequencenumber,
                addNewRow: event.addNewRow,
                workcentre: event.workcentre,
                workstation:
                    event.workstation != '' ? event.workstation : wkstation,
                topBottomDataAaray: event.topBottomDataAaray,
                updateData: event.updateData,
                processId: event.processId,
                processList: processList,
                processName: event.processName,
                processData: processData));
          } else {
            emit(ProductProcessRouteErrorState(
                errorMessage: 'Product bill of material id not found'));
          }
        } else {
          emit(ProductProcessRouteErrorState(
              errorMessage: 'Please select product'));
        }
      } catch (e) {
        emit(ProductProcessRouteErrorState(errorMessage: e.toString()));
      }
    });
  }
}

// ======================================= Already Filled Product ===============================================

class ProductRouteBloc
    extends Bloc<ProductRouteDataEvent, ProductRouteDataState> {
  ProductRouteBloc() : super(const ProductRouteDataInitialState()) {
    on<GetProductRouteData>((event, emit) async {
      try {
        final saveddata = await UserData.getUserData();

        Map<String, dynamic> productrouteData = await ProductRouteRepository()
            .filledProductAndProcessRoute(token: saveddata['token'].toString());
        emit(SetProductRouteData(
            routeData: productrouteData['data'],
            routeCount: productrouteData['count']));
      } catch (e) {
        emit(ProductRouteErrorState(errorMessage: e.toString()));
      }
    });
  }
}
