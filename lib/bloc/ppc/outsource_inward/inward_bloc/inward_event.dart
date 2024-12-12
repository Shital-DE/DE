part of 'inward_bloc.dart';

class InwardEvent {
  const InwardEvent();
}

class InwardListLoadEvent extends InwardEvent {
  final String subcontractorid;
  InwardListLoadEvent({required this.subcontractorid});
}

class InwardSaveEvent extends InwardEvent {
  final InwardChallan inwardData;
  final int qty;
  final bool status;
  final String subcontractorid;
  InwardSaveEvent(
      {required this.inwardData,
      required this.qty,
      required this.status,
      required this.subcontractorid});
}

class FinishedInwardListLoadEvent extends InwardEvent {
  final bool check;
  final String subcontractorid;
  FinishedInwardListLoadEvent(
      {required this.check, required this.subcontractorid});
}
