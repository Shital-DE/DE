// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../../../utils/app_url.dart';
import '../../common/api.dart';
import '../../model/user/user_model.dart';

class UserRepository {
  // Employee full name
  Future employeeFullName({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.empFullName, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => EmployeeName.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Validate username
  Future validateUsername(
      {required String username, required String token}) async {
    try {
      Map<String, String> payload = {
        'username': username,
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.validateUsername, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return 'user found';
        } else {
          return 'user not found';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Register username and password to acl_user table
  Future createLoginCredential(
      {required String createdby,
      required String username,
      required String password,
      required String mobileno,
      required String token,
      required empId}) async {
    try {
      List<int> bytes = utf8.encode(password); // Compute the SHA-256 hash
      Digest digest =
          sha256.convert(bytes); // Convert the digest to a hexadecimal string
      String hashedPassword = digest.toString();
      Map<String, String> payload = {
        'createdby': createdby,
        'username': username,
        'password': hashedPassword,
        'pass': password,
        'mobileno': mobileno,
        'empId': empId
      };
      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.createUserCredentials, token, payload);
        if (response.body.toString() == 'Updated successfully') {
          http.Response res = await API()
              .postApiResponse(AppUrl.createEmpCredentials, token, payload);
          if (res.body.toString() == 'Inserted successfully') {
            return 'Inserted successfully';
          } else {
            return res.body.toString();
          }
        } else {
          return response.body.toString();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Get employee role list
  Future employeeRole({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.employeeRole, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => EmployeeRole.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Validate user role is already registerd or not
  Future validateUserRole(
      {required String rolename, required String token}) async {
    try {
      Map<String, String> payload = {
        'rolename': rolename,
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.validateRole, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return 'user found';
        } else {
          return 'user not found';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Register employee role
  Future registerEmployeeRole(
      {required String token,
      required String role,
      required String createdby}) async {
    try {
      Map<String, String> payload = {
        'createdby': createdby,
        'role': role,
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.registerEmpRole, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// All users list form acl_user
  Future user({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.user, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => AllUsers.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Validate user role is assigned to user or not
  Future validateRoleAssignedOrNot(
      {required String userid, required String token}) async {
    try {
      Map<String, String> payload = {
        'userid': userid,
      };
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.validateIfRoleAlreadyAssignedToUser, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data[0]['rolename'].toString();
        } else {
          return 'not found';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Assign user role to user
  Future assignUserRole(
      {required String token,
      required String createdby,
      required String userid,
      required String roleid}) async {
    try {
      Map<String, String> payload = {
        'createdby': createdby,
        'userid': userid,
        'roleid': roleid,
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.assignUserRole, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Validate programs are already registered or not
  Future validateProgramRegistration(
      {required String programname, required String token}) async {
    try {
      Map<String, String> payload = {
        'programname': programname,
      };
      if (payload.isNotEmpty) {
        http.Response response = await API().postApiResponse(
            AppUrl.validateProgramRegistration, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data[0]['programname'].toString();
        } else {
          return 'not found';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// register programs
  Future registerProgram(
      {required String token,
      required String createdby,
      required String programname,
      required String schemaname}) async {
    try {
      Map<String, String> payload = {
        'createdby': createdby,
        'programname': programname,
        'schemaname': schemaname,
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.registerProgram, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Validate if folder is registered
  Future validateFolderRegistration(
      {required String foldername, required String token}) async {
    try {
      Map<String, String> payload = {
        'foldername': foldername,
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.validateFolder, token, payload);
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data[0]['foldername'].toString();
        } else {
          return 'not found';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// All programs list
  Future allPrograms({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.allPrograms, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => AllPrograms.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// All folders list
  Future allFolders({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.allFolders, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => AllFolders.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Register folders
  Future registerFolder(
      {required String token,
      required String createdby,
      required String foldername}) async {
    try {
      Map<String, String> payload = {
        'createdby': createdby,
        'foldername': foldername
      };
      if (payload.isNotEmpty) {
        http.Response response =
            await API().postApiResponse(AppUrl.registerFolders, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Programs available in folder
  Future programsInFolder({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.programsInFolder, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => ProgramsInFolder.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Add programs to folder
  Future addProgramsToFolder(
      {required String token,
      required String createdby,
      required String folderid,
      required List<ProgramsNotInFolder> programs}) async {
    try {
      Map<String, dynamic> payload = {
        'createdby': createdby,
        'folderid': folderid,
        'programs': List<Map<String, String>>.from(
            programs.map((program) => {'id': program.id.toString()})),
      };

      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.addProgramsInFolder, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Programs assigned to role
  Future programsAssignedToRole({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.programsAssignedToRole, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => ProgramsAssignedToRole.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//Assign programs to role
  Future assignProgramToRole(
      {required String token,
      required String createdby,
      required String roleid,
      required List<AllPrograms> programs}) async {
    try {
      Map<String, dynamic> payload = {
        'createdby': createdby,
        'roleid': roleid,
        'programs': List<Map<String, String>>.from(
            programs.map((program) => {'id': program.id.toString()})),
      };

      if (payload.isNotEmpty) {
        http.Response response = await API()
            .postApiResponse(AppUrl.assignProgramsToRole, token, payload);
        if (response.body.toString() == 'Inserted successfully') {
          return 'Inserted successfully';
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// Programs not in folder
  Future programsNotInFolder({required String token}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (headers.isNotEmpty) {
        http.Response response =
            await API().getApiResponse(AppUrl.programsNotInFolder, headers);
        if (response.body.toString() == 'Server unreachable') {
          return 'Server unreachable';
        } else {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((e) => ProgramsNotInFolder.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Delete role
  Future<String> deleteRole(
      {required String token, required Map<String, String> payload}) async {
    try {
      http.Response response = await API().deleteApiResponse(
          url: AppUrl.deleteRoleUrl, token: token, payload: payload);
      if (response.body == 'Deleted successfully') {
        return 'Deleted successfully';
      } else {
        return response.body.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete program
  Future<String> deleteProgram(
      {required String token, required Map<String, String> payload}) async {
    try {
      http.Response response = await API().deleteApiResponse(
          url: AppUrl.deleteProgramUrl, token: token, payload: payload);
      if (response.body == 'Deleted successfully') {
        return 'Deleted successfully';
      } else {
        return response.body.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete folder
  Future<String> deleteFolder(
      {required String token, required Map<String, String> payload}) async {
    try {
      http.Response response = await API().deleteApiResponse(
          url: AppUrl.deleteFolderUrl, token: token, payload: payload);
      if (response.body == 'Deleted successfully') {
        return 'Deleted successfully';
      } else {
        return response.body.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete programs in folder
  Future<String> deleteProgramsInFolder(
      {required String token, required Map<String, String> payload}) async {
    try {
      http.Response response = await API().deleteApiResponse(
          url: AppUrl.deleteProgramsInFolderUrl,
          token: token,
          payload: payload);
      if (response.body == 'Deleted successfully') {
        return 'Deleted successfully';
      } else {
        return response.body.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }
}
