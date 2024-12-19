// Author : Shital Gayakwad
// Created Date : 5 Dec 2023
// Description : Calibration screen

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
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/table/custom_table.dart';

class OrderInstrument extends StatelessWidget {
  const OrderInstrument({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(OrderInstrumentEvent());
    Size size = MediaQuery.of(context).size;
    return MakeMeResponsiveScreen(
      horixontaltab: orderInstrumentUI(
          size: size, context: context, blocProvider: blocProvider),
      windows: orderInstrumentUI(
          size: size, context: context, blocProvider: blocProvider),
      linux: orderInstrumentUI(
          size: size, context: context, blocProvider: blocProvider),
    );
  }

  SizedBox orderInstrumentUI(
      {required Size size,
      required BuildContext context,
      required CalibrationBloc blocProvider}) {
    TextEditingController from = TextEditingController();
    TextEditingController subject =
        TextEditingController(text: 'Request for Instrument Order');
    TextEditingController quantity = TextEditingController(text: '1');
    TextEditingController range = TextEditingController();
    StreamController<String> isNew = StreamController<String>.broadcast();
    StreamController<List<InstrumentMeasuringRanges>> measuringrangeList =
        StreamController<List<InstrumentMeasuringRanges>>.broadcast();
    StreamController<Map<String, dynamic>> selectedInstrument =
        StreamController<Map<String, dynamic>>.broadcast();
    StreamController<List<MailContentElements>> mailContentListData =
        StreamController<List<MailContentElements>>.broadcast();
    double conWidth = 350, conHeight = Platform.isAndroid ? 40 : 35;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Row(
        children: [
          Container(
            width: conWidth,
            height: size.height,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5.0,
                  ),
                ]),
            child: ListView(
              children: [
                QuickFixUi.verticalSpace(height: 10),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Recipients : ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Platform.isAndroid ? 16 : 13),
                  ),
                ),
                fromWidget(conWidth, conHeight, from),
                toWidget(conWidth, conHeight),
                QuickFixUi.verticalSpace(height: 20),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Select instruments : ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Platform.isAndroid ? 16 : 13),
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          isNew.add('true');
                        },
                        icon: const Icon(Icons.add_circle),
                        label: Text(
                          'New',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Platform.isAndroid ? 15 : 12),
                        )),
                    TextButton.icon(
                        onPressed: () {
                          isNew.add('false');
                        },
                        icon: const Icon(Icons.exit_to_app_sharp),
                        label: Text(
                          'Against rejection',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Platform.isAndroid ? 15 : 12),
                        )),
                  ],
                ),
                StreamBuilder<String>(
                    stream: isNew.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data == 'true') {
                        return instrumentWidget(
                            conWidth: conWidth,
                            conHeight: conHeight,
                            measuringrangeList: measuringrangeList,
                            selectedInstrument: selectedInstrument);
                      } else {
                        return const Stack();
                      }
                    }),
                StreamBuilder<String>(
                    stream: isNew.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data == 'true') {
                        return rangeWidget(
                            measuringrangeList: measuringrangeList,
                            conWidth: conWidth,
                            conHeight: conHeight,
                            range: range);
                      } else {
                        return const Stack();
                      }
                    }),
                StreamBuilder<String>(
                    stream: isNew.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data == 'false') {
                        return rejectedinstrumentWidget(
                            conWidth: conWidth,
                            conHeight: conHeight,
                            selectedInstrument: selectedInstrument,
                            range: range);
                      } else {
                        return const Stack();
                      }
                    }),
                StreamBuilder<String>(
                    stream: isNew.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data != '') {
                        return quantityWidget(conWidth, conHeight, quantity);
                      } else {
                        return const Stack();
                      }
                    }),
                addInstrumentButton(
                    selectedInstrument: selectedInstrument,
                    measuringrangeList: measuringrangeList,
                    range: range,
                    quantity: quantity,
                    mailContentListData: mailContentListData,
                    from: from,
                    isNew: isNew)
              ],
            ),
          ),
          Container(
            width: size.width - (conWidth + 30),
            height: size.height,
            margin: const EdgeInsets.only(left: 15, right: 10),
            child: ListView(
              children: [
                QuickFixUi.verticalSpace(height: 10),
                SizedBox(
                    height: conHeight,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width - (conWidth + 140),
                          child: TextField(
                            controller: subject,
                            textAlign: TextAlign.start,
                            style: AppTheme.labelTextStyle(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              contentPadding:
                                  const EdgeInsets.only(bottom: 5, left: 20),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                        QuickFixUi.horizontalSpace(width: 10),
                        BlocBuilder<CalibrationBloc, CalibrationState>(
                            builder: (context, state) {
                          if (state is OrderInstrumentState) {
                            return StreamBuilder<List<MailContentElements>>(
                                stream: mailContentListData.stream,
                                builder: (context, snapshot) {
                                  return InkWell(
                                    onTap: () async {
                                      QuickFixUi()
                                          .showProcessing(context: context);
                                      if (snapshot.data == null &&
                                          snapshot.data!.isNotEmpty) {
                                        QuickFixUi.errorMessage(
                                            'Mail content not found.', context);
                                      } else {
                                        List<Map<String, dynamic>> mailcontent =
                                            snapshot.data!
                                                .map((element) =>
                                                    element.toJson())
                                                .toList();

                                        String response =
                                            await CalibrationRepository()
                                                .sendInstrumentOrder(
                                                    token: state.token,
                                                    payload: {
                                              'userId': state.userId,
                                              'from': from.text,
                                              'to':
                                                  state.toList[0].emailaddress,
                                              'subject': subject.text,
                                              'content': mailcontent
                                            });
                                        if (response == 'Success') {
                                          Navigator.of(context).pop();
                                          mailContentListData.add([]);
                                          QuickFixUi.successMessage(
                                              'Your order has been successfully placed.',
                                              context);
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 100,
                                      height: conHeight,
                                      color: Theme.of(context).primaryColor,
                                      child: Center(
                                        child: Text(
                                          'Send',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize:
                                                  Platform.isAndroid ? 15 : 13),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return const Stack();
                          }
                        })
                      ],
                    )),
                QuickFixUi.verticalSpace(height: 10),
                mailContentWidget(
                    size: size,
                    mailContentListData: mailContentListData,
                    from: from)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container mailContentWidget(
      {required Size size,
      required StreamController<List<MailContentElements>> mailContentListData,
      required TextEditingController from}) {
    return Container(
      width: size.width - 100,
      height: size.height - 240,
      decoration: QuickFixUi().borderContainer(borderThickness: .5),
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<List<MailContentElements>>(
          stream: mailContentListData.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return BlocBuilder<CalibrationBloc, CalibrationState>(
                  builder: (context, state) {
                if (state is OrderInstrumentState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mailBeggining(state: state),
                        style: AppTheme.labelTextStyle(),
                      ),
                      Container(
                        width: size.width - 100,
                        height: snapshot.data!.isEmpty
                            ? 47
                            : (snapshot.data!.length * 45) + 45 >
                                    (size.height - 405)
                                ? size.height - 405
                                : (snapshot.data!.length * 45) + 45,
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: CustomTable(
                            tablewidth: size.width - 100,
                            tableheight: size.height - 405,
                            columnWidth: (size.width) / 8,
                            rowHeight: 45,
                            tableheaderColor:
                                Theme.of(context).colorScheme.surface,
                            tablebodyColor:
                                Theme.of(context).colorScheme.surface,
                            headerStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: Platform.isAndroid ? 15 : 13),
                            tableOutsideBorder: true,
                            enableHeaderBottomBorder: true,
                            enableRowBottomBorder: true,
                            headerBorderColor: Colors.black,
                            headerBorderThickness: .5,
                            borderThickness: .5,
                            column: InstrumentOrdersCommon().ordersTableColumns,
                            rows: snapshot.data!
                                .map((e) => RowData(cell: [
                                      TableDataCell(
                                          width: 60,
                                          label: IconButton(
                                            onPressed: () {
                                              List<MailContentElements>
                                                  datalist = snapshot.data!;
                                              datalist.removeWhere((element) =>
                                                  element.drawingNumber ==
                                                      e.drawingNumber &&
                                                  element.measuringRange ==
                                                      e.measuringRange);
                                              mailContentListData.add(datalist);
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          )),
                                      TableDataCell(
                                          label: Text(
                                        e.drawingNumber.toString().trim(),
                                        textAlign: TextAlign.center,
                                        style: AppTheme.labelTextStyle(),
                                      )),
                                      TableDataCell(
                                          label: Text(
                                        e.instrumentDescription
                                            .toString()
                                            .trim(),
                                        textAlign: TextAlign.center,
                                        style: AppTheme.labelTextStyle(),
                                      )),
                                      TableDataCell(
                                          label: Text(
                                        e.product.toString().trim(),
                                        textAlign: TextAlign.center,
                                        style: AppTheme.labelTextStyle(),
                                      )),
                                      TableDataCell(
                                          label: Text(
                                        e.productDescription.toString().trim(),
                                        textAlign: TextAlign.center,
                                        style: AppTheme.labelTextStyle(),
                                      )),
                                      TableDataCell(
                                          label: Text(
                                        e.measuringRange.toString().trim(),
                                        textAlign: TextAlign.center,
                                        style: AppTheme.labelTextStyle(),
                                      )),
                                      TableDataCell(
                                          label: Text(
                                        e.quantity.toString().trim(),
                                        textAlign: TextAlign.center,
                                        style: AppTheme.labelTextStyle(),
                                      )),
                                      TableDataCell(
                                          label: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          e.rejectedInstrument == null ||
                                                  e.rejectedInstrument
                                                          .toString() ==
                                                      "null"
                                              ? ''
                                              : e.rejectedInstrument
                                                  .toString()
                                                  .trim(),
                                          textAlign: TextAlign.center,
                                          style: AppTheme.labelTextStyle(),
                                        ),
                                      )),
                                    ]))
                                .toList()),
                      ),
                      Text(
                        mailBottom(from: from.text),
                        style: AppTheme.labelTextStyle(),
                      )
                    ],
                  );
                } else {
                  return const Stack();
                }
              });
            } else {
              return Center(
                  child: Text(
                'Mail content!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: Platform.isAndroid ? 15 : 13),
              ));
            }
          }),
    );
  }

  String mailBottom({required String from}) =>
      """Best regards, \n${firstnameGenerator(name: from)} ${lastnameGenerator(lastname: from)}.""";

  String mailBeggining({required OrderInstrumentState state}) =>
      """Dear ${firstnameGenerator(name: state.toList[0].emailaddress.toString())},\n\nWe kindly request immediate processing of our instrument order for\nProduct details :""";

  String firstnameGenerator({required String name}) {
    try {
      String firstname = name.toString().split('.').first;
      firstname =
          firstname.substring(0, 1).toUpperCase() + firstname.substring(1);
      return firstname;
    } catch (e) {
      return '';
    }
  }

  String lastnameGenerator({required String lastname}) {
    try {
      String name = '';
      List<String> parts = lastname.toString().split('@');
      if (parts.length == 2) {
        String localPart = parts[0];
        List<String> localParts = localPart.split('.');
        if (localParts.length >= 2) {
          String lastName = localParts[1];
          name = lastName.substring(0, 1).toUpperCase() + lastName.substring(1);
        }
      }
      return name;
    } catch (e) {
      return '';
    }
  }

  addInstrumentButton(
      {required StreamController<Map<String, dynamic>> selectedInstrument,
      required StreamController<List<InstrumentMeasuringRanges>>
          measuringrangeList,
      required TextEditingController range,
      required TextEditingController quantity,
      required StreamController<List<MailContentElements>> mailContentListData,
      required TextEditingController from,
      required StreamController<String> isNew}) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: selectedInstrument.stream,
        builder: (context, snapshot) {
          return StreamBuilder<List<MailContentElements>>(
              stream: mailContentListData.stream,
              builder: (context, newSnap) {
                return StreamBuilder<String>(
                    stream: isNew.stream,
                    builder: (context, buttonSnap) {
                      if (buttonSnap.data != null && buttonSnap.data != '') {
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 120, right: 120),
                          child: FilledButton(
                              onPressed: () {
                                try {
                                  if (snapshot.data != null &&
                                      snapshot.data.toString() != '') {
                                    List<MailContentElements> datalist = [];
                                    if (from.text == '') {
                                      QuickFixUi.errorMessage(
                                          'From recepient not found.', context);
                                    } else if (snapshot.data == null ||
                                        snapshot.data!.isEmpty) {
                                      QuickFixUi.errorMessage(
                                          'Please select instrument.', context);
                                    } else if (range.text == '') {
                                      QuickFixUi.errorMessage(
                                          'Please select range', context);
                                    } else {
                                      if (newSnap.data != null &&
                                          newSnap.data!.isNotEmpty) {
                                        datalist = newSnap.data!;
                                      }
                                      if (datalist.isNotEmpty) {
                                        List<MailContentElements>
                                            existingElement = datalist
                                                .where(
                                                  (element) =>
                                                      element.drawingNumber
                                                              .toString()
                                                              .trim() ==
                                                          snapshot.data![
                                                                  'instrument']
                                                              .toString()
                                                              .trim() &&
                                                      element.measuringRange
                                                              .toString()
                                                              .trim() ==
                                                          range.text
                                                              .toString()
                                                              .trim(),
                                                )
                                                .toList();
                                        if (existingElement.isNotEmpty) {
                                          for (var data in existingElement) {
                                            incrementQuantityInDatalist(
                                                data, quantity, datalist);
                                          }
                                        } else {
                                          addNewToDatalist(datalist, snapshot,
                                              range, quantity);
                                        }
                                      } else {
                                        addNewToDatalist(datalist, snapshot,
                                            range, quantity);
                                      }

                                      mailContentListData.add(datalist);
                                      if (datalist.isNotEmpty) {
                                        selectedInstrument.add({});
                                        measuringrangeList.add([]);
                                        range.text = '';
                                        quantity.text = '1';
                                        isNew.add('');
                                      }
                                    }
                                  }
                                } catch (e) {
                                  e;
                                }
                              },
                              child: Text('Add',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteTheme,
                                    fontSize: Platform.isAndroid ? 15 : 13,
                                  ))),
                        );
                      } else {
                        return const Stack();
                      }
                    });
              });
        });
  }

  void incrementQuantityInDatalist(MailContentElements existingElement,
      TextEditingController quantity, List<MailContentElements> datalist) {
    int oldqty = int.parse(existingElement.quantity.toString());
    int newQty = int.parse(quantity.text);
    datalist.removeWhere((element) =>
        element.drawingNumber == existingElement.drawingNumber &&
        element.measuringRange == existingElement.measuringRange);
    datalist.add(MailContentElements(
        product: existingElement.product.toString().trim(),
        productDescription:
            existingElement.productDescription.toString().trim(),
        drawingNumber: existingElement.drawingNumber.toString().trim(),
        instrumentDescription:
            existingElement.instrumentDescription.toString().trim(),
        measuringRange: existingElement.measuringRange.toString().trim(),
        quantity: (oldqty + newQty).toString().trim(),
        rejectedInstrument:
            existingElement.rejectedInstrument.toString().trim(),
        rejectedInstrumentId:
            existingElement.rejectedInstrumentId.toString().trim(),
        instrumentId: existingElement.instrumentId));
  }

  void addNewToDatalist(
      List<MailContentElements> datalist,
      AsyncSnapshot<Map<String, dynamic>> snapshot,
      TextEditingController range,
      TextEditingController quantity) {
    datalist.add(MailContentElements(
        product: snapshot.data!['product'].toString().trim(),
        productDescription:
            snapshot.data!['product_description'].toString().trim(),
        drawingNumber: snapshot.data!['instrument'].toString().trim(),
        instrumentDescription:
            snapshot.data!['instrument_description'].toString().trim(),
        measuringRange: range.text.trim(),
        quantity: quantity.text.trim(),
        rejectedInstrument:
            snapshot.data!['rejected_instrument'].toString().trim(),
        rejectedInstrumentId:
            snapshot.data!['rejected_instrument_id'].toString().trim(),
        instrumentId: snapshot.data!['instrumentId'].toString().trim()));
  }

  Container instrumentWidget(
      {required double conWidth,
      required double conHeight,
      required StreamController<List<InstrumentMeasuringRanges>>
          measuringrangeList,
      required StreamController<Map<String, dynamic>> selectedInstrument}) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              'Instrument : ',
              style: AppTheme.labelTextStyle(isFontBold: true),
            ),
          ),
          BlocBuilder<CalibrationBloc, CalibrationState>(
              builder: (context, state) {
            if (state is OrderInstrumentState) {
              return SizedBox(
                width: conWidth - 140,
                height: conHeight,
                child: DropdownSearch<AllInstrumentsData>(
                  items: state.allInstrumentsList,
                  itemAsString: (item) => item.instrumentname.toString(),
                  popupProps: PopupProps.menu(
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(
                          item.instrumentname.toString(),
                          style: AppTheme.labelTextStyle(),
                        ),
                      );
                    },
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      textAlign: TextAlign.center,
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Drawing number',
                        hintStyle: AppTheme.labelTextStyle(),
                        contentPadding:
                            const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2)),
                      )),
                  onChanged: (value) async {
                    List<InstrumentMeasuringRanges> response =
                        await CalibrationRepository().measuringrangeList(
                            token: state.token,
                            payload: {'id': value!.id.toString()});
                    List<OneProduct> oneProductList =
                        await CalibrationRepository().oneproductData(
                            token: state.token,
                            payload: {'id': value.productId.toString()});
                    selectedInstrument.add({
                      'instrument': value.instrumentname.toString(),
                      'instrument_description': value.description.toString(),
                      'product': oneProductList[0].code.toString(),
                      'product_description':
                          oneProductList[0].description.toString(),
                      'instrumentId': value.id
                    });
                    measuringrangeList.add(response);
                  },
                ),
              );
            } else {
              return const Stack();
            }
          }),
        ],
      ),
    );
  }

  Container rejectedinstrumentWidget({
    required double conWidth,
    required double conHeight,
    required StreamController<Map<String, dynamic>> selectedInstrument,
    required TextEditingController range,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              'Instrument : ',
              style: AppTheme.labelTextStyle(isFontBold: true),
            ),
          ),
          BlocBuilder<CalibrationBloc, CalibrationState>(
              builder: (context, state) {
            if (state is OrderInstrumentState) {
              return SizedBox(
                width: conWidth - 140,
                height: conHeight,
                child: DropdownSearch<RejectedInstrumentsNewOrderDataModel>(
                  items: state.rejectedInstrumentsDataList,
                  itemAsString: (item) =>
                      '${item.instrumentname}       ${item.cardnumber}',
                  popupProps: PopupProps.menu(
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(
                          item.instrumentname.toString(),
                          style: AppTheme.labelTextStyle(),
                        ),
                      );
                    },
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      textAlign: TextAlign.center,
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Drawing number',
                        hintStyle: AppTheme.labelTextStyle(),
                        contentPadding:
                            const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2)),
                      )),
                  onChanged: (value) async {
                    selectedInstrument.add({
                      'instrument': value!.instrumentname.toString().trim(),
                      'instrument_description':
                          value.description.toString().trim(),
                      'product': value.product.toString().trim(),
                      'product_description':
                          value.productdescription.toString().trim(),
                      'rejected_instrument_id':
                          value.instrumentscheduleId.toString().trim(),
                      'rejected_instrument':
                          '${value.instrumentname.toString().trim()}  ${value.cardnumber.toString().trim()}',
                      'instrumentId': value.instrumentId.toString()
                    });
                    range.text = value.measuringrange.toString();
                  },
                ),
              );
            } else {
              return const Stack();
            }
          }),
        ],
      ),
    );
  }

  Container quantityWidget(
      double conWidth, double conHeight, TextEditingController quantity) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              'Quantity : ',
              style: AppTheme.labelTextStyle(isFontBold: true),
            ),
          ),
          SizedBox(
              width: conWidth - 140,
              height: conHeight,
              child: TextField(
                controller: quantity,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: AppTheme.labelTextStyle(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2)),
                  contentPadding: const EdgeInsets.only(
                    bottom: 5,
                  ),
                ),
                onChanged: (value) {
                  quantity.text = value.toString();
                },
              )),
        ],
      ),
    );
  }

  StreamBuilder<List<InstrumentMeasuringRanges>> rangeWidget(
      {required StreamController<List<InstrumentMeasuringRanges>>
          measuringrangeList,
      required double conWidth,
      required double conHeight,
      required TextEditingController range}) {
    return StreamBuilder<List<InstrumentMeasuringRanges>>(
        stream: measuringrangeList.stream,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    'Range : ',
                    style: AppTheme.labelTextStyle(isFontBold: true),
                  ),
                ),
                snapshot.data != null && snapshot.data!.isNotEmpty
                    ? SizedBox(
                        width: conWidth - 140,
                        height: conHeight,
                        child: DropdownSearch<InstrumentMeasuringRanges>(
                            items: snapshot.data!,
                            itemAsString: (item) =>
                                item.measuringrange.toString(),
                            popupProps: PopupProps.menu(
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(
                                    item.measuringrange.toString(),
                                    style: AppTheme.labelTextStyle(),
                                  ),
                                );
                              },
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                                textAlign: TextAlign.center,
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: 'Measuring range',
                                  hintStyle: AppTheme.labelTextStyle(),
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 11, top: 11, left: 2),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                )),
                            onChanged: (value) async {
                              range.text = value!.measuringrange.toString();
                            }))
                    : Container(
                        width: conWidth - 140,
                        height: conHeight,
                        decoration:
                            QuickFixUi().borderContainer(borderThickness: .5),
                        padding: paddingWidget(),
                        child: TextField(
                          controller: range,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (value) {
                            range.text = value.toString();
                          },
                        )),
              ],
            ),
          );
        });
  }

  Container toWidget(double conWidth, double conHeight) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              'To : ',
              style: AppTheme.labelTextStyle(isFontBold: true),
            ),
          ),
          Container(
            width: conWidth - 100,
            height: conHeight,
            padding: paddingWidget(),
            child: BlocBuilder<CalibrationBloc, CalibrationState>(
                builder: (context, state) {
              if (state is OrderInstrumentState) {
                return TextField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: state.toList.isNotEmpty
                          ? state.toList[0].emailaddress.toString().trim()
                          : ''),
                  textAlign: TextAlign.center,
                  style: AppTheme.labelTextStyle(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding: const EdgeInsets.only(
                      bottom: 5,
                    ),
                  ),
                );
              } else {
                return const Stack();
              }
            }),
          ),
        ],
      ),
    );
  }

  Container fromWidget(
      double conWidth, double conHeight, TextEditingController from) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              'From : ',
              style: AppTheme.labelTextStyle(isFontBold: true),
            ),
          ),
          Container(
            width: conWidth - 100,
            height: conHeight,
            padding: paddingWidget(),
            child: BlocBuilder<CalibrationBloc, CalibrationState>(
                builder: (context, state) {
              if (state is OrderInstrumentState) {
                return DropdownSearch<MailAddress>(
                  items: state.fromList,
                  itemAsString: (item) => item.emailaddress.toString(),
                  popupProps: PopupProps.menu(
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(
                          item.emailaddress.toString(),
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
                      )),
                  onChanged: (value) {
                    from.text = value!.emailaddress.toString();
                  },
                );
              } else {
                return const Stack();
              }
            }),
          ),
        ],
      ),
    );
  }

  EdgeInsets marginWidget() => const EdgeInsets.all(10);

  EdgeInsets paddingWidget() => const EdgeInsets.only(left: 10);
}

class InstrumentOrdersCommon {
  List<ColumnData> get ordersTableColumns {
    return [
      ColumnData(label: 'Action', width: 60),
      ColumnData(label: 'Drawing number'),
      ColumnData(label: 'Instrument description'),
      ColumnData(label: 'Product'),
      ColumnData(label: 'Product description'),
      ColumnData(label: 'Range'),
      ColumnData(label: 'Quantity'),
      ColumnData(label: 'Against rejection'),
    ];
  }
}
