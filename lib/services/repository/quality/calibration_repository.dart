// Author : Shital Gayakwad
// Created Date : 16 Nov 2023
// Description : Calibration Repository

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import 'package:http/http.dart' as http;
import '../../model/quality/calibration_model.dart';

class CalibrationRepository {
  // Measuring instrument list
  Future<List<MeasuringInstruments>> getMeasuringInstruments(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.measuringInstruments, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MeasuringInstruments.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

// Instrument type list
  Future<List<InstrumentsTypeData>> getInstrumentTypes(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.instrumentTypeData, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => InstrumentsTypeData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

// Register instrument type
  Future<String> registerInstrumentType(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerInstrumentType, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

// Delete instrument type
  Future<String> deleteInstrumentType(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.deleteInstrumentType, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Register instrument
  Future<String> registerInstument(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerInstruments, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

// Register measuring instrument in pd_product
  Future<String> registerProduct(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.registerProduct, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          http.Response newResponse = await API()
              .postApiResponse(AppUrl.instrumentReturnId, token, payload);
          final data = jsonDecode(newResponse.body);
          return data[0]['id'];
        } else {
          return response.body.toString();
        }
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Get all instruments from measuring instruments table
  Future<List<AllInstrumentsData>> getAllInstruments(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.getAllInstruments, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AllInstrumentsData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

// Card number
  Future<String> generateCardNumber(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.generateCardNumber, token, payload);
        final data = jsonDecode(response.body);
        return data[0]['incremented_cardnumber'].toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Frequency
  Future<List<Frequency>> frequency({required String token}) async {
    try {
      http.Response response = await API().getApiResponse(AppUrl.frequency, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => Frequency.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Purchase order
  Future<List<InstrumentsPurchaseOrder>> purchaseOrder(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.purchaseOrder, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => InstrumentsPurchaseOrder.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Instrument schedule registration
  Future<String> instrumentScheduleRegistration(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.instrumentScheduleRegistration, token, payload);
        return response.body.toString();
      } else {
        return '';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Register certificates
  Future<String> instrumentsCertificatesRegistration(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerCertificates, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Certificate reference
  Future<String> certificateReference(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.certificateReference, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Current day records
  Future<List<CurrentDayInstrumentsRegistered>> currentDayRecords(
      {required String token}) async {
    try {
      http.Response response = await API().getApiResponse(AppUrl.currentDay, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => CurrentDayInstrumentsRegistered.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get certificate
  Future<String> getCertificate(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.getCertificates, token, payload);

        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Calibration status
  Future<List<CalibrationStatusModel>> calibrationStatus(
      {required String token,
      required int range,
      required String searchString}) async {
    try {
      http.Response response = await API().getApiResponse(
          '${AppUrl.calibrationStatus}?range=$range&searchString=$searchString',
          {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      final data = jsonDecode(response.body);
      List<dynamic> result = data['result'];
      return result.map((e) => CalibrationStatusModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Mail adresses
  Future<List<MailAddress>> emailAddresses(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.emailAddresses, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MailAddress.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Send mail for order instruments
  Future<String> sendInstrumentOrder(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.sendInstrumentOrder, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Measuring range list
  Future<List<InstrumentMeasuringRanges>> measuringrangeList(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.measuringrangeList, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => InstrumentMeasuringRanges.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // One product data
  Future<List<OneProduct>> oneproductData(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      http.Response response =
          await API().postApiResponse(AppUrl.oneProduct, token, payload);
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => OneProduct.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // All instrument orders
  Future<List<AllInstrumentOrdersModel>> allInstrumentOrders(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.allInstrumentOrders, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AllInstrumentOrdersModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

// calibration history registration
  Future<String> calibrationHistoryRegistration(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.calibrationHistoryRegistration, token, payload);

        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

// Send instrument for calibration
  Future<String> sendInstrumentForCalibration(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().putApiResponse(
            AppUrl.sendInstrumentForCalibration, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Outward instruments
  Future<List<OutsourcedInstrumentsModel>> outwardInstruments(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.outwardInstruments, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => OutsourcedInstrumentsModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Outsource workorder challan generate
  Future<dynamic> generateChallan(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.challanWorkorder, token, payload);
        final data = jsonDecode(response.body);
        return data;
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Gave challan reference to outward instruments
  Future<String> challanReference(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().putApiResponse(AppUrl.challanReference, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Inward instruments
  Future<List<OutsourcedInstrumentsModel>> inwardInstruments(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.inwardInstruments, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => OutsourcedInstrumentsModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Inward spacific instrument
  Future<String> inwardSpacificInstrument(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .putApiResponse(AppUrl.inwardSpacificInstrument, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // All work orders of instrument calibration
  Future<List<OutsorceWorkordersModel>> allWorkordersOfInstrumentCalibration(
      {required String token}) async {
    try {
      http.Response response = await API().getApiResponse(
          AppUrl.allOutsourcedInstrumentsForCalibrationWorkorders, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => OutsorceWorkordersModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // One challan data
  Future<List<OutsourcedInstrumentsModel>> oneChallanData(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.oneChallanData, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => OutsourcedInstrumentsModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Spacific instrument card number
  Future<List<InstrumentsCardModel>> cardNumbers(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.allCardNumbers, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => InstrumentsCardModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Searched instruments data
  Future<List<CalibrationHistoryModel>> searchedInstrument(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.searchedInstrument, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CalibrationHistoryModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CalibrationHistoryModel>> oneInstrumentHistory(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.oneInstrumentHistory, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CalibrationHistoryModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

// Reject instrument
  Future<String> rejectInstrument(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().putApiResponse(AppUrl.rejectInstrument, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Add rejected instrument to history
  Future<String> addrejectedInstrumentToHistory(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.addRejectedInstrumentToHistory, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Instrument rejection reasons
  Future<List<InstrumentRejectionReasons>> instrumentRejectionReasons(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.instrumentRejectionReasons, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => InstrumentRejectionReasons.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Rejected instruments data to fill rejection against
  Future<List<RejectedInstrumentsNewOrderDataModel>>
      rejectedInstrumentsDataForNewInstrumentOrder(
          {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.rejectedInstrumentsdata, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => RejectedInstrumentsNewOrderDataModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

// Get one order data
  Future<List<OneInstrumentOrder>> getOneOrderData(
      {required String token, required String id}) async {
    try {
      http.Response response =
          await API().getApiResponse('${AppUrl.getOneOrder}?params=$id', {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => OneInstrumentOrder.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Register manufacturer
  Future<String> registerManufacturer(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.registerManufacturer, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Manufacturer data list
  Future<List<ManufacturerData>> getManufacturerData(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.manufacturerData, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ManufacturerData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

// Delete manufacturer
  Future<String> deleteManufacturer(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.deleteManufacturer, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Stored instruments
  Future<List<StoredInstrumentsModel>> storedInstruments(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.storedInstrumentsData, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => StoredInstrumentsModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Cancel calibration
  Future<String> cancelCalibration(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.cancelCalibration, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Restore stored instruments
  Future<String> restoreStoredInstruments(
      {required String token, required Map<String, String> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API().deleteApiResponse(
            url: AppUrl.restoreStoredInstrument,
            token: token,
            payload: payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Rejected instruments
  Future<List<RejectedInstrumentsModel>> rejectedInstruments(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.rejectedInstrument, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RejectedInstrumentsModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Outsource instruments
  Future<String> issueAndReclaimInstruments(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .putApiResponse(AppUrl.issueAndReclaimInstruments, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Available instruments
  Future<List<AvailableInstrumentsModel>> availableInstrumentsData(
      {required String token}) async {
    try {
      http.Response response =
          await API().getApiResponse(AppUrl.availableInstrumentsDataUrl, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AvailableInstrumentsModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // All work orders of instrument calibration for use
  Future<List<OutsorceWorkordersModel>>
      allWorkordersOfInstrumentOutsourceForUse({required String token}) async {
    try {
      http.Response response = await API()
          .getApiResponse(AppUrl.allWorkordersOfInstrumentOutsourceForUse, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => OutsorceWorkordersModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Reclaim instruments list data
  Future<List<ReclaimOutsourcedInstrumentsModel>> reclaimInstrumentsDataList(
      {required String token}) async {
    try {
      http.Response response = await API()
          .getApiResponse(AppUrl.reclaimOutsourcedInstrumentsDataListUrl, {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => ReclaimOutsourcedInstrumentsModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Instrument outsource history by contractor
  Future<List<InstrumentOutsourceHistoryBySubcontractorModel>>
      instrumentOutsourceHistoryByContractor(
          {required String token, required String vendorId}) async {
    try {
      http.Response response = await API().getApiResponse(
          '${AppUrl.instrumentOutsourceHistoryByContactorStateUrl}?vendorId=$vendorId',
          {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
              (e) => InstrumentOutsourceHistoryBySubcontractorModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
