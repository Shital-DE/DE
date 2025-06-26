// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC ->Quality dashboard bloc

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/common/document_model.dart';
import '../../../services/model/machine/workcentre.dart';
import '../../../services/model/quality/quality_models.dart';
import '../../../services/repository/common/documents_repository.dart';
import '../../../services/repository/common/tablet_repository.dart';
import '../../../services/repository/quality/quality_repository.dart';
import '../../../services/session/user_login.dart';
import 'quality_dashboard_event.dart';
import 'quality_dashboard_state.dart';

class QualityBloc extends Bloc<QualityEvents, QualityState> {
  QualityBloc() : super(QualityInitialState()) {
    on<QualityDashboardEvents>((event, emit) async {
      bool isAlreadyInspected = false;
      String pdfmdocid = '',
          pdfRevisionNo = '',
          modelMdocid = '',
          modelRevisionNumber = '',
          productDescription = '',
          imageType = '';

      //User data
      final saveddata = await UserData.getUserData();
      final machineData = await MachineData.geMachineData();
      final macData = jsonDecode(machineData.toString());

      // Check if inspection is already started or not
      isAlreadyInspected = await QualityInspectionRepository()
          .jobInspectionStatusCheck(token: saveddata['token'], payload: {
        'product_id': event.barcode.productid,
        'rmsissueid': event.barcode.rawmaterialissueid,
        'workcentre_id': macData[0]['wr_workcentre_id'],
        'revision_number': event.barcode.revisionnumber
      });

      if (isAlreadyInspected == true) {
        emit(QualityErrorState(
            errorMessage: 'This product is already inspected.'));
      } else {
        //PDF details
        List<DocumentDetails> pdfDetails = await DocumentsRepository()
            .pdfMdocId(saveddata['token'], event.barcode.productid.toString());
        for (var element in pdfDetails) {
          pdfmdocid = element.mdocId.toString().trim();
          pdfRevisionNo = element.revisionNumber.toString().trim();
        }

        //Model details
        List<DocumentDetails> modelsDetails = await DocumentsRepository()
            .modelsMdocId(
                saveddata['token'], event.barcode.productid.toString());
        for (var element in modelsDetails) {
          modelMdocid = element.mdocId.toString().trim();
          modelRevisionNumber = element.revisionNumber.toString().trim();
          productDescription = element.description.toString().trim();
          imageType = element.imagetypeCode.toString().trim();
        }

        // inspect id
        String inspectionId = await QualityInspectionRepository()
            .getproductworkstationJobStatusId(
                token: saveddata['token'],
                payload: {
              'product_id': event.barcode.productid.toString(),
              'rms_issue_id': event.barcode.rawmaterialissueid.toString(),
              'workcentre_id': macData[0]['wr_workcentre_id'],
              'workstation_id': macData[0]['workstationid'],
              'employee_id': saveddata['data'][0]['id'],
              'revision_number': event.barcode.revisionnumber.toString()
            });

        // Inspection time
        String time = inspectionId != ''
            ? await QualityInspectionRepository().getInspectionTime(
                token: saveddata['token'], payload: {'id': inspectionId})
            : '';

        // Workcentre list
        List<Workcentre> workcentrelist =
            await TabletRepository().workcentreList(saveddata['token']);

        // Quality rejected reasons
        List<QualityRejectedReasons> rejectedReasonsList =
            await QualityInspectionRepository()
                .rejectedReasons(saveddata['token']);

        emit(QualityDashboardState(
          isInspectionStarted: isAlreadyInspected,
          barcode: event.barcode,
          pdfMdocId: pdfmdocid,
          pdfRevisionNo: pdfRevisionNo,
          modelMdocId: modelMdocid,
          modelRevisionNo: modelRevisionNumber,
          productDescription: productDescription,
          imageType: imageType,
          token: saveddata['token'],
          startInspection: time == '' ? event.startInspection : time,
          workcentre: macData[0]['wr_workcentre_id'],
          workstation: macData[0]['workstationid'],
          userid: saveddata['data'][0]['id'],
          pdfDetails: pdfDetails,
          modelsDetails: modelsDetails,
          workcentrelist: workcentrelist,
          rejectedReasonsList: rejectedReasonsList,
          inspectionId: inspectionId,
        ));
      }
    });
  }
}
