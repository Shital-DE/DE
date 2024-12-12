import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../services/model/po/po_models.dart';
import '../../../../../services/repository/capacity_plan/capacity_plan_repository.dart';

part 'plandate_state.dart';

class PlanDateCubit extends Cubit<PlanDateState> {
  PlanDateCubit() : super(const PlanDateInitial());

  Future<void> searchPO({required String po}) async {
    try {
      SalesOrder list = await CapacityPlanRepository.searchPO(po: po);
      if (list.isEmpty) {
        emit(const POLoadError(message: "PO Not Found"));
      } else {
        emit(POPlanDateLoad(so: list, po: po));
      }
    } catch (e) {
      // emit(RuntimeMasterDataError(
    }
  }

  // Future<void> selectNewDate(
  //     {required String newdate, required String po}) async {
  //   try {
  //     SalesOrder list = await CapacityPlanRepository.searchPO(po: po);
  //     list.plandate = newdate;

  //     emit(POPlanDateLoad(so: list, po: po));
  //   } catch (e) {
  //     // emit(RuntimeMasterDataError(
  //   }
  // }

  Future<void> editallPOPlanDate(
      {required String poid,
      required String plandate,
      required String po}) async {
    try {
      String result = await CapacityPlanRepository.editAllPOPlanDate(
          po: poid, plandate: plandate);
      if (result == 'Success') {
        SalesOrder list = await CapacityPlanRepository.searchPO(po: po);
        emit(POPlanDateLoad(so: list, po: po));
      }
    } catch (e) {
      // emit(RuntimeMasterDataError(
      //     errorMessage: e.toString(), runtimeMasterData: const []));
    }
  }

  Future<void> editsinglePOProductPlanDate(
      // {required String po,
      // required String poProductId,
      // required String plandate}
      {
    required SalesOrderDetails soDeails,
    required String po,
  }) async {
    try {
      String result = await CapacityPlanRepository.editSinglePOProductPlanDate(
          soDeails: soDeails);
      if (result == 'Success') {
        SalesOrder list = await CapacityPlanRepository.searchPO(po: po);
        emit(POPlanDateLoad(so: list, po: po));
        // emit(POPlanDateLoad(list));
      }
    } catch (e) {
      // emit(RuntimeMasterDataError(
      //     errorMessage: e.toString(), runtimeMasterData: const []));
    }
  }
}
