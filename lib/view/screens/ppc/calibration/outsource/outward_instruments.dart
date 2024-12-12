// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../../routes/route_data.dart';
import '../../../../../routes/route_names.dart';
import '../../../../../services/model/quality/calibration_model.dart';
import '../../../../../services/model/registration/subcontractor_models.dart';
import '../../../../../services/repository/quality/calibration_repository.dart';
import '../../../../../services/session/user_login.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/common/quickfix_widget.dart';
import '../../../../../utils/responsive.dart';
import '../../../../widgets/PDF/challan.dart';
import '../../../../widgets/appbar.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../widgets/table/custom_table.dart';

class OutwardInstruments extends StatelessWidget {
  Map<String, dynamic> args;
  OutwardInstruments({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    if (args['outward'] == true) {
      args = {'outward': false};
      blocProvider.add(OutwardInstrumentsEvent());
    } else {
      blocProvider.add(InwardInstrumentsEvent());
    }
    Size size = MediaQuery.of(context).size;
    return MakeMeResponsiveScreen(
      horixontaltab: outwardScreen(
          context: context, size: size, blocProvider: blocProvider),
      windows: outwardScreen(
          context: context, size: size, blocProvider: blocProvider),
      linux: outwardScreen(
          context: context, size: size, blocProvider: blocProvider),
    );
  }

  PopScope outwardScreen(
      {required BuildContext context,
      required Size size,
      required CalibrationBloc blocProvider}) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Navigator.popAndPushNamed(context, RouteName.calibration);
      },
      child: Scaffold(
          appBar: CustomAppbar()
              .appbar(context: context, title: 'Instrument calibration'),
          body: BlocBuilder<CalibrationBloc, CalibrationState>(
              builder: (context, state) {
            if (state is OutwardInstrumentsState) {
              if (state.outwardInstrumentsList.isNotEmpty) {
                return sentInstrumentsForCalibration(
                    size: size,
                    state: state,
                    context: context,
                    blocProvider: blocProvider);
              } else {
                return const Center(
                  child: Text('No elements are available for calibration.'),
                );
              }
            } else if (state is InwardInstrumentsState) {
              return RouteData.getRouteData(
                  context, RouteName.inwardInstruments, {});
            } else if (state is OutsourceWorkorderState) {
              return RouteData.getRouteData(
                  context, RouteName.instrumentOutsourceWorkorder, {});
            } else {
              return const Stack();
            }
          }),
          bottomNavigationBar: bottomNavigation(blocProvider: blocProvider)),
    );
  }

  Column sentInstrumentsForCalibration(
      {required Size size,
      required OutwardInstrumentsState state,
      required BuildContext context,
      required CalibrationBloc blocProvider}) {
    List<String> unselectedInstrumentsList = [];
    StreamController<List<String>> unselectedInstrumentsData =
        StreamController<List<String>>.broadcast();
    return Column(
      children: [
        QuickFixUi.verticalSpace(height: 10),
        Container(
            height: 45,
            width: 300,
            decoration: QuickFixUi().borderContainer(borderThickness: .5),
            padding: const EdgeInsets.only(left: 10),
            child: DropdownSearch<CalibrationContractors>(
              items: state.calibrationContractorList,
              itemAsString: (item) => item.name.toString(),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Select contractor')),
              onChanged: (value) {
                blocProvider.add(OutwardInstrumentsEvent(subcontactor: value));
              },
            )),
        Container(
          width: size.width,
          height:
              (state.outwardInstrumentsList.length + 1) * 45 < size.height - 283
                  ? (state.outwardInstrumentsList.length + 1) * 45
                  : size.height - 283,
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: CustomTable(
              tablewidth: size.width,
              tableheight: (state.outwardInstrumentsList.length + 1) * 45,
              rowHeight: 45,
              columnWidth: size.width / 5.1,
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
                ColumnData(label: 'Instrument name'),
                ColumnData(label: 'Instrument type'),
                ColumnData(label: 'Card number'),
                ColumnData(label: 'Measuring range'),
                ColumnData(label: 'Action'),
              ],
              rows: state.outwardInstrumentsList
                  .map((e) => RowData(cell: [
                        TableDataCell(
                            label: Text(e.instrumentname.toString(),
                                textAlign: TextAlign.center)),
                        TableDataCell(
                            label: Text(e.instrumenttype.toString(),
                                textAlign: TextAlign.center)),
                        TableDataCell(
                            label: Text(e.cardnumber.toString(),
                                textAlign: TextAlign.center)),
                        TableDataCell(
                            label: Text(e.measuringrange.toString(),
                                textAlign: TextAlign.center)),
                        TableDataCell(
                            label: StreamBuilder<List<String>>(
                                stream: unselectedInstrumentsData.stream,
                                builder: (context, snapshot) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          value: snapshot.data == null
                                              ? true
                                              : snapshot.data!
                                                      .contains(e.id.toString())
                                                  ? false
                                                  : true,
                                          onChanged: (value) {
                                            if (snapshot.data != null &&
                                                snapshot.data!.contains(
                                                    e.id.toString())) {
                                              unselectedInstrumentsList
                                                  .remove(e.id.toString());
                                              unselectedInstrumentsData.add(
                                                  unselectedInstrumentsList);
                                            } else {
                                              unselectedInstrumentsList
                                                  .add(e.id.toString());
                                              unselectedInstrumentsData.add(
                                                  unselectedInstrumentsList);
                                            }
                                          }),
                                      IconButton(
                                          onPressed: () async {
                                            String response =
                                                await CalibrationRepository()
                                                    .cancelCalibration(
                                                        token: state.token,
                                                        payload: {
                                                  'createdby': state.userId,
                                                  'startdate': e.startdate,
                                                  'duedate': e.duedate,
                                                  'instrumentcalibrationscheduleId':
                                                      e.instrumentcalibrationscheduleId,
                                                  'historytableid': e.id,
                                                  'frequency': e.frequency,
                                                  'certificate_mdocid':
                                                      e.certificateId
                                                });
                                            if (response ==
                                                'Deleted successfully') {
                                              blocProvider.add(
                                                  OutwardInstrumentsEvent());
                                            }
                                          },
                                          icon: Icon(
                                            Icons.cancel_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ))
                                    ],
                                  );
                                })),
                      ]))
                  .toList()),
        ),
        StreamBuilder<List<String>>(
            stream: unselectedInstrumentsData.stream,
            builder: (context, snapshot) {
              return FilledButton(
                  onPressed: () async {
                    List<OutsourcedInstrumentsModel> updatedData = [];
                    if (snapshot.data != null) {
                      for (var item in state.outwardInstrumentsList) {
                        bool notInSnapshotData = snapshot.data!
                            .every((element) => item.id != element);
                        if (notInSnapshotData) {
                          updatedData.add(item);
                        }
                      }
                    } else {
                      updatedData = state.outwardInstrumentsList;
                    }
                    if (state.subcontactor.id == null) {
                      QuickFixUi.errorMessage(
                          'Select contractor first.', context);
                    } else if (updatedData.length > 15) {
                      QuickFixUi.errorMessage(
                          'Challan generation requires only 15 elements.',
                          context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const SizedBox(
                                  height: 22,
                                  child: Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.center,
                                  )),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {
                                      dynamic response =
                                          await CalibrationRepository()
                                              .generateChallan(
                                                  token: state.token,
                                                  payload: {
                                            'outwardchallan_no': state.chalanno,
                                            'outsource_date': DateTime.now()
                                                .toString()
                                                .split(' ')[0],
                                            'subcontractor_id':
                                                state.subcontactor.id,
                                            'userid': state.userId
                                          });
                                      if (response['Status'] ==
                                          'Inserted successfully') {
                                        for (var data in updatedData) {
                                          await CalibrationRepository()
                                              .challanReference(
                                                  token: state.token,
                                                  payload: {
                                                'id': data.id,
                                                'outsourceworkorder_id':
                                                    response['id'].toString()
                                              });
                                        }
                                        Navigator.of(context).pop();
                                        blocProvider
                                            .add(OutwardInstrumentsEvent());

                                        generatePDF(
                                          context: context,
                                          size: size,
                                          state: state,
                                          updatedData: updatedData,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            );
                          });
                    }
                  },
                  child: const Text('Generate Challan'));
            })
      ],
    );
  }

  void generatePDF(
      {required BuildContext context,
      required Size size,
      required OutwardInstrumentsState state,
      required List<OutsourcedInstrumentsModel> updatedData}) async {
    final saveddata = await UserData.getUserData();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Challan(
                despatchThrough:
                    "${saveddata['data'][0]["firstname"].toString().trim()} ${saveddata['data'][0]["lastname"].toString().trim()}",
                challanno: state.chalanno,
                date: state.currentdate,
                contractorCompany: state.subcontactor.name.toString(),
                contractorName: state.subcontactor.address1.toString(),
                columns: const [
                  'Sr. No.',
                  'Instrument name',
                  'Instrument type',
                  'Card number',
                  'Range',
                  'Quantity'
                ],
                row: updatedData
                    .map(
                      (e) => pw.TableRow(
                        children: [
                          PDFTableRow().rowTiles(
                            element: (updatedData.indexWhere(
                                        (element) => element.id == e.id) +
                                    1)
                                .toString(),
                          ),
                          PDFTableRow().rowTiles(
                              element: e.instrumentname.toString().trim()),
                          PDFTableRow().rowTiles(
                              element: e.instrumenttype.toString().trim()),
                          PDFTableRow().rowTiles(
                              element: e.cardnumber.toString().trim()),
                          PDFTableRow().rowTiles(
                              element: e.measuringrange.toString().trim()),
                          PDFTableRow().rowTiles(element: '1'),
                        ],
                      ),
                    )
                    .toList(),
              )),
    );
  }

  bottomNavigation({required CalibrationBloc blocProvider}) {
    List<String> items = [
      'Outward instruments',
      'Inward instruments',
      'Outsource workorders'
    ];
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      return NavigationBar(
          selectedIndex: selectedIndex(state),
          onDestinationSelected: (destination) {
            if (destination == 0) {
              blocProvider.add(OutwardInstrumentsEvent());
            } else if (destination == 1) {
              blocProvider.add(InwardInstrumentsEvent());
            } else if (destination == 2) {
              blocProvider.add(OutsourceWorkorderEvent());
            }
          },
          destinations: items
              .map((e) => NavigationDestination(
                  icon: MyIconGenerator.getIcon(
                      name: e.toString(), iconColor: Colors.black),
                  label: e.toString()))
              .toList());
    });
  }

  int selectedIndex(CalibrationState state) {
    if (state is OutwardInstrumentsState) {
      return 0;
    } else if (state is InwardInstrumentsState) {
      return 1;
    } else if (state is OutsourceWorkorderState) {
      return 2;
    } else {
      return 0;
    }
  }
}
