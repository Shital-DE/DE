// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Tablet registration event

abstract class TabletEvent {}

class TabletFormEvent extends TabletEvent {
  final String workcentreId;
  final String workstationId;
  final bool checkALreadyRegisteredTabletList;
  TabletFormEvent(
      {this.workcentreId = '',
      this.workstationId = '',
      this.checkALreadyRegisteredTabletList = false});
}

class DeleteTablet extends TabletEvent {
  final String workstationId;
  final String token;
  DeleteTablet(this.workstationId, this.token);
}
