// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/model/dashboard/dashboard_model.dart';
import '../../services/repository/dashboard/dashboard_repository.dart';
import 'machinewisedashboard_event.dart';
import 'machinewisedashboard_state.dart';

class MachinewiseDashboardBloc extends Bloc<MWDEvent, MWDState> {
  final BuildContext context;
  MachinewiseDashboardBloc(this.context) : super(MWDinitialState()) {
    on<MWDEvent>((event, emit) async {
      List<WorkstationStatusModel> workstationstatuslist = [];
      List<ProductiontimeData> productiontimeData = [];

      double machineenergy = 0,
          productiontime = 0,
          idletime = 0,
          efficiency = 0,
          partcount = 0,
          machineon = 0;
      List<FeedData> fr = [];
      List<MachineCurrentData> currentspiks = [];
      List<MachineVolatgeData> voltageData = [];
      List<ProductionCyclevalue> cs = [];
      List<Industry4WorkstationTagId> wstagid = [];
      String currentDate = '', starttime = '', endtime = '';

      DateTime today;

      final nowdateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      DateTime nowcurrentTime = DateTime.now().toLocal();
      String nowdatetime = nowdateFormat.format(nowcurrentTime);

      wstagid = await DashboardRepository.industry4WorkstationtagID(
          workstationid: event.workstationstatus.id.toString());

      if (event.chooseDate == '') {
        today = DateTime.now();
        currentDate = DateFormat('dd/MM/yyyy').format(today);
        starttime = '';
        endtime = '';
      } else {
        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(event.chooseDate);
        currentDate = DateFormat('dd/MM/yyyy').format(parsedDate);
        starttime = '';
        endtime = '';
      }

      if (event.switchIndex == 1) {
        starttime = '08:00:00';
        endtime = '16:30:00';
        String shiftwiseStarttime = "$currentDate $starttime";
        String shiftwiseEndtime = "$currentDate $endtime";
        DateTime nowDateTime1 = nowdateFormat.parse(nowdatetime);
        DateTime shiftStartdateTime = nowdateFormat.parse(shiftwiseStarttime);
        DateTime shiftEnddateTime = nowdateFormat.parse(shiftwiseEndtime);

        if (shiftStartdateTime.isBefore(nowDateTime1)) {
          if (nowDateTime1.isBefore(shiftEnddateTime)) {
            starttime = '08:00:00';
            endtime = DateFormat('HH:mm:ss').format(nowDateTime1);
          } else if (nowDateTime1.isAfter(shiftEnddateTime)) {
            starttime = '08:00:00';
            endtime = '16:30:00';
          } else {
            starttime = '00:00:00';
            endtime = '00:00:00';
          }
        } else {
          starttime = '00:00:00';
          endtime = '00:00:00';
        }
      } else if (event.switchIndex == 2) {
        starttime = '16:30:01';
        endtime = '23:59:59';
        String shiftwiseStarttime = "$currentDate $starttime";
        String shiftwiseEndtime = "$currentDate $endtime";
        DateTime nowDateTime1 = nowdateFormat.parse(nowdatetime);
        DateTime shiftStartdateTime = nowdateFormat.parse(shiftwiseStarttime);
        DateTime shiftEnddateTime = nowdateFormat.parse(shiftwiseEndtime);

        if (shiftStartdateTime.isBefore(nowDateTime1)) {
          if (nowDateTime1.isBefore(shiftEnddateTime)) {
            starttime = '16:30:01';
            endtime = DateFormat('HH:mm:ss').format(nowDateTime1);
          } else if (nowDateTime1.isAfter(shiftEnddateTime)) {
            starttime = '16:30:01';
            endtime = '23:59:59';
          } else {
            QuickFixUi.errorMessage("Shift Not started Yet ...!", context);
            starttime = '00:00:00';
            endtime = '00:00:00';
          }
        } else {
          QuickFixUi.errorMessage("Shift Not started Yet ...!", context);
          starttime = '00:00:00';
          endtime = '00:00:00';
        }
      } else if (event.switchIndex == 3) {
        starttime = '00:00:01';
        endtime = '07:59:59';

        String shiftwiseStarttime = "$currentDate $starttime";
        String shiftwiseEndtime = "$currentDate $endtime";
        DateTime nowDateTime1 = nowdateFormat.parse(nowdatetime);
        DateTime shiftStartdateTime = nowdateFormat.parse(shiftwiseStarttime);
        DateTime shiftEnddateTime = nowdateFormat.parse(shiftwiseEndtime);

        if (shiftStartdateTime.isBefore(nowDateTime1)) {
          if (nowDateTime1.isBefore(shiftEnddateTime)) {
            starttime = '00:00:01';
            endtime = DateFormat('HH:mm:ss').format(nowDateTime1);
          } else if (nowDateTime1.isAfter(shiftEnddateTime)) {
            starttime = '00:00:01';
            endtime = '07:59:59';
          } else {
            QuickFixUi.errorMessage("Shift Not started Yet ...!", context);
            starttime = '00:00:00';
            endtime = '00:00:00';
          }
        } else {
          QuickFixUi.errorMessage("Shift Not started Yet ...!", context);
          starttime = '00:00:00';
          endtime = '00:00:00';
        }
      } else if (event.switchIndex == 4) {
        DateTime nowDateTime2 = nowdateFormat.parse(nowdatetime);
        DateTime adjustedDateTime =
            nowDateTime2.subtract(const Duration(hours: 24));
        starttime = nowdateFormat.format(adjustedDateTime);
        endtime = nowdatetime;
      }

      DateTime currentTime = DateTime.now().toLocal();
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      DateTime startTime = currentTime.subtract(const Duration(hours: 1));

      List<ProductionCyclevalue> productionCycleBarData =
          await DashboardRepository.machinewisecyclerun(
              starttime: dateFormat.format(startTime),
              endtime: dateFormat.format(currentTime),
              machinename:
                  event.workstationstatus.machinename.toString().trim());

      switch (event.switchIndex) {
        case 1:
          {
            fr = await DashboardRepository.machinewiseFeedRate(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            machineenergy = await DashboardRepository.machinewiseeenergy(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );
            double value = machineenergy / 1000;
            machineenergy = ((value * 100).truncateToDouble()) / 100;

            ProductionUtilizationData? machineUtilizationData =
                await DashboardRepository.machinewiseUtilization(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            currentspiks = await DashboardRepository.machineCurrentData(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            voltageData = await DashboardRepository.machineVoltageData(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            if (machineUtilizationData != null) {
              idletime = machineUtilizationData.idleTime.toDouble() / 60;
              productiontime =
                  machineUtilizationData.productionTime.toDouble() / 60;
              machineon = machineUtilizationData.machineON.toDouble() / 60;
            } else {}

            double truncatedIdletime =
                ((idletime * 100).truncateToDouble()) / 100;
            double truncatedProductiontime =
                ((productiontime * 100).truncateToDouble()) / 100;
            double truncatedmachineon =
                ((machineon * 100).truncateToDouble()) / 100;

            productiontimeData = [
              ProductiontimeData('MachineOn', truncatedmachineon, Colors.black),
              ProductiontimeData(
                  'Production_time', truncatedProductiontime, Colors.red),
              ProductiontimeData('Idel_Time', truncatedIdletime, Colors.brown),
            ];

            if (machineUtilizationData != null) {
              efficiency = (productiontime / machineon) * 100;
            } else {
              //
            }
          }
          break;
        case 2:
          {
            fr = await DashboardRepository.machinewiseFeedRate(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            machineenergy = await DashboardRepository.machinewiseeenergy(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            double value = machineenergy / 1000;
            machineenergy = ((value * 100).truncateToDouble()) / 100;

            ProductionUtilizationData? machineUtilizationData =
                await DashboardRepository.machinewiseUtilization(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            currentspiks = await DashboardRepository.machineCurrentData(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );
            voltageData = await DashboardRepository.machineVoltageData(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            if (machineUtilizationData != null) {
              idletime = machineUtilizationData.idleTime.toDouble() / 60;
              productiontime =
                  machineUtilizationData.productionTime.toDouble() / 60;
              machineon = machineUtilizationData.machineON.toDouble() / 60;
            } else {
              //
            }

            double truncatedIdletime =
                ((idletime * 100).truncateToDouble()) / 100;
            double truncatedProductiontime =
                ((productiontime * 100).truncateToDouble()) / 100;
            double truncatedmachineon =
                ((machineon * 100).truncateToDouble()) / 100;

            productiontimeData = [
              ProductiontimeData('MachineOn', truncatedmachineon, Colors.black),
              ProductiontimeData(
                  'Production_time', truncatedProductiontime, Colors.red),
              ProductiontimeData('Idel_Time', truncatedIdletime, Colors.brown),
            ];

            efficiency = (productiontime / machineon) * 100;
          }
          break;
        case 3:
          {
            fr = await DashboardRepository.machinewiseFeedRate(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            machineenergy = await DashboardRepository.machinewiseeenergy(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );
            double value = machineenergy / 1000;
            machineenergy = ((value * 100).truncateToDouble()) / 100;

            ProductionUtilizationData? machineUtilizationData =
                await DashboardRepository.machinewiseUtilization(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            currentspiks = await DashboardRepository.machineCurrentData(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );
            voltageData = await DashboardRepository.machineVoltageData(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              formattedDate: currentDate,
              starttime: starttime,
              endtime: endtime,
            );

            if (machineUtilizationData != null) {
              idletime = machineUtilizationData.idleTime.toDouble() / 60;
              productiontime =
                  machineUtilizationData.productionTime.toDouble() / 60;
              machineon = machineUtilizationData.machineON.toDouble() / 60;
            } else {
              //
            }

            double truncatedIdletime =
                ((idletime * 100).truncateToDouble()) / 100;
            double truncatedProductiontime =
                ((productiontime * 100).truncateToDouble()) / 100;
            double truncatedmachineon =
                ((machineon * 100).truncateToDouble()) / 100;

            productiontimeData = [
              ProductiontimeData('MachineOn', truncatedmachineon, Colors.black),
              ProductiontimeData(
                  'Production_time', truncatedProductiontime, Colors.red),
              ProductiontimeData('Idel_Time', truncatedIdletime, Colors.brown),
            ];

            efficiency = (productiontime / machineon) * 100;
          }
          break;

        case 4:
          {
            fr = await DashboardRepository.machinewiseFeedRate24hr(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              starttime: starttime,
              endtime: endtime,
            );

            machineenergy = await DashboardRepository.machinewiseeenergy24hr(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              starttime: starttime,
              endtime: endtime,
            );
            double value = machineenergy / 1000;
            machineenergy = ((value * 100).truncateToDouble()) / 100;

            ProductionUtilizationData? machineUtilizationData =
                await DashboardRepository.machinewiseUtilization24hr(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              starttime: starttime,
              endtime: endtime,
            );

            currentspiks = await DashboardRepository.machineCurrentData24hr(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              starttime: starttime,
              endtime: endtime,
            );

            voltageData = await DashboardRepository.machineVoltageData24hr(
              machinename:
                  event.workstationstatus.machinename.toString().trim(),
              starttime: starttime,
              endtime: endtime,
            );

            if (machineUtilizationData != null) {
              idletime = machineUtilizationData.idleTime.toDouble() / 60;
              productiontime =
                  machineUtilizationData.productionTime.toDouble() / 60;
              machineon = machineUtilizationData.machineON.toDouble() / 60;
            } else {
              //
            }

            double truncatedIdletime =
                ((idletime * 100).truncateToDouble()) / 100;
            double truncatedProductiontime =
                ((productiontime * 100).truncateToDouble()) / 100;
            double truncatedmachineon =
                ((machineon * 100).truncateToDouble()) / 100;

            productiontimeData = [
              ProductiontimeData('MachineOn', truncatedmachineon, Colors.black),
              ProductiontimeData(
                  'Production_time', truncatedProductiontime, Colors.red),
              ProductiontimeData('Idel_Time', truncatedIdletime, Colors.brown),
            ];

            efficiency = (productiontime / machineon) * 100;
          }
          break;
      }

      emit(MWDLoadingState(
          workstationstatuslist: workstationstatuslist,
          feedData: fr,
          productiontimeData: productiontimeData,
          machineenergy: machineenergy,
          efficiency: double.parse(efficiency.toStringAsFixed(2)),
          cs: cs,
          partcount: partcount,
          selectedShift: event.switchIndex,
          starttime: starttime,
          endtime: endtime,
          currentDate: currentDate,
          chooseDate: event.chooseDate,
          currentspikes: currentspiks,
          machinename: event.workstationstatus.machinename.toString().trim(),
          voltageData: voltageData,
          wstagid: wstagid,
          productionCycleBarData: productionCycleBarData));
    });
  }
}
