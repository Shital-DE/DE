// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/machine/assigned_machine.dart';

class AssignedmachineRepository {
  Future assignedMachine(String androidId, String token) async {
    List<dynamic> assignedMachineDataList = [];
    try {
      if (androidId != '') {
        Map<String, dynamic> payload = {
          'androidId': androidId.toString().trim(),
        };
        if (payload.isNotEmpty) {
          http.Response? response = await API()
              .postApiResponse(AppUrl.assignedMachine, token, payload);

          if (response.body.toString() == 'Server unreachable') {
            return 'Server unreachable';
          } else {
            assignedMachineDataList = jsonDecode(response.body);
          }
        }
      } else {
        return 'Android id not available';
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return assignedMachineDataList
        .map((machine) => AssignedMachine.fromJson(machine))
        .toList();
  }
}
