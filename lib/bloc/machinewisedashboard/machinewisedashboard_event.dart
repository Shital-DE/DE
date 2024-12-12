import '../../services/model/dashboard/dashboard_model.dart';

abstract class MWD {}

class MWDEvent extends MWD {
  final WorkstationStatusModel workstationstatus;
  int switchIndex = 1;
  String chooseDate = '';
  MWDEvent(
      {required this.workstationstatus,
      required this.switchIndex,
      required this.chooseDate});
}
