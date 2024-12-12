// Author : Shital Gayakwad
// Created Date : 21 April 2023
// Description : ERPX_PPC -> Barcode session
// import 'package:de_opc/services/model/operator/oprator_models.dart';
// import 'package:de_opc/utils/app_colors.dart';
// import 'package:de_opc/utils/app_theme.dart';
import 'package:flutter/material.dart';
import '../../services/model/operator/oprator_models.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';

class BarcodeSession {
  Center barcodeDataUI(
      {required BuildContext context,
      required Map<String, dynamic> sessionData,
      required Map<String, dynamic> machinedata}) {
    return Center(
        child: SizedBox(
            width: 500,
            height: 500,
            child: Column(
              children: [
                const Text(
                  'Barcode Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                space(),
                space(),
                space(),
                space(),
                desContainer(
                    name: 'PO',
                    data: sessionData['po'] != '' ? sessionData['po'] : ''),
                space(),
                desContainer(
                    name: 'Product',
                    data: sessionData['product'] != ''
                        ? sessionData['product']
                        : ''),
                space(),
                desContainer(
                    name: 'Line No',
                    data: sessionData['line_number'] != ''
                        ? sessionData['line_number']
                        : ''),
                space(),
                desContainer(
                    name: 'Raw Material',
                    data: sessionData['raw_material'] != ''
                        ? sessionData['raw_material']
                        : ''),
                space(),
                desContainer(
                    name: 'Dispatch Date',
                    data: sessionData['dispatch_date'] != ''
                        ? sessionData['dispatch_date']
                        : ''),
                space(),
                desContainer(
                    name: 'Issued Quantity',
                    data: sessionData['issue_quantity'] != ''
                        ? sessionData['issue_quantity']
                        : ''),
                space(),
                space(),
                space(),
                InkWell(
                  onTap: () {
                    try {} catch (e) {
                      //
                    }
                  },
                  child: Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  SizedBox space() {
    return const SizedBox(
      height: 8,
    );
  }

  Container desContainer({required String name, required String data}) {
    double conWidth = 500, conheight = 50;
    return Container(
      width: conWidth,
      height: conheight,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: AppColors.blueColor),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 190,
            child: Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text(name, style: AppTheme.tabSubTextStyle()),
            ),
          ),
          const SizedBox(
            width: 98,
            child: Center(
              child: Text(
                ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              data,
              style: AppTheme.tabSubTextStyle(),
            ),
          ),
        ],
      )),
    );
  }

  static Future<bool?> goBack(
          {required BuildContext context,
          required Map<String, dynamic> arguments}) =>
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to go back?'),
              actions: [
                FilledButton(
                  onPressed: () {
                    for (int i = 0; i <= 1; i++) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Go back'),
                ),
                const SizedBox(
                  width: 20,
                  height: 10,
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Stay here'),
                )
              ],
            );
          });

  Column barcodeData(
      {required BuildContext context,
      required double parentWidth,
      required Barcode? barcode}) {
    return Column(
      children: [
        SizedBox(
            height: 40,
            width: parentWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  barcodeDetailsCon(
                      context: context,
                      name: 'PO',
                      data: barcode!.po.toString().trim()),
                  barcodeDetailsCon(
                      context: context,
                      name: 'Product',
                      data: barcode.product.toString().trim()),
                  barcodeDetailsCon(
                      context: context,
                      name: 'Line No.',
                      data: barcode.lineitemnumber.toString().trim()),
                  barcodeDetailsCon(
                      context: context,
                      name: 'Raw Material',
                      data: barcode.rawmaterial.toString().trim()),
                  barcodeDetailsCon(
                      context: context,
                      name: 'Dispatch',
                      data: barcode.dispatchDate.toString().trim()),
                  barcodeDetailsCon(
                      context: context,
                      name: 'Issued Quantity',
                      data: barcode.issueQty.toString().trim())
                ],
              ),
            )),
        const SizedBox(
          child: Divider(thickness: 2, color: AppColors.appTheme),
        )
      ],
    );
  }

  SizedBox barcodeDetailsCon(
      {required BuildContext context,
      required String name,
      required String data}) {
    return SizedBox(
      child: Row(
        children: [
          SizedBox(
            height: 150,
            child: Center(
                child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Text('$name :',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                        Text(
                          ' $data',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ))),
          ),
        ],
      ),
    );
  }
}
