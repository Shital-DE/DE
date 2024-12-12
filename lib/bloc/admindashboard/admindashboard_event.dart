abstract class ADB {}

class ADBEvent extends ADB {
  // final int buttonIndex;
  ADBEvent(//{required this.buttonIndex}
      );
}

abstract class ADBsecond {}

class ADBsecondEvent extends ADBsecond {
  final int buttonIndex;
  int selectedCentreBotton = 0, dashboardindex = 0;
  ADBsecondEvent(
      {required this.buttonIndex,
      required this.selectedCentreBotton,
      required this.dashboardindex});
}

/*
class ADBsecondProductionStatusUpdatedEvent extends ADBsecondEvent {
  final Map<String, int> productionStatusMap;

  ADBsecondProductionStatusUpdatedEvent(
      {required super.buttonIndex,
      required super.selectedCentreBotton,
      required super.dashboardindex,
      required this.productionStatusMap});
}


abstract class SocketioE {}

class SocketioEvent extends SocketioE {
  // final int buttonIndex;
  SocketioEvent();
}
*/