/*
/// * Rohini Mane
/// Created 16-04-23
/// Modified 27-04-23
*/

import 'package:de/services/api_services/capacity_plan/capacity_plan_service.dart';
import 'package:de/services/model/capacity_plan/model.dart';
import '../../model/machine/workstation.dart';
import '../../model/po/po_models.dart';

class CapacityPlanRepository {
  static Future<String> checkDate({required String fromDate}) async {
    try {
      String data =
          await CapacityPlanService.checkDateService(fromDate: fromDate);

      return data;
    } catch (e) {
      return "";
    }
  }

  static Future<List<CapacityPlanData>> getCPProducts(
      {required String fromDate, required String toDate}) async {
    try {
      List<CapacityPlanData> list =
          await CapacityPlanService.getCPProductsService(
              fromDate: fromDate, toDate: toDate);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<CapacityPlanData>> addNewCPProducts(
      {required String fromDate,
      required String toDate,
      required int runnumber}) async {
    try {
      List<CapacityPlanData> list =
          await CapacityPlanService.addNewCPProductsService(
              fromDate: fromDate, toDate: toDate, runnumber: runnumber);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<String> saveCapacityPlan(
      {required String fromDate,
      required String toDate,
      required List<CapacityPlanData> list}) async {
    try {
      String result = await CapacityPlanService.saveCapcityPlanService(
          fromDate: fromDate, toDate: toDate, list: list);
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> updateCapacityPlan(
      {required String fromDate,
      required String toDate,
      required int runnumber,
      required List<CapacityPlanData> list}) async {
    try {
      String result = await CapacityPlanService.updateCapcityPlanService(
          fromDate: fromDate, toDate: toDate, runnumber: runnumber, list: list);
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<CapacityPlanList>> getAllCPList() async {
    try {
      List<CapacityPlanList> list =
          await CapacityPlanService.getAllCapacityPlanList();

      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<WorkcentreCP>> getGraphViewCP(int runno) async {
    try {
      List<WorkcentreCP> list = await CapacityPlanService.graphViewCP(runno);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<ProductDragDrop>> cpDragAndDrop(int runno) async {
    try {
      List<ProductDragDrop> list =
          await CapacityPlanService.cpDragAndDropService(runno);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<WorkstationByWorkcentreId>> cpWorkstationList(
      String workcentreId) async {
    // Workstation
    try {
      List<WorkstationByWorkcentreId> list =
          await CapacityPlanService.cpWorkstationService(workcentreId);
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<List<WorkcentreCP>> cpWorkcentreList() async {
    try {
      List<WorkcentreCP> list = await CapacityPlanService.cpWorkcentreService();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveDraggedProduct(
      {required ProductDragDrop product, required String workcentreId}) async {
    try {
      await CapacityPlanService.saveDraggedProductService(
          product: product, workcenterId: workcentreId);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> saveAllDragDropProduct({
    required List<ProductDragDrop> product,
  }) async {
    try {
      String s = await CapacityPlanService.saveAllDragDropProductService(
          product: product);
      return s;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ProductDragDrop>> getWorkcentreAssignProducts(
      {required String workcentreId, required int runnumber}) async {
    try {
      List<ProductDragDrop> productDragDrop =
          await CapacityPlanService.getWorkcentreAssignProductService(
              workcentreId: workcentreId, runnumber: runnumber);
      return productDragDrop;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> deleteWCProductCP({required String cpChildId}) async {
    try {
      String result = await CapacityPlanService.deleteWCProductCPService(
          cpChildId: cpChildId);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> updateWStoCPproduction(
      {required String workstationId,
      required String cpChildId,
      required String capacityplanId}) async {
    try {
      String result = await CapacityPlanService.updateWStoCPService(
          workstationId: workstationId,
          capacityplanId: capacityplanId,
          cpChildId: cpChildId);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<SalesOrder> searchPO({required String po}) async {
    try {
      SalesOrder result = await CapacityPlanService.searchPOService(po: po);
      // if (result.isUndefined) {
      //   print("object not found");
      // }
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> editAllPOPlanDate(
      {required String po, required String plandate}) async {
    try {
      String result = await CapacityPlanService.editAllPOPlanDateService(
          po: po, plandate: plandate);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> editSinglePOProductPlanDate(
      // {required String po,
      // required String poProductId,
      // required String plandate}
      {required SalesOrderDetails soDeails}) async {
    try {
      String result =
          await CapacityPlanService.editSinglePOProductPlanDateService(
              soDeails: soDeails);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<WorkstationShift>> workstationShift(
      {required String workcentreId}) async {
    try {
      List<WorkstationShift> result =
          await CapacityPlanService.workstationShiftService(
              workcentreId: workcentreId);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> selectShift({
    required bool value,
    required String wsStatusId,
  }) async {
    try {
      String result = await CapacityPlanService.selectShiftService(
          value: value, wsStatusId: wsStatusId);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ShiftTotal>> shiftTotal() async {
    try {
      List<ShiftTotal> result = await CapacityPlanService.shiftTotalService();
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
