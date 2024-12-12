// Author : Shital Gayakwad
// Created Date : 26 Nov 2023
// Description : Packing dashboard

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/packing_bloc/packing_bloc.dart';
import '../../../../bloc/production/packing_bloc/packing_event.dart';
import '../../../../bloc/production/packing_bloc/packing_state.dart';
import '../../../../services/model/operator/oprator_models.dart';
import '../../../../services/repository/packing/packing_repository.dart';
import '../../../../services/repository/quality/quality_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/barcode_session.dart';
import '../../common/documents.dart';

class PakingDashboard extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const PakingDashboard({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    final blocProvider = BlocProvider.of<PackingBloc>(context);
    blocProvider.add(PackingWorkLogEvent(barcode: barcode));
    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Product inspection screen'),
      body: MakeMeResponsiveScreen(horixontaltab:
          BlocBuilder<PackingBloc, PackingState>(builder: (context, state) {
        if (state is PackingWorkLogState) {
          return ListView(
            children: [
              BarcodeSession().barcodeData(
                  context: context, parentWidth: 1280, barcode: barcode),
              Documents().documentsButtons(
                  context: context,
                  alignment: Alignment.center,
                  topMargin: 0,
                  token: state.token,
                  pdfMdocId: state.pdfMdocId,
                  product: state.barcode!.product.toString(),
                  productDescription: state.productDescription,
                  pdfRevisionNo: state.pdfRevisionNo,
                  modelMdocId: state.modelMdocId,
                  modelimageType: state.imageType),
              Documents().horizontalVersions(
                  context: context,
                  topMargin: 0,
                  pdfMdocId: state.pdfMdocId,
                  pdfRevisionNo: state.pdfRevisionNo,
                  modelMdocId: state.modelMdocId,
                  modelRevisionNo: state.modelRevisionNo,
                  modelsDetails: state.modelsDetails,
                  pdfDetails: state.pdfDetails,
                  modelimageType: state.imageType,
                  product: state.barcode!.product.toString(),
                  productDescription: state.productDescription,
                  token: state.token),
              QuickFixUi.verticalSpace(height: 30),
              packingForm(
                  context: context, state: state, blocProvider: blocProvider)
            ],
          );
        } else if (state is PackingErrorState &&
            state.errorMessage ==
                'The packing process for this product has been finished.') {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return const Stack();
        }
      })),
    );
  }

  Column packingForm(
      {required BuildContext context,
      required PackingWorkLogState state,
      required PackingBloc blocProvider}) {
    TextEditingController packingQuantity = TextEditingController();
    TextEditingController stockQuantity = TextEditingController();
    return Column(
      children: [
        const Center(
            child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Shipping & Packing Registration Form",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        )),
        QuickFixUi.verticalSpace(height: 10),
        Center(
            child: Container(
                decoration: QuickFixUi().borderContainer(borderThickness: .5),
                width: 300,
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  controller: packingQuantity,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Packing quantity'),
                  onChanged: (value) {
                    packingQuantity.text = value.toString();
                  },
                ))),
        QuickFixUi.verticalSpace(height: 10),
        Center(
            child: Container(
                decoration: QuickFixUi().borderContainer(borderThickness: .5),
                width: 300,
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  controller: stockQuantity,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Stock quantity'),
                  onChanged: (value) {
                    stockQuantity.text = value.toString();
                  },
                ))),
        QuickFixUi.verticalSpace(height: 10),
        Center(
            child: FilledButton(
                onPressed: () {
                  if (packingQuantity.text == '') {
                    QuickFixUi.errorMessage(
                        'Please fill packing quantity first', context);
                  } else {
                    endPacking(
                        context: context,
                        state: state,
                        packingQuantity: packingQuantity,
                        stockQuantity: stockQuantity);
                  }
                },
                child: const Text('SUBMIT'))),
      ],
    );
  }

  Future<dynamic> endPacking(
      {required BuildContext context,
      required PackingWorkLogState state,
      required TextEditingController packingQuantity,
      required TextEditingController stockQuantity}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const SizedBox(
              height: 25,
              child: Center(
                  child: Text(
                'Are you sure you want to end the packing?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )),
            ),
            actions: [
              FilledButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    String newResponse = '';
                    if (stockQuantity.text != '') {
                      newResponse = await PackingRepository()
                          .decreaseStock(token: state.token, payload: {
                        'stock_quantity': stockQuantity.text,
                        'product_id': state.barcode!.productid.toString(),
                        'revision_value':
                            state.barcode!.revisionnumber.toString()
                      });
                    }
                    debugPrint(newResponse);
                    final response = await QualityInspectionRepository()
                        .endInspection(token: state.token, payload: {
                      'id': state.packingId,
                      'ok_quantity': packingQuantity.text,
                      'rework_quantity': 0,
                      'rejected_quantity': 0,
                      'rejected_reasons': '',
                      'remark': '',
                      'stockqty': newResponse == 'Not enough stock available.'
                          ? 0
                          : stockQuantity.text == ''
                              ? 0
                              : stockQuantity.text
                    });
                    if (response == 'Product inspected successfully') {
                      packingQuantity.text = '';
                      stockQuantity.text = '';
                      finalEndPacking(
                          context: context,
                          state: state,
                          message: newResponse == 'Not enough stock available.'
                              ? """\n But we can't use quantity in stock because ${newResponse.toLowerCase()}"""
                              : '');
                    } else {
                      navigator.pop();
                      QuickFixUi.errorMessage(response.toString(), context);
                    }
                  },
                  child: const Text('Yes')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  Future<dynamic> finalEndPacking(
      {required BuildContext context,
      required PackingWorkLogState state,
      required String message}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 70,
              child: Center(
                  child: Text(
                'The packing process for this product has been finished.$message \n Do you want to finally end packing?',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )),
            ),
            actions: [
              FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.error),
                  ),
                  onPressed: () {
                    for (int i = 0; i <= 2; i++) {
                      Navigator.of(context).pop();
                    }
                    QualityInspectionRepository().finalEndInspection(
                        context: context,
                        token: state.token,
                        payload: {
                          'productid': state.barcode!.productid,
                          'rmsissueid': state.barcode!.rawmaterialissueid,
                          'workcentreid': state.workcentre,
                          'revision_number': state.barcode!.revisionnumber
                        },
                        message: 'Packing successful.');
                  },
                  child: const Text('Yes')),
              FilledButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith(
                    (states) => AppColors.greenTheme,
                  )),
                  onPressed: () {
                    for (int i = 0; i <= 2; i++) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
