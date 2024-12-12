import 'package:de/services/model/registration/subcontractor_models.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:de/view/widgets/custom_datatable.dart';
import 'package:de/view/widgets/custom_dropdown.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../bloc/ppc/outsource_inward/outsource_bloc/outsource_bloc.dart';
import '../../../../routes/route_names.dart';
import '../../../../services/model/po/po_models.dart';
import 'package:pdf/widgets.dart' as pdf_doc;
import 'package:pdf/pdf.dart' as color;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import '../../../../services/session/user_login.dart';

class ChallanPdf extends StatelessWidget {
  final List<Outsource> outsourceList;
  const ChallanPdf({
    super.key,
    required this.outsourceList,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    BlocProvider.of<OutsourceBloc>(context).add(GetSubcontractorEvent());
    String challanNumber = '';
    String subcontractorId = '';
    AllSubContractor? partyData;
    CompanyDetails company = CompanyDetails();
    return Scaffold(
      appBar:
          CustomAppbar().appbar(context: context, title: "Outsource Challan"),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: BlocBuilder<OutsourceBloc, OutsourceState>(
                builder: (context, state) {
              if (state is SubcontractorListState) {
                company = state.company;
                challanNumber = state.challanNumber;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      "Challan Number : ",
                    ),
                    CustomText(
                      challanNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                );
              } else {
                return const Text("");
              }
            }),
          ),
          Container(
            height: SizeConfig.screenHeight! * 0.7,
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: previewChallanProducts(outsourceList: outsourceList)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal!),
                width: SizeConfig.blockSizeHorizontal! * 25,
                child: BlocBuilder<OutsourceBloc, OutsourceState>(
                  builder: (context, state) {
                    if (state is SubcontractorListState) {
                      return CustomDropdownSearch<AllSubContractor>(
                          items: state.subContractorList,
                          itemAsString: (i) => i.name.toString(),
                          onChanged: (value) {
                            subcontractorId = value?.id ?? '';
                            partyData = value!;
                          },
                          hintText: "Select Subcontractor");
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 150,
                child: DebouncedButton(
                    text: "Confirm",
                    onPressed: () async {
                      if (subcontractorId.isNotEmpty) {
                        if (challanNumber != '') {
                          BlocProvider.of<OutsourceBloc>(context).add(
                              CreateChallanEvent(
                                  challanNo: challanNumber,
                                  subcontractor: subcontractorId,
                                  outsourceList: outsourceList));
                        }

                        Navigator.of(context).pop();
                        DateFormat formatter = DateFormat('dd/MM/yyyy');
                        String date = formatter.format(DateTime.now());
                        final saveddata = await UserData.getUserData();

                        Uint8List pdflist = await generatePdf(
                            outsourcelist: outsourceList,
                            challanNo: challanNumber,
                            party: partyData!,
                            logininfo: saveddata['data'][0]["firstname"] +
                                " " +
                                saveddata['data'][0]["lastname"],
                            outsourceDate: date,
                            company: company);

                        Future.sync(() {
                          BlocProvider.of<OutsourceBloc>(context)
                              .add(SendEmailEvent(
                            challanNo: challanNumber,
                            pdfdata: pdflist,
                          ));
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => PdfPreviewPage(
                                pdfdoc: pdflist,
                              ),
                            ),
                          );
                        });
                      } else {
                        QuickFixUi.errorMessage(
                            "Please Select Subcontractor", context);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => const Color(0XFF01579b)))),
              ),
            ],
          )
        ],
      ),
    );
  }
}

pdf_doc.Widget paddedText(
  final String text, {
  final pdf_doc.TextAlign align = pdf_doc.TextAlign.left,
}) =>
    pdf_doc.Padding(
      padding: const pdf_doc.EdgeInsets.all(6),
      child: pdf_doc.Text(text,
          textAlign: align, style: const pdf_doc.TextStyle(fontSize: 8)),
    );
//----------//
Future<Uint8List> generatePdf(
    {required List<Outsource> outsourcelist,
    required String challanNo,
    required AllSubContractor party,
    required String logininfo,
    required String outsourceDate,
    required CompanyDetails company}) async {
  final pdf = pdf_doc.Document();
  int count = 0;
  const int maxItemsPerPage = 15; // Maximum items per page

  final imageLogo = pdf_doc.MemoryImage(
      (await rootBundle.load('assets/icon/de_logo.png')).buffer.asUint8List());

  for (int pageIndex = 0;
      pageIndex < (outsourcelist.length / maxItemsPerPage).ceil();
      pageIndex++) {
    final start = pageIndex * maxItemsPerPage;
    final end = (pageIndex + 1) * maxItemsPerPage;

    // Ensure the end is within the bounds of the list
    final chunk = outsourcelist.sublist(
        start, end < outsourcelist.length ? end : outsourcelist.length);

    pdf.addPage(
      pdf_doc.Page(
        pageFormat: color.PdfPageFormat.a4,
        build: (context) {
          return pdf_doc.Column(
            children: [
              pdf_doc.SizedBox(width: 55),
              pdf_doc.Container(
                child: pdf_doc.Row(
                  mainAxisAlignment: pdf_doc.MainAxisAlignment.center,
                  children: [
                    pdf_doc.Container(
                        child: pdf_doc.Text('Delivery Challan',
                            style: pdf_doc.TextStyle(
                                fontWeight: pdf_doc.FontWeight.normal,
                                fontSize: 10))),
                  ],
                ),
              ),
              pdf_doc.Divider(
                height: 5,
                thickness: 0.5,
                borderStyle: pdf_doc.BorderStyle.dotted,
              ),
              pdf_doc.SizedBox(height: 5),
              pdf_doc.Row(
                mainAxisAlignment: pdf_doc.MainAxisAlignment.center,
                children: [
                  pdf_doc.SizedBox(
                    height: 40,
                    width: 40,
                    child: pdf_doc.Image(imageLogo),
                  ),
                  pdf_doc.SizedBox(
                    width: 10,
                  ),
                  pdf_doc.Column(children: [
                    pdf_doc.Text(company.name!.trim(),
                        style: pdf_doc.TextStyle(
                            fontWeight: pdf_doc.FontWeight.bold, fontSize: 16)),
                    pdf_doc.Text(company.address!.trim(),
                        style: pdf_doc.TextStyle(
                            fontWeight: pdf_doc.FontWeight.normal,
                            fontSize: 8)),
                    pdf_doc.Text('GSTIN/UIN - ${company.gstin!.trim()}',
                        style: pdf_doc.TextStyle(
                            fontWeight: pdf_doc.FontWeight.normal,
                            fontSize: 8)),
                  ], crossAxisAlignment: pdf_doc.CrossAxisAlignment.center),
                  pdf_doc.SizedBox(width: 20),
                  pdf_doc.Container(
                    height: 40,
                    width: 40,
                    child: pdf_doc.BarcodeWidget(
                      barcode: pdf_doc.Barcode.qrCode(),
                      data: challanNo.toString(),
                    ),
                  ),
                ],
              ),
              pdf_doc.SizedBox(height: 5),
              pdf_doc.Divider(
                height: 7,
                thickness: 0.3,
                borderStyle: pdf_doc.BorderStyle.solid,
              ),
              pdf_doc.Row(
                mainAxisAlignment: pdf_doc.MainAxisAlignment.start,
                children: [
                  pdf_doc.Container(
                      width: SizeConfig.blockSizeHorizontal! * 25,
                      child: pdf_doc.Column(
                        children: [
                          pdf_doc.Text('Challan No : $challanNo',
                              style: pdf_doc.TextStyle(
                                  fontWeight: pdf_doc.FontWeight.normal,
                                  fontSize: 8)),
                          pdf_doc.SizedBox(height: 3),
                          pdf_doc.Text(
                              'Company Name :  ${party.name.toString()}',
                              style: pdf_doc.TextStyle(
                                  fontWeight: pdf_doc.FontWeight.normal,
                                  fontSize: 8)),
                          pdf_doc.SizedBox(height: 3),
                        ],
                        crossAxisAlignment: pdf_doc.CrossAxisAlignment.start,
                      )),
                  pdf_doc.Container(
                      width: SizeConfig.blockSizeHorizontal! * 12,
                      child: pdf_doc.Column(
                        children: [
                          pdf_doc.Text('Date : $outsourceDate',
                              style: pdf_doc.TextStyle(
                                  fontWeight: pdf_doc.FontWeight.normal,
                                  fontSize: 8)),
                          pdf_doc.SizedBox(height: 3),
                          pdf_doc.Text('Address : ${party.address2.toString()}',
                              style: pdf_doc.TextStyle(
                                  fontWeight: pdf_doc.FontWeight.normal,
                                  fontSize: 8)),
                          pdf_doc.SizedBox(height: 3),
                        ],
                        crossAxisAlignment: pdf_doc.CrossAxisAlignment.start,
                      )),
                ],
              ),

              pdf_doc.Row(
                mainAxisAlignment: pdf_doc.MainAxisAlignment.start,
                children: [
                  pdf_doc.Text('Despatch through : $logininfo',
                      style: pdf_doc.TextStyle(
                          fontWeight: pdf_doc.FontWeight.normal, fontSize: 8)),
                ],
              ),
              pdf_doc.SizedBox(height: 5),
              pdf_doc.Divider(
                height: 5,
                thickness: 0.3,
                borderStyle: pdf_doc.BorderStyle.solid,
              ),
              pdf_doc.Container(height: 5),

              // Display the chunk of items for this page

              pdf_doc.Table(
                border: pdf_doc.TableBorder.all(
                    color: color.PdfColors.black, width: 0.3),
                children: [
                  pdf_doc.TableRow(
                    children: [
                      pdf_doc.Padding(
                        child: pdf_doc.Text('Sr.No',
                            style: pdf_doc.TextStyle(
                                fontWeight: pdf_doc.FontWeight.bold,
                                fontSize: 8)),
                        padding: const pdf_doc.EdgeInsets.all(10),
                      ),
                      pdf_doc.Padding(
                        child: pdf_doc.Text('Part Number',
                            style: pdf_doc.TextStyle(
                                fontWeight: pdf_doc.FontWeight.bold,
                                fontSize: 8)),
                        padding: const pdf_doc.EdgeInsets.all(10),
                      ),
                      pdf_doc.Padding(
                        child: pdf_doc.Text('Process',
                            style: pdf_doc.TextStyle(
                                fontWeight: pdf_doc.FontWeight.bold,
                                fontSize: 8)),
                        padding: const pdf_doc.EdgeInsets.all(10),
                      ),
                      pdf_doc.Padding(
                        child: pdf_doc.Text('Qty',
                            style: pdf_doc.TextStyle(
                                fontWeight: pdf_doc.FontWeight.bold,
                                fontSize: 8)),
                        padding: const pdf_doc.EdgeInsets.all(10),
                      )
                    ],
                  ),
                  ...chunk.map(
                    (e) => pdf_doc.TableRow(
                      children: [
                        pdf_doc.Expanded(
                          child: paddedText((count = count + 1).toString()),
                          flex: 0,
                        ),
                        pdf_doc.Expanded(
                          child: paddedText(e.product.toString() +
                              e.revisionnumber.toString()),
                          flex: 2,
                        ),
                        pdf_doc.Expanded(
                          child: paddedText(e.process ?? e.instruction!),
                          flex: 4,
                        ),
                        pdf_doc.Expanded(
                          child: paddedText(e.quantity.toString()),
                          flex: 2,
                        )
                      ],
                    ),
                  ),
                ],
              ),

              pdf_doc.Padding(
                child: pdf_doc.Text(
                  "Received above material in good condition",
                  style: const pdf_doc.TextStyle(fontSize: 8),
                ),
                padding: const pdf_doc.EdgeInsets.all(3),
              ),
              pdf_doc.Divider(
                height: 1,
                thickness: 0.5,
                borderStyle: pdf_doc.BorderStyle.dashed,
              ),
              pdf_doc.SizedBox(
                height: 100,
              ),
              pdf_doc.Row(
                mainAxisAlignment: pdf_doc.MainAxisAlignment.spaceBetween,
                children: [
                  pdf_doc.Column(
                    children: [
                      pdf_doc.Text('Receiver Sign',
                          style: pdf_doc.TextStyle(
                              fontWeight: pdf_doc.FontWeight.bold,
                              fontSize: 9)),
                    ],
                    crossAxisAlignment: pdf_doc.CrossAxisAlignment.start,
                  ),
                  pdf_doc.Text('For Datta Enterprises',
                      style: pdf_doc.TextStyle(
                          fontWeight: pdf_doc.FontWeight.bold, fontSize: 9))
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  return pdf.save();
}

CustomDataTable previewChallanProducts(
    {required List<Outsource> outsourceList}) {
  return CustomDataTable(
      columnNames: const [
        'SrNo',
        'PO',
        'Product',
        'LineItem',
        'Qty',
        'Process'
      ],
      rows: outsourceList
          .map((e) => DataRow(cells: [
                DataCell(Text('${outsourceList.indexOf(e) + 1}')),
                DataCell(Text(e.salesorder!)),
                DataCell(Text(e.product! + e.revisionnumber.toString())),
                DataCell(Text(e.lineitemnumber.toString())),
                DataCell(Text(e.quantity.toString())),
                DataCell(Text(e.process ?? e.instruction!)),
              ]))
          .toList());
}

//-------------------------------------------------//
class PdfPreviewPage extends StatelessWidget {
  final Uint8List pdfdoc;
  const PdfPreviewPage({
    Key? key,
    required this.pdfdoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Navigator.of(context).popAndPushNamed(RouteName.outsourceDashboard);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context)
                .popAndPushNamed(RouteName.outsourceDashboard),
          ),
          title: const Text('PDF Preview'),
        ),
        body: PdfPreview(
          build: (context) => pdfdoc,
          initialPageFormat: color.PdfPageFormat.a4,
        ),
      ),
    );
  }
}
