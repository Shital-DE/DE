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
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/quality/calibration_model.dart';
import '../../../../services/repository/quality/calibration_repository.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';

class CalibrationHistory extends StatelessWidget {
  const CalibrationHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentCalibrationHistoryEvent());
    StreamController<List<InstrumentsCardModel>> allCards =
        StreamController<List<InstrumentsCardModel>>.broadcast();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: MakeMeResponsiveScreen(
            horixontaltab: calibrationHistoryScreen(
                allCards: allCards, blocProvider: blocProvider, size: size),
            windows: calibrationHistoryScreen(
                allCards: allCards, blocProvider: blocProvider, size: size),
            linux: calibrationHistoryScreen(
                allCards: allCards, blocProvider: blocProvider, size: size)));
  }

  BlocBuilder<CalibrationBloc, CalibrationState> calibrationHistoryScreen(
      {required StreamController<List<InstrumentsCardModel>> allCards,
      required CalibrationBloc blocProvider,
      required Size size}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is InstrumentCalibrationHistoryState) {
        return ListView(
          children: [
            QuickFixUi.verticalSpace(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 45,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: QuickFixUi().borderContainer(borderThickness: .5),
                  child: DropdownSearch<AllInstrumentsData>(
                    items: state.allInstrumentsList,
                    itemAsString: (item) => item.instrumentname.toString(),
                    popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: TextStyle(fontSize: 18),
                        )),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Select instrument')),
                    onChanged: (value) async {
                      allCards.add([]);
                      List<InstrumentsCardModel> cardsList =
                          await CalibrationRepository().cardNumbers(
                              token: state.token,
                              payload: {'instrument_id': value!.id.toString()});
                      allCards.add(cardsList);
                    },
                  ),
                ),
                QuickFixUi.horizontalSpace(width: 20),
                StreamBuilder<List<InstrumentsCardModel>>(
                    stream: allCards.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return Container(
                          width: 150,
                          height: 45,
                          padding: const EdgeInsets.only(left: 20),
                          decoration:
                              QuickFixUi().borderContainer(borderThickness: .5),
                          child: DropdownSearch<InstrumentsCardModel>(
                            items: snapshot.data!,
                            itemAsString: (item) => item.cardnumber.toString(),
                            popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  style: TextStyle(fontSize: 18),
                                )),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Card number')),
                            onChanged: (value) async {
                              blocProvider.add(
                                  InstrumentCalibrationHistoryEvent(
                                      instrument: value));
                            },
                          ),
                        );
                      } else {
                        return const Stack();
                      }
                    })
              ],
            ),
            state.calibrationHistory.isNotEmpty
                ? Container(
                    width: size.width,
                    height: size.height - 255,
                    margin: const EdgeInsets.all(10),
                    child: CustomTable(
                        tablewidth: size.width,
                        tableheight: (state.calibrationHistory.length + 1) * 45,
                        rowHeight: 45,
                        columnWidth: (size.width - 28) / 7.2,
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
                        showIndex: true,
                        column: [
                          ColumnData(label: 'Certificate'),
                          ColumnData(label: 'Instrument name'),
                          ColumnData(label: 'Instrument type'),
                          ColumnData(label: 'Card number'),
                          ColumnData(label: 'Range'),
                          ColumnData(label: 'Start date'),
                          ColumnData(label: 'Due date'),
                          ColumnData(label: 'Manufacturer'),
                          ColumnData(label: 'Location'),
                          ColumnData(label: 'Rejection reason'),
                          ColumnData(label: 'Rejected By'),
                          ColumnData(label: 'Rejection date')
                        ],
                        rows: state.calibrationHistory.map((e) {
                          return RowData(
                            cell: [
                              TableDataCell(
                                  label: e.certificateMdocid
                                              .toString()
                                              .trim() !=
                                          'null'
                                      ? IconButton(
                                          onPressed: () async {
                                            String response =
                                                await CalibrationRepository()
                                                    .getCertificate(payload: {
                                              'id': e.certificateMdocid
                                            }, token: state.token);

                                            if (response != '' &&
                                                response !=
                                                    'Something went wrong') {
                                              if (Platform.isAndroid) {
                                                Navigator.pushNamed(
                                                    context, RouteName.pdf,
                                                    arguments: {
                                                      'data': base64
                                                          .decode(response)
                                                    });
                                              } else {
                                                Documents().models(
                                                    response,
                                                    '${e.instrumentname}-${e.cardnumber}',
                                                    '',
                                                    'pdf');
                                              }
                                            } else {
                                              debugPrint('File not found');
                                            }
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ))
                                      : const Text('')),
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
                                  label: Text(
                                e.startdate == null
                                    ? ''
                                    : e.startdate.toString() == '0000-00-00'
                                        ? ''
                                        : DateTime.parse(e.startdate.toString())
                                            .toLocal()
                                            .toString()
                                            .substring(0, 10),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.duedate == null
                                    ? ''
                                    : e.duedate.toString() == '0000-00-00'
                                        ? ''
                                        : DateTime.parse(e.duedate.toString())
                                            .toLocal()
                                            .toString()
                                            .substring(0, 10),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.manufacturer.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.storagelocation.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.rejectionreason == null
                                    ? ''
                                    : e.rejectionreason.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.rejectionreason == null
                                    ? ''
                                    : e.rejectedby.toString(),
                                textAlign: TextAlign.center,
                              )),
                              TableDataCell(
                                  label: Text(
                                e.rejectionreason == null
                                    ? ''
                                    : DateTime.parse(e.rejectiondate.toString())
                                        .toLocal()
                                        .toString()
                                        .substring(0, 10),
                                textAlign: TextAlign.center,
                              )),
                            ],
                          );
                        }).toList()))
                : const Stack()
          ],
        );
      } else {
        return const Center(child: Text('Data not found.'));
      }
    });
  }
}
