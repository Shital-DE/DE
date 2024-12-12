// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration event

import '../../../services/model/quality/calibration_model.dart';
import '../../../services/model/registration/subcontractor_models.dart';

class CalibrationEvent {}

class CalibrationInitialEvent extends CalibrationEvent {}

class InstrumentsRegistrationEvent extends CalibrationEvent {}

class InstrumentTypeRegistrationEvent extends CalibrationEvent {}

class CalibrationScheduleRegistrationEvent extends CalibrationEvent {}

class InstrumentCalibrationStatusEvent extends CalibrationEvent {
  // final int range;
  // final String searchString;
  final List<CalibrationStatusModel> selectedInstrumentsList;
  InstrumentCalibrationStatusEvent(
      {
      // this.range = 0,
      // this.searchString = '',
      this.selectedInstrumentsList = const []});
}

class OrderInstrumentEvent extends CalibrationEvent {}

class AllInstrumentOrdersEvent extends CalibrationEvent {}

class OutwardInstrumentsEvent extends CalibrationEvent {
  final CalibrationContractors? subcontactor;
  OutwardInstrumentsEvent({this.subcontactor});
}

class InwardInstrumentsEvent extends CalibrationEvent {}

class OutsourceWorkorderEvent extends CalibrationEvent {}

class InstrumentCalibrationHistoryEvent extends CalibrationEvent {
  final InstrumentsCardModel? instrument;
  InstrumentCalibrationHistoryEvent({this.instrument});
}

class InstrumentStoreEvent extends CalibrationEvent {}
