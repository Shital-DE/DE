// Author : Shital Gayakwad
// Created Date : 27 May 2023
// Description : ERPX_PPC -> User model
// Modified data :
class EmployeeName {
  String? id;
  String? employeename;
  String? mobile;
  String? employeeusername;
  String? employeeuserpassword;

  EmployeeName(
      {this.id,
      this.employeename,
      this.mobile,
      this.employeeusername,
      this.employeeuserpassword});

  EmployeeName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeename = json['employeename'];
    mobile = json['mobile'];
    employeeusername = json['employeeusername'];
    employeeuserpassword = json['employeeuserpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeename'] = employeename;
    data['mobile'] = mobile;
    data['employeeusername'] = employeeusername;
    data['employeeuserpassword'] = employeeuserpassword;
    return data;
  }
}

class EmployeeRole {
  String? id;
  String? rolename;

  EmployeeRole({this.id, this.rolename});

  EmployeeRole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rolename = json['rolename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rolename'] = rolename;
    return data;
  }
}

class AllUsers {
  String? id;
  String? username;

  AllUsers({this.id, this.username});

  AllUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    return data;
  }
}

class AllPrograms {
  String? id;
  String? programname;

  AllPrograms({this.id, this.programname});

  AllPrograms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programname = json['programname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['programname'] = programname;
    return data;
  }
}

class AllFolders {
  String? id;
  String? foldername;

  AllFolders({this.id, this.foldername});

  AllFolders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foldername = json['foldername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['foldername'] = foldername;
    return data;
  }
}

class ProgramsInFolder {
  String? foldername;
  List<String>? programNames;
  List<String>? programIds;

  ProgramsInFolder({this.foldername, this.programNames, this.programIds});

  ProgramsInFolder.fromJson(Map<String, dynamic> json) {
    foldername = json['foldername'];
    programNames = json['program_names'].cast<String>();
    programIds = json['program_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foldername'] = foldername;
    data['program_names'] = programNames;
    data['program_ids'] = programIds;
    return data;
  }
}

class ProgramsAssignedToRole {
  String? rolename;
  List<String>? programNames;
  List<String>? programIds;

  ProgramsAssignedToRole({this.rolename, this.programNames, this.programIds});

  ProgramsAssignedToRole.fromJson(Map<String, dynamic> json) {
    rolename = json['rolename'];
    programNames = json['program_names'].cast<String>();
    programIds = json['program_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rolename'] = rolename;
    data['program_names'] = programNames;
    data['program_ids'] = programIds;
    return data;
  }
}

class ProgramsNotInFolder {
  String? id;
  String? programname;

  ProgramsNotInFolder({this.id, this.programname});

  ProgramsNotInFolder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programname = json['programname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['programname'] = programname;
    return data;
  }
}
