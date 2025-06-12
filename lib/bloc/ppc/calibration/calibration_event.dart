// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration event

import '../../../services/model/quality/calibration_model.dart';
import '../../../services/model/registration/subcontractor_models.dart';

// Instrument calibration events
class CalibrationEvent {}

// Calibration initial event
class CalibrationInitialEvent extends CalibrationEvent {}

// Instrument registration event
class InstrumentsRegistrationEvent extends CalibrationEvent {}

// Instrument type registration event
class InstrumentTypeRegistrationEvent extends CalibrationEvent {}

// Instrument scedule registration event
class CalibrationScheduleRegistrationEvent extends CalibrationEvent {}

// Instruments status event
class InstrumentCalibrationStatusEvent extends CalibrationEvent {
  final List<CalibrationStatusModel> selectedInstrumentsList;
  InstrumentCalibrationStatusEvent({this.selectedInstrumentsList = const []});
}

//  Order instrument event
class OrderInstrumentEvent extends CalibrationEvent {}

// All instrument orders event
class AllInstrumentOrdersEvent extends CalibrationEvent {}

// Outward instruments
class OutwardInstrumentsEvent extends CalibrationEvent {
  final CalibrationContractors? subcontactor;
  OutwardInstrumentsEvent({this.subcontactor});
}

// Inward instruments
class InwardInstrumentsEvent extends CalibrationEvent {}

// Outsource work order event
class OutsourceWorkorderEvent extends CalibrationEvent {}

// Instrument history event
class InstrumentCalibrationHistoryEvent extends CalibrationEvent {
  final InstrumentsCardModel? instrument;
  InstrumentCalibrationHistoryEvent({this.instrument});
}

// Instrument store event
class InstrumentStoreEvent extends CalibrationEvent {}

// Rejected instruments data event
class RejectedInstrumentsEvent extends CalibrationEvent {
  final List<RejectedInstrumentsModel>? selectedInstrumentList;
  RejectedInstrumentsEvent({this.selectedInstrumentList = const []});
}
