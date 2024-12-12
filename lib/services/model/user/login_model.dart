// Author : Shital Gayakwad
// Created Date : 24 Feb 2023
// Description : ERPX_PPC -> Auth_view_model

class UserLoginModel {
  String? token;
  List<UserDataModel>? data;

  UserLoginModel({this.token, this.data});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['data'] != null) {
      data = <UserDataModel>[];
      json['data'].forEach((v) {
        data!.add(UserDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDataModel {
  String? id;
  String? employeeId;
  String? employeetypeId;
  String? employeeTypeDescription;
  String? employeeTypeCode;
  String? employeedepartmentId;
  String? employeeDepartmentDescription;
  String? employeeDepartmentCode;
  String? employeedesignationId;
  String? employeeDesignationDescription;
  String? birthdate;
  String? honorific;
  String? lastname;
  String? firstname;
  String? middlename;
  String? currentaddress1;
  String? currentaddress2;
  String? currentcityId;
  String? currentCityName;
  int? currentpin;
  String? currentstate;
  String? currentStateName;
  String? permanentaddress1;
  String? permanentaddress2;
  String? permanentcityId;
  String? permanentCityName;
  int? permanentpin;
  String? permanentstate;
  String? permanentStateName;
  String? qualification;
  String? dateofjoining;
  String? dateofleaving;
  String? epfnumber;
  String? fpfnumber;
  String? pannumber;
  String? aadharnumber;
  String? bankaccountnumber;
  String? bankname;
  String? bankifsccode;
  String? email;
  String? phonenumber;
  String? mobile;
  String? companyId;
  String? companyName;
  String? nextofkinname;
  String? nextofkinaddress;
  String? nextofkinemail;
  String? nextofkinphone;
  String? nextofkinrelationwithemployee;
  String? empprofilemdocid;
  String? adharcardmdocid;
  String? pancardmdocid;
  String? employeeusername;
  String? employeeuserpassword;

  UserDataModel(
      {this.id,
      this.employeeId,
      this.employeetypeId,
      this.employeeTypeDescription,
      this.employeeTypeCode,
      this.employeedepartmentId,
      this.employeeDepartmentDescription,
      this.employeeDepartmentCode,
      this.employeedesignationId,
      this.employeeDesignationDescription,
      this.birthdate,
      this.honorific,
      this.lastname,
      this.firstname,
      this.middlename,
      this.currentaddress1,
      this.currentaddress2,
      this.currentcityId,
      this.currentCityName,
      this.currentpin,
      this.currentstate,
      this.currentStateName,
      this.permanentaddress1,
      this.permanentaddress2,
      this.permanentcityId,
      this.permanentCityName,
      this.permanentpin,
      this.permanentstate,
      this.permanentStateName,
      this.qualification,
      this.dateofjoining,
      this.dateofleaving,
      this.epfnumber,
      this.fpfnumber,
      this.pannumber,
      this.aadharnumber,
      this.bankaccountnumber,
      this.bankname,
      this.bankifsccode,
      this.email,
      this.phonenumber,
      this.mobile,
      this.companyId,
      this.companyName,
      this.nextofkinname,
      this.nextofkinaddress,
      this.nextofkinemail,
      this.nextofkinphone,
      this.nextofkinrelationwithemployee,
      this.empprofilemdocid,
      this.adharcardmdocid,
      this.pancardmdocid,
      this.employeeusername,
      this.employeeuserpassword});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    employeetypeId = json['employeetype_id'];
    employeeTypeDescription = json['employee_type_description'];
    employeeTypeCode = json['employee_type_code'];
    employeedepartmentId = json['employeedepartment_id'];
    employeeDepartmentDescription = json['employee_department_description'];
    employeeDepartmentCode = json['employee_department_code'];
    employeedesignationId = json['employeedesignation_id'];
    employeeDesignationDescription = json['employee_designation_description'];
    birthdate = json['birthdate'];
    honorific = json['honorific'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    currentaddress1 = json['currentaddress1'];
    currentaddress2 = json['currentaddress2'];
    currentcityId = json['currentcity_id'];
    currentCityName = json['current_city_name'];
    currentpin = json['currentpin'];
    currentstate = json['currentstate'];
    currentStateName = json['current_state_name'];
    permanentaddress1 = json['permanentaddress1'];
    permanentaddress2 = json['permanentaddress2'];
    permanentcityId = json['permanentcity_id'];
    permanentCityName = json['permanent_city_name'];
    permanentpin = json['permanentpin'];
    permanentstate = json['permanentstate'];
    permanentStateName = json['permanent_state_name'];
    qualification = json['qualification'];
    dateofjoining = json['dateofjoining'];
    dateofleaving = json['dateofleaving'];
    epfnumber = json['epfnumber'];
    fpfnumber = json['fpfnumber'];
    pannumber = json['pannumber'];
    aadharnumber = json['aadharnumber'];
    bankaccountnumber = json['bankaccountnumber'];
    bankname = json['bankname'];
    bankifsccode = json['bankifsccode'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    mobile = json['mobile'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    nextofkinname = json['nextofkinname'];
    nextofkinaddress = json['nextofkinaddress'];
    nextofkinemail = json['nextofkinemail'];
    nextofkinphone = json['nextofkinphone'];
    nextofkinrelationwithemployee = json['nextofkinrelationwithemployee'];
    empprofilemdocid = json['empprofilemdocid'];
    adharcardmdocid = json['adharcardmdocid'];
    pancardmdocid = json['pancardmdocid'];
    employeeusername = json['employeeusername'];
    employeeuserpassword = json['employeeuserpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['employeetype_id'] = employeetypeId;
    data['employee_type_description'] = employeeTypeDescription;
    data['employee_type_code'] = employeeTypeCode;
    data['employeedepartment_id'] = employeedepartmentId;
    data['employee_department_description'] = employeeDepartmentDescription;
    data['employee_department_code'] = employeeDepartmentCode;
    data['employeedesignation_id'] = employeedesignationId;
    data['employee_designation_description'] = employeeDesignationDescription;
    data['birthdate'] = birthdate;
    data['honorific'] = honorific;
    data['lastname'] = lastname;
    data['firstname'] = firstname;
    data['middlename'] = middlename;
    data['currentaddress1'] = currentaddress1;
    data['currentaddress2'] = currentaddress2;
    data['currentcity_id'] = currentcityId;
    data['current_city_name'] = currentCityName;
    data['currentpin'] = currentpin;
    data['currentstate'] = currentstate;
    data['current_state_name'] = currentStateName;
    data['permanentaddress1'] = permanentaddress1;
    data['permanentaddress2'] = permanentaddress2;
    data['permanentcity_id'] = permanentcityId;
    data['permanent_city_name'] = permanentCityName;
    data['permanentpin'] = permanentpin;
    data['permanentstate'] = permanentstate;
    data['permanent_state_name'] = permanentStateName;
    data['qualification'] = qualification;
    data['dateofjoining'] = dateofjoining;
    data['dateofleaving'] = dateofleaving;
    data['epfnumber'] = epfnumber;
    data['fpfnumber'] = fpfnumber;
    data['pannumber'] = pannumber;
    data['aadharnumber'] = aadharnumber;
    data['bankaccountnumber'] = bankaccountnumber;
    data['bankname'] = bankname;
    data['bankifsccode'] = bankifsccode;
    data['email'] = email;
    data['phonenumber'] = phonenumber;
    data['mobile'] = mobile;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['nextofkinname'] = nextofkinname;
    data['nextofkinaddress'] = nextofkinaddress;
    data['nextofkinemail'] = nextofkinemail;
    data['nextofkinphone'] = nextofkinphone;
    data['nextofkinrelationwithemployee'] = nextofkinrelationwithemployee;
    data['empprofilemdocid'] = empprofilemdocid;
    data['adharcardmdocid'] = adharcardmdocid;
    data['pancardmdocid'] = pancardmdocid;
    data['employeeusername'] = employeeusername;
    data['employeeuserpassword'] = employeeuserpassword;
    return data;
  }
}

// class UserLoginModel {
//   String? token;
//   List<UserDataModel>? data;

//   UserLoginModel({this.token, this.data});

//   UserLoginModel.fromJson(Map<String, dynamic> json) {
//     token = json['token'];
//     if (json['data'] != null) {
//       data = <UserDataModel>[];
//       json['data'].forEach((v) {
//         data!.add(UserDataModel.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['token'] = token;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class UserDataModel {
//   String? id,
//       code,
//       employeetypeId,
//       employeedepartmentId,
//       employeedesignationId,
//       birthdate,
//       honorific,
//       lastname,
//       firstname,
//       middlename,
//       currentaddress1,
//       currentaddress2,
//       currentcityId,
//       currentstate,
//       permanentaddress1,
//       permanentaddress2,
//       permanentcityId,
//       permanentstate,
//       qualification,
//       dateofjoining,
//       epfnumber,
//       fpfnumber,
//       pannumber,
//       aadharnumber,
//       bankaccountnumber,
//       bankname,
//       email,
//       phonenumber,
//       mobile,
//       companyId,
//       nextofkinname,
//       bankifsccode,
//       nextofkinaddress,
//       nextofkinemail,
//       nextofkinphone,
//       nextofkinrelationwithemployee,
//       empprofilemdocid,
//       adharcardmdocid,
//       pancardmdocid,
//       employeeusername;
//   int? currentpin, permanentpin;
//   DateTime? dateofleaving;

//   UserDataModel(
//       {this.id,
//       this.code,
//       this.employeetypeId,
//       this.employeedepartmentId,
//       this.employeedesignationId,
//       this.birthdate,
//       this.honorific,
//       this.lastname,
//       this.firstname,
//       this.middlename,
//       this.currentaddress1,
//       this.currentaddress2,
//       this.currentcityId,
//       this.currentpin,
//       this.currentstate,
//       this.permanentaddress1,
//       this.permanentaddress2,
//       this.permanentcityId,
//       this.permanentpin,
//       this.permanentstate,
//       this.qualification,
//       this.dateofjoining,
//       this.dateofleaving,
//       this.epfnumber,
//       this.fpfnumber,
//       this.pannumber,
//       this.aadharnumber,
//       this.bankaccountnumber,
//       this.bankname,
//       this.email,
//       this.phonenumber,
//       this.mobile,
//       this.companyId,
//       this.nextofkinname,
//       this.bankifsccode,
//       this.nextofkinaddress,
//       this.nextofkinemail,
//       this.nextofkinphone,
//       this.nextofkinrelationwithemployee,
//       this.empprofilemdocid,
//       this.adharcardmdocid,
//       this.pancardmdocid,
//       this.employeeusername});

//   UserDataModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     code = json['code'];
//     employeetypeId = json['employeetype_id'];
//     employeedepartmentId = json['employeedepartment_id'];
//     employeedesignationId = json['employeedesignation_id'];
//     birthdate = json['birthdate'];
//     honorific = json['honorific'];
//     lastname = json['lastname'];
//     firstname = json['firstname'];
//     middlename = json['middlename'];
//     currentaddress1 = json['currentaddress1'];
//     currentaddress2 = json['currentaddress2'];
//     currentcityId = json['currentcity_id'];
//     currentpin = json['currentpin'];
//     currentstate = json['currentstate'];
//     permanentaddress1 = json['permanentaddress1'];
//     permanentaddress2 = json['permanentaddress2'];
//     permanentcityId = json['permanentcity_id'];
//     permanentpin = json['permanentpin'];
//     permanentstate = json['permanentstate'];
//     qualification = json['qualification'];
//     dateofjoining = json['dateofjoining'];
//     dateofleaving = json['dateofleaving'];
//     epfnumber = json['epfnumber'];
//     fpfnumber = json['fpfnumber'];
//     pannumber = json['pannumber'];
//     aadharnumber = json['aadharnumber'];
//     bankaccountnumber = json['bankaccountnumber'];
//     bankname = json['bankname'];
//     email = json['email'];
//     phonenumber = json['phonenumber'];
//     mobile = json['mobile'];
//     companyId = json['company_id'];
//     nextofkinname = json['nextofkinname'];
//     bankifsccode = json['bankifsccode'];
//     nextofkinaddress = json['nextofkinaddress'];
//     nextofkinemail = json['nextofkinemail'];
//     nextofkinphone = json['nextofkinphone'];
//     nextofkinrelationwithemployee = json['nextofkinrelationwithemployee'];
//     empprofilemdocid = json['empprofilemdocid'];
//     adharcardmdocid = json['adharcardmdocid'];
//     pancardmdocid = json['pancardmdocid'];
//     employeeusername = json['employeeusername'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['code'] = code;
//     data['employeetype_id'] = employeetypeId;
//     data['employeedepartment_id'] = employeedepartmentId;
//     data['employeedesignation_id'] = employeedesignationId;
//     data['birthdate'] = birthdate;
//     data['honorific'] = honorific;
//     data['lastname'] = lastname;
//     data['firstname'] = firstname;
//     data['middlename'] = middlename;
//     data['currentaddress1'] = currentaddress1;
//     data['currentaddress2'] = currentaddress2;
//     data['currentcity_id'] = currentcityId;
//     data['currentpin'] = currentpin;
//     data['currentstate'] = currentstate;
//     data['permanentaddress1'] = permanentaddress1;
//     data['permanentaddress2'] = permanentaddress2;
//     data['permanentcity_id'] = permanentcityId;
//     data['permanentpin'] = permanentpin;
//     data['permanentstate'] = permanentstate;
//     data['qualification'] = qualification;
//     data['dateofjoining'] = dateofjoining;
//     data['dateofleaving'] = dateofleaving;
//     data['epfnumber'] = epfnumber;
//     data['fpfnumber'] = fpfnumber;
//     data['pannumber'] = pannumber;
//     data['aadharnumber'] = aadharnumber;
//     data['bankaccountnumber'] = bankaccountnumber;
//     data['bankname'] = bankname;
//     data['email'] = email;
//     data['phonenumber'] = phonenumber;
//     data['mobile'] = mobile;
//     data['company_id'] = companyId;
//     data['nextofkinname'] = nextofkinname;
//     data['bankifsccode'] = bankifsccode;
//     data['nextofkinaddress'] = nextofkinaddress;
//     data['nextofkinemail'] = nextofkinemail;
//     data['nextofkinphone'] = nextofkinphone;
//     data['nextofkinrelationwithemployee'] = nextofkinrelationwithemployee;
//     data['empprofilemdocid'] = empprofilemdocid;
//     data['adharcardmdocid'] = adharcardmdocid;
//     data['pancardmdocid'] = pancardmdocid;
//     data['employeeusername'] = employeeusername;
//     return data;
//   }
// }
