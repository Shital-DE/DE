// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Instruments registration

// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
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
    return Scaffold(
      body: Row(
        children: [
          instrumentRegistrationForm(
              context: context, blocProvider: blocProvider),
          availableInstruments(context: context)
        ],
      ),
    );
  }

  availableInstruments({required BuildContext context}) {
    StreamController<List<AllInstrumentsData>> searchedProducts =
        StreamController<List<AllInstrumentsData>>.broadcast();
    return SizedBox(
      width: MediaQuery.of(context).size.width - 335,
      height:
          MediaQuery.of(context).size.height - (Platform.isAndroid ? 160 : 140),
      child: ListView(
        children: [
          QuickFixUi.verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<CalibrationBloc, CalibrationState>(
                  builder: (context, state) {
                if (state is InstrumentsRegistrationState) {
                  return Container(
                      width: 200,
                      height: 45,
                      decoration:
                          QuickFixUi().borderContainer(borderThickness: .5),
                      padding: const EdgeInsets.only(left: 20),
                      margin: const EdgeInsets.only(right: 20),
                      child: BlocBuilder<CalibrationBloc, CalibrationState>(
                          builder: (context, state) {
                        if (state is InstrumentsRegistrationState) {
                          return TextField(
                            decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: 'Search instrument',
                                hintStyle: hintTextStyle()),
                            onChanged: (value) {
                              List<AllInstrumentsData> searchedData =
                                  state.allInstrumentsList.where((item) {
                                String itemString = item.instrumentname
                                    .toString()
                                    .toLowerCase();
                                return itemString.contains(value.toLowerCase());
                              }).toList();
                              searchedProducts.add(searchedData);
                            },
                          );
                        } else {
                          return const Stack();
                        }
                      }));
                } else {
                  return const Stack();
                }
              })
            ],
          ),
          QuickFixUi.verticalSpace(height: 10),
          BlocBuilder<CalibrationBloc, CalibrationState>(
              builder: (context, state) {
            if (state is InstrumentsRegistrationState) {
              return StreamBuilder<List<AllInstrumentsData>>(
                  stream: searchedProducts.stream,
                  builder: (context, snapshot) {
                    double tableWidth = MediaQuery.of(context).size.width - 320,
                        rowHeight = Platform.isAndroid ? 50 : 40;
                    return instrumentsTable(
                        context: context,
                        searchedProducts: searchedProducts,
                        allInstrumentsList: snapshot.data != null
                            ? snapshot.data!
                            : state.allInstrumentsList.length > 100
                                ? state.allInstrumentsList.sublist(0, 100)
                                : state.allInstrumentsList,
                        tableWidth: tableWidth,
                        rowHeight: rowHeight,
                        tableheight: state.allInstrumentsList.isEmpty
                            ? 52
                            : state.allInstrumentsList.length > 20
                                ? MediaQuery.of(context).size.height - 220
                                : (state.allInstrumentsList.length + 1) *
                                    rowHeight);
                  });
            } else {
              return const Stack();
            }
          })
        ],
      ),
    );
  }

  TextStyle hintTextStyle() {
    return TextStyle(fontSize: Platform.isAndroid ? 15 : 14);
  }

  Container instrumentsTable(
      {required BuildContext context,
      required StreamController<List<AllInstrumentsData>> searchedProducts,
      required List<AllInstrumentsData> allInstrumentsList,
      required double tableWidth,
      required double tableheight,
      required double rowHeight}) {
    return Container(
        width: tableWidth,
        height: MediaQuery.of(context).size.height -
            (Platform.isAndroid ? 240 : 220),
        padding: const EdgeInsets.only(right: 10),
        child: CustomTable(
          tableheight: tableheight,
          tablewidth: tableWidth,
          rowHeight: rowHeight,
          showIndex: true,
          columnWidth: (MediaQuery.of(context).size.width - 400) / 4,
          tableOutsideBorder: true,
          enableRowBottomBorder: true,
          tableBorderColor: Theme.of(context).primaryColor,
          tableheaderColor: Theme.of(context).colorScheme.inversePrimary,
          headerStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: Platform.isAndroid ? 14 : 13),
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
      {required BuildContext context, required CalibrationBloc blocProvider}) {
    double tableheight = MediaQuery.of(context).size.height;
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
      width: 330,
      height:
          MediaQuery.of(context).size.height - (Platform.isAndroid ? 160 : 140),
      child: ListView(
        children: [
          Row(
            children: [
              SizedBox(
                width: 330,
                height: tableheight,
                child: Column(
                  children: [
                    QuickFixUi.verticalSpace(height: 10),
                    Center(
                      child: Text(
                        'Instrument Registration',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Platform.isAndroid ? 18 : 16,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    QuickFixUi.verticalSpace(height: 30),
                    Center(
                      child: StreamBuilder<bool>(
                          stream: productNotFound.stream,
                          builder: (context, snapshot) {
                            if (snapshot.data == null ||
                                snapshot.data == false) {
                              return BlocBuilder<CalibrationBloc,
                                  CalibrationState>(builder: (context, state) {
                                if (state is InstrumentsRegistrationState) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: Platform.isAndroid ? 300 : 250,
                                        height: Platform.isAndroid ? 45 : 38,
                                        decoration: QuickFixUi()
                                            .borderContainer(
                                                borderThickness: .5),
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            bottom: Platform.isAndroid ? 0 : 5),
                                        child: DropdownSearch<
                                            MeasuringInstruments>(
                                          items: state.measuringInstrumentsList,
                                          itemAsString: (item) =>
                                              item.description.toString(),
                                          popupProps: const PopupProps.menu(
                                              showSearchBox: true,
                                              searchFieldProps: TextFieldProps(
                                                style: TextStyle(fontSize: 18),
                                              )),
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Select product',
                                                          hintStyle:
                                                              hintTextStyle())),
                                          onChanged: (value) {
                                            productId.text =
                                                value!.id.toString();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                Platform.isAndroid ? 170 : 130),
                                        child: TextButton(
                                            onPressed: () {
                                              productNotFound.add(true);
                                            },
                                            child: Text('Product not found?',
                                                style: hintTextStyle())),
                                      )
                                    ],
                                  );
                                } else {
                                  return const Stack();
                                }
                              });
                            } else {
                              return const Stack();
                            }
                          }),
                    ),
                    Center(
                      child: BlocBuilder<CalibrationBloc, CalibrationState>(
                          builder: (context, state) {
                        if (state is InstrumentsRegistrationState) {
                          return Container(
                            width: Platform.isAndroid ? 300 : 250,
                            height: Platform.isAndroid ? 45 : 38,
                            decoration: QuickFixUi()
                                .borderContainer(borderThickness: .5),
                            padding: EdgeInsets.only(
                                left: 20, bottom: Platform.isAndroid ? 0 : 5),
                            child: DropdownSearch<InstrumentsTypeData>(
                              items: state.instrumentsTypeList,
                              itemAsString: (item) =>
                                  item.description.toString(),
                              popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      style: TextStyle(fontSize: 18))),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Select instrument type',
                                      hintStyle: hintTextStyle())),
                              onChanged: (value) {
                                instrumentTypeId.text = value!.id.toString();
                                instrumentTypeDescription.text =
                                    '${value.description} ';
                              },
                            ),
                          );
                        } else {
                          return const Stack();
                        }
                      }),
                    ),
                    QuickFixUi.verticalSpace(height: 10),
                    Center(
                      child: Container(
                        width: Platform.isAndroid ? 300 : 250,
                        height: Platform.isAndroid ? 45 : 38,
                        decoration:
                            QuickFixUi().borderContainer(borderThickness: .5),
                        padding: EdgeInsets.only(
                            left: 20, bottom: Platform.isAndroid ? 0 : 5),
                        child: TextField(
                          controller: instrumentName,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Drawing number',
                              hintStyle: hintTextStyle()),
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
                      child: Container(
                        width: Platform.isAndroid ? 300 : 250,
                        height: Platform.isAndroid ? 45 : 38,
                        decoration:
                            QuickFixUi().borderContainer(borderThickness: .5),
                        padding: EdgeInsets.only(
                            left: 20, bottom: Platform.isAndroid ? 0 : 5),
                        child: TextField(
                          controller: description,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
                              hintStyle: hintTextStyle()),
                          onChanged: (value) {
                            description.text = value.toString();
                          },
                        ),
                      ),
                    ),
                    QuickFixUi.verticalSpace(height: 10),
                    Center(
                      child: Container(
                        width: Platform.isAndroid ? 300 : 250,
                        height: Platform.isAndroid ? 45 : 38,
                        decoration:
                            QuickFixUi().borderContainer(borderThickness: .5),
                        padding: EdgeInsets.only(
                            left: 20, bottom: Platform.isAndroid ? 0 : 5),
                        child: TextField(
                          controller: subcategory,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Sub category',
                              hintStyle: hintTextStyle()),
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
                            if (snapshot.data != null &&
                                snapshot.data == true) {
                              return Column(
                                children: [
                                  QuickFixUi.verticalSpace(height: 10),
                                  Container(
                                    width: Platform.isAndroid ? 300 : 250,
                                    height: Platform.isAndroid ? 45 : 38,
                                    decoration: QuickFixUi()
                                        .borderContainer(borderThickness: .5),
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        bottom: Platform.isAndroid ? 0 : 5),
                                    child: TextField(
                                      controller: storageLocation,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Storage location'),
                                      onChanged: (value) {
                                        storageLocation.text = value.toString();
                                      },
                                    ),
                                  ),
                                  QuickFixUi.verticalSpace(height: 10),
                                  Container(
                                    width: Platform.isAndroid ? 300 : 250,
                                    height: Platform.isAndroid ? 45 : 38,
                                    decoration: QuickFixUi()
                                        .borderContainer(borderThickness: .5),
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        bottom: Platform.isAndroid ? 0 : 5),
                                    child: TextField(
                                      controller: rackNumber,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Rack Number'),
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
                            return BlocBuilder<CalibrationBloc,
                                CalibrationState>(builder: (context, state) {
                              if (state is InstrumentsRegistrationState) {
                                return FilledButton(
                                    onPressed: () async {
                                      String resultedinstrumentName =
                                          capitalizeFirstPart(
                                              instrumentName.text.toString());

                                      String productid = '';
                                      if (snapshot.data == null &&
                                          productId.text == '') {
                                        QuickFixUi.errorMessage(
                                            'Please select product.', context);
                                      } else if (instrumentTypeId.text == '') {
                                        QuickFixUi.errorMessage(
                                            'Please select instrument type.',
                                            context);
                                      } else if (instrumentName.text == '') {
                                        QuickFixUi.errorMessage(
                                            'Instrument name not found.',
                                            context);
                                      } else if (description.text == '') {
                                        QuickFixUi.errorMessage(
                                            'Description not found.', context);
                                      } else if ((snapshot.data != null &&
                                              snapshot.data == true) &&
                                          storageLocation.text == '') {
                                        QuickFixUi.errorMessage(
                                            'Storage location not found.',
                                            context);
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
                                            instrumentName:
                                                resultedinstrumentName,
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
                                    child: const Text('SUBMIT'));
                              } else {
                                return const Stack();
                              }
                            });
                          }),
                    )
                  ],
                ),
              ),
              QuickFixUi.verticalSpace(height: 10)
            ],
          ),
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
                        // 'manufacturer': manufacturer.text.toUpperCase(),
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
                          // manufacturer.text = '';
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
