import 'package:de/view/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../../services/repository/quality/calibration_repository.dart';
import '../../../../../utils/app_colors.dart';

class InstrumentReclaimScreen extends StatelessWidget {
  const InstrumentReclaimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CalibrationBloc blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentReclaimEvent());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<CalibrationBloc, CalibrationState>(
          builder: (context, state) {
        if (state is CalibrationInitialState) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.appTheme,
            ),
          );
        } else if (state is InstrumentReclaimState) {
          return state.reclaimOutsourceInstrumentsDatalist.isEmpty
              ? const Center(
                  child: Text('No instruments are available to reclaim'),
                )
              : Container(
                  width: size.width,
                  height: size.height,
                  margin: const EdgeInsets.all(10),
                  child: CustomTable(
                      tablewidth: size.width - 20,
                      tableheight: size.height - 20,
                      showIndex: true,
                      columnWidth: (size.width - 100) / 8,
                      tableheaderColor:
                          Theme.of(context).colorScheme.errorContainer,
                      headerStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      column: state.tableColumnsList
                          .map((e) => ColumnData(label: e))
                          .toList(),
                      rows: state.reclaimOutsourceInstrumentsDatalist
                          .map((element) => RowData(cell: [
                                TableDataCell(
                                    label: Text(element.instrumentname
                                        .toString()
                                        .trim())),
                                TableDataCell(
                                    label: Text(element.instrumenttype
                                        .toString()
                                        .trim())),
                                TableDataCell(
                                    label: Text(
                                        element.cardnumber.toString().trim())),
                                TableDataCell(
                                    label: Text(element.measuringrange
                                        .toString()
                                        .trim())),
                                TableDataCell(
                                    label: Text(DateTime.parse(
                                            element.startdate.toString().trim())
                                        .toLocal()
                                        .toString()
                                        .substring(0, 10))),
                                TableDataCell(
                                    label: Text(DateTime.parse(
                                            element.duedate.toString().trim())
                                        .toLocal()
                                        .toString()
                                        .substring(0, 10))),
                                TableDataCell(
                                    label: Text(
                                        element.frequency.toString().trim())),
                                TableDataCell(
                                    label: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, bottom: 2),
                                  child: FilledButton(
                                      style: FilledButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return AlertDialog(
                                                content: const SizedBox(
                                                  height: 40,
                                                  child: Center(
                                                      child: Text(
                                                    "Are you sure?",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  )),
                                                ),
                                                actions: [
                                                  noButton(
                                                      dialogContext:
                                                          dialogContext),
                                                  FilledButton(
                                                      onPressed: () async {
                                                        try {
                                                          Navigator.of(
                                                                  dialogContext)
                                                              .pop();
                                                          String response =
                                                              await CalibrationRepository()
                                                                  .calibrationHistoryRegistration(
                                                                      token: state
                                                                          .token,
                                                                      payload: {
                                                                'createdby':
                                                                    state
                                                                        .userId,
                                                                'instrumentcalibrationschedule_id':
                                                                    element
                                                                        .instrumentcalibrationscheduleId
                                                                        .toString()
                                                                        .trim(),
                                                                'startdate': element
                                                                    .startdate
                                                                    .toString()
                                                                    .trim(),
                                                                'duedate': element
                                                                    .duedate
                                                                    .toString()
                                                                    .trim(),
                                                                'certificate_id':
                                                                    element
                                                                        .certificateMdocid
                                                                        .toString()
                                                                        .trim(),
                                                                'frequency': element
                                                                    .frequencyId,
                                                                'remark':
                                                                    "Instrument reclaimed from vendor."
                                                              });
                                                          if (response.length ==
                                                              32) {
                                                            String
                                                                reclaimResponse =
                                                                await CalibrationRepository()
                                                                    .issueAndReclaimInstruments(
                                                                        token: state
                                                                            .token,
                                                                        payload: {
                                                                  'id': element
                                                                      .instrumentcalibrationscheduleId
                                                                      .toString()
                                                                      .trim(),
                                                                  'isoutsourced':
                                                                      false
                                                                });
                                                            if (reclaimResponse ==
                                                                'Updated successfully') {
                                                              blocProvider.add(
                                                                  InstrumentReclaimEvent());
                                                            }
                                                          }
                                                        } catch (error) {
                                                          debugPrint(
                                                              error.toString());
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty
                                                                .all(AppColors
                                                                    .greenTheme),
                                                      ),
                                                      child: const Text('Yes'))
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text(
                                        'Inward',
                                        style: TextStyle(
                                            color: AppColors.whiteTheme,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ))
                              ]))
                          .toList()));
        } else {
          return const Text("");
        }
      }),
    );
  }

  FilledButton noButton({required BuildContext dialogContext}) {
    return FilledButton(
        onPressed: () {
          Navigator.of(dialogContext).pop();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.redTheme),
        ),
        child: const Text('No'));
  }
}
