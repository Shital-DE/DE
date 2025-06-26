// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Istrument use outsource dashboard

// ignore_for_file: use_build_context_synchronously

import 'package:de/utils/app_colors.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../../services/model/quality/calibration_model.dart';
import '../../../../../services/model/registration/subcontractor_models.dart';
import '../../../../../services/repository/quality/calibration_repository.dart';
import '../../../../../utils/app_theme.dart';
import '../../../../widgets/PDF/challan.dart';
import 'package:pdf/widgets.dart' as pw;

class InstrumentIssuanceScreen extends StatelessWidget {
  const InstrumentIssuanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CalibrationBloc blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentIssuanceEvent());
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
        } else if (state is InstrumentIssuanceState) {
          return Center(
            child: ListView(
              children: [
                const SizedBox(height: 10),
                vendorDropdown(state: state, blocProvider: blocProvider),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      state.selectedVendor.id != null
                          ? instrumentDropdown(
                              state: state, blocProvider: blocProvider)
                          : const Stack(),
                      const SizedBox(width: 10),
                      state.selectedInstrument.instrumentscheduleId != null
                          ? addButton(
                              state: state,
                              blocProvider: blocProvider,
                              context: context)
                          : const Text("")
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                state.selectedInstumentsDataList.isNotEmpty
                    ? selectedInstrumentTable(
                        size: size,
                        state: state,
                        context: context,
                        blocProvider: blocProvider)
                    : const Stack(),
                const SizedBox(height: 10),
                state.selectedInstumentsDataList.isNotEmpty
                    ? generateChallanButton(
                        context: context,
                        state: state,
                        blocProvider: blocProvider)
                    : const Stack()
              ],
            ),
          );
        } else {
          return const Stack();
        }
      }),
    );
  }

  Center vendorDropdown(
      {required InstrumentIssuanceState state,
      required CalibrationBloc blocProvider}) {
    return Center(
      child: SizedBox(
        width: 300,
        child: DropdownSearch<AllSubContractor>(
          items: state.calibrationVendorList,
          itemAsString: (item) => item.name.toString(),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            itemBuilder: (context, item, isSelected) {
              return ListTile(
                title: Text(
                  item.name.toString(),
                  style: AppTheme.labelTextStyle(),
                ),
              );
            },
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
              textAlign: TextAlign.center,
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Select vendor name',
                hintStyle: AppTheme.labelTextStyle(),
                contentPadding:
                    const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              )),
          onChanged: (value) async {
            blocProvider.add(InstrumentIssuanceEvent(selectedVendor: value));
          },
        ),
      ),
    );
  }

  SizedBox instrumentDropdown(
      {required InstrumentIssuanceState state,
      required CalibrationBloc blocProvider}) {
    return SizedBox(
      width: 300,
      child: DropdownSearch<AvailableInstrumentsModel>(
        items: state.instrumentsList,
        itemAsString: (item) => '${item.instrumentname} --> ${item.cardnumber}',
        popupProps: const PopupPropsMultiSelection.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              style: TextStyle(fontSize: 18),
            )),
        dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                label: Text('Select instruments'),
                border: OutlineInputBorder())),
        onChanged: (value) async {
          blocProvider.add(InstrumentIssuanceEvent(
              selectedVendor: state.selectedVendor,
              selectedInstrument: value,
              selectedInstumentsDataList: state.selectedInstumentsDataList));
        },
      ),
    );
  }

  InkWell addButton(
      {required InstrumentIssuanceState state,
      required CalibrationBloc blocProvider,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        List<AvailableInstrumentsModel> updatedList = [
          ...state.selectedInstumentsDataList,
          state.selectedInstrument
        ];

        blocProvider.add(InstrumentIssuanceEvent(
            selectedVendor: state.selectedVendor,
            selectedInstumentsDataList: updatedList));
      },
      child: Container(
        width: 150,
        height: 50,
        color: Theme.of(context).primaryColor,
        child: const Center(
          child: Text(
            'Add',
            style: TextStyle(
                color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Container selectedInstrumentTable(
      {required Size size,
      required InstrumentIssuanceState state,
      required BuildContext context,
      required CalibrationBloc blocProvider}) {
    return Container(
      width: size.width,
      height: ((state.selectedInstumentsDataList.length + 1) * 40),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: CustomTable(
          tablewidth: size.width - 20,
          tableheight: size.height - 130,
          columnWidth: (size.width - 20) / 3,
          enableBorder: true,
          headerBorderThickness: 1.5,
          tableheaderColor: Theme.of(context).primaryColorLight,
          tableBorderColor: AppColors.blackColor,
          headerStyle: const TextStyle(fontWeight: FontWeight.bold),
          rowHeight: 40,
          headerHeight: 40,
          column:
              state.tableColumnsList.map((e) => ColumnData(label: e)).toList(),
          rows: state.selectedInstumentsDataList
              .map((element) => RowData(cell: [
                    TableDataCell(
                        label: Text(element.instrumentname.toString())),
                    TableDataCell(label: Text(element.cardnumber.toString())),
                    TableDataCell(
                        label: IconButton(
                            onPressed: () {
                              List<AvailableInstrumentsModel> updatedList =
                                  state.selectedInstumentsDataList
                                      .where((e) => !(e.instrumentscheduleId ==
                                          element.instrumentscheduleId))
                                      .toList();
                              blocProvider.add(InstrumentIssuanceEvent(
                                  selectedVendor: state.selectedVendor,
                                  selectedInstumentsDataList: updatedList));
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: AppColors.redTheme,
                            )))
                  ]))
              .toList()),
    );
  }

  Center generateChallanButton(
      {required BuildContext context,
      required InstrumentIssuanceState state,
      required CalibrationBloc blocProvider}) {
    return Center(
      widthFactor: 300,
      child: FilledButton(
          onPressed: () async {
            confirmationDialog(
                context: context, state: state, blocProvider: blocProvider);
          },
          child: const Text("Generate Challan")),
    );
  }

  Future<dynamic> confirmationDialog(
      {required BuildContext context,
      required InstrumentIssuanceState state,
      required CalibrationBloc blocProvider}) {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            content: const SizedBox(
              height: 40,
              child: Center(
                  child: Text(
                "Are you sure?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )),
            ),
            actions: [
              noButton(dialogContext: dialogContext),
              yesButton(
                  dialogContext: dialogContext,
                  state: state,
                  context: context,
                  blocProvider: blocProvider)
            ],
          );
        });
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

  FilledButton yesButton(
      {required BuildContext dialogContext,
      required InstrumentIssuanceState state,
      required BuildContext context,
      required CalibrationBloc blocProvider}) {
    return FilledButton(
        onPressed: () async {
          try {
            Future.delayed(const Duration(seconds: 2), () async {
              dynamic challanResponse = await CalibrationRepository()
                  .generateChallan(token: state.token, payload: {
                'outwardchallan_no': state.challanno,
                'outsource_date': DateTime.now().toString().split(' ')[0],
                'subcontractor_id': state.selectedVendor.id,
                'userid': state.userId
              });
              for (var record in state.selectedInstumentsDataList) {
                String response = await CalibrationRepository()
                    .calibrationHistoryRegistration(
                        token: state.token,
                        payload: {
                      'createdby': state.userId,
                      'instrumentcalibrationschedule_id':
                          record.instrumentscheduleId.toString().trim(),
                      'startdate': record.startdate.toString().trim(),
                      'duedate': record.duedate.toString().trim(),
                      'certificate_id':
                          record.certificateMdocid.toString().trim(),
                      'frequency': record.frequency,
                      'remark':
                          "Instrument outsourced to vendor for operational use."
                    });

                if (response.length == 32) {
                  String issueResponse = await CalibrationRepository()
                      .issueAndReclaimInstruments(token: state.token, payload: {
                    'id': record.instrumentscheduleId.toString().trim(),
                    'isoutsourced': true
                  });

                  if (issueResponse == 'Updated successfully') {
                    if (challanResponse['Status'] == 'Inserted successfully') {
                      await CalibrationRepository().challanReference(
                          token: state.token,
                          payload: {
                            'id': response,
                            'outsourceworkorder_id':
                                challanResponse['id'].toString()
                          });
                    }
                  }
                }
              }
              challanGenerator(context: context, state: state);
            });
            Navigator.of(dialogContext).pop();
            blocProvider.add(CalibrationInitialEvent());
          } catch (error) {
            debugPrint(error.toString());
          }
          blocProvider.add(InstrumentIssuanceEvent());
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.greenTheme),
        ),
        child: const Text('Yes'));
  }

  void challanGenerator(
      {required BuildContext context, required InstrumentIssuanceState state}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (navContext) => Challan(
                despatchThrough: state.userFullName,
                challanno: state.challanno,
                date: state.currentDate,
                contractorCompany: state.selectedVendor.name.toString(),
                contractorName: state.selectedVendor.address1.toString(),
                columns: const [
                  'Sr. No.',
                  'Instrument name',
                  'Instrument type',
                  'Card number',
                  'Range',
                  'Quantity'
                ],
                row: state.selectedInstumentsDataList
                    .map(
                      (e) => pw.TableRow(
                        children: [
                          PDFTableRow().rowTiles(
                            element: (state.selectedInstumentsDataList
                                        .indexWhere((element) =>
                                            element.instrumentscheduleId ==
                                            e.instrumentscheduleId) +
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
}
