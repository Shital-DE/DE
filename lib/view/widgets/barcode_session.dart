// Author : Shital Gayakwad
// Created Date : 21 April 2023
// Description : ERPX_PPC -> Barcode session
// import 'package:de_opc/services/model/operator/oprator_models.dart';
// import 'package:de_opc/utils/app_colors.dart';
// import 'package:de_opc/utils/app_theme.dart';
import 'package:flutter/material.dart';
import '../../services/model/operator/oprator_models.dart';

class BarcodeSession {
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
        SizedBox(
          child: Divider(thickness: 2, color: Theme.of(context).primaryColor),
        ),
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
                              fontSize: 15,
                            )),
                        Text(
                          ' $data',
                          style: const TextStyle(
                            fontSize: 15,
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
