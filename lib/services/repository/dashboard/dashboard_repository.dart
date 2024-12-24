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

  static Future<List<MachineSocketIDData>> getmachineSocketmachineID() async {
    try {
      final response = await http.get(Uri.parse(allmachinesocketID));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        List<MachineSocketIDData> machineDataList = jsonResponse
            .map((data) => MachineSocketIDData.fromJson(data))
            .toList();

        return machineDataList; // Return the list of machine data
      } else {
        throw Exception('Failed to get socketID list');
      }
    } catch (e) {
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
      //
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
      //
    }
    return machineValueList
        .map((machine) => MachineAutomaticCheck.fromJson(machine))
        .toList();
  }

  static Future<List<WorkstationStatusModel>> getworkstationlist() async {
    final savedData = await UserData.getUserData();

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
      //
    }

    return workstationstatsList
        .map((e) => WorkstationStatusModel.fromJson(e))
        .toList();
  }

  static Future<List<Map<String, String>>> getAutomaticWorkcentreList() async {
    final savedData = await UserData.getUserData();
    List<Map<String, String>> workcentreList = [];

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${savedData['token'].toString()}',
      };

      var response = await API()
          .getApiResponse(AppUrl.getAutomaticworkcentreList, headers);

      if (response.statusCode == 200) {
        List<dynamic> decodedData = jsonDecode(response.body);
        workcentreList = decodedData
            .map((item) {
              final mapItem = item as Map<String, dynamic>;
              return {
                'wr_workcentre_id':
                    mapItem['wr_workcentre_id']?.toString() ?? '',
                'code': mapItem['code']?.toString().trim() ?? ''
              };
            })
            .where((item) => item.isNotEmpty)
            .toList();
      } else {
        //
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
      //
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
          List<dynamic> data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            monthEnergy =
                double.tryParse(data[0]['total_energy_consumption']) ?? 0.0;
          }
        } else {}
      }
    } catch (e) {
      //
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

      String token = await UserData.authorizeToken();

      if (payload.isNotEmpty) {
        var response = await API()
            .postApiResponse(AppUrl.industry4workstationtagID, token, payload);

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
            double stateName = double.parse(item['value'].toString());
            updatedFeedData.add(FeedData(timestamp, stateName));
          }
        }
      } else {
        //
      }
    } catch (e) {
      //
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

        return ProductionUtilizationData(
          production: sumProduction,
          oee: averageOEE,
          productionTime: sumProductionTime,
          idleTime: sumIdleTime,
          machineON: summachineOn,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
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
          //
        }
      } else {
        //
      }
    } catch (e) {
      //
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
          DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(item['ts']);

          double currentR = double.parse(item['value']['currentR'].toString());
          double currentY = double.parse(item['value']['currentY'].toString());
          double currentB = double.parse(item['value']['currentB'].toString());
          double currentTotal =
              double.parse(item['value']['currentTotal'].toString());

          updatedcurrentData.add(MachineCurrentData(
              timestamp, currentTotal, currentR, currentY, currentB));
        }
      } else {
        //
      }
    } catch (e) {
      //
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
        //
      }
    } catch (e) {
      //
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
            double stateName = double.parse(item['value'].toString());
            updatedFeedData.add(FeedData(timestamp, stateName));
          }
        }
      } else {
        //
      }
    } catch (e) {
      //
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
          //
        }
      } else {
        //
      }
    } catch (e) {
      //
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

        return ProductionUtilizationData(
          production: sumProduction,
          oee: averageOEE,
          productionTime: sumProductionTime,
          idleTime: sumIdleTime,
          machineON: summachineOn,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
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
          DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(item['ts']);

          double currentR = double.parse(item['value']['currentR'].toString());
          double currentY = double.parse(item['value']['currentY'].toString());
          double currentB = double.parse(item['value']['currentB'].toString());
          double currentTotal =
              double.parse(item['value']['currentTotal'].toString());

          updatedcurrentData.add(MachineCurrentData(
              timestamp, currentTotal, currentR, currentY, currentB));
        }
      } else {
        //
      }
    } catch (e) {
      //
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
        //
      }
    } catch (e) {
      //
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
        "machineName": machinename,
        "startDate": starttime,
        "endDate": endtime,
        "parameter": "CycleStatus"
      };
      String payloadJson = jsonEncode(payload);

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
    Map<String, double> efficiencyMap = {};

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

        if (jsonResponse.containsKey('error')) {
          continue;
        }

        List<dynamic> dataList = jsonResponse['data'];

        int sumProduction = 0;
        int summachineOn = 0;

        for (var entry in dataList) {
          int production1 = entry['productionTime'] ?? 0;
          int machineon1 = entry['machineON'] ?? 0;

          sumProduction += production1;
          summachineOn += machineon1;
        }

        double productiontime = sumProduction.toDouble();
        double machineon = summachineOn.toDouble();

        double efficiency =
            (machineon > 0) ? (productiontime / machineon) * 100 : 0.0;

        efficiency = double.parse(efficiency.toStringAsFixed(2));

        efficiencyMap[machine] = efficiency;
      } else {
        continue;
      }
    }

    List<EfficiencyData> allData = [];
    efficiencyMap.forEach((machine, efficiency) {
      String formattedMachineName =
          machine.replaceAll(RegExp(r'(CNC-|VMC-|VMC)\s*'), '').trim();

      Color color = Colors.blue;

      allData.add(EfficiencyData(
        formattedMachineName,
        efficiency,
        color,
      ));
    });

    return allData;
  }
}

List<FactoryOEEData> calculateFactoryOEE(
    List<MachinenameAndData> organizedData) {
  Map<String, List<double>> oeeByEndTime = {};

  for (var machine in organizedData) {
    for (var metric in machine.metrics) {
      String endTime = metric.endTime;
      double oee = metric.oee;

      if (oeeByEndTime.containsKey(endTime)) {
        oeeByEndTime[endTime]?.add(oee);
      } else {
        oeeByEndTime[endTime] = [oee];
      }
    }
  }

  List<FactoryOEEData> centralizedOEEData = [];

  for (var entry in oeeByEndTime.entries) {
    String endTime = entry.key;
    List<double> oees = entry.value;

    double averageOEE = oees.reduce((a, b) => a + b) / oees.length;

    centralizedOEEData.add(FactoryOEEData(endTime: endTime, oee: averageOEE));
  }

  return centralizedOEEData;
}

Map<String, double> calculateAverageOEEofCenters(
    List<MachinenameAndData> organizedData) {
  Map<String, List<num>> oeeData = {};

  for (var machine in organizedData) {
    String machineName = machine.machineName;
    if (!oeeData.containsKey(machineName)) {
      oeeData[machineName] = [0.0, 0];
    }

    for (var metric in machine.metrics) {
      oeeData[machineName]![0] += metric.oee;
      oeeData[machineName]![1] = oeeData[machineName]![1] + 1;
    }
  }

  Map<String, double> averageOEEByMachine = {};
  oeeData.forEach((machineName, data) {
    double sumOEE = data[0].toDouble();
    int count = data[1].toInt();
    averageOEEByMachine[machineName] = count > 0 ? (sumOEE / count) : 0;
  });

  return averageOEEByMachine;
}

List<FactoryEfficency> calculateFactoryEfficiency(
    List<MachinenameAndData> organizedData) {
  Map<DateTime, List<double>> efficiencyMap = {};

  for (var machine in organizedData) {
    for (var metric in machine.metrics) {
      DateTime endTime = DateTime.parse(metric.endTime);

      if (metric.machineon > 0) {
        double efficiency = (metric.productionTime / metric.machineon) * 100;

        if (!efficiencyMap.containsKey(endTime)) {
          efficiencyMap[endTime] = [];
        }
        efficiencyMap[endTime]!.add(efficiency);
      } else {
        efficiencyMap.putIfAbsent(endTime, () => []).add(0);
      }
    }
  }

  List<FactoryEfficency> factoryEfficiencyDataList = [];
  efficiencyMap.forEach((endTime, efficiencies) {
    double averageEfficiency =
        efficiencies.reduce((a, b) => a + b) / efficiencies.length;

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
  Map<String, double> centreWiseEfficiencyMap = {};

  for (var machine in organizedData) {
    String machineName = machine.machineName;
    List<MachineMetricsData> metrics = machine.metrics;
    double totalEfficiency = 0.0;
    int count = 0;

    for (var metric in metrics) {
      if (metric.machineon > 0) {
        double efficiency = (metric.productionTime / metric.machineon) * 100;
        totalEfficiency += efficiency;
        count++;
      }
    }

    double averageEfficiency = count > 0 ? (totalEfficiency / count) : 0.0;
    centreWiseEfficiencyMap[machineName] = averageEfficiency;
  }

  return centreWiseEfficiencyMap;
}
