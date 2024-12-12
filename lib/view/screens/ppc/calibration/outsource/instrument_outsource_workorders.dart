// ignore_for_file: use_build_context_synchronously

// import 'package:de_opc/services/repository/quality/calibration_repository.dart';
// import 'package:de_opc/utils/responsive.dart';
// import 'package:de_opc/view/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../../services/model/quality/calibration_model.dart';
import '../../../../../services/repository/quality/calibration_repository.dart';
import '../../../../../utils/responsive.dart';
import '../../../../widgets/PDF/challan.dart';
import '../../../../widgets/table/custom_table.dart';

class InstrumentOutsourceWorkorders extends StatelessWidget {
  const InstrumentOutsourceWorkorders({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(OutsourceWorkorderEvent());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: MakeMeResponsiveScreen(
          horixontaltab: outsourceWorkordersScreen(size: size),
          windows: outsourceWorkordersScreen(size: size),
          linux: outsourceWorkordersScreen(size: size)),
    );
  }

  BlocBuilder<CalibrationBloc, CalibrationState> outsourceWorkordersScreen(
      {required Size size}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is OutsourceWorkorderState && state.allWorkorders.isNotEmpty) {
        return Container(
          width: size.width,
          height: size.height,
          margin: const EdgeInsets.all(10),
          child: CustomTable(
              tablewidth: size.width,
              tableheight: (state.allWorkorders.length + 1) * 45,
              rowHeight: 45,
              columnWidth: (size.width - 28) / 5.1,
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
                ColumnData(label: 'Workorder No.'),
                ColumnData(label: 'Outsource date'),
                ColumnData(label: 'Contractor'),
                ColumnData(label: 'Outsourced by'),
                ColumnData(label: 'Certificate'),
              ],
              rows: state.allWorkorders
                  .map((e) => RowData(cell: [
                        TableDataCell(
                            label: Text(
                          e.challanno.toString(),
                          textAlign: TextAlign.center,
                        )),
                        TableDataCell(
                            label: Text(
                          DateTime.parse(e.outsourceDate.toString())
                              .toLocal()
                              .toString()
                              .substring(0, 10),
                          textAlign: TextAlign.center,
                        )),
                        TableDataCell(
                            label: Text(
                          e.contractor.toString(),
                          textAlign: TextAlign.center,
                        )),
                        TableDataCell(
                            label: Text(
                          e.outsourcedby.toString(),
                          textAlign: TextAlign.center,
                        )),
                        TableDataCell(
                            label: IconButton(
                          onPressed: () async {
                            List<OutsourcedInstrumentsModel>
                                outsourcedElements =
                                await CalibrationRepository().oneChallanData(
                                    token: state.token,
                                    payload: {
                                  'outsourceworkorder_id':
                                      e.outsourceworkorderId
                                });
                            if (outsourcedElements.isNotEmpty) {
                              generateChallan(
                                  context: context,
                                  size: size,
                                  outsource: e,
                                  outsourcedElements: outsourcedElements);
                            }
                          },
                          icon: Icon(
                            Icons.picture_as_pdf,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )),
                      ]))
                  .toList()),
        );
      } else {
        return const Center(child: Text('No elements are outsourced yet.'));
      }
    });
  }

  generateChallan(
      {required BuildContext context,
      required Size size,
      required OutsorceWorkordersModel outsource,
      required List<OutsourcedInstrumentsModel> outsourcedElements}) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Challan(
                despatchThrough: outsourcedElements[0].employeeName.toString(),
                challanno: outsource.challanno.toString(),
                date: formatter.format(
                    DateTime.parse(outsource.outsourceDate.toString())
                        .toLocal()),
                contractorCompany: outsource.contractor.toString(),
                contractorName: outsource.address1.toString(),
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
                          PDFTableRow().rowTiles(
                            element: (outsourcedElements.indexWhere(
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
}
