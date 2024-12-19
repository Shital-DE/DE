// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../services/model/quality/calibration_model.dart';
import '../../../../services/repository/quality/calibration_repository.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/table/custom_table.dart';
import 'order_instrument.dart';

class AllInstrumentOrders extends StatelessWidget {
  const AllInstrumentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(AllInstrumentOrdersEvent());
    return Scaffold(
      body: MakeMeResponsiveScreen(
        horixontaltab: instrumentsOrdersScreen(),
        windows: instrumentsOrdersScreen(),
        linux: instrumentsOrdersScreen(),
      ),
    );
  }

  Center instrumentsOrdersScreen() {
    return Center(child: BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is AllInstrumentOrdersState &&
          state.allinstrumentOrdersList.isNotEmpty) {
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              color: Theme.of(context).primaryColorLight,
              child: const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'All Instrument Orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: Platform.isAndroid
                  ? 500
                  : MediaQuery.of(context).size.height - 200,
              child: ListView(
                children: state.allinstrumentOrdersList
                    .map((e) => Container(
                          width: 400,
                          height: Platform.isAndroid ? 70 : 60,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Color.fromARGB(255, 190, 186, 186)),
                            ),
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              width: 300,
                              child: Text(
                                'From : ${e.fromrecipient}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            title: Text(
                              e.subject.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            subtitle:
                                Text(e.mailcontent.toString().substring(0, 14)),
                            trailing: Text(e.formattedDate.toString()),
                            onTap: () async {
                              List<OneInstrumentOrder> orders =
                                  await CalibrationRepository().getOneOrderData(
                                      id: e.id.toString(), token: state.token);
                              showMail(context: context, e: e, orders: orders);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      } else {
        return const Center(
          child: Text('Orders not available.'),
        );
      }
    }));
  }

  Future<dynamic> showMail(
      {required BuildContext context,
      required AllInstrumentOrdersModel e,
      required List<OneInstrumentOrder> orders}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back)),
                Text(
                  e.subject.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: 600,
              margin: const EdgeInsets.only(left: 50, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From : ${e.fromrecipient}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(e.customDateFormat.toString())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To : ${e.torecipient}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      const Text('')
                    ],
                  ),
                  QuickFixUi.verticalSpace(height: 50),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: Platform.isAndroid ? 470 : 405,
                      child: ListView(
                        children: [
                          Text(e.mailcontent!.substring(0, 6)),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: (orders.length + 1) *
                                (Platform.isAndroid ? 50.5 : 50.5),
                            margin: const EdgeInsets.all(10),
                            child: CustomTable(
                                tablewidth: MediaQuery.of(context).size.width,
                                tableheight: (orders.length + 1) *
                                    (Platform.isAndroid ? 50 : 40),
                                columnWidth:
                                    (MediaQuery.of(context).size.width - 230) /
                                        6,
                                rowHeight: Platform.isAndroid ? 50 : 40,
                                showIndex: true,
                                tableheaderColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withOpacity(0.38),
                                tablebodyColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withOpacity(0.38),
                                tableOutsideBorder: true,
                                headerStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                enableBorder: true,
                                column: InstrumentOrdersCommon()
                                    .ordersTableColumns
                                    .sublist(1),
                                rows: orders
                                    .map((e) => RowData(cell: [
                                          TableDataCell(
                                              label: Text(
                                            e.drawingNumber.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                          TableDataCell(
                                              label: Text(
                                            e.instrumentDescription.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                          TableDataCell(
                                              label: Text(
                                            e.product.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                          TableDataCell(
                                              label: Text(
                                            e.productDescription.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                          TableDataCell(
                                              label: Text(
                                            e.measuringrange.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                          TableDataCell(
                                              label: Text(
                                            e.quantity.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                          TableDataCell(
                                              label: Text(
                                            e.againstRejection.toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                        ]))
                                    .toList()),
                          ),
                          Text(extractBottomPart(e.mailcontent.toString())),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  String extractBottomPart(String input) {
    int startIndex = input.indexOf('Best regards');
    if (startIndex != -1) {
      return input.substring(startIndex).trim();
    }
    return '';
  }
}
