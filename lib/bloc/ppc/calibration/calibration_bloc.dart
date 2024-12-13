// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration bloc

import 'package:bloc/bloc.dart';
import '../../../services/model/quality/calibration_model.dart';
import '../../../services/model/registration/subcontractor_models.dart';
import '../../../services/repository/outsource/outsource_repository.dart';
import '../../../services/repository/quality/calibration_repository.dart';
import '../../../services/repository/registration/subcontractor_repository.dart';
import '../../../services/session/user_login.dart';
import 'calibration_event.dart';
import 'calibration_state.dart';
import 'package:intl/intl.dart';

class CalibrationBloc extends Bloc<CalibrationEvent, CalibrationState> {
  CalibrationBloc() : super(CalibrationInitialState()) {
    on<CalibrationInitialEvent>((event, emit) {
      emit(CalibrationInitialState());
    });

    //-----------------------Instrument registration-----------------------------------
    on<InstrumentsRegistrationEvent>((event, emit) async {
      final saveddata = await UserData.getUserData();
      List<MeasuringInstruments> measuringInstrumentsList =
          await CalibrationRepository()
              .getMeasuringInstruments(token: saveddata['token'].toString());
      List<InstrumentsTypeData> instrumentsTypeList =
          await CalibrationRepository()
              .getInstrumentTypes(token: saveddata['token'].toString());
      List<AllInstrumentsData> allInstrumentsList =
          await CalibrationRepository()
              .getAllInstruments(token: saveddata['token'].toString());
      emit(InstrumentsRegistrationState(
          token: saveddata['token'].toString(),
          measuringInstrumentsList: measuringInstrumentsList,
          instrumentsTypeList: instrumentsTypeList,
          userId: saveddata['data'][0]['id'].toString(),
          allInstrumentsList: allInstrumentsList));
    });

    //-----------------------Instrument type registration-----------------------------------
    on<InstrumentTypeRegistrationEvent>((event, emit) async {
      final saveddata = await UserData.getUserData();
      List<InstrumentsTypeData> instrumentsTypeList =
          await CalibrationRepository()
              .getInstrumentTypes(token: saveddata['token'].toString());
      List<ManufacturerData> manufacturerData = await CalibrationRepository()
          .getManufacturerData(token: saveddata['token'].toString());
      emit(InstrumentTypeRegistrationState(
          token: saveddata['token'].toString(),
          instrumentsTypeList: instrumentsTypeList,
          userId: saveddata['data'][0]['id'].toString(),
          manufacturerData: manufacturerData));
    });

    //-----------------------Calibration schedule registration-----------------------------------
    on<CalibrationScheduleRegistrationEvent>((event, emit) async {
      final saveddata = await UserData.getUserData();
      List<AllInstrumentsData> allInstrumentsList =
          await CalibrationRepository()
              .getAllInstruments(token: saveddata['token'].toString());

      List<Frequency> frequencyList = await CalibrationRepository()
          .frequency(token: saveddata['token'].toString());

      List<CurrentDayInstrumentsRegistered> currentDayRecords =
          await CalibrationRepository()
              .currentDayRecords(token: saveddata['token'].toString());

      List<ManufacturerData> manufacturerData = await CalibrationRepository()
          .getManufacturerData(token: saveddata['token'].toString());

      emit(CalibrationScheduleRegistrationState(
          allInstrumentsList: allInstrumentsList,
          token: saveddata['token'].toString(),
          frequencyList: frequencyList,
          userId: saveddata['data'][0]['id'].toString(),
          currentDayRecords: currentDayRecords,
          manufacturerData: manufacturerData));
    });

    //-----------------------Calibration status-----------------------------------
    on<InstrumentCalibrationStatusEvent>((event, emit) async {
      final saveddata = await UserData.getUserData();
      List<CalibrationStatusModel> calibrationStatusList = [];

      // if (event.range == 0) {
      calibrationStatusList = await CalibrationRepository().calibrationStatus(
          token: saveddata['token'].toString(),
          range: 0,
          // event.range,
          searchString: ''
          // event.searchString
          );
      // }
      List<InstrumentRejectionReasons> rejectionReasons =
          await CalibrationRepository()
              .instrumentRejectionReasons(token: saveddata['token'].toString());
      emit(InstrumentCalibrationStatusState(
          calibrationStatusList: calibrationStatusList,
          token: saveddata['token'].toString(),
          userId: saveddata['data'][0]['id'].toString(),
          rejectionReasons: rejectionReasons,
          // range: event.range,
          // searchString: event.searchString,
          selectedInstrumentsList: event.selectedInstrumentsList));
    });

    //-----------------------Order instrument-------------------------------------
    on<OrderInstrumentEvent>((event, emit) async {
      final saveddata = await UserData.getUserData();
      List<MailAddress> toList = [];
      List<MailAddress> fromList = await CalibrationRepository().emailAddresses(
          token: saveddata['token'].toString(), payload: {'recipient': 'fr'});
      if (fromList.isNotEmpty) {
        toList = await CalibrationRepository().emailAddresses(
            token: saveddata['token'].toString(), payload: {'recipient': 'to'});
      }
      List<AllInstrumentsData> allInstrumentsList =
          await CalibrationRepository()
              .getAllInstruments(token: saveddata['token'].toString());
      List<RejectedInstrumentsDataModel> rejectedInstrumentsDataList =
          await CalibrationRepository()
              .rejectedInstrumentsData(token: saveddata['token'].toString());
      emit(OrderInstrumentState(
          token: saveddata['token'].toString(),
          fromList: fromList,
          toList: toList,
          allInstrumentsList: allInstrumentsList,
          userId: saveddata['data'][0]['id'].toString(),
          rejectedInstrumentsDataList: rejectedInstrumentsDataList));
    });

    //-----------------------All instrument orders-------------------------------------
    on<AllInstrumentOrdersEvent>((event, emit) async {
      final saveddata = await UserData.getUserData();
      List<AllInstrumentOrdersModel> allinstrumentOrdersList =
          await CalibrationRepository()
              .allInstrumentOrders(token: saveddata['token'].toString());
      emit(AllInstrumentOrdersState(
          allinstrumentOrdersList: allinstrumentOrdersList,
          token: saveddata['token'].toString()));
    });

    //----------------------Sent instrument for calibration---------------------------------------
    on<OutwardInstrumentsEvent>((event, emit) async {
      // User data and token
      final saveddata = await UserData.getUserData();

      // Oursource challan
      String challanno = await OutsourceRepository.getChallanNo();

      // Current date
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      String date = formatter.format(DateTime.now());

      // Instruments list which need to calibrate
      List<OutsourcedInstrumentsModel> outwardInstrumentsList =
          await CalibrationRepository()
              .outwardInstruments(token: saveddata['token'].toString());

      // Subcontractor list
      List<CalibrationContractors> calibrationContractorList =
          await SubcontractorRepository()
              .calibrationContractorsData(token: saveddata['token'].toString());
      emit(OutwardInstrumentsState(
          token: saveddata['token'].toString(),
          userId: saveddata['data'][0]['id'].toString(),
          outwardInstrumentsList: outwardInstrumentsList,
          calibrationContractorList: calibrationContractorList,
          subcontactor: event.subcontactor ?? CalibrationContractors(),
          chalanno: challanno,
          currentdate: date));
    });

    //----------------------Collect calibrated instruments---------------------------------------
    on<InwardInstrumentsEvent>((event, emit) async {
      // User data and token
      final saveddata = await UserData.getUserData();

      // Inward instruments
      List<OutsourcedInstrumentsModel> inwardInstrumentsList =
          await CalibrationRepository()
              .inwardInstruments(token: saveddata['token'].toString());

      // Frequency
      List<Frequency> frequencyList = await CalibrationRepository()
          .frequency(token: saveddata['token'].toString());

      List<InstrumentRejectionReasons> rejectionReasons =
          await CalibrationRepository()
              .instrumentRejectionReasons(token: saveddata['token'].toString());

      emit(InwardInstrumentsState(
          inwardInstrumentsList: inwardInstrumentsList,
          frequencyList: frequencyList,
          token: saveddata['token'].toString(),
          rejectionReasons: rejectionReasons,
          userId: saveddata['data'][0]['id'].toString()));
    });

    //----------------------Instrument calibration outsource workorder---------------------------------------
    on<OutsourceWorkorderEvent>((event, emit) async {
      // User data and token
      final saveddata = await UserData.getUserData();
      List<OutsorceWorkordersModel> allWorkorders =
          await CalibrationRepository()
              .allWorkorders(token: saveddata['token'].toString());
      emit(OutsourceWorkorderState(
          allWorkorders: allWorkorders, token: saveddata['token'].toString()));
    });

    //----------------------Instrument calibration history---------------------------------------
    on<InstrumentCalibrationHistoryEvent>((event, emit) async {
      List<CalibrationHistoryModel> calibrationHistory = [];
      // User data and token
      final saveddata = await UserData.getUserData();

      // Instruments list
      List<AllInstrumentsData> allInstrumentsList =
          await CalibrationRepository()
              .getAllInstruments(token: saveddata['token'].toString());
      if (event.instrument != null && event.instrument!.id != null) {
        calibrationHistory = await CalibrationRepository()
            .searchedInstrument(token: saveddata['token'].toString(), payload: {
          'id': event.instrument!.id.toString(),
          'instrument_id': event.instrument!.instrumentId.toString()
        });
        calibrationHistory += await CalibrationRepository()
            .oneInstrumentHistory(
                token: saveddata['token'].toString(),
                payload: {
              'id': event.instrument!.id.toString(),
              'instrument_id': event.instrument!.instrumentId.toString()
            });
      }
      emit(InstrumentCalibrationHistoryState(
          allInstrumentsList: allInstrumentsList,
          token: saveddata['token'].toString(),
          calibrationHistory: calibrationHistory));
    });

    //----------------------------Instrument store------------------------------------
    on<InstrumentStoreEvent>((event, emit) async {
      // User data and token
      final saveddata = await UserData.getUserData();

      List<StoredInstrumentsModel> storedInstrumentsData =
          await CalibrationRepository()
              .storedInstruments(token: saveddata['token'].toString());
      emit(InstrumentStoreState(
          storedInstrumentsData: storedInstrumentsData,
          token: saveddata['token'].toString()));
    });
  }
}
