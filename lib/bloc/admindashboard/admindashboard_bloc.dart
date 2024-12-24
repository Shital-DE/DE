// ignore_for_file: prefer_interpolation_to_compose_strings, unused_element

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/model/dashboard/dashboard_model.dart';
import '../../services/repository/dashboard/dashboard_repository.dart';
import 'admindashboard_event.dart';
import 'admindashboard_state.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

class ADBBloc extends Bloc<ADBEvent, ADBState> {
  final BuildContext context;
  ADBBloc(this.context) : super(ADBinitialState()) {
    on<ADBEvent>((event, emit) async {
      List<WorkstationStatusModel> workstationstatuslist = [];

      List<Map<String, String>> machinesocketidList = [];

      double shopefficiency = 0;
      double machineMonthwiseEnergyConsumption = 0;
      String onlynowtime = '', effiStarttime = '', effiEndtime = '';
      List wc = [];
      List<CentrewiseenergyData> centrewiseenergyData = [];

      var today = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy').format(today);
      String yearrmonth = DateFormat('yyyy-MM-dd').format(today);

      DateTime nowcurrentTime = DateTime.now().toLocal();

      onlynowtime = DateFormat('HH:mm:ss').format(nowcurrentTime);

      effiStarttime = "$formattedDate 00:00:01'";
      effiEndtime = "$formattedDate $onlynowtime";
      List<MachineSocketIDData> machineSocketID =
          await DashboardRepository.getmachineSocketmachineID();
      for (var element in machineSocketID) {
        machinesocketidList.add({
          'machineName': element.machineName,
          'id': element.id,
        });
      }

      machineMonthwiseEnergyConsumption =
          await DashboardRepository.machineMonthlyEnergyData(
              yearmm: yearrmonth);

      workstationstatuslist = await DashboardRepository.getworkstationlist();

      wc = await DashboardRepository.getAutomaticWorkcentreList();
      Map<String, Map<String, List<String>>> machinesByWorkcentreIdAndCode = {};

      for (var element in wc) {
        String workcentreId = element['wr_workcentre_id'] ?? '';
        String code = element['code'] ?? '';

        List<String> matchingMachines = workstationstatuslist
            .where((workstation) => workstation.wrWorkcentreId == workcentreId)
            .map((workstation) => workstation.machinename ?? '')
            .where((name) => name.isNotEmpty)
            .toList();

        if (matchingMachines.isNotEmpty) {
          machinesByWorkcentreIdAndCode[workcentreId] = {
            code: matchingMachines,
          };
        }
      }

      // Map to hold the total energy for each workcentre ID and code
      Map<String, double> totalEnergyByWorkcentreIdAndCode = {};
      double totalenergy = 0.0;

      for (var entry in machinesByWorkcentreIdAndCode.entries) {
        String workcentreId = entry.key;

        for (var codeEntry in entry.value.entries) {
          String code = codeEntry.key;
          List<String> machines = codeEntry.value;
          double totalEnergy = 0.0;

          for (String machinename in machines) {
            double machineenergy = await DashboardRepository.machinewiseeenergy(
              machinename: machinename.toString().trim(),
              formattedDate: formattedDate,
              starttime: '00:00:01',
              endtime: onlynowtime,
            );

            double value = machineenergy / 1000;
            machineenergy = ((value * 100).truncateToDouble()) / 100;
            totalEnergy += machineenergy;
          }
          totalEnergyByWorkcentreIdAndCode['$workcentreId, Code: $code'] =
              totalEnergy;
          totalenergy =
              double.parse((totalenergy + totalEnergy).toStringAsFixed(2));
        }
      }

      Map<String, CentrewiseenergyData> centrewiseEnergyMap = {
        'CNCL': centrewiseenergyData.firstWhere(
          (data) => data.x == 'CNCL',
          orElse: () => CentrewiseenergyData(
            'CNCL',
            0,
            const Color.fromARGB(255, 255, 179, 186), // Soft Pink
          ),
        ),
        'VMC': centrewiseenergyData.firstWhere(
          (data) => data.x == 'VMC',
          orElse: () => CentrewiseenergyData(
            'VMC',
            0,
            const Color.fromARGB(255, 255, 223, 186), // Light Orange
          ),
        ),
        'Variaxis': centrewiseenergyData.firstWhere(
          (data) => data.x == 'Variaxis',
          orElse: () => CentrewiseenergyData(
            'Variaxis',
            0,
            const Color.fromARGB(255, 255, 255, 186), // Light Yellow
          ),
        ),
        'Mazak': centrewiseenergyData.firstWhere(
          (data) => data.x == 'Mazak',
          orElse: () => CentrewiseenergyData(
            'Mazak',
            0,
            const Color.fromARGB(255, 186, 255, 201), // Mint Green
          ),
        ),
        'DMG': centrewiseenergyData.firstWhere(
          (data) => data.x == 'DMG',
          orElse: () => CentrewiseenergyData(
            'DMG',
            0,
            const Color.fromARGB(255, 186, 225, 255), // Light Blue
          ),
        ),
      };

      totalEnergyByWorkcentreIdAndCode.forEach((key, totalEnergy) {
        String code = key.split(',').last.split(':').last.trim();

        CentrewiseenergyData? data = centrewiseEnergyMap[code];

        if (data != null) {
          centrewiseEnergyMap[code] = CentrewiseenergyData(
            data.x,
            totalEnergy, // Update the energy value
            data.color,
          );
        }
      });
      centrewiseenergyData = centrewiseEnergyMap.values.toList();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      List<MachinwiseCellID> machinewiseCentreCellList =
          await DashboardRepository.machinewiseCentreCellList();

      List<CellutilizationData> centreUtilizationDataList =
          await DashboardRepository.fetchUtilizationMachineData(
              machinewiseCentreCellList, effiStarttime, effiEndtime);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      List<MachinenameAndData> processData(
          List<CellutilizationData> centreUtilizationDataList) {
        List<MachinenameAndData> machineDataList = [];

        for (var machine in centreUtilizationDataList) {
          String machineName = machine.name;
          List<MachineMetricsData> metrics = [];

          for (var entry in machine.data) {
            metrics.add(
              MachineMetricsData(
                endTime: entry['endDate'],
                oee: entry['OEE'].toDouble(),
                productionTime: entry['productionTime'].toDouble(),
                idleTime: entry['idleTime'].toDouble(),
                production: entry['production'],
                machineon: entry['machineON'].toDouble(),
                offline: entry['offline'].toDouble(),
              ),
            );
          }

          machineDataList.add(
              MachinenameAndData(machineName: machineName, metrics: metrics));
        }

        return machineDataList;
      }
/* central data */

      List<MachinenameAndData> organizedData =
          processData(centreUtilizationDataList);
      List<CentralOEE> centraloee = [];

      Map<String, double> averageOEEByMachine =
          calculateAverageOEEofCenters(organizedData);

      final List<EfficiencyData> centerOEEData = [
        EfficiencyData(
            'CNCL',
            double.parse((averageOEEByMachine['CNCL'] ?? 0.0)
                .toStringAsFixed(2)), //'Variaxies i-700'
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'VMC',
            double.parse(
                (averageOEEByMachine['VMC'] ?? 0.0).toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'I-700',
            double.parse((averageOEEByMachine['Variaxies i-700'] ?? 0.0)
                .toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'Mazak',
            double.parse(
                (averageOEEByMachine['Mazak'] ?? 0.0).toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'DMG',
            double.parse(
                (averageOEEByMachine['DMG'] ?? 0.0).toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
      ];
/*   */

/* factory OEE */

      List<FactoryOEE> factoryOee = [];
      List<FactoryOEEData> centralizedData = calculateFactoryOEE(organizedData);

      for (var data in centralizedData) {
        DateTime utcDateTime = DateTime.parse(data.endTime);
        DateTime localDateTime = utcDateTime.toLocal();

        factoryOee.add(FactoryOEE(localDateTime, data.oee));
      }

/*  */
// factory Efficency //
      List<FactoryEfficency> factoryEfficency = [];
      List<FactoryEfficency> factoryEfficiencyList =
          calculateFactoryEfficiency(organizedData);
      for (var data in factoryEfficiencyList) {
        DateTime utcDateTime = data.endTime;
        DateTime localDateTime = utcDateTime.toLocal();

        factoryEfficency.add(FactoryEfficency(
            endTime: localDateTime, efficency: data.efficency));
      }
/////////////////////
      /// centre wise efficency //

      Map<String, double> centreEfficiencies =
          calculateCentreWiseEfficiency(organizedData);

      final List<EfficiencyData> centerEfficencyData = [
        EfficiencyData(
            'CNCL',
            double.parse((centreEfficiencies['CNCL'] ?? 0.0)
                .toStringAsFixed(2)), //'Variaxies i-700'
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'VMC',
            double.parse((centreEfficiencies['VMC'] ?? 0.0).toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'I-700',
            double.parse((centreEfficiencies['Variaxies i-700'] ?? 0.0)
                .toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'Mazak',
            double.parse(
                (centreEfficiencies['Mazak'] ?? 0.0).toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
        EfficiencyData(
            'DMG',
            double.parse((centreEfficiencies['DMG'] ?? 0.0).toStringAsFixed(2)),
            const Color.fromARGB(255, 160, 212, 247)),
        // Add more EfficiencyData as needed for other machines
      ];

      for (var item in centerEfficencyData) {
        shopefficiency += item.y;
      }

      double fshopeffi = shopefficiency / centerEfficencyData.length;
      fshopeffi = double.parse(fshopeffi.toStringAsFixed(2));

      emit(ADBLoadingState(
          workstationstatuslist: workstationstatuslist,
          centrewiseenergyData: centrewiseenergyData,
          centerOEEData: centerOEEData,
          shopefficiency: fshopeffi,
          centraloee: centraloee,
          factoryOee: factoryOee,
          factoryEfficency: factoryEfficency,
          centerEfficencyData: centerEfficencyData,
          totalenergy: totalenergy,
          machineMonthwiseEnergyConsumption:
              machineMonthwiseEnergyConsumption));
    });
  }
}

class ADBsecondBloc extends Bloc<ADBsecondEvent, ADBsecondState> {
  final BuildContext context;

  io.Socket? socket;
  Map<String, int> productionStatusMap = {};

  List<Map<String, String>> machineSocketIDList = [
    {'machineName': 'DMG', 'id': '66447cc097413d47f8fae095'},
    {'machineName': 'CNC-S2', 'id': '66893589241854b309b1012e'},
    {'machineName': 'CNC-S3', 'id': '668935ad241854b309b10137'},
    {'machineName': 'CNC-S4', 'id': '668935d1241854b309b10147'},
    {'machineName': 'VMC-F1', 'id': '668e37fa49dcc80bb42cfa61'},
    {'machineName': 'VMC-F3', 'id': '668e37bb49dcc80bb42cf9a3'},
    {'machineName': 'TS', 'id': '668e379949dcc80bb42cf96f'},
    {'machineName': 'Hartford', 'id': '6691108496d3ae07ec84dc04'},
    {'machineName': 'Mazak-300', 'id': '668f6992db97d2f2cb150256'},
  ];

  void connectToSocket() {
    socket = io.io('http://103.173.51.130:9003', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    // Loop through machines and listen for KPI data
    for (var machine in machineSocketIDList) {
      String machineId = machine['id']!;
      String kpiEvent = 'kpi/$machineId';

      // Listen to KPI data for each machine
      socket?.on(kpiEvent, (data) {
        int productionStatus = int.parse(data['productionStatus'].toString());
        productionStatusMap[machine['machineName'].toString()] =
            productionStatus;
      });
    }

    // Error handling
    socket?.on('connect_error', (data) {
      //
    });

    socket?.on('disconnect', (_) {
      //
    });
  }

  // Clean up socket connection when Bloc is closed

  ADBsecondBloc(this.context) : super(ADBsecondinitialState()) {
    on<ADBsecondEvent>((event, emit) async {
      List<WorkstationStatusModel> workstationstatuslist = [];
      List<WorkstationStatusModel> workstationstatuslist2 = [];
      List<WorkstationStatusModel> cncmachineslist = [], actulmachinelist = [];
      List<WorkstationStatusModel> vmcmachineslist = [],
          vmcenergymachinslist = [];
      List<WorkstationStatusModel> i700machineslist = [];
      List<WorkstationStatusModel> mazakmachineslist = [];
      List<WorkstationStatusModel> dmgmachineslist = [];

      String onlynowtime = '', formattedDate = '', starttime = '', endtime = '';

      DateTime nowcurrentTime = DateTime.now().toLocal();

      onlynowtime = DateFormat('HH:mm:ss').format(nowcurrentTime);
      formattedDate = DateFormat('dd/MM/yyyy').format(nowcurrentTime);
      starttime = "$formattedDate 00:00:01";
      endtime = "$formattedDate $onlynowtime";

      emit(ADBsecondLoadingState(
        workstationstatuslist: workstationstatuslist,
        buttonIndex: event.buttonIndex,
        cncmachineslist: cncmachineslist,
        vmcmachineslist: vmcmachineslist,
        i700machineslist: i700machineslist,
        mazakmachineslist: mazakmachineslist,
        dmgmachineslist: dmgmachineslist,
        workstationstatuslist2: workstationstatuslist2,
        wsefficiencyData: [],
        machinewiseenergyData: [],
        selectedCentreBotton: event.selectedCentreBotton,
        productionStatusMap: productionStatusMap,
      ));

      // Simulate a delay to allow for immediate visual feedback (optional)
      await Future.delayed(const Duration(milliseconds: 50));

      List<EfficiencyData> wsefficiencyData = [];

      List<MachinewiseenergyData> machinewiseenergyDatafinal = [];
      List wc = [];

      workstationstatuslist = await DashboardRepository.getworkstationlist();
      List<String> cncl = [];
      List<String> vmc = [];
      List<String> mazak = [];
      List<String> i700 = [];
      List<String> dmg = [];
      wc = await DashboardRepository.getAutomaticWorkcentreList();
      Map<String, Map<String, List<String>>> machinesByWorkcentreIdAndCode = {};

      for (var element in wc) {
        String workcentreId = element['wr_workcentre_id'] ?? '';
        String code = element['code'] ?? '';

        List<String> matchingMachines = workstationstatuslist
            .where((workstation) => workstation.wrWorkcentreId == workcentreId)
            .map((workstation) => workstation.machinename ?? '')
            .where((name) => name.isNotEmpty)
            .toList();

        if (matchingMachines.isNotEmpty) {
          machinesByWorkcentreIdAndCode[workcentreId] = {
            code: matchingMachines,
          };
        }
      }

      machinesByWorkcentreIdAndCode.forEach((id, machinesMap) {
        machinesMap.forEach((code, machines) {
          if (code == 'CNCL') {
            cncl.addAll(machines);
          } else if (code == 'VMC') {
            vmc.addAll(machines);
          } else if (code == 'Mazak') {
            mazak.addAll(machines);
          } else if (code == 'Variaxis') {
            i700.addAll(machines);
          } else if (code == 'DMG') {
            dmg.addAll(machines);
          }
        });
      });

      if (event.buttonIndex == 1) {
        /// CNC Button /////

        workstationstatuslist2 = [];
        wsefficiencyData = [];
        actulmachinelist = [];
        machinewiseenergyDatafinal = [];

        for (var item in workstationstatuslist) {
          if (item.wrWorkcentreId == '402881ea5dcffbaa015dd0003e5b0003') {
            actulmachinelist.add(item);
            actulmachinelist.removeWhere((element) =>
                element.id == '74c50e1043df49bfba98f9859318a785' ||
                element.id ==
                    '1e15aecbbbac40eead82bcaac5547692'); // S1 and S7 removed
            cncmachineslist.add(item);
            cncmachineslist.removeWhere((element) =>
                element.id == '74c50e1043df49bfba98f9859318a785' ||
                element.id == '1e15aecbbbac40eead82bcaac5547692');
          }
        }

        workstationstatuslist2 = actulmachinelist;

        wsefficiencyData = await DashboardRepository.workstationEfficency(
            cncl, starttime, endtime);

        Future<Map<String, double>> calculateEnergyForWorkstation(
            List<String> cncl, String formattedDate, String onlynowtime) async {
          Map<String, double> energyData = {};
          double totalEnergy = 0.0;
          double value = 0.0;

          for (String machine in cncl) {
            double machineEnergy = await DashboardRepository.machinewiseeenergy(
              machinename: machine.trim(),
              formattedDate: formattedDate,
              starttime: '00:00:01',
              endtime: onlynowtime,
            );

            value = machineEnergy / 1000;
            totalEnergy = ((value * 100).truncateToDouble()) / 100;

            // Store the energy data in the map with the machine name as the key
            energyData[machine] = totalEnergy;

            energyData.forEach((machine, energy) {
              // Remove specific substrings like "CNCL" or "VMC" from machine name
              String formattedMachineName =
                  machine.replaceAll(RegExp(r'(CNC-|VMC-|VMC)\s*'), '').trim();

              Color color = const Color.fromARGB(255, 57, 165,
                  192); // Assign a default color or set dynamically

              machinewiseenergyDatafinal.add(MachinewiseenergyData(
                formattedMachineName, // x: Formatted machine name
                energy, // y: Calculated efficiency
                color, // color: Assigned color
              ));
            });
          }
          return energyData;
        }

        Map<String, double> energyConsumption =
            await calculateEnergyForWorkstation(
          cncl,
          formattedDate,
          onlynowtime,
        );
        energyConsumption;
      } else if (event.buttonIndex == 2) {
        workstationstatuslist2 = [];
        wsefficiencyData = [];
        actulmachinelist = [];

        vmcenergymachinslist = [];

        machinewiseenergyDatafinal = [];

        for (var item in workstationstatuslist) {
          if (item.wrWorkcentreId == '402881ea5dcffbaa015dd00339660006') {
            actulmachinelist.add(item);
            vmcmachineslist.add(item);
            vmcenergymachinslist.add(item);
            vmcmachineslist.removeWhere((element) =>
                element.id == 'b6baa999c88a4e79a958efa6f8f025de' ||
                element.id == '213eff3361214449b188abdd79df628c');

            vmcenergymachinslist.removeWhere(
                (element) => element.id == 'b6baa999c88a4e79a958efa6f8f025de');
          }
        }
        workstationstatuslist2 = actulmachinelist;

        wsefficiencyData = await DashboardRepository.workstationEfficency(
            vmc, starttime, endtime);

        Future<Map<String, double>> calculateEnergyForWorkstation(
            List<String> vmc, String formattedDate, String onlynowtime) async {
          Map<String, double> energyData = {};
          double totalEnergy = 0.0;
          double value = 0.0;

          for (String machine in vmc) {
            double machineEnergy = await DashboardRepository.machinewiseeenergy(
              machinename: machine.trim(),
              formattedDate: formattedDate,
              starttime: '00:00:01',
              endtime: onlynowtime,
            );

            value = machineEnergy / 1000;
            totalEnergy = ((value * 100).truncateToDouble()) / 100;

            // Store the energy data in the map with the machine name as the key
            energyData[machine] = totalEnergy;

            energyData.forEach((machine, energy) {
              // Remove specific substrings like "CNCL" or "VMC" from machine name
              String formattedMachineName =
                  machine.replaceAll(RegExp(r'(CNC-|VMC-|VMC)\s*'), '').trim();

              Color color = const Color.fromARGB(255, 57, 165,
                  192); // Assign a default color or set dynamically

              machinewiseenergyDatafinal.add(MachinewiseenergyData(
                formattedMachineName, // x: Formatted machine name
                energy, // y: Calculated efficiency
                color, // color: Assigned color
              ));
            });
          }
          return energyData;
        }

        Map<String, double> energyConsumption =
            await calculateEnergyForWorkstation(
          vmc,
          formattedDate,
          onlynowtime,
        );
        energyConsumption;
      } else if (event.buttonIndex == 3) {
        workstationstatuslist2 = [];
        wsefficiencyData = [];
        actulmachinelist = [];

        machinewiseenergyDatafinal = [];

        for (var item in workstationstatuslist) {
          if (item.wrWorkcentreId == '402881ea5dcffbaa015dd004554a0008') {
            actulmachinelist.add(item);
            i700machineslist.add(item);
          }
        }
        workstationstatuslist2 = actulmachinelist;
        wsefficiencyData = await DashboardRepository.workstationEfficency(
            i700, starttime, endtime);

        Future<Map<String, double>> calculateEnergyForWorkstation(
            List<String> i700, String formattedDate, String onlynowtime) async {
          Map<String, double> energyData = {};
          double totalEnergy = 0.0;
          double value = 0.0;

          for (String machine in i700) {
            double machineEnergy = await DashboardRepository.machinewiseeenergy(
              machinename: machine.trim(),
              formattedDate: formattedDate,
              starttime: '00:00:01',
              endtime: onlynowtime,
            );

            value = machineEnergy / 1000;
            totalEnergy = ((value * 100).truncateToDouble()) / 100;

            // Store the energy data in the map with the machine name as the key
            energyData[machine] = totalEnergy;

            energyData.forEach((machine, energy) {
              // Remove specific substrings like "CNCL" or "VMC" from machine name
              String formattedMachineName =
                  machine.replaceAll(RegExp(r'(CNC-|VMC-|VMC)\s*'), '').trim();

              Color color = const Color.fromARGB(255, 57, 165,
                  192); // Assign a default color or set dynamically

              machinewiseenergyDatafinal.add(MachinewiseenergyData(
                formattedMachineName, // x: Formatted machine name
                energy, // y: Calculated efficiency
                color, // color: Assigned color
              ));
            });
          }
          return energyData;
        }

        Map<String, double> energyConsumption =
            await calculateEnergyForWorkstation(
          i700,
          formattedDate,
          onlynowtime,
        );
        energyConsumption;
      } else if (event.buttonIndex == 4) {
        // mazak ///////////////////////////////////////////////////////////////////////////////////////////////////////
        workstationstatuslist2 = [];
        wsefficiencyData = [];
        actulmachinelist = [];

        machinewiseenergyDatafinal = [];

        for (var item in workstationstatuslist) {
          if (item.wrWorkcentreId == '402881ea5dcffbaa015dd0013e100004') {
            actulmachinelist.add(item);
            mazakmachineslist.add(item);
          }
        }
        workstationstatuslist2 = actulmachinelist;
        wsefficiencyData = await DashboardRepository.workstationEfficency(
            mazak, starttime, endtime);

        Future<Map<String, double>> calculateEnergyForWorkstation(
            List<String> mazak,
            String formattedDate,
            String onlynowtime) async {
          Map<String, double> energyData = {};
          double totalEnergy = 0.0;
          double value = 0.0;

          for (String machine in mazak) {
            double machineEnergy = await DashboardRepository.machinewiseeenergy(
              machinename: machine.trim(),
              formattedDate: formattedDate,
              starttime: '00:00:01',
              endtime: onlynowtime,
            );

            value = machineEnergy / 1000;
            totalEnergy = ((value * 100).truncateToDouble()) / 100;

            // Store the energy data in the map with the machine name as the key
            energyData[machine] = totalEnergy;

            energyData.forEach((machine, energy) {
              // Remove specific substrings like "CNCL" or "VMC" from machine name
              String formattedMachineName =
                  machine.replaceAll(RegExp(r'(CNC-|VMC-|VMC)\s*'), '').trim();

              Color color = const Color.fromARGB(255, 57, 165,
                  192); // Assign a default color or set dynamically

              machinewiseenergyDatafinal.add(MachinewiseenergyData(
                formattedMachineName, // x: Formatted machine name
                energy, // y: Calculated efficiency
                color, // color: Assigned color
              ));
            });
          }
          return energyData;
        }

        Map<String, double> energyConsumption =
            await calculateEnergyForWorkstation(
          mazak,
          formattedDate,
          onlynowtime,
        );
        energyConsumption;
      } else if (event.buttonIndex == 5) {
        //////// dmg        ////////////////////////////////////////////////////////////////////////////////////////
        workstationstatuslist2 = [];
        machinewiseenergyDatafinal = [];

        for (var item in workstationstatuslist) {
          if (item.wrWorkcentreId == '4028817170aedeb70170af7e2821001e') {
            dmgmachineslist.add(item);
          }
        }
        workstationstatuslist2 = dmgmachineslist;
        wsefficiencyData = await DashboardRepository.workstationEfficency(
            dmg, starttime, endtime);

        Future<Map<String, double>> calculateEnergyForWorkstation(
            List<String> dmg, String formattedDate, String onlynowtime) async {
          Map<String, double> energyData = {};
          double totalEnergy = 0.0;
          double value = 0.0;

          for (String machine in dmg) {
            double machineEnergy = await DashboardRepository.machinewiseeenergy(
              machinename: machine.trim(),
              formattedDate: formattedDate,
              starttime: '00:00:01',
              endtime: onlynowtime,
            );

            value = machineEnergy / 1000;
            totalEnergy = ((value * 100).truncateToDouble()) / 100;

            // Store the energy data in the map with the machine name as the key
            energyData[machine] = totalEnergy;

            energyData.forEach((machine, energy) {
              // Remove specific substrings like "CNCL" or "VMC" from machine name
              String formattedMachineName =
                  machine.replaceAll(RegExp(r'(CNC-|VMC-|VMC)\s*'), '').trim();

              Color color = const Color.fromARGB(255, 57, 165,
                  192); // Assign a default color or set dynamically

              machinewiseenergyDatafinal.add(MachinewiseenergyData(
                formattedMachineName, // x: Formatted machine name
                energy, // y: Calculated efficiency
                color, // color: Assigned color
              ));
            });
          }
          return energyData;
        }

        Map<String, double> energyConsumption =
            await calculateEnergyForWorkstation(
          dmg,
          formattedDate,
          onlynowtime,
        );
        energyConsumption;
      }

      emit(ADBsecondLoadingState(
        workstationstatuslist: workstationstatuslist,
        buttonIndex: event.buttonIndex,
        cncmachineslist: cncmachineslist,
        vmcmachineslist: vmcmachineslist,
        i700machineslist: i700machineslist,
        mazakmachineslist: mazakmachineslist,
        dmgmachineslist: dmgmachineslist,
        workstationstatuslist2: workstationstatuslist2,
        wsefficiencyData: wsefficiencyData,
        machinewiseenergyData: machinewiseenergyDatafinal,
        selectedCentreBotton: event.selectedCentreBotton,
        productionStatusMap: productionStatusMap,
      ));

      @override
      Future<void> close() {
        socket?.dispose(); // Properly close the socket connection
        return super.close();
      }
    });
  }
}
