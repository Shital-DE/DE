// ignore_for_file: use_build_context_synchronously
// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration screen
// Modification : 11 June 2025 by Shital Gayakwad.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../../services/model/quality/calibration_model.dart';
import '../../../../../services/repository/quality/calibration_repository.dart';
import '../../../../../utils/app_theme.dart';
import '../../../../../utils/common/quickfix_widget.dart';
import '../../../../../utils/responsive.dart';
import '../../../../widgets/PDF/image_to_pdf_generator.dart';
import '../../../../widgets/date_range_picker.dart';
import '../../../../widgets/table/custom_table.dart';

class InwardInstruments extends StatelessWidget {
  const InwardInstruments({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InwardInstrumentsForCalibrationEvent());
    return Scaffold(
      body: MakeMeResponsiveScreen(
          horixontaltab:
              inwarInstrumentsTable(size: size, blocProvider: blocProvider),
          windows:
              inwarInstrumentsTable(size: size, blocProvider: blocProvider),
          linux: inwarInstrumentsTable(size: size, blocProvider: blocProvider)),
    );
  }

  BlocBuilder<CalibrationBloc, CalibrationState> inwarInstrumentsTable(
      {required Size size, required CalibrationBloc blocProvider}) {
    StreamController<InwardInstrumentsModel> inwardingInstrument =
        StreamController<InwardInstrumentsModel>.broadcast();
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is InwardInstrumentsState &&
          state.inwardInstrumentsList.isNotEmpty) {
        double tableHeight = (state.inwardInstrumentsList.length + 1) * 45;
        return Container(
          width: size.width,
          height: tableHeight,
          margin: const EdgeInsets.all(10),
          child: CustomTable(
              tablewidth: size.width,
              tableheight: tableHeight,
              rowHeight: 45,
              showIndex: true,
              columnWidth: Platform.isAndroid
                  ? size.width / 9.2
                  : (size.width > 1300)
                      ? size.width / 8.8
                      : size.width / 9.2,
              tableheaderColor: Colors.white,
              headerStyle: TextStyle(
                  fontSize: Platform.isAndroid ? 15 : 13,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
              tableOutsideBorder: true,
              enableHeaderBottomBorder: true,
              enableRowBottomBorder: true,
              borderThickness: .5,
              headerBorderThickness: .5,
              headerBorderColor: Colors.black,
              column: [
                ColumnData(label: 'Instrument name'),
                ColumnData(label: 'Instrument type'),
                ColumnData(label: 'Card number', width: 100),
                ColumnData(label: 'Measuring range'),
                ColumnData(label: 'Start date'),
                ColumnData(label: 'Due date'),
                ColumnData(label: 'Frequency'),
                ColumnData(label: 'Certificate'),
                ColumnData(label: 'Action'),
              ],
              rows: state.inwardInstrumentsList
                  .map((e) => RowData(cell: [
                        TableDataCell(
                            label: Text(
                          e.instrumentname.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                        TableDataCell(
                            label: Text(
                          e.instrumenttype.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                        TableDataCell(
                            width: 100,
                            label: Text(
                              e.cardnumber.toString(),
                              textAlign: TextAlign.center,
                              style: AppTheme.labelTextStyle(),
                            )),
                        TableDataCell(
                            label: Text(
                          e.measuringrange.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                        TableDataCell(
                            label: startDate(
                                context: context,
                                inwardingInstrument: inwardingInstrument,
                                outsourcedInstruments: e)),
                        TableDataCell(
                            label: dueDate(
                                context: context,
                                inwardingInstrument: inwardingInstrument,
                                outsourcedInstruments: e)),
                        TableDataCell(
                            label: frequencyWidget(
                                state: state,
                                context: context,
                                inwardingInstrument: inwardingInstrument,
                                outsourcedInstruments: e)),
                        TableDataCell(label: const ImageToPDFGenerator()),
                        TableDataCell(
                            label: Padding(
                          padding: const EdgeInsets.only(top: 7, bottom: 7),
                          child: submitButton(
                              inwardingInstrument: inwardingInstrument,
                              state: state,
                              e: e,
                              blocProvider: blocProvider),
                        ))
                      ]))
                  .toList()),
        );
      } else {
        return const Center(
          child: Text(
            'No instruments are outsourced.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        );
      }
    });
  }

  StreamBuilder<InwardInstrumentsModel> submitButton(
      {required StreamController<InwardInstrumentsModel> inwardingInstrument,
      required InwardInstrumentsState state,
      required OutsourcedInstrumentsModel e,
      required CalibrationBloc blocProvider}) {
    return StreamBuilder<InwardInstrumentsModel>(
        stream: inwardingInstrument.stream,
        builder: (context, snapshot) {
          return FilledButton(
              onPressed: () async {
                if (snapshot.data != null) {
                  if (snapshot.data!.startdate == '') {
                    QuickFixUi.errorMessage('Start date not found.', context);
                  } else if (snapshot.data!.duedate == '') {
                    QuickFixUi.errorMessage('Due date not found.', context);
                  } else {
                    try {
                      final Directory directory =
                          await getApplicationDocumentsDirectory();
                      final String path = directory.path;
                      final File file = File('$path/certificate.pdf');
                      if (await file.exists()) {
                        QuickFixUi().showProcessing(context: context);
                        List<int> pdfBytes = await file.readAsBytes();
                        String certificateId = await CalibrationRepository()
                            .instrumentsCertificatesRegistration(
                                token: state.token,
                                payload: {
                              'instrumentname':
                                  '${e.instrumentname.toString().trim()}_${e.cardnumber}.pdf',
                              'postgresql_id': e.instrumentcalibrationscheduleId
                                  .toString()
                                  .trim(),
                              'data': base64Encode(pdfBytes)
                            });
                        if (certificateId.length == 24) {
                          String response = await CalibrationRepository()
                              .inwardSpacificInstrument(
                                  token: state.token,
                                  payload: {
                                'startdate': snapshot.data!.startdate,
                                'duedate': snapshot.data!.duedate,
                                'frequency': snapshot.data!.frequency,
                                'certificateid': certificateId,
                                'id': e.instrumentcalibrationscheduleId
                              });
                          if (response == 'Updated successfully') {
                            Navigator.of(context).pop();
                            blocProvider
                                .add(OutwardInstrumentsForCalibrationEvent());
                            await file.delete();
                            Future.delayed(const Duration(seconds: 1), () {
                              blocProvider
                                  .add(InwardInstrumentsForCalibrationEvent());
                            });
                          }
                        }
                      } else {
                        QuickFixUi.errorMessage(
                            'Certificate not found.', context);
                      }
                    } catch (e) {
                      //
                    }
                  }
                } else {
                  QuickFixUi.errorMessage('Start date not found.', context);
                }
              },
              child: const Text('Submit'));
        });
  }

  frequencyWidget(
      {required InwardInstrumentsState state,
      required BuildContext context,
      required StreamController<InwardInstrumentsModel> inwardingInstrument,
      required OutsourcedInstrumentsModel outsourcedInstruments}) {
    return StreamBuilder<InwardInstrumentsModel>(
        stream: inwardingInstrument.stream,
        builder: (context, snapshot) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: DropdownSearch<Frequency>(
              items: state.frequencyList,
              itemAsString: (item) => item.frequency.toString(),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(
                      item.frequency.toString(),
                      style: AppTheme.labelTextStyle(),
                    ),
                  );
                },
              ),
              onChanged: (value) async {
                if (value!.frequency == '0') {
                  QuickFixUi.errorMessage(
                      'Choose a frequency of at least one month.', context);
                } else {
                  if (snapshot.data != null &&
                      snapshot.data!.startdate.toString() != '') {
                    String dueDate = await DateRangePickerHelper()
                        .generateDueDate(
                            startdate: snapshot.data!.startdate.toString(),
                            frequency: value.frequency!);
                    inwardingInstrument.add(
                      InwardInstrumentsModel(
                          historyId: snapshot.data!.historyId,
                          instrumentScheduleId:
                              snapshot.data!.instrumentScheduleId,
                          startdate: snapshot.data!.startdate,
                          duedate: dueDate,
                          frequency: value.id.toString()),
                    );
                  } else {
                    QuickFixUi.errorMessage('Select start date first', context);
                  }
                }
              },
            ),
          );
        });
  }

  dueDate(
      {required BuildContext context,
      required StreamController<InwardInstrumentsModel> inwardingInstrument,
      required OutsourcedInstrumentsModel outsourcedInstruments}) {
    return StreamBuilder<InwardInstrumentsModel>(
        stream: inwardingInstrument.stream,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                snapshot.data != null &&
                        snapshot.data!.duedate != null &&
                        outsourcedInstruments.id == snapshot.data!.historyId
                    ? snapshot.data!.duedate.toString()
                    : '',
                style: AppTheme.labelTextStyle(),
              ),
              IconButton(
                  onPressed: () async {
                    try {
                      DateTime? pickedDate =
                          await QuickFixUi().dateTimePicker(context);
                      if (pickedDate.toString() != '') {
                        if (snapshot.data != null) {
                          inwardingInstrument.add(
                            InwardInstrumentsModel(
                                historyId: snapshot.data!.historyId,
                                instrumentScheduleId:
                                    snapshot.data!.instrumentScheduleId,
                                startdate: snapshot.data!.startdate,
                                duedate:
                                    pickedDate.toString().substring(0, 10)),
                          );
                        }
                      }
                    } catch (e) {
                      QuickFixUi.errorMessage(e.toString(), context);
                    }
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).primaryColor,
                  ))
            ],
          );
        });
  }

  startDate(
      {required BuildContext context,
      required StreamController<InwardInstrumentsModel> inwardingInstrument,
      required OutsourcedInstrumentsModel outsourcedInstruments}) {
    return StreamBuilder<InwardInstrumentsModel>(
        stream: inwardingInstrument.stream,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                snapshot.data != null &&
                        outsourcedInstruments.id == snapshot.data!.historyId
                    ? snapshot.data!.startdate.toString()
                    : '',
                style: AppTheme.labelTextStyle(),
              ),
              IconButton(
                  onPressed: () async {
                    try {
                      DateTime? pickedDate =
                          await QuickFixUi().dateTimePicker(context);
                      if (pickedDate.toString() != '') {
                        inwardingInstrument.add(InwardInstrumentsModel(
                            historyId: outsourcedInstruments.id,
                            instrumentScheduleId: outsourcedInstruments
                                .instrumentcalibrationscheduleId,
                            startdate: pickedDate.toString().substring(0, 10)));
                      }
                    } catch (e) {
                      QuickFixUi.errorMessage(e.toString(), context);
                    }
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).primaryColor,
                  ))
            ],
          );
        });
  }
}
