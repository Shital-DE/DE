//  Author : Shital Gayakwad
// Description : ERPX_PPC -> Product and Process route event
// Created : 24 August 2023

part of 'product_and_process_route_bloc.dart';

class ProductAndProcessRouteEvent {
  const ProductAndProcessRouteEvent();
}

class GetProductProcessRouteParams extends ProductAndProcessRouteEvent {
  final String productId,
      productRevision,
      workcentreid,
      workstationid,
      desciption,
      runtimeMinutes,
      setupMinutes,
      addNewRow,
      workcentre,
      workstation,
      updateData,
      processId,
      processName;
  final int sequencenumber;
  final List<ProductAndProcessRouteModel> productAndProcessRouteDataList;
  final List<String> topBottomDataAaray;
  GetProductProcessRouteParams(
      {this.productId = '',
      this.productRevision = '',
      this.workcentreid = '',
      this.workstationid = '',
      this.desciption = '',
      this.runtimeMinutes = '0',
      this.setupMinutes = '0',
      this.sequencenumber = 10,
      this.addNewRow = '',
      this.productAndProcessRouteDataList = const [],
      this.workcentre = '',
      this.workstation = '',
      this.topBottomDataAaray = const ['', ''],
      this.updateData = '',
      this.processId = '',
      this.processName = ''});
}

// ======================================= Already Filled Product ===============================================

class ProductRouteDataEvent {
  const ProductRouteDataEvent();
}

class GetProductRouteData extends ProductRouteDataEvent {
  const GetProductRouteData();
}
