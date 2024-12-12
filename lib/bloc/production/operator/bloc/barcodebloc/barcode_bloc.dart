// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'package:de/services/model/operator/oprator_models.dart';
import 'package:de/services/repository/quality/quality_repository.dart';
import 'package:de/services/session/user_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path/path.dart';
import '../../../../../services/model/common/document_model.dart';
import '../../../../../services/repository/common/documents_repository.dart';
import '../../../../../services/repository/operator/operator_repository.dart';
part 'barcode_event.dart';
part 'barcode_state.dart';

class BarcodeBloc extends Bloc<BarcodeEvent, BarcodeState> {
  final BuildContext context;
  BarcodeBloc({required this.context}) : super(BarcodeInitial()) {
    on<BarcodeLoadEvent>((event, emit) async {
      Map<String, String> barcode =
          await OperatorRepository.scanBarcode(context: context);
      emit(BarcodeLoadState(barcode['code']!));
    });
  }
}

class OperatorScreenBloc
    extends Bloc<OperatorScreenEvent, OperatorManualState> {
  OperatorScreenBloc() : super(OperatorManualinitialState()) {
    on<OperatorScreenEvent>((event, emit) async {
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
      final saveddata = await UserData.getUserData();
      //Token
      String token = saveddata['token'].toString();

      for (var userdata in saveddata['data']) {
        employeeId = userdata['id'];
      }

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

      List<Tools> toollist =
          await OperatorRepository.gettoolslist(wcid: workcentreid);

      List<OperatorRejectedReasons> operatorrejresons =
          await OperatorRepository.getoperatorrejresonslist();

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
        emit(OperatormanualyErrorState('Previous data not avilable'));
      } else {
        previousprodutiontime = getpreviousproductiontime;
      }
////////////////////////////////////////////////////
      bool isAlreadyEndProduction = await OperatorRepository()
          .finalProductionJobStatusCheck(event.barcode.productid.toString(), '',
              event.barcode.rawmaterialissueid.toString(), token, '', '', '');
////////////////////////////////////////////////////
      final bomid = await OperatorRepository().getProductBOMid(
        event.barcode.productid.toString(),
        token,
      );
      Map<String, dynamic> productbomid = bomid;

////////////////////////////////////////////////////
      final lastproroutedetails =
          await OperatorRepository().getlastProductroutedetails(
        event.barcode.productid.toString(),
        event.barcode.revisionnumber.toString(),
        token,
      );
      Map<String, dynamic> productRouteDetails = lastproroutedetails;

///////////////////////////////////////////////////////
      emit(OperatorManualLoadingState(
          event.selectedItems,
          token,
          employeeId,
          event.settingtime,
          event.startproductiontime,
          toollist,
          event.okqty,
          event.selectedtoollist,
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
          isAlreadyEndProduction,
          productbomid,
          productRouteDetails));
    });
  }
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
class OperatorAutomaticScreenBloc
    extends Bloc<OperatorAutoScreenEvent, OperatorAutomaticState> {
  final BuildContext context;
  OperatorAutomaticScreenBloc(this.context)
      : super(OperatorAutomaticinitialState()) {
    on<OperatorAutoScreenEvent>((event, emit) async {
      String employeeId = '',
          // ignore: unused_local_variable
          employeeName = '',
          workcentreid = '',
          workstationid = '',
          pdfmdocid = '',
          pdfRevisionNo = '',
          modelMdocid = '',
          modelRevisionNumber = '',
          productDescription = '',
          machineid = '',
          machinename = '',
          imageType = '';
      String settingtime = '', productionstatusid = '';
      Map<String, dynamic> previousprodutiontime = {};
      List<DocumentDetails> modelsDetails = [];
      List<DocumentDetails> pdfDetails = [];
      List<Tools> toollist = [];
      List<OperatorRejectedReasons> operatorrejresons = [];
      bool getdataflag = false;
      final saveddata = await UserData.getUserData();
      //Token
      String token = saveddata['token'].toString();

      for (var userdata in saveddata['data']) {
        employeeId = userdata['id'];
        employeeName = userdata['firstname'];
      }

      final machinedata = await MachineData.geMachineData();

      for (var element in machinedata) {
        Map<String, dynamic> data = jsonDecode(element);
        workcentreid = data['wr_workcentre_id'];
        workstationid = data['workstationid'].toString();
        machineid = data['machineid'].toString();
        machinename = data['machinename'].toString();
      }

      bool isAlreadyEndProduction = await OperatorRepository()
          .finalProductionJobStatusCheck(event.barcode.productid.toString(), '',
              event.barcode.rawmaterialissueid.toString(), token, '', '', '');
///////////////////////////////////////////////////////////////

      if (isAlreadyEndProduction == false) {
        //PDF details
        pdfDetails = await DocumentsRepository()
            .pdfMdocId(token, event.barcode.productid.toString());
        for (var element in pdfDetails) {
          pdfmdocid = element.mdocId.toString().trim();
          pdfRevisionNo = element.revisionNumber.toString().trim();
        }
        // debugPrint(pdfDetails.toString());
        //Model details
        modelsDetails = await DocumentsRepository()
            .modelsMdocId(token, event.barcode.productid.toString());
        for (var element in modelsDetails) {
          modelMdocid = element.mdocId.toString().trim();
          modelRevisionNumber = element.revisionNumber.toString().trim();
          productDescription = element.description.toString().trim();
          imageType = element.imagetypeCode.toString().trim();
        }
        ///////////////////////////////////////////////////////////////////
        //  toollist = await OperatorRepository.gettoolslist(wcid: workcentreid);
        toollist = await OperatorRepository.toollist(
            workcentreid: workcentreid, token: token);

        // for (Tools tool in toollist) {
        //   debugPrint('Tool ID: ${tool.id}');
        //   debugPrint('Tool Name: ${tool.toolname}');
        //   debugPrint('--------------');
        // }
        ///////////////////////////////////////////////////
        // operatorrejresons = await OperatorRepository.getoperatorrejresonslist();
        operatorrejresons = await OperatorRepository.rejectedReasons(token);
        ///////////////////////////////////////////////////////////////////
        productionstatusid = await QualityInspectionRepository()
            .getproductworkstationJobStatusId(token: token, payload: {
          'product_id': event.barcode.productid.toString(),
          'rms_issue_id': event.barcode.rawmaterialissueid.toString(),
          'workcentre_id': workcentreid,
          'workstation_id': workstationid,
          'employee_id': saveddata['data'][0]['id'],
          'revision_number': event.barcode.revisionnumber.toString()
        }
                // event.barcode.productid.toString(),
                // event.barcode.rawmaterialissueid.toString(),
                // workcentreid,
                // workstationid,
                // employeeId,
                // token,
                );

        ///////////////////////////////////////////////////////////////////
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

        ////////////////////////////////////////////////////////////////////

        final bomid = await OperatorRepository().getProductBOMid(
          event.barcode.productid.toString(),
          token,
        );

        Map<String, dynamic> productbomid = bomid;

        //////////////////////////////////////////////////////////////////////
        final lastproroutedetails =
            await OperatorRepository().getlastProductroutedetails(
          event.barcode.productid.toString(),
          event.barcode.revisionnumber.toString(),
          token,
        );
        Map<String, dynamic> productRouteDetails = lastproroutedetails;

        //////////////////////////////////////////////////////////////////////
        if (getpreviousproductiontime.toString() ==
            'Previous data not avilable') {
          settingtime =
              await QualityInspectionRepository().currentDatabaseTime(token);

          // await OperatorRepository.startsettinginsert(
          //     event.barcode.productid.toString(),
          //     event.barcode.rawmaterialissueid.toString(),
          //     workcentreid,
          //     workstationid,
          //     employeeId,
          //     event.barcode.revisionnumber.toString(),
          //     token,
          //     context);

          String checkresponce = await OperatorRepository.jobStartAPI(
            slipId: event.barcode.rawmaterialissueid.toString(),
            productId: event.barcode.productid.toString(),
            toBeProducedQty: event.barcode.issueQty!.toInt(),
            machineId: "002",
            timeStart: settingtime,
            processid: '',
            requestid: '',
          );
          debugPrint("22------------==-=-=-=-=-=-==>>>>>>>>>>>>>>>>>>>>>>");
          debugPrint(checkresponce.toString());

          if (productRouteDetails.isEmpty) {
            await OperatorRepository.createMachineProductRoute(
              event.barcode.productid.toString(),
              workcentreid,
              workstationid,
              productbomid['productBOMiD'].toString(),
              event.barcode.revisionnumber.toString(),
              token,
              context,
            );
          } else {
            int nseqno = 0;
            int ver = 0;

            if (productRouteDetails['productid'] ==
                    event.barcode.productid.toString() &&
                productRouteDetails['wcid'] != workcentreid &&
                productRouteDetails['wcid'] !=
                    '4028817165f0a36c0165f0a95e1c0006') {
              debugPrint("The values are not same of wc machine");
              if (workcentreid == '4028817165f0a36c0165f0a89c410004') {
                nseqno = 800;
              } else if (workcentreid == '4028817165f0a36c0165f0a9020e0005') {
                nseqno = 900;
              } else if (workcentreid == '4028817165f0a36c0165f0a95e1c0006') {
                nseqno = 1000;
              } else {
                nseqno = productRouteDetails['seqno'] + 10;
              }

              ver = productRouteDetails['Route_version'];
              debugPrint("new diff seqno.....$ver/////>>>>>>>>>>>>>>>>>>>>");

              ///create function here for revision route create

              OperatorRepository.createMachineProductRouteDiffSeqNo(
                event.barcode.productid.toString(),
                workcentreid,
                workstationid,
                productbomid['productBOMiD'].toString(),
                event.barcode.revisionnumber.toString(),
                nseqno,
                ver,
                token,
                context,
              );
            } else if (productRouteDetails['productid'] ==
                    event.barcode.productid.toString() &&
                productRouteDetails['wcid'] != workcentreid) {
              debugPrint("previous workcenter is same");
            } else if (productRouteDetails['productid'] ==
                    event.barcode.productid.toString() &&
                productRouteDetails['wcid'] ==
                    '4028817165f0a36c0165f0a95e1c0006') {
              if (workcentreid == '4028817165f0a36c0165f0a95e1c0006') {
                debugPrint("First Product route complete");
              } else if (productRouteDetails['wcid'] != workcentreid) {
                int rversion = productRouteDetails['Route_version'] + 1;

                OperatorRepository.createMachineProductRouteDiffRevision(
                  event.barcode.productid.toString(),
                  workcentreid,
                  workstationid,
                  productbomid['productBOMiD'].toString(),
                  event.barcode.revisionnumber.toString(),
                  rversion,
                  token,
                  context,
                );

                debugPrint("new version new route----------$rversion");
              }
            }
          }

          // emit(OperatorAutomaticErrorState('Previous data not avilable'));
        } else {
          previousprodutiontime = getpreviousproductiontime;
          if (previousprodutiontime['startprocesstime'] != null) {
            settingtime =
                DateTime.parse(previousprodutiontime['startprocesstime'])
                    .toLocal()
                    .toString();
          }
        }

        emit(OperatorAutomaticLoadingState(
            event.barcode,
            isAlreadyEndProduction,
            token,
            employeeId,
            pdfmdocid,
            pdfRevisionNo,
            modelMdocid,
            modelRevisionNumber,
            productDescription,
            imageType,
            pdfDetails,
            modelsDetails,
            event.selectedItems,
            toollist,
            event.selectedtoollist,
            event.okqty,
            event.rejqty,
            operatorrejresons,
            productionstatusid,
            previousprodutiontime,
            productbomid,
            productRouteDetails,
            settingtime,
            workcentreid,
            workstationid,
            getdataflag,
            machineid,
            machinename));
      }

      emit(OperatorAutomaticLoadingState(
          event.barcode,
          isAlreadyEndProduction,
          token,
          employeeId,
          pdfmdocid,
          pdfRevisionNo,
          modelMdocid,
          modelRevisionNumber,
          productDescription,
          imageType,
          pdfDetails,
          modelsDetails,
          event.selectedItems,
          toollist,
          event.selectedtoollist,
          event.okqty,
          event.rejqty,
          operatorrejresons,
          productionstatusid,
          previousprodutiontime,
          {},
          {},
          settingtime,
          workcentreid,
          workstationid,
          getdataflag,
          machineid,
          machinename));
    });
  }
}

// class ApiClient {
//   Future<Map<String, dynamic>> fetchData({
//     required Barcode barcode,
//   }) async {
//     String workcentreid, workstationid, machineid;
//     try {
//       final machinedata = await MachineData.geMachineData();

//       for (var element in machinedata) {
//         Map<String, dynamic> data = jsonDecode(element);
//         workcentreid = data['wr_workcentre_id'];
//         workstationid = data['workstationid'].toString();
//         machineid = data['machineid'].toString();
//       }

//       var url = Uri.parse(
//           "http://192.168.0.55:3213/v1/industry40/getProductionStatus");
//       final response = await http.post(
//         url,
//         body: jsonEncode(<String, dynamic>{
//           // "slipId": "94eb3664aa4a45d2bb12a07a193e6191",
//           // "productCodeId": "31ed2537d6b4404ca127ec13c9a248df",
//           // "toBeProducedQty": "30",
//           // "machineId": "002"
//           "requestid": "202020201",
//           "slipid": "20231706110700",
//           "productid": "20231706110701",
//           "machineid": "S3Test"
//         }),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//       debugPrint(response.body);
//       if (response.statusCode == 200) {
//         Map<String, dynamic> jsonData = jsonDecode(response.body);
//         return jsonData;
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       //throw Exception(e);
//       //debugPrint(e.toString());
//       throw Exception(e);
//       // showSuccessDialog(context: context, message: "Server not connect...");
//       // return {'Error': "Connection timed out"};
//     }
//   }

//   // Future<dynamic> showSuccessDialog(
//   //     {required BuildContext context, required String message}) {
//   //   return showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: Center(
//   //             child: Text(
//   //           message,
//   //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//   //         )),
//   //         actions: [
//   //           Center(
//   //             child: FilledButton(
//   //                 onPressed: () {
//   //                   Navigator.of(context).pop();
//   //                 },
//   //                 child: const Text('OK')),
//   //           )
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
// }
