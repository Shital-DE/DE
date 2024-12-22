// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../services/model/common/document_model.dart';
import '../../../../../services/model/operator/oprator_models.dart';
import '../../../../../services/repository/common/documents_repository.dart';
import '../../../../../services/repository/operator/operator_repository.dart';
import '../../../../../services/repository/product/product_machine_route_repository.dart';
import '../../../../../services/repository/quality/quality_repository.dart';
import '../../../../../services/session/user_login.dart';
import 'operatorautoproduction_event.dart';
import 'operatorautoproduction_state.dart';

class OAPBloc extends Bloc<OAPEvent, OAPState> {
  final BuildContext context;
  OAPBloc(this.context) : super(OAPinitialState()) {
    on<OAPEvent>((event, emit) async {
      String employeeId = '',
          pdfmdocid = '',
          pdfRevisionNo = '',
          modelMdocid = '',
          modelRevisionNumber = '',
          productDescription = '',
          imageType = '',
          productionstatusid = '';

      String instruction = '';
      Map<String, dynamic> data = {};

      List<DocumentDetails> modelsDetails = [];
      List<DocumentDetails> pdfDetails = [];
      List<Tools> toollist = [];
      List<OperatorRejectedReasons> operatorrejresons = [];
      Map<String, dynamic> productRouteDetails = {};
      Map<String, dynamic> starttimeproduction = {};
      DateTime productionstart = DateTime.now();
      bool isAlreadyEndProduction = false;
      final saveddata = await UserData.getUserData();
      //Token
      String token = saveddata['token'].toString();

      for (var userdata in saveddata['data']) {
        employeeId = userdata['id'];
        // employeeName = userdata['firstname'];
      }
      // if (event.rejqty > 0) {
      operatorrejresons = await OperatorRepository.rejectedReasons(token);
      // debugPrint("operator rejected resons-=-=-=-=-=-=-==========");
      // debugPrint(operatorrejresons.toString());
      // }

      final machinedata = await MachineData.geMachineData();

      for (var element in machinedata) {
        data = jsonDecode(element);
      }

      isAlreadyEndProduction = await OperatorRepository()
          .finalProductionJobStatusCheck(
              event.barcode.productid.toString(),
              event.barcode.revisionnumber.toString(),
              event.barcode.rawmaterialissueid.toString(),
              token,
              data['wr_workcentre_id'],
              data['workstationid'],
              event.processrouteid.toString());

      final firsttimeproduct = await OperatorRepository()
          .getfirsttimeproductdetails(
              event.barcode.productid.toString(), token);

      if (firsttimeproduct == 'Previous data not avilable') {
        // String statusofInsert =
        await OperatorRepository.insertfirstscanProductCadlab(
            event.barcode.productid.toString(),
            event.barcode.revisionnumber.toString(),
            data['workstationid'],
            event.barcode.po.toString(),
            event.barcode.issueQty.toString(),
            employeeId,
            token,
            context);
      }

      if (isAlreadyEndProduction == false) {
        ///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        instruction = await OperatorRepository.getInstructionString(
          processrouteid: event.processrouteid,
          token: token,
        );

        pdfDetails = await DocumentsRepository()
            .pdfMdocId(token, event.barcode.productid.toString());
        for (var element in pdfDetails) {
          pdfmdocid = element.mdocId.toString().trim();
          pdfRevisionNo = element.revisionNumber.toString().trim();
        }

        modelsDetails = await DocumentsRepository()
            .modelsMdocId(token, event.barcode.productid.toString());
        for (var element in modelsDetails) {
          modelMdocid = element.mdocId.toString().trim();
          modelRevisionNumber = element.revisionNumber.toString().trim();
          productDescription = element.description.toString().trim();
          imageType = element.imagetypeCode.toString().trim();
        }

        ///////////////////////////////////////////////////////////////////
        // toollist = await OperatorRepository.toollist(
        //     workcentreid: data['wr_workcentre_id'], token: token);
        // ///////////////////////////////////////////////////////////////////
        productionstatusid =
            await OperatorRepository().getproductworkstationJobStatusId(
          event.barcode.productid.toString(),
          event.barcode.rawmaterialissueid.toString(),
          data['wr_workcentre_id'],
          data['workstationid'],
          employeeId,
          event.processrouteid,
          event.seqno,
          token,
        );

        // debugPrint(
        //     "Production statusid--------898989>>>>>>>>  ${productionstatusid.toString()}");

        // ///////////////////////////////////////////////////////////////////

        final getpreviousproductiontime = await OperatorRepository()
            .getpreviousprodutiontime(token: token, payload: {
          'product_id': event.barcode.productid.toString(),
          'rms_issue_id': event.barcode.rawmaterialissueid.toString(),
          'workcentre_id': data['wr_workcentre_id'],
          'workstation_id': data['workstationid'],
          'employee_id': employeeId,
          'revision_number': event.barcode.revisionnumber.toString(),
          'productionstatusid': productionstatusid
        });
        // debugPrint("-----------$getpreviousproductiontime");
        if (getpreviousproductiontime.toString() ==
            'Previous data not avilable') {
          final timeofProductionNotAvailable =
              await QualityInspectionRepository().currentDatabaseTime(token);
          productionstart =
              DateTime.parse(timeofProductionNotAvailable.toString());
        } else {
          starttimeproduction = getpreviousproductiontime;
          productionstart = DateTime.parse(
              starttimeproduction['startprocesstime'].toString());
        }

        // debugPrint("++++++$productionstart");
        //////////////////////////////////////////////////////////////////////

        final bomid = await OperatorRepository().getProductBOMid(
          event.barcode.productid.toString(),
          token,
        );

        Map<String, dynamic> productbomid = bomid;

        // debugPrint("===============$productbomid");

        /////////////////////////////////////////////////////////////////////
        final lastproroutedetails =
            await OperatorRepository().getlastProductroutedetails(
          event.barcode.productid.toString(),
          event.barcode.revisionnumber.toString(),
          token,
        );
        // debugPrint(")))))))))))))))))))))) $lastproroutedetails");

        if (lastproroutedetails == 'Product route not availbale') {
        } else {
          productRouteDetails = lastproroutedetails;
          // debugPrint(productRouteDetails['Route_version'].toString());
        }
        ///////////////////////////////////////////////////////////////////

        if (getpreviousproductiontime.toString() ==
            'Previous data not avilable') {
          String statusofInsert = await OperatorRepository.startsettinginsert(
              event.barcode.productid.toString(),
              event.barcode.rawmaterialissueid.toString(),
              data['wr_workcentre_id'],
              data['workstationid'],
              employeeId,
              event.barcode.revisionnumber.toString(),
              event.processrouteid.toString(),
              event.seqno.toString(),
              event.cprunnumber,
              event.cpchildid,
              token,
              context);

          if (statusofInsert != 'Inserted successfully') {
            Navigator.of(context).pop();
          }

          await ProductMachineRoute()
              .registerProductMachineRoute(token: token, payload: {
            'product_id': event.barcode.productid.toString(),
            'product_revision': event.barcode.revisionnumber.toString(),
            'workcentre_id': data['wr_workcentre_id'],
            'workstation_id': data['workstationid']
          });

          productionstatusid =
              await OperatorRepository().getproductworkstationJobStatusId(
            event.barcode.productid.toString(),
            event.barcode.rawmaterialissueid.toString(),
            data['wr_workcentre_id'],
            data['workstationid'],
            employeeId,
            event.processrouteid,
            event.seqno,
            token,
          );

          // debugPrint(
          //     "this is id of productionstatusid 111111111111111------>>>>");
          // debugPrint(productionstatusid.toString());
        }

        emit(OAPLoadingState(
          barcode: event.barcode,
          token: token,
          employeeId: employeeId,
          pdfmdocid: pdfmdocid,
          pdfRevisionNo: pdfRevisionNo,
          modelMdocid: modelMdocid,
          modelRevisionNumber: modelRevisionNumber,
          productDescription: productDescription,
          imageType: imageType,
          pdfDetails: pdfDetails,
          modelsDetails: modelsDetails,
          workcentreid: data['wr_workcentre_id'],
          machinename: data['machinename'].toString(),
          workstationid: data['workstationid'].toString(),
          machineid: data['machineid'].toString(),
          getpreviousproductiontime: productionstart.toLocal().toString(),
          // previousprodutiontime['startprocesstime'].toString(),
          //settingtime: settingtime,
          toollist: toollist,
          selectedtoollist: event.selectedtoollist,
          operatorrejresons: operatorrejresons,
          productionstatusid: productionstatusid,
          productRouteDetails: productRouteDetails,
          productbomid: productbomid,
          isAlreadyEndProduction: isAlreadyEndProduction,
          // okqty: event.okqty,
          // rejqty: event.rejqty, rejectedresonsid: event.rejectedresonsid,
          instruction: instruction,
          // productiontimedata: {},
          // selectedtoolsItems: event.selectedtoolsItems,
        ));
      }
      emit(OAPLoadingState(
        barcode: event.barcode,
        token: token,
        employeeId: employeeId,
        pdfmdocid: pdfmdocid,
        pdfRevisionNo: pdfRevisionNo,
        modelMdocid: modelMdocid,
        modelRevisionNumber: modelRevisionNumber,
        productDescription: productDescription,
        imageType: imageType,
        pdfDetails: pdfDetails,
        modelsDetails: modelsDetails,
        workcentreid: data['wr_workcentre_id'],
        machinename: data['machinename'].toString(),
        workstationid: data['workstationid'].toString(),
        machineid: data['machineid'].toString(),
        getpreviousproductiontime: productionstart.toLocal().toString(),
        // settingtime: '',
        toollist: toollist,
        selectedtoollist: event.selectedtoollist,
        operatorrejresons: operatorrejresons,
        productionstatusid: productionstatusid,
        productRouteDetails: {},
        productbomid: {},
        isAlreadyEndProduction: isAlreadyEndProduction,
        // okqty: event.okqty,
        // rejqty: event.rejqty,
        // rejectedresonsid: event.rejectedresonsid,
        instruction: instruction,
        // productiontimedata: {},
        //  selectedtoolsItems: event.selectedtoolsItems
      ));
    });
  }
}
