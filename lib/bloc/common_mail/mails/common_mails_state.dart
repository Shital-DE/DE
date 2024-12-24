// Author : Shital Gayakwad
// Created date : 9 Feb 2024
// Description : Purchase order state

class CommonMailState {}

class CommonMailInitialState extends CommonMailState {}

class UploadOrderState extends CommonMailState {
  final List<List<dynamic>> excelData;
  final List<List<dynamic>> rejectedOrders;
  final String token, userId;
  UploadOrderState(
      {required this.excelData,
      required this.token,
      required this.userId,
      required this.rejectedOrders});
}
