import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerHelper {
  Future<String?> rangeDatePicker(BuildContext context) async {
    String dateStr = '';
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 500,
            height: 300,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  dateStr =
                      '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} TO '
                      '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedDates: [DateTime.now(), DateTime.now()],
              confirmText: "OK",
              cancelText: "CANCEL",
              showActionButtons: true,
              onSubmit: (value) {
                if (dateStr.isNotEmpty) {
                  Navigator.of(context).pop(dateStr);
                } else {
                  Navigator.of(context).pop("");
                }
              },
              onCancel: () {
                Navigator.of(context).pop("");
              },
            ),
          ),
        );
      },
    );
  }

  Future<String> generateDueDate(
      {required String startdate, required String frequency}) async {
    DateTime start = DateTime.parse(startdate);
    List<String> parts = frequency.split(' ');
    int selectedVal = int.parse(parts[0]);
    if (parts[1] == 'Year') {
      int dueYear = start.year + selectedVal;
      int dueMonth = start.month;
      int dueDay = start.day;
      if (start.month == 2 && start.day == 29) {
        if (!((dueYear % 4 == 0 && dueYear % 100 != 0) ||
            (dueYear % 400 == 0))) {
          dueMonth = 3;
          dueDay = 1;
        }
      }
      return '$dueYear-${dueMonth.toString().padLeft(2, '0')}-${dueDay.toString().padLeft(2, '0')}';
    } else {
      int dueMonth = start.month + selectedVal;
      int dueYear = start.year + (dueMonth - 1) ~/ 12;
      dueMonth = (dueMonth - 1) % 12 + 1;
      int maxDay = DateTime(dueYear, dueMonth + 1, 0).day;
      int dueDay = start.day > maxDay ? maxDay : start.day;
      return '$dueYear-${dueMonth.toString().padLeft(2, '0')}-${dueDay.toString().padLeft(2, '0')}';
    }
  }
}
