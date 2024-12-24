// Author : Shital Gayakwad
// Created Date : 12 April 2023
// Description : ERPX_PPC -> Machine status

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/ppc/machine_status/status_bloc.dart';
import '../../../bloc/ppc/machine_status/status_event.dart';
import '../../../bloc/ppc/machine_status/status_state.dart';
import '../../../services/repository/machine/machine_status_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../../utils/responsive.dart';
import '../../widgets/appbar.dart';
import '../../widgets/dropdown/month.dart';
import '../../widgets/table/custom_table.dart';
import '../common/server.dart';

class MachineStatus extends StatelessWidget {
  const MachineStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            CustomAppbar().appbar(context: context, title: 'Machine status'),
        body: SingleChildScrollView(
          child: MakeMeResponsiveScreen(
              horixontaltab: getmachineStatusUi(context: context),
              verticaltab: getmachineStatusUi(context: context),
              windows: getmachineStatusUi(context: context),
              linux: getmachineStatusUi(context: context),
              mobile: getmachineStatusUi(context: context)),
        ));
  }

  Widget getmachineStatusUi({required BuildContext context}) {
    Size size = MediaQuery.of(context).size;
    final blocProvider = BlocProvider.of<MachineStatusBloc>(context);
    blocProvider.add(MachineStatusLoadingEvents(
        const {},
        const {},
        const {},
        const {'isPeriodic': false, 'isMonth': false, 'isEmployee': false},
        '',
        const {}));
    return BlocBuilder<MachineStatusBloc, MachineStatusState>(
      builder: (context, state) {
        if (state is StatusLoadingState) {
          return SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      workcentreList(
                          state: state,
                          blocProvider: blocProvider,
                          size: size,
                          context: context),
                      workstationList(
                          size: size, state: state, blocProvider: blocProvider)
                    ],
                  ),
                ),
                if (state.workcentre.isNotEmpty)
                  periodicButtonList(
                      context: context,
                      state: state,
                      blocProvider: blocProvider),
                Center(
                    child: statusTable(
                        parentHeight: size.height,
                        parentWidth: size.width,
                        state: state))
              ],
            ),
          );
        } else if (state is StatusErrorState) {
          if (state.errorMessage == 'Server unreachable') {
            return Server().serverUnreachable(
                context: context, screenname: 'machineStatus');
          }
        }
        return const Text('');
      },
    );
  }

  SingleChildScrollView periodicButtonList(
      {required BuildContext context,
      required StatusLoadingState state,
      required MachineStatusBloc blocProvider}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            horizontalSpace(),
            InkWell(
              child: buttonName(
                  context: context,
                  buttonName: 'Periodic',
                  icon: Icon(
                    Icons.access_time_filled,
                    color: state.isButtonClicked.isNotEmpty
                        ? state.isButtonClicked['isPeriodic']
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.error
                        : Colors.black,
                  ),
                  isButtonClicked: state.isButtonClicked['isPeriodic']),
              onTap: () {
                blocProvider.add(MachineStatusLoadingEvents(
                    state.workcentre,
                    state.workstation,
                    state.selectedPeriod,
                    const {
                      'isPeriodic': true,
                      'isMonth': false,
                      'isEmployee': false
                    },
                    '',
                    state.employee));
                periodicDialog(
                    context: context, blocProvider: blocProvider, state: state);
              },
            ),
            horizontalSpace(),
            InkWell(
              child: buttonName(
                  context: context,
                  buttonName: 'Month',
                  icon: Icon(
                    Icons.calendar_month,
                    color: state.isButtonClicked.isNotEmpty
                        ? state.isButtonClicked['isMonth']
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.error
                        : Colors.black,
                  ),
                  isButtonClicked: state.isButtonClicked['isMonth']),
              onTap: () {
                blocProvider.add(MachineStatusLoadingEvents(
                    state.workcentre,
                    state.workstation,
                    const {},
                    const {
                      'isPeriodic': false,
                      'isMonth': true,
                      'isEmployee': false
                    },
                    state.monthSelection,
                    state.employee));
                monthDialog(
                    context: context, blocProvider: blocProvider, state: state);
              },
            ),
            horizontalSpace(),
            PopupMenuButton(
              child: buttonName(
                  context: context,
                  buttonName: state.employee.isNotEmpty
                      ? state.employee['name']
                      : 'Employee',
                  icon: Icon(
                    Icons.person,
                    color: state.isButtonClicked.isNotEmpty
                        ? state.isButtonClicked['isEmployee']
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.error
                        : Colors.black,
                  ),
                  isButtonClicked: state.isButtonClicked['isEmployee']),
              itemBuilder: (context) {
                return List.generate(
                    state.workcentreWiseEmpList.isNotEmpty
                        ? state.workcentreWiseEmpList.length
                        : 0,
                    (index) => PopupMenuItem(
                          child: Container(
                              height: 40,
                              width: 300,
                              color: state.employee['index'] == index
                                  ? AppColors.appTheme
                                  : AppColors.whiteTheme,
                              child: Center(
                                  child: Text(
                                state.workcentreWiseEmpList[index].employee
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ))),
                          onTap: () {
                            blocProvider.add(MachineStatusLoadingEvents(
                                state.workcentre,
                                state.workstation,
                                const {},
                                const {
                                  'isPeriodic': false,
                                  'isMonth': false,
                                  'isEmployee': true
                                },
                                '',
                                {
                                  'id': state
                                      .workcentreWiseEmpList[index].employeeId
                                      .toString(),
                                  'index': index,
                                  'name': state
                                      .workcentreWiseEmpList[index].employee
                                }));
                          },
                        ));
              },
            ),
            horizontalSpace(),
          ],
        ),
      ),
    );
  }

  Future<dynamic> monthDialog(
      {required BuildContext context,
      required MachineStatusBloc blocProvider,
      required StatusLoadingState state}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select month'),
          content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: MonthDropDown(
                  onValueSelected: (Map<String, dynamic> value) {
                    int month = value['month-index'] + 1;
                    String concatDate =
                        '${value['year']}-${month.toString()}-01';
                    blocProvider.add(MachineStatusLoadingEvents(
                        state.workcentre,
                        state.workstation,
                        const {},
                        const {
                          'isPeriodic': false,
                          'isMonth': true,
                          'isEmployee': false
                        },
                        concatDate,
                        state.employee));
                  },
                ),
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'))
          ],
        );
      },
    );
  }

  Future<dynamic> periodicDialog(
      {required BuildContext context,
      required MachineStatusBloc blocProvider,
      required StatusLoadingState state}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController fromController = TextEditingController();
        TextEditingController toController = TextEditingController();
        return AlertDialog(
          title: const Center(child: Text('Select Spacific period')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  readOnly: true,
                  controller: fromController,
                  decoration: InputDecoration(
                    hintText: 'From',
                    border: QuickFixUi.makeTextFieldCircular(),
                  ),
                  onChanged: (value) {},
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now());
                    if (pickedDate != null) {
                      fromController.text =
                          pickedDate.toString().substring(0, 10);
                    }
                  },
                ),
                verticalSpace(),
                TextField(
                  readOnly: true,
                  controller: toController,
                  decoration: InputDecoration(
                    hintText: 'To',
                    border: QuickFixUi.makeTextFieldCircular(),
                  ),
                  onChanged: (value) {},
                  onTap: () async {
                    if (fromController.text == '') {
                      QuickFixUi.errorMessage(
                          'Select from date first', context);
                    } else {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime.now());
                      final fromDate = DateTime.parse(fromController.text);
                      if (pickedDate != null) {
                        if (pickedDate.isAtSameMomentAs(fromDate) ||
                            pickedDate.isAfter(fromDate)) {
                          toController.text =
                              pickedDate.toString().substring(0, 10);
                        } else {
                          QuickFixUi.errorMessage(
                              'To date must be greater than from date',
                              context);
                        }
                      }
                    }
                  },
                ),
                verticalSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          if (fromController.text == '') {
                            return QuickFixUi.errorMessage(
                                'From date not found', context);
                          } else if (toController.text == '') {
                            return QuickFixUi.errorMessage(
                                'To date not found', context);
                          } else {
                            blocProvider.add(MachineStatusLoadingEvents(
                                state.workcentre,
                                state.workstation,
                                {
                                  'From': fromController.text,
                                  'To': toController.text
                                },
                                const {
                                  'isPeriodic': true,
                                  'isMonth': false,
                                  'isEmployee': false
                                },
                                state.monthSelection,
                                state.employee));
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.appTheme,
                            ),
                            child: const Center(
                                child: Text(
                              'OK',
                              style: TextStyle(color: AppColors.whiteTheme),
                            )))),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.appTheme,
                            ),
                            child: const Center(
                                child: Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.whiteTheme),
                            ))))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox verticalSpace() {
    return const SizedBox(
      height: 20,
    );
  }

  Container buttonName(
      {required String buttonName,
      required Icon icon,
      required bool isButtonClicked,
      required BuildContext context}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isButtonClicked == true
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.errorContainer,
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            icon,
            horizontalSpace(),
            Text(
              buttonName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isButtonClicked == true
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.error),
            )
          ],
        ),
      ),
    );
  }

  SizedBox horizontalSpace() {
    return const SizedBox(
      width: 10,
    );
  }

  statusTable(
      {required double parentHeight,
      required double parentWidth,
      required StatusLoadingState state}) {
    return state.machineStatus.isEmpty
        ? Container(
            height: state.workcentre.isNotEmpty ? 50 : parentHeight - 140,
            margin: const EdgeInsets.only(top: 250),
            child: const Center(
                child: Text(
              'Data not found',
              style: TextStyle(
                  color: AppColors.appTheme,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
          )
        : SizedBox(
            height: state.workcentre.isNotEmpty
                ? parentHeight - 200
                : parentHeight - 140,
            child: StreamBuilder<bool>(
                stream: MachineStatusRepository().delayedStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.appTheme,
                          ),
                        ));
                  } else if (snapshot.hasData && snapshot.data == true) {
                    return CustomTable(
                        tablewidth: parentWidth,
                        tableheight: parentHeight,
                        showIndex: true,
                        rowHeight: 50,
                        columnWidth: Platform.isAndroid ? 116.6 : 100,
                        enableRowBottomBorder: true,
                        tableheaderColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        headerStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        column: [
                          ColumnData(label: 'Product'),
                          ColumnData(label: 'PO No.'),
                          ColumnData(label: 'Line No.'),
                          ColumnData(label: 'PO Qty'),
                          ColumnData(label: 'Produced Qty'),
                          ColumnData(label: 'Rejected Qty'),
                          ColumnData(label: 'Start time'),
                          ColumnData(label: 'End time'),
                          ColumnData(label: 'Workstation'),
                          ColumnData(label: 'Operator'),
                          ColumnData(label: 'Status'),
                        ],
                        rows: state.machineStatus
                            .map((e) => RowData(cell: [
                                  TableDataCell(
                                      label: Text(e.product.toString().trim())),
                                  TableDataCell(
                                      label: Text(e.po.toString().trim())),
                                  TableDataCell(label: Text(e.line.toString())),
                                  TableDataCell(
                                      label: Text(e.poqty.toString())),
                                  TableDataCell(
                                      label: Text(e.okqty.toString())),
                                  TableDataCell(
                                      label: Text(e.rejectedQty.toString())),
                                  TableDataCell(
                                      label: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Text(DateTime.parse(
                                                e.startprocesstime.toString())
                                            .toLocal()
                                            .toString()
                                            .substring(0, 10)),
                                        Text(DateTime.parse(
                                                e.startprocesstime.toString())
                                            .toLocal()
                                            .toString()
                                            .substring(11, 19)),
                                      ],
                                    ),
                                  )),
                                  TableDataCell(
                                      label: e.endprocesstime == null
                                          ? const Text(
                                              'NA',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: Column(
                                                children: [
                                                  Text(DateTime.parse(e
                                                          .endprocesstime
                                                          .toString())
                                                      .toLocal()
                                                      .toString()
                                                      .substring(0, 10)),
                                                  Text(DateTime.parse(e
                                                          .endprocesstime
                                                          .toString())
                                                      .toLocal()
                                                      .toString()
                                                      .substring(11, 19)),
                                                ],
                                              ),
                                            )),
                                  TableDataCell(
                                      label: Text(
                                          e.workstation.toString().trim())),
                                  TableDataCell(
                                      label: Text(
                                    e.employeename.toString().trim(),
                                    textAlign: TextAlign.center,
                                  )),
                                  TableDataCell(
                                      label: e.endprocessflag == 0
                                          ? const Text(
                                              'In Progress',
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Text(
                                              'Completed',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                ]))
                            .toList());
                  } else {
                    return const SizedBox(
                      child: Text('Data not found'),
                    );
                  }
                }));
  }

  Container workstationList(
      {required Size size,
      required StatusLoadingState state,
      required MachineStatusBloc blocProvider}) {
    return Container(
      width: size.width - (size.width < 800 ? 150 : 310),
      margin: const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.appTheme,
          width: 2,
        ),
      ),
      child: ListView.builder(
        itemCount: state.workstationsList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            color: state.workstation['index'] == index
                ? AppColors.appTheme
                : AppColors.secondarybackgroundColor,
            margin: const EdgeInsets.only(left: 5, bottom: 5, top: 5, right: 5),
            child: Center(
              child: TextButton(
                child: Text(
                  state.workstationsList[index].code.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: state.workstation['index'] == index
                          ? AppColors.whiteTheme
                          : Colors.black),
                ),
                onPressed: () {
                  blocProvider.add(MachineStatusLoadingEvents(
                      state.workcentre,
                      {
                        'id': state.workstationsList[index].id.toString(),
                        'code': state.workstationsList[index].code.toString(),
                        'index': index
                      },
                      const {},
                      const {
                        'isPeriodic': false,
                        'isMonth': false,
                        'isEmployee': false
                      },
                      '',
                      const {}));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Container workcentreList(
      {required StatusLoadingState state,
      required MachineStatusBloc blocProvider,
      required Size size,
      required BuildContext context}) {
    return Container(
      width: size.width < 800 ? 120 : 280,
      margin: const EdgeInsets.only(left: 10, right: 10),
      color: AppColors.appTheme,
      child: PopupMenuButton(
        child: SizedBox(
            height: 50,
            child: Center(
                child: Text(
              state.workcentre.isEmpty
                  ? 'Select Workcentre'
                  : state.workcentre['code'].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColors.whiteTheme),
            ))),
        itemBuilder: (context) {
          return List.generate(state.workcentreList.length, (index) {
            return PopupMenuItem(
              child: Container(
                  height: 40,
                  width: 300,
                  color: state.workcentre['index'] == index
                      ? AppColors.appTheme
                      : AppColors.whiteTheme,
                  child: Center(
                      child: Text(
                    state.workcentreList[index].code.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: state.workcentre['index'] == index
                            ? AppColors.whiteTheme
                            : AppColors.blackColor),
                  ))),
              onTap: () {
                blocProvider.add(MachineStatusLoadingEvents(
                    {
                      'id': state.workcentreList[index].id.toString(),
                      'code': state.workcentreList[index].code.toString(),
                      'index': index
                    },
                    const {},
                    const {},
                    const {
                      'isPeriodic': false,
                      'isMonth': false,
                      'isEmployee': false
                    },
                    '',
                    const {}));
              },
            );
          });
        },
      ),
    );
  }

  Widget invisible() {
    return const Center(
        child: Text('This screen is not available for this platform'));
  }
}
