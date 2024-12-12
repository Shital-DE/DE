import '../../services/model/dashboard/dashboard_model.dart';
// import '../../view/screens/dashboard/admin/machinewise_dashboard.dart';

abstract class MWDState {}

class MWDinitialState extends MWDState {}

class MWDLoadingState extends MWDState {
  List<WorkstationStatusModel> workstationstatuslist = [];
  List<ProductiontimeData> productiontimeData = [];
  double machineenergy = 0, efficiency = 0, partcount = 0;
  String chooseDate = '';
  List<FeedData> feedData = [];
  List<MachineCurrentData> currentspikes = [];
  List<MachineVolatgeData> voltageData = [];
  List<ProductionCyclevalue> cs = [];
  List<Industry4WorkstationTagId> wstagid = [];
  //int switchValues = 0;
  int selectedShift = 1;
  String starttime = '';
  String endtime = '';
  String currentDate = '';
  String machinename = '';
  List<ProductionCyclevalue> productionCycleBarData = [];

  MWDLoadingState(
      {required this.workstationstatuslist,
      // // required this.centrewiseenergyData
      required this.feedData,
      required this.currentspikes,
      required this.productiontimeData,
      required this.machineenergy,
      required this.efficiency,
      required this.cs,
      required this.partcount,
      //required this.switchValues,
      required this.selectedShift,
      required this.starttime,
      required this.endtime,
      required this.currentDate,
      required this.chooseDate,
      required this.machinename,
      required this.voltageData,
      required this.wstagid,
      required this.productionCycleBarData});
}
