// Author : Shital Gayakwad
// Created date : 9 Feb 2024
// Description : Purchase order event

class CommonMailEvent {}

class BulkmailsendEvent extends CommonMailEvent {
  final List<List<dynamic>> excelData;
  final List<List<dynamic>> rejectedOrders;
  BulkmailsendEvent(
      {this.excelData = const [], this.rejectedOrders = const []});
}
