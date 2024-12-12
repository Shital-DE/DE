// Author : Shital Gayakwad
// Created Date : 28 May 2024
// Description : Program access management
class ProgramAccessManagementModel {
  String? rolename;
  List<UserInfo>? userInfo;
  List<FolderInfo>? folderInfo;
  String? aclroleid;

  ProgramAccessManagementModel(
      {this.rolename, this.userInfo, this.folderInfo, this.aclroleid});

  ProgramAccessManagementModel.fromJson(Map<String, dynamic> json) {
    rolename = json['rolename'];
    if (json['user_info'] != null) {
      userInfo = <UserInfo>[];
      json['user_info'].forEach((v) {
        userInfo!.add(UserInfo.fromJson(v));
      });
    }
    if (json['folder_info'] != null) {
      folderInfo = <FolderInfo>[];
      json['folder_info'].forEach((v) {
        folderInfo!.add(FolderInfo.fromJson(v));
      });
    }
    aclroleid = json['aclroleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rolename'] = rolename;
    if (userInfo != null) {
      data['user_info'] = userInfo!.map((v) => v.toJson()).toList();
    }
    if (folderInfo != null) {
      data['folder_info'] = folderInfo!.map((v) => v.toJson()).toList();
    }
    data['aclroleid'] = aclroleid;
    return data;
  }
}

class UserInfo {
  String? userId;
  String? userName;
  String? userRoleId;
  String? employeeName;

  UserInfo({this.userId, this.userName, this.userRoleId, this.employeeName});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userRoleId = json['user_role_id'];
    employeeName = json['employee_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_role_id'] = userRoleId;
    data['employee_name'] = employeeName;
    return data;
  }
}

class FolderInfo {
  String? folderId;
  String? foldername;
  List<ProgramsInFolder>? programsInFolder;

  FolderInfo({this.folderId, this.foldername, this.programsInFolder});

  FolderInfo.fromJson(Map<String, dynamic> json) {
    folderId = json['folder_id'];
    foldername = json['foldername'];
    if (json['programs_in_folder'] != null) {
      programsInFolder = <ProgramsInFolder>[];
      json['programs_in_folder'].forEach((v) {
        programsInFolder!.add(ProgramsInFolder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['folder_id'] = folderId;
    data['foldername'] = foldername;
    if (programsInFolder != null) {
      data['programs_in_folder'] =
          programsInFolder!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProgramsInFolder {
  String? programId;
  String? programname;
  String? programRoleId;
  String? folderProgramId;

  ProgramsInFolder(
      {this.programId,
      this.programname,
      this.programRoleId,
      this.folderProgramId});

  ProgramsInFolder.fromJson(Map<String, dynamic> json) {
    programId = json['program_id'];
    programname = json['programname'];
    programRoleId = json['program_role_id'];
    folderProgramId = json['folder_program_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['program_id'] = programId;
    data['programname'] = programname;
    data['program_role_id'] = programRoleId;
    data['folder_program_id'] = folderProgramId;
    return data;
  }
}
