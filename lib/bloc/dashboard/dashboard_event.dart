// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Dashboard event
//Modified date : 21 May 2023

abstract class DashboardEvent {}

class DashboardMenuEvent extends DashboardEvent {
  final int selectedIndex;
  final Map<String, dynamic> folder;
  final String platform;
  DashboardMenuEvent(
      {this.selectedIndex = 0,
      this.folder = const {
        'id': '', // Production folder id b443992598a6426090c3a2c30407bfb3
        'name': 'Production'
      },
      this.platform = ''});
}
