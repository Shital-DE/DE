// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:math';
import 'package:de/services/api_services/operator/operator_service.dart';
import 'package:de/services/common/api.dart';
import 'package:de/services/model/operator/oprator_models.dart' as op_model;
import 'package:de/utils/app_url.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import '../../session/user_login.dart';
import '../quality/quality_repository.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class OperatorRepository {
  static Future<Map<String, String>> scanBarcode(
      {required BuildContext context}) async {
    try {
      String barcodeyear, documentNo;
      int barcodeyearaddition = 0;
      Map<String, String> data = {};
      // String result =  await FlutterBarcodeScanner.scanBarcode(
      //   '#ff6666',
      //   'Cancel',
      //   true,
      //   ScanMode.BARCODE,
      // );
      String? result = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Barcode scan',
          centerTitle: false,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
        cameraFace: CameraFace.front,
      );
      if (result.toString() != 'null' && result.toString() != '-1') {
        var split = result!.split('#');
        barcodeyear = split[1].toString();
        barcodeyearaddition = int.parse(barcodeyear) + 1;
        documentNo = split[2].toString();

        data.addAll({
          "code": result,
          "year": "$barcodeyear-${barcodeyearaddition.toString()}",
          "document_no": documentNo
        });

        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  static Future<op_model.Barcode> getBarcodeDataRepo(
      {required String year, required String documentno}) async {
    try {
      // String year
      op_model.Barcode b = await OperatorAPIService.getBarcodeData(
          year: year, documentno: documentno);
      return b;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<op_model.MachineCenterProcess>> getMachineProcess() async {
    try {
      // String year
      List<op_model.MachineCenterProcess> c =
          await OperatorAPIService.getProcess(
              // wsid: wsid
              );
      return c;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<op_model.Tools>> gettoolslist(
      {required String wcid}) async {
    try {
      List<op_model.Tools> c =
          await OperatorAPIService.getToolsList(wcid: wcid);
      return c;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<op_model.OperatorRejectedReasons>>
      getoperatorrejresonslist() async {
    try {
      List<op_model.OperatorRejectedReasons> c =
          await OperatorAPIService.getOperatorrejresonsList();

      return c;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<op_model.PendingProductlistforoperator>>
      pendingproductlist({required String workcentreid, dynamic token}) async {
    Map<String, dynamic> payload = {};
    List<op_model.PendingProductlistforoperator> pendingProductList = [];
    try {
      payload = {
        'workcentre_id': workcentreid,
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.pendingproductlist, token, payload);

        if (response.statusCode == 200) {
          List<dynamic> responseData = jsonDecode(response.body);

          for (var item in responseData) {
            op_model.PendingProductlistforoperator pendingProduct =
                op_model.PendingProductlistforoperator(
              id: item['id'],
              runnumber: item['runnumber'].toString(),
              product: item['product'],
              capacityplanChildId: item['capacityplan_child_id'],
              productid: item['pd_product_id'],
              revisionNo: item['revision_no'],
              lineno: item['lineitemno'].toString(),
              poid: item['ss_salesorder_id'],
              ponumber: item['referancedocumentnumber'].toString(),
              rmsid: item['rmsid'],
              description: '',
              toBeProducedQty: item['tobeproducedqty'],
            );
            pendingProductList.add(pendingProduct);
          }
          return pendingProductList;
        }
      }
    } catch (e) {
      //debugPrint(e.toString());
    }
    return [];
  }

  static Future<List<op_model.PendingProductlistforoperator>>
      productlistfromcapacityplan(
          {required String workcentreid,
          required String productid,
          required String rmsid,
          required String poid,
          dynamic token}) async {
    Map<String, dynamic> payload = {};
    List<op_model.PendingProductlistforoperator> pendingProductList = [];
    try {
      payload = {
        'workcentre_id': workcentreid,
        'product_id': productid,
        'rms_id': rmsid,
        'poid': poid
      };
      if (payload.isNotEmpty) {
        // debugPrint(payload.toString());
        var response = await API().postApiResponse(
            AppUrl.productlistfromcapacityplan, token, payload);

        if (response.statusCode == 200) {
          List<dynamic> responseData = jsonDecode(response.body);
          for (var item in responseData) {
            op_model.PendingProductlistforoperator pendingProduct =
                op_model.PendingProductlistforoperator(
              id: item['id'],
              runnumber: item['runnumber'].toString(),
              capacityplanChildId: item['capacityplan_child_id'],
              product: item['product'],
              productid: item['pd_product_id'],
              revisionNo: item['revision_no'],
              lineno: item['lineitemno'].toString(),
              poid: item['ss_salesorder_id'],
              ponumber: item['ponumber'],
              rmsid: item['rmsid'],
              description:
                  '', // Add your logic to populate the description property
              toBeProducedQty: item['tobeproducedqty'],
            );
            // Add the object to the list
            pendingProductList.add(pendingProduct);
          }
          // debugPrint('1---------------$pendingProductList');
          return pendingProductList;
        }
      }
    } catch (e) {
      //debugPrint(e.toString());
    }
    return [];
  }

  static Future insertfirstscanProductCadlab(
      String productid,
      String revisionno,
      String workstationid,
      String po,
      String poqty,
      String employeeid,
      String token,
      BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
        'workstation_id': workstationid,
        'employee_id': employeeid,
        'revisionno': revisionno,
        'po_number': po,
        'poqty': poqty
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.insertfistscanproductCadlab, token, payload);

        if (response.body.toString() == 'Inserted successfully') {
          return response.body.toString();
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future startsettinginsert(
      String productid,
      String rmsIssueid,
      String workcentreid,
      String workstationid,
      String employeeid,
      String revisionno,
      String processrouteid,
      String seqno,
      String cprunnumber,
      String cpexcutionid,
      String token,
      BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
        'rms_issue_id': rmsIssueid,
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'employee_id': employeeid,
        'revisionno': revisionno,
        'processrouteid': processrouteid,
        'seqno': seqno,
        'cprunnumber': cprunnumber,
        'cpexcutionid': cpexcutionid
      };

      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.startsetting, token, payload);

        if (response.body.toString() == 'Inserted successfully') {
          return response.body.toString();
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future ompstartsettinginsert(
      {required String token,
      required BuildContext context,
      required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.ompstartsetting, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return QuickFixUi.successMessage('Setting Start', context);
        }
      }
    } catch (e) {
      //
    }
  }

  static Future updatestartproductionrecord(
      String productid,
      String rmsIssueid,
      String workcentreid,
      String workstationid,
      String employeeid,
      String token,
      String id,
      BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
        'rms_issue_id': rmsIssueid,
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'employee_id': employeeid,
        'id': id
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.ompupdatestartproductionrecord, token, payload);
        if (response.body.toString() == 'update records') {
          return QuickFixUi.successMessage('update records', context);
        }
      }
    } catch (e) {
      //  debugPrint(e.toString());
    }
  }

  Future getpreviousprodutiontime(
      {required Map<String, dynamic> payload, required String token}) async {
    try {
      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.getpreviousproductiontime, token, payload);
        if (response.body.toString() == '[]') {
          return 'Previous data not avilable';
        } else {
          List<dynamic> pdptime = jsonDecode(response.body);
          return {
            'id': pdptime[0]['id'],
            'startprocesstime': pdptime[0]['startprocesstime'],
            'startproductiontime': pdptime[0]['startproductiontime']
          };
        }
      }
    } catch (e) {
      //debugPrint(e.toString());
    }
  }

  Future getfirsttimeproductdetails(
    String productid,
    String token,
  ) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.getstatusoffirstscanproductdetails, token, payload);
        if (response.body.toString() == '[]') {
          return 'Previous data not avilable';
        } else {
          return 'data avilable';
        }
      }
    } catch (e) {
      //debugPrint(e.toString());
    }
  }

  Future<String> endProcess(
    BuildContext context,
    String productstatusId,
    String oKquantity,
    String rejectedquantity,
    String rejectedReasons,
    String productid,
    String rmsissueid,
    String employeeid,
    String token,
    int producedcount,
    int productiontime,
    int idletime,
    double energyconsumed,
  ) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
        'rms_issuse_id': rmsissueid,
        'employee_id': employeeid,
        'id': productstatusId,
        'ok_quantity': oKquantity,
        'rejected_quantity': rejectedquantity,
        'rejected_reasons': rejectedReasons,
        'produced_count': producedcount,
        'production_time': productiontime,
        'idle_time': idletime,
        'energy_consumed': energyconsumed
      };
      // debugPrint(payload.toString());
      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.endProcess, token, payload);
        // debugPrint(response.body.toString());
        if (response.body.toString() == 'Updated successfully') {
          return "End Process successfully";
        } else {
          return response.body.toString();
        }
      } else {
        return "payload is empty";
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return "something went gone wrong";
  }

  Future<String> ompendProcess(
      BuildContext context,
      String productstatusId,
      int oKquantity,
      int rejectedquantity,
      String rejectedReasons,
      String token) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'id': productstatusId,
        'ok_quantity': oKquantity,
        'rejected_quantity': rejectedquantity,
        'rejected_reasons': rejectedReasons,
      };
      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.ompendProcess, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return "End Process successfully";
        } else {
          return response.body.toString();
        }
      } else {
        return "payload is empty";
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return "something went gone wrong";
  }

  Future<String> finalEndProduction(
      {required BuildContext context,
      required String productid,
      required String rmsissueid,
      required String revisionno,
      required String workcentreId,
      required String token}) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'productid': productid,
        'revisionno': revisionno,
        'rmsid': rmsissueid,
        'wcid': workcentreId
      };
      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.finalEndProduction, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return "Updated successfully";
        } else {
          return response.body.toString();
        }
      } else {
        return "final end production payload is empty";
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return "something went gone wrong";
  }

  Future<String> ompfinalEndProduction(
      {required BuildContext context,
      required String productid,
      required String revisionno,
      required String rmsid,
      required String wcid,
      required String token}) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'productid': productid,
        'revisionno': revisionno,
        'rmsid': rmsid,
        'wcid': wcid
      };
      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.ompfinalEndProduction, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          return "Final end production success";
        } else {
          return response.body.toString();
        }
      } else {
        return "payload is empty";
      }
    } catch (e) {
      //debugPrint(e.toString());
    }
    return "something went gone wrong";
  }

  Future<bool> finalProductionJobStatusCheck(
      String productid,
      String revisionnumber,
      String rmsissueid,
      String token,
      String wcid,
      String wsid,
      String processrouteid) async {
    bool endProduction = false;
    try {
      Map<String, dynamic> payload = {
        'product_id': productid,
        'revisionno': revisionnumber,
        'rms_issue_id': rmsissueid,
        'workcentre_id': wcid,
        'workstation_id': wsid,
        'processrouteid': processrouteid
      };
      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.productionjobStatusCheck, token, payload);
        var data = jsonDecode(response.body.toString());
        if (data[0]['endprocessflag'] == 1 &&
            data[0]['endproductionflag'] == 1 &&
            data[0]['job_status'] == 0 &&
            data[0]['workcentre_id'] == wcid &&
            data[0]['workstation_id'] == wsid) {
          endProduction = true;
        }
      }
      return endProduction;
    } catch (e) {
      // debugPrint(e.toString());
    }
    return endProduction;
  }

  Future getProductBOMid(
    String productid,
    String token,
  ) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'productid': productid,
      };
      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.getProductBOMid, token, payload);

        if (response.body.toString() == '[]') {
          return 'Product BOM not availbale';
        } else {
          List<dynamic> pdptime = jsonDecode(response.body);
          return {
            'productBOMiD': pdptime[0]['id'],
          };
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  Future getlastProductroutedetails(
    String productid,
    String revisionno,
    String token,
  ) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {'productid': productid, 'revision_number': revisionno};
      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.getLastProductRouteDetails, token, payload);

        if (response.body.toString() == '[]') {
          return 'Product route not availbale';
        } else {
          List<dynamic> lastProductRouteDetails = jsonDecode(response.body);
          return {
            'Route_version': lastProductRouteDetails[0]
                ['production_route_version'],
            'seqno': lastProductRouteDetails[0]['sequance_number'],
            'wcid': lastProductRouteDetails[0]['workcenter_id'],
            'productid': lastProductRouteDetails[0]['pd_product_id'],
            'bomid': lastProductRouteDetails[0]['productbillofmaterial_id'],
            'revision_number': lastProductRouteDetails[0]['revision_number'],
          };
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  static Future createMachineProductRoute(
      String productid,
      String workcentreid,
      String workstationid,
      String bomid,
      String revisionno,
      String token,
      BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'productbomid': bomid,
        'revision_number': revisionno
      };
      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.productMachineRoute, token, payload);
        if (response.body.toString() == 'Inserted machine route successfully') {
          return QuickFixUi.successMessage(
              'Machine Route successfully', context);
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  static Future createMachineProductRouteDiffSeqNo(
      String productid,
      String workcentreid,
      String workstationid,
      String bomid,
      String revisionno,
      int nseq,
      int ver,
      String token,
      BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'productbomid': bomid,
        'revision_number': revisionno,
        'nseq': nseq,
        'version': ver,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.machineProductRouteDiffSeqNo, token, payload);
        if (response.body.toString() ==
            'Inserted machine route successfully with diff seq') {
          return QuickFixUi.successMessage(
              'Machine Route successfully inserted', context);
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  static Future createMachineProductRouteDiffRevision(
      String productid,
      String workcentreid,
      String workstationid,
      String bomid,
      String revisionno,
      int ver,
      String token,
      BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'product_id': productid,
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'productbomid': bomid,
        'revision_number': revisionno,
        'version': ver,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.machineProductRouteDiffrevision, token, payload);
        if (response.body.toString() ==
            'Inserted machine route successfully with diff seq') {
          return QuickFixUi.successMessage(
              'Machine Route successfully inserted', context);
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  static Future<String> jobProdutionloadApi(
      {required String requestid,
      required String slipId,
      required String productId,
      required int toBeProducedQty,
      required String machineId,
      required String timeStart,
      required String processid,
      required String token,
      required BuildContext context}) async {
    DateTime productionstart = DateTime.now();
    try {
      final tiemofProductionNotAvailable =
          await QualityInspectionRepository().currentDatabaseTime(token);
      productionstart = DateTime.parse(tiemofProductionNotAvailable.toString());
      // List<ResponseId> requestno =
      //     await OperatorRepository.getsequanceno(token);

      var url =
          Uri.parse("${AppUrl.indURI}/v1/industry40/loadProductionDetails");
      Map<String, dynamic> payload = {
        // "requestid": requestno[0].newRequestId.toString().trim(),
        "slipid": slipId.toString().trim(),
        "productid": productId.toString().trim(),
        "jobActivity": {
          "machineid": machineId.toString().trim(),
          "starttime": productionstart.toString().trim(),
        },
        "tobeproduced": toBeProducedQty,
        "processid": processid.toString().trim(),
      };

      String payloadJson =
          jsonEncode(payload); // Convert payload to JSON string
      var response = await http.post(
        url,
        body: payloadJson, // Use JSON string as the body
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String td = responseData['status'];
        return td;
      } else {
        String responseofAPI = "Job not started";
        return responseofAPI;
      }
    } catch (e) {
      //  debugPrint(e.toString());
    }
    return "";
  }

  static Future<String> jobStartAPI(
      {required String requestid,
      required String slipId,
      required String productId,
      required int toBeProducedQty,
      required String machineId,
      required String timeStart,
      required String processid}) async {
    try {
      //List<Tools> c =
      String check = await OperatorAPIService.jobStartAPI(
          requestid: requestid,
          slipId: slipId,
          productId: productId,
          toBeProducedQty: toBeProducedQty,
          machineId: machineId,
          timeStart: timeStart,
          processid: processid);
      return check;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> jobStopAPI({
    required String slipId,
    required String productCodeId,
    required int toBeProducedQty,
    required String machineId,
  }) async {
    try {
      String check = await OperatorAPIService.jobStopAPI(
        slipId: slipId,
        productCodeId: productCodeId,
        toBeProducedQty: toBeProducedQty,
        machineId: machineId,
      );
      return check;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future machineloginStatus(String workcentreid, String workstationid,
      String employeeid, String token, BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'employee_id': employeeid,
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.machineloginstatus, token, payload);
        if (response.body.toString() ==
            'Machine login status Update successfully') {
          return QuickFixUi.successMessage('login status update', context);
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  static Future machinelogout(String workcentreid, String workstationid,
      String token, BuildContext context) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
      };
      // debugPrint(payload.toString());
      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.machinelogout, token, payload);
        if (response.body.toString() == 'Machine logout successfully') {
          return QuickFixUi.successMessage('logout status update', context);
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  static Future<List<op_model.MachineProgramListFromERP>>
      getMachineProgramListFromERP(String productid, String revisionno,
          String workcenterid, String seqNo, String token) async {
    Map<String, dynamic> payload = {};

    try {
      payload = {
        'product_id': productid,
        'revisionno': revisionno,
        'workcentre_id': workcenterid,
        'Process_seqno': seqNo,
      };

      // debugPrint(payload.toString());

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.machineProgramListFromERP, token, payload);

        if (response.statusCode == 200) {
          List<dynamic> responseData = jsonDecode(response.body);
          List<op_model.MachineProgramListFromERP> machineprogramlistfromERP =
              responseData
                  .map((item) =>
                      op_model.MachineProgramListFromERP.fromJson(item))
                  .toList();

          return machineprogramlistfromERP;
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return [];
  }

  static Future<List<op_model.Operatorworkstatuslist>> operatorworkstatus(
      String employeeid, String token) async {
    Map<String, dynamic> payload = {};

    try {
      payload = {
        'employee_id': employeeid,
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.operatorworkstatusall, token, payload);
        if (response.statusCode == 200) {
          List<dynamic> responseData = jsonDecode(response.body);
          List<op_model.Operatorworkstatuslist> operatorworkstatusall =
              responseData
                  .map((item) => op_model.Operatorworkstatuslist.fromJson(item))
                  .toList();
          return operatorworkstatusall;
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return [];
  }

  static Future<List<op_model.Tools>> toollist(
      {required String workcentreid, dynamic token}) async {
    Map<String, dynamic> payload = {};
    try {
      payload = {
        'workcentre_id': workcentreid,
      };

      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.toollist, token, payload);

        if (response.statusCode == 200) {
          List<dynamic> responseData = jsonDecode(response.body);
          List<op_model.Tools> toolsList = responseData
              .map((item) => op_model.Tools.fromJson(item))
              .toList();
          return toolsList;
        }
      }
    } catch (e) {
      //  debugPrint(e.toString());
    }
    return [];
  }

  static Future<List<op_model.OperatorRejectedReasons>> rejectedReasons(
      String token) async {
    List<dynamic> rejectedReasonsList = [];
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        var response =
            await API().getApiResponse(AppUrl.operatorRejectedReasons, headers);
        rejectedReasonsList = jsonDecode(response.body);
      }
    } catch (e) {
      //  debugPrint(e.toString());
    }
    return rejectedReasonsList
        .map((e) => op_model.OperatorRejectedReasons.fromJson(e))
        .toList();
  }

  static Future<op_model.Barcode> getBarcodeData({
    required String token,
    required String year,
    required String documentno,
  }) async {
    Map<String, dynamic> payload = {};
    op_model.Barcode barCode = op_model.Barcode();
    try {
      payload = {"year": year, "document_no": documentno};
      var response =
          await API().postApiResponse(AppUrl.scanbarcodedata, token, payload);
      List<dynamic> jsonData = jsonDecode(response.body);
      barCode = op_model.Barcode.fromJson(jsonData[0]);
      return barCode;
    } catch (e) {
      //debugPrint(e.toString());
      throw Exception(
          'Failed to retrieve barcode data'); // Throw an exception if an error occurs
    }
  }

  Future<List<op_model.Wcprogramlist>> machineprogramlist({
    required String token,
    required String workcentreid,
    required String productid,
    required String revisionno,
  }) async {
    try {
      Map<String, dynamic> payload = {
        'workcentre_id': workcentreid,
        'product_id': productid,
        'revision_number': revisionno,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
          AppUrl.machineprogramlist,
          token,
          payload,
        );

        List<dynamic> responseData = jsonDecode(response.body);
        List<op_model.Wcprogramlist> wcprogramlist = responseData
            .map((item) => op_model.Wcprogramlist.fromJson(item))
            .toList();

        return wcprogramlist;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<op_model.Productprocessseq>> productprocessseq({
    required String token,
    required String workcentreid,
    required String productid,
    required String revisionno,
  }) async {
    try {
      Map<String, dynamic> payload = {
        'workcentre_id': workcentreid,
        'product_id': productid,
        'revision_number': revisionno,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
          AppUrl.productprocessseq,
          token,
          payload,
        );
        List<dynamic> responseData = jsonDecode(response.body);
        List<op_model.Productprocessseq> productproseq = responseData
            .map((item) => op_model.Productprocessseq.fromJson(item))
            .toList();

        return productproseq;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<op_model.ResponseId>> getsequanceno(String token) async {
    List<op_model.ResponseId> requestID = [];
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        final response = await API().getApiResponse(AppUrl.requestid, headers);

        List<dynamic> requestIdList = jsonDecode(response.body);

        requestIdList
            .map((item) => op_model.ResponseId.fromJson(item))
            .toList();
        return requestID;
      }
    } catch (e) {
      //  debugPrint(e.toString());
    }
    return requestID;
  }

  Future<String> getproductworkstationJobStatusId(
    String productid,
    String rmsIssueid,
    String workcentreid,
    String workstationid,
    String employeeid,
    String processrouteid,
    String seqno,
    String token,
  ) async {
    Map<String, dynamic> payload = {};
    String worstationStatusId = '';
    try {
      payload = {
        'product_id': productid,
        'rms_issue_id': rmsIssueid,
        'workcentre_id': workcentreid,
        'workstation_id': workstationid,
        'employee_id': employeeid,
        'processrouteid': processrouteid,
        'seqno': seqno
      };
      // debugPrint("getproductworkstationJobStatusId---::::>>>");
      // debugPrint(payload.toString());
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.workstationstatusid, token, payload);

        // debugPrint(response.body.toString());
        if (response.body.toString() == '[]') {
          worstationStatusId = '';
        } else {
          final data = jsonDecode(response.body);
          worstationStatusId = data[0]['id'].toString();
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return worstationStatusId;
  }

  static Future<List<op_model.MachinIpUsername>> getmachineuserdata(
      {required String wc, required String ws, required String token}) async {
    try {
      Map<String, dynamic> payload = {
        'workcentre_id': wc,
        'workstation_id': ws,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
          AppUrl.getmachineuserdata,
          token,
          payload,
        );

        List<dynamic> responseData = jsonDecode(response.body);
        List<op_model.MachinIpUsername> productproseq = responseData
            .map((item) => op_model.MachinIpUsername.fromJson(item))
            .toList();

        return productproseq;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<String> getInstructionString(
      {required String processrouteid, required String token}) async {
    try {
      Map<String, dynamic> payload = {
        'processrouteid': processrouteid,
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
          AppUrl.getInstructiondata,
          token,
          payload,
        );

        var responseData = jsonDecode(response.body);
        String instruction = responseData[0]['instruction'].toString();
        return instruction;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  static Future<String> inserttoollist(
      {required String productionstatusid,
      required String toollist,
      required String token}) async {
    try {
      Map<String, dynamic> payload = {
        'productionstatusid': productionstatusid,
        'toolList': toollist
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
          AppUrl.inserttoollist,
          token,
          payload,
        );

        return response.body.toString();
      } else {
        return '';
      }
    } catch (e) {
      debugPrint(e.toString());

      return '';
    }
  }

  Future<bool> cpmessagesendStatusCheck(String productid, String revisionnumber,
      String rmsissueid, String token, String poid, String lineitno) async {
    bool cpmessage = false;
    try {
      Map<String, dynamic> payload = {
        'product_id': productid,
        'revisionno': revisionnumber,
        'rms_issue_id': rmsissueid,
        'po_id': poid,
        'lineitno': lineitno,
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.cpmessageStatusCheck, token, payload);

        var data = jsonDecode(response.body.toString());
        if (data[0]['product_id'].toString().trim() == productid &&
            data[0]['revision_no'].toString().trim() == revisionnumber &&
            data[0]['rmsissue_id'].toString().trim() == rmsissueid &&
            data[0]['po_id'].toString().trim() == poid &&
            data[0]['lineitno'].toString().trim() == lineitno) {
          cpmessage = true;
        }
      }
      return cpmessage;
    } catch (e) {
      //   debugPrint(e.toString());
    }
    return cpmessage;
  }

  Future<bool> prmessagesendStatusCheck(
      String productid,
      String revisionnumber,
      String rmsissueid,
      String token,
      String poid,
      String lineitno,
      String workcentreid) async {
    bool prmessage = false;
    try {
      Map<String, dynamic> payload = {
        'product_id': productid,
        'revisionno': revisionnumber,
        'rms_issue_id': rmsissueid,
        'po_id': poid,
        'lineitno': lineitno,
        'workcentre_id': workcentreid
      };

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.prmessageStatusCheck, token, payload);

        var data = jsonDecode(response.body.toString());
        if (data[0]['product_id'].toString().trim() == productid &&
            data[0]['revision_no'].toString().trim() == revisionnumber &&
            data[0]['rmsissue_id'].toString().trim() == rmsissueid &&
            data[0]['po_id'].toString().trim() == poid &&
            data[0]['lineitno'].toString().trim() == lineitno &&
            data[0]['workcentre_id'].toString().trim() == workcentreid) {
          prmessage = true;
        }
      }
      return prmessage;
    } catch (e) {
      // debugPrint(e.toString());
    }
    return prmessage;
  }

  static Future cpmessageinsert(
      {required String productid,
      required String revisionnumber,
      required String rmsissueid,
      required String poid,
      required String lineitno,
      required String employeeid,
      required String token,
      required BuildContext context}) async {
    try {
      Map<String, dynamic> payload = {
        'product_id': productid,
        'revisionno': revisionnumber,
        'rms_issue_id': rmsissueid,
        'po_id': poid,
        'lineitno': lineitno,
        'employeeid': employeeid
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
          AppUrl.cpmessageinsert,
          token,
          payload,
        );
        if (response.body.toString() == 'Inserted successfully') {}
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  static Future prmessageinsert(
      {required String productid,
      required String revisionnumber,
      required String rmsissueid,
      required String poid,
      required String lineitno,
      required String employeeid,
      required String whatsupno,
      required String message,
      required String workcentreid,
      required String token,
      required BuildContext context}) async {
    try {
      Map<String, dynamic> payload = {
        'product_id': productid,
        'revisionno': revisionnumber,
        'rms_issue_id': rmsissueid,
        'po_id': poid,
        'lineitno': lineitno,
        'employeeid': employeeid,
        'authorized_person': whatsupno,
        'message': message,
        'workcentre_id': workcentreid
      };

      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
          AppUrl.prmessageinsert,
          token,
          payload,
        );
        if (response.body.toString() == 'Inserted successfully') {}
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<List<String>> availableProductRoute(
      {required String productid,
      required String revisionnumber,
      required String token,
      required BuildContext context}) async {
    try {
      Map<String, dynamic> payload = {
        'product_id': productid,
        'revisionno': revisionnumber,
      };

      if (payload.isNotEmpty) {
        var response =
            await API().postApiResponse(AppUrl.availablePR, token, payload);
        var responseData = jsonDecode(response.body);

        return extractCodes(responseData);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<String> extractCodes(List<dynamic> response) {
    List<String> codes = [];

    for (var item in response) {
      if (item['code'] != null) {
        codes.add(item['code']);
      }
    }

    return codes;
  }
}

class ApiClient {
  Future<Map<String, dynamic>> fetchData({
    required op_model.Barcode barcode,
    required String processrouteid,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    String machineid = '';

    if (processrouteid == '') {
      processrouteid = "noprocess";
    }

    try {
      final machinedata = await MachineData.geMachineData();

      for (var element in machinedata) {
        Map<String, dynamic> data = jsonDecode(element);
        machineid = data['machineid'].toString();
      }

      var url = Uri.parse(
          "http://192.168.0.55:3213/v1/industry40/getProductionStatus");

      Map<String, dynamic> payload = {
        "slipid": barcode.rawmaterialissueid.toString().trim(),
        "productid": barcode.productid.toString().trim(),
        "machineid": machineid.toString().trim(),
        "processid": processrouteid.toString().trim(),
      };
      String payloadJson = jsonEncode(payload);

      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        return jsonData;
      } else {}
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
    return {'error': 'An error occurred: $e'};
  }
}
