// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Dashboard state
//Modified date : 21 May 2023

import '../../services/model/dashboard/dashboard_model.dart';

abstract class DashboardState {}

class DashboardinitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {
  final List<UserModule> data;
  final int selectedIndex;
  final Map<String, dynamic> folder;
  final List<Programs> programsList;
  final String workcentreid, isautomatic;
  DashboardLoadingState(
      {required this.data,
      required this.selectedIndex,
      required this.folder,
      required this.programsList,
      required this.workcentreid,
      required this.isautomatic});
}

class DashboardError extends DashboardState {
  final String errorMessage;
  DashboardError({required this.errorMessage});
}
