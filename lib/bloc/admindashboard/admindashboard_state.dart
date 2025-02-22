import '../../services/model/dashboard/dashboard_model.dart';

abstract class ADBState {}

class ADBinitialState extends ADBState {}

class ADBLoadingState extends ADBState {
  List<WorkstationStatusModel> workstationstatuslist = [];
  final List<CentrewiseenergyData> centrewiseenergyData;
  final List<EfficiencyData> centerOEEData;
  List<CentralOEE> centraloee = [];
  List<FactoryOEE> factoryOee = [];
  List<FactoryEfficency> factoryEfficency = [];
  List<EfficiencyData> centerEfficencyData = [];

  double shopefficiency = 0.0;
  double totalenergy = 0.0;
  double machineMonthwiseEnergyConsumption = 0;
  ADBLoadingState(
      {required this.workstationstatuslist,
      required this.centrewiseenergyData,
      required this.centerOEEData,
      required this.shopefficiency,
      required this.centraloee,
      required this.factoryOee,
      required this.factoryEfficency,
      required this.centerEfficencyData,
      required this.totalenergy,
      required this.machineMonthwiseEnergyConsumption});
}

abstract class ADBsecondState {}

class ADBsecondinitialState extends ADBsecondState {}

class ADBsecondLoadingState extends ADBsecondState {
  List<WorkstationStatusModel> workstationstatuslist;
  List<WorkstationStatusModel> workstationstatuslist2;
  List<MachinewiseenergyData> machinewiseenergyData;
  List<WorkstationStatusModel> cncmachineslist;
  List<WorkstationStatusModel> vmcmachineslist;
  List<WorkstationStatusModel> i700machineslist;
  List<WorkstationStatusModel> mazakmachineslist;
  List<WorkstationStatusModel> dmgmachineslist;
  List<EfficiencyData> wsefficiencyData;
  int buttonIndex;
  int selectedCentreBotton;
  Map<String, int> productionStatusMap;

  ADBsecondLoadingState({
    required this.workstationstatuslist,
    required this.workstationstatuslist2,
    required this.buttonIndex,
    required this.cncmachineslist,
    required this.vmcmachineslist,
    required this.i700machineslist,
    required this.mazakmachineslist,
    required this.dmgmachineslist,
    required this.wsefficiencyData,
    required this.machinewiseenergyData,
    required this.selectedCentreBotton,
    required this.productionStatusMap,
  });
}
