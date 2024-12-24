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
import '../../../../utils/app_theme.dart';
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
          allCards: allCards, blocProvider: blocProvider, size: size),
    ));
  }

  BlocBuilder<CalibrationBloc, CalibrationState> calibrationHistoryScreen(
      {required StreamController<List<InstrumentsCardModel>> allCards,
      required CalibrationBloc blocProvider,
      required Size size}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is InstrumentCalibrationHistoryState) {
        return instrumentHistoryWidget(
            state: state,
            allCards: allCards,
            blocProvider: blocProvider,
            size: size,
            context: context);
      } else {
        return dataNotFoundWidget();
      }
    });
  }

  Center dataNotFoundWidget() => const Center(child: Text('Data not found.'));

  ListView instrumentHistoryWidget(
      {required InstrumentCalibrationHistoryState state,
      required StreamController<List<InstrumentsCardModel>> allCards,
      required CalibrationBloc blocProvider,
      required Size size,
      required BuildContext context}) {
    double conWidth = 250, conHeight = Platform.isAndroid ? 45 : 35;
    return ListView(
      children: [
        QuickFixUi.verticalSpace(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: conWidth,
              height: conHeight,
              child: DropdownSearch<AllInstrumentsData>(
                items: state.allInstrumentsList,
                itemAsString: (item) => item.instrumentname.toString(),
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(
                        item.instrumentname.toString(),
                        style: AppTheme.labelTextStyle(),
                      ),
                    );
                  },
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                    textAlign: TextAlign.center,
                    dropdownSearchDecoration: InputDecoration(
                      hintText: 'Select instrument',
                      hintStyle: AppTheme.labelTextStyle(),
                      contentPadding:
                          const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2)),
                    )),
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
                    return SizedBox(
                      width: conWidth,
                      height: conHeight,
                      child: DropdownSearch<InstrumentsCardModel>(
                        items: snapshot.data!,
                        itemAsString: (item) => item.cardnumber.toString(),
                        popupProps: PopupProps.menu(
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(
                                item.cardnumber.toString(),
                                style: AppTheme.labelTextStyle(),
                              ),
                            );
                          },
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            textAlign: TextAlign.center,
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'Card number',
                              hintStyle: AppTheme.labelTextStyle(),
                              contentPadding: const EdgeInsets.only(
                                  bottom: 11, top: 11, left: 2),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2)),
                            )),
                        onChanged: (value) async {
                          blocProvider.add(InstrumentCalibrationHistoryEvent(
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
                margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                child: CustomTable(
                    tablewidth: size.width,
                    tableheight:
                        (state.calibrationHistory.length + 1) * conHeight,
                    rowHeight: conHeight,
                    headerHeight: conHeight,
                    columnWidth: 200,
                    tableheaderColor: Colors.white,
                    headerStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Platform.isAndroid ? 15 : 13,
                        color: Theme.of(context).primaryColor),
                    tableOutsideBorder: true,
                    enableHeaderBottomBorder: true,
                    enableRowBottomBorder: true,
                    borderThickness: .5,
                    headerBorderThickness: .5,
                    headerBorderColor: Colors.black,
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
                              label: e.certificateMdocid.toString().trim() !=
                                      'null'
                                  ? pdfButton(
                                      e: e, state: state, context: context)
                                  : const Text('')),
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
                            style: AppTheme.labelTextStyle(),
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
                            style: AppTheme.labelTextStyle(),
                          )),
                          TableDataCell(
                              label: Text(
                            e.manufacturer.toString(),
                            textAlign: TextAlign.center,
                            style: AppTheme.labelTextStyle(),
                          )),
                          TableDataCell(
                              label: Text(
                            e.storagelocation.toString(),
                            textAlign: TextAlign.center,
                            style: AppTheme.labelTextStyle(),
                          )),
                          TableDataCell(
                              label: Text(
                            e.rejectionreason == null
                                ? ''
                                : e.rejectionreason.toString(),
                            textAlign: TextAlign.center,
                            style: AppTheme.labelTextStyle(),
                          )),
                          TableDataCell(
                              label: Text(
                            e.rejectionreason == null
                                ? ''
                                : e.rejectedby.toString(),
                            textAlign: TextAlign.center,
                            style: AppTheme.labelTextStyle(),
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
                            style: AppTheme.labelTextStyle(),
                          )),
                        ],
                      );
                    }).toList()))
            : const Stack()
      ],
    );
  }

  IconButton pdfButton(
      {required CalibrationHistoryModel e,
      required InstrumentCalibrationHistoryState state,
      required BuildContext context}) {
    return IconButton(
        onPressed: () async {
          String response = await CalibrationRepository().getCertificate(
              payload: {'id': e.certificateMdocid}, token: state.token);

          if (response != '' && response != 'Something went wrong') {
            if (Platform.isAndroid) {
              Navigator.pushNamed(context, RouteName.pdf,
                  arguments: {'data': base64.decode(response)});
            } else {
              Documents().models(
                  response, '${e.instrumentname}-${e.cardnumber}', '', 'pdf');
            }
          } else {
            //
          }
        },
        icon: Icon(
          Icons.picture_as_pdf,
          color: Theme.of(context).colorScheme.error,
        ));
  }
}
