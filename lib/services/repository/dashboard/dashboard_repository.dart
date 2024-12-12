// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/dashboard/dashboard_model.dart';
import '../../session/user_login.dart';

class DashboardRepository {
  static var autobitsurl = 'http://103.173.51.130:4040/api/datasets/json';
  static var machinewiseurlfeeddata = 'http://192.168.0.55:3213/v1/fanuc/feed';
  static var machinewiseurlcyclerun = 'http://192.168.0.55:3213/v1/fanuc/run';
  static var machinewiseParameterData =
      'http://103.173.51.130:9003/v1/erp/datta/parameter-data';
  static var machineUtilization =
      'http://103.173.51.130:9003/v1/erp/datta/utilization';
  static var machinewisechartdata =
      'http://103.173.51.130:9003/v1/erp/datta/chart-data';
  static var machinewiseMachineCentreID =
      'http://103.173.51.130:9003/v1/cells/findAllCells';
  static var centrecellUtilizationURL =
      'http://103.173.51.130:9003/v1/erp/datta/cell-utilization';
  static var allmachinesocketID =
      'http://103.173.51.130:9003/v1/machines/findAllMachines';

  // static Future<List<dynamic>> getmachineSocketmachineID() async {
  static Future<List<MachineSocketIDData>> getmachineSocketmachineID() async {
    // const String allmachinesocketID = allmachinesocketID; // Replace with your URL

    try {
      final response = await http.get(Uri.parse(allmachinesocketID));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        // Extract machineName and _id into a list of MachineData objects
        List<MachineSocketIDData> machineDataList = jsonResponse
            .map((data) => MachineSocketIDData.fromJson(data))
            .toList();

        return machineDataList; // Return the list of machine data
      } else {
        throw Exception('Failed to get socketID list');
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Future userModules(
      {required String username,
      required String password,
      required String token}) async {
    try {
      if (username != '') {
        Map<String, dynamic> payload = {
          'username': username.toString().trim(),
          'password': password.toString().trim()
        };
        if (payload.isNotEmpty) {
          http.Response? response =
              await API().postApiResponse(AppUrl.userModuleUrl, token, payload);
          if (response.body.toString() == 'Server unreachable') {
            return 'Server unreachable';
          } else {
            List<dynamic> folderList = jsonDecode(response.body);
            return folderList
                .map((folders) => UserModule.fromJson(folders))
                .toList();
          }
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  Future programs(
      {required String token,
      required String folderId,
      required String username,
      required String password}) async {
    try {
      List<Programs> list = [];
      Map<String, dynamic> payload = {
        'folder_id': folderId == ''
            ? folderId == 'All'
                ? 'All'
                : '5c06859ea07643258cbe9924f6b39b55' //PPC folder id from data.acl_folder
            : folderId.toString().trim(),
        'username': username.toString(),
        'password': password.toString()
      };
      if (payload.isNotEmpty) {
        http.Response? response =
            await API().postApiResponse(AppUrl.programs, token, payload);

        if (response.body.toString() == 'Server unreachable') {
          return list;
        } else if (response.body.toString() ==
            'Client has encountered a connection error and is not queryable') {
          return list;
        } else {
          List<dynamic> programList = jsonDecode(response.body);
          return programList
              .map((programs) => Programs.fromJson(programs))
              .toList();
        }
      }
    } catch (e) {
      //
    }
  }

  Future<List<MachineAutomaticCheck>> getDashboardBody(
      {required String workcentreid, required String workstationid}) async {
    Map<String, dynamic> payload = {};
    List<dynamic> machineValueList = [];
    try {
      payload = {
        'workstation_id': workstationid,
        'workcentre_id': workcentreid
      };
      //Token
      String token = await UserData.authorizeToken();
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.knowMachineAutomaticOrManual, token, payload);
        machineValueList = jsonDecode(response.body);
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return machineValueList
        .map((machine) => MachineAutomaticCheck.fromJson(machine))
        .toList();
  }

  static Future<List<WorkstationStatusModel>> getworkstationlist() async {
    final savedData = await UserData.getUserData();
    // debugPrint(savedData['token'].toString());
    // Map<String, dynamic> payload = {};
    List<dynamic> workstationstatsList = [];
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${savedData['token'].toString()}',
      };
      if (headers.isNotEmpty) {
        var response =
            await API().getApiResponse(AppUrl.getworkstationlist, headers);
        workstationstatsList = jsonDecode(response.body);
      }
    } catch (e) {
      //debugPrint(e.toString());
    }

    return workstationstatsList
        .map((e) => WorkstationStatusModel.fromJson(e))
        .toList();
  }

  static Future<List<Map<String, String>>> getAutomaticWorkcentreList() async {
    final savedData = await UserData.getUserData();
    List<Map<String, String>> workcentreList =
        []; // List to hold the formatted data

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${savedData['token'].toString()}',
      };

      var response = await API()
          .getApiResponse(AppUrl.getAutomaticworkcentreList, headers);

      // Ensure the response is successful
      if (response.statusCode == 200) {
        List<dynamic> decodedData = jsonDecode(response.body);
        workcentreList = decodedData
            .map((item) {
              final mapItem =
                  item as Map<String, dynamic>; // Cast each item properly
              return {
                'wr_workcentre_id':
                    mapItem['wr_workcentre_id']?.toString() ?? '',
                'code': mapItem['code']?.toString().trim() ??
                    '' // Trim the 'code' value
              };
            })
            .where((item) => item.isNotEmpty)
            .toList(); // Filter out any empty maps
      } else {
        // debugPrint('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }

    return workcentreList;
  }

//---------------------------------------------------------------------//

  static Future<List<MachinwiseCellID>> machinewiseCentreCellList() async {
    List<MachinwiseCellID> dataList2 = [];
    try {
      final response = await http.get(Uri.parse(machinewiseMachineCentreID));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        dataList2 = jsonResponse
            .map((data) => MachinwiseCellID.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load machine list');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return dataList2;
  }

  static Future<List<CellutilizationData>> fetchUtilizationMachineData(
      List<MachinwiseCellID> machines, String starttime, String endtime) async {
    List<CellutilizationData> allData = [];

    for (var machine in machines) {
      final response = await http.post(
        Uri.parse(centrecellUtilizationURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "startDate": starttime,
          "endDate": endtime,
          "cellId": machine.id,
          "interval": "1"
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> dataList = jsonResponse['data'];

        allData.add(CellutilizationData(name: machine.name, data: dataList));
      } else {
        throw Exception('Failed to load machine data');
      }
    }

    return allData;
  }

  static Future<double> machineMonthlyEnergyData(
      {required String yearmm}) async {
    Map<String, dynamic> payload = {};
    double monthEnergy = 0;
    try {
      payload = {
        'yearrmonth': yearmm,
      };
      //Token
      String token = await UserData.authorizeToken();
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.machineMonthlyEnergyconsumption, token, payload);

        if (response.statusCode == 200) {
          // Parse the response body
          List<dynamic> data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            // Extract the total_energy_consumption and convert to double
            // debugPrint(data.toString());
            monthEnergy =
                double.tryParse(data[0]['total_energy_consumption']) ?? 0.0;
          }
        } else {
          // Handle error response if needed
          // debugPrint("Error: ${response.statusCode} - ${response.body}");
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return monthEnergy;
  }

  static Future<List<Industry4WorkstationTagId>> industry4WorkstationtagID(
      {required String workstationid}) async {
    Map<String, dynamic> payload = {};
    List<Industry4WorkstationTagId> workstationTagid = [];
    try {
      payload = {
        'workstation_id': workstationid,
      };

      // debugPrint(payload.toString());

      String token = await UserData.authorizeToken();

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.industry4workstationtagID, token, payload);

        // debugPrint(response.body.toString());
        if (response.body.toString() == '[]') {
          return workstationTagid = [];
        } else {
          workstationTagid = [];
          List<dynamic> list = jsonDecode(response.body);
          workstationTagid = list
              .map((item) => Industry4WorkstationTagId.fromJson(item))
              .toList();
          return workstationTagid;
        }
      }
    } catch (e) {
      return workstationTagid = [];
    }
    return workstationTagid;
  }

  static Future<List<Workstationtotalcurrenttagid>>
      getworkstationTotalCurrentTagid({required String workstationid}) async {
    Map<String, dynamic> payload = {};

    List<Workstationtotalcurrenttagid> workstationcurrentTagid = [];
    try {
      payload = {
        'workstation_id': workstationid,
      };

      String token = await UserData.authorizeToken();
      if (payload.isNotEmpty) {
        var response = await API().postApiResponse(
            AppUrl.getworkstationTotalCurrentTagid, token, payload);

        if (response.body.toString() == '[]') {
          return workstationcurrentTagid = [];
        } else {
          workstationcurrentTagid = [];
          List<dynamic> list = jsonDecode(response.body);
          workstationcurrentTagid = list
              .map((item) => Workstationtotalcurrenttagid.fromJson(item))
              .toList();
          return workstationcurrentTagid;
        }
      }
    } catch (e) {
      return workstationcurrentTagid = [];
    }
    return workstationcurrentTagid;
  }

  static Future<List<FeedData>> machinewiseFeedRate(
      {required String machinename,
      required String formattedDate,
      required String starttime,
      required String endtime}) async {
    final List<FeedData> feedData = [];
    List<FeedData> updatedFeedData = List.from(feedData);
    // List<dynamic> cncenergy = [];
    try {
      var url = Uri.parse(machinewisechartdata);

      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": "$formattedDate $starttime",
        "endDate": "$formattedDate $endtime",
        "parameter": "Feed"
      };
      String payloadJson = jsonEncode(payload);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final fr = jsonDecode(response.body);
        final frdata = fr['data'];

        for (var item in frdata) {
          if (item['value'] != 898989) {
            DateTime timestamp =
                DateTime.fromMillisecondsSinceEpoch(item['ts']).toLocal();
            double stateName = double.parse(
                item['value'].toString()); // Assuming state_name is a double
            updatedFeedData.add(FeedData(timestamp, stateName));
          }
        }

        // for (var data in updatedFeedData) {
        //   debugPrint('DateTime: ${data.x} | State Name: ${data.y}');
        // }
      } else {
        // debugPrint(response.statusCode.toString());
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return updatedFeedData;
  }

  static Future<ProductionUtilizationData?> machinewiseUtilization({
    required String machinename,
    required String formattedDate,
    required String starttime,
    required String endtime,
  }) async {
    try {
      var url = Uri.parse(machineUtilization);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": "$formattedDate $starttime",
        "endDate": "$formattedDate $endtime",
        "interval": "1"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonDecoded = jsonDecode(response.body);

        final List<dynamic> dataList = jsonDecoded['data'];

        int dataLength = dataList.length;
        int sumProductionTime = 0;
        double sumOEE = 0.0;
        int sumIdleTime = 0;
        int sumProduction = 0;
        int summachineOn = 0;

        // debugPrint('Data length: $dataLength');

        for (var element in dataList) {
          int productionTime = element['productionTime'] ?? 0;
          double oee = (element['OEE'] ?? 0.0).toDouble();
          int idleTime = element['idleTime'] ?? 0;
          int production = element['production'] ?? 0;
          int machineon = element['machineON'] ?? 0;

          sumProductionTime += productionTime;
          sumOEE += oee;
          sumIdleTime += idleTime;
          sumProduction += production;
          summachineOn += machineon;
        }

        double averageOEE = sumOEE / dataLength;

        // debugPrint("Machine WISe [[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]");
        // debugPrint('Sum of Production: $sumProductionTime');
        // debugPrint('Sum of machineoN: $summachineOn');
        return ProductionUtilizationData(
          production: sumProduction,
          oee: averageOEE,
          productionTime: sumProductionTime,
          idleTime: sumIdleTime,
          machineON: summachineOn,
        );
      } else {
        // debugPrint('HTTP error: ${response.statusCode}');
        return null; // Return null if the request failed
      }
    } catch (e) {
      // debugPrint('Exception: $e');
      return null; // Return null in case of an exception
    }
  }

  static Future<double> machinewiseeenergy(
      {required String machinename,
      required String formattedDate,
      required String starttime,
      required String endtime}) async {
    double energy = 0;

    try {
      var url = Uri.parse(machinewiseParameterData);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": "$formattedDate $starttime",
        "endDate": "$formattedDate $endtime",
        "parameter": "EnergyData"
      };
      String payloadJson = jsonEncode(payload);
      //  debugPrint(payloadJson.toString());

      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final dataArray = responseData['data'];

        if (dataArray != null && dataArray is List && dataArray.isNotEmpty) {
          double firstValue = dataArray[0]['value'].toDouble();
          double lastValue =
              dataArray[dataArray.length - 1]['value'].toDouble();
          energy = lastValue - firstValue;
        } else {
          // debugPrint('ENergy data is empty or invalid');
        }
      } else {
        // debugPrint('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // debugPrint('Exception: $e');
    }
    return energy;
  }

  static Future<List<MachineCurrentData>> machineCurrentData({
    required String machinename,
    required String formattedDate,
    required String starttime,
    required String endtime,
  }) async {
    final List<MachineCurrentData> currentData = [];
    List<MachineCurrentData> updatedcurrentData = List.from(currentData);

    try {
      var url = Uri.parse(machinewiseParameterData);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": "$formattedDate $starttime",
        "endDate": "$formattedDate $endtime",
        "parameter": "MachineCurrentData"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final fr = jsonDecode(response.body);
        final frdata = fr['data'];

        // debugPrint(frdata.toString());
        for (var item in frdata) {
          DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(item['ts']);

          double currentR = double.parse(item['value']['currentR'].toString());
          double currentY = double.parse(item['value']['currentY'].toString());
          double currentB = double.parse(item['value']['currentB'].toString());
          double currentTotal =
              double.parse(item['value']['currentTotal'].toString());
          // (item['value']['currentTotal'] as num).toDouble();
          // debugPrint(item['value']['currentTotal'].toString());
          // DateTime timestamp =
          // DateTime.fromMillisecondsSinceEpoch(item['ts']);
          // DateTime formattedTime =
          //     '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}'
          //         as DateTime;
          // double stateName = double.parse(
          //     item['value'].toString());

          updatedcurrentData.add(MachineCurrentData(
              timestamp, currentTotal, currentR, currentY, currentB));

          // for (var element in currentData) {
          //   debugPrint(element.currentTotal.toString());
          //   debugPrint(element.timestamp.toString());
          // }
        }
      } else {
        // Handle error here if needed
      }
    } catch (e) {
      // Handle exception here if needed
    }
    return updatedcurrentData;
  }

  static Future<List<MachineVolatgeData>> machineVoltageData({
    required String machinename,
    required String formattedDate,
    required String starttime,
    required String endtime,
  }) async {
    final List<MachineVolatgeData> voltageData = [];
    List<MachineVolatgeData> updatedVoltageData = List.from(voltageData);

    try {
      var url = Uri.parse(machinewiseParameterData);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": "$formattedDate $starttime",
        "endDate": "$formattedDate $endtime",
        "parameter": "MachineVoltageData"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final volte = jsonDecode(response.body);
        final voltdata = volte['data'];
        for (var item in voltdata) {
          DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(item['ts']);

          double vatotal = double.parse(item['value']['VAtotal'].toString());
          double vllaverage =
              double.parse(item['value']['VLLaverage'].toString());
          double varphase = double.parse(item['value']['VARphase'].toString());
          double vayphase = double.parse(item['value']['VAYphase'].toString());
          double vabphase = double.parse(item['value']['VABphase'].toString());
          updatedVoltageData.add(
            MachineVolatgeData(
                timestamp, vllaverage, varphase, vayphase, vabphase, vatotal),
          );
        }
      } else {
        // Handle error here if needed
      }
    } catch (e) {
      // Handle exception here if needed
    }
    return updatedVoltageData;
  }

  static Future<List<FeedData>> machinewiseFeedRate24hr(
      {required String machinename,
      required String starttime,
      required String endtime}) async {
    final List<FeedData> feedData = [];
    List<FeedData> updatedFeedData = List.from(feedData);
    try {
      var url = Uri.parse(machinewisechartdata);

      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": starttime,
        "endDate": endtime,
        "parameter": "Feed"
      };
      String payloadJson = jsonEncode(payload);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final fr = jsonDecode(response.body);
        final frdata = fr['data'];

        for (var item in frdata) {
          if (item['value'] != 898989) {
            DateTime timestamp =
                DateTime.fromMillisecondsSinceEpoch(item['ts']).toLocal();
            double stateName = double.parse(
                item['value'].toString()); // Assuming state_name is a double
            updatedFeedData.add(FeedData(timestamp, stateName));
          }
        }
      } else {
        // debugPrint(response.statusCode.toString());
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return updatedFeedData;
  }

  static Future<double> machinewiseeenergy24hr(
      {required String machinename,
      required String starttime,
      required String endtime}) async {
    double energy = 0;

    try {
      var url = Uri.parse(machinewiseParameterData);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": starttime,
        "endDate": endtime,
        "parameter": "EnergyData"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson.toString());

      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final dataArray = responseData['data'];

        if (dataArray != null && dataArray is List && dataArray.isNotEmpty) {
          double firstValue = dataArray[0]['value'].toDouble();
          double lastValue =
              dataArray[dataArray.length - 1]['value'].toDouble();
          energy = lastValue - firstValue;
        } else {
          // debugPrint('ENergy data is empty or invalid');
        }
      } else {
        // debugPrint('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // debugPrint('Exception: $e');
    }
    return energy;
  }

  static Future<ProductionUtilizationData?> machinewiseUtilization24hr({
    required String machinename,
    required String starttime,
    required String endtime,
  }) async {
    try {
      var url = Uri.parse(machineUtilization);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": starttime,
        "endDate": endtime,
        "interval": "0.5"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonDecoded = jsonDecode(response.body);

        final List<dynamic> dataList = jsonDecoded['data'];

        int dataLength = dataList.length;
        int sumProductionTime = 0;
        double sumOEE = 0.0;
        int sumIdleTime = 0;
        int sumProduction = 0;
        int summachineOn = 0;

        // debugPrint('Data length: $dataLength');

        for (var element in dataList) {
          // debugPrint(element.toString());
          // debugPrint(element['productionTime'].toString()); // int
          // debugPrint(element['OEE'].toString()); //double
          // debugPrint(element['idleTime'].toString()); //int
          // debugPrint(element['production'].toString()); //int
          // debugPrint("machine --- >${element['machineON']}");
          int productionTime = element['productionTime'] ?? 0;
          double oee = (element['OEE'] ?? 0.0).toDouble();
          int idleTime = element['idleTime'] ?? 0;
          int production = element['production'] ?? 0;
          int machineon = element['machineON'] ?? 0;

          sumProductionTime += productionTime;
          sumOEE += oee;
          sumIdleTime += idleTime;
          sumProduction += production;
          summachineOn += machineon;
        }

        double averageOEE = sumOEE / dataLength;

        // debugPrint('Sum of Production Time: $sumProductionTime');
        // debugPrint('Average OEE: $averageOEE');
        // debugPrint('Sum of Idle Time: $sumIdleTime');
        // debugPrint('Sum of Production: $sumProduction');
        // debugPrint('Sum of machineoN: $summachineOn');
        return ProductionUtilizationData(
          production: sumProduction,
          oee: averageOEE,
          productionTime: sumProductionTime,
          idleTime: sumIdleTime,
          machineON: summachineOn,
        );
      } else {
        // debugPrint('HTTP error: ${response.statusCode}');
        return null; // Return null if the request failed
      }
    } catch (e) {
      // debugPrint('Exception: $e');
      return null; // Return null in case of an exception
    }
  }

  static Future<List<MachineCurrentData>> machineCurrentData24hr({
    required String machinename,
    required String starttime,
    required String endtime,
  }) async {
    final List<MachineCurrentData> currentData = [];
    List<MachineCurrentData> updatedcurrentData = List.from(currentData);

    try {
      var url = Uri.parse(machinewiseParameterData);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": starttime,
        "endDate": endtime,
        "parameter": "MachineCurrentData"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final fr = jsonDecode(response.body);
        final frdata = fr['data'];

        // debugPrint(frdata.toString());
        for (var item in frdata) {
          DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(item['ts']);

          double currentR = double.parse(item['value']['currentR'].toString());
          double currentY = double.parse(item['value']['currentY'].toString());
          double currentB = double.parse(item['value']['currentB'].toString());
          double currentTotal =
              double.parse(item['value']['currentTotal'].toString());
          // (item['value']['currentTotal'] as num).toDouble();
          // debugPrint(item['value']['currentTotal'].toString());
          // DateTime timestamp =
          // DateTime.fromMillisecondsSinceEpoch(item['ts']);
          // DateTime formattedTime =
          //     '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}'
          //         as DateTime;
          // double stateName = double.parse(
          //     item['value'].toString());

          updatedcurrentData.add(MachineCurrentData(
              timestamp, currentTotal, currentR, currentY, currentB));

          // for (var element in currentData) {
          //   debugPrint(element.currentTotal.toString());
          //   debugPrint(element.timestamp.toString());
          // }
        }
      } else {
        // Handle error here if needed
      }
    } catch (e) {
      // Handle exception here if needed
    }
    return updatedcurrentData;
  }

  static Future<List<MachineVolatgeData>> machineVoltageData24hr({
    required String machinename,
    required String starttime,
    required String endtime,
  }) async {
    final List<MachineVolatgeData> voltageData = [];
    List<MachineVolatgeData> updatedVoltageData = List.from(voltageData);

    try {
      var url = Uri.parse(machinewiseParameterData);
      Map<String, dynamic> payload = {
        "machineName": machinename,
        "startDate": starttime,
        "endDate": endtime,
        "parameter": "MachineVoltageData"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson);
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final volte = jsonDecode(response.body);
        final voltdata = volte['data'];
        for (var item in voltdata) {
          DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(item['ts']);

          double vatotal = double.parse(item['value']['VAtotal'].toString());
          double vllaverage =
              double.parse(item['value']['VLLaverage'].toString());
          double varphase = double.parse(item['value']['VARphase'].toString());
          double vayphase = double.parse(item['value']['VAYphase'].toString());
          double vabphase = double.parse(item['value']['VABphase'].toString());
          updatedVoltageData.add(
            MachineVolatgeData(
                timestamp, vllaverage, varphase, vayphase, vabphase, vatotal),
          );
        }
      } else {
        // Handle error here if needed
      }
    } catch (e) {
      // Handle exception here if needed
    }
    return updatedVoltageData;
  }

  static Future<List<ProductionCyclevalue>> machinewisecyclerun(
      {required String machinename,
      required String starttime,
      required String endtime}) async {
    try {
      var url = Uri.parse(machinewisechartdata);

      Map<String, dynamic> payload = {
        "machineName":
            machinename, // CNC-S3 , CNC-S4, VMC-F3, VMC-F4, VMC BFW, VMC AMS, ''ts''
        "startDate": starttime,
        "endDate": endtime,
        "parameter": "CycleStatus"
      };
      String payloadJson = jsonEncode(payload);
      // debugPrint(payloadJson.toString());
      final response = await http.post(
        url,
        body: payloadJson,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body);
      if (data["message"] == "Success") {
        List<dynamic> dataList = data["data"];

        return dataList
            .map((folders) => ProductionCyclevalue.fromJson(folders))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<EfficiencyData>> workstationEfficency(
      List<String> machines, String starttime, String endtime) async {
    // Map to store efficiency for each machine
    Map<String, double> efficiencyMap = {};

    // debugPrint('$starttime   $endtime');
    // debugPrint(machines.toString());
    for (var machine in machines) {
      final response = await http.post(
        Uri.parse(machineUtilization),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "startDate": starttime,
          "endDate": endtime,
          "machineName": machine.trim(),
          "interval": "1"
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if the response contains an error
        if (jsonResponse.containsKey('error')) {
          // debugPrint('Error for machine $machine: ${jsonResponse['error']}');
          continue; // Skip to the next machine
        }

        List<dynamic> dataList = jsonResponse['data'];

        // Initialize sum variables for the current machine
        int sumProduction = 0;
        int summachineOn = 0;

        // Process each data entry in the response
        for (var entry in dataList) {
          // Extract and sum the data fields
          int production1 = entry['productionTime'] ?? 0;
          int machineon1 = entry['machineON'] ?? 0;

          sumProduction += production1;
          summachineOn += machineon1;
        }

        // Calculate efficiency for the machine
        double productiontime = sumProduction.toDouble(); // Convert to hours
        double machineon = summachineOn.toDouble(); // Convert to hours

        double efficiency =
            (machineon > 0) ? (productiontime / machineon) * 100 : 0.0;

        efficiency = double.parse(
            efficiency.toStringAsFixed(2)); // Format to 2 decimal places

        // Store the calculated efficiency in the map
        efficiencyMap[machine] = efficiency;

        // debugPrint("Efficiency for machine $machine: $efficiency");
      } else {
        // Handle HTTP errors
        // debugPrint(
        //     'Failed to load machine data for $machine: HTTP ${response.statusCode}');
        continue; // Skip to the next machine
      }
    }

    // Create EfficiencyData models with the calculated efficiencies
    List<EfficiencyData> allData = [];
    efficiencyMap.forEach((machine, efficiency) {
      // Remove specific substrings like "CNCL" or "VMC" from machine name
      String formattedMachineName =
          machine.replaceAll(RegExp(r'(CNC-|VMC-|VMC)\s*'), '').trim();

      Color color = Colors.blue; // Assign a default color or set dynamically

      allData.add(EfficiencyData(
        formattedMachineName, // x: Formatted machine name
        efficiency, // y: Calculated efficiency
        color, // color: Assigned color
      ));
    });

    return allData;
  }
}

List<FactoryOEEData> calculateFactoryOEE(
    List<MachinenameAndData> organizedData) {
  // A map to group OEEs by their end times
  Map<String, List<double>> oeeByEndTime = {};

  // Group OEEs by end time
  for (var machine in organizedData) {
    for (var metric in machine.metrics) {
      String endTime = metric.endTime;
      double oee = metric.oee;

      // If the endTime key already exists, add the OEE to the list
      if (oeeByEndTime.containsKey(endTime)) {
        oeeByEndTime[endTime]?.add(oee);
      } else {
        // If the endTime key does not exist, create a new list with the OEE
        oeeByEndTime[endTime] = [oee];
      }
    }
  }

  // To store the centralized OEE data
  List<FactoryOEEData> centralizedOEEData = [];

  // Calculate factory OEE for each end time
  for (var entry in oeeByEndTime.entries) {
    String endTime = entry.key;
    List<double> oees = entry.value;

    // Calculate the average OEE
    double averageOEE = oees.reduce((a, b) => a + b) / oees.length;

    // Create a new CentralizedOEEData object and add it to the list
    centralizedOEEData.add(FactoryOEEData(endTime: endTime, oee: averageOEE));

    // debugPrint("123 End Time: $endTime, Average OEE: $averageOEE");
  }

  // Return the list of CentralizedOEEData
  return centralizedOEEData;
}

Map<String, double> calculateAverageOEEofCenters(
    List<MachinenameAndData> organizedData) {
  // A map to store the sum of OEE values and count for each machine
  Map<String, List<num>> oeeData = {};

  for (var machine in organizedData) {
    String machineName = machine.machineName;
    if (!oeeData.containsKey(machineName)) {
      oeeData[machineName] = [
        0.0,
        0
      ]; // Initialize sum (double) and count (int)
    }

    for (var metric in machine.metrics) {
      oeeData[machineName]![0] += metric.oee; // Sum the OEE values
      oeeData[machineName]![1] =
          oeeData[machineName]![1] + 1; // Increment the count
    }
  }

  // Calculate the average OEE for each machine
  Map<String, double> averageOEEByMachine = {};
  oeeData.forEach((machineName, data) {
    double sumOEE = data[0].toDouble(); // Ensure sum is treated as a double
    int count = data[1].toInt(); // Ensure count is treated as an integer
    averageOEEByMachine[machineName] = count > 0 ? (sumOEE / count) : 0;
  });

  return averageOEEByMachine;
}

List<FactoryEfficency> calculateFactoryEfficiency(
    List<MachinenameAndData> organizedData) {
  // A map to store efficiency data for each unique endTime
  Map<DateTime, List<double>> efficiencyMap = {};

  // Iterate over each machine's data
  for (var machine in organizedData) {
    for (var metric in machine.metrics) {
      // Convert the endTime from String to DateTime
      DateTime endTime = DateTime.parse(metric.endTime);

      // Avoid division by zero
      if (metric.machineon > 0) {
        double efficiency = (metric.productionTime / metric.machineon) * 100;

        // Add the efficiency value to the map using endTime as the key
        if (!efficiencyMap.containsKey(endTime)) {
          efficiencyMap[endTime] = [];
        }
        efficiencyMap[endTime]!.add(efficiency);
      } else {
        // Handle the case where machineon is zero, if necessary
        efficiencyMap
            .putIfAbsent(endTime, () => [])
            .add(0); // Add 0 efficiency when machineon is 0
      }
    }
  }
  // Calculate average efficiency for each endTime
  List<FactoryEfficency> factoryEfficiencyDataList = [];
  efficiencyMap.forEach((endTime, efficiencies) {
    double averageEfficiency =
        efficiencies.reduce((a, b) => a + b) / efficiencies.length;

    // Create a new FactoryEfficency object with the average efficiency
    factoryEfficiencyDataList.add(
      FactoryEfficency(
        endTime: endTime,
        efficency: averageEfficiency,
      ),
    );
  });

  return factoryEfficiencyDataList;
}

Map<String, double> calculateCentreWiseEfficiency(
    List<MachinenameAndData> organizedData) {
  // A map to store the average efficiency for each machine
  Map<String, double> centreWiseEfficiencyMap = {};

  // Iterate over each machine's data
  for (var machine in organizedData) {
    String machineName = machine.machineName;
    List<MachineMetricsData> metrics = machine.metrics;
    double totalEfficiency = 0.0;
    int count = 0;

    // Calculate efficiency for each metric of the machine
    for (var metric in metrics) {
      // Avoid division by zero
      if (metric.machineon > 0) {
        double efficiency = (metric.productionTime / metric.machineon) * 100;
        totalEfficiency += efficiency;
        count++;
      }
    }

    // Calculate the average efficiency for the machine
    double averageEfficiency = count > 0 ? (totalEfficiency / count) : 0.0;
    centreWiseEfficiencyMap[machineName] = averageEfficiency;
  }

  return centreWiseEfficiencyMap;
}
