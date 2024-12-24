// Author : Shital Gayakwad
// Created Date : 28 Feb 2023
// Description : ERPX_PPC -> User models

import 'package:flutter/material.dart';

class UserModule {
  String? foldername;
  String? folderId;

  UserModule({this.foldername, this.folderId});

  UserModule.fromJson(Map<String, dynamic> json) {
    foldername = json['foldername'];
    folderId = json['folder_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foldername'] = foldername;
    data['folder_id'] = folderId;
    return data;
  }
}

class Programs {
  String? id;
  String? programname;

  Programs({this.id, this.programname});

  Programs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programname = json['programname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['programname'] = programname;
    return data;
  }
}

class MachineAutomaticCheck {
  String? id;
  String? wrWorkcentreId;
  String? code;
  String? workstationgroupCode;
  String? isautomatic;

  MachineAutomaticCheck(
      {this.id,
      this.wrWorkcentreId,
      this.code,
      this.workstationgroupCode,
      this.isautomatic});

  MachineAutomaticCheck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wrWorkcentreId = json['wr_workcentre_id'];
    code = json['code'];
    workstationgroupCode = json['workstationgroup_code'];
    isautomatic = json['isautomatic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wr_workcentre_id'] = wrWorkcentreId;
    data['code'] = code;
    data['workstationgroup_code'] = workstationgroupCode;
    data['isautomatic'] = isautomatic;
    return data;
  }
}

class Workstationtotalcurrenttagid {
  String? id;
  String? wsid;
  String? machine;
  String? totalcurrenttagid;

  Workstationtotalcurrenttagid(
      {this.id, this.wsid, this.machine, this.totalcurrenttagid});

  Workstationtotalcurrenttagid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wsid = json['workstation_id'];
    machine = json['machine'];
    totalcurrenttagid = json['total_current_tagid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['workstation_id'] = wsid;
    data['machine'] = machine;
    data['total_current_tagid'] = totalcurrenttagid;
    return data;
  }
}

class WorkstationStatusModel {
  String? id;
  String? wrWorkcentreId;
  String? code;
  String? machineid;
  String? machinename;
  String? machineip;
  String? productid;
  String? productcode;
  String? rmsid;
  String? pono;
  int? seqno;
  String? qty;
  String? employeename;
  String? startprocesstime;
  String? endprocesstime;
  int? endprocessflag;
  String? feedrate;
  String? idletime;
  String? productiontime;
  String? machinestatus;
  String? partcount;
  String? energy;
  String? cyclerun;

  WorkstationStatusModel(
      {this.id,
      this.wrWorkcentreId,
      this.code,
      this.machineid,
      this.machinename,
      this.machineip,
      this.productid,
      this.productcode,
      this.rmsid,
      this.pono,
      this.seqno,
      this.qty,
      this.employeename,
      this.startprocesstime,
      this.endprocesstime,
      this.endprocessflag,
      this.feedrate,
      this.idletime,
      this.productiontime,
      this.machinestatus,
      this.partcount,
      this.energy,
      this.cyclerun});

  WorkstationStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wrWorkcentreId = json['wr_workcentre_id'];
    code = json['code'];
    machineid = json['machineid'];
    machinename = json['machinename'];
    machineip = json['machineip'];
    productid = json['productid'];
    productcode = json['productcode'];
    rmsid = json['rmsid'];
    pono = json['pono'];
    seqno = json['seqno'];
    qty = json['qty'];
    employeename = json['employeename'];
    startprocesstime = json['startprocesstime'];
    endprocesstime = json['endprocesstime'];
    endprocessflag = json['endprocessflag'];
    feedrate = json['feedrate'];
    idletime = json['idletime'];
    productiontime = json['productiontime'];
    machinestatus = json['machinestatus'];
    partcount = json['partcount'];
    energy = json['energy'];
    cyclerun = json['cyclerun'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wr_workcentre_id'] = wrWorkcentreId;
    data['code'] = code;
    data['machineid'] = machineid;
    data['machinename'] = machinename;
    data['machineip'] = machineip;
    data['productid'] = productid;
    data['productcode'] = productcode;
    data['rmsid'] = rmsid;
    data['pono'] = pono;
    data['seqno'] = seqno;
    data['qty'] = qty;
    data['employeename'] = employeename;
    data['startprocesstime'] = startprocesstime;
    data['endprocesstime'] = endprocesstime;
    data['endprocessflag'] = endprocessflag;
    data['feedrate'] = feedrate;
    data['idletime'] = idletime;
    data['productiontime'] = productiontime;
    data['machinestatus'] = machinestatus;
    data['partcount'] = partcount;
    data['energy'] = energy;
    data['cyclerun'] = cyclerun;
    return data;
  }
}

class Cncenery {
  bool status;
  int resultTime;
  Map<String, CncCentreEnergyData> data;

  Cncenery({
    required this.status,
    required this.resultTime,
    required this.data,
  });

  factory Cncenery.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dataMap = json['data'];
    Map<String, CncCentreEnergyData> data = dataMap.map((key, value) {
      return MapEntry(key, CncCentreEnergyData.fromJson(value));
    });

    return Cncenery(
      status: json['status'],
      resultTime: json['result_time'],
      data: data,
    );
  }
}

class Vmcenery {
  bool status;
  int resultTime;
  Map<String, CncCentreEnergyData> data;

  Vmcenery({
    required this.status,
    required this.resultTime,
    required this.data,
  });

  factory Vmcenery.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dataMap = json['data'];
    Map<String, CncCentreEnergyData> data = dataMap.map((key, value) {
      return MapEntry(key, CncCentreEnergyData.fromJson(value));
    });

    return Vmcenery(
      status: json['status'],
      resultTime: json['result_time'],
      data: data,
    );
  }
}

class Mazakenery {
  bool status;
  int resultTime;
  Map<String, CncCentreEnergyData> data;

  Mazakenery({
    required this.status,
    required this.resultTime,
    required this.data,
  });

  factory Mazakenery.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dataMap = json['data'];
    Map<String, CncCentreEnergyData> data = dataMap.map((key, value) {
      return MapEntry(key, CncCentreEnergyData.fromJson(value));
    });

    return Mazakenery(
      status: json['status'],
      resultTime: json['result_time'],
      data: data,
    );
  }
}

class I700enery {
  bool status;
  int resultTime;
  Map<String, CncCentreEnergyData> data;

  I700enery({
    required this.status,
    required this.resultTime,
    required this.data,
  });

  factory I700enery.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dataMap = json['data'];
    Map<String, CncCentreEnergyData> data = dataMap.map((key, value) {
      return MapEntry(key, CncCentreEnergyData.fromJson(value));
    });

    return I700enery(
      status: json['status'],
      resultTime: json['result_time'],
      data: data,
    );
  }
}

class CncCentreEnergyData {
  bool status;
  List<SubPeriodData> subPeriodData;
  List<PeriodData> periodData;

  CncCentreEnergyData({
    required this.status,
    required this.subPeriodData,
    required this.periodData,
  });

  factory CncCentreEnergyData.fromJson(Map<String, dynamic> json) {
    List<dynamic> subPeriodJsonList = json['sub_period_data'] ?? [];
    List<SubPeriodData> subPeriodDataList =
        subPeriodJsonList.map((e) => SubPeriodData.fromJson(e)).toList();

    List<dynamic> periodJsonList = json['period_data'] ?? [];
    List<PeriodData> periodDataList =
        periodJsonList.map((e) => PeriodData.fromJson(e)).toList();

    return CncCentreEnergyData(
      status: json['status'],
      subPeriodData: subPeriodDataList,
      periodData: periodDataList,
    );
  }
}

class SubPeriodData {
  int ts;
  int value;

  SubPeriodData({
    required this.ts,
    required this.value,
  });

  factory SubPeriodData.fromJson(Map<String, dynamic> json) {
    return SubPeriodData(
      ts: json['ts'],
      value: json['value'],
    );
  }
}

class PeriodData {
  int ts;
  int value;

  PeriodData({
    required this.ts,
    required this.value,
  });

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      ts: json['ts'],
      value: json['value'],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class Centrewisecount {
  Centrewisecount(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class CentrewiseenergyData {
  CentrewiseenergyData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class MachinewiseenergyData {
  MachinewiseenergyData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class EfficiencyData {
  EfficiencyData(
    this.x,
    this.y,
    this.color,
  );
  final String x;
  final double y;
  final Color color;
}

class FeedData {
  FeedData(this.x, this.y);
  final DateTime x;
  final double y;
}

class TotalCurrentspiks {
  TotalCurrentspiks(this.x, this.y);
  final DateTime x;
  final double y;
}

class ProductiontimeData {
  ProductiontimeData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class CycleObject {
  CycleObject(this.x, this.y);
  final DateTime x;
  final int y;
}

class ProductionCyclevalue {
  final int ts;
  final int value;

  ProductionCyclevalue({required this.ts, required this.value});

  factory ProductionCyclevalue.fromJson(Map<String, dynamic> json) {
    return ProductionCyclevalue(
      ts: json['ts'] as int,
      value: json['value'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ts': ts,
      'value': value,
    };
  }
}

class OneCycleData {
  String startTime, endTime;
  double pos;
  int value;
  OneCycleData(
      {this.startTime = '', this.endTime = '', this.pos = 0, this.value = -1});
}

class MachineUtilizationData {
  final String startDate;
  final String endDate;
  final int productionTime;
  final int idleTime;
  final int production;
  final double oee;
  final int offlineTime;
  final int reportTime;

  MachineUtilizationData({
    required this.startDate,
    required this.endDate,
    required this.productionTime,
    required this.idleTime,
    required this.production,
    required this.oee,
    required this.offlineTime,
    required this.reportTime,
  });

  factory MachineUtilizationData.fromJson(Map<String, dynamic> json) {
    return MachineUtilizationData(
      startDate: json['startDate'],
      endDate: json['endDate'],
      productionTime: json['productionTime'],
      idleTime: json['idleTime'],
      production: json['production'],
      oee: json['OEE'].toDouble(),
      offlineTime: json['offlineTime'],
      reportTime: json['reportTime'],
    );
  }
}

class MachineCurrentData {
  MachineCurrentData(this.timestamp, this.currentTotal, this.r, this.y, this.b);
  final DateTime timestamp;
  final double currentTotal;
  final double r;
  final double y;
  final double b;
}

class MachineVolatgeData {
  MachineVolatgeData(this.timestamp, this.vllaverage, this.varphase,
      this.vayphase, this.vabphase, this.vatotal);
  final DateTime timestamp;
  final double vllaverage;
  final double varphase;
  final double vayphase;
  final double vabphase;
  final double vatotal;
}

class ProductionUtilizationData {
  final int production;
  final double oee;
  final int productionTime;
  final int idleTime;
  final int machineON;

  ProductionUtilizationData({
    required this.production,
    required this.oee,
    required this.productionTime,
    required this.idleTime,
    required this.machineON,
  });

  factory ProductionUtilizationData.fromJson(Map<String, dynamic> json) {
    return ProductionUtilizationData(
      production: json['production'],
      oee: json['OEE'],
      productionTime: json['productionTime'],
      idleTime: json['idleTime'],
      machineON: json['machineON'],
    );
  }
}

class MachinwiseCellID {
  final String name;
  final String value;
  final String id;

  MachinwiseCellID({required this.name, required this.value, required this.id});

  factory MachinwiseCellID.fromJson(Map<String, dynamic> json) {
    return MachinwiseCellID(
      name: json['name'],
      value: json['value'],
      id: json['id'],
    );
  }
}

class CellutilizationData {
  final String name;
  final List<dynamic> data;

  CellutilizationData({required this.name, required this.data});
}

class MachinenameAndData {
  final String machineName;
  final List<MachineMetricsData> metrics;

  MachinenameAndData({required this.machineName, required this.metrics});
}

class MachineMetricsData {
  final String endTime;
  final double oee;
  final double productionTime;
  final double idleTime;
  final int production;
  final double machineon;
  final double offline;

  MachineMetricsData(
      {required this.endTime,
      required this.oee,
      required this.productionTime,
      required this.idleTime,
      required this.production,
      required this.machineon,
      required this.offline});
}

class FactoryOEEData {
  final String endTime;
  final double oee;

  FactoryOEEData({required this.endTime, required this.oee});

  factory FactoryOEEData.fromMap(Map<String, dynamic> map) {
    return FactoryOEEData(
      endTime: map['endTime'] as String,
      oee: map['oee'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'endTime': endTime,
      'oee': oee,
    };
  }
}

class FactoryEfficency {
  final DateTime endTime;
  final double efficency;

  FactoryEfficency({required this.endTime, required this.efficency});

  factory FactoryEfficency.fromMap(Map<String, dynamic> map) {
    return FactoryEfficency(
      endTime: DateTime.parse(map['endTime'] as String),
      efficency: map['efficency'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'endTime': endTime.toIso8601String(),
      'efficency': efficency,
    };
  }
}

class CentralOEE {
  CentralOEE(this.time, this.oee);
  final DateTime time;
  final double oee;
}

class FactoryOEE {
  FactoryOEE(this.time, this.oee);
  final DateTime time;
  final double oee;
}

class Industry4WorkstationTagId {
  final String id;
  final String workstationid;
  final String efficiency;
  final String productionTime;
  final String idleTime;
  final String currentSpike;
  final String energyConsumption;
  final String feedRate;
  final String machinevoltage;

  Industry4WorkstationTagId({
    required this.id,
    required this.workstationid,
    required this.efficiency,
    required this.productionTime,
    required this.idleTime,
    required this.currentSpike,
    required this.energyConsumption,
    required this.feedRate,
    required this.machinevoltage,
  });

  // Factory method to create an instance from a JSON map
  factory Industry4WorkstationTagId.fromJson(Map<String, dynamic> json) {
    return Industry4WorkstationTagId(
      id: json['id'] ?? '',
      workstationid: json['workstation_id'] ?? '',
      efficiency: json['efficiency'] ?? '',
      productionTime: json['production_time'] ?? '',
      idleTime: json['idle_time'] ?? '',
      currentSpike: json['current_spike'] ?? '',
      energyConsumption: json['energy_consumption'] ?? '',
      feedRate: json['feed_rate'] ?? '',
      machinevoltage: json['machinevoltage'] ?? '',
    );
  }

  // Convert the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workstation_id': workstationid,
      'efficiency': efficiency,
      'production_time': productionTime,
      'idle_time': idleTime,
      'current_spike': currentSpike,
      'energy_consumption': energyConsumption,
      'feed_rate': feedRate,
      'machinevolatge': machinevoltage
    };
  }

  @override
  String toString() {
    return 'WorkstationStatusModel(id:$id, workstation_id:$workstationid, efficiency: $efficiency, productionTime: $productionTime, idleTime: $idleTime, currentSpike: $currentSpike, energyConsumption: $energyConsumption, feedRate: $feedRate, machinevoltage:$machinevoltage)';
  }
}

class MachineSocketIDData {
  final String machineName;
  final String id;

  MachineSocketIDData({required this.machineName, required this.id});

  // Factory method to create MachineData from JSON
  factory MachineSocketIDData.fromJson(Map<String, dynamic> json) {
    return MachineSocketIDData(
      machineName: json['machineName'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class MachineSocketIO {
  final String machineName;
  final int state;

  MachineSocketIO({required this.machineName, required this.state});

  @override
  String toString() {
    return 'MachineSocketIO(machineName: $machineName, state: $state)';
  }
}
