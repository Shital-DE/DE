import 'package:shared_preferences/shared_preferences.dart';

class EmployeeeRegistrationSession {
  static Future personalInformationSession(
      {required Map<String, dynamic> personalInformation}) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (personalInformation['selectedHonorific'] != '') {
        List<String> empPersonalInfo = [];
        personalInformation.forEach((key, value) {
          empPersonalInfo.add(value.toString());
        });
        preferences.setStringList('empPersonalInfo', empPersonalInfo);
      }
    } catch (e) {
      //
    }
  }

  static Future getEmpPersonalInfo() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> data = preferences.getStringList('empPersonalInfo') ?? [];
    Map<String, dynamic> emptyMap = {};
    return data.isNotEmpty
        ? {
            'selectedHonorific': data[0],
            'firstName': data[1],
            'middleName': data[2],
            'lastName': data[3],
            'dateOfBirth': data[4],
            'qualification': data[5],
            'mobileNumber': data[6],
            'relativeName': data[7],
            'relationWith': data[8],
            'relativeMobileNumber': data[9]
          }
        : emptyMap;
  }

  static Future employeeAddressSession(
      {required Map<String, dynamic> addressInformation}) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (addressInformation['current_add1'] != '') {
        List<String> empAddress = [];
        addressInformation.forEach((key, value) {
          empAddress.add(value.toString());
        });
        preferences.setStringList('employeeAddress', empAddress);
      }
    } catch (e) {
      //
    }
  }

  static Future getEmployeeAddress() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> data = preferences.getStringList('employeeAddress') ?? [];
    Map<String, dynamic> emptyMap = {};
    return data.isNotEmpty
        ? {
            'current_add1': data[0],
            'current_add2': data[1],
            'current_city_id': data[2],
            'current_city_name': data[3],
            'current_pin_code': data[4],
            'current_state_id': data[5],
            'current_state_name': data[6],
            'per_add1': data[7],
            'per_add2': data[8],
            'per_city_id': data[9],
            'per_city_name': data[10],
            'per_pin_code': data[11],
            'per_state_id': data[12],
            'per_state_name': data[13],
            'cur_add_is_same_as_permanent_add': data[14]
          }
        : emptyMap;
  }

  static Future registrationDocumentSession(
      {required Map<String, dynamic> docInfo}) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      // if (docInfo['emp_profile'] != '') {
      List<String> doc = [];
      docInfo.forEach((key, value) {
        doc.add(value.toString());
      });

      preferences.setStringList('docInformation', doc);
      // }
    } catch (e) {
      //
    }
  }

  static Future getDocumentsInfo() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> data = preferences.getStringList('docInformation') ?? [];
    Map<String, dynamic> emptyMap = {};
    return data.isNotEmpty
        ? {
            'bank_ac_number': data[0],
            'bank_name': data[1],
            'bank_ifsc_code': data[2],
            'emp_pf_number': data[3],
            'family_pf_number': data[4],
            'pancard_number': data[5],
            'pancard_image_path': data[6],
            'aadharcard_number': data[7],
            'aadharcard_image_path': data[8],
            'email_id': data[9],
            'date_of_joining': data[10],
            'emp_profile': data[11],
          }
        : emptyMap;
  }

  static Future employementInformationSession(
      {required Map<String, dynamic> employmentInfo}) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (employmentInfo['employee_id'] != null) {
        List<String> employmentInformation = [];
        employmentInfo.forEach((key, value) {
          employmentInformation.add(value.toString());
        });
        preferences.setStringList(
            'employmentInformation', employmentInformation);
      }
    } catch (e) {
      //
    }
  }

  static Future getEmployementDetails() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> data =
        preferences.getStringList('employmentInformation') ?? [];
    Map<String, dynamic> emptyMap = {};
    return data.isNotEmpty
        ? {
            'employee_id': data[0],
            'type_id': data[1],
            'type_code': data[2],
            'type_description': data[3],
            'dept_id': data[4],
            'dept_code': data[5],
            'dept_description': data[6],
            'desig_id': data[7],
            'desig_description': data[8],
            'cmpny_id': data[9],
            'cmpny_code': data[10],
          }
        : emptyMap;
  }

  static Future removeEmployeeRegistrationSession() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('empPersonalInfo');
    preferences.remove('employeeAddress');
    preferences.remove('docInformation');
    preferences.remove('employmentInformation');
    return true;
  }
}
