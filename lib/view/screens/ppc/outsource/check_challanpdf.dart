// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:de/bloc/ppc/outsource_inward/challanpdf_cubit/challanpdf_cubit.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:de/view/widgets/custom_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../../bloc/ppc/outsource_inward/outsource_bloc/outsource_bloc.dart';
import '../../../../utils/constant.dart';
import '../../../widgets/custom_dropdown.dart';
import 'challan_pdf.dart';
import 'package:pdf/pdf.dart' as color;

class CheckChallanPdf extends StatelessWidget {
  const CheckChallanPdf({super.key});

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat.MMMM().format(DateTime.now());
    int currentYear = DateTime.now().year;
    String subcontractorId = "";

    SizeConfig.init(context);
    BlocProvider.of<OutsourceBloc>(context).add(GetSubcontractorEvent());

    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: "PDF"),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, right: 20),
                width: SizeConfig.screenWidth! * 0.33,
                child: BlocBuilder<OutsourceBloc, OutsourceState>(
                  builder: (context, state) {
                    if (state is SubcontractorListState) {
                      return CustomDropdownSearch(
                          items: state.subContractorList,
                          itemAsString: (i) => i.name.toString(),
                          onChanged: (value) {
                            subcontractorId = value!.id!;
                            BlocProvider.of<ChallanpdfCubit>(context)
                                .getAllChallanPdfList(
                                    subcontractorId: subcontractorId,
                                    month: monthList.indexOf(currentMonth) + 1,
                                    year: currentYear);
                          },
                          hintText: "Select Subcontractor");
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 20),
                  width: SizeConfig.screenWidth! * 0.1,
                  child: CustomDropdownSearch<String>(
                    items: monthList,
                    selectedItem: currentMonth,
                    itemAsString: (item) => item,
                    onChanged: (item) {
                      currentMonth = item!;
                      BlocProvider.of<ChallanpdfCubit>(context)
                          .getAllChallanPdfList(
                              subcontractorId: subcontractorId,
                              month: monthList.indexOf(currentMonth) + 1,
                              year: currentYear);
                    },
                    hintText: "Month",
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: SizeConfig.screenWidth! * 0.1,
                  child: CustomDropdownSearch<int>(
                      items: yearList,
                      selectedItem: currentYear,
                      itemAsString: (i) => i.toString(),
                      onChanged: (value) {
                        currentYear = value!;
                        BlocProvider.of<ChallanpdfCubit>(context)
                            .getAllChallanPdfList(
                                subcontractorId: subcontractorId,
                                month: monthList.indexOf(currentMonth) + 1,
                                year: currentYear);
                      },
                      hintText: "Year")),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight! * 0.6,
            child: BlocBuilder<ChallanpdfCubit, ChallanpdfState>(
              builder: (context, state) {
                DateFormat formatter = DateFormat('dd/MM/yyyy');
                if (state is ListChallanPDFState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CustomSearchDataTable(
                        columnNames: const [
                          "Challan-No",
                          "Outsource Date",
                          "Download PDF"
                        ],
                        tableBorder: const TableBorder(
                            top: BorderSide(),
                            bottom: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide()),
                        rows: state.challanPdflist
                            .map((e) => DataRow(cells: [
                                  DataCell(CustomText(
                                      e.challan!.outwardchallan.toString())),
                                  DataCell(CustomText(DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.parse(e
                                              .challan!.outsourcedate
                                              .toString())
                                          .toLocal()))),
                                  DataCell(IconButton(
                                    icon: const Icon(
                                        Icons.picture_as_pdf_outlined),
                                    onPressed: () async {
                                      String formattedDate = formatter.format(
                                          DateTime.parse(e
                                              .challan!.outsourcedate
                                              .toString()));

                                      Uint8List pdflist = await generatePdf(
                                          outsourcelist: e.outlist,
                                          challanNo: e.challan!.outwardchallan
                                              .toString(),
                                          party: e.party!,
                                          logininfo:
                                              e.despatchthrough.toString(),
                                          outsourceDate: formattedDate,
                                          company: state.company);

                                      Future.microtask(() {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PrintPdf(
                                              pdfdoc: pdflist,
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  )),
                                ]))
                            .toList()),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class PrintPdf extends StatelessWidget {
  final Uint8List pdfdoc;
  const PrintPdf({
    super.key,
    required this.pdfdoc,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
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
