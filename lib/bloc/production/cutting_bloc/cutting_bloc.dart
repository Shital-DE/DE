// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Cutting bloc

import 'dart:convert';
import 'package:de/services/model/common/document_model.dart';
import 'package:de/services/model/operator/cutting_model.dart';
import 'package:de/services/repository/common/documents_repository.dart';
import 'package:de/services/repository/operator/cutting_repository.dart';
import 'package:de/services/session/user_login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/product/product_route.dart';
import '../../../services/repository/product/product_route_repo.dart';
import 'cutting_event.dart';
import 'cutting_state.dart';

class CuttingBloc extends Bloc<CuttingEvent, CuttingState> {
  CuttingBloc() : super(CuttingInitialState()) {
    on<CuttingProductionEvent>((event, emit) async {
      Map<String, dynamic> pdfdoc = {}, modeldoc = {}, productStatus = {};
      String employeeid = '';
      int producedQuantity = event.barcode.issueQty!.toInt();

      //User data
      final saveddata = await UserData.getUserData();

      //Token
      String token = saveddata['token'].toString();

      //Documents

      List<DocumentDetails> pdfDetails =
          await DocumentsRepository() //PDF details
              .pdfMdocId(token, event.barcode.productid.toString());

      List<DocumentDetails> modelsDetails =
          await DocumentsRepository() //Model details
              .modelsMdocId(token, event.barcode.productid.toString());

      // Assigned Machine data
      List<String> machinedata = await MachineData.geMachineData();
      List<dynamic> assignedMachineData = jsonDecode(machinedata.toString());

      for (var machineData in assignedMachineData) {
        //Cutting status
        final cuttingStatus =
            await CuttingRepository().cuttingStatus(token: token, payload: {
          'productid': event.barcode.productid.toString().trim(),
          'rawmaterialissueid':
              event.barcode.rawmaterialissueid.toString().trim(),
          'workcentreid': machineData['wr_workcentre_id'].toString().trim(),
          'revision': event.barcode.revisionnumber.toString()
        });
        List<CuttingStatus> status = cuttingStatus;

        final cuttingLiveStatus =
            await CuttingRepository().cuttingLiveStatus(token: token, payload: {
          'productid': event.barcode.productid.toString().trim(),
          'rawmaterialissueid':
              event.barcode.rawmaterialissueid.toString().trim(),
          'workcentreid': machineData['wr_workcentre_id'].toString().trim(),
          'revision': event.barcode.revisionnumber.toString()
        });
        List<CuttingStatus> liveStatus = cuttingLiveStatus;

        String cuttingQuantity =
            await CuttingRepository().cuttingQuantity(token: token, payload: {
          'productid': event.barcode.productid.toString().trim(),
          'rawmaterialissueid':
              event.barcode.rawmaterialissueid.toString().trim(),
          'workcentreid': machineData['wr_workcentre_id'].toString().trim(),
          'revision': event.barcode.revisionnumber.toString()
        });

        if (liveStatus.isNotEmpty) {
          for (var data in liveStatus) {
            productStatus = {
              'start_time': data.starttime,
              'end_time': data.endtime,
              'status': data.endprocessflag,
              'id': data.id,
              'production_end': data.endproductionflag,
              'cut_quantity': data.cuttingqty
            };
          }
        }

        if (pdfDetails.toString() == 'Server unreachable' ||
            cuttingQuantity == 'Server unreachable') {
          emit(CuttingErrorState('Server unreachable'));
        } else {
          for (var element in pdfDetails) {
            pdfdoc = {
              'pdf_mdoc_id': element.mdocId.toString().trim(),
              'pdf_revision_number': element.revisionNumber.toString().trim(),
              'pdf_image_type': element.imagetypeCode.toString().trim(),
              'product_description': element.code.toString().trim()
            };
          }

          for (var element in modelsDetails) {
            modeldoc = {
              'model_mdoc_id': element.mdocId.toString().trim(),
              'model_revision_number': element.revisionNumber.toString().trim(),
              'model_image_type': element.imagetypeCode.toString().trim(),
            };
          }

          for (var data in saveddata['data']) {
            employeeid = data['id'];
          }

          if (cuttingQuantity.toString() != 'null') {
            producedQuantity =
                event.barcode.issueQty!.toInt() - int.parse(cuttingQuantity);
          }

          if (producedQuantity == 0 &&
              producedQuantity <= 0 &&
              event.cuttingQty != '') {
            producedQuantity == int.parse(event.cuttingQty);
          }

          emit(CuttingProductionState(
            barcode: event.barcode,
            pdfdoc: pdfdoc,
            modeldoc: modeldoc,
            token: token,
            pdfDetails: pdfDetails,
            modelsDetails: modelsDetails,
            cuttingQty: event.cuttingQty,
            employeeid: employeeid,
            productStatus: productStatus,
            status: status,
            tobeProducedQuantity: producedQuantity,
            machinedata: machineData,
          ));
        }
      }
    });

    on<CuttingProductionProcessesEvent>((event, emit) async {
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
      emit(CuttingProductionProcessesState(
          barcode: event.barcode,
          productProcessRouteList: productProcessRouteList,
          token: userdata['token'],
          userId: userdata['data'][0]['id'],
          workcentreId: macData[0]['wr_workcentre_id'],
          workstationId: macData[0]['workstationid']));
    });
  }
}
