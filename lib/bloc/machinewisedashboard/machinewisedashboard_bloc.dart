// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/model/dashboard/dashboard_model.dart';
import '../../services/repository/dashboard/dashboard_repository.dart';
import 'machinewisedashboard_event.dart';
import 'machinewisedashboard_state.dart';

/*
class MWDBloc extends Bloc<MWDEvent, MWDState> {
  final BuildContext context;
  MWDBloc(this.context) : super(MWDinitialState()) {
    on<MWDEvent>((event, emit) async {
      // @override
      // Stream<MWDState> mapEventToState(MWDEvent event) async* {
      //   final updatedState = MWDLoadingState(
      //     selectedShift: event.switchIndex,
      //     workstationstatuslist: [],
      //     feedData: [],
      //     productiontimeData: [],
      //     machineenergy: 0,
      //     efficiency: 0,
      //     cs: [],
      //     partcount: 0, starttime: '', endtime: '', currentDate: '',
      //     //switchValues: 0,
      //   );

      //   yield updatedState;
      // }

      List<WorkstationStatusModel> workstationstatuslist = [];
      List<ProductiontimeData> productiontimeData = [];
      List<Workstationtotalcurrenttagid> wstotalcurrenttagid = [];
      String feedratetagid = '',
          idletimetagid = '',
          productiontimetagid = '',
          machinestatustagid = '',
          partcounttagid = '',
          energytagid = '',
          cyclestatustagid = '',
          totalcurrenttagid = '';
      double machineenergy = 0,
          productiontime = 0,
          idletime = 0,
          efficiency = 0,
          partcount = 0;
      List<FeedData> fr = [];
      List<TotalCurrentspiks> currentspiks = [];
      List<CycleObject> cs = [];
      String currentDate = '', starttime = '', endtime = '';
      DateTime today;

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
      } else if (event.switchIndex == 2) {
        starttime = '16:30:01';
        endtime = '23:59:59';
      } else if (event.switchIndex == 3) {
        starttime = '00:00:01';
        endtime = '07:59:59';
      }

      //debugPrint("$currentDate +' '+${event.switchIndex}+' '+ $starttime+ ' '+ $endtime");

      wstotalcurrenttagid =
          await DashboardRepository.getworkstationTotalCurrentTagid(
              workstationid: event.workstationstatus.id.toString().trim());
      for (var item in wstotalcurrenttagid) {
        totalcurrenttagid = item.totalcurrenttagid.toString().trim();
      }

      switch (event.switchIndex) {
        case 1:
          {
            switch (event.workstationstatus.id.toString().trim()) {
              case '4fba9c88a7a84a2989b51ae53f5713c4': //// DMG Machine
                {
                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();

                    debugPrint(event.workstationstatus.machinename.toString());
                    machineenergy =
                        await DashboardRepository.machinewiseeenergy(
                      machinename:
                          event.workstationstatus.machinename.toString(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    debugPrint(machineenergy.toDouble().toString());
                  }

                  if (event.workstationstatus.feedrate != null) {
                    feedratetagid =
                        event.workstationstatus.feedrate.toString().trim();
                    // debugPrint("feedrate function---");
                    fr = await DashboardRepository.dmgf2FeedRate(
                      tagid: feedratetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (event.workstationstatus.cyclerun != null) {
                    cyclestatustagid =
                        event.workstationstatus.cyclerun.toString().trim();
                    // debugPrint("cyclerun function---");
                    cs = await DashboardRepository.dmgf2cyclerun(
                      tagid: cyclestatustagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    // debugPrint(currentspiks.toString());
                  } else {
                    currentspiks = [];
                  }
                }
                break;

              case '213eff3361214449b188abdd79df628c': //// F2 machine
                {
                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();
                    // debugPrint("energy function---");
                    // machineenergy =
                    //     await DashboardRepository.machinewiseeenergy(
                    //   tagid: energytagid.trim(),
                    //   formattedDate: currentDate,
                    //   starttime: starttime,
                    //   endtime: endtime,
                    // );
                  }

                  if (event.workstationstatus.feedrate != null) {
                    feedratetagid =
                        event.workstationstatus.feedrate.toString().trim();
                    // debugPrint("feedrate function---");
                    fr = await DashboardRepository.dmgf2FeedRate(
                      tagid: feedratetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (event.workstationstatus.cyclerun != null) {
                    cyclestatustagid =
                        event.workstationstatus.cyclerun.toString().trim();
                    // debugPrint("cyclerun function---");
                    cs = await DashboardRepository.dmgf2cyclerun(
                      tagid: cyclestatustagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    // debugPrint(currentspiks.toString());
                  } else {
                    currentspiks = [];
                  }
                }
                break;
              default:
                {
                  if (event.workstationstatus.feedrate != null) {
                    feedratetagid =
                        event.workstationstatus.feedrate.toString().trim();
                    fr = await DashboardRepository.machinewiseFeedRate(
                      machinename:
                          event.workstationstatus.machinename.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    fr = [];
                  }
                  // debugPrint(fr.runtimeType.toString());

                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();

                    machineenergy =
                        await DashboardRepository.machinewiseeenergy(
                      machinename:
                          event.workstationstatus.machinename.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    machineenergy = machineenergy / 1000;
                  }

                  if (event.workstationstatus.idletime != null) {
                    idletimetagid =
                        event.workstationstatus.idletime.toString().trim();
                    // debugPrint("IdelTime function---");
                    idletime = await DashboardRepository.machinewiseIdleTime(
                      tagid: idletimetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (event.workstationstatus.productiontime != null) {
                    productiontimetagid = event.workstationstatus.productiontime
                        .toString()
                        .trim();
                    // debugPrint("ProductionTime function---");
                    productiontime =
                        await DashboardRepository.machinewiseProductionTime(
                      tagid: productiontimetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (event.workstationstatus.machinestatus != null) {
                    machinestatustagid =
                        event.workstationstatus.machinestatus.toString().trim();
                  }

                  if (event.workstationstatus.cyclerun != null) {
                    cyclestatustagid =
                        event.workstationstatus.cyclerun.toString().trim();
                    cs = await DashboardRepository.machinewisecyclerun(
                      machinename:
                          event.workstationstatus.machinename.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    // cs = await DashboardRepository.dmgF2cyclerun(
                    //   formattedDate: formattedDate,
                    // );
                  }

                  if (event.workstationstatus.partcount != null) {
                    partcounttagid =
                        event.workstationstatus.partcount.toString().trim();
                    // debugPrint("partcount function---");
                    partcount = await DashboardRepository.machinewisePartCount(
                      tagid: partcounttagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }
                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    // debugPrint(currentspiks.toString());
                  } else {
                    currentspiks = [];
                  }

                  productiontimeData = [
                    ProductiontimeData(
                        'Production_time', productiontime, Colors.red),
                    ProductiontimeData('Idel_Time', idletime, Colors.brown),
                  ];
                  efficiency =
                      (productiontime / (productiontime + idletime)) * 100;
                }
                break;
            }
          }
          break;
        case 2:
          {
            switch (event.workstationstatus.id.toString().trim()) {
              case '4fba9c88a7a84a2989b51ae53f5713c4': //// DMG Machine
                {
                  // debugPrint(
                  //     "DMG DMG-2------------------------============================>>>>>>>>>>");
                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();

                    // machineenergy =
                    //     await DashboardRepository.machinewiseeenergy(
                    //   tagid: energytagid.trim(),
                    //   formattedDate: currentDate,
                    //   starttime: starttime,
                    //   endtime: endtime,
                    // );
                  }
                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    // debugPrint(currentspiks.toString());
                  } else {
                    currentspiks = [];
                  }
                }
                break;

              case '213eff3361214449b188abdd79df628c': //F2 machine
                {
                  // debugPrint(
                  //     "F2 F2-22-----------------------============================>>>>>>>>>>");
                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();
                    // debugPrint("energy function---");
                    // machineenergy =
                    //     await DashboardRepository.machinewiseeenergy(
                    //   tagid: energytagid.trim(),
                    //   formattedDate: currentDate,
                    //   starttime: starttime,
                    //   endtime: endtime,
                    // );
                  }
                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    // debugPrint(currentspiks.toString());
                  } else {
                    currentspiks = [];
                  }
                }
                break;
              default:
                {
                  if (event.workstationstatus.idletime != null) {
                    idletimetagid =
                        event.workstationstatus.idletime.toString().trim();
                    // debugPrint("IdelTime function---");
                    idletime = await DashboardRepository.machinewiseIdleTime(
                      tagid: idletimetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (event.workstationstatus.productiontime != null) {
                    productiontimetagid = event.workstationstatus.productiontime
                        .toString()
                        .trim();
                    // debugPrint("ProductionTime function---");
                    productiontime =
                        await DashboardRepository.machinewiseProductionTime(
                      tagid: productiontimetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (event.workstationstatus.machinestatus != null) {
                    machinestatustagid =
                        event.workstationstatus.machinestatus.toString().trim();
                  }

                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();
                    // machineenergy =
                    //     await DashboardRepository.machinewiseeenergy(
                    //   tagid: energytagid.trim(),
                    //   formattedDate: currentDate,
                    //   starttime: starttime,
                    //   endtime: endtime,
                    // );
                  }

                  if (event.workstationstatus.cyclerun != null) {
                    cyclestatustagid =
                        event.workstationstatus.cyclerun.toString().trim();
                    cs = await DashboardRepository.machinewisecyclerun(
                      machinename:
                          event.workstationstatus.machinename.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    // cs = await DashboardRepository.dmgF2cyclerun(
                    //   formattedDate: formattedDate,
                    // );
                  }

                  if (event.workstationstatus.feedrate != null) {
                    feedratetagid =
                        event.workstationstatus.feedrate.toString().trim();
                    fr = await DashboardRepository.machinewiseFeedRate(
                      machinename:
                          event.workstationstatus.machinename.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    fr = [];
                  }

                  if (event.workstationstatus.partcount != null) {
                    partcounttagid =
                        event.workstationstatus.partcount.toString().trim();
                    partcount = await DashboardRepository.machinewisePartCount(
                      tagid: partcounttagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    currentspiks = [];
                  }

                  productiontimeData = [
                    ProductiontimeData(
                        'Production_time', productiontime, Colors.red),
                    ProductiontimeData('Idel_Time', idletime, Colors.brown),
                  ];

                  efficiency =
                      (productiontime / (productiontime + idletime)) * 100;
                }
                break;
            }
          }
          break;
        case 3:
          {
            switch (event.workstationstatus.id.toString().trim()) {
              case '4fba9c88a7a84a2989b51ae53f5713c4': //// DMG Machine
                {
                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();
                    // machineenergy =
                    //     await DashboardRepository.machinewiseeenergy(
                    //   tagid: energytagid.trim(),
                    //   formattedDate: currentDate,
                    //   starttime: starttime,
                    //   endtime: endtime,
                    // );
                  }

                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    // debugPrint(currentspiks.toString());
                  } else {
                    currentspiks = [];
                  }
                }
                break;

              case '213eff3361214449b188abdd79df628c': // F2 machine
                {
                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();
                    // machineenergy =
                    //     await DashboardRepository.machinewiseeenergy(
                    //   tagid: energytagid.trim(),
                    //   formattedDate: currentDate,
                    //   starttime: starttime,
                    //   endtime: endtime,
                    // );
                  }

                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                    // debugPrint(currentspiks.toString());
                  } else {
                    currentspiks = [];
                  }
                }
                break;
              default:
                {
                  if (event.workstationstatus.idletime != null) {
                    idletimetagid =
                        event.workstationstatus.idletime.toString().trim();
                    // debugPrint("IdelTime function---");
                    idletime = await DashboardRepository.machinewiseIdleTime(
                      tagid: idletimetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }
                  if (event.workstationstatus.productiontime != null) {
                    productiontimetagid = event.workstationstatus.productiontime
                        .toString()
                        .trim();
                    productiontime =
                        await DashboardRepository.machinewiseProductionTime(
                      tagid: productiontimetagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }

                  if (event.workstationstatus.machinestatus != null) {
                    machinestatustagid =
                        event.workstationstatus.machinestatus.toString().trim();
                  }

                  if (event.workstationstatus.energy != null) {
                    energytagid =
                        event.workstationstatus.energy.toString().trim();
                    // machineenergy =
                    //     await DashboardRepository.machinewiseeenergy(
                    //   tagid: energytagid.trim(),
                    //   formattedDate: currentDate,
                    //   starttime: starttime,
                    //   endtime: endtime,
                    // );
                  }

                  if (event.workstationstatus.cyclerun != null) {
                    cyclestatustagid =
                        event.workstationstatus.cyclerun.toString().trim();
                    cs = await DashboardRepository.machinewisecyclerun(
                      machinename:
                          event.workstationstatus.machinename.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    // cs = await DashboardRepository.dmgF2cyclerun(
                    //   formattedDate: formattedDate,
                    // );
                  }

                  if (event.workstationstatus.feedrate != null) {
                    feedratetagid =
                        event.workstationstatus.feedrate.toString().trim();
                    fr = await DashboardRepository.machinewiseFeedRate(
                      machinename:
                          event.workstationstatus.machinename.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    fr = [];
                  }

                  if (event.workstationstatus.partcount != null) {
                    partcounttagid =
                        event.workstationstatus.partcount.toString().trim();
                    partcount = await DashboardRepository.machinewisePartCount(
                      tagid: partcounttagid.trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  }
                  if (totalcurrenttagid != '') {
                    currentspiks =
                        await DashboardRepository.workstationCurrentspikes(
                      tagid: totalcurrenttagid.toString().trim(),
                      formattedDate: currentDate,
                      starttime: starttime,
                      endtime: endtime,
                    );
                  } else {
                    currentspiks = [];
                  }

                  productiontimeData = [
                    ProductiontimeData(
                        'Production_time', productiontime, Colors.red),
                    ProductiontimeData('Idel_Time', idletime, Colors.brown),
                  ];

                  efficiency =
                      (productiontime / (productiontime + idletime)) * 100;
                  // debugPrint("efficiency :-  ${efficiency.toStringAsFixed(2)}");

                  // debugPrint(
                  //     "energy:$machineenergy+   production time: $productiontime + IdleTime: $idletime+'    '+partCount:- $partcount");
                }
                break;
            }
          }
          break;
        // default:
        //   {
        //     debugPrint("This is default case ----??????????????????????");
        //   }
        // break;
      }
      machinestatustagid;
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
      ));
    });
  }
}
*/
class MachinewiseDashboardBloc extends Bloc<MWDEvent, MWDState> {
  final BuildContext context;
  MachinewiseDashboardBloc(this.context) : super(MWDinitialState()) {
    on<MWDEvent>((event, emit) async {
      List<WorkstationStatusModel> workstationstatuslist = [];
      List<ProductiontimeData> productiontimeData = [];
      // List<Workstationtotalcurrenttagid> wstotalcurrenttagid = [];
      // ProductionUtilizationData machineUtilizationData = [];
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
      // datefor24hr = '';
      DateTime today;

      final nowdateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      DateTime nowcurrentTime = DateTime.now().toLocal();
      String nowdatetime = nowdateFormat.format(nowcurrentTime);

      // debugPrint(
      //     "check now check now ->>>>>>>>>>>>>>>>>>>>>>>>>>" + nowdatetime);

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

        //debugPrint('$starttime $endtime');
      }

      DateTime currentTime = DateTime.now().toLocal();
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      DateTime startTime = currentTime.subtract(const Duration(hours: 1));
      //  List<ProductionCyclevalue> productionCycleBarData =[];
      // debugPrint(startTime.toString());
      List<ProductionCyclevalue> productionCycleBarData =
          await DashboardRepository.machinewisecyclerun(
              starttime: dateFormat.format(startTime),
              endtime: dateFormat.format(currentTime),
              machinename:
                  event.workstationstatus.machinename.toString().trim());
      // productionCycleBarData.add(dataList);

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
            } else {
              // Handle the case where the data could not be fetched
              // debugPrint(
              //     'Failed to fetch machine utilization data [[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]');
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
            // efficiency = (truncatedProductiontime /
            //         (truncatedProductiontime + truncatedIdletime)) *
            //     100;

            // efficiency = machineUtilizationData!.oee;

            if (machineUtilizationData != null) {
              // debugPrint("------------>>>>>>");
              // debugPrint(productiontime.toString());
              // debugPrint(machineon.toString());
              efficiency = (productiontime / machineon) * 100;
              // Use efficiency as needed
            } else {
              // Handle the case where machineUtilizationData is null
              debugPrint("Machine Utilization Data is null");
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
              // Handle the case where the data could not be fetched
              // debugPrint(
              //     'Failed to fetch machine utilization data [[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]');
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
            // efficiency = (truncatedProductiontime /
            //         (truncatedProductiontime + truncatedIdletime)) *
            //     100;

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
              // Handle the case where the data could not be fetched
              // debugPrint(
              //     'Failed to fetch machine utilization data [[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]');
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

              // const Color.fromARGB(255, 71, 61, 57)),
            ];
            // efficiency = (truncatedProductiontime /
            //         (truncatedProductiontime + truncatedIdletime)) *
            //     100;

            // efficiency = machineUtilizationData!.oee.toDouble();
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
              // Handle the case where the data could not be fetched
              // debugPrint(
              //     'Failed to fetch machine utilization data [[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]');
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
            // efficiency = machineUtilizationData!.oee.toDouble();
            efficiency = (productiontime / machineon) * 100;
          }
          break;
      }
      //  machinestatustagid;
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
