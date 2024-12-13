// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration state

import '../../../services/model/quality/calibration_model.dart';
import '../../../services/model/registration/subcontractor_models.dart';

class CalibrationState {}

class CalibrationInitialState extends CalibrationState {}

class InstrumentsRegistrationState extends CalibrationState {
  final List<MeasuringInstruments> measuringInstrumentsList;
  final List<InstrumentsTypeData> instrumentsTypeList;
  final List<AllInstrumentsData> allInstrumentsList;
  final String token, userId;
  InstrumentsRegistrationState(
      {required this.token,
      required this.measuringInstrumentsList,
      required this.instrumentsTypeList,
      required this.userId,
      required this.allInstrumentsList});
}

class InstrumentTypeRegistrationState extends CalibrationState {
  final String token, userId;
  final List<InstrumentsTypeData> instrumentsTypeList;
  final List<ManufacturerData> manufacturerData;
  InstrumentTypeRegistrationState(
      {required this.token,
      required this.instrumentsTypeList,
      required this.userId,
      required this.manufacturerData});
}

class CalibrationScheduleRegistrationState extends CalibrationState {
  final List<AllInstrumentsData> allInstrumentsList;
  final List<Frequency> frequencyList;
  final List<CurrentDayInstrumentsRegistered> currentDayRecords;
  final List<ManufacturerData> manufacturerData;
  final String token, userId;
  CalibrationScheduleRegistrationState(
      {required this.allInstrumentsList,
      required this.token,
      required this.frequencyList,
      required this.userId,
      required this.currentDayRecords,
      required this.manufacturerData});
}

class InstrumentCalibrationStatusState extends CalibrationState {
  final List<CalibrationStatusModel> calibrationStatusList;
  final List<InstrumentRejectionReasons> rejectionReasons;
  final List<CalibrationStatusModel> selectedInstrumentsList;
  final String token, userId;
  InstrumentCalibrationStatusState(
      {required this.calibrationStatusList,
      required this.token,
      required this.userId,
      required this.rejectionReasons,
      required this.selectedInstrumentsList});
}

class OrderInstrumentState extends CalibrationState {
  final String token, userId;
  final List<MailAddress> fromList;
  final List<MailAddress> toList;
  final List<AllInstrumentsData> allInstrumentsList;
  final List<RejectedInstrumentsDataModel> rejectedInstrumentsDataList;
  OrderInstrumentState(
      {required this.token,
      required this.fromList,
      required this.toList,
      required this.allInstrumentsList,
      required this.userId,
      required this.rejectedInstrumentsDataList});
}

class AllInstrumentOrdersState extends CalibrationState {
  final List<AllInstrumentOrdersModel> allinstrumentOrdersList;
  final String token;
  AllInstrumentOrdersState(
      {required this.allinstrumentOrdersList, required this.token});
}

class OutwardInstrumentsState extends CalibrationState {
  final String token, userId, chalanno, currentdate;
  final List<OutsourcedInstrumentsModel> outwardInstrumentsList;
  final List<CalibrationContractors> calibrationContractorList;
  final CalibrationContractors subcontactor;
  OutwardInstrumentsState(
      {required this.token,
      required this.userId,
      required this.outwardInstrumentsList,
      required this.calibrationContractorList,
      required this.subcontactor,
      required this.chalanno,
      required this.currentdate});
}

class InwardInstrumentsState extends CalibrationState {
  final List<OutsourcedInstrumentsModel> inwardInstrumentsList;
  final List<Frequency> frequencyList;
  final String token, userId;
  final List<InstrumentRejectionReasons> rejectionReasons;
  InwardInstrumentsState(
      {required this.inwardInstrumentsList,
      required this.frequencyList,
      required this.token,
      required this.rejectionReasons,
      required this.userId});
}

class OutsourceWorkorderState extends CalibrationState {
  final String token;
  final List<OutsorceWorkordersModel> allWorkorders;
  OutsourceWorkorderState({required this.allWorkorders, required this.token});
}

class InstrumentCalibrationHistoryState extends CalibrationState {
  final List<AllInstrumentsData> allInstrumentsList;
  final List<CalibrationHistoryModel> calibrationHistory;
  final String token;
  InstrumentCalibrationHistoryState(
      {required this.allInstrumentsList,
      required this.calibrationHistory,
      required this.token});
}

class InstrumentStoreState extends CalibrationState {
  final List<StoredInstrumentsModel> storedInstrumentsData;
  final String token;
  InstrumentStoreState(
      {required this.storedInstrumentsData, required this.token});
}
