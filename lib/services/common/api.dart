// // Author : Shital Gayakwad
// // Created Date : 24 Feb 2023
// // Description : ERPX_PPC ->Api Calling functinality

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  //For get Api response
  Future getApiResponse(
    String url,
    Map<String, String> headers,
  ) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response;
      } else {
        return 'No data found';
      }
    } catch (error) {
      return http.Response(error.toString(), 500);
    }
  }

  //For post api
  Future<http.Response> postApiResponse(
      String url, String token, Map<String, dynamic> payload) async {
    try {
      Map<String, String> headers;
      if (token == '') {
        headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
      }
      if (payload.isNotEmpty) {
        final response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(payload));
        if (response.statusCode == 200) {
          return response;
        } else {
          return response;
        }
      } else {
        return http.Response('Payload is empty', 404);
      }
    } catch (e) {
      return http.Response(e.toString(), 500);
    }
  }

  Future<http.Response> postApiWithBodyPayload(
      String url, String token, Map<String, dynamic> payload) async {
    try {
      Map<String, String> headers;
      if (token == '') {
        headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
      }
      if (payload.isNotEmpty) {
        final response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(payload));
        if (response.statusCode == 200) {
          return response;
        } else {
          return response;
        }
      } else {
        return http.Response('Payload is empty', 404);
      }
    } catch (e) {
      return http.Response(e.toString(), 500);
    }
  }

  //Put api
  Future<http.Response> putApiResponse(
      String url, String token, Map<String, dynamic> payload) async {
    try {
      Map<String, String> headers;
      if (token == '') {
        headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
      }
      if (payload.isNotEmpty) {
        final response = await http.put(Uri.parse(url),
            headers: headers, body: jsonEncode(payload));
        if (response.statusCode == 200) {
          return response;
        } else {
          return response;
        }
      } else {
        return http.Response('Payload is empty', 404);
      }
    } catch (e) {
      return http.Response(e.toString(), 500);
    }
  }

  Future<http.Response> deleteApiResponse(
      {required String url,
      required String token,
      required Map<String, String> payload}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return http.Response(e.toString(), 500);
    }
  }
}
