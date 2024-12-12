// Author : Shital Gayakwad
// Created Date : 15 November 2024
// Description : Sales orders

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:de/bloc/sales_order/sales_order_event.dart';
import 'package:de/routes/route_names.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/sales_order/sales_order_bloc.dart';
import '../../../bloc/sales_order/sales_order_state.dart';
import '../../../services/repository/sales_order/sales_order_repository.dart';
import '../../widgets/appbar.dart';

class Salesorders extends StatefulWidget {
  const Salesorders({super.key});

  @override
  State<Salesorders> createState() => _SalesordersState();
}

class _SalesordersState extends State<Salesorders> {
  // Stream controllers
  StreamController<String> selectRowController =
      StreamController<String>.broadcast();
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();

  // Scroll controllers
  final ScrollController descriptionScrollController = ScrollController();

  @override
  void initState() {
    final blocProvider = BlocProvider.of<SalesOrderBloc>(context);
    blocProvider.add(AllOrdersEvent());
    super.initState();
  }

  @override
  void dispose() {
    // Stream controllers
    selectRowController.close();

    // Scroll controllers
    descriptionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<SalesOrderBloc>(context);
    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: 'Sales orders'),
      body: MakeMeResponsiveScreen(
        horixontaltab:
            salesOrderScreen(context: context, blocProvider: blocProvider),
        windows: salesOrderScreen(context: context, blocProvider: blocProvider),
      ),
    );
  }

  Center salesOrderScreen(
      {required BuildContext context, required SalesOrderBloc blocProvider}) {
    Size size = MediaQuery.of(context).size;
    double datpickerstaticHeight = 121 + (Platform.isAndroid ? 24.3 : 0);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 35,
            width: 520,
            child: Row(
              children: [
                Container(
                  width: 200,
                  decoration:
                      BoxDecoration(color: Colors.white, border: Border.all()),
                  child: TextField(
                    readOnly: true,
                    controller: fromdate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'From date',
                      hintStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(bottom: Platform.isAndroid ? 12 : 17),
                    ),
                    onTap: () async {
                      blocProvider.add(AllOrdersEvent());
                      fromdate.text = '';
                      todate.text = '';
                      fromdate.text =
                          await SalesOrderRepository().getDate(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 200,
                  decoration:
                      BoxDecoration(color: Colors.white, border: Border.all()),
                  child: TextField(
                    readOnly: true,
                    controller: todate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'To date',
                      hintStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(bottom: Platform.isAndroid ? 12 : 17),
                    ),
                    onTap: () async {
                      blocProvider.add(AllOrdersEvent());
                      todate.text = '';
                      todate.text =
                          await SalesOrderRepository().getDate(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  child: Container(
                    height: 35,
                    width: 100,
                    color: Theme.of(context).primaryColorDark.withOpacity(.5),
                    child: const Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  onTap: () {
                    blocProvider.add(AllOrdersEvent(
                        fromdate: fromdate.text, todate: todate.text));
                  },
                )
              ],
            ),
          ),
          BlocBuilder<SalesOrderBloc, SalesOrderState>(
              builder: (context, state) {
            if (state is InitialSalesOrderState) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else if (state is AllOrdersState) {
              return state.allSalesOrdersList.isEmpty
                  ? const Text('')
                  : StreamBuilder<String>(
                      stream: selectRowController.stream,
                      builder: (context, selectRowControllersnapshot) {
                        double poColumnWidth = 150,
                            productDetailsColumnWidth =
                                (size.width - 22) - poColumnWidth,
                            staticrowHeight = 40;
                        return Container(
                          margin: const EdgeInsets.all(10),
                          width: size.width - 20,
                          height: selectRowControllersnapshot.data != null
                              ? size.height - datpickerstaticHeight
                              : ((state.allSalesOrdersList.length + 2) *
                                          staticrowHeight) <
                                      (size.height - 21)
                                  ? ((state.allSalesOrdersList.length + 2) *
                                      staticrowHeight)
                                  : size.height - datpickerstaticHeight,
                          child: CustomTable(
                            tablewidth: size.width - 21,
                            tableheight: size.height - datpickerstaticHeight,
                            headerHeight: staticrowHeight,
                            headerStyle:
                                tableHeaderTextStyle(color: Colors.black),
                            tableheaderColor: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(.5),
                            enableBorder: true,
                            tableOutsideBorder: true,
                            tableBorderColor:
                                Theme.of(context).primaryColorDark,
                            column: [
                              ColumnData(
                                  width: poColumnWidth, label: 'Order number'),
                              ColumnData(
                                  width: productDetailsColumnWidth,
                                  label: 'Products in order')
                            ],
                            rows: state.allSalesOrdersList.map((orderElement) {
                              double rowHeight = staticrowHeight;
                              if (selectRowControllersnapshot.data != null &&
                                  selectRowControllersnapshot.data! ==
                                      orderElement.salesorderId) {
                                rowHeight = (orderElement.productsInOrder ==
                                        null
                                    ? 0
                                    : (orderElement.productsInOrder!.length +
                                            1) *
                                        staticrowHeight);
                              } else {
                                rowHeight = staticrowHeight;
                              }
                              return RowData(cell: [
                                TableDataCell(
                                    width: poColumnWidth,
                                    height: rowHeight,
                                    label: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (selectRowControllersnapshot
                                                        .data !=
                                                    null &&
                                                selectRowControllersnapshot
                                                        .data! ==
                                                    orderElement.salesorderId) {
                                              selectRowController.add('');
                                            } else {
                                              selectRowController.add(
                                                  orderElement.salesorderId
                                                      .toString());
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  orderElement.po
                                                      .toString()
                                                      .trim(),
                                                  textAlign: TextAlign.center,
                                                  style: rowTextStyle(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: selectRowControllersnapshot
                                                                  .data !=
                                                              null &&
                                                          selectRowControllersnapshot
                                                                  .data! ==
                                                              orderElement
                                                                  .salesorderId
                                                      ? const Icon(
                                                          Icons.arrow_drop_down,
                                                          size: 25,
                                                          color: Colors.green,
                                                        )
                                                      : Icon(
                                                          Icons.arrow_right,
                                                          size: 25,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                TableDataCell(
                                    width: productDetailsColumnWidth,
                                    height: rowHeight,
                                    label: selectRowControllersnapshot.data !=
                                                null &&
                                            selectRowControllersnapshot.data! ==
                                                orderElement.salesorderId
                                        ? orderElement.productsInOrder !=
                                                    null &&
                                                orderElement
                                                    .productsInOrder!.isNotEmpty
                                            ? CustomTable(
                                                tablewidth:
                                                    productDetailsColumnWidth,
                                                tableheight: rowHeight - 1,
                                                headerStyle: tableHeaderTextStyle(
                                                    color: Colors.black),
                                                columnWidth:
                                                    (productDetailsColumnWidth -
                                                            1) /
                                                        7,
                                                headerHeight: staticrowHeight,
                                                rowHeight: staticrowHeight,
                                                tableheaderColor: Theme
                                                        .of(context)
                                                    .primaryColorLight,
                                                enableRowBottomBorder: true,
                                                tableBorderColor:
                                                    Theme.of(context)
                                                        .primaryColorDark,
                                                borderThickness: .6,
                                                column: [
                                                  ColumnData(label: 'Product'),
                                                  ColumnData(label: 'Revision'),
                                                  ColumnData(
                                                      label: 'Product type'),
                                                  ColumnData(
                                                      label: 'Description'),
                                                  ColumnData(
                                                      label: 'Dispatch date'),
                                                  ColumnData(label: 'Quantity'),
                                                  ColumnData(label: 'Action')
                                                ],
                                                rows: orderElement
                                                    .productsInOrder!
                                                    .map((orderDetailsElement) {
                                                  return RowData(cell: [
                                                    TableDataCell(
                                                        label: Text(
                                                      orderDetailsElement
                                                          .product
                                                          .toString()
                                                          .trim(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowTextStyle(),
                                                    )),
                                                    TableDataCell(
                                                        label: Text(
                                                      orderDetailsElement
                                                          .revision
                                                          .toString()
                                                          .trim(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowTextStyle(),
                                                    )),
                                                    TableDataCell(
                                                        label: Text(
                                                      orderDetailsElement
                                                          .productType
                                                          .toString()
                                                          .trim(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowTextStyle(),
                                                    )),
                                                    TableDataCell(
                                                        label: Scrollbar(
                                                      thickness: 7,
                                                      controller:
                                                          descriptionScrollController,
                                                      child:
                                                          SingleChildScrollView(
                                                        controller:
                                                            descriptionScrollController,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          orderDetailsElement
                                                              .productDescription
                                                              .toString()
                                                              .trim(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: rowTextStyle(),
                                                        ),
                                                      ),
                                                    )),
                                                    TableDataCell(
                                                        label: Text(
                                                      DateTime.parse(
                                                              orderDetailsElement
                                                                  .dueDate
                                                                  .toString()
                                                                  .trim())
                                                          .toLocal()
                                                          .toString()
                                                          .substring(0, 10),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowTextStyle(),
                                                    )),
                                                    TableDataCell(
                                                        label: Text(
                                                      orderDetailsElement
                                                          .quantity
                                                          .toString()
                                                          .trim(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowTextStyle(),
                                                    )),
                                                    TableDataCell(
                                                        label: Center(
                                                      child: Checkbox(
                                                          value:
                                                              orderDetailsElement
                                                                  .action,
                                                          onChanged:
                                                              (value) async {
                                                            if (orderDetailsElement
                                                                    .action ==
                                                                false) {
                                                              Map<String,
                                                                      dynamic>
                                                                  response =
                                                                  await SalesOrderRepository().generateAssemblyComponentRequirement(
                                                                      token: state
                                                                          .token,
                                                                      payload: {
                                                                    'childproduct_id':
                                                                        orderDetailsElement
                                                                            .productId,
                                                                    'revision_number':
                                                                        orderDetailsElement
                                                                            .revision,
                                                                    'sodetails_id':
                                                                        orderDetailsElement
                                                                            .salesorderdetailsId,
                                                                    'createdby':
                                                                        state
                                                                            .userId,
                                                                    'order_quantity':
                                                                        orderDetailsElement
                                                                            .quantity,
                                                                    'from':
                                                                        fromdate
                                                                            .text,
                                                                    'to': todate
                                                                        .text
                                                                  });

                                                              if (response[
                                                                      'message'] ==
                                                                  'success') {
                                                                blocProvider.add(AllOrdersEvent(
                                                                    fromdate: state
                                                                        .fromdate,
                                                                    todate: state
                                                                        .todate));
                                                                selectRowController.add(
                                                                    orderElement
                                                                        .salesorderId
                                                                        .toString());
                                                              } else {
                                                                QuickFixUi.errorMessage(
                                                                    response[
                                                                            'message']
                                                                        .toString(),
                                                                    context);
                                                              }
                                                            } else {
                                                              Map<String,
                                                                      dynamic>
                                                                  response =
                                                                  await SalesOrderRepository().discardAssemblyComponentRequirement(
                                                                      token: state
                                                                          .token,
                                                                      payload: {
                                                                    'parentproduct_id':
                                                                        orderDetailsElement
                                                                            .productId
                                                                            .toString(),
                                                                    'sodetails_id':
                                                                        orderDetailsElement
                                                                            .salesorderdetailsId
                                                                            .toString()
                                                                  });

                                                              if (response[
                                                                      'Message'] ==
                                                                  'Success') {
                                                                blocProvider.add(AllOrdersEvent(
                                                                    fromdate: state
                                                                        .fromdate,
                                                                    todate: state
                                                                        .todate));
                                                                selectRowController.add(
                                                                    orderElement
                                                                        .salesorderId
                                                                        .toString());
                                                              } else {
                                                                QuickFixUi.errorMessage(
                                                                    response[
                                                                            'Message']
                                                                        .toString(),
                                                                    context);
                                                              }
                                                            }
                                                          }),
                                                    ))
                                                  ]);
                                                }).toList())
                                            : const Text(
                                                'Products not available.',
                                                textAlign: TextAlign.left,
                                              )
                                        : const Text(''))
                              ]);
                            }).toList(),
                            footer: Container(
                                width: size.width - 21,
                                height: staticrowHeight,
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(.1),
                                child:
                                    state.selectedAssembliesDataList.isNotEmpty
                                        ? Center(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      RouteName
                                                          .assemblyComponentRequirementsScreen,
                                                      arguments: {
                                                        'selectedAssembliesDataList':
                                                            state
                                                                .selectedAssembliesDataList
                                                      });
                                                },
                                                child: const Text('Check')),
                                          )
                                        : const Text('')),
                          ),
                        );
                      });
            } else if (state is SalesOrderErrorState) {
              return Container(
                margin: const EdgeInsets.all(10),
                width: size.width - 20,
                height: size.height - datpickerstaticHeight,
                child: Center(
                    child: Text(state.errorMessage,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
              );
            } else {
              return const Stack();
            }
          }),
        ],
      ),
    );
  }

  TextStyle rowTextStyle() => const TextStyle(fontSize: 14);

  TextStyle tableHeaderTextStyle({required Color color}) =>
      TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold);
}
