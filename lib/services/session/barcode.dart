import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/operator/oprator_models.dart';

class ProductData {
  static Future saveBarcodeData({required List<String> barcodelist}) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (barcodelist.isNotEmpty) {
        preferences.setStringList('barode', barcodelist);
      }
    } catch (e) {
      //
    }
  }

  static Future<Barcode> getbarocodeData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> barcode = preferences.getStringList('barode') ?? [];
    List<Barcode> barcodeList = [];
    for (String jsonString in barcode) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      Barcode barcode = Barcode.fromJson(jsonMap);
      barcodeList.add(barcode);
    }
    Barcode? newBarcode;
    for (Barcode barcode in barcodeList) {
      newBarcode = barcode;
    }
    return newBarcode ?? Barcode(productid: '');
  }

  static Future<bool> removeBorcodeSession() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('barode');
    return true;
  }

  // Quality session
  static Future qualitySessionStart({required List<String> qualityData}) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (qualityData.isNotEmpty) {
        preferences.setStringList('qualitySession', qualityData);
      }
    } catch (e) {
      //
    }
  }

  //Quality get Data
  static Future<Map<String, dynamic>> getQualityStatus() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> qualityBarcodeData =
        preferences.getStringList('qualitySession') ?? [];
    return qualityBarcodeData.isNotEmpty
        ? {
            'product_id': qualityBarcodeData[0],
            'rms_id': qualityBarcodeData[1],
            'po': qualityBarcodeData[2],
            'product': qualityBarcodeData[3],
            'line_number': qualityBarcodeData[4],
            'raw_material': qualityBarcodeData[5],
            'dispatch_date': qualityBarcodeData[6],
            'issue_quantity': qualityBarcodeData[7],
            'start_time': qualityBarcodeData[8],
          }
        : {};
  }

  //Remove quality session
  static Future<bool> removeQualitySession() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('qualitySession');
    return true;
  }
}
