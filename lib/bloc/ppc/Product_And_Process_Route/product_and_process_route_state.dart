//  Author : Shital Gayakwad
// Description : ERPX_PPC -> Product and Process route state
// Created : 24 August 2023

part of 'product_and_process_route_bloc.dart';

class ProductAndProcessRouteState {
  const ProductAndProcessRouteState();
}

class ProductAndProcessRouteInitial extends ProductAndProcessRouteState {}

class SetProductProcessRouteParams extends ProductAndProcessRouteState {
  final String productId,
      productRevision,
      workcentreid,
      workstationid,
      desciption,
      runtimeMinutes,
      setupMinutes,
      token,
      userId,
      addNewRow,
      productbillofmaterialId,
      workcentre,
      workstation,
      updateData,
      processId,
      processName;
  final int sequencenumber;
  final List<ProductRevision> productRevisionList;
  final List<Workcentre> workcentreList;
  final List<WorkstationByWorkcentreId> workstationList;
  final List<ProductAndProcessRouteModel> productAndProcessRouteDataList;
  final List<String> topBottomDataAaray;
  final List<Process> processList;
  final Iterable<ProductAndProcessRouteModel> processData;
  SetProductProcessRouteParams(
      {required this.productRevisionList,
      required this.productId,
      required this.productRevision,
      required this.workcentreid,
      required this.workstationid,
      required this.workcentreList,
      required this.workstationList,
      required this.desciption,
      required this.runtimeMinutes,
      required this.setupMinutes,
      required this.token,
      required this.userId,
      required this.productbillofmaterialId,
      required this.productAndProcessRouteDataList,
      required this.sequencenumber,
      required this.addNewRow,
      required this.workcentre,
      required this.workstation,
      required this.topBottomDataAaray,
      required this.updateData,
      required this.processId,
      required this.processList,
      required this.processName,
      required this.processData});
}

class ProductProcessRouteErrorState extends ProductAndProcessRouteState {
  final String errorMessage;
  ProductProcessRouteErrorState({required this.errorMessage});
}

// ======================================= Already Filled Product ===============================================

class ProductRouteDataState {
  const ProductRouteDataState();
}

class ProductRouteDataInitialState extends ProductRouteDataState {
  const ProductRouteDataInitialState();
}

class SetProductRouteData extends ProductRouteDataState {
  final List<FilledProductAndProcessRoute> routeData;
  final int routeCount;
  const SetProductRouteData(
      {required this.routeData, required this.routeCount});
}

class ProductRouteErrorState extends ProductRouteDataState {
  final String errorMessage;
  ProductRouteErrorState({required this.errorMessage});
}
