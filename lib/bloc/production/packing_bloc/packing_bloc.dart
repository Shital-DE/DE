// Author : Shital Gayakwad
// Created Date : 26 Nov 2023
// Description : Packing bloc

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/common/document_model.dart';
import '../../../services/model/packing/packing_model.dart';
import '../../../services/model/product/product_route.dart';
import '../../../services/repository/common/documents_repository.dart';
import '../../../services/repository/packing/packing_repository.dart';
import '../../../services/repository/product/product_machine_route_repository.dart';
import '../../../services/repository/product/product_repository.dart';
import '../../../services/repository/product/product_route_repo.dart';
import '../../../services/repository/quality/quality_repository.dart';
import '../../../services/session/user_login.dart';
import 'packing_event.dart';
import 'packing_state.dart';

class PackingBloc extends Bloc<PackingEvent, PackingState> {
  PackingBloc() : super(PackingInitialState()) {
    // Packing production  bloc handler
    on<PackingProductionEvent>((event, emit) async {
      bool isAlreadyInspected = false;
      String pdfmdocid = '',
          pdfRevisionNo = '',
          modelMdocid = '',
          modelRevisionNumber = '',
          productDescription = '',
          imageType = '';

      final saveddata = await UserData.getUserData();
      final machineData = await MachineData.geMachineData();
      final macData = jsonDecode(machineData.toString());

      // Check if inspection is already started or not
      isAlreadyInspected = await QualityInspectionRepository()
          .jobInspectionStatusCheck(token: saveddata['token'], payload: {
        'product_id': event.barcode!.productid,
        'rmsissueid': event.barcode!.rawmaterialissueid,
        'workcentre_id': macData[0]['wr_workcentre_id'],
        'revision_number': event.barcode!.revisionnumber,
        'process_sequence': event.productAndProcessRouteModel!.combinedSequence
      });
      if (isAlreadyInspected == true) {
        emit(PackingErrorState(
            errorMessage:
                'The packing process for this product has been finished.'));
      } else {
        //PDF details
        List<DocumentDetails> pdfDetails = await DocumentsRepository()
            .pdfMdocId(saveddata['token'], event.barcode!.productid.toString());
        for (var element in pdfDetails) {
          pdfmdocid = element.mdocId.toString().trim();
          pdfRevisionNo = element.revisionNumber.toString().trim();
        }

        //Model details
        List<DocumentDetails> modelsDetails = await DocumentsRepository()
            .modelsMdocId(
                saveddata['token'], event.barcode!.productid.toString());
        for (var element in modelsDetails) {
          modelMdocid = element.mdocId.toString().trim();
          modelRevisionNumber = element.revisionNumber.toString().trim();
          productDescription = element.description.toString().trim();
          imageType = element.imagetypeCode.toString().trim();
        }
        // inspect id
        String packingId = await QualityInspectionRepository()
            .getproductworkstationJobStatusId(
                token: saveddata['token'],
                payload: {
              'product_id': event.barcode!.productid.toString(),
              'rms_issue_id': event.barcode!.rawmaterialissueid.toString(),
              'workcentre_id': macData[0]['wr_workcentre_id'],
              'workstation_id': macData[0]['workstationid'],
              'employee_id': saveddata['data'][0]['id'],
              'revision_number': event.barcode!.revisionnumber.toString(),
              'process_sequence':
                  event.productAndProcessRouteModel!.combinedSequence
            });

        if (packingId == '') {
          await ProductMachineRoute()
              .registerProductMachineRoute(token: saveddata['token'], payload: {
            'product_id': event.barcode!.productid.toString(),
            'product_revision': event.barcode!.revisionnumber.toString(),
            'workcentre_id': macData[0]['wr_workcentre_id'],
            'workstation_id': macData[0]['workstationid']
          });
          QualityInspectionRepository().startInspection(
            payload: {
              'product_id': event.barcode!.productid.toString(),
              'rms_issue_id': event.barcode!.rawmaterialissueid.toString(),
              'workcentre_id': macData[0]['wr_workcentre_id'],
              'workstation_id': macData[0]['workstationid'],
              'employee_id': saveddata['data'][0]['id'],
              'revision_number': event.barcode!.revisionnumber.toString(),
              'process_sequence':
                  event.productAndProcessRouteModel!.combinedSequence,
              'processroute_id': event
                  .productAndProcessRouteModel!.processRouteId
                  .toString()
                  .trim()
            },
            token: saveddata['token'],
          );
          packingId = await QualityInspectionRepository()
              .getproductworkstationJobStatusId(
                  token: saveddata['token'],
                  payload: {
                'product_id': event.barcode!.productid.toString(),
                'rms_issue_id': event.barcode!.rawmaterialissueid.toString(),
                'workcentre_id': macData[0]['wr_workcentre_id'],
                'workstation_id': macData[0]['workstationid'],
                'employee_id': saveddata['data'][0]['id'],
                'revision_number': event.barcode!.revisionnumber.toString(),
                'process_sequence':
                    event.productAndProcessRouteModel!.combinedSequence
              });
        }

        emit(PackingProductionState(
            barcode: event.barcode,
            token: saveddata['token'],
            pdfMdocId: pdfmdocid,
            productDescription: productDescription,
            pdfRevisionNo: pdfRevisionNo,
            modelMdocId: modelMdocid,
            imageType: imageType,
            modelRevisionNo: modelRevisionNumber,
            modelsDetails: modelsDetails,
            pdfDetails: pdfDetails,
            packingId: packingId,
            workcentre: macData[0]['wr_workcentre_id']));
      }
    });

    // Production process bloc handler
    on<PackingProcessesEvent>((event, emit) async {
      final userdata = await UserData.getUserData();
      final machineData = await MachineData.geMachineData();
      final macData = jsonDecode(machineData.toString());

      List<ProductAndProcessRouteModel> productProcessRouteList =
          await ProductRouteRepository().oneWorkcentreProductRoute(
        token: userdata['token'],
        productId: event.barcode.productid.toString(),
        revision: event.barcode.revisionnumber.toString(),
        workcentreId: macData[0]['wr_workcentre_id'],
      );
      emit(PackingProcessesState(
          productProcessRouteList: productProcessRouteList,
          token: userdata['token'],
          userid: userdata['data'][0]['id'],
          workcentreId: macData[0]['wr_workcentre_id'],
          workstationId: macData[0]['workstationid']));
    });

    // Stock event and state management
    on<StockEvent>((event, emit) async {
      List<ProductRevision> revision = [];
      final saveddata = await UserData.getUserData();
      List<AvailableStock> availableStock = await PackingRepository()
          .availableStock(token: saveddata['token'].toString());
      if (event.productid != '') {
        revision = await ProductRepository().productRevision(
            token: saveddata['token'].toString(),
            payload: {'product_id': event.productid});
      }
      emit(StockState(
          productId: event.productid,
          revision: revision,
          token: saveddata['token'].toString(),
          userid: saveddata['data'][0]['id'],
          availableStock: availableStock));
    });
  }
}
