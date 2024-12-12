import 'dart:typed_data';

import 'package:de/services/api_services/outsource/outsource_service.dart';
import 'package:de/services/model/registration/subcontractor_models.dart';

import '../../model/po/po_models.dart';

class OutsourceRepository {
  static Future<List<Outsource>> getOutsourceList(
      {required String fromdate, required String todate}) async {
    try {
      List<Outsource> list = await OutsourceService.listOutsourceData(
          fromdate: fromdate, todate: todate);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<AllSubContractor>> getSubcontrctorList() async {
    try {
      List<AllSubContractor> list = await OutsourceService.subcotractorList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<String> getChallanNo() async {
    try {
      String challan = await OutsourceService.generateChallanNo();
      return challan;
    } catch (e) {
      return "";
    }
  }

  static Future<String> saveChallan(
      {required String challanNo,
      required String subcontractor,
      required List<Outsource> outsourceList}) async {
    try {
      String challan = await OutsourceService.saveOutsourceChallan(
          challanNo: challanNo,
          subcontractor: subcontractor,
          outsourceList: outsourceList);
      return challan;
    } catch (e) {
      return "";
    }
  }

  static Future<String> sendMail(
      {required String challanNo, required Uint8List pdf}) async {
    try {
      String challan = await OutsourceService.sendOutsourceChallanMail(
          challanNo: challanNo, pdf: pdf);
      return challan;
    } catch (e) {
      return "";
    }
  }

  static Future<List<InwardChallan>> getInwardList(
      {required String subcontractorId}) async {
    try {
      List<InwardChallan> list =
          await OutsourceService.inwardList(subcontractorId: subcontractorId);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<String> saveInwardChallan(
      {required InwardChallan inwardchallan,
      required int qty,
      required bool status}) async {
    try {
      String challan = await OutsourceService.saveInwardChallan(
          inwardchallan: inwardchallan, qty: qty, status: status);
      return challan;
    } catch (e) {
      return "";
    }
  }

  static Future<List<InwardChallan>> getFinishedInwardList(
      {required String subcontractorId, required bool check}) async {
    try {
      List<InwardChallan> list = await OutsourceService.finishedInwardList(
          subcontractorId: subcontractorId, check: check);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<String> savesubcontractorProcessCapability(
      {required String subcontractorId, required String processId}) async {
    try {
      String result = await OutsourceService.savesubcontractorProcessCapability(
          subcontractorId: subcontractorId, processId: processId);
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<ProcessCapability>> listProcessCapability() async {
    try {
      List<ProcessCapability> result =
          await OutsourceService.listProcessCapability();
      return result;
    } catch (e) {
      return [];
    }
  }

  static Future deleteProcessCapability({required String id}) async {
    try {
      await OutsourceService.deleteProcessCapability(id: id);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<CompanyDetails> companyDetails() async {
    try {
      CompanyDetails company = await OutsourceService.getCompanyDetails();
      return company;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ChallanPDFList>> listChallanPdf(
      {required String subcontractorId,
      required int month,
      required int year}) async {
    try {
      List<ChallanPDFList> list = await OutsourceService.listChallanPdfService(
          subcontractorId: subcontractorId, month: month, year: year);
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }
}
