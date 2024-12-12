import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import 'dropdown_bloc.dart';

class MonthDropDown extends StatelessWidget {
  final ValueChanged<Map<String, dynamic>> onValueSelected;
  const MonthDropDown({super.key, required this.onValueSelected});

  @override
  Widget build(BuildContext context) {
    double conWidth = 200;
    return BlocProvider(
      create: (context) => MonthDropDownBloc(),
      child: Builder(builder: (innercontext) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          yearDropDown(context: innercontext, width: conWidth),
          monthDropDown(context: innercontext, width: conWidth),
          BlocBuilder<MonthDropDownBloc, MonthDropDownState>(
            builder: (context, state) {
              return TextButton(
                  onPressed: () {
                    if (state is MonthDropDownLoading) {
                      onValueSelected({
                        'month-index': state.monthSelection['index'],
                        'month-value': state.monthSelection['month'],
                        'year': state.yearSelection['year'],
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      height: 50,
                      width: 120,
                      color: AppColors.appTheme,
                      child: const Center(
                          child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ))));
            },
          )
        ]);
      }),
    );
  }

  Container monthDropDown(
      {required BuildContext context, required double width}) {
    final blocProvider = BlocProvider.of<MonthDropDownBloc>(context);
    return Container(
      width: width,
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: BlocBuilder<MonthDropDownBloc, MonthDropDownState>(
        builder: (context, state) {
          return PopupMenuButton(
            child: SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                  state is MonthDropDownLoading &&
                          state.monthSelection.isNotEmpty
                      ? state.monthSelection['month']
                      : 'Select Month',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ))),
            itemBuilder: (context) {
              List month = [
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
              ];
              if (state is MonthDropDownLoading) {
                String currentYear = DateTime.now().year.toString();
                int currentMonth = DateTime.now().month;
                return List.generate(month.length, (index) {
                  bool beforeSeptermber2022 =
                      state.yearSelection['year'].toString() == '2022' &&
                          index < 8;
                  bool afterCurrentMonth =
                      state.yearSelection['year'].toString() == currentYear &&
                          index >= currentMonth;
                  return PopupMenuItem(
                    child: Container(
                        height: 40,
                        width: 300,
                        color: state.monthSelection['index'] == index
                            ? AppColors.appTheme
                            : AppColors.whiteTheme,
                        child: Center(
                            child: Text(
                          month[index].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: beforeSeptermber2022 || afterCurrentMonth
                                  ? Colors.grey
                                  : Colors.black),
                        ))),
                    onTap: () {
                      if (beforeSeptermber2022) {
                        return QuickFixUi.errorMessage(
                            'Please select after September 2022', context);
                      } else if (afterCurrentMonth) {
                        return QuickFixUi.errorMessage(
                            'Please select before ${state.monthSelection['month']} $currentYear ',
                            context);
                      } else {
                        blocProvider.add(MonthDropDownInitialEvent(
                            {'index': index, 'month': month[index].toString()},
                            state.yearSelection));
                      }
                    },
                  );
                });
              } else {
                return [];
              }
            },
          );
        },
      ),
    );
  }

  //Year dropdown
  Container yearDropDown(
      {required BuildContext context, required double width}) {
    final blocProvider = BlocProvider.of<MonthDropDownBloc>(context);
    // Get the current year
    int currentYear = DateTime.now().year;
    return Container(
      width: width,
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: BlocBuilder<MonthDropDownBloc, MonthDropDownState>(
        builder: (context, state) {
          return PopupMenuButton(
            child: SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                  state is MonthDropDownLoading &&
                          state.yearSelection.isNotEmpty
                      ? state.yearSelection['year'].toString()
                      : 'Select Year',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ))),
            itemBuilder: (context) {
              List<String> year = List.generate(
                  currentYear - 2021, (index) => (2022 + index).toString());

              return List.generate(year.length, (index) {
                return PopupMenuItem(
                    child: Container(
                        height: 40,
                        width: 300,
                        color: state is MonthDropDownLoading &&
                                state.yearSelection['index'] == index
                            ? AppColors.appTheme
                            : AppColors.whiteTheme,
                        child: Center(
                            child: Text(
                          year[index].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ))),
                    onTap: () {
                      blocProvider.add(MonthDropDownInitialEvent(const {}, {
                        'index': index,
                        'year': year[index].toString(),
                      }));
                    });
              });
            },
          );
        },
      ),
    );
  }
}
