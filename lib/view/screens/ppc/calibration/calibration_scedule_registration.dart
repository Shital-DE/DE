// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:de/utils/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../bloc/ppc/calibration/calibration_bloc.dart';
import '../../../../bloc/ppc/calibration/calibration_event.dart';
import '../../../../bloc/ppc/calibration/calibration_state.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/quality/calibration_model.dart';
import '../../../../services/repository/quality/calibration_repository.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/date_range_picker.dart';
import '../../../widgets/PDF/image_to_pdf_generator.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CalibrationScheduleRegistration extends StatelessWidget {
  const CalibrationScheduleRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CalibrationBloc>(context);
    blocProvider.add(CalibrationScheduleRegistrationEvent());
    return MakeMeResponsiveScreen(
      windows: screenUi(context, blocProvider),
      horixontaltab: screenUi(context, blocProvider),
      linux: screenUi(context, blocProvider),
    );
  }

  Scaffold screenUi(BuildContext context, CalibrationBloc blocProvider) {
    return Scaffold(
      body: ListView(
        children: [
          QuickFixUi.verticalSpace(height: 5),
          calibrationScheduleRegistrationForm(
              context: context, blocProvider: blocProvider),
          QuickFixUi.verticalSpace(height: 5),
          currentRecordsTable()
        ],
      ),
    );
  }

  BlocBuilder<CalibrationBloc, CalibrationState> currentRecordsTable() {
    StreamController<String> viewPdf = StreamController<String>.broadcast();

    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      Size size = MediaQuery.of(context).size;
      if (state is CalibrationScheduleRegistrationState &&
          state.currentDayRecords.isNotEmpty) {
        double rowHeight = Platform.isAndroid ? 40 : 35,
            tableheight =
                (((state.currentDayRecords.length + 1) * rowHeight) + 2.4) + 20;
        return Container(
            margin: size.width < 1350
                ? const EdgeInsets.only(left: 5, right: 5)
                : const EdgeInsets.only(left: 200),
            width: size.width,
            height: tableheight <= 500 ? tableheight : 500,
            child: CustomTable(
                tablewidth: size.width < 1370 ? size.width : size.width - 400,
                tableheight: tableheight,
                columnWidth: size.width < 1370 ? 200 : 219.5,
                headerBorderThickness: .5,
                rowHeight: rowHeight,
                headerHeight: rowHeight + 20,
                headerStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: Platform.isAndroid ? 15 : 13),
                tableheaderColor: AppColors.whiteTheme,
                headerBorderColor: AppColors.blackColor,
                showIndex: true,
                enableHeaderBottomBorder: true,
                tableOutsideBorder: true,
                enableRowBottomBorder: true,
                column: [
                  ColumnData(label: 'Certificates', width: 100),
                  ColumnData(label: 'Instrument name'),
                  ColumnData(label: 'Instrument type'),
                  ColumnData(label: 'Card number', width: 100),
                  ColumnData(label: 'Range'),
                  ColumnData(
                    label: 'Start date',
                    width: 100,
                  ),
                  ColumnData(
                    label: 'Due date',
                    width: 100,
                  ),
                  ColumnData(
                    label: 'Frequency',
                    width: 100,
                  ),
                  ColumnData(
                    label: 'Purchase order',
                    width: 100,
                  ),
                  ColumnData(label: 'Barcode/QR Code \nInformation'),
                ],
                rows: state.currentDayRecords.map((e) {
                  return RowData(cell: [
                    TableDataCell(
                        width: 100,
                        label: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: e.certificateMdocid != null
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<
                                            Color>(
                                        Theme.of(context).primaryColorLight),
                                  ),
                                  onPressed: () async {
                                    viewPdf.add(e.id.toString());
                                    viewDBPDF(
                                        context: context,
                                        token: state.token,
                                        certificateMdocId:
                                            e.certificateMdocid.toString(),
                                        viewPdf: viewPdf,
                                        instrumentName:
                                            '${e.instrumentname.toString()}.pdf');
                                  },
                                  child: StreamBuilder<String>(
                                      stream: viewPdf.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null &&
                                            snapshot.data == e.id.toString()) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          );
                                        } else {
                                          return Text('View',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontWeight: FontWeight.bold));
                                        }
                                      }))
                              : const Stack(),
                        )),
                    TableDataCell(
                        label: Text(
                      e.instrumentname.toString(),
                      textAlign: TextAlign.center,
                      style: AppTheme.labelTextStyle(),
                    )),
                    TableDataCell(
                        label: Text(
                      e.instrumenttype.toString(),
                      textAlign: TextAlign.center,
                      style: AppTheme.labelTextStyle(),
                    )),
                    TableDataCell(
                        width: 100,
                        label: Text(
                          e.cardnumber.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                    TableDataCell(
                        label: Text(
                      e.measuringrange.toString(),
                      textAlign: TextAlign.center,
                      style: AppTheme.labelTextStyle(),
                    )),
                    TableDataCell(
                        width: 100,
                        label: Text(
                          e.startdate.toString() == '0000-00-00'
                              ? ''
                              : e.startdate != null
                                  ? DateTime.parse(e.startdate.toString())
                                      .toLocal()
                                      .toString()
                                      .substring(0, 10)
                                  : '',
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                    TableDataCell(
                        width: 100,
                        label: Text(
                          e.duedate.toString() == '0000-00-00'
                              ? ''
                              : e.duedate != null
                                  ? DateTime.parse(e.duedate.toString())
                                      .toLocal()
                                      .toString()
                                      .substring(0, 10)
                                  : '',
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                    TableDataCell(
                        width: 100,
                        label: Text(
                          e.frequency == null ? '' : e.frequency.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                    TableDataCell(
                        width: 100,
                        label: Text(
                          e.purchaseorder == null
                              ? ''
                              : e.purchaseorder.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.labelTextStyle(),
                        )),
                    TableDataCell(
                        label: Text(
                      e.barcodeinformation == null
                          ? ''
                          : e.barcodeinformation.toString(),
                      textAlign: TextAlign.center,
                      style: AppTheme.labelTextStyle(),
                    )),
                  ]);
                }).toList()));
      } else {
        return const Stack();
      }
    });
  }

  Container calibrationScheduleRegistrationForm(
      {required BuildContext context, required CalibrationBloc blocProvider}) {
    double conWidth = 230, conHeight = Platform.isAndroid ? 45 : 35;
    StreamController<AllInstrumentsData> allInstrumentsData =
        StreamController<AllInstrumentsData>.broadcast();
    StreamController<List<InstrumentsPurchaseOrder>> purchaseOrderList =
        StreamController<List<InstrumentsPurchaseOrder>>();
    TextEditingController cardNumber = TextEditingController();
    TextEditingController range = TextEditingController();
    TextEditingController startdate = TextEditingController();
    TextEditingController duedate = TextEditingController();
    TextEditingController frequency = TextEditingController();
    TextEditingController barcodedata = TextEditingController();
    TextEditingController purchaseOrderId = TextEditingController();
    TextEditingController manufacturer = TextEditingController();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Platform.isAndroid ? 405 : 355, // 370
      margin: MediaQuery.of(context).size.width < 1350
          ? const EdgeInsets.only(left: 5, right: 5)
          : const EdgeInsets.only(left: 200, right: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          QuickFixUi.verticalSpace(height: 10),
          Text(
            'Calibration Schedule Registration',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Platform.isAndroid ? 17 : 14,
                color: Theme.of(context).colorScheme.error),
          ),
          QuickFixUi.verticalSpace(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(name: 'Drawing number'),
              dots(),
              drawingNumberWidget(
                  conWidth: conWidth,
                  purchaseOrderList: purchaseOrderList,
                  allInstrumentsData: allInstrumentsData,
                  cardNumber: cardNumber,
                  conHeight: conHeight),
              QuickFixUi.horizontalSpace(width: 40),
              title(name: 'Instrument type'),
              dots(),
              instrumentTypeWidget(
                  allInstrumentsData: allInstrumentsData,
                  conWidth: conWidth,
                  conHeight: conHeight)
            ],
          ),
          QuickFixUi.verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(name: 'Card Number'),
              dots(),
              cardNumberWidget(
                  conWidth: conWidth,
                  cardNumber: cardNumber,
                  conHeight: conHeight),
              QuickFixUi.horizontalSpace(width: 40),
              title(name: 'Range'),
              dots(),
              rangeWidget(
                  conWidth: conWidth, range: range, conHeight: conHeight),
            ],
          ),
          QuickFixUi.verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(name: 'Start date'),
              dots(),
              startdateWidget(
                  conWidth: conWidth,
                  startdate: startdate,
                  context: context,
                  duedate: duedate,
                  conHeight: conHeight),
              QuickFixUi.horizontalSpace(width: 40),
              title(name: 'Due date'),
              dots(),
              duedateWidget(
                  conWidth: conWidth,
                  duedate: duedate,
                  context: context,
                  conHeight: conHeight),
            ],
          ),
          QuickFixUi.verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(name: 'Frequency'),
              dots(),
              frequencyWidget(
                  conWidth: conWidth,
                  frequency: frequency,
                  startdate: startdate,
                  duedate: duedate,
                  conHeight: conHeight),
              QuickFixUi.horizontalSpace(width: 40),
              title(name: 'Purchase order number'),
              dots(),
              purchaseOrderWidget(
                  purchaseOrderList: purchaseOrderList,
                  conWidth: conWidth,
                  purchaseOrderId: purchaseOrderId,
                  conHeight: conHeight),
            ],
          ),
          QuickFixUi.verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(name: 'Barcode & Qrcode data'),
              dots(),
              barcodeScanWidget(
                  conWidth: conWidth,
                  barcodedata: barcodedata,
                  context: context,
                  conHeight: conHeight),
              QuickFixUi.horizontalSpace(width: 40),
              title(name: 'Upload certificate'),
              dots(),
              uploadCertificates(conWidth, allInstrumentsData)
            ],
          ),
          QuickFixUi.verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(name: 'Manufacturer'),
              dots(),
              manufacturerWidget(
                  conWidth: conWidth,
                  conHeight: conHeight,
                  manufacturer: manufacturer),
              submitButton(
                  allInstrumentsData: allInstrumentsData,
                  range: range,
                  startdate: startdate,
                  duedate: duedate,
                  frequency: frequency,
                  cardNumber: cardNumber,
                  barcodedata: barcodedata,
                  purchaseOrderId: purchaseOrderId,
                  purchaseOrderList: purchaseOrderList,
                  blocProvider: blocProvider,
                  manufacturer: manufacturer),
            ],
          ),
          QuickFixUi.verticalSpace(height: 10),
        ],
      ),
    );
  }

  BlocBuilder<CalibrationBloc, CalibrationState> manufacturerWidget(
      {required double conWidth,
      required double conHeight,
      required TextEditingController manufacturer}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is CalibrationScheduleRegistrationState) {
        return SizedBox(
          width: conWidth,
          height: conHeight,
          child: DropdownSearch<ManufacturerData>(
            items: state.manufacturerData,
            itemAsString: (item) => item.manufacturer.toString(),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(
                    item.manufacturer.toString(),
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
            onChanged: (value) async {
              manufacturer.text = value!.id.toString();
            },
          ),
        );
      } else {
        return const Stack();
      }
    });
  }

  SizedBox uploadCertificates(double conWidth,
      StreamController<AllInstrumentsData> allInstrumentsData) {
    return SizedBox(
        width: conWidth,
        child: BlocBuilder<CalibrationBloc, CalibrationState>(
            builder: (context, state) {
          if (state is CalibrationScheduleRegistrationState) {
            return const Row(
              children: [
                ImageToPDFGenerator(),
              ],
            );
          } else {
            return const Stack();
          }
        }));
  }

  Future<void> viewDBPDF(
      {required BuildContext context,
      required String token,
      required String certificateMdocId,
      required StreamController<String> viewPdf,
      required String instrumentName}) async {
    String response = await CalibrationRepository()
        .getCertificate(payload: {'id': certificateMdocId}, token: token);
    if (response != '' && response != 'Something went wrong') {
      viewPdf.add('');
      if (Platform.isAndroid) {
        Navigator.pushNamed(context, RouteName.pdf,
            arguments: {'data': base64.decode(response)});
      } else {
        Documents().models(response, instrumentName, '', 'pdf');
      }
    } else {
      viewPdf.add('');
      debugPrint('File not found');
    }
  }

  Container submitButton(
      {required StreamController<AllInstrumentsData> allInstrumentsData,
      required TextEditingController range,
      required TextEditingController startdate,
      required TextEditingController duedate,
      required TextEditingController frequency,
      required TextEditingController cardNumber,
      required TextEditingController barcodedata,
      required TextEditingController purchaseOrderId,
      required StreamController<List<InstrumentsPurchaseOrder>>
          purchaseOrderList,
      required CalibrationBloc blocProvider,
      required TextEditingController manufacturer}) {
    return Container(
        width: 480,
        padding: const EdgeInsets.only(left: 40, right: 200),
        child: BlocBuilder<CalibrationBloc, CalibrationState>(
            builder: (context, state) {
          if (state is CalibrationScheduleRegistrationState) {
            return StreamBuilder<AllInstrumentsData>(
                stream: allInstrumentsData.stream,
                builder: (context, instrumentsnapshot) {
                  return FilledButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error),
                      onPressed: () async {
                        if (instrumentsnapshot.data == null) {
                          QuickFixUi.errorMessage(
                              'Instrument not found.', context);
                        } else if (range.text == '') {
                          QuickFixUi.errorMessage(
                              'Measuring range not found.', context);
                        } else if (startdate.text == '') {
                          QuickFixUi.errorMessage(
                              'Start date not found.', context);
                        } else if (duedate.text == '') {
                          QuickFixUi.errorMessage(
                              'Due date not found.', context);
                        } else if (frequency.text == '') {
                          QuickFixUi.errorMessage(
                              'Frequency not found.', context);
                        } else if (manufacturer.text == '') {
                          QuickFixUi.errorMessage(
                              'Manufacturer not found.', context);
                        } else {
                          QuickFixUi().showProcessing(context: context);
                          String response = await CalibrationRepository()
                              .instrumentScheduleRegistration(
                                  token: state.token,
                                  payload: {
                                'createdby': state.userId.trim(),
                                'instrument_id': instrumentsnapshot.data!.id
                                    .toString()
                                    .trim(),
                                'cardnumber': cardNumber.text.trim(),
                                'measuringrange': range.text.trim(),
                                'startdate': startdate.text.trim(),
                                'duedate': duedate.text.trim(),
                                'frequency': frequency.text.trim(),
                                'certificate_mdocid': '',
                                'barcodeinformation': barcodedata.text.trim(),
                                'purchaseorder_id': purchaseOrderId.text.trim(),
                                'manufacturer': manufacturer.text
                              });

                          if (response.length == 32) {
                            allInstrumentsData.add(AllInstrumentsData());
                            purchaseOrderList.add([]);
                            range.text = '';
                            startdate.text = '';
                            duedate.text = '';
                            frequency.text = '';
                            barcodedata.text = '';
                            purchaseOrderId.text = '';
                            final Directory directory =
                                await getApplicationDocumentsDirectory();
                            final String path = directory.path;
                            final File file = File('$path/certificate.pdf');
                            if (await file.exists()) {
                              List<int> pdfBytes = await file.readAsBytes();
                              String certificateId =
                                  await CalibrationRepository()
                                      .instrumentsCertificatesRegistration(
                                          token: state.token,
                                          payload: {
                                    'instrumentname':
                                        '${instrumentsnapshot.data!.instrumentname.toString().trim()}_${cardNumber.text}.pdf',
                                    'postgresql_id': response.trim(),
                                    'data': base64Encode(pdfBytes)
                                  });

                              cardNumber.text = '';
                              String updatedResponse =
                                  await CalibrationRepository()
                                      .certificateReference(
                                          token: state.token,
                                          payload: {
                                    'id': response.trim(),
                                    'certificate_mdocid': certificateId
                                  });
                              if (updatedResponse == 'Updated successfully') {
                                await file.delete();
                                QuickFixUi.successMessage(
                                    'Calibration schedule registration successful.',
                                    context);
                                Navigator.of(context).pop();
                                blocProvider.add(CalibrationInitialEvent());
                                Future.delayed(const Duration(seconds: 2), () {
                                  blocProvider.add(
                                      CalibrationScheduleRegistrationEvent());
                                });
                              }
                            } else {
                              cardNumber.text = '';
                              QuickFixUi.successMessage(
                                  'Calibration schedule registration successful.',
                                  context);
                              Navigator.of(context).pop();
                              blocProvider.add(CalibrationInitialEvent());
                              Future.delayed(const Duration(seconds: 2), () {
                                blocProvider.add(
                                    CalibrationScheduleRegistrationEvent());
                              });
                            }
                          }
                        }
                      },
                      child: const Text('SUBMIT'));
                });
          } else {
            return const Stack();
          }
        }));
  }

  SizedBox barcodeScanWidget(
      {required double conWidth,
      required TextEditingController barcodedata,
      required BuildContext context,
      required double conHeight}) {
    return SizedBox(
      width: conWidth,
      child: Row(
        children: [
          SizedBox(
            width: conWidth - 52,
            height: conHeight,
            child: TextField(
              readOnly: true,
              controller: barcodedata,
              textAlign: TextAlign.center,
              style: AppTheme.labelTextStyle(),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                String? result = await SimpleBarcodeScanner.scanBarcode(
                  context,
                  barcodeAppBar: const BarcodeAppBar(
                    appBarTitle: 'Test',
                    centerTitle: false,
                    enableBackButton: true,
                    backButtonIcon: Icon(Icons.arrow_back_ios),
                  ),
                  isShowFlashIcon: true,
                  delayMillis: 2000,
                  cameraFace: CameraFace.front,
                );
                if (result != 'null' && result!.isNotEmpty) {
                  barcodedata.text = result;
                } else {
                  barcodedata.text = '';
                }
              },
              icon: Icon(
                Icons.qr_code_scanner,
                color: Theme.of(context).colorScheme.error,
                size: 35,
              ))
        ],
      ),
    );
  }

  SizedBox purchaseOrderWidget(
      {required StreamController<List<InstrumentsPurchaseOrder>>
          purchaseOrderList,
      required double conWidth,
      required TextEditingController purchaseOrderId,
      required double conHeight}) {
    return SizedBox(
        width: conWidth,
        height: conHeight,
        child: StreamBuilder<List<InstrumentsPurchaseOrder>>(
            stream: purchaseOrderList.stream,
            builder: (context, snapshot) {
              return DropdownSearch<InstrumentsPurchaseOrder>(
                items: snapshot.data != null && snapshot.data!.isNotEmpty
                    ? snapshot.data!
                    : [],
                itemAsString: (item) => item.purchaseorder.toString(),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(
                        item.purchaseorder.toString(),
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
                  purchaseOrderId.text = value!.id.toString();
                },
              );
            }));
  }

  BlocBuilder<CalibrationBloc, CalibrationState> frequencyWidget(
      {required double conWidth,
      required TextEditingController frequency,
      required TextEditingController startdate,
      required TextEditingController duedate,
      required double conHeight}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is CalibrationScheduleRegistrationState) {
        return SizedBox(
          width: conWidth,
          height: conHeight,
          child: DropdownSearch<Frequency>(
            items: state.frequencyList,
            itemAsString: (item) => item.frequency.toString(),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(
                    item.frequency.toString(),
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
            onChanged: (value) async {
              if (value!.frequency == '0') {
                QuickFixUi.errorMessage(
                    'Choose a frequency of at least one month.', context);
              } else {
                if (startdate.text != '') {
                  frequency.text = value.id.toString();
                  duedate.text = await DateRangePickerHelper().generateDueDate(
                      startdate: startdate.text, frequency: value.frequency!);
                } else {
                  QuickFixUi.errorMessage('Select start date first', context);
                }
              }
            },
          ),
        );
      } else {
        return const Stack();
      }
    });
  }

  SizedBox duedateWidget(
      {required double conWidth,
      required TextEditingController duedate,
      required BuildContext context,
      required double conHeight}) {
    return SizedBox(
      width: conWidth,
      child: Row(
        children: [
          SizedBox(
            width: conWidth - 52,
            height: conHeight,
            child: TextField(
              readOnly: true,
              controller: duedate,
              textAlign: TextAlign.center,
              style: AppTheme.labelTextStyle(),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                try {
                  DateTime? pickedDate =
                      await QuickFixUi().dateTimePicker(context);

                  if (pickedDate.toString() != '') {
                    duedate.text = pickedDate.toString().substring(0, 10);
                  }
                } catch (e) {
                  QuickFixUi.errorMessage(e.toString(), context);
                }
              },
              icon: Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.error,
                size: 35,
              ))
        ],
      ),
    );
  }

  SizedBox startdateWidget(
      {required double conWidth,
      required TextEditingController startdate,
      required BuildContext context,
      required TextEditingController duedate,
      required double conHeight}) {
    return SizedBox(
      width: conWidth,
      child: Row(
        children: [
          SizedBox(
            width: conWidth - 52,
            height: conHeight,
            child: TextField(
              readOnly: true,
              controller: startdate,
              textAlign: TextAlign.center,
              style: AppTheme.labelTextStyle(),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                try {
                  DateTime? pickedDate =
                      await QuickFixUi().dateTimePicker(context);
                  if (pickedDate.toString() != '') {
                    startdate.text = pickedDate.toString().substring(0, 10);
                  }
                } catch (e) {
                  QuickFixUi.errorMessage(e.toString(), context);
                }
              },
              icon: Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.error,
                size: 35,
              ))
        ],
      ),
    );
  }

  SizedBox rangeWidget(
      {required double conWidth,
      required TextEditingController range,
      required double conHeight}) {
    return SizedBox(
      width: conWidth,
      height: conHeight,
      child: TextField(
        controller: range,
        textAlign: TextAlign.center,
        style: AppTheme.labelTextStyle(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 11, top: 11, left: 2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
        ),
        onChanged: (value) {
          range.text = value.toString();
        },
      ),
    );
  }

  SizedBox cardNumberWidget(
      {required double conWidth,
      required TextEditingController cardNumber,
      required double conHeight}) {
    return SizedBox(
      width: conWidth,
      height: conHeight,
      child: TextField(
        controller: cardNumber,
        textAlign: TextAlign.center,
        style: AppTheme.labelTextStyle(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 11, top: 11, left: 2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
        ),
        onChanged: (value) {
          cardNumber.text = value.toString();
        },
      ),
    );
  }

  StreamBuilder<AllInstrumentsData> instrumentTypeWidget(
      {required StreamController<AllInstrumentsData> allInstrumentsData,
      required double conWidth,
      required double conHeight}) {
    return StreamBuilder<AllInstrumentsData>(
        stream: allInstrumentsData.stream,
        builder: (context, snapshot) {
          return SizedBox(
            width: conWidth,
            height: conHeight,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(
                  text: snapshot.data != null &&
                          snapshot.data!.instrumenttype != null
                      ? snapshot.data!.instrumenttype.toString()
                      : ''),
              textAlign: TextAlign.center,
              style: AppTheme.labelTextStyle(),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              ),
            ),
          );
        });
  }

  BlocBuilder<CalibrationBloc, CalibrationState> drawingNumberWidget(
      {required double conWidth,
      required StreamController<List<InstrumentsPurchaseOrder>>
          purchaseOrderList,
      required StreamController<AllInstrumentsData> allInstrumentsData,
      required TextEditingController cardNumber,
      required double conHeight}) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
        builder: (context, state) {
      if (state is CalibrationScheduleRegistrationState) {
        return SizedBox(
          width: conWidth,
          height: conHeight,
          child: DropdownSearch<AllInstrumentsData>(
            items: state.allInstrumentsList,
            itemAsString: (item) => item.instrumentname.toString(),
            popupProps: PopupProps.menu(
              showSearchBox: true,
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
                  contentPadding:
                      const EdgeInsets.only(bottom: 11, top: 11, left: 2),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2)),
                )),
            onChanged: (value) async {
              purchaseOrderList.add([]);
              allInstrumentsData.add(value!);
              cardNumber.text = await CalibrationRepository()
                  .generateCardNumber(
                      token: state.token, payload: {'instrument_id': value.id});
              List<InstrumentsPurchaseOrder> instrumentsPurchaseOrder =
                  await CalibrationRepository().purchaseOrder(
                      token: state.token,
                      payload: {'product_id': value.productId});
              if (instrumentsPurchaseOrder.isNotEmpty) {
                purchaseOrderList.add(instrumentsPurchaseOrder);
              }
            },
          ),
        );
      } else {
        return const Stack();
      }
    });
  }

  IconButton captureCertificate(
      {required List<String> certificate,
      required StreamController<List<String>> certificateListData,
      required BuildContext context}) {
    return IconButton(
        onPressed: () async {
          XFile? pickedImage =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (pickedImage != null) {
            final appDir = await getApplicationDocumentsDirectory();
            final fileName = path.basename(pickedImage.path);
            final filePath = path.join(appDir.path, fileName);
            final File pickedFile = File(pickedImage.path);
            await pickedFile.copy(filePath);
            certificate.add(pickedFile.path);
            certificateListData.add(certificate);
          }
        },
        icon: Icon(
          Icons.file_open_rounded,
          size: 35,
          color: Theme.of(context).colorScheme.error,
        ));
  }

  SizedBox dots() => const SizedBox(
      width: 30,
      child: Text(':',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)));

  SizedBox title({required String name}) => SizedBox(
      width: 180,
      child: Text(
        name,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Platform.isAndroid ? 15 : 12),
      ));
}
