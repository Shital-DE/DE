// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration screen
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/quality/calibration_model.dart';
import '../../../../services/repository/quality/calibration_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/PDF/image_to_pdf_generator.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';

class CalibrationStatus extends StatelessWidget {
  const CalibrationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentCalibrationStatusEvent());
    StreamController<List<CalibrationStatusModel>> selectedInstrumentsListData =
        StreamController<List<CalibrationStatusModel>>.broadcast();
    List<CalibrationStatusModel> selectedInstrumentsList = [];
    StreamController<List<CalibrationStatusModel>> searchedInstrumentsListData =
        StreamController<List<CalibrationStatusModel>>.broadcast();
    StreamController<int> rangeData = StreamController<int>.broadcast();
    return Scaffold(
      body: MakeMeResponsiveScreen(
        horixontaltab: calibrationStatusScreen(
            selectedInstrumentsListData: selectedInstrumentsListData,
            selectedInstrumentsList: selectedInstrumentsList,
            blocProvider: blocProvider,
            searchedInstrumentsListData: searchedInstrumentsListData,
            rangeData: rangeData),
        windows: calibrationStatusScreen(
            selectedInstrumentsListData: selectedInstrumentsListData,
            selectedInstrumentsList: selectedInstrumentsList,
            blocProvider: blocProvider,
            searchedInstrumentsListData: searchedInstrumentsListData,
            rangeData: rangeData),
        linux: calibrationStatusScreen(
            selectedInstrumentsListData: selectedInstrumentsListData,
            selectedInstrumentsList: selectedInstrumentsList,
            blocProvider: blocProvider,
            searchedInstrumentsListData: searchedInstrumentsListData,
            rangeData: rangeData),
      ),
    );
  }

  RefreshIndicator calibrationStatusScreen(
      {required StreamController<List<CalibrationStatusModel>>
          selectedInstrumentsListData,
      required List<CalibrationStatusModel> selectedInstrumentsList,
      required CalibrationBloc blocProvider,
      required StreamController<List<CalibrationStatusModel>>
          searchedInstrumentsListData,
      required StreamController<int> rangeData}) {
    TextEditingController searchedString = TextEditingController();
    StreamController<String> uploadCertificate =
        StreamController<String>.broadcast();
    rangeData.add(0);
    return RefreshIndicator(
      onRefresh: () async {
        blocProvider.add(InstrumentCalibrationStatusEvent());
      },
      child: ListView(
        children: [
          BlocBuilder<CalibrationBloc, CalibrationState>(
              builder: (context, state) {
            if (state is InstrumentCalibrationStatusState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 300,
                          margin: Platform.isAndroid
                              ? const EdgeInsets.only(left: 10)
                              : const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(left: 10),
                          decoration:
                              QuickFixUi().borderContainer(borderThickness: .5),
                          child: StreamBuilder<List<CalibrationStatusModel>>(
                              stream: selectedInstrumentsListData.stream,
                              builder: (context, selectedsnapshot) {
                                return TextField(
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search instrument'),
                                  onChanged: (value) async {
                                    if (value == '') {
                                      searchedString.text = '';
                                      List<CalibrationStatusModel>
                                          searchedData =
                                          await CalibrationRepository()
                                              .calibrationStatus(
                                                  token: state.token,
                                                  range: 0,
                                                  searchString:
                                                      searchedString.text);
                                      searchedInstrumentsListData
                                          .add(searchedData);
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        selectedInstrumentsListData.add(
                                            selectedsnapshot.data != null
                                                ? selectedsnapshot.data!
                                                : []);
                                      });
                                    } else {
                                      searchedString.text = value;
                                    }
                                  },
                                );
                              })),
                      const SizedBox(width: 5),
                      StreamBuilder<List<CalibrationStatusModel>>(
                          stream: selectedInstrumentsListData.stream,
                          builder: (context, selectedsnapshot) {
                            return IconButton.filled(
                                onPressed: () async {
                                  if (searchedString.text != '') {
                                    List<CalibrationStatusModel> searchedData =
                                        await CalibrationRepository()
                                            .calibrationStatus(
                                                token: state.token,
                                                range: 0,
                                                searchString:
                                                    searchedString.text);
                                    searchedInstrumentsListData
                                        .add(searchedData);
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      selectedInstrumentsListData.add(
                                          selectedsnapshot.data != null
                                              ? selectedsnapshot.data!
                                              : []);
                                    });
                                    rangeData.add(0);
                                  }
                                },
                                icon: const Icon(Icons.search));
                          })
                    ],
                  ),
                  Row(
                    children: [
                      FilledButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteName.instrumentStore);
                          },
                          child: const Text('Store')),
                      StreamBuilder<List<CalibrationStatusModel>>(
                          stream: selectedInstrumentsListData.stream,
                          builder: (context, snapshot) {
                            return Padding(
                                padding: const EdgeInsets.all(5),
                                child: FilledButton(
                                    onPressed: () async {
                                      if (snapshot.data != null &&
                                          snapshot.data!.isNotEmpty) {
                                        QuickFixUi()
                                            .showProcessing(context: context);
                                        for (var record in snapshot.data!) {
                                          String response =
                                              await CalibrationRepository()
                                                  .calibrationHistoryRegistration(
                                                      token: state.token,
                                                      payload: {
                                                'createdby': state.userId,
                                                'instrumentcalibrationschedule_id':
                                                    record.id.toString().trim(),
                                                'startdate': record.startdate
                                                    .toString()
                                                    .trim(),
                                                'duedate': record.duedate
                                                    .toString()
                                                    .trim(),
                                                'certificate_id': record
                                                    .certificateMdocid
                                                    .toString()
                                                    .trim(),
                                                'frequency': record.frequencyid
                                                    .toString()
                                              });

                                          if (response ==
                                              'Inserted successfully') {
                                            await CalibrationRepository()
                                                .sendInstrumentForCalibration(
                                                    token: state.token,
                                                    payload: {
                                                  'createdby': state.userId,
                                                  'id': record.id
                                                });
                                          }
                                        }
                                        blocProvider.add(
                                            InstrumentCalibrationStatusEvent());
                                        selectedInstrumentsListData.add([]);
                                        blocProvider
                                            .add(OutwardInstrumentsEvent());
                                        Navigator.of(context).pop();
                                        Navigator.popAndPushNamed(context,
                                            RouteName.outwardInstruments,
                                            arguments: {'outward': true});
                                      } else {
                                        Navigator.popAndPushNamed(context,
                                            RouteName.outwardInstruments,
                                            arguments: {'outward': false});
                                      }
                                    },
                                    child: const Text('Calibrate')));
                          }),
                    ],
                  ),
                ],
              );
            } else {
              return const Stack();
            }
          }),
          BlocBuilder<CalibrationBloc, CalibrationState>(
              builder: (context, state) {
            if (state is InstrumentCalibrationStatusState &&
                state.calibrationStatusList.isNotEmpty) {
              return StreamBuilder<List<CalibrationStatusModel>>(
                  stream: searchedInstrumentsListData.stream,
                  builder: (context, searchedsnapshot) {
                    return calibrationStatusTableUI(
                        context: context,
                        calibrationStatusList: searchedsnapshot.data == null
                            ? state.calibrationStatusList
                            : searchedsnapshot.data!,
                        state: state,
                        selectedInstrumentsList: selectedInstrumentsList,
                        selectedInstrumentsListData:
                            selectedInstrumentsListData,
                        blocProvider: blocProvider,
                        uploadCertificate: uploadCertificate,
                        searchedInstrumentsListData:
                            searchedInstrumentsListData,
                        rangeData: rangeData);
                  });
            } else {
              return const Center(
                child: Text('Data not found.'),
              );
            }
          })
        ],
      ),
    );
  }

  Container calibrationStatusTableUI(
      {required BuildContext context,
      required List<CalibrationStatusModel> calibrationStatusList,
      required InstrumentCalibrationStatusState state,
      required List<CalibrationStatusModel> selectedInstrumentsList,
      required StreamController<List<CalibrationStatusModel>>
          selectedInstrumentsListData,
      required CalibrationBloc blocProvider,
      required StreamController<String> uploadCertificate,
      required StreamController<List<CalibrationStatusModel>>
          searchedInstrumentsListData,
      required StreamController<int> rangeData}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 233,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.all(1),
      child: calibrationStatusList.isEmpty
          ? const Center(
              child: Text('No istruments are available with this name.'))
          : CustomTable(
              tablewidth: MediaQuery.of(context).size.width - 20,
              tableheight: calibrationStatusList.length < 12
                  ? ((calibrationStatusList.length + 1) * 45)
                  : MediaQuery.of(context).size.height - 220,
              columnWidth: (MediaQuery.of(context).size.width - 20.2) / 8.9,
              headerStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.blackColor),
              tableheaderColor: AppColors.whiteTheme,
              rowHeight: 45,
              tableOutsideBorder: true,
              enableRowBottomBorder: true,
              column: [
                ColumnData(width: 50, label: 'Sr.No.'),
                ColumnData(width: 240, label: 'Action'),
                ColumnData(label: 'Instrument name'),
                ColumnData(label: 'Instrument type'),
                ColumnData(label: 'Card number'),
                ColumnData(label: 'Range'),
                ColumnData(label: 'Start date'),
                ColumnData(label: 'Due date'),
                ColumnData(label: 'Frequency')
              ],
              rows: calibrationStatusList.map((e) {
                return RowData(
                    rowColor: getColorBasedOnCategory(
                        e.remainingTimeCategory, e.remainingTimeUntilDue!),
                    cell: [
                      TableDataCell(
                          width: 50,
                          label: StreamBuilder<int>(
                              stream: rangeData.stream,
                              builder: (context, rangesnapshot) {
                                return Text(
                                  ((rangesnapshot.data == null
                                              ? 0
                                              : rangesnapshot.data!) +
                                          (calibrationStatusList.indexOf(e) +
                                              1))
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: tableTextStyle(),
                                );
                              })),
                      TableDataCell(
                          width: 240,
                          label: Row(children: [
                            e.startdate.toString() == '0000-00-00'
                                ? const Text('')
                                : StreamBuilder<List<CalibrationStatusModel>>(
                                    stream: selectedInstrumentsListData.stream,
                                    builder: (context, selectedsnapshot) {
                                      return Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.black,
                                          value: isSelected(
                                              selectedItems:
                                                  selectedsnapshot.data != null
                                                      ? selectedsnapshot.data!
                                                      : [],
                                              item: e),
                                          onChanged: (value) {
                                            selectedInstrumentsList =
                                                selectedsnapshot.data != null
                                                    ? selectedsnapshot.data!
                                                    : [];
                                            if (selectedsnapshot.data != null &&
                                                selectedsnapshot.data!.length >
                                                    14) {
                                              QuickFixUi.errorMessage(
                                                  'Challan generation requires only 15 elements.',
                                                  context);
                                            } else if (isSelected(
                                                selectedItems:
                                                    selectedsnapshot.data !=
                                                            null
                                                        ? selectedsnapshot.data!
                                                        : [],
                                                item: e)) {
                                              selectedInstrumentsList
                                                  .removeWhere((element) =>
                                                      element.id == e.id);
                                              selectedInstrumentsListData
                                                  .add(selectedInstrumentsList);
                                            } else {
                                              selectedInstrumentsList.add(e);
                                              selectedInstrumentsListData
                                                  .add(selectedInstrumentsList);
                                            }
                                          });
                                    }),
                            e.startdate.toString() == '0000-00-00'
                                ? const Text('')
                                : IconButton(
                                    onPressed: () async {
                                      TextEditingController rejectedReason =
                                          TextEditingController();
                                      rejectInstrument(
                                          context: context,
                                          rejectionReasons:
                                              state.rejectionReasons,
                                          rejectedReason: rejectedReason,
                                          e: e,
                                          token: state.token,
                                          userid: state.userId,
                                          blocProvider: blocProvider);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                      size: Platform.isAndroid ? 25 : 20,
                                    )),
                            e.certificateMdocid != null
                                ? viewCertificate(
                                    context: context, e: e, token: state.token)
                                : e.startdate.toString() == '0000-00-00'
                                    ? const Text('')
                                    : Row(children: [
                                        StreamBuilder<String>(
                                            stream: uploadCertificate.stream,
                                            builder: (context, snapshot) {
                                              return ImageToPDFGenerator(
                                                onFilePicked: () {
                                                  if (snapshot.data != null &&
                                                      snapshot.data == e.id) {
                                                    uploadCertificate.add('');
                                                  } else {
                                                    uploadCertificate
                                                        .add(e.id.toString());
                                                  }
                                                },
                                              );
                                            }),
                                        StreamBuilder<String>(
                                            stream: uploadCertificate.stream,
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null &&
                                                  snapshot.data ==
                                                      e.id.toString()) {
                                                return IconButton(
                                                    onPressed: () async {
                                                      final Directory
                                                          directory =
                                                          await getApplicationDocumentsDirectory();
                                                      final String path =
                                                          directory.path;
                                                      final File file = File(
                                                          '$path/certificate.pdf');
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              dialContext) {
                                                            return AlertDialog(
                                                              content:
                                                                  const SizedBox(
                                                                height: 20,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Are you sure you want to upload certificate?',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                FilledButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            WidgetStateProperty.all(AppColors
                                                                                .redTheme)),
                                                                    child: const Text(
                                                                        'No')),
                                                                FilledButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (await file
                                                                          .exists()) {
                                                                        QuickFixUi().showProcessing(
                                                                            context:
                                                                                context);
                                                                        List<int>
                                                                            pdfBytes =
                                                                            await file.readAsBytes();
                                                                        String certificateId = await CalibrationRepository().instrumentsCertificatesRegistration(
                                                                            token:
                                                                                state.token,
                                                                            payload: {
                                                                              'instrumentname': '${e.instrumentname.toString().trim()}_${e.cardnumber}.pdf',
                                                                              'postgresql_id': e.id,
                                                                              'data': base64Encode(pdfBytes)
                                                                            });
                                                                        String updatedResponse = await CalibrationRepository().certificateReference(
                                                                            token:
                                                                                state.token,
                                                                            payload: {
                                                                              'id': e.id,
                                                                              'certificate_mdocid': certificateId
                                                                            });
                                                                        if (updatedResponse ==
                                                                            'Updated successfully') {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          await file
                                                                              .delete();
                                                                          uploadCertificate
                                                                              .add('');
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          blocProvider
                                                                              .add(InstrumentCalibrationStatusEvent());

                                                                          QuickFixUi.successMessage(
                                                                              'Certificate uploaded successfully.',
                                                                              context);
                                                                        }
                                                                      }
                                                                    },
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            WidgetStateProperty.all(AppColors
                                                                                .greenTheme)),
                                                                    child: const Text(
                                                                        'Yes'))
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon: Icon(
                                                      Icons.upload_sharp,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                    ));
                                              } else {
                                                return const SizedBox();
                                              }
                                            })
                                      ])
                          ])),
                      TableDataCell(
                          label: Text(
                        e.instrumentname == null
                            ? ''
                            : e.instrumentname.toString(),
                        textAlign: TextAlign.center,
                        style: tableTextStyle(),
                      )),
                      TableDataCell(
                          label: Text(
                        e.instrumenttype == null
                            ? ''
                            : e.instrumenttype.toString(),
                        textAlign: TextAlign.center,
                        style: tableTextStyle(),
                      )),
                      TableDataCell(
                          label: Text(
                        e.cardnumber == null ? '' : e.cardnumber.toString(),
                        textAlign: TextAlign.center,
                        style: tableTextStyle(),
                      )),
                      TableDataCell(
                          label: Text(
                        e.measuringrange == null
                            ? ''
                            : e.measuringrange.toString(),
                        textAlign: TextAlign.center,
                        style: tableTextStyle(),
                      )),
                      TableDataCell(
                          label: Text(
                        e.startdate.toString() == '0000-00-00'
                            ? ''
                            : e.startdate == null
                                ? ''
                                : DateTime.parse(e.startdate.toString())
                                    .toLocal()
                                    .toString()
                                    .substring(0, 10),
                        textAlign: TextAlign.center,
                        style: tableTextStyle(),
                      )),
                      TableDataCell(
                          label: Text(
                        e.duedate.toString() == '0000-00-00'
                            ? ''
                            : e.duedate == null
                                ? ''
                                : DateTime.parse(e.duedate.toString())
                                    .toLocal()
                                    .toString()
                                    .substring(0, 10),
                        textAlign: TextAlign.center,
                        style: tableTextStyle(),
                      )),
                      TableDataCell(
                          label: Text(
                        e.startdate.toString() == '0000-00-00'
                            ? 'Outsourced'
                            : e.remainingTimeUntilDue == null
                                ? ''
                                : e.remainingTimeUntilDue.toString() == '-'
                                    ? 'Last day'
                                    : e.remainingTimeUntilDue.toString(),
                        textAlign: TextAlign.center,
                        style: tableTextStyle(),
                      )),
                    ]);
              }).toList(),
              footer: StreamBuilder<int>(
                  stream: rangeData.stream,
                  builder: (context, rangesnapshot) {
                    return ((rangesnapshot.data != null &&
                                rangesnapshot.data == 0 &&
                                calibrationStatusList.length != 50) ||
                            calibrationStatusList.length > 50)
                        ? const SizedBox(height: .1)
                        : Container(
                            color: AppColors.whiteTheme,
                            width: MediaQuery.of(context).size.width - 20,
                            height: 45,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (rangesnapshot.data != null &&
                                        rangesnapshot.data! > 0)
                                    ? StreamBuilder<
                                            List<CalibrationStatusModel>>(
                                        stream:
                                            selectedInstrumentsListData.stream,
                                        builder: (context, selectedsnapshot) {
                                          return InkWell(
                                            onTap: () async {
                                              List<CalibrationStatusModel>
                                                  searchedData =
                                                  await CalibrationRepository()
                                                      .calibrationStatus(
                                                          token: state.token,
                                                          range: rangesnapshot
                                                                  .data! -
                                                              50,
                                                          searchString: '');
                                              searchedInstrumentsListData
                                                  .add(searchedData);
                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                selectedInstrumentsListData.add(
                                                    selectedsnapshot.data !=
                                                            null
                                                        ? selectedsnapshot.data!
                                                        : []);
                                              });
                                              rangeData.add(
                                                  rangesnapshot.data! - 50);
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.arrow_back_ios),
                                                Text(
                                                  'Back',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          );
                                        })
                                    : const SizedBox(),
                                calibrationStatusList.length != 50
                                    ? const SizedBox(
                                        height: .1,
                                      )
                                    : StreamBuilder<
                                            List<CalibrationStatusModel>>(
                                        stream:
                                            selectedInstrumentsListData.stream,
                                        builder: (context, selectedsnapshot) {
                                          return InkWell(
                                            onTap: () async {
                                              List<CalibrationStatusModel>
                                                  searchedData =
                                                  await CalibrationRepository()
                                                      .calibrationStatus(
                                                          token: state.token,
                                                          range: (rangesnapshot
                                                                          .data ==
                                                                      null
                                                                  ? 0
                                                                  : rangesnapshot
                                                                      .data!) +
                                                              50,
                                                          searchString: '');
                                              searchedInstrumentsListData
                                                  .add(searchedData);
                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                selectedInstrumentsListData.add(
                                                    selectedsnapshot.data !=
                                                            null
                                                        ? selectedsnapshot.data!
                                                        : []);
                                              });
                                              rangeData.add(
                                                  (rangesnapshot.data == null
                                                          ? 0
                                                          : rangesnapshot
                                                              .data!) +
                                                      50);
                                            },
                                            child: const Row(
                                              children: [
                                                Text(
                                                  'Next',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(Icons.arrow_forward_ios)
                                              ],
                                            ),
                                          );
                                        })
                              ],
                            ),
                          );
                  })),
    );
  }

  bool isSelected(
      {required List<CalibrationStatusModel> selectedItems,
      required CalibrationStatusModel item}) {
    return selectedItems.any((selectedItem) => selectedItem.id == item.id);
  }

  Future<dynamic> rejectInstrument(
      {required BuildContext context,
      required List<InstrumentRejectionReasons> rejectionReasons,
      required TextEditingController rejectedReason,
      required CalibrationStatusModel e,
      required String token,
      required String userid,
      required CalibrationBloc blocProvider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Reject instrument',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            content: DropdownSearch<InstrumentRejectionReasons>(
              items: rejectionReasons,
              itemAsString: (item) => item.reason.toString(),
              onChanged: (value) {
                rejectedReason.text = value!.id.toString();
              },
            ),
            actions: [
              FilledButton(
                  onPressed: () async {
                    if (rejectedReason.text == '') {
                      QuickFixUi().showCustomDialog(
                          errorMessage: 'Select rejection reason first.',
                          context: context);
                    } else {
                      String id = e.id.toString().trim(),
                          startdate = e.startdate.toString().trim(),
                          duedate = e.duedate.toString().trim(),
                          certificateMdocid =
                              e.certificateMdocid.toString().trim();
                      String deleteResponse = await CalibrationRepository()
                          .rejectInstrument(token: token, payload: {
                        'id': e.id.toString(),
                        'isdeleted': true
                      });
                      if (deleteResponse == 'Updated successfully') {
                        String response = await CalibrationRepository()
                            .addrejectedInstrumentToHistory(
                                token: token,
                                payload: {
                              'createdby': userid,
                              'instrumentcalibrationschedule_id': id,
                              'startdate': startdate,
                              'duedate': duedate,
                              'certificate_id': certificateMdocid,
                              'rejectionreason': rejectedReason.text,
                              'isdeleted': rejectedReason.text ==
                                      '81180939c054478587d54fab54f585fd'
                                  ? false
                                  : true
                            });
                        if (response == 'Inserted successfully') {
                          Navigator.of(context).pop();
                          QuickFixUi.successMessage(response, context);
                          Future.delayed(const Duration(seconds: 1), () {
                            blocProvider
                                .add(InstrumentCalibrationStatusEvent());
                          });
                        }
                      }
                    }
                  },
                  child: const Text('Confirm')),
              FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  Padding viewCertificate(
      {required BuildContext context,
      required CalibrationStatusModel e,
      required String token}) {
    return Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () async {
            String response = await CalibrationRepository().getCertificate(
                payload: {'id': e.certificateMdocid}, token: token);
            if (response != '' && response != 'Something went wrong') {
              if (Platform.isAndroid) {
                Navigator.pushNamed(context, RouteName.pdf,
                    arguments: {'data': base64.decode(response)});
              } else {
                Documents().models(
                    response, '${e.instrumentname}-${e.cardnumber}', '', 'pdf');
              }
            } else {
              debugPrint('File not found');
            }
          },
          icon: Icon(
            Icons.picture_as_pdf_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 17,
          )),
    );
  }

  Color getColorBasedOnCategory(
      int? remainingTimeCategory, String remainingTimeUntilDue) {
    if (remainingTimeCategory == null) {
      return Colors.white;
    } else if (remainingTimeCategory == -1) {
      return const Color(0XFFffab92);
    } else if (remainingTimeUntilDue == '-') {
      return const Color(0XFFF4BB44);
    } else if (remainingTimeCategory == 0) {
      return const Color(0XFFf1ee8e);
    } else {
      return const Color(0XFFa1debb);
    }
  }

  tableTextStyle() => TextStyle(fontSize: Platform.isAndroid ? 14 : 12);
}
