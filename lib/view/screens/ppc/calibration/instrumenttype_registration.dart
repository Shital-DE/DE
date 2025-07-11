// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Instrument type registration
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../services/repository/quality/calibration_repository.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/table/custom_table.dart';

class InstrumentTypeRegistration extends StatelessWidget {
  const InstrumentTypeRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height,
        screenWidth = MediaQuery.of(context).size.width;
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentTypeRegistrationEvent());
    return Scaffold(
      body: MakeMeResponsiveScreen(
        horixontaltab: instrumentTypeRegistrationScreen(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            blocProvider: blocProvider),
        windows: instrumentTypeRegistrationScreen(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            blocProvider: blocProvider),
        linux: instrumentTypeRegistrationScreen(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            blocProvider: blocProvider),
      ),
    );
  }

  Center instrumentTypeRegistrationScreen(
      {required double screenWidth,
      required double screenHeight,
      required CalibrationBloc blocProvider}) {
    double rowHeight = Platform.isAndroid ? 45 : 35;
    return Center(child: BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      TextEditingController instrumentType = TextEditingController();
      TextEditingController manufacturer = TextEditingController();
      if (state is InstrumentTypeRegistrationState) {
        return ListView(
          children: [
            QuickFixUi.verticalSpace(height: 10),
            headers(screenWidth: screenWidth, context: context),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: (screenWidth - 20) / 2,
                    height: screenHeight - 210,
                    child: Column(
                      children: [
                        instrumentCategoryRegistration(
                            instrumentType: instrumentType,
                            context: context,
                            state: state,
                            blocProvider: blocProvider),
                        instrumentCategoryData(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            context: context,
                            state: state,
                            blocProvider: blocProvider,
                            rowHeight: rowHeight)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (screenWidth - 20) / 2,
                    height: screenHeight - 210,
                    child: Column(
                      children: [
                        manufacturerRegistration(
                            manufacturer: manufacturer,
                            context: context,
                            state: state,
                            instrumentType: instrumentType,
                            blocProvider: blocProvider),
                        manufacturerDataTable(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            context: context,
                            state: state,
                            blocProvider: blocProvider,
                            rowHeight: rowHeight)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      } else {
        return const Stack();
      }
    }));
  }

  Container manufacturerDataTable(
      {required double screenWidth,
      required double screenHeight,
      required BuildContext context,
      required InstrumentTypeRegistrationState state,
      required CalibrationBloc blocProvider,
      required double rowHeight}) {
    return Container(
      width: (screenWidth - 20) / 2,
      height: screenHeight - 260,
      margin: const EdgeInsets.only(top: 10, right: 10),
      child: CustomTable(
          tablewidth: (screenWidth - 20) / 2,
          tableheight: screenHeight - 210,
          showIndex: true,
          rowHeight: rowHeight,
          tableOutsideBorder: true,
          enableRowBottomBorder: true,
          tableheaderColor: Theme.of(context).colorScheme.errorContainer,
          headerStyle: AppTheme.labelTextStyle(isFontBold: true),
          column: [
            ColumnData(
                width: ((screenWidth - 20) / 2) - (112 + (rowHeight * 2)),
                label: 'Manufacturer name'),
            ColumnData(width: 100, label: 'Action')
          ],
          rows: state.manufacturerData
              .map((e) => RowData(cell: [
                    TableDataCell(
                        width:
                            ((screenWidth - 20) / 2) - (112 + (rowHeight * 2)),
                        label: Text(
                          e.manufacturer.toString(),
                          style: AppTheme.labelTextStyle(),
                        )),
                    TableDataCell(
                        width: 100,
                        label: IconButton(
                            onPressed: () async {
                              String response = await CalibrationRepository()
                                  .deleteManufacturer(
                                      token: state.token,
                                      payload: {'id': e.id});
                              if (response == 'Updated successfully') {
                                QuickFixUi.successMessage(
                                    'Deleted successfully', context);
                                blocProvider
                                    .add(InstrumentTypeRegistrationEvent());
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            )))
                  ]))
              .toList()),
    );
  }

  SizedBox manufacturerRegistration(
      {required TextEditingController manufacturer,
      required BuildContext context,
      required InstrumentTypeRegistrationState state,
      required TextEditingController instrumentType,
      required CalibrationBloc blocProvider}) {
    return SizedBox(
        height: 40,
        child: Row(children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: manufacturer,
              textAlign: TextAlign.center,
              style: AppTheme.labelTextStyle(),
              decoration: InputDecoration(
                hintText: 'Manufacturer name',
                contentPadding:
                    const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              ),
              onChanged: (value) {
                manufacturer.text = value.toString();
              },
            ),
          ),
          const SizedBox(width: 20),
          FilledButton(
              onPressed: () async {
                if (manufacturer.text == '') {
                  QuickFixUi.errorMessage(
                      'Manufacturer name not found.', context);
                } else {
                  confirmManufacturerRegistration(
                      context: context,
                      state: state,
                      manufacturer: manufacturer,
                      instrumentType: instrumentType,
                      blocProvider: blocProvider);
                }
              },
              child: Text(
                'SUBMIT',
                style: TextStyle(fontSize: Platform.isAndroid ? 14 : 12),
              ))
        ]));
  }

  Future<dynamic> confirmManufacturerRegistration(
      {required BuildContext context,
      required InstrumentTypeRegistrationState state,
      required TextEditingController manufacturer,
      required TextEditingController instrumentType,
      required CalibrationBloc blocProvider}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: const SizedBox(
                height: 25,
                child: Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                )),
            actions: [
              FilledButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    String response = await CalibrationRepository()
                        .registerManufacturer(token: state.token, payload: {
                      'userid': state.userId,
                      'descrption': manufacturer.text.trim()
                    });
                    if (response == 'Inserted successfully') {
                      QuickFixUi.successMessage(
                          'Inserted successfully', context);
                      instrumentType.text = '';
                      blocProvider.add(InstrumentTypeRegistrationEvent());
                      navigator.pop();
                    }
                  },
                  child: const Text('Yes')),
              FilledButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  Container instrumentCategoryData(
      {required double screenWidth,
      required double screenHeight,
      required BuildContext context,
      required InstrumentTypeRegistrationState state,
      required CalibrationBloc blocProvider,
      required double rowHeight}) {
    return Container(
      width: (screenWidth - 20) / 2,
      height: screenHeight - 260,
      margin: const EdgeInsets.only(top: 10, right: 10),
      child: CustomTable(
          tablewidth: (screenWidth - 20) / 2,
          tableheight: screenHeight - 210,
          showIndex: true,
          rowHeight: rowHeight,
          tableOutsideBorder: true,
          enableRowBottomBorder: true,
          tableheaderColor: Theme.of(context).primaryColorLight,
          headerStyle: AppTheme.labelTextStyle(isFontBold: true),
          column: [
            ColumnData(
                width: ((screenWidth - 20) / 2) - (112 + (rowHeight * 2)),
                label: 'Instrument type'),
            ColumnData(width: 100, label: 'Action')
          ],
          rows: state.instrumentsTypeList
              .map((e) => RowData(cell: [
                    TableDataCell(
                        width:
                            ((screenWidth - 20) / 2) - (112 + (rowHeight * 2)),
                        label: Text(
                          e.description.toString(),
                          style: AppTheme.labelTextStyle(),
                        )),
                    TableDataCell(
                        width: 100,
                        label: IconButton(
                            onPressed: () async {
                              String response = await CalibrationRepository()
                                  .deleteInstrumentType(
                                      token: state.token,
                                      payload: {'id': e.id});
                              if (response == 'Updated successfully') {
                                QuickFixUi.successMessage(
                                    'Deleted successfully', context);
                                blocProvider
                                    .add(InstrumentTypeRegistrationEvent());
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            )))
                  ]))
              .toList()),
    );
  }

  SizedBox instrumentCategoryRegistration(
      {required TextEditingController instrumentType,
      required BuildContext context,
      required InstrumentTypeRegistrationState state,
      required CalibrationBloc blocProvider}) {
    return SizedBox(
        height: 40,
        child: Row(children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: instrumentType,
              textAlign: TextAlign.center,
              style: AppTheme.labelTextStyle(),
              decoration: InputDecoration(
                hintText: 'Instrument category',
                contentPadding:
                    const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              ),
              onChanged: (value) {
                instrumentType.text = value.toString();
              },
            ),
          ),
          const SizedBox(width: 20),
          FilledButton(
              onPressed: () async {
                if (instrumentType.text == '') {
                  QuickFixUi.errorMessage(
                      'Instrument type not found.', context);
                } else {
                  confirmationDialog(
                      context: context,
                      state: state,
                      instrumentType: instrumentType,
                      blocProvider: blocProvider);
                }
              },
              child: Text(
                'SUBMIT',
                style: TextStyle(fontSize: Platform.isAndroid ? 14 : 12),
              ))
        ]));
  }

  Future<dynamic> confirmationDialog(
      {required BuildContext context,
      required InstrumentTypeRegistrationState state,
      required TextEditingController instrumentType,
      required CalibrationBloc blocProvider}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: const SizedBox(
                height: 25,
                child: Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                )),
            actions: [
              FilledButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    String response = await CalibrationRepository()
                        .registerInstrumentType(token: state.token, payload: {
                      'userid': state.userId,
                      'descrption': instrumentType.text.trim()
                    });
                    if (response == 'Inserted successfully') {
                      QuickFixUi.successMessage(
                          'Inserted successfully', context);
                      instrumentType.text = '';
                      blocProvider.add(InstrumentTypeRegistrationEvent());
                      navigator.pop();
                    }
                  },
                  child: const Text('Yes')),
              FilledButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  Row headers({required double screenWidth, required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            height: 40,
            width: screenWidth / 2,
            child: Text(
              'Instrument categories registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Platform.isAndroid ? 16 : 14,
                  color: Theme.of(context).colorScheme.primary),
            )),
        SizedBox(
            height: 40,
            width: screenWidth / 2,
            child: Text(
              'Manufacturer registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Platform.isAndroid ? 16 : 14,
                  color: Theme.of(context).colorScheme.primary),
            ))
      ],
    );
  }
}
