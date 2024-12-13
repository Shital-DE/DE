// ignore_for_file: use_build_context_synchronously

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
    blocProvider.add(InwardInstrumentsEvent());
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
              columnWidth:
                  Platform.isAndroid ? size.width / 9.2 : size.width / 8.8,
              tableheaderColor: Colors.white,
              headerStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
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
                        )),
                        TableDataCell(
                            label: Text(
                          e.instrumenttype.toString(),
                          textAlign: TextAlign.center,
                        )),
                        TableDataCell(
                            width: 100,
                            label: Text(
                              e.cardnumber.toString(),
                              textAlign: TextAlign.center,
                            )),
                        TableDataCell(
                            label: Text(
                          e.measuringrange.toString(),
                          textAlign: TextAlign.center,
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
                          child: Row(
                            children: [
                              submitButton(
                                  inwardingInstrument: inwardingInstrument,
                                  state: state,
                                  e: e,
                                  blocProvider: blocProvider),
                              IconButton(
                                  padding: const EdgeInsets.only(bottom: 1),
                                  onPressed: () async {
                                    TextEditingController rejectedReason =
                                        TextEditingController();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: const Text(
                                                'Reject instrument',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                              content: DropdownSearch<
                                                  InstrumentRejectionReasons>(
                                                items: state.rejectionReasons,
                                                itemAsString: (item) =>
                                                    item.reason.toString(),
                                                onChanged: (value) {
                                                  rejectedReason.text =
                                                      value!.id.toString();
                                                },
                                              ),
                                              actions: [
                                                FilledButton(
                                                    onPressed: () async {
                                                      if (rejectedReason.text ==
                                                          '') {
                                                        QuickFixUi()
                                                            .showCustomDialog(
                                                                errorMessage:
                                                                    'Select rejection reason first.',
                                                                context:
                                                                    context);
                                                      } else {
                                                        String id = e
                                                                .instrumentcalibrationscheduleId
                                                                .toString()
                                                                .trim(),
                                                            startdate = e
                                                                .startdate
                                                                .toString()
                                                                .trim(),
                                                            duedate = e.duedate
                                                                .toString()
                                                                .trim(),
                                                            certificateMdocid =
                                                                e.certificateId
                                                                    .toString()
                                                                    .trim();
                                                        String deleteResponse =
                                                            await CalibrationRepository()
                                                                .rejectInstrument(
                                                                    token: state
                                                                        .token,
                                                                    payload: {
                                                              'id':
                                                                  id.toString(),
                                                              'isdeleted': true
                                                            });

                                                        if (deleteResponse ==
                                                            'Updated successfully') {
                                                          String response =
                                                              await CalibrationRepository()
                                                                  .addrejectedInstrumentToHistory(
                                                                      token: state
                                                                          .token,
                                                                      payload: {
                                                                'createdby':
                                                                    state
                                                                        .userId,
                                                                'instrumentcalibrationschedule_id':
                                                                    id,
                                                                'startdate':
                                                                    startdate,
                                                                'duedate':
                                                                    duedate,
                                                                'certificate_id':
                                                                    certificateMdocid,
                                                                'rejectionreason':
                                                                    rejectedReason
                                                                        .text,
                                                                'isdeleted':
                                                                    rejectedReason.text ==
                                                                            '81180939c054478587d54fab54f585fd'
                                                                        ? false
                                                                        : true
                                                              });

                                                          if (response ==
                                                              'Inserted successfully') {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            QuickFixUi
                                                                .successMessage(
                                                                    response,
                                                                    context);
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 1),
                                                                () {
                                                              blocProvider.add(
                                                                  InwardInstrumentsEvent());
                                                            });
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child:
                                                        const Text('Confirm')),
                                                FilledButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'))
                                              ]);
                                        });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: Platform.isAndroid ? 25 : 20,
                                  )),
                            ],
                          ),
                        ))
                      ]))
                  .toList()),
        );
      } else {
        return const Center(
          child: Text('No instruments are outsourced.'),
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
                            blocProvider.add(OutwardInstrumentsEvent());
                            await file.delete();
                            Future.delayed(const Duration(seconds: 1), () {
                              blocProvider.add(InwardInstrumentsEvent());
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
              Text(snapshot.data != null &&
                      snapshot.data!.duedate != null &&
                      outsourcedInstruments.id == snapshot.data!.historyId
                  ? snapshot.data!.duedate.toString()
                  : ''),
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
              Text(snapshot.data != null &&
                      outsourcedInstruments.id == snapshot.data!.historyId
                  ? snapshot.data!.startdate.toString()
                  : ''),
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
