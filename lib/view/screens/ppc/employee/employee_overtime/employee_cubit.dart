// import 'package:bloc/bloc.dart';
// import 'package:de_opc/services/repository/employee/employee_repository.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// import '../../../../../services/model/employee/employee_model.dart';
// import '../../../../../services/session/user_login.dart';
// // import '../../../../../utils/common/quickfix_widget.dart';
// part 'employee_state.dart';

// class EmployeeCubit extends Cubit<EmployeeState> {
//   EmployeeCubit()
//       : super(const OperatorLoadList(
//             operator: [],
//             empovertimews: [],
//             employeeid: '',
//             wsid: '',
//             empovertimedata: [],
//             token: '',
//             soid: '',
//             polist: [],
//             productlist: []));

//   Future<void> getOperatorList(
//       {required String empid, required String soid}) async {
//     String token = '';

//     ///loginid = '';
//     List<EmployeeOvertimedata> empovertimedata = [];
//     List<Productlist> productlist = [];
//     List<EmpOvertimeWorkstation> empovertimews = [];
//     final saveddata = await UserData.getUserData();
//     token = saveddata['token'].toString();
//     // for (var userdata in saveddata['data']) {
//     //   loginid = userdata['id'];
//     // }
//     try {
//       List<Employee> operatorList = await EmployeeRepository.operatorList();
//       List<Polist> polist = await EmployeeRepository.polist(token: token);
//       empovertimews = await EmployeeRepository.workstationList();

//       if (empid != '') {
//         empovertimedata = await EmployeeRepository.empOvertimedata(
//             empid: empid.toString(), token: token);
//       }

//       emit(OperatorLoadList(
//           operator: operatorList,
//           empovertimews: empovertimews,
//           employeeid: '',
//           wsid: '',
//           empovertimedata: empovertimedata,
//           token: token,
//           soid: '',
//           polist: polist,
//           productlist: productlist));
//     } catch (e) {
//       //
//     }
//   }

//   Future<void> saveDData({
//     required String empid,
//     required String wsid,
//     required String startddate,
//     required String starttime,
//     required String endddate,
//     required String endttime,
//     required String updatedendDateTime,
//   }) async {
//     String token = ''; //, loginid = '';

//     final saveddata = await UserData.getUserData();
//     token = saveddata['token'].toString();
//     // for (var userdata in saveddata['data']) {
//     //   loginid = userdata['id'];
//     // }

//     if (empid != '') {
//       try {
//         List<Employee> operatorList = await EmployeeRepository.operatorList();

//         List<EmpOvertimeWorkstation> empovertimews =
//             await EmployeeRepository.workstationList();

//         List<EmployeeOvertimedata> empovertimedata =
//             await EmployeeRepository.empOvertimedata(
//                 empid: empid, token: token);

//         emit(OperatorLoadList(
//             operator: operatorList,
//             empovertimews: empovertimews,
//             employeeid: empid,
//             wsid: wsid,
//             empovertimedata: empovertimedata,
//             token: token,
//             soid: '',
//             polist: state.polist,
//             productlist: state.productlist));
//       } catch (e) {
//         //
//       }
//     }
//   }

//   Future<void> productlist({
//     required String empid,
//     required String soid,
//   }) async {
//     String token = '';
//     List<Productlist> productlist = [];
//     final saveddata = await UserData.getUserData();
//     token = saveddata['token'].toString();
//     if (soid != '') {
//       try {
//         productlist = await EmployeeRepository.productlistfromsoid(
//             token: token, soid: soid);
//         emit(OperatorLoadList(
//             operator: state.operator,
//             empovertimews: state.empovertimews,
//             employeeid: empid,
//             wsid: state.wsid,
//             empovertimedata: state.empovertimedata,
//             token: token,
//             soid: '',
//             polist: state.polist,
//             productlist: productlist));
//       } catch (e) {
//         //
//       }
//     }
//   }

//   Future<void> overtimeInsertData(
//       {required String loginid,
//       required String empid,
//       required String wsid,
//       required String poid,
//       required String productid,
//       required String remark,
//       required String starttime,
//       required String endtime,
//       required String token,
//       required BuildContext context}) async {
//     String token = '', loginid = '';
//     List<EmployeeOvertimedata> empovertimedata = [];
//     final saveddata = await UserData.getUserData();
//     token = saveddata['token'].toString();

//     for (var userdata in saveddata['data']) {
//       loginid = userdata['id'];
//     }

//     if (empid != '') {
//       try {
//         List<Employee> operatorList = await EmployeeRepository.operatorList();

//         List<EmpOvertimeWorkstation> empovertimews =
//             await EmployeeRepository.workstationList();

//         await EmployeeRepository.sendEmpOvertimeData(
//           loginid: loginid,
//           empid: empid,
//           wsid: wsid,
//           starttime: starttime,
//           endtime: endtime,
//           token: token,
//           poid: poid,
//           productid: productid,
//           remark: remark,
//         );

//         empovertimedata = await EmployeeRepository.empOvertimedata(
//             empid: empid, token: token);

//         emit(OperatorLoadList(
//             operator: operatorList,
//             empovertimews: empovertimews,
//             employeeid: empid,
//             wsid: wsid,
//             empovertimedata: empovertimedata,
//             token: token,
//             soid: '',
//             polist: state.polist,
//             productlist: state.productlist));
//       } catch (e) {
//         //
//       }
//     }
//   }

//   Future<void> overtimeUpdateData(
//       {required String id,
//       required String empid,
//       required String wsid,
//       required String endtime,
//       required String token,
//       required BuildContext context}) async {
//     String token = ''; //, loginid = '';
//     List<EmployeeOvertimedata> empovertimedata = [];

//     final saveddata = await UserData.getUserData();
//     token = saveddata['token'].toString();
//     // for (var userdata in saveddata['data']) {
//     //   loginid = userdata['id'];
//     // }
//     if (empid != '') {
//       try {
//         List<Employee> operatorList = await EmployeeRepository.operatorList();

//         List<EmpOvertimeWorkstation> empovertimews =
//             await EmployeeRepository.workstationList();

//         await EmployeeRepository.updateEmpOvertimeData(
//           id: id,
//           empid: empid,
//           endtime: endtime,
//           token: token,
//         );

//         empovertimedata = await EmployeeRepository.empOvertimedata(
//             empid: empid, token: token);
            
//         emit(OperatorLoadList(
//             operator: operatorList,
//             empovertimews: empovertimews,
//             employeeid: empid,
//             wsid: wsid,
//             empovertimedata: empovertimedata,
//             token: token,
//             soid: '',
//             polist: state.polist,
//             productlist: state.productlist));
//       } catch (e) {
//         //
//       }
//     }
//   }

//   Future<void> resetSelectedValues(
//       {required String empid, required String token}) async {
//     List<Employee> operatorList = await EmployeeRepository.operatorList();
//     List<EmployeeOvertimedata> empovertimedata = [];
//     empovertimedata = await EmployeeRepository.empOvertimedata(
//         empid: empid.toString(), token: token);

//     emit(OperatorInitial(
//         operator: operatorList,
//         empovertimews: const [],
//         employeeid: empid,
//         wsid: '',
//         empovertimedata: empovertimedata,
//         token: token,
//         soid: '',
//         polist: const [],
//         productlist: const [])); // Emit a new state with cleared selections
//   }

//   resetSelectedValues2() async {
//     // List<Employee> operatorList = await EmployeeRepository.operatorList();
//     // List<EmployeeOvertimedata> empovertimedata = [];
//     // empovertimedata = await EmployeeRepository.empOvertimedata(
//     //     empid: empid.toString(), token: token);

//     emit(const OperatorInitial(
//         operator: [],
//         empovertimews: [],
//         employeeid: '',
//         wsid: '',
//         empovertimedata: [],
//         token: '',
//         soid: '',
//         polist: [],
//         productlist: []));

//     emit(const OperatorLoadList(
//         operator: [],
//         empovertimews: [],
//         employeeid: '',
//         wsid: '',
//         empovertimedata: [],
//         token: '',
//         soid: '',
//         polist: [],
//         productlist: [])); // Emit a new state with cleared selections
//   }
// }
