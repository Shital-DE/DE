import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../services/model/registration/machine_registration_model.dart';
import '../../../services/repository/machine/machine_registration_repository.dart';
import '../../../services/session/user_login.dart';
import 'pdf.dart';

class Challan extends StatelessWidget {
  final List<String> columns;
  final dynamic row;
  final String contractorCompany,
      contractorName,
      challanno,
      date,
      despatchThrough;
  const Challan(
      {super.key,
      required this.columns,
      required this.row,
      required this.contractorCompany,
      required this.contractorName,
      required this.challanno,
      required this.date,
      required this.despatchThrough});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: Platform.isAndroid ? false : true,
      ),
      body: Center(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: FutureBuilder<PDFPreviewWidget>(
            future: generatePDF(size: size, despatchThrough: despatchThrough),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Stack();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return snapshot.data!;
              } else {
                return const Text('Something went wrong');
              }
            },
          ),
        ),
      ),
    );
  }

  Future<PDFPreviewWidget> generatePDF(
      {required Size size, required String despatchThrough}) async {
    final saveddata = await UserData.getUserData();
    List<Company> companyDetailsList = await MachineRegistrationRepository()
        .getCompany(saveddata['token'].toString());
    final imageLogo = pw.MemoryImage(
        (await rootBundle.load('assets/icon/de_logo.png'))
            .buffer
            .asUint8List());
    double conWidth = 240, conHeight = 10;
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Container(
              width: size.width,
              height: size.height,
              child: pw.Column(children: [
                pw.Text('Delivery Challan',
                    style: const pw.TextStyle(fontSize: 10)),
                pw.Divider(
                  height: 5,
                  thickness: 0.5,
                  borderStyle: pw.BorderStyle.dotted,
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.SizedBox(
                        height: 40,
                        width: 40,
                        child: pw.Image(imageLogo),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                                companyDetailsList[0].name.toString().trim(),
                                style: const pw.TextStyle(fontSize: 13)),
                            pw.Text(
                                companyDetailsList[0].address.toString().trim(),
                                style: const pw.TextStyle(fontSize: 7)),
                            pw.Text(
                                'GSTIN/UIN -${companyDetailsList[0].gstin.toString().trim()}',
                                style: const pw.TextStyle(fontSize: 7))
                          ]),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        height: 40,
                        width: 40,
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: challanno,
                        ),
                      ),
                    ]),
                pw.SizedBox(height: 5),
                pw.Divider(
                  height: 7,
                  thickness: 0.4,
                  borderStyle: pw.BorderStyle.solid,
                ),
                pw.Column(children: [
                  pw.Row(children: [
                    pw.Container(
                      height: conHeight,
                      width: conWidth,
                      child: pw.Text('Challan No : $challanno',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal, fontSize: 8)),
                    ),
                    pw.Container(
                      height: conHeight,
                      width: conWidth,
                      child: pw.Text('Date :  $date',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal, fontSize: 8)),
                    )
                  ]),
                  pw.Row(children: [
                    pw.Container(
                      width: conWidth,
                      child: pw.Text('Company Name :  $contractorCompany',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal, fontSize: 8)),
                    ),
                    pw.Container(
                      width: conWidth,
                      child: pw.Text('Address : $contractorName',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal, fontSize: 8)),
                    )
                  ]),
                  pw.Row(children: [
                    pw.Container(
                        height: conHeight,
                        child: pw.Text('Despatch through : $despatchThrough',
                            // {"${saveddata['data'][0]["firstname"].toString().trim()} ${saveddata['data'][0]["lastname"].toString().trim()}"}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 8))),
                  ]),
                ]),
                pw.SizedBox(height: 5),
                pw.Divider(
                  height: 5,
                  thickness: 0.5,
                  borderStyle: pw.BorderStyle.solid,
                ),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  children: [
                    pw.TableRow(
                      children:
                          columns.map((e) => tableColumn(element: e)).toList(),
                    ),
                    ...row
                  ],
                ),
                pw.Container(height: 5),
                pw.Padding(
                  child: pw.Text(
                    "Received above instruments in good condition",
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  padding: const pw.EdgeInsets.all(1),
                ),
                pw.Divider(
                  height: 1,
                  thickness: 0.5,
                  borderStyle: pw.BorderStyle.dashed,
                ),
                pw.SizedBox(
                  height: 90,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('Receiver Sign',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ],
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                    ),
                    pw.SizedBox(
                      width: 280,
                    ),
                    pw.Text('For Datta Enterprises',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 8))
                  ],
                ),
              ]),
            )));
    final bytes = await pdf.save();
    return PDFPreviewWidget(
      bytes: bytes,
    );
  }

  pw.Widget tableColumn({required String element}) {
    return pw.Padding(
      child: pw.Text(element,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
      padding: const pw.EdgeInsets.all(10),
    );
  }
}

class PDFTableRow {
  pw.Widget rowTiles({required String element}) {
    return pw.Expanded(
      flex: 0,
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(element,
            textAlign: pw.TextAlign.left,
            style: const pw.TextStyle(fontSize: 7)),
      ),
    );
  }
}
