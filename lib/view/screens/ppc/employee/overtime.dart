// // ignore_for_file: use_build_context_synchronously

// import 'package:de_opc/utils/common/quickfix_widget.dart';
// import 'package:de_opc/utils/responsive.dart';
// import 'package:de_opc/view/widgets/custom_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../services/model/employee/employee_model.dart';
// import '../../../../services/repository/employee/employee_repository.dart';
// import '../../../../services/session/user_login.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/constant.dart';
// import '../../../widgets/appbar.dart';
// import 'employeeOvertime/employee_cubit.dart';
// import 'dart:io';

// class OperatorOverTime extends StatelessWidget {
//   const OperatorOverTime({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TimeOfDay? selectedstartTime = TimeOfDay.now();
//     TimeOfDay? selectedendTime = TimeOfDay.now();
//     TimeOfDay? UpdatedselectedendTime = TimeOfDay.now();

//     TextEditingController startpickDate = TextEditingController();
//     TextEditingController endpickDate = TextEditingController();
//     TextEditingController starttime = TextEditingController();
//     TextEditingController endtime = TextEditingController();

//     TextEditingController updatedEndDate = TextEditingController();
//     TextEditingController updatedEndTime = TextEditingController();
//     TextEditingController updatedEndDateTime = TextEditingController();
//     TextEditingController remarkcontroller = TextEditingController();

//     debugPrint("123456789--");
//     String employeeid = '',
//         wsid = '',
//         loginid = '',
//         token = '',
//         soid = '',
//         productid = '',
//         ponumber = '',
//         productcode = '';
//     DateTime? dt1, dt2;
//     String? Dt1, Dt2;
//     DateTime? fenddate;
//     int serialNumber = 1;
//     String oldvalue = '';

//     List<TextEditingController> rowControllers = [];
//     BlocProvider.of<EmployeeCubit>(context)
//         .getOperatorList(empid: '', soid: '');
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar:
//           CustomAppbar().appbar(context: context, title: 'Opertor Overtime'),
//       body: MakeMeResponsiveScreen(
//         horixontaltab: Padding(
//           padding: const EdgeInsets.all(23.0),
//           child: BlocBuilder<EmployeeCubit, EmployeeState>(
//             builder: (context, state) {
//               if (state is OperatorLoadList) {
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     children: [
//                       /* Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // BlocBuilder<OperatorCubit, EmployeeState>(
//                             //   builder: (context, state) {
//                             // if (state is OperatorLoadList) {
//                             //   return
//                             Container(
//                               width: 300,
//                               child: CustomDropdownSearch(
//                                   items: state.operator,
//                                   itemAsString: (s) => s.employeename!,
//                                   onChanged: (s) {
//                                     employeeid = s!.id!;
//                                     // BlocProvider.of<OperatorCubit>(context)
//                                     //     .saveDData(
//                                     //   empid: employeeid,
//                                     //   wsid: wsid,
//                                     //   startddate: startpickDate.text,
//                                     //   starttime: starttime.text,
//                                     //   endddate: endpickDate.text,
//                                     //   endttime: endtime.text,
//                                     //   updatedendDateTime:
//                                     //       updatedEndDateTime.text,
//                                     // );
//                                   },
//                                   hintText: "Select Employee"),
//                             ),
//                             // } else {
//                             //   return const Stack();
//                             // }
//                             //   },
//                             // ),
//                             const SizedBox(
//                               width: 28,
//                             ),
//                             // BlocBuilder<OperatorCubit, EmployeeState>(
//                             //   builder: (context, state) {
//                             //     return
//                             Container(
//                               width: 300,
//                               child: CustomDropdownSearch(
//                                   items: state.empovertimews,
//                                   itemAsString: (s) => s.ws!,
//                                   onChanged: (s) {
//                                     // if (state is OperatorLoadList) {
//                                     if (employeeid != '') {
//                                       wsid = s!.id!;
//                                     } else {
//                                       showDialog(
//                                         barrierDismissible: false,
//                                         barrierColor: Theme.of(context)
//                                             .colorScheme
//                                             .background,
//                                         context: context,
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             content: const Text(
//                                               "Please select Employee...!",
//                                               style: TextStyle(
//                                                 color: Color.fromARGB(
//                                                     255, 25, 25, 26),
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 19,
//                                               ),
//                                             ),
//                                             actions: [
//                                               FilledButton(
//                                                   child:
//                                                       const Text('Go back'),
//                                                   onPressed: () {
//                                                     wsid = '';
//                                                     Navigator.of(context)
//                                                         .pop();
//                                                   })
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     }
//                                     // }
//                                   },
//                                   hintText: "Select workstation"),
//                             ),
//                             //   },
//                             // ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 46,
//                       ),*/
//                       Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // BlocBuilder<OperatorCubit, EmployeeState>(
//                             //   builder: (context, state) {
//                             //     if (state is OperatorLoadList) {

//                             //       return
//                             Container(
//                               width: 300,
//                               child: CustomDropdownSearch(
//                                   items: state.polist,
//                                   itemAsString: (s) => s.ponumber!,
//                                   onChanged: (s) {
//                                     soid = s!.id!;
//                                     ponumber = s.ponumber!;
//                                     //  oldvalue = "check this message";
//                                     remarkcontroller.text =
//                                         "PO-${ponumber.toString().trim()} ";
//                                     // BlocProvider.of<OperatorCubit>(context)
//                                     //     .productlist(
//                                     //         empid: employeeid,
//                                     //         soid: soid.toString().trim()
//                                     //         // empid: employeeid,
//                                     //         // wsid: wsid,
//                                     //         // startddate: startpickDate.text,
//                                     //         // starttime: starttime.text,
//                                     //         // endddate: endpickDate.text,
//                                     //         // endttime: endtime.text,
//                                     //         // updatedendDateTime:
//                                     //         //     updatedEndDateTime.text,
//                                     //         );
//                                   },
//                                   hintText: "Select Po"),
//                             ),
//                             //     } else {
//                             //       return const Stack();
//                             //     }
//                             //   },
//                             // ),
//                             const SizedBox(
//                               width: 28,
//                             ),
//                             // BlocBuilder<OperatorCubit, EmployeeState>(
//                             //   builder: (context, state) {
//                             //     return
//                             // Container(
//                             //   width: 300,
//                             //   child: CustomDropdownSearch(
//                             //       items: state.productlist,
//                             //       itemAsString: (s) => s.productcode!,
//                             //       onChanged: (s) {
//                             //         //  if (state is OperatorLoadList) {
//                             //         if (soid != '') {
//                             //           productid = s!.id!;
//                             //           productcode = s.productcode!;
//                             //           // remarkcontroller.text =
//                             //           //     "${remarkcontroller.text} Product-${productcode.toString()}";
//                             //           oldvalue = "check this message";
//                             //         } else {
//                             //           showDialog(
//                             //             barrierDismissible: false,
//                             //             barrierColor: Theme.of(context)
//                             //                 .colorScheme
//                             //                 .background,
//                             //             context: context,
//                             //             builder: (context) {
//                             //               return AlertDialog(
//                             //                 content: const Text(
//                             //                   "Please select PO...!",
//                             //                   style: TextStyle(
//                             //                     color: Color.fromARGB(
//                             //                         255, 25, 25, 26),
//                             //                     fontWeight: FontWeight.bold,
//                             //                     fontSize: 19,
//                             //                   ),
//                             //                 ),
//                             //                 actions: [
//                             //                   FilledButton(
//                             //                       child:
//                             //                           const Text('Go back'),
//                             //                       onPressed: () {
//                             //                         productid = '';
//                             //                         Navigator.of(context)
//                             //                             .pop();
//                             //                       })
//                             //                 ],
//                             //               );
//                             //             },
//                             //           );
//                             //         }
//                             //         // }
//                             //       },
//                             //       hintText: "Select productcode"),
//                             // ),
//                             //   },
//                             // ),
//                             const SizedBox(
//                               width: 46,
//                             ),

//                             // Container(
//                             //     width: 500,
//                             //     child: TextField(
//                             //       controller: remarkcontroller,
//                             //       // decoration: const InputDecoration(
//                             //       //   border: OutlineInputBorder(),
//                             //       //   //  hintText: 'Enter a search term',
//                             //       // ),
//                             //       onTap: () {
//                             //         String dd = remarkcontroller.text;
//                             //         remarkcontroller.text = dd;
//                             //         // remarkcontroller.text =
//                             //         //     remarkcontroller.text;
//                             //         debugPrint(remarkcontroller.text);
//                             //       },
//                             //       onChanged: (value) {
//                             //         // remarkcontroller.text = oldvalue;
//                             //         remarkcontroller.text = value;
//                             //       },
//                             //     )),
//                             SizedBox(
//                               width: 550,
//                               child: Padding(
//                                 padding: EdgeInsets.all(15),
//                                 child: TextField(
//                                   onTap: () {
//                                     remarkcontroller.text =
//                                         remarkcontroller.text;
//                                   },
//                                   onChanged: (value) {
//                                     debugDumpRenderTree();
//                                     // remarkcontroller.text = remarkcontroller.text;
//                                     remarkcontroller.text = value;
//                                   },
//                                   decoration: const InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     //labelText: 'Remark',
//                                     hintText: 'Remark',
//                                   ),
//                                   controller: remarkcontroller,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 46,
//                       ),
//                       /*  SizedBox(
//                         //  width: 630,
//                         child: TextField(
//                           // readOnly: false,
//                           controller: remarkcontroller,
//                           // decoration: const InputDecoration(
//                           //   border: InputBorder.none,
//                           //   enabledBorder: OutlineInputBorder(),
//                           //   focusedBorder: OutlineInputBorder(),
//                           // ),
//                           // onTap: () {
//                           //   remarkcontroller.text = remarkcontroller.text;
//                           //   debugPrint("00000000000000000000-->");
//                           //   debugPrint(remarkcontroller.text);
//                           // },
//                           onChanged: (value) {
//                             String oldvalue = remarkcontroller.text;
//                             //  debugPrint("1111111111111110-->");
//                             // debugPrint(remarkcontroller.text);
//                             // debugPrint(oldvalue.toString());
                  
//                             remarkcontroller.text = oldvalue + value;
//                             // Your onChanged logic here
//                             // debugPrint(
//                             //     "onchanged values------------++++++++++++++++++>>");
//                             // debugPrint(remarkcontroller.text);
                  
//                             // remarkcontroller.value = TextEditingValue(
//                             //   text: value + remarkcontroller.text,
//                             //   selection: TextSelection.fromPosition(
//                             //     TextPosition(
//                             //         offset:
//                             //             (value + remarkcontroller.text)
//                             //                 .length),
//                             //   ),
//                             // );
//                             // debugPrint(remarkcontroller.text);
//                           },
//                         ),
//                       ),*/

//                       /* const SizedBox(
//                         height: 46,
//                       ),
//                       /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                       Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Select overtime start date and time:  ",
//                               style: TextStyle(
//                                   fontSize: 19, fontWeight: FontWeight.bold),
//                             ),
//                             Container(
//                                 margin: const EdgeInsets.only(left: 40),
//                                 width: 200,
//                                 child: TextField(
//                                   onTap: () async {
//                                     if (employeeid != '' && wsid != '') {
//                                       DateTime? picked =
//                                           await dateTimePicker(context);
//                                       if (picked != null) {
//                                         List<String> pickeddate =
//                                             picked.toString().split(' ');
//                                         startpickDate.text =
//                                             pickeddate[0].toString();
//                                       }
//                                       BlocProvider.of<OperatorCubit>(context)
//                                           .saveDData(
//                                         empid: employeeid,
//                                         wsid: wsid,
//                                         startddate: startpickDate.text,
//                                         starttime: starttime.text,
//                                         endddate: endpickDate.text,
//                                         endttime: endtime.text,
//                                         updatedendDateTime:
//                                             updatedEndDateTime.text,
//                                       );
//                                     }
//                                   },
//                                   onChanged: (value) async {},
//                                   readOnly: true,
//                                   controller: startpickDate,
//                                   decoration: const InputDecoration(
//                                     icon: Icon(
//                                       Icons.calendar_month_sharp,
//                                       color: Color(0XFF01579b),
//                                     ),
//                                     border: InputBorder.none,
//                                     enabledBorder: OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(),
//                                   ),
//                                 )),
//                             SizedBox(
//                               child: IconButton(
//                                   onPressed: () async {
//                                     startpickDate.text = '';
//                                   },
//                                   icon: Icon(
//                                     Icons.cancel,
//                                     color: const Color.fromARGB(
//                                         255, 223, 123, 123),
//                                     size: Platform.isAndroid ? 25 : 20,
//                                   )),
//                             ),
//                             const SizedBox(
//                               width: 28,
//                             ),
//                             Container(
//                                 margin: const EdgeInsets.only(left: 40),
//                                 width: 200,
//                                 child: TextField(
//                                   onTap: () async {
//                                     if (employeeid != '' &&
//                                         wsid != '' &&
//                                         startpickDate.text != '') {
//                                       var time = await showTimePicker(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         initialTime: TimeOfDay.now(),
//                                         initialEntryMode:
//                                             TimePickerEntryMode.dialOnly,
//                                         helpText: 'Select Time',
//                                         cancelText: 'Cancel',
//                                         confirmText: 'Ok',
//                                         //  errorFormatText: 'Invalid format',
//                                         errorInvalidText: 'Invalid time',
//                                         builder: (BuildContext context,
//                                             Widget? child) {
//                                           return MediaQuery(
//                                             data: MediaQuery.of(context).copyWith(
//                                                 alwaysUse24HourFormat:
//                                                     false), // Set to false for 12-hour format
//                                             child: child!,
//                                           );
//                                         },
//                                       );
                  
//                                       if (time != null) {
//                                         selectedstartTime = time;
//                                         starttime.text =
//                                             '${selectedstartTime!.hour.toString().padLeft(2, '0')}:${selectedstartTime!.minute.toString().padLeft(2, '0')}';
//                                         String date1 =
//                                             '${startpickDate.text} ${starttime.text}';
//                                         dt1 = DateTime.parse(date1);
//                                         Dt1 = dt1.toString();
                  
//                                         BlocProvider.of<OperatorCubit>(
//                                                 context)
//                                             .saveDData(
//                                           empid: employeeid,
//                                           wsid: wsid,
//                                           startddate: startpickDate.text,
//                                           starttime: starttime.text,
//                                           endddate: endpickDate.text,
//                                           endttime: endtime.text,
//                                           updatedendDateTime:
//                                               updatedEndDateTime.text,
//                                         );
//                                       }
//                                     }
//                                   },
//                                   readOnly: true,
//                                   controller: starttime,
//                                   decoration: const InputDecoration(
//                                     icon: Icon(
//                                       Icons.access_time,
//                                       color: Color.fromARGB(255, 52, 94, 126),
//                                     ),
//                                     border: InputBorder.none,
//                                     enabledBorder: OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(),
//                                   ),
//                                 )),
//                             SizedBox(
//                               child: IconButton(
//                                   onPressed: () async {
//                                     starttime.text = '';
//                                     endtime.text = '';
//                                   },
//                                   icon: Icon(
//                                     Icons.cancel,
//                                     color: const Color.fromARGB(
//                                         255, 223, 123, 123),
//                                     size: Platform.isAndroid ? 25 : 20,
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 28,
//                       ),
//                       Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Select overtime end date and time:   ",
//                               style: TextStyle(
//                                   fontSize: 19, fontWeight: FontWeight.bold),
//                             ),
//                             Container(
//                                 margin: const EdgeInsets.only(left: 40),
//                                 width: 200,
//                                 child: TextField(
//                                   onTap: () async {
//                                     if (employeeid != '' &&
//                                         wsid != '' &&
//                                         startpickDate.text != '' &&
//                                         starttime.text != '') {
//                                       DateTime? picked =
//                                           await dateTimePicker(context);
//                                       if (picked != null) {
//                                         List<String> pickeddate =
//                                             picked.toString().split(' ');
//                                         endpickDate.text =
//                                             pickeddate[0].toString();
//                                         BlocProvider.of<OperatorCubit>(
//                                                 context)
//                                             .saveDData(
//                                           empid: employeeid,
//                                           wsid: wsid,
//                                           startddate: startpickDate.text,
//                                           starttime: starttime.text,
//                                           endddate: endpickDate.text,
//                                           endttime: endtime.text,
//                                           updatedendDateTime:
//                                               updatedEndDateTime.text,
//                                         );
//                                       }
//                                     }
//                                   },
//                                   readOnly: true,
//                                   controller: endpickDate,
//                                   decoration: const InputDecoration(
//                                     icon: Icon(
//                                       Icons.calendar_month_sharp,
//                                       color: Color(0XFF01579b),
//                                     ),
//                                     border: InputBorder.none,
//                                     enabledBorder: OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(),
//                                   ),
//                                 )),
//                             SizedBox(
//                               child: IconButton(
//                                   onPressed: () async {
//                                     endpickDate.text = '';
//                                     Dt2 = '';
//                                     endtime.text = '';
//                                   },
//                                   icon: Icon(
//                                     Icons.cancel,
//                                     color: const Color.fromARGB(
//                                         255, 223, 123, 123),
//                                     size: Platform.isAndroid ? 25 : 20,
//                                   )),
//                             ),
//                             const SizedBox(
//                               width: 28,
//                             ),
//                             Container(
//                                 margin: const EdgeInsets.only(left: 40),
//                                 width: 200,
//                                 child: TextField(
//                                   onTap: () async {
//                                     if (employeeid != '' &&
//                                         wsid != '' &&
//                                         startpickDate.text != '' &&
//                                         starttime.text != '' &&
//                                         endpickDate.text != '') {
//                                       var time = await showTimePicker(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         initialTime: TimeOfDay.now(),
//                                         initialEntryMode:
//                                             TimePickerEntryMode.dialOnly,
//                                         helpText: 'Select end Time',
//                                         cancelText: 'Cancel',
//                                         confirmText: 'Ok',
//                                         //  errorFormatText: 'Invalid format',
//                                         errorInvalidText: 'Invalid time',
//                                         builder: (BuildContext context,
//                                             Widget? child) {
//                                           return MediaQuery(
//                                             data: MediaQuery.of(context).copyWith(
//                                                 alwaysUse24HourFormat:
//                                                     false), // Set to false for 12-hour format
//                                             child: child!,
//                                           );
//                                         },
//                                       );
//                                       if (time != null) {
//                                         selectedendTime = time;
//                                         endtime.text =
//                                             '${selectedendTime!.hour.toString().padLeft(2, '0')}:${selectedendTime!.minute.toString().padLeft(2, '0')}';
                  
//                                         String date2 =
//                                             '${endpickDate.text} ${endtime.text}';
//                                         dt2 = DateTime.parse(date2);
//                                         Dt2 = dt2.toString();
                  
//                                         if (dt1!.isBefore(dt2!)) {
//                                           BlocProvider.of<OperatorCubit>(
//                                                   context)
//                                               .saveDData(
//                                             empid: employeeid,
//                                             wsid: wsid,
//                                             startddate: startpickDate.text,
//                                             starttime: starttime.text,
//                                             endddate: endpickDate.text,
//                                             endttime: endtime.text,
//                                             updatedendDateTime:
//                                                 updatedEndDateTime.text,
//                                           );
//                                         }
//                                         if (dt1!.isAfter(dt2!)) {
//                                           QuickFixUi().showCustomDialog(
//                                               context: context,
//                                               errorMessage:
//                                                   "Please select proper date and Time");
//                                           endpickDate.text = '';
//                                           endtime.text = '';
//                                         }
//                                       }
//                                     }
//                                   },
//                                   readOnly: true,
//                                   controller: endtime,
//                                   decoration: const InputDecoration(
//                                     icon: Icon(
//                                       Icons.access_time,
//                                       color: Color.fromARGB(255, 52, 94, 126),
//                                     ),
//                                     border: InputBorder.none,
//                                     enabledBorder: OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(),
//                                   ),
//                                 )),
//                             SizedBox(
//                               child: IconButton(
//                                   onPressed: () async {
//                                     endtime.text = '';
//                                     Dt2 = '';
//                                   },
//                                   icon: Icon(
//                                     Icons.cancel,
//                                     color: const Color.fromARGB(
//                                         255, 223, 123, 123),
//                                     size: Platform.isAndroid ? 25 : 20,
//                                   )),
//                             )
//                           ],
//                         ),
//                       ),
//                       /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                       const SizedBox(
//                         height: 46,
//                       ),
//                       Center(
//                         child: BlocBuilder<OperatorCubit, EmployeeState>(
//                           builder: (context, state) {
//                             return 
//                             SizedBox(
//                                 child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 elevation: 10,
//                                 backgroundColor: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 side: const BorderSide(
//                                     width: 1.0,
//                                     color: Color.fromARGB(255, 235, 32, 18)),
//                               ),
//                               onPressed: () async {
//                                 debugPrint(
//                                     "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{-----}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
//                                 debugPrint(
//                                     employeeid.toString() + wsid.toString());
                  
//                                 // if (state is OperatorLoadList) {
//                                 //   if (employeeid != '' &&
//                                 //       wsid != '' &&
//                                 //       startpickDate != '' &&
//                                 //       starttime.text != '') {
//                                 //     final saveddata = await UserData.getUserData();
//                                 //     token = saveddata['token'].toString();
//                                 //     for (var userdata in saveddata['data']) {
//                                 //       loginid = userdata['id'];
//                                 //     }
//                                 //     dynamic check = await showDialog<String>(
//                                 //       context: context,
//                                 //       barrierDismissible: false,
//                                 //       builder: (context) {
//                                 //         return AlertDialog(
//                                 //           content: const Text(
//                                 //               "Do you want to submit record?",
//                                 //               style: TextStyle(
//                                 //                   color: AppColors.blackColor,
//                                 //                   fontWeight: FontWeight.bold,
//                                 //                   fontSize: 25)),
//                                 //           actions: [
//                                 //             ElevatedButton(
//                                 //                 style: ButtonStyle(
//                                 //                     backgroundColor:
//                                 //                         MaterialStateColor
//                                 //                             .resolveWith((states) =>
//                                 //                                 Theme.of(context)
//                                 //                                     .colorScheme
//                                 //                                     .error)),
//                                 //                 onPressed: () {
//                                 //                   Navigator.of(context).pop('cancel');
//                                 //                 },
//                                 //                 child: const Text(
//                                 //                   "No",
//                                 //                   style: TextStyle(
//                                 //                       color: AppColors.whiteTheme,
//                                 //                       fontWeight: FontWeight.bold),
//                                 //                 )),
//                                 //             QuickFixUi.horizontalSpace(width: 180),
//                                 //             ElevatedButton(
//                                 //                 style: ButtonStyle(
//                                 //                     backgroundColor:
//                                 //                         MaterialStateColor
//                                 //                             .resolveWith((states) =>
//                                 //                                 AppColors
//                                 //                                     .greenTheme)),
//                                 //                 onPressed: () async {
                  
//                                 //                   Navigator.of(context)
//                                 //                       .pop('confirm');
//                                 //                 },
//                                 //                 child: const Text(
//                                 //                   "Yes",
//                                 //                   style: TextStyle(
//                                 //                       color: AppColors.whiteTheme,
//                                 //                       fontWeight: FontWeight.bold),
//                                 //                 ))
//                                 //             //})
//                                 //           ],
//                                 //         );
//                                 //       },
//                                 //     );
//                                 //     if (check == 'confirm') {
//                                 //       Future.sync(() {
                  
//                                 //         BlocProvider.of<OperatorCubit>(context)
//                                 //             .overtimeInsertData(
//                                 //                 loginid: loginid,
//                                 //                 empid: employeeid,
//                                 //                 wsid: wsid,
//                                 //                 starttime: Dt1.toString(),
//                                 //                 endtime: Dt2 ?? '',
//                                 //                 token: token,
//                                 //                 context: context);
//                                 //         QuickFixUi.successMessage(
//                                 //             "Successfully insert", context);
                  
//                                 //         startpickDate.text = '';
//                                 //         starttime.text = '';
//                                 //         endpickDate.text = '';
//                                 //         endtime.text = '';
//                                 //         updatedEndDateTime.text = '';
//                                 //         Dt1 = '';
//                                 //         Dt2 = '';
//                                 //       });
//                                 //     }
//                                 //   }
//                                 // }
//                               },
//                               child: const Text("Submit"),
//                             ));
//                           },
//                         ),
//                       ),*/
//                       const SizedBox(
//                         height: 46,
//                       ),
//                       // BlocBuilder<OperatorCubit, EmployeeState>(
//                       //   builder: (context, state) {
//                       // int serialNumber = 1;
//                       //     if (state is OperatorLoadList &&
//                       //         state.empovertimedata.isNotEmpty &&
//                       //         employeeid.isNotEmpty) {
//                       //       return
//                       Container(
//                           width: size.width,
//                           height: 350, //size.height,
//                           margin: const EdgeInsets.all(10),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.vertical,
//                             child: DataTable(
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 224, 224, 224),
//                                   border: Border.all(color: Colors.grey),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 dataRowColor:
//                                     MaterialStateProperty.all(Colors.white),
//                                 columns: const [
//                                   DataColumn(label: Text('Sr.No')),
//                                   DataColumn(label: Text('Employee name')),
//                                   DataColumn(label: Text('Machine Name')),
//                                   DataColumn(label: Text('Start time')),
//                                   DataColumn(label: Text('End time')),
//                                   DataColumn(label: Text('Action')),
//                                 ],
//                                 rows: state.empovertimedata
//                                     .asMap()
//                                     .entries
//                                     .map((entry) {
//                                   int index = entry.key;
//                                   EmployeeOvertimedata e = entry.value;
//                                   rowControllers = List.generate(
//                                     state.empovertimedata.length,
//                                     (index) => TextEditingController(),
//                                   );
//                                   TextEditingController controller = rowControllers[
//                                       index]; // Retrieve the controller for this row
//                                   int currentSerial = serialNumber++;
//                                   // debugPrint(e.endtime);
//                                   // debugPrint(e.endtime.runtimeType.toString());
//                                   return DataRow(
//                                     cells: [
//                                       DataCell(Text(currentSerial.toString())),
//                                       DataCell(Text(e.employeename.toString())),
//                                       DataCell(Text(
//                                         e.wscode.toString(),
//                                         style: const TextStyle(
//                                           color:
//                                               Color.fromARGB(255, 58, 126, 153),
//                                         ),
//                                         // style: AppTextStyle.tableItem
//                                       )),
//                                       DataCell(Text(e.starttime.toString())),
//                                       DataCell(
//                                         e.endtime == '' || e.endtime == null
//                                             ? Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(5.0),
//                                                 child: TextField(
//                                                   readOnly: true,
//                                                   controller: controller,
//                                                   onTap: () async {
//                                                     fenddate =
//                                                         await dateTimePicker(
//                                                             context);
//                                                     if (fenddate == null)
//                                                       return;

//                                                     List<String> pickeddate =
//                                                         fenddate
//                                                             .toString()
//                                                             .split(' ');
//                                                     updatedEndDate.text =
//                                                         pickeddate[0]
//                                                             .toString();

//                                                     TimeOfDay? time =
//                                                         await showTimePicker(
//                                                       context: context,
//                                                       initialTime:
//                                                           TimeOfDay.now(),
//                                                       initialEntryMode:
//                                                           TimePickerEntryMode
//                                                               .dialOnly,
//                                                       builder:
//                                                           (BuildContext context,
//                                                               Widget? child) {
//                                                         return MediaQuery(
//                                                           data: MediaQuery.of(
//                                                                   context)
//                                                               .copyWith(
//                                                             alwaysUse24HourFormat:
//                                                                 false, // Set to false for 12-hour format
//                                                           ),
//                                                           child: child!,
//                                                         );
//                                                       },
//                                                     );
//                                                     if (time == null) return;

//                                                     UpdatedselectedendTime =
//                                                         time;
//                                                     updatedEndTime.text =
//                                                         '${UpdatedselectedendTime!.hour.toString().padLeft(2, '0')}:${UpdatedselectedendTime!.minute.toString().padLeft(2, '0')}';

//                                                     updatedEndDateTime.text =
//                                                         '${updatedEndDate.text} ${updatedEndTime.text}';

//                                                     e.endtime =
//                                                         updatedEndDateTime.text
//                                                             .toString()
//                                                             .trim();

//                                                     dt1 = DateTime.parse(
//                                                         e.starttime.toString());
//                                                     dt2 = DateTime.parse(
//                                                         e.endtime.toString());

//                                                     //  Dt2 = dt1.toString();

//                                                     if (dt1!.isBefore(dt2!)) {
//                                                       controller.text =
//                                                           e.endtime.toString();
//                                                     }
//                                                     if (dt1!.isAfter(dt2!)) {
//                                                       QuickFixUi().showCustomDialog(
//                                                           context: context,
//                                                           errorMessage:
//                                                               "Please select proper date and Time");
//                                                       e.endtime = '';
//                                                     }
//                                                   },
//                                                   decoration: InputDecoration(
//                                                     filled: true,
//                                                     fillColor: Theme.of(context)
//                                                         .colorScheme
//                                                         .primaryContainer,
//                                                     border:
//                                                         const OutlineInputBorder(),
//                                                     contentPadding:
//                                                         const EdgeInsets
//                                                             .symmetric(
//                                                             vertical: 12,
//                                                             horizontal: 16),
//                                                   ),
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   textAlign: TextAlign.center,
//                                                   keyboardType:
//                                                       TextInputType.text,
//                                                 ),
//                                               )
//                                             : Text(e.endtime.toString()),
//                                       ),
//                                       DataCell(e.endtime == ''
//                                           ? Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: ElevatedButton(
//                                                 style: ButtonStyle(
//                                                   backgroundColor:
//                                                       MaterialStateColor
//                                                           .resolveWith(
//                                                     (states) =>
//                                                         Theme.of(context)
//                                                             .colorScheme
//                                                             .primaryContainer,
//                                                   ),
//                                                 ),
//                                                 onPressed: () async {
//                                                   if (e.endtime != '') {
//                                                     dynamic check =
//                                                         await showDialog<
//                                                                 String>(
//                                                             context: context,
//                                                             builder: (context) {
//                                                               return AlertDialog(
//                                                                 content: const Text(
//                                                                     "Do you want to update record?",
//                                                                     style: TextStyle(
//                                                                         color: AppColors
//                                                                             .blackColor,
//                                                                         fontWeight:
//                                                                             FontWeight
//                                                                                 .bold,
//                                                                         fontSize:
//                                                                             25)),
//                                                                 actions: [
//                                                                   ElevatedButton(
//                                                                       style: ButtonStyle(
//                                                                           backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context)
//                                                                               .colorScheme
//                                                                               .error)),
//                                                                       onPressed:
//                                                                           () {
//                                                                         Navigator.of(context)
//                                                                             .pop('cancel');
//                                                                       },
//                                                                       child:
//                                                                           const Text(
//                                                                         "No",
//                                                                         style: TextStyle(
//                                                                             color:
//                                                                                 AppColors.whiteTheme,
//                                                                             fontWeight: FontWeight.bold),
//                                                                       )),
//                                                                   QuickFixUi
//                                                                       .horizontalSpace(
//                                                                           width:
//                                                                               180),
//                                                                   ElevatedButton(
//                                                                       style: ButtonStyle(
//                                                                           backgroundColor: MaterialStateColor.resolveWith((states) => AppColors
//                                                                               .greenTheme)),
//                                                                       onPressed:
//                                                                           () async {
//                                                                         Navigator.of(context)
//                                                                             .pop('confirm');
//                                                                       },
//                                                                       child:
//                                                                           const Text(
//                                                                         "Yes",
//                                                                         style: TextStyle(
//                                                                             color:
//                                                                                 AppColors.whiteTheme,
//                                                                             fontWeight: FontWeight.bold),
//                                                                       ))
//                                                                   //})
//                                                                 ],
//                                                               );
//                                                             });
//                                                     if (check == 'confirm') {
//                                                       Future.sync(() async {
//                                                         BlocProvider.of<EmployeeCubit>(
//                                                                 context)
//                                                             .overtimeUpdateData(
//                                                                 id: e.id
//                                                                     .toString(),
//                                                                 empid:
//                                                                     employeeid,
//                                                                 wsid: wsid,
//                                                                 endtime:
//                                                                     controller
//                                                                         .text,
//                                                                 token: token,
//                                                                 context:
//                                                                     context);
//                                                         QuickFixUi.successMessage(
//                                                             "Updated Successfully",
//                                                             context);
//                                                       });
//                                                     }
//                                                   }
//                                                 },
//                                                 child: const Text(
//                                                   "Update",
//                                                   style: TextStyle(
//                                                     color: Color.fromARGB(
//                                                         255, 12, 12, 12),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           : const Text('')),
//                                     ],
//                                   );
//                                 }).toList()),
//                           ))
//                       // }else{
//                       //     } else {
//                       //       return const Stack();
//                       //     }
//                       //   },
//                       // ),
//                     ],
//                   ),
//                 );
//                 ///////////////
//               } else {
//                 return const Stack();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   confirmtoinsert(
//       {required BuildContext context,
//       required String loginid,
//       required String empid,
//       required String wsid,
//       required String starttime,
//       required String endtime,
//       required String token}) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           content: const Text("Do you want to submit record?",
//               style: TextStyle(
//                   color: AppColors.blackColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 25)),
//           actions: [
//             ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateColor.resolveWith(
//                         (states) => Theme.of(context).colorScheme.error)),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text(
//                   "No",
//                   style: TextStyle(
//                       color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
//                 )),
//             QuickFixUi.horizontalSpace(width: 180),
//             ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateColor.resolveWith(
//                         (states) => AppColors.greenTheme)),
//                 onPressed: () async {
//                   // await EmployeeRepository.sendEmpOvertimeData(
//                   //     loginid: loginid,
//                   //     empid: empid,
//                   //     wsid: wsid,
//                   //     starttime: starttime,
//                   //     endtime: endtime,
//                   //     token: token,
//                   //     context: context);
//                   // BlocProvider.of<OperatorCubit>(context).sendEmpOvertimedata(
//                   //   loginid: loginid,
//                   //   empid: empid,
//                   //   wsid: wsid,
//                   //   starttime: starttime,
//                   //   endtime: endtime != '' ? endtime.toString() : '',
//                   // );

//                   // BlocProvider.of<OperatorCubit>(context).overtimeInsertData(
//                   //     loginid: loginid,
//                   //     empid: empid,
//                   //     wsid: wsid,
//                   //     starttime: starttime,
//                   //     endtime: endtime,
//                   //     token: token,
//                   //     context: context);

//                   Navigator.of(context).pop();
//                 },
//                 child: const Text(
//                   "Yes",
//                   style: TextStyle(
//                       color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
//                 ))
//             //})
//           ],
//         );
//       },
//     );
//   }

//   updateemployeeData(
//       {required BuildContext context,
//       required String id,
//       required String empid,
//       required String endtime,
//       required String token}) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           content: const Text("Do you want to update record?",
//               style: TextStyle(
//                   color: AppColors.blackColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 25)),
//           actions: [
//             ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateColor.resolveWith(
//                         (states) => Theme.of(context).colorScheme.error)),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text(
//                   "No",
//                   style: TextStyle(
//                       color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
//                 )),
//             QuickFixUi.horizontalSpace(width: 180),
//             ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateColor.resolveWith(
//                         (states) => AppColors.greenTheme)),
//                 onPressed: () async {
//                   await EmployeeRepository.updateEmpOvertimeData(
//                     id: id,
//                     empid: empid,
//                     endtime: endtime,
//                     token: token,
//                     //context: context
//                   );

//                   Navigator.of(context).pop();
//                 },
//                 child: const Text(
//                   "Yes",
//                   style: TextStyle(
//                       color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
//                 ))
//             //})
//           ],
//         );
//       },
//     );
//   }
// }
