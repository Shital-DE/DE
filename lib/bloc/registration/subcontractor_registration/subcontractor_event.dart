// Author : Shital Gayakwad
// Created Date : 30 April 2023
// Description : ERPX_PPC -> Subcontractor event

abstract class SubcontractorRegistrationEvent {}

class SubcontractorRegistrationInitialEvent
    extends SubcontractorRegistrationEvent {
  final Map<String, dynamic> subcontractorData;
  final String address1, address2;
  final bool isCkeckBoxChecked;
  SubcontractorRegistrationInitialEvent(
      {required this.subcontractorData,
      required this.address1,
      required this.address2,
      required this.isCkeckBoxChecked});
}
