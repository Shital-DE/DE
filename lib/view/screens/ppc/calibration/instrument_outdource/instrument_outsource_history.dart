import 'package:de/view/widgets/table/custom_table.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../../services/model/registration/subcontractor_models.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_theme.dart';

class InstrumentOutsourceHistory extends StatelessWidget {
  const InstrumentOutsourceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    CalibrationBloc blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentOutsourceHistoryByContractorEvent());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: BlocBuilder<CalibrationBloc, CalibrationState>(
            builder: (context, state) {
          if (state is CalibrationInitialState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.appTheme,
              ),
            );
          } else if (state is InstrumentOutsourceHistoryByContractorState) {
            return ListView(
              children: [
                const SizedBox(height: 10),
                Center(
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
                            contentPadding: const EdgeInsets.only(
                                bottom: 11, top: 11, left: 2),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2)),
                          )),
                      onChanged: (value) async {
                        blocProvider.add(
                            InstrumentOutsourceHistoryByContractorEvent(
                                selectedVendor: value));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                state.instrumentsListByContractor.isNotEmpty
                    ? Container(
                        height: size.height - 80,
                        width: size.width - 20,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: CustomTable(
                            tablewidth: size.width - 20,
                            tableheight: size.height - 80,
                            columnWidth: 200,
                            enableBorder: true,
                            tableheaderColor:
                                Theme.of(context).primaryColorLight,
                            headerStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            column: state.tableColumnsList
                                .map((e) => ColumnData(label: e))
                                .toList(),
                            rows: state.instrumentsListByContractor.map((e) {
                              double initialHeight = 45,
                                  rowHeight = e.instrumentname != null
                                      ? e.instrumentname!.length * initialHeight
                                      : initialHeight;
                              return RowData(cell: [
                                TableDataCell(
                                    height: rowHeight,
                                    label: Container(
                                      width: 200,
                                      height: rowHeight,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            e.vendorname.toString().trim(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Container(
                                      width: 200,
                                      height: rowHeight,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            e.outwardchallanNo
                                                .toString()
                                                .trim(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.instrumentname != null
                                          ? e.instrumentname!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(e,
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.instrumenttype != null
                                          ? e.instrumenttype!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(e,
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.cardnumber != null
                                          ? e.cardnumber!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(e,
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.measuringrange != null
                                          ? e.measuringrange!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(e,
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.startdate != null
                                          ? e.startdate!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(e,
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.duedate != null
                                          ? e.duedate!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(e,
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.outsourcedBy != null
                                          ? e.outsourcedBy!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(e,
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                                TableDataCell(
                                    height: rowHeight,
                                    label: Column(
                                      children: e.updatedon != null
                                          ? e.updatedon!
                                              .map((e) => Container(
                                                  height: initialHeight,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        DateTime.parse(e)
                                                            .toLocal()
                                                            .toString()
                                                            .substring(0, 10),
                                                        textAlign:
                                                            TextAlign.center),
                                                  )))
                                              .toList()
                                          : [],
                                    )),
                              ]);
                            }).toList()),
                      )
                    : state.selectedVendor != null
                        ? const Center(child: Text('No data available.'))
                        : const Text(''),
                const SizedBox(height: 10),
              ],
            );
          } else {
            return const Center(
              child: Text("No data available."),
            );
          }
        }),
      ),
    );
  }
}
