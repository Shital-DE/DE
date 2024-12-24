// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:de/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/quality/calibration_model.dart';
import '../../../../services/repository/quality/calibration_repository.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';

class InstrumentStore extends StatelessWidget {
  const InstrumentStore({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentStoreEvent());
    return Scaffold(
      appBar:
          CustomAppbar().appbar(context: context, title: 'Instrument store'),
      body: Center(child: BlocBuilder<CalibrationBloc, CalibrationState>(
          builder: (context, state) {
        if (state is InstrumentStoreState &&
            state.storedInstrumentsData.isNotEmpty) {
          return Container(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height - 20,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(1),
            child: CustomTable(
                tablewidth: MediaQuery.of(context).size.width - 20,
                tableheight: (state.storedInstrumentsData.length + 1) * 46,
                showIndex: true,
                columnWidth: 180,
                rowHeight: 45,
                enableBorder: true,
                tableheaderColor:
                    Theme.of(context).colorScheme.primaryContainer,
                tablebodyColor: Theme.of(context).colorScheme.surface,
                tableBorderColor: Theme.of(context).primaryColor,
                headerStyle: TextStyle(
                    fontSize: Platform.isAndroid ? 15 : 13,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
                column: [
                  ColumnData(label: 'Action'),
                  ColumnData(label: 'Instrument name'),
                  ColumnData(label: 'Instrument type'),
                  ColumnData(label: 'Card number'),
                  ColumnData(label: 'Range'),
                  ColumnData(label: 'Start date'),
                  ColumnData(label: 'Due date'),
                  ColumnData(label: 'Manufacturer'),
                  ColumnData(label: 'Location'),
                  ColumnData(label: 'Stored By'),
                  ColumnData(label: 'Stored On')
                ],
                rows: state.storedInstrumentsData
                    .map((e) => RowData(cell: [
                          TableDataCell(
                              label: e.certificateMdocid.toString().trim() !=
                                      'null'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        certificateButton(
                                            e: e,
                                            state: state,
                                            context: context),
                                        restoreInstrument(
                                            state: state,
                                            e: e,
                                            blocProvider: blocProvider,
                                            context: context)
                                      ],
                                    )
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
                            e.storedby.toString(),
                            textAlign: TextAlign.center,
                            style: AppTheme.labelTextStyle(),
                          )),
                          TableDataCell(
                              label: Text(
                            e.storedon == null
                                ? ''
                                : e.storedon.toString() == '0000-00-00'
                                    ? ''
                                    : DateTime.parse(e.storedon.toString())
                                        .toLocal()
                                        .toString()
                                        .substring(0, 10),
                            textAlign: TextAlign.center,
                            style: AppTheme.labelTextStyle(),
                          )),
                        ]))
                    .toList()),
          );
        } else {
          return const Text('Data not available.');
        }
      })),
    );
  }

  IconButton restoreInstrument(
      {required InstrumentStoreState state,
      required StoredInstrumentsModel e,
      required CalibrationBloc blocProvider,
      required BuildContext context}) {
    return IconButton(
        onPressed: () async {
          String response = await CalibrationRepository()
              .restoreStoredInstruments(
                  token: state.token, payload: {'id': e.id.toString()});
          if (response == 'Deleted successfully') {
            String deleteResponse = await CalibrationRepository()
                .rejectInstrument(token: state.token, payload: {
              'id': e.instrumentcalibrationscheduleId.toString(),
              'isdeleted': false
            });
            if (deleteResponse == 'Updated successfully') {
              blocProvider.add(InstrumentStoreEvent());
            }
          }
        },
        icon: Icon(
          Icons.restore_outlined,
          color: Theme.of(context).primaryColor,
        ));
  }

  IconButton certificateButton(
      {required StoredInstrumentsModel e,
      required InstrumentStoreState state,
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
