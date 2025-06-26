// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Instruments registration
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:de/utils/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../services/model/quality/calibration_model.dart';
import '../../../../services/repository/quality/calibration_repository.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/table/custom_table.dart';

class InstrumentsRegistration extends StatelessWidget {
  const InstrumentsRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(InstrumentsRegistrationEvent());
    return MakeMeResponsiveScreen(
      horixontaltab: screenBody(context, blocProvider),
      windows: screenBody(context, blocProvider),
      linux: screenBody(context, blocProvider),
    );
  }

  Scaffold screenBody(BuildContext context, CalibrationBloc blocProvider) {
    Size size = MediaQuery.of(context).size;
    double conWidth = Platform.isAndroid ? 300 : 250;
    return Scaffold(
      body: BlocBuilder<CalibrationBloc, CalibrationState>(
          builder: (context, state) {
        if (state is InstrumentsRegistrationState) {
          return Row(
            children: [
              instrumentRegistrationForm(
                  context: context,
                  blocProvider: blocProvider,
                  state: state,
                  size: size,
                  conWidth: conWidth),
              const SizedBox(width: 5),
              availableInstruments(
                  context: context,
                  state: state,
                  size: size,
                  conWidth: conWidth)
            ],
          );
        } else {
          return const Stack();
        }
      }),
    );
  }

  availableInstruments(
      {required BuildContext context,
      required InstrumentsRegistrationState state,
      required Size size,
      required double conWidth}) {
    StreamController<List<AllInstrumentsData>> searchedProducts =
        StreamController<List<AllInstrumentsData>>.broadcast();
    return Container(
      width: size.width - (conWidth + 15),
      height: size.height - (Platform.isAndroid ? 160 : 140),
      padding: const EdgeInsets.only(right: 5),
      child: ListView(
        children: [
          QuickFixUi.verticalSpace(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 200,
                  height: 45,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2)),
                        suffixIcon: const Icon(Icons.search),
                        hintText: 'Search instrument',
                        hintStyle: hintTextStyle()),
                    onChanged: (value) {
                      List<AllInstrumentsData> searchedData =
                          state.allInstrumentsList.where((item) {
                        String itemString =
                            item.instrumentname.toString().toLowerCase();
                        return itemString.contains(value.toLowerCase());
                      }).toList();
                      searchedProducts.add(searchedData);
                    },
                  )),
            ],
          ),
          QuickFixUi.verticalSpace(height: 5),
          StreamBuilder<List<AllInstrumentsData>>(
              stream: searchedProducts.stream,
              builder: (context, snapshot) {
                double tableWidth = size.width - (conWidth + 15),
                    rowHeight = Platform.isAndroid ? 45 : 35;
                return instrumentsTable(
                    context: context,
                    allInstrumentsList: snapshot.data != null
                        ? snapshot.data!
                        : state.allInstrumentsList.length > 100
                            ? state.allInstrumentsList.sublist(0, 100)
                            : state.allInstrumentsList,
                    tableWidth: tableWidth,
                    rowHeight: rowHeight,
                    tableheight: snapshot.data != null
                        ? snapshot.data!.isEmpty
                            ? rowHeight + 2.5
                            : (snapshot.data!.length * rowHeight) + rowHeight
                        : state.allInstrumentsList.isEmpty
                            ? rowHeight
                            : state.allInstrumentsList.length > 20
                                ? size.height - 197
                                : ((state.allInstrumentsList.length) *
                                        rowHeight) +
                                    rowHeight);
              })
        ],
      ),
    );
  }

  TextStyle hintTextStyle() {
    return TextStyle(fontSize: Platform.isAndroid ? 15 : 13);
  }

  SizedBox instrumentsTable(
      {required BuildContext context,
      required List<AllInstrumentsData> allInstrumentsList,
      required double tableWidth,
      required double tableheight,
      required double rowHeight}) {
    return SizedBox(
        width: tableWidth,
        height: tableheight,
        child: CustomTable(
          tableheight: tableheight,
          tablewidth: tableWidth,
          rowHeight: rowHeight,
          headerHeight: rowHeight,
          columnWidth: ((tableWidth - 10) - (rowHeight * 2)) / 4,
          headerBorderThickness: .5,
          headerStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: Platform.isAndroid ? 15 : 13),
          tableheaderColor: AppColors.whiteTheme,
          headerBorderColor: AppColors.blackColor,
          showIndex: true,
          tableOutsideBorder: true,
          enableRowBottomBorder: true,
          enableHeaderBottomBorder: true,
          column: [
            ColumnData(label: 'Instrument name'),
            ColumnData(label: 'Instrument type'),
            ColumnData(label: 'Description'),
            ColumnData(label: 'Subcategory'),
          ],
          rows: allInstrumentsList
              .map((e) => RowData(cell: [
                    TableDataCell(
                        label: Text(
                      e.instrumentname.toString(),
                      textAlign: TextAlign.center,
                      style: getTableBodyFontStyle(),
                    )),
                    TableDataCell(
                        label: Text(
                      e.instrumenttype.toString(),
                      textAlign: TextAlign.center,
                      style: getTableBodyFontStyle(),
                    )),
                    TableDataCell(
                        label: Padding(
                      padding: Platform.isAndroid
                          ? const EdgeInsets.only(top: 7, bottom: 7)
                          : const EdgeInsets.only(top: 9, bottom: 9),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          e.description.toString(),
                          textAlign: TextAlign.center,
                          style: getTableBodyFontStyle(),
                        ),
                      ),
                    )),
                    TableDataCell(
                        label: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          e.subcategory.toString(),
                          textAlign: TextAlign.center,
                          style: getTableBodyFontStyle(),
                        ),
                      ),
                    )),
                  ]))
              .toList(),
        ));
  }

  TextStyle getTableBodyFontStyle() =>
      TextStyle(fontSize: Platform.isAndroid ? 14 : 12, color: Colors.black);

  instrumentRegistrationForm(
      {required BuildContext context,
      required CalibrationBloc blocProvider,
      required InstrumentsRegistrationState state,
      required Size size,
      required double conWidth}) {
    TextEditingController instrumentTypeId = TextEditingController();
    TextEditingController productId = TextEditingController();
    TextEditingController instrumentName = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController subcategory = TextEditingController();
    StreamController<bool> productNotFound = StreamController<bool>.broadcast();
    TextEditingController storageLocation = TextEditingController();
    TextEditingController rackNumber = TextEditingController();
    TextEditingController instrumentTypeDescription = TextEditingController();
    return SizedBox(
      width: conWidth + 10,
      height: size.height - (Platform.isAndroid ? 160 : 140),
      child: ListView(
        children: [
          QuickFixUi.verticalSpace(height: 20),
          Center(
            child: Text(
              'Instrument Registration',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Platform.isAndroid ? 18 : 16,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          QuickFixUi.verticalSpace(height: 20),
          Center(
            child: StreamBuilder<bool>(
                stream: productNotFound.stream,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      SizedBox(
                        width: conWidth,
                        height: Platform.isAndroid ? 45 : 38,
                        child: DropdownSearch<MeasuringInstruments>(
                          items: state.measuringInstrumentsList,
                          itemAsString: (item) => item.description.toString(),
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(
                                  item.description.toString(),
                                  style: AppTheme.labelTextStyle(),
                                ),
                              );
                            },
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                              textAlign: TextAlign.center,
                              dropdownSearchDecoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 11, top: 11, left: 2),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  hintText: 'Select product',
                                  hintStyle: hintTextStyle())),
                          onChanged: (value) {
                            productId.text = value!.id.toString();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                if (snapshot.data != null &&
                                    snapshot.data == true) {
                                  productNotFound.add(false);
                                } else {
                                  productNotFound.add(true);
                                }
                              },
                              child: Text(
                                  snapshot.data != null && snapshot.data == true
                                      ? 'Product is available.'
                                      : 'Product not found?',
                                  style: hintTextStyle()))
                        ],
                      ),
                    ],
                  );
                }),
          ),
          Center(
            child: SizedBox(
              width: conWidth,
              height: Platform.isAndroid ? 45 : 38,
              child: DropdownSearch<InstrumentsTypeData>(
                items: state.instrumentsTypeList,
                itemAsString: (item) => item.description.toString(),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(
                        item.description.toString(),
                        style: AppTheme.labelTextStyle(),
                      ),
                    );
                  },
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                    textAlign: TextAlign.center,
                    dropdownSearchDecoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2)),
                        hintText: 'Select instrument type',
                        hintStyle: hintTextStyle())),
                onChanged: (value) {
                  instrumentTypeId.text = value!.id.toString();
                  instrumentTypeDescription.text = '${value.description} ';
                },
              ),
            ),
          ),
          QuickFixUi.verticalSpace(height: 10),
          Center(
            child: SizedBox(
              width: conWidth,
              height: Platform.isAndroid ? 45 : 38,
              child: TextField(
                controller: instrumentName,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2)),
                  hintText: 'Drawing number',
                  hintStyle: hintTextStyle(),
                  contentPadding: const EdgeInsets.only(
                    bottom: 5,
                  ),
                ),
                onChanged: (value) {
                  instrumentName.text = value.toString();
                  description.text = instrumentTypeDescription.text +
                      instrumentName.text.toString();
                },
              ),
            ),
          ),
          QuickFixUi.verticalSpace(height: 10),
          Center(
            child: SizedBox(
              width: conWidth,
              height: Platform.isAndroid ? 45 : 38,
              child: TextField(
                controller: description,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2)),
                  hintText: 'Description',
                  hintStyle: hintTextStyle(),
                  contentPadding: const EdgeInsets.only(
                    bottom: 5,
                  ),
                ),
                onChanged: (value) {
                  description.text = value.toString();
                },
              ),
            ),
          ),
          QuickFixUi.verticalSpace(height: 10),
          Center(
            child: SizedBox(
              width: conWidth,
              height: Platform.isAndroid ? 45 : 38,
              child: TextField(
                controller: subcategory,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2)),
                  hintText: 'Sub category',
                  hintStyle: hintTextStyle(),
                  contentPadding: const EdgeInsets.only(
                    bottom: 5,
                  ),
                ),
                onChanged: (value) {
                  subcategory.text = value.toString();
                },
              ),
            ),
          ),
          Center(
            child: StreamBuilder<bool>(
                stream: productNotFound.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data == true) {
                    return Column(
                      children: [
                        QuickFixUi.verticalSpace(height: 10),
                        SizedBox(
                          width: conWidth,
                          height: Platform.isAndroid ? 45 : 38,
                          child: TextField(
                            controller: storageLocation,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              hintText: 'Storage location',
                              hintStyle: hintTextStyle(),
                              contentPadding: const EdgeInsets.only(
                                bottom: 5,
                              ),
                            ),
                            onChanged: (value) {
                              storageLocation.text = value.toString();
                            },
                          ),
                        ),
                        QuickFixUi.verticalSpace(height: 10),
                        SizedBox(
                          width: conWidth,
                          height: Platform.isAndroid ? 45 : 38,
                          child: TextField(
                            controller: rackNumber,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              hintText: 'Rack Number',
                              hintStyle: hintTextStyle(),
                              contentPadding: const EdgeInsets.only(
                                bottom: 5,
                              ),
                            ),
                            onChanged: (value) {
                              rackNumber.text = value.toString();
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Stack();
                  }
                }),
          ),
          QuickFixUi.verticalSpace(height: 10),
          Center(
            child: StreamBuilder<bool>(
                stream: productNotFound.stream,
                builder: (context, snapshot) {
                  return FilledButton(
                      onPressed: () async {
                        String resultedinstrumentName =
                            capitalizeFirstPart(instrumentName.text.toString());
                        String productid = '';
                        if (snapshot.data == null && productId.text == '') {
                          QuickFixUi.errorMessage(
                              'Please select product.', context);
                        } else if (instrumentTypeId.text == '') {
                          QuickFixUi.errorMessage(
                              'Please select instrument type.', context);
                        } else if (instrumentName.text == '') {
                          QuickFixUi.errorMessage(
                              'Instrument name not found.', context);
                        } else if (description.text == '') {
                          QuickFixUi.errorMessage(
                              'Description not found.', context);
                        } else if ((snapshot.data != null &&
                                snapshot.data == true) &&
                            storageLocation.text == '') {
                          QuickFixUi.errorMessage(
                              'Storage location not found.', context);
                        } else if ((snapshot.data != null &&
                                snapshot.data == true) &&
                            rackNumber.text == '') {
                          QuickFixUi.errorMessage(
                              'Rack number not found.', context);
                        } else {
                          instrumentName.text = '';
                          confirmationDialog(
                              context: context,
                              snapshot: snapshot,
                              productid: productid,
                              state: state,
                              instrumentName: resultedinstrumentName,
                              storageLocation: storageLocation,
                              rackNumber: rackNumber,
                              description: description,
                              instrumentTypeId: instrumentTypeId,
                              productId: productId,
                              subcategory: subcategory,
                              blocProvider: blocProvider,
                              productNotFound: productNotFound);
                        }
                      },
                      child: Text('SUBMIT',
                          style: TextStyle(
                              color: AppColors.whiteTheme,
                              fontWeight: FontWeight.bold,
                              fontSize: Platform.isAndroid ? 15 : 12)));
                }),
          )
        ],
      ),
    );
  }

  String capitalizeFirstPart(String input) {
    List<String> parts = input.split('.');

    if (parts.isNotEmpty) {
      String firstPart = parts.first.toUpperCase();
      parts[0] = firstPart;
    }

    return parts.join('.');
  }

  Future<dynamic> confirmationDialog(
      {required BuildContext context,
      required AsyncSnapshot<bool> snapshot,
      required String productid,
      required InstrumentsRegistrationState state,
      required String instrumentName,
      required TextEditingController storageLocation,
      required TextEditingController rackNumber,
      required TextEditingController description,
      required TextEditingController instrumentTypeId,
      required TextEditingController productId,
      required TextEditingController subcategory,
      required CalibrationBloc blocProvider,
      required StreamController<bool> productNotFound}) {
    final navigator = Navigator.of(context);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              content: const SizedBox(
                  height: 25,
                  child: Text(
                    'Are you sure?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  )),
              actions: [
                FilledButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      if (snapshot.data != null && snapshot.data != false) {
                        productid = await CalibrationRepository()
                            .registerProduct(token: state.token, payload: {
                          'createdby': state.userId,
                          'code': instrumentName.trim(),
                          'storagelocation':
                              storageLocation.text.trim().toUpperCase(),
                          'racknumber': rackNumber.text.trim().toUpperCase(),
                          'description': description.text.trim().toUpperCase()
                        });
                      }
                      String response = await CalibrationRepository()
                          .registerInstument(token: state.token, payload: {
                        'createdby': state.userId,
                        'instrumenttype_id': instrumentTypeId.text.trim(),
                        'product_id':
                            snapshot.data != null && snapshot.data != false
                                ? productid
                                : productId.text.trim(),
                        'instrumentname': instrumentName.trim(),
                        'description': description.text.toUpperCase(),
                        'subcategory': subcategory.text.toUpperCase()
                      });
                      if (response == 'Inserted successfully') {
                        productNotFound.add(false);
                        QuickFixUi.successMessage(response, context);
                        blocProvider.add(CalibrationInitialEvent());
                        Future.delayed(const Duration(seconds: 1), () {
                          blocProvider.add(InstrumentsRegistrationEvent());
                          instrumentTypeId.text = '';
                          productId.text = '';
                          description.text = '';
                          subcategory.text = '';
                          storageLocation.text = '';
                          rackNumber.text = '';
                          navigator.pop();
                        });
                      }
                    },
                    child: const Text('Yes')),
                FilledButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'))
              ]);
        });
  }
}
