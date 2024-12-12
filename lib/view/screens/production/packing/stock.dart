// Author : Shital Gayakwad
// Created Date : 28 Nov 2023
// Description : Stock dashboard

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/packing_bloc/packing_bloc.dart';
import '../../../../bloc/production/packing_bloc/packing_event.dart';
import '../../../../bloc/production/packing_bloc/packing_state.dart';
import '../../../../services/model/packing/packing_model.dart';
import '../../../../services/repository/packing/packing_repository.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/product.dart';

class Stock extends StatelessWidget {
  const Stock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: 'Available stock'),
      body: MakeMeResponsiveScreen(
        horixontaltab: getBody(context: context),
        windows: getBody(context: context),
        linux: getBody(context: context),
      ),
    );
  }

  ListView getBody({required BuildContext context}) {
    final blocProvider = BlocProvider.of<PackingBloc>(context);
    StreamController<List<AvailableStock>> searchedProducts =
        StreamController<List<AvailableStock>>.broadcast();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 170, top: 10),
          child: Text(
            'Register stock :',
            style: headerDecoration(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 160),
          child: registerStockWidget(blocProvider: blocProvider),
        ),
        QuickFixUi.verticalSpace(height: 10),
        Padding(
          padding:
              const EdgeInsets.only(left: 170, top: 10, bottom: 10, right: 170),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available stock :',
                style: headerDecoration(context),
              ),
              SizedBox(
                  width: 200,
                  child: BlocBuilder<PackingBloc, PackingState>(
                      builder: (context, state) {
                    if (state is StockState &&
                        state.availableStock.isNotEmpty) {
                      return TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Search stock',
                            suffixIcon: Icon(
                              Icons.search,
                            )),
                        onChanged: (value) {
                          List<AvailableStock> searchedData =
                              state.availableStock.where((item) {
                            String itemString =
                                item.product.toString().toLowerCase();
                            return itemString.contains(value.toLowerCase());
                          }).toList();
                          searchedProducts.add(searchedData);
                        },
                      );
                    } else {
                      return const Stack();
                    }
                  }))
            ],
          ),
        ),
        Center(
          child:
              BlocBuilder<PackingBloc, PackingState>(builder: (context, state) {
            if (state is StockState && state.availableStock.isNotEmpty) {
              double width = 1000, height = state.availableStock.length + 1;
              return StreamBuilder<List<AvailableStock>>(
                  stream: searchedProducts.stream,
                  builder: (context, snapshot) {
                    return availableStockTable(
                        width: width,
                        height: height * 50,
                        availableStock: snapshot.data ?? state.availableStock,
                        context: context);
                  });
            } else {
              return const Stack();
            }
          }),
        )
      ],
    );
  }

  SizedBox availableStockTable(
      {required double width,
      required double height,
      required List<AvailableStock> availableStock,
      required BuildContext context}) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomTable(
        tablewidth: width,
        tableheight: height,
        showIndex: true,
        columnWidth: width / 5,
        rowHeight: 50,
        enableRowBottomBorder: true,
        tableOutsideBorder: true,
        tableheaderColor: Theme.of(context).colorScheme.inversePrimary,
        tableBorderColor: Theme.of(context).primaryColor,
        headerStyle: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        column: [
          ColumnData(label: 'Product'),
          ColumnData(label: 'Revision', width: 100),
          ColumnData(label: 'Stock quantity'),
          ColumnData(label: 'Box number'),
          ColumnData(label: 'Stock Controller', width: 250),
        ],
        rows: availableStock
            .map((e) => RowData(cell: [
                  TableDataCell(
                      label: Text(
                    e.product.toString(),
                    textAlign: TextAlign.center,
                  )),
                  TableDataCell(
                      width: 100,
                      label: Text(
                        e.revision == null ? '' : e.revision.toString(),
                        textAlign: TextAlign.center,
                      )),
                  TableDataCell(
                      label: Text(
                    e.stockqty.toString(),
                    textAlign: TextAlign.center,
                  )),
                  TableDataCell(
                      label: Text(
                    e.boxnumber.toString(),
                    textAlign: TextAlign.center,
                  )),
                  TableDataCell(
                      width: 250,
                      label: Text(
                        e.stockUploader.toString(),
                        textAlign: TextAlign.center,
                      )),
                ]))
            .toList(),
      ),
    );
  }

  TextStyle headerDecoration(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 18);
  }

  Row registerStockWidget({required PackingBloc blocProvider}) {
    TextEditingController selectedRevision = TextEditingController();
    TextEditingController stockQuantity = TextEditingController();
    TextEditingController boxNumber = TextEditingController();
    blocProvider.add(StockEvent());
    return Row(
      children: [
        QuickFixUi.horizontalSpace(width: 10),
        BlocBuilder<PackingBloc, PackingState>(builder: (context, state) {
          return Container(
              width: 200,
              height: 50,
              margin: const EdgeInsets.only(top: 10),
              child: ProductSearch(
                onChanged: (value) {
                  blocProvider.add(StockEvent(productid: value!.id.toString()));
                },
              ));
        }),
        QuickFixUi.horizontalSpace(width: 10),
        BlocBuilder<PackingBloc, PackingState>(builder: (context, state) {
          if (state is StockState &&
              state.revision.isNotEmpty &&
              state.productId != '') {
            return Row(
              children: [
                Container(
                    width: 200,
                    height: 50,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: QuickFixUi().borderContainer(
                      borderThickness: .5,
                    ),
                    child: DropdownSearch(
                      items: state.revision,
                      itemAsString: (item) => item.revisionNumber.toString(),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          textAlign: TextAlign.center,
                          dropdownSearchDecoration: InputDecoration(
                              hintText: 'Product revision',
                              border: InputBorder.none)),
                      onChanged: (value) {
                        selectedRevision.text =
                            value!.revisionNumber.toString();
                      },
                    )),
                QuickFixUi.horizontalSpace(width: 10),
                Container(
                  width: 200,
                  height: 50,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 10),
                  decoration: QuickFixUi().borderContainer(
                    borderThickness: .5,
                  ),
                  child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Stock quantity'),
                      onChanged: (value) {
                        stockQuantity.text = value.toString();
                      }),
                ),
                QuickFixUi.horizontalSpace(width: 10),
                Container(
                  width: 200,
                  height: 50,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 10),
                  decoration: QuickFixUi().borderContainer(
                    borderThickness: .5,
                  ),
                  child: TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Box number'),
                      onChanged: (value) {
                        boxNumber.text = value.toString();
                      }),
                ),
                QuickFixUi.horizontalSpace(width: 10),
                Container(
                    width: 120,
                    height: 40,
                    margin: const EdgeInsets.only(top: 10),
                    child: FilledButton(
                        onPressed: () async {
                          if (state.productId == '') {
                            QuickFixUi.errorMessage(
                                'Product not found', context);
                          } else if (selectedRevision.text == '') {
                            QuickFixUi.errorMessage(
                                'Product revision not found', context);
                          } else if (stockQuantity.text == '') {
                            QuickFixUi.errorMessage(
                                'Stock quantity not found', context);
                          } else if (boxNumber.text == '') {
                            QuickFixUi.errorMessage(
                                'Box number not found', context);
                          } else {
                            String response = await PackingRepository()
                                .registerStock(token: state.token, payload: {
                              'product_id': state.productId.toString().trim(),
                              'revision':
                                  selectedRevision.text.toString().trim(),
                              'stockqty': stockQuantity.text.toString().trim(),
                              'boxnumber': boxNumber.text.characters
                                  .toString()
                                  .trim()
                                  .toUpperCase(),
                              'user_id': state.userid
                            });
                            if (response == 'Stock registered successfully.') {
                              blocProvider.add(StockEvent(productid: ''));
                              selectedRevision.text = '';
                              stockQuantity.text = '';
                              boxNumber.text = '';
                              QuickFixUi.successMessage(response, context);
                            }
                          }
                        },
                        child: const Text('SUBMIT')))
              ],
            );
          } else {
            return const Stack();
          }
        }),
      ],
    );
  }
}
