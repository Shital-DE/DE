import 'dart:convert';

// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../services/model/common/document_model.dart';
import '../../../../../services/model/operator/oprator_models.dart';
import '../../../../../services/repository/common/documents_repository.dart';
import '../../../../../services/repository/operator/operator_repository.dart';
import '../../../../../services/repository/quality/quality_repository.dart';
import '../../../../../services/session/user_login.dart';
import 'operator_manual_production_event.dart';
import 'operator_manual_production_state.dart';

class OMPBloc extends Bloc<OMPEvent, OMPState> {
  OMPBloc(BuildContext context) : super(OMPinitialState()) {
    on<OMPEvent>((event, emit) async {
      String employeeId = '',
          workcentreid = '',
          workstationid = '',
          pdfmdocid = '',
          pdfRevisionNo = '',
          modelMdocid = '',
          modelRevisionNumber = '',
          productDescription = '',
          imageType = '';
      Map<String, dynamic> previousprodutiontime = {};
      List<OperatorRejectedReasons> operatorrejresons = [];
      final saveddata = await UserData.getUserData();
      // bool isAlreadyEndProduction;
      //Token
      String token = saveddata['token'].toString();

      for (var userdata in saveddata['data']) {
        employeeId = userdata['id'];
      }

      //if (event.rejqty > 0) {
      operatorrejresons = await OperatorRepository.rejectedReasons(token);
      // }

      final machinedata = await MachineData.geMachineData();
      for (var element in machinedata) {
        Map<String, dynamic> data = jsonDecode(element);
        workcentreid = data['wr_workcentre_id'];
        workstationid = data['workstationid'].toString();
      }

      //PDF details
      List<DocumentDetails> pdfDetails = await DocumentsRepository()
          .pdfMdocId(token, event.barcode.productid.toString());
      for (var element in pdfDetails) {
        pdfmdocid = element.mdocId.toString().trim();
        pdfRevisionNo = element.revisionNumber.toString().trim();
      }

      //Model details
      List<DocumentDetails> modelsDetails = await DocumentsRepository()
          .modelsMdocId(token, event.barcode.productid.toString());
      for (var element in modelsDetails) {
        modelMdocid = element.mdocId.toString().trim();
        modelRevisionNumber = element.revisionNumber.toString().trim();
        productDescription = element.description.toString().trim();
        imageType = element.imagetypeCode.toString().trim();
      }

      // List<Tools> toollist =
      //     await OperatorRepository.gettoolslist(wcid: workcentreid);

      String productionstatusid = await QualityInspectionRepository()
          .getproductworkstationJobStatusId(token: token, payload: {
        'product_id': event.barcode.productid.toString(),
        'rms_issue_id': event.barcode.rawmaterialissueid.toString(),
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'employee_id': saveddata['data'][0]['id'],
        'revision_number': event.barcode.revisionnumber.toString()
      });

      final getpreviousproductiontime =
          await OperatorRepository().getpreviousprodutiontime(
        event.barcode.productid.toString(),
        event.barcode.rawmaterialissueid.toString(),
        workcentreid,
        workstationid,
        employeeId,
        event.barcode.revisionnumber.toString(),
        productionstatusid,
        token,
      );

      if (getpreviousproductiontime.toString() ==
          'Previous data not avilable') {
        emit(OMPErrorState('Previous data not avilable'));
      } else {
        previousprodutiontime = getpreviousproductiontime;
        debugPrint(previousprodutiontime['startproductiontime']);
      }
      //debugPrint(previousprodutiontime['startproductiontime']);
////////////////////////////////////////////////////
      // isAlreadyEndProduction = await OperatorRepository()
      //     .finalProductionJobStatusCheck(
      //         event.barcode.productid.toString(),
      //         event.barcode.revisionnumber.toString(),
      //         event.barcode.rawmaterialissueid.toString(),
      //         token,
      //         workcentreid,
      //         '',
      //         '');
      // debugPrint("already production check.");
      // debugPrint(isAlreadyEndProduction.toString());
////////////////////////////////////////////////////
      // final bomid = await OperatorRepository().getProductBOMid(
      //   event.barcode.productid.toString(),
      //   token,
      // );
      // Map<String, dynamic> productbomid = bomid;

////////////////////////////////////////////////////
      // final lastproroutedetails =
      //     await OperatorRepository().getlastProductroutedetails(
      //   event.barcode.productid.toString(),
      //   event.barcode.revisionnumber.toString(),
      //   token,
      // );
      //  Map<String, dynamic> productRouteDetails = lastproroutedetails;

///////////////////////////////////////////////////////
      emit(OMPLoadingState(
        event.selectedItems,
        token,
        employeeId,
        event.settingtime,
        event.startproductiontime,
        // toollist,
        event.okqty,
        // event.selectedtoollist,
        workcentreid,
        workstationid,
        pdfmdocid,
        pdfRevisionNo,
        modelMdocid,
        modelRevisionNumber,
        productDescription,
        imageType,
        event.barcode,
        modelsDetails,
        pdfDetails,
        event.rejqty,
        operatorrejresons,
        productionstatusid,
        previousprodutiontime,
        event.rejresons,
        // isAlreadyEndProduction
        // productbomid,
        // productRouteDetails
      ));
    });
  }
}
