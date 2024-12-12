import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//var baseUrl = "https://192.168.0.91:8081/";
//var baseUrl = "https://erpx.datta-india.co.in:8081/";
//var baseUrl = "https://192.168.0.91:8081";

var wAPIURL = "http://192.168.0.55:3213";
String scanIcon = "assets/icon/ic_barcode_scan.png";

Future<bool> isLoading() async {
  await Future.delayed(const Duration(seconds: 3));
  return false;
}

Future<DateTime?> dateTimePicker(BuildContext context) {
  return showDatePicker(
      barrierDismissible: false,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1991),
      lastDate: DateTime(2050),
      initialEntryMode: DatePickerEntryMode.calendarOnly);
}

List<String> monthList = List.generate(12, (index) {
  final month = DateTime(2023, index + 1);
  return DateFormat.MMMM().format(month);
});

List<int> yearList = List.generate(30, (index) {
  return 2021 + index;
});

String get ageValidationMessage =>
    'This person is under age. \nPerson must be at least 18 years old to work in DATTA ENTERPRISES ';

class EmployeeWidgets {
  final List<String> honorificlist = [
    'Mr.',
    'Mrs.',
    'Miss',
    'Other',
  ];
}
