// Author : Shital Gayakwad
// Created Date : 20 November 2024
// Description : Product inventory management

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:de/utils/common/quickfix_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/product_dashboard/product_dashboard_bloc.dart';
import '../../../bloc/product_dashboard/product_dashboard_event.dart';
import '../../../bloc/product_dashboard/product_dashboard_state.dart';
import '../../../services/model/product/product_structure_model.dart';
import '../../../services/repository/product/pam_repository.dart';

class ProductInventoryManagement extends StatefulWidget {
  const ProductInventoryManagement({super.key});

  @override
  State<ProductInventoryManagement> createState() =>
      _ProductInventoryManagementState();
}

class _ProductInventoryManagementState
    extends State<ProductInventoryManagement> {
  StreamController<ProductInventoryManagementDetailsModel>
      productInventoryManagementDetails =
      StreamController<ProductInventoryManagementDetailsModel>.broadcast();
  @override
  void initState() {
    final blocProvider = BlocProvider.of<ProductDashboardBloc>(context);
    blocProvider.add(ProductInventoryManagementEvent());
    super.initState();
  }

  @override
  void dispose() {
    productInventoryManagementDetails.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double conWidth = 200, conHeight = 40, paramWidth = 190;
    final blocProvider = BlocProvider.of<ProductDashboardBloc>(context);
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.inversePrimary.withOpacity(.2),
      body: Center(child:
          BlocBuilder<ProductDashboardBloc, ProductDashboardState>(
              builder: (context, state) {
        if (state is ProductInventoryManagementState) {
          List<String> stockEventList = [
            'Inward',
            state.currentStock > 0 ? 'Issue' : '',
            state.currentStock > 0 ? 'Scrap' : ''
          ];
          return StreamBuilder<ProductInventoryManagementDetailsModel>(
              stream: productInventoryManagementDetails.stream,
              builder: (context, productInventoryManagementDetailsSnapshot) {
                String selectedValue = '';
                if (productInventoryManagementDetailsSnapshot.data != null &&
                    productInventoryManagementDetailsSnapshot
                            .data!.stockEvent !=
                        '') {
                  selectedValue = productInventoryManagementDetailsSnapshot
                      .data!.stockEvent;
                }
                return Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      top: 10, left: 100, right: 100, bottom: 10),
                  child: ListView(
                    children: [
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Product inventory management',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (productInventoryManagementDetailsSnapshot
                                                  .data !=
                                              null &&
                                          productInventoryManagementDetailsSnapshot
                                                  .data!
                                                  .selectedRevisionNumber !=
                                              '')
                                      ? paramenterContainer(
                                          conHeight: conHeight,
                                          value: 'Product',
                                          paramWidth: paramWidth)
                                      : const Stack(),
                                  Container(
                                    width: conWidth,
                                    height: conHeight,
                                    padding: const EdgeInsets.only(left: 20),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Center(
                                      child: DropdownSearch<
                                          ProductsWithRevisionDataModel>(
                                        items: state.productsList,
                                        itemAsString: (item) =>
                                            item.product.toString(),
                                        popupProps: const PopupProps.menu(
                                            showSearchBox: true,
                                            searchFieldProps: TextFieldProps(
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  hintText: 'Select product',
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  border: InputBorder.none),
                                          textAlign: TextAlign.center,
                                        ),
                                        onBeforeChange:
                                            (prevItem, nextItem) async {
                                          blocProvider.add(
                                              ProductInventoryManagementEvent());
                                          productInventoryManagementDetails.add(
                                              ProductInventoryManagementDetailsModel());
                                          return true;
                                        },
                                        onChanged: (value) {
                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            blocProvider.add(
                                                ProductInventoryManagementEvent(
                                                    productsWithRevisionDataModel:
                                                        value));
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              (state.productsWithRevisionDataModel
                                              .revisionNumbers !=
                                          null &&
                                      state.productsWithRevisionDataModel
                                          .revisionNumbers!.isNotEmpty &&
                                      state.productsWithRevisionDataModel
                                              .revisionNumbers![0] !=
                                          '')
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        (productInventoryManagementDetailsSnapshot
                                                        .data !=
                                                    null &&
                                                productInventoryManagementDetailsSnapshot
                                                        .data!
                                                        .selectedRevisionNumber !=
                                                    '')
                                            ? paramenterContainer(
                                                conHeight: conHeight,
                                                value: 'Revision',
                                                paramWidth: paramWidth)
                                            : const SizedBox(width: 10),
                                        Container(
                                          width: conWidth,
                                          height: conHeight,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          child: DropdownSearch(
                                            items: state.productsWithRevisionDataModel
                                                            .revisionNumbers !=
                                                        null &&
                                                    state
                                                        .productsWithRevisionDataModel
                                                        .revisionNumbers!
                                                        .isNotEmpty
                                                ? state
                                                    .productsWithRevisionDataModel
                                                    .revisionNumbers!
                                                : [],
                                            itemAsString: (item) =>
                                                item.toString(),
                                            popupProps: const PopupProps.menu(
                                                showSearchBox: true,
                                                searchFieldProps:
                                                    TextFieldProps(
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )),
                                            dropdownDecoratorProps:
                                                const DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                      hintText: 'Revision',
                                                      hintStyle: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                      border: InputBorder.none),
                                              textAlign: TextAlign.center,
                                            ),
                                            onChanged: (value) {
                                              productInventoryManagementDetails.add(
                                                  ProductInventoryManagementDetailsModel(
                                                      selectedRevisionNumber:
                                                          value
                                                              .toString()
                                                              .trim()));
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Stack()
                            ],
                          ),
                        ),
                      ),
                      productInventoryManagementDetailsSnapshot.data != null &&
                              productInventoryManagementDetailsSnapshot
                                      .data!.selectedRevisionNumber !=
                                  ''
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        paramenterContainer(
                                            conHeight: conHeight,
                                            value: 'Product type',
                                            paramWidth: paramWidth),
                                        Container(
                                            width: conWidth,
                                            height: conHeight,
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            child: Center(
                                              child: Text(
                                                state
                                                    .productsWithRevisionDataModel
                                                    .producttype
                                                    .toString(),
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        paramenterContainer(
                                            conHeight: conHeight,
                                            value: 'Description',
                                            paramWidth: paramWidth),
                                        Container(
                                            width: conWidth,
                                            height: conHeight,
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            child: Center(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  state
                                                      .productsWithRevisionDataModel
                                                      .description
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const Stack(),
                      (productInventoryManagementDetailsSnapshot.data != null &&
                              productInventoryManagementDetailsSnapshot
                                      .data!.selectedRevisionNumber !=
                                  '')
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        paramenterContainer(
                                            conHeight: conHeight,
                                            value: 'Current Stock',
                                            paramWidth: paramWidth),
                                        SizedBox(
                                            width: conWidth,
                                            height: conHeight,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    width: conWidth / 2,
                                                    height: conHeight,
                                                    decoration: BoxDecoration(
                                                        border: Border.all()),
                                                    child: Center(
                                                      child: Text(
                                                        state.currentStock
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: conWidth / 2,
                                                    height: conHeight,
                                                    child: Center(
                                                      child: Text(state
                                                          .productsWithRevisionDataModel
                                                          .uom
                                                          .toString()),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: conWidth + paramWidth,
                                          height: conHeight,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const Stack(),
                      (productInventoryManagementDetailsSnapshot.data != null &&
                              productInventoryManagementDetailsSnapshot
                                      .data!.selectedRevisionNumber !=
                                  '')
                          ? Center(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: stockEventList
                                        .map((se) => se != ''
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Radio<String>(
                                                      value: se,
                                                      groupValue: selectedValue,
                                                      onChanged: (val) {
                                                        if (val != null) {
                                                          productInventoryManagementDetails.add(
                                                              ProductInventoryManagementDetailsModel(
                                                                  selectedRevisionNumber:
                                                                      productInventoryManagementDetailsSnapshot
                                                                          .data!
                                                                          .selectedRevisionNumber,
                                                                  stockEvent:
                                                                      val));
                                                        }
                                                      },
                                                    ),
                                                    Text(se)
                                                  ],
                                                ),
                                              )
                                            : const Stack())
                                        .toList(),
                                  )),
                            )
                          : const Stack(),
                      (productInventoryManagementDetailsSnapshot.data != null &&
                              productInventoryManagementDetailsSnapshot
                                      .data!.selectedRevisionNumber !=
                                  '')
                          ? (productInventoryManagementDetailsSnapshot
                                          .data!.stockEvent !=
                                      '' &&
                                  productInventoryManagementDetailsSnapshot
                                          .data!.stockEvent ==
                                      stockEventList[0])
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    quantityWidget(
                                        conHeight: conHeight,
                                        paramWidth: paramWidth,
                                        conWidth: conWidth,
                                        productInventoryManagementDetailsSnapshot:
                                            productInventoryManagementDetailsSnapshot),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        paramenterContainer(
                                            conHeight: conHeight,
                                            value: 'Unit of measurement',
                                            paramWidth: paramWidth),
                                        Container(
                                          width: conWidth,
                                          height: conHeight,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          child: DropdownSearch<UOMDataModel>(
                                            items: state.unitOfMeasurementList,
                                            itemAsString: (item) =>
                                                item.uomName.toString(),
                                            popupProps: const PopupProps.menu(
                                                showSearchBox: true,
                                                searchFieldProps:
                                                    TextFieldProps(
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )),
                                            dropdownDecoratorProps:
                                                const DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                      border: InputBorder.none),
                                              textAlign: TextAlign.center,
                                            ),
                                            onChanged: (value) {
                                              if (value.toString() != 'null' &&
                                                  value.toString() != '') {
                                                productInventoryManagementDetails.add(
                                                    ProductInventoryManagementDetailsModel(
                                                        selectedRevisionNumber:
                                                            productInventoryManagementDetailsSnapshot
                                                                .data!
                                                                .selectedRevisionNumber
                                                                .toString()
                                                                .trim(),
                                                        stockEvent:
                                                            productInventoryManagementDetailsSnapshot
                                                                .data!
                                                                .stockEvent,
                                                        quantity:
                                                            productInventoryManagementDetailsSnapshot
                                                                .data!.quantity,
                                                        uomId: value!.id
                                                            .toString()));
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : (productInventoryManagementDetailsSnapshot
                                              .data!.stockEvent !=
                                          '' &&
                                      productInventoryManagementDetailsSnapshot
                                              .data!.stockEvent ==
                                          stockEventList[1])
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            quantityWidget(
                                                conHeight: conHeight,
                                                paramWidth: paramWidth,
                                                conWidth: conWidth,
                                                productInventoryManagementDetailsSnapshot:
                                                    productInventoryManagementDetailsSnapshot),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                paramenterContainer(
                                                    conHeight: conHeight,
                                                    value: 'Parent product',
                                                    paramWidth: paramWidth),
                                                Container(
                                                  width: conWidth,
                                                  height: conHeight,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  decoration: BoxDecoration(
                                                      border: Border.all()),
                                                  child: DropdownSearch<
                                                      CurrentSalesOrdersDataModel>(
                                                    items: state
                                                        .salesOrderDataList,
                                                    itemAsString: (item) =>
                                                        item.product.toString(),
                                                    popupProps:
                                                        const PopupProps.menu(
                                                            showSearchBox: true,
                                                            searchFieldProps:
                                                                TextFieldProps(
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            )),
                                                    dropdownDecoratorProps:
                                                        const DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onChanged: (value) {
                                                      if (value.toString() !=
                                                              'null' &&
                                                          value.toString() !=
                                                              '') {
                                                        productInventoryManagementDetails.add(ProductInventoryManagementDetailsModel(
                                                            selectedRevisionNumber:
                                                                productInventoryManagementDetailsSnapshot
                                                                    .data!
                                                                    .selectedRevisionNumber
                                                                    .toString()
                                                                    .trim(),
                                                            stockEvent:
                                                                productInventoryManagementDetailsSnapshot
                                                                    .data!
                                                                    .stockEvent,
                                                            quantity:
                                                                productInventoryManagementDetailsSnapshot
                                                                    .data!
                                                                    .quantity,
                                                            uomId: state
                                                                .productsWithRevisionDataModel
                                                                .uomId
                                                                .toString(),
                                                            parentProductId:
                                                                value!.productId
                                                                    .toString(),
                                                            soDetailsId: value
                                                                .ssSalesorderId
                                                                .toString(),
                                                            soNumber: value.po
                                                                .toString()));
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                paramenterContainer(
                                                    conHeight: conHeight,
                                                    value: 'Sales order Number',
                                                    paramWidth: paramWidth),
                                                Container(
                                                    width: conWidth,
                                                    height: conHeight,
                                                    decoration: BoxDecoration(
                                                        border: Border.all()),
                                                    child: Center(
                                                      child: Text(
                                                          productInventoryManagementDetailsSnapshot
                                                              .data!.soNumber
                                                              .toString()),
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: conWidth + paramWidth,
                                                  height: conHeight,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  : (productInventoryManagementDetailsSnapshot
                                                  .data!.stockEvent !=
                                              '' &&
                                          productInventoryManagementDetailsSnapshot
                                                  .data!.stockEvent ==
                                              stockEventList[2])
                                      ? const Center(child: Text(''))
                                      : const Text('')
                          : const Stack(),
                      const SizedBox(height: 20),
                      (productInventoryManagementDetailsSnapshot.data != null &&
                              productInventoryManagementDetailsSnapshot
                                      .data!.selectedRevisionNumber !=
                                  '')
                          ? Center(
                              child: SizedBox(
                                width: conWidth,
                                height: conHeight,
                                child: FilledButton(
                                    onPressed: () async {
                                      if (productInventoryManagementDetailsSnapshot
                                              .data!.stockEvent
                                              .toString() !=
                                          stockEventList[2]) {
                                        if (productInventoryManagementDetailsSnapshot
                                                .data!.quantity <=
                                            0) {
                                          QuickFixUi.errorMessage(
                                              'Please fill valid quantity.',
                                              context);
                                        } else if (productInventoryManagementDetailsSnapshot
                                                    .data!.stockEvent
                                                    .toString() ==
                                                stockEventList[1] &&
                                            productInventoryManagementDetailsSnapshot
                                                    .data!.quantity >
                                                state.currentStock) {
                                          QuickFixUi.errorMessage(
                                              '${productInventoryManagementDetailsSnapshot.data!.quantity} is greater than current stock.',
                                              context);
                                        } else if (productInventoryManagementDetailsSnapshot
                                                    .data!.stockEvent
                                                    .toString() ==
                                                stockEventList[1] &&
                                            productInventoryManagementDetailsSnapshot
                                                    .data!.parentProductId ==
                                                '') {
                                          QuickFixUi.errorMessage(
                                              'Please select parent product.',
                                              context);
                                        } else if (productInventoryManagementDetailsSnapshot
                                                    .data!.stockEvent
                                                    .toString() ==
                                                stockEventList[0] &&
                                            productInventoryManagementDetailsSnapshot
                                                    .data!.uomId ==
                                                '') {
                                          QuickFixUi.errorMessage(
                                              'Unit of measurement not found.',
                                              context);
                                        } else {
                                          String response =
                                              await PamRepository()
                                                  .productStockRegister(
                                                      token: state.token,
                                                      payload: {
                                                'product_id': state
                                                    .productsWithRevisionDataModel
                                                    .productId,
                                                'revision_number':
                                                    productInventoryManagementDetailsSnapshot
                                                        .data!
                                                        .selectedRevisionNumber,
                                                'createdby': state.userId,
                                                'new_quantity':
                                                    productInventoryManagementDetailsSnapshot
                                                        .data!.quantity,
                                                'preUOM': state
                                                    .productsWithRevisionDataModel
                                                    .uomId,
                                                'postUOM': productInventoryManagementDetailsSnapshot
                                                                .data!.uomId ==
                                                            '' ||
                                                        productInventoryManagementDetailsSnapshot
                                                                .data!.uomId ==
                                                            'null'
                                                    ? state
                                                        .productsWithRevisionDataModel
                                                        .uomId
                                                    : productInventoryManagementDetailsSnapshot
                                                        .data!.uomId,
                                                'drcr': productInventoryManagementDetailsSnapshot
                                                            .data!.stockEvent
                                                            .toString() ==
                                                        stockEventList[0]
                                                    ? 'D'
                                                    : productInventoryManagementDetailsSnapshot
                                                                .data!
                                                                .stockEvent
                                                                .toString() ==
                                                            stockEventList[1]
                                                        ? 'C'
                                                        : '',
                                                'parentproduct_id':
                                                    productInventoryManagementDetailsSnapshot
                                                        .data!.parentProductId,
                                                'sodetails_id':
                                                    productInventoryManagementDetailsSnapshot
                                                        .data!.soDetailsId
                                              });
                                          if (response == 'Success') {
                                            blocProvider.add(
                                                ProductInventoryManagementEvent(
                                                    productsWithRevisionDataModel:
                                                        state
                                                            .productsWithRevisionDataModel));
                                            productInventoryManagementDetails.add(
                                                ProductInventoryManagementDetailsModel(
                                                    selectedRevisionNumber:
                                                        productInventoryManagementDetailsSnapshot
                                                            .data!
                                                            .selectedRevisionNumber));
                                            if (productInventoryManagementDetailsSnapshot
                                                    .data!.stockEvent
                                                    .toString() ==
                                                stockEventList[0]) {
                                              QuickFixUi.successMessage(
                                                  'Stock inwarded successfully.',
                                                  context);
                                            } else if (productInventoryManagementDetailsSnapshot
                                                    .data!.stockEvent
                                                    .toString() ==
                                                stockEventList[1]) {
                                              QuickFixUi.successMessage(
                                                  'Stock issued successfully.',
                                                  context);
                                            } else {}
                                          } else {
                                            QuickFixUi.errorMessage(
                                                response, context);
                                          }
                                        }
                                      } else {
                                        QuickFixUi.errorMessage(
                                            'Scrap functionality is not added yet.',
                                            context);
                                      }
                                    },
                                    child: const Text('SUBMIT')),
                              ),
                            )
                          : const Text('')
                    ],
                  ),
                );
              });
        } else {
          return const Stack();
        }
      })),
    );
  }

  Row quantityWidget(
      {required double conHeight,
      required double paramWidth,
      required double conWidth,
      required AsyncSnapshot<ProductInventoryManagementDetailsModel>
          productInventoryManagementDetailsSnapshot}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        paramenterContainer(
            conHeight: conHeight, value: 'Quantity', paramWidth: paramWidth),
        Container(
            width: conWidth,
            height: conHeight,
            decoration: BoxDecoration(border: Border.all()),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (value) {
                if (value != 'null' && value != '') {
                  productInventoryManagementDetails
                      .add(ProductInventoryManagementDetailsModel(
                    selectedRevisionNumber:
                        productInventoryManagementDetailsSnapshot
                            .data!.selectedRevisionNumber
                            .toString()
                            .trim(),
                    stockEvent: productInventoryManagementDetailsSnapshot
                        .data!.stockEvent,
                    quantity: int.parse(value),
                  ));
                }
              },
            )),
      ],
    );
  }

  paramenterContainer(
      {required double conHeight,
      required String value,
      required double paramWidth}) {
    return SizedBox(
      width: paramWidth,
      height: conHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 20),
            child: Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
