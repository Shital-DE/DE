// ignore_for_file: use_build_context_synchronously

import 'package:de/view/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../../services/model/quality/calibration_model.dart';
import '../../../../../services/repository/quality/calibration_repository.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/PDF/challan.dart';
import 'package:pdf/widgets.dart' as pw;

class InstrumentIssuanceReciept extends StatelessWidget {
  const InstrumentIssuanceReciept({super.key});

  @override
  Widget build(BuildContext context) {
    CalibrationBloc blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentIssuanceReceiptEvent());
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
        } else if (state is InstrumentIssuanceReceiptState) {
          return state.workOrdersList.isEmpty
              ? const Center(
                  child: Text('No instruments outsourced yet.'),
                )
              : Container(
                  width: size.width,
                  height: size.height,
                  margin: const EdgeInsets.all(10),
                  child: CustomTable(
                      tablewidth: size.width - 20,
                      tableheight: size.height - 20,
                      showIndex: true,
                      columnWidth: (size.width - 100) / 5,
                      tableheaderColor: Theme.of(context).primaryColorLight,
                      headerStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      column: state.tableColumnsList
                          .map((e) => ColumnData(label: e))
                          .toList(),
                      rows: state.workOrdersList
                          .map((element) => RowData(cell: [
                                TableDataCell(
                                    label: Text(element.challanno.toString())),
                                TableDataCell(
                                    label: Text(
                                  DateTime.parse(
                                          element.outsourceDate.toString())
                                      .toLocal()
                                      .toString()
                                      .substring(0, 10),
                                )),
                                TableDataCell(
                                    label: Text(element.contractor.toString())),
                                TableDataCell(
                                    label:
                                        Text(element.outsourcedby.toString())),
                                TableDataCell(
                                    label: InkWell(
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    color: AppColors.redTheme,
                                    size: 25,
                                  ),
                                  onTap: () async {
                                    List<OutsourcedInstrumentsModel>
                                        outsourcedElements =
                                        await CalibrationRepository()
                                            .oneChallanData(
                                                token: state.token,
                                                payload: {
                                          'outsourceworkorder_id':
                                              element.outsourceworkorderId
                                        });
                                    if (outsourcedElements.isNotEmpty) {
                                      DateFormat formatter =
                                          DateFormat('dd/MM/yyyy');

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Challan(
                                                  despatchThrough:
                                                      outsourcedElements[0]
                                                          .employeeName
                                                          .toString(),
                                                  challanno: element.challanno
                                                      .toString(),
                                                  date: formatter.format(
                                                      DateTime.parse(element
                                                              .outsourceDate
                                                              .toString())
                                                          .toLocal()),
                                                  contractorCompany: element
                                                      .contractor
                                                      .toString(),
                                                  contractorName: element
                                                      .address1
                                                      .toString(),
                                                  columns: const [
                                                    'Sr. No.',
                                                    'Instrument name',
                                                    'Instrument type',
                                                    'Card number',
                                                    'Range',
                                                    'Quantity'
                                                  ],
                                                  row: outsourcedElements
                                                      .map(
                                                        (e) => pw.TableRow(
                                                          children: [
                                                            PDFTableRow()
                                                                .rowTiles(
                                                              element: (outsourcedElements.indexWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          e.id) +
                                                                      1)
                                                                  .toString(),
                                                            ),
                                                            PDFTableRow().rowTiles(
                                                                element: e
                                                                    .instrumentname
                                                                    .toString()
                                                                    .trim()),
                                                            PDFTableRow().rowTiles(
                                                                element: e
                                                                    .instrumenttype
                                                                    .toString()
                                                                    .trim()),
                                                            PDFTableRow().rowTiles(
                                                                element: e
                                                                    .cardnumber
                                                                    .toString()
                                                                    .trim()),
                                                            PDFTableRow().rowTiles(
                                                                element: e
                                                                    .measuringrange
                                                                    .toString()
                                                                    .trim()),
                                                            PDFTableRow()
                                                                .rowTiles(
                                                                    element:
                                                                        '1'),
                                                          ],
                                                        ),
                                                      )
                                                      .toList(),
                                                )),
                                      );
                                    }
                                  },
                                )),
                              ]))
                          .toList()),
                );
        } else {
          return const Text('');
        }
      }),
    );
  }
}
