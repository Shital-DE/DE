abstract class ADB {}

class ADBEvent extends ADB {
  ADBEvent();
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
