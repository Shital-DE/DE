// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:typed_data';
import 'package:de/services/model/registration/subcontractor_models.dart';
import '../../../utils/app_url.dart';
import '../../model/po/po_models.dart';
import '../../session/user_login.dart';
import 'package:http/http.dart' as http;

class OutsourceService {
  static Future<List<Outsource>> listOutsourceData(
      {required String fromdate, required String todate}) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/supervisor/outsource/list");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({"fromDate": fromdate, "toDate": todate}));
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      List<Outsource> outsourceList =
          list.map((e) => Outsource.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return outsourceList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<AllSubContractor>> subcotractorList() async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/supervisor/subcontractor/subcontractor-list");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["list"];
      List<AllSubContractor> subcontractor =
          list.map((e) => AllSubContractor.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return subcontractor;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> generateChallanNo() async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/supervisor/outsource/challan_no");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['challan_no'];
      } else {
        return '';
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> saveOutsourceChallan(
      {required String challanNo,
      required String subcontractor,
      required List<Outsource> outsourceList}) async {
    try {
      String challanDate = DateTime.now().toString().split(' ')[0];

      var url =
          Uri.parse("${AppUrl.baseUrl}/supervisor/outsource/save-outsource");
      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({
            "outwardchallan_no": challanNo,
            "subcontractor_id": subcontractor,
            "outsource_list": outsourceList,
            "outsource_date": challanDate,
            "userid": saveddata['data'][0]['id'].toString()
          }));

      if (response.statusCode == 200) {
        return challanNo;
      } else {
        return '';
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> sendOutsourceChallanMail(
      {required String challanNo, required Uint8List pdf}) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/supervisor/mail/send");
      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({"outsource_challan": challanNo, "pdfdata": pdf}));

      if (response.statusCode == 200) {
        return challanNo;
      } else {
        return '';
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<InwardChallan>> inwardList(
      {required String subcontractorId}) async {
    try {
      var url = Uri.parse("${AppUrl.baseUrl}/supervisor/outsource/inward-list");
      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({"subcontractor_id": subcontractorId}));

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      List<InwardChallan> inwardList = [];
      list.map((e) {
        Outsource o = Outsource.fromJson(e);
        Challan c = Challan.fromJson(e);
        InwardChallan i = InwardChallan(o, c);
        inwardList.add(i);
      }).toList();
      if (response.statusCode == 200) {
        // inwardList.forEach((element) {element.ou})
        return inwardList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> saveInwardChallan(
      {required InwardChallan inwardchallan,
      required int qty,
      required bool status}) async {
    try {
      String challanDate = DateTime.now().toString().split(' ')[0];

      var url = Uri.parse("${AppUrl.baseUrl}/supervisor/outsource/save-inward");
      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({
            "challandata": inwardchallan.challan,
            "outsource": inwardchallan.outsource,
            "qty": qty,
            "status": status,
            "outsource_date": challanDate,
            "userid": saveddata['data'][0]['id'].toString()
          }));

      if (response.statusCode == 200) {
        return "challanNo";
      } else {
        return '';
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<InwardChallan>> finishedInwardList(
      {required String subcontractorId, required bool check}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/supervisor/outsource/finished-inward-list");
      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({"subcontractor_id": subcontractorId}));

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      List<InwardChallan> inwardList = [];
      list.map((e) {
        Outsource o = Outsource.fromJson(e);
        Challan c = Challan.fromJson(e);
        InwardChallan i = InwardChallan(o, c);
        inwardList.add(i);
      }).toList();
      if (response.statusCode == 200) {
        // inwardList.forEach((element) {element.ou})
        return inwardList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> savesubcontractorProcessCapability(
      {required String subcontractorId, required String processId}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/supervisor/outsource/save-subcontractor-process");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({
            "subcontractor_id": subcontractorId,
            "process_id": processId,
            "userid": saveddata['data'][0]['id'].toString()
          }));
      // Map<String, dynamic> data = jsonDecode(response.body);
      // List<dynamic> list = data["data"];
      // List<Outsource> outsourceList =
      //     list.map((e) => Outsource.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Fail";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ProcessCapability>> listProcessCapability() async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/supervisor/outsource/list-process-capability");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];
      List<ProcessCapability> subProcessList =
          list.map((e) => ProcessCapability.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return subProcessList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future deleteProcessCapability({required String id}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/supervisor/outsource/delete-subcontractor-process");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({"id": id}));

      if (response.statusCode == 200) {
        // return subProcessList;
      } else {
        // return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<ChallanPDFList>> listChallanPdfService(
      {required String subcontractorId,
      required int month,
      required int year}) async {
    try {
      var url = Uri.parse(
          "${AppUrl.baseUrl}/supervisor/outsource/list-subcontractor-challan");
      final saveddata = await UserData.getUserData();

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${saveddata['token'].toString()}'
          },
          body: jsonEncode({
            "subcontractor_id": subcontractorId,
            "month": month,
            "year": year
          }));

      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> list = data["data"];

      List<ChallanPDFList> challanPrintList = [];
      list.map((e) {
        List<dynamic> outwardlist = e['outlist'];
        List<Outsource> outsourceList =
            outwardlist.map((e) => Outsource.fromJson(e)).toList();
        list.map((e) => Outsource.fromJson(e)).toList();
        ChallanPDFList i = ChallanPDFList(
            challan: Challan.fromJson(e),
            party: AllSubContractor.fromJson(e),
            despatchthrough: e['despatchthrough'],
            outlist: outsourceList);
        challanPrintList.add(i);
      }).toList();
      if (response.statusCode == 200) {
        return challanPrintList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<CompanyDetails> getCompanyDetails() async {
    try {
      var url =
          Uri.parse("${AppUrl.baseUrl}/supervisor/outsource/company-details");
      final saveddata = await UserData.getUserData();
      http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization": 'Bearer ${saveddata['token'].toString()}'
        },
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> companylist = data["data"];

      CompanyDetails company = CompanyDetails.fromJson(companylist[0]);

      if (response.statusCode == 200) {
        return company;
      } else {
        return CompanyDetails(name: "", address: "", gstin: "");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
