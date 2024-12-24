// ignore_for_file: depend_on_referenced_packages

import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';

class CommonRepository {
  // Send bulk mail.
  Future<String> sendbulkmail(
      {required String token, required Map<String, dynamic> payload}) async {
    try {
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.sendbulkmailurl, token, payload);
        return response.body.toString();
      } else {
        return 'Payload not found';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
