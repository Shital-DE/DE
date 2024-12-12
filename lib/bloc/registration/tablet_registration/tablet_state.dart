// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Tablet registration state

part of 'tablet_bloc.dart';

abstract class TabletState {}

class TabletLoading extends TabletState {
  TabletLoading();
}

class TabletLoaded extends TabletState {
  final List<Workcentre> workcentreList;
  final List<WorkstationByWorkcentreId> workstationList;
  final List<CheckTabIsAssignedOrNot> checkTabIsAssignedList;
  final List<AllWcWsWithAndroidId> allTabAssignedList;
  final String workcentreId, workstationId, token, androidId;
  final bool checkALreadyRegisteredTabletList;
  TabletLoaded(
      {required this.androidId,
      required this.workcentreList,
      required this.workstationList,
      required this.checkTabIsAssignedList,
      required this.token,
      required this.allTabAssignedList,
      required this.workcentreId,
      required this.workstationId,
      required this.checkALreadyRegisteredTabletList});
}

class TabletErrorState extends TabletState {
  final String errorMessage;
  TabletErrorState({required this.errorMessage});
}

class DeleteTabletState extends TabletState {
  final String workstationid;
  DeleteTabletState(this.workstationid);
}
