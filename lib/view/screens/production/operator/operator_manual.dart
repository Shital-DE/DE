// //modified by Nilesh 29-03-2023 added processlist

// // ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

// import 'dart:async';

// import 'package:de_opc/routes/route_names.dart';
// import 'package:de_opc/services/model/operator/oprator_models.dart';
// import 'package:de_opc/services/repository/operator/operator_repository.dart';
// import 'package:de_opc/services/repository/quality/quality_repository.dart';
// import 'package:de_opc/utils/app_colors.dart';
// import 'package:de_opc/utils/app_theme.dart';
// import 'package:de_opc/utils/common/quickfix_widget.dart';
// import 'package:de_opc/utils/size_config.dart';
// import 'package:de_opc/view/screens/common/documents.dart';
// import 'package:de_opc/view/screens/common/internet_connection.dart';
// import 'package:de_opc/view/widgets/appbar.dart';
// import 'package:de_opc/view/widgets/debounce_button.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // import '../../../../bloc/production/operator/bloc/operatorManualProduction/operatorManualProduction_bloc.dart';
// // import '../../../../bloc/production/operator/bloc/operatorManualProduction/operatorManualProduction_event.dart';
// // import '../../../../bloc/production/operator/bloc/operatorManualProduction/operatorManualProduction_state.dart';

// // ignore: must_be_immutable
// class ProductionManual extends StatelessWidget {
//   ProductionManual({
//     super.key,
//     required this.arguments,
//   });
//   final Map<String, dynamic> arguments;
//   final List<String> selectedItems = [];
//   String toolselectItem = '';

//   List<Tools> selectedtoollist = [];
//   @override
//   Widget build(BuildContext context) {
//     Barcode? barcode = arguments['barcode'];
//     final blocprovider = BlocProvider.of<OperatorManualScreenBloc>(context);
//     blocprovider.add(OperatorScreenEvent(selectedItems, '', '', 0, [], barcode!,
//         arguments['machinedata'], 0, ''));

//     SizeConfig.init(context);
//     return InternetConnectionCheck(
//       widget: Scaffold(
//         appBar: CustomAppbar()
//             .appbar(context: context, title: 'Operator Manuallly'),
//         body: BlocBuilder<OperatorManualScreenBloc, OperatorManualState>(
//           builder: (context, state) {
//             return state is OperatorManualLoadingState &&
//                     state.isAlreadyEndProduction
//                 ? Center(
//                     child: Container(
//                         width: 300,
//                         height: 130,
//                         margin: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black.withOpacity(0.50),
//                                   spreadRadius: 5.0,
//                                   blurRadius: 8.0)
//                             ],
//                             color: const Color.fromARGB(255, 194, 171, 171)),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.only(top: 10),
//                               child: const Text(
//                                 'This Product final End completed',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 18),
//                               ),
//                             ),
//                             FilledButton(
//                                 child: const Text('Go back'),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                   Navigator.popAndPushNamed(
//                                       context, RouteName.dashboard, arguments: {
//                                     'machinedata': arguments['machinedata']
//                                   });
//                                 })
//                           ],
//                         )),
//                   )
//                 : SafeArea(
//                     child: ListView(
//                       children: [
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(top: 10, left: 80),
//                                 child: SizedBox(
//                                   width: 200,
//                                   child: Stack(children: [
//                                     Positioned(
//                                       child: Text(
//                                         "PO : ",
//                                         style: AppTheme.tabTextStyleBold()
//                                             .copyWith(color: Colors.black),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       left: 40,
//                                       child: Text(
//                                         barcode.po.toString(),
//                                         style: AppTheme.tabTextStyleNormal()
//                                             .copyWith(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w500),
//                                       ),
//                                     ),
//                                   ]),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 10),
//                                 child: SizedBox(
//                                   width: 180,
//                                   child: Stack(children: [
//                                     Positioned(
//                                       child: Text("LineNo : ",
//                                           style: AppTheme.tabTextStyleBold()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                     Positioned(
//                                       left: 80,
//                                       child: Text(
//                                           barcode.lineitemnumber.toString(),
//                                           style: AppTheme.tabTextStyleNormal()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                   ]),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 10),
//                                 child: SizedBox(
//                                   width: 240,
//                                   child: Stack(children: [
//                                     Positioned(
//                                       child: Text("Product : ",
//                                           style: AppTheme.tabTextStyleBold()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                     Positioned(
//                                       left: 90,
//                                       child: Text(barcode.product ?? "",
//                                           style: AppTheme.tabTextStyleNormal()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                   ]),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 10),
//                                 child: SizedBox(
//                                   width: 400,
//                                   child: Stack(children: [
//                                     Positioned(
//                                       child: Text("Raw Material : ",
//                                           style: AppTheme.tabTextStyleBold()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                     Positioned(
//                                       left: 140,
//                                       child: Text(
//                                           barcode.rawmaterial.toString(),
//                                           style: AppTheme.tabTextStyleNormal()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                   ]),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 10),
//                                 child: SizedBox(
//                                   width: 150,
//                                   child: Stack(children: [
//                                     Positioned(
//                                       child: Text("Qty : ",
//                                           style: AppTheme.tabTextStyleBold()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                     Positioned(
//                                       left: 50,
//                                       child: Text(barcode.issueQty.toString(),
//                                           style: AppTheme.tabTextStyleNormal()
//                                               .copyWith(color: Colors.black)),
//                                     ),
//                                   ]),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Divider(
//                           height: 20,
//                           thickness: 5,
//                           indent: 0,
//                           endIndent: 0,
//                           color: Color.fromARGB(255, 50, 84, 100),
//                         ),
//                         startbutton(blocprovider),
//                         pdfmodelbutton(),
//                         revisionnumber(),
//                         const Divider(
//                           height: 20,
//                           thickness: 1,
//                           indent: 0,
//                           endIndent: 0,
//                           color: Color.fromARGB(255, 50, 84, 100),
//                         ),
//                         selectprocess(),
//                         selecttools(blocprovider),
//                         const Divider(
//                           height: 10,
//                           thickness: 0,
//                           indent: 0,
//                           endIndent: 0,
//                           color: Color.fromARGB(255, 50, 84, 100),
//                         ),
//                         BlocBuilder<OperatorManualScreenBloc,
//                             OperatorManualState>(
//                           builder: (context, state) {
//                             return Container(
//                               width: SizeConfig.screenWidth,
//                               margin: const EdgeInsets.only(top: 30),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   fillokqtytextformfild(
//                                       state, context, blocprovider),
//                                   const SizedBox(
//                                     width: 30,
//                                   ),
//                                   rejectqtyTextFormfild(
//                                       state, context, blocprovider),
//                                   const SizedBox(
//                                     width: 30,
//                                   ),
//                                   SizedBox(
//                                     width: SizeConfig.blockSizeHorizontal! * 20,
//                                     child:
//                                         DropdownSearch<OperatorRejectedReasons>(
//                                       items: state is OperatorManualLoadingState
//                                           ? state.operatorrejresons
//                                           : [],
//                                       itemAsString: (item) =>
//                                           item.rejectedreasons.toString(),
//                                       popupProps: const PopupProps.menu(
//                                           showSearchBox: true,
//                                           searchFieldProps: TextFieldProps(
//                                             style: TextStyle(fontSize: 18),
//                                           )),
//                                       dropdownDecoratorProps:
//                                           DropDownDecoratorProps(
//                                               dropdownSearchDecoration:
//                                                   InputDecoration(
//                                                       labelText:
//                                                           "Rejected reasons",
//                                                       border: OutlineInputBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10)))),
//                                       onChanged: (value) {
//                                         toolselectItem = '';

//                                         if (state
//                                             is OperatorManualLoadingState) {
//                                           if (state.rejqty == 0) {
//                                             return QuickFixUi.errorMessage(
//                                                 'Reject Qty is empty', context);
//                                           } else {
//                                             if (state.rejqty > 0) {
//                                               blocprovider.add(
//                                                   OperatorScreenEvent(
//                                                       state.selectedItems,
//                                                       state.settingtime,
//                                                       state.startproductiontime,
//                                                       state.okqty,
//                                                       state.selectedtoollist,
//                                                       state.barcode,
//                                                       arguments['machinedata'],
//                                                       state.rejqty,
//                                                       value!.id.toString()));
//                                               toolselectItem =
//                                                   value.id.toString();
//                                               // debugPrint(
//                                               //     "resonsselectlist.....;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
//                                               // debugPrint(toolselectItem);
//                                             }
//                                           }
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         BlocBuilder<OperatorManualScreenBloc,
//                             OperatorManualState>(
//                           builder: (context, state) {
//                             return Container(
//                                 margin: const EdgeInsets.only(top: 50),
//                                 width: SizeConfig.screenWidth,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 200,
//                                       height: 50,
//                                       child: DebouncedButton(
//                                         onPressed: () async {
//                                           if (state
//                                               is OperatorManualLoadingState) {
//                                             if (state.settingtime == null &&
//                                                     state.getpreviousproductiontime['startprocesstime'] !=
//                                                         null ||
//                                                 state.settingtime != null &&
//                                                     state.getpreviousproductiontime[
//                                                             'startprocesstime'] ==
//                                                         null) {
//                                               return QuickFixUi.errorMessage(
//                                                   ' Startsetting first',
//                                                   context);
//                                             } else if (state.getpreviousproductiontime[
//                                                             'startproductiontime'] ==
//                                                         null &&
//                                                     state.startproductiontime !=
//                                                         null ||
//                                                 state.getpreviousproductiontime[
//                                                             'startproductiontime'] !=
//                                                         null &&
//                                                     state.startproductiontime ==
//                                                         null) {
//                                               return QuickFixUi.errorMessage(
//                                                   'start prodution first.',
//                                                   context);
//                                             } else if (state.selectedItems.isEmpty ||
//                                                 state
//                                                     .selectedtoollist.isEmpty) {
//                                               return QuickFixUi.errorMessage(
//                                                   'Select Process and Tools',
//                                                   context);
//                                             } else if (state.okqty == 0) {
//                                               return QuickFixUi.errorMessage(
//                                                   'fill Ok Qty', context);
//                                             } else if (state.rejqty > 0 &&
//                                                 toolselectItem.isEmpty) {
//                                               return QuickFixUi.errorMessage(
//                                                   'Please Choose Reject Reasons',
//                                                   context);
//                                             } else {
//                                               List<String> selecttool = [];
//                                               for (var data
//                                                   in state.selectedtoollist) {
//                                                 selecttool
//                                                     .add(data.id.toString());
//                                               }
//                                               await confirmEndProcess(
//                                                   context,
//                                                   state.productionstatusid,
//                                                   state.okqty,
//                                                   state.rejqty,
//                                                   toolselectItem.toString(),
//                                                   state.barcode.productid
//                                                       .toString(),
//                                                   state.barcode
//                                                       .rawmaterialissueid
//                                                       .toString(),
//                                                   state.employeeID,
//                                                   state.token,
//                                                   state.workcentreid,
//                                                   state.workstationid);
//                                             }
//                                           }
//                                         },
//                                         text: 'End Process',
//                                         style: ButtonStyle(
//                                             textStyle: MaterialStateProperty
//                                                 .resolveWith((states) =>
//                                                     AppTheme
//                                                         .mobileTextStyle())),
//                                       ),
//                                     )
//                                   ],
//                                 ));
//                           },
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         )
//                       ],
//                     ),
//                   );
//           },
//         ),
//       ),
//     );
//   }

//   BlocBuilder<OperatorManualScreenBloc, OperatorManualState> startbutton(
//       OperatorManualScreenBloc blocprovider) {
//     return BlocBuilder<OperatorManualScreenBloc, OperatorManualState>(
//       builder: (context, state) {
//         return Container(
//           margin: const EdgeInsets.only(top: 10),
//           width: SizeConfig.screenWidth,
//           height: 100,
//           child:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//             Container(
//                 width: 130,
//                 height: 50,
//                 margin: EdgeInsets.zero,
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: state is OperatorManualLoadingState &&
//                               state.getpreviousproductiontime.isEmpty
//                           ? (state.settingtime == ''
//                               ? AppColors.startsettingbuttonColor
//                               : AppColors.buttonDisableColor)
//                           : AppColors.buttonDisableColor,
//                       foregroundColor: const Color.fromARGB(255, 255, 255, 255),
//                     ),
//                     onPressed: () async {
//                       if (state is OperatorManualLoadingState &&
//                           state.settingtime == '') {
//                         String settingtime = await QualityInspectionRepository()
//                             .currentDatabaseTime(state.token);
//                         blocprovider.add(OperatorScreenEvent(
//                             selectedItems,
//                             settingtime,
//                             '',
//                             0,
//                             state.selectedtoollist,
//                             state.barcode,
//                             arguments['machinedata'],
//                             state.rejqty,
//                             ''));
//                         // OperatorRepository.startsettinginsert(
//                         //     state.barcode.productid.toString(),
//                         //     state.barcode.rawmaterialissueid.toString(),
//                         //     state.workcentreid,
//                         //     state.workstationid,
//                         //     state.employeeID,
//                         //     state.barcode.revisionnumber.toString(),
//                         //     state.token,
//                         //     context);

//                         if (state.productRouteDetails.isEmpty) {
//                           await OperatorRepository.createMachineProductRoute(
//                             state.barcode.productid.toString(),
//                             state.workcentreid,
//                             state.workstationid,
//                             state.productbomid['productBOMiD'].toString(),
//                             state.barcode.revisionnumber.toString(),
//                             state.token,
//                             context,
//                           );
//                         } else {
//                           int nseqno = 0;
//                           int ver = 0;

//                           if (state.productRouteDetails['productid'] ==
//                                   state.barcode.productid.toString() &&
//                               state.productRouteDetails['wcid'] !=
//                                   state.workcentreid &&
//                               state.productRouteDetails['wcid'] !=
//                                   '4028817165f0a36c0165f0a95e1c0006') {
//                             debugPrint("The values are not same of wc machine");
//                             if (state.workcentreid ==
//                                 '4028817165f0a36c0165f0a89c410004') {
//                               nseqno = 800;
//                             } else if (state.workcentreid ==
//                                 '4028817165f0a36c0165f0a9020e0005') {
//                               nseqno = 900;
//                             } else if (state.workcentreid ==
//                                 '4028817165f0a36c0165f0a95e1c0006') {
//                               nseqno = 1000;
//                             } else {
//                               nseqno = state.productRouteDetails['seqno'] + 10;
//                             }

//                             ver = state.productRouteDetails['Route_version'];
//                             debugPrint(
//                                 "new diff seqno.....$ver/////>>>>>>>>>>>>>>>>>>>>");

//                             ///create function here for revision route create
//                             OperatorRepository
//                                 .createMachineProductRouteDiffSeqNo(
//                               state.barcode.productid.toString(),
//                               state.workcentreid,
//                               state.workstationid,
//                               state.productbomid['productBOMiD'].toString(),
//                               state.barcode.revisionnumber.toString(),
//                               nseqno,
//                               ver,
//                               state.token,
//                               context,
//                             );
//                           } else if (state.productRouteDetails['productid'] ==
//                                   state.barcode.productid.toString() &&
//                               state.productRouteDetails['wcid'] !=
//                                   state.workcentreid) {
//                             debugPrint("previous workcenter is same");
//                           } else if (state.productRouteDetails['productid'] ==
//                                   state.barcode.productid.toString() &&
//                               state.productRouteDetails['wcid'] ==
//                                   '4028817165f0a36c0165f0a95e1c0006') {
//                             if (state.workcentreid ==
//                                 '4028817165f0a36c0165f0a95e1c0006') {
//                               debugPrint("First Product route complete");
//                             } else if (state.productRouteDetails['wcid'] !=
//                                 state.workcentreid) {
//                               int rversion =
//                                   state.productRouteDetails['Route_version'] +
//                                       1;

//                               OperatorRepository
//                                   .createMachineProductRouteDiffRevision(
//                                 state.barcode.productid.toString(),
//                                 state.workcentreid,
//                                 state.workstationid,
//                                 state.productbomid['productBOMiD'].toString(),
//                                 state.barcode.revisionnumber.toString(),
//                                 rversion,
//                                 state.token,
//                                 context,
//                               );

//                               debugPrint(
//                                   "new version new route----------$rversion");
//                             }
//                           }
//                         }
//                       }
//                     },
//                     child: const Text(
//                       "Start Setting",
//                     ))),
//             Container(
//                 decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 245, 239, 239),
//                     borderRadius: BorderRadius.circular(5)),
//                 height: SizeConfig.blockSizeVertical! * 7,
//                 width: SizeConfig.blockSizeHorizontal! * 19,
//                 child: Align(
//                     alignment: Alignment.center,
//                     child: TextField(
//                         decoration:
//                             const InputDecoration(border: InputBorder.none),
//                         readOnly: true,
//                         controller: TextEditingController(
//                             text: state is OperatorManualLoadingState &&
//                                     state.getpreviousproductiontime['startprocesstime'] !=
//                                         null
//                                 ? DateTime.parse(
//                                         state.getpreviousproductiontime[
//                                             'startprocesstime'])
//                                     .toLocal()
//                                     .toString()
//                                 : (state is OperatorManualLoadingState &&
//                                         state.settingtime != ''
//                                     ? DateTime.parse(state.settingtime)
//                                         .toLocal()
//                                         .toString()
//                                     : '')),
//                         textAlign: TextAlign.center,
//                         style: AppTheme.tabTextStyle().copyWith(color: Colors.black)))),
//             Container(
//                 width: 130,
//                 height: 50,
//                 margin: EdgeInsets.zero,
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: state is OperatorManualLoadingState &&
//                               state.getpreviousproductiontime[
//                                       'startproductiontime'] ==
//                                   null
//                           ? ((state.settingtime != '' ||
//                                   state.getpreviousproductiontime[
//                                               'startprocesstime'] !=
//                                           null &&
//                                       state.startproductiontime == '')
//                               ? AppColors.startproductionbuttonColor
//                               : AppColors.buttonDisableColor)
//                           : AppColors.buttonDisableColor,
//                       foregroundColor: const Color.fromARGB(255, 255, 255, 255),
//                     ),
//                     onPressed: () async {
//                       if (state is OperatorManualLoadingState &&
//                           state.startproductiontime == '' &&
//                           (state.settingtime != '' ||
//                               state.getpreviousproductiontime[
//                                       'startprocesstime'] !=
//                                   null)) {
//                         String startproductiontime =
//                             await QualityInspectionRepository()
//                                 .currentDatabaseTime(state.token);
//                         blocprovider.add(OperatorScreenEvent(
//                             selectedItems,
//                             state.settingtime,
//                             startproductiontime,
//                             0,
//                             state.selectedtoollist,
//                             state.barcode,
//                             arguments['machinedata'],
//                             state.rejqty,
//                             ''));
//                         OperatorRepository.updatestartproductionrecord(
//                             state.barcode.productid.toString(),
//                             state.barcode.rawmaterialissueid.toString(),
//                             state.workcentreid,
//                             state.workstationid,
//                             state.employeeID,
//                             state.token,
//                             state.productionstatusid,
//                             context);
//                       } else {
//                         return QuickFixUi.errorMessage(
//                             "Start Setting First", context);
//                       }
//                     },
//                     child: const Text(
//                       "Start Production",
//                     ))),
//             Container(
//                 decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 245, 239, 239),
//                     borderRadius: BorderRadius.circular(5)),
//                 height: SizeConfig.blockSizeVertical! * 8,
//                 width: SizeConfig.blockSizeHorizontal! * 20,
//                 child: Align(
//                     alignment: Alignment.center,
//                     child: TextField(
//                         decoration:
//                             const InputDecoration(border: InputBorder.none),
//                         readOnly: true,
//                         controller: TextEditingController(
//                             text: state is OperatorManualLoadingState &&
//                                     state.getpreviousproductiontime['startproductiontime'] !=
//                                         null
//                                 ? DateTime.parse(state.getpreviousproductiontime[
//                                         'startproductiontime'])
//                                     .toLocal()
//                                     .toString()
//                                 : (state is OperatorManualLoadingState &&
//                                         state.startproductiontime != ''
//                                     ? DateTime.parse(state.startproductiontime)
//                                         .toLocal()
//                                         .toString()
//                                     : '')),
//                         textAlign: TextAlign.center,
//                         style:
//                             AppTheme.tabTextStyle().copyWith(color: Colors.black)))),
//           ]),
//         );
//       },
//     );
//   }

//   BlocBuilder<OperatorManualScreenBloc, OperatorManualState> pdfmodelbutton() {
//     return BlocBuilder<OperatorManualScreenBloc, OperatorManualState>(
//       builder: (context, state) {
//         if (state is OperatorManualLoadingState) {
//           return Documents().documentsButtons(
//             context: context,
//             alignment: Alignment.center,
//             topMargin: 25,
//             token: state.token,
//             pdfMdocId: state.pdfmdocid,
//             product: state.barcode.product.toString(),
//             // productid: state.barcode.productid.toString(),
//             productDescription: state.productDescription,
//             pdfRevisionNo: state.pdfRevisionNo,
//             modelMdocId: state.modelMdocid,
//             modelimageType: state.imageType,
//             // machinename: ''
//           );
//         } else {
//           return const Text('');
//         }
//       },
//     );
//   }

//   BlocBuilder<OperatorScreenBloc, OperatorManualState> revisionnumber() {
//     return BlocBuilder<OperatorScreenBloc, OperatorManualState>(
//         builder: (context, state) {
//       if (state is OperatorManualLoadingState) {
//         return Documents().horizontalVersions(
//             context: context,
//             topMargin: 15,
//             pdfMdocId: state.pdfmdocid,
//             pdfRevisionNo: state.pdfRevisionNo,
//             modelMdocId: state.modelMdocid,
//             modelRevisionNo: state.modelRevisionNumber,
//             modelsDetails: state.modelsDetails,
//             pdfDetails: state.pdfDetails,
//             modelimageType: state.imageType,
//             product: state.barcode.product.toString(),
//             productDescription: state.productDescription,
//             token: state.token);
//       } else {
//         return const Text('');
//       }
//     });
//   }

//   Column selectprocess() {
//     return Column(
//       // mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               // height: 25,
//               //  width: 800,
//               // color: Color.fromARGB(255, 71, 122, 138),
//               child: Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: Text(
//                   'Select Process and Tools'.toUpperCase(),
//                   style: const TextStyle(
//                     fontSize: 20,
//                     color: Color.fromARGB(255, 27, 54, 80),
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Container(
//                 margin: const EdgeInsets.only(top: 5),
//                 color: const Color.fromARGB(255, 255, 255, 255),
//                 width: SizeConfig.screenWidth,
//                 height: 120,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: arguments['processList'].length,
//                   // list item builder
//                   itemBuilder: (BuildContext context, index) {
//                     return BlocBuilder<OperatorManualScreenBloc,
//                         OperatorManualState>(
//                       builder: (context, state) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5.0, vertical: 21.0),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               if (state is OperatorManualLoadingState) {
//                                 if (state.selectedItems.contains(
//                                     arguments['processList'][index].id)) {
//                                   selectedItems.remove((arguments['processList']
//                                           [index]
//                                       .id
//                                       .toString()));
//                                 } else {
//                                   selectedItems.add(arguments['processList']
//                                           [index]
//                                       .id
//                                       .toString());
//                                 }
//                                 // debugPrint(selectedItems.toString());
//                                 BlocProvider.of<OperatorManualScreenBloc>(
//                                         context)
//                                     .add(OperatorScreenEvent(
//                                         selectedItems,
//                                         state.settingtime,
//                                         state.startproductiontime,
//                                         0,
//                                         state.selectedtoollist,
//                                         state.barcode,
//                                         arguments['machinedata'],
//                                         state.rejqty,
//                                         ''));
//                               }
//                             },
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                 state is OperatorManualLoadingState &&
//                                         state.selectedItems.contains(
//                                             arguments['processList'][index].id)
//                                     ? const Color.fromARGB(255, 137, 92, 146)
//                                     : const Color.fromARGB(255, 161, 161, 161),
//                               ),
//                             ),
//                             child: Text(
//                               arguments['processList'][index]
//                                   .processname
//                                   .toString(),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   //  );
//                   //   },
//                 )),
//           ],
//         ),
//       ],
//     );
//   }

//   BlocBuilder<OperatorManualScreenBloc, OperatorManualState> selecttools(
//       OperatorManualScreenBloc blocprovider) {
//     return BlocBuilder<OperatorManualScreenBloc, OperatorManualState>(
//       builder: (context, state) {
//         double conatinerwidth = 250;
//         if (state is OperatorManualLoadingState) {
//           return Container(
//               height: 120,
//               width: conatinerwidth,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 color: const Color.fromARGB(255, 221, 236, 241),
//               ),
//               margin: const EdgeInsets.only(left: 10, right: 10),
//               child: Column(
//                 children: [
//                   SizedBox(
//                       height: 45,
//                       child: TextFormField(
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           hintText: "Select Tools",
//                           hintStyle: const TextStyle(
//                               color: Color.fromARGB(255, 35, 105, 172),
//                               fontSize: 18),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                         onTap: () {
//                           multiselectionDropdown(context, state, blocprovider);
//                         },
//                       )),
//                   SizedBox(
//                     height: 65,
//                     child: ListView.builder(
//                       itemCount: state.selectedtoollist.length,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.only(
//                               left: 10, top: 10, bottom: 10),
//                           decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 99, 160, 209),
//                               border: Border.all(
//                                 color: const Color.fromARGB(238, 165, 203, 218),
//                                 width: 1,
//                                 style: BorderStyle.solid,
//                               ),
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Row(
//                             children: [
//                               Container(
//                                 height: 70,
//                                 margin: const EdgeInsets.only(left: 10),
//                                 child: Center(
//                                   child: Text(
//                                     state.selectedtoollist[index].toolname
//                                         .toString(),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                   onPressed: () {
//                                     selectedtoollist.removeWhere((element) =>
//                                         element.id ==
//                                         state.selectedtoollist[index].id);
//                                     blocprovider.add(OperatorScreenEvent(
//                                         state.selectedItems,
//                                         state.settingtime,
//                                         state.startproductiontime,
//                                         state.okqty,
//                                         selectedtoollist,
//                                         state.barcode,
//                                         arguments['machinedata'],
//                                         state.rejqty,
//                                         ''));
//                                   },
//                                   icon: const Icon(Icons.cancel))
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   )
//                 ],
//               ));
//         } else {
//           return const Text(" ");
//         }
//       },
//     );
//   }

//   SizedBox fillokqtytextformfild(OperatorManualState state,
//       BuildContext context, OperatorManualScreenBloc blocprovider) {
//     return SizedBox(
//         width: SizeConfig.blockSizeHorizontal! * 20,
//         child: TextFormField(
//           readOnly: true,
//           controller: TextEditingController(
//               text: state is OperatorManualLoadingState && state.okqty != 0
//                   ? state.okqty.toString()
//                   : ''),
//           decoration: InputDecoration(
//               hintText: "Fill OK Qty",
//               hintStyle: AppTheme.tableRowTextStyle()
//                   .copyWith(color: Colors.grey, fontWeight: FontWeight.w200),
//               filled: true,
//               fillColor: Colors.white,
//               suffixIcon: IconButton(
//                 icon: const Icon(
//                   size: 30,
//                   Icons.edit,
//                   color: Colors.blue,
//                 ),
//                 onPressed: () {
//                   if (state is OperatorManualLoadingState) {
//                     showDialog(
//                         barrierDismissible: false,
//                         context: context,
//                         builder: (context) {
//                           TextEditingController textEditingController =
//                               TextEditingController(text: '0');
//                           return AlertDialog(
//                             title: const Center(child: Text("Quantity")),
//                             content: TextField(
//                               keyboardType: TextInputType.number,
//                               controller: textEditingController,
//                               decoration: const InputDecoration(
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 0.5)),
//                                   enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 0.5)),
//                                   border: InputBorder.none),
//                             ),
//                             actions: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   SizedBox(
//                                     width: 100,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         try {
//                                           int okqty = int.parse(
//                                               textEditingController.text);
//                                           FocusScope.of(context).unfocus();
//                                           Future.delayed(
//                                               const Duration(milliseconds: 500),
//                                               () {
//                                             blocprovider.add(
//                                                 OperatorScreenEvent(
//                                                     state.selectedItems,
//                                                     state.settingtime,
//                                                     state.startproductiontime,
//                                                     okqty,
//                                                     state.selectedtoollist,
//                                                     state.barcode,
//                                                     arguments['machinedata'],
//                                                     state.rejqty,
//                                                     ''));

//                                             Navigator.of(context).pop();
//                                           });
//                                         } catch (e) {
//                                           debugPrint(e.toString());
//                                         }
//                                       },
//                                       style: AppTheme.roundedButtonStyle(),
//                                       child: const Text("OK"),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 100,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         try {
//                                           int okqty = int.parse(
//                                               textEditingController.text);
//                                           FocusScope.of(context).unfocus();
//                                           Future.delayed(
//                                               const Duration(milliseconds: 500),
//                                               () {
//                                             blocprovider.add(
//                                                 OperatorScreenEvent(
//                                                     state.selectedItems,
//                                                     state.settingtime,
//                                                     state.startproductiontime,
//                                                     okqty,
//                                                     state.selectedtoollist,
//                                                     state.barcode,
//                                                     arguments['machinedata'],
//                                                     state.rejqty,
//                                                     ''));

//                                             Navigator.of(context).pop();
//                                           });
//                                         } catch (e) {
//                                           debugPrint(e.toString());
//                                         }
//                                       },
//                                       style: AppTheme.roundedButtonStyle(),
//                                       child: const Text("Cancel"),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           );
//                         });
//                     blocprovider.add(OperatorScreenEvent(
//                         state.selectedItems,
//                         state.settingtime,
//                         state.startproductiontime,
//                         state.okqty,
//                         state.selectedtoollist,
//                         state.barcode,
//                         arguments['machinedata'],
//                         state.rejqty,
//                         ''));
//                   }
//                 },
//               ),
//               border: InputBorder.none,
//               enabledBorder:
//                   const OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
//               focusedBorder:
//                   const OutlineInputBorder(borderSide: BorderSide(width: 0.5))),
//         ));
//   }

//   SizedBox rejectqtyTextFormfild(OperatorManualState state,
//       BuildContext context, OperatorManualScreenBloc blocprovider) {
//     return SizedBox(
//         width: SizeConfig.blockSizeHorizontal! * 20,
//         child: TextFormField(
//           readOnly: true,
//           controller: TextEditingController(
//               text: state is OperatorManualLoadingState && state.rejqty != 0
//                   ? state.rejqty.toString()
//                   : ''),
//           decoration: InputDecoration(
//               hintText: "Fill Reject Qty",
//               hintStyle: AppTheme.tableRowTextStyle()
//                   .copyWith(color: Colors.grey, fontWeight: FontWeight.w200),
//               filled: true,
//               fillColor: Colors.white,
//               suffixIcon: IconButton(
//                 icon: const Icon(
//                   size: 30,
//                   Icons.edit,
//                   color: Colors.blue,
//                 ),
//                 onPressed: () {
//                   if (state is OperatorManualLoadingState) {
//                     showDialog(
//                         barrierDismissible: true,
//                         context: context,
//                         builder: (context) {
//                           TextEditingController textEditingController =
//                               TextEditingController(text: '0');
//                           return AlertDialog(
//                             title: const Center(child: Text("Reject Quantity")),
//                             content: TextField(
//                               keyboardType: TextInputType.number,
//                               controller: textEditingController,
//                               decoration: const InputDecoration(
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 0.5)),
//                                   enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 0.5)),
//                                   border: InputBorder.none),
//                             ),
//                             actions: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   SizedBox(
//                                     width: 100,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         try {
//                                           int rejqty = int.parse(
//                                               textEditingController.text);
//                                           FocusScope.of(context).unfocus();

//                                           Future.delayed(
//                                               const Duration(milliseconds: 500),
//                                               () {
//                                             blocprovider.add(
//                                                 OperatorScreenEvent(
//                                                     state.selectedItems,
//                                                     state.settingtime,
//                                                     state.startproductiontime,
//                                                     state.okqty,
//                                                     state.selectedtoollist,
//                                                     state.barcode,
//                                                     arguments['machinedata'],
//                                                     rejqty,
//                                                     ''));

//                                             Navigator.of(context).pop();
//                                           });
//                                         } catch (e) {
//                                           debugPrint(e.toString());
//                                         }
//                                       },
//                                       style: AppTheme.roundedButtonStyle(),
//                                       child: const Text("OK"),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 100,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         try {
//                                           int rejqty = int.parse(
//                                               textEditingController.text);
//                                           FocusScope.of(context).unfocus();
//                                           Future.delayed(
//                                               const Duration(milliseconds: 500),
//                                               () {
//                                             blocprovider.add(
//                                                 OperatorScreenEvent(
//                                                     state.selectedItems,
//                                                     state.settingtime,
//                                                     state.startproductiontime,
//                                                     state.okqty,
//                                                     state.selectedtoollist,
//                                                     state.barcode,
//                                                     arguments['machinedata'],
//                                                     rejqty,
//                                                     ''));

//                                             Navigator.of(context).pop();
//                                           });
//                                         } catch (e) {
//                                           debugPrint(e.toString());
//                                         }
//                                       },
//                                       style: AppTheme.roundedButtonStyle(),
//                                       child: const Text("Cancel"),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           );
//                         });
//                     blocprovider.add(OperatorScreenEvent(
//                         state.selectedItems,
//                         state.settingtime,
//                         state.startproductiontime,
//                         state.okqty,
//                         state.selectedtoollist,
//                         state.barcode,
//                         arguments['machinedata'],
//                         state.rejqty,
//                         ''));
//                   }
//                 },
//               ),
//               border: InputBorder.none,
//               enabledBorder:
//                   const OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
//               focusedBorder:
//                   const OutlineInputBorder(borderSide: BorderSide(width: 0.5))),
//         ));
//   }

//   Future<dynamic> multiselectionDropdown(BuildContext context,
//       OperatorManualLoadingState state, OperatorManualScreenBloc blocprovider) {
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) {
//           List<Tools> searchableToollist = state.toollist;
//           StreamController<List<Tools>> seletedtoollistcontroller =
//               StreamController<List<Tools>>.broadcast();
//           StreamController<List<Tools>> matchedTools =
//               StreamController<List<Tools>>.broadcast();
//           StreamController<bool> searchtoollistcontroller =
//               StreamController<bool>.broadcast();
//           return AlertDialog(
//             title: StreamBuilder<bool>(
//                 stream: searchtoollistcontroller.stream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     if (snapshot.data == true) {
//                       return TextFormField(
//                         decoration:
//                             const InputDecoration(hintText: "Search Tool"),
//                         onChanged: (value) {
//                           List<Tools> matchedItems = [];

//                           matchedItems = searchableToollist.where((item) {
//                             String itemString =
//                                 item.toolname.toString().toLowerCase();
//                             String searchValue = value.toLowerCase();

//                             return itemString.contains(searchValue);
//                           }).toList();

//                           matchedTools.add(matchedItems);
//                         },
//                       );
//                     }
//                   }
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Tool List'),
//                       IconButton(
//                           onPressed: () {
//                             searchtoollistcontroller.add(true);
//                           },
//                           icon: const Icon(Icons.search))
//                     ],
//                   );
//                 }),
//             content: SizedBox(
//                 height: 350,
//                 width: 550,
//                 child: StreamBuilder<List<Tools>>(
//                     stream: matchedTools.stream,
//                     builder: (context, snapshot) {
//                       List<Tools> toolsDataList = [];
//                       if (snapshot.data != null) {
//                         toolsDataList = snapshot.data!;
//                       } else {
//                         toolsDataList = state.toollist;
//                       }
//                       return ListView.builder(
//                         itemCount: toolsDataList.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             trailing: StreamBuilder<List<Tools>>(
//                                 stream: seletedtoollistcontroller.stream,
//                                 builder: (context, snapshot) {
//                                   return Checkbox(
//                                     value: selectedtoollist.any((tool) =>
//                                         tool.id == toolsDataList[index].id),
//                                     onChanged: (value) {
//                                       if (value == true) {
//                                         selectedtoollist.add(Tools(
//                                             id: toolsDataList[index].id,
//                                             toolname:
//                                                 toolsDataList[index].toolname));
//                                       } else {
//                                         selectedtoollist.removeWhere(
//                                             (element) =>
//                                                 element.id ==
//                                                 toolsDataList[index].id);
//                                       }
//                                       seletedtoollistcontroller
//                                           .add(selectedtoollist);
//                                       blocprovider.add(OperatorScreenEvent(
//                                           state.selectedItems,
//                                           state.settingtime,
//                                           state.startproductiontime,
//                                           state.okqty,
//                                           selectedtoollist,
//                                           state.barcode,
//                                           arguments['machinedata'],
//                                           state.rejqty,
//                                           ''));
//                                     },
//                                   );
//                                 }),
//                             title:
//                                 Text(toolsDataList[index].toolname.toString()),
//                           );
//                         },
//                       );
//                     })),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     FocusScope.of(context).unfocus();
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       searchtoollistcontroller.close();

//                       seletedtoollistcontroller.close();
//                       Navigator.of(context).pop();
//                       blocprovider.add(OperatorScreenEvent(
//                           state.selectedItems,
//                           state.settingtime,
//                           state.startproductiontime,
//                           state.okqty,
//                           selectedtoollist,
//                           state.barcode,
//                           arguments['machinedata'],
//                           state.rejqty,
//                           ''));
//                     });
//                   },
//                   child: const Text('Cancel')),
//               TextButton(
//                   onPressed: () {
//                     FocusScope.of(context).unfocus();
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       searchtoollistcontroller.close();

//                       seletedtoollistcontroller.close();
//                       Navigator.of(context).pop();
//                       blocprovider.add(OperatorScreenEvent(
//                           state.selectedItems,
//                           state.settingtime,
//                           state.startproductiontime,
//                           state.okqty,
//                           selectedtoollist,
//                           state.barcode,
//                           arguments['machinedata'],
//                           state.rejqty,
//                           ''));
//                     });
//                   },
//                   child: const Text('OK')),
//             ],
//           );
//         });
//   }

//   confirmEndProcess(
//       BuildContext context,
//       String productstatusid,
//       int oKquantity,
//       int rejectedquantity,
//       String rejectedReasons,
//       String productid,
//       String rmsissueid,
//       String employeeid,
//       String token,
//       String workcentreid,
//       String workstationid) {
//     StreamController<bool> isClickedController = StreamController<bool>();
//     AlertDialog alert = AlertDialog(
//       content: SizedBox(
//         height: 108,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 height: 50,
//                 margin: const EdgeInsets.only(top: 10),
//                 child: const Text(
//                   'Do you want to end Process?',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 )),
//             SizedBox(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                       decoration: BoxDecoration(
//                           color: AppColors.greenTheme,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: TextButton(
//                           onPressed: () async {
//                             await OperatorRepository().endProcess(
//                                 context,
//                                 productstatusid,
//                                 oKquantity,
//                                 rejectedquantity,
//                                 rejectedReasons,
//                                 productid,
//                                 rmsissueid,
//                                 employeeid,
//                                 token);

//                             isClickedController.add(true);
//                             navigationAfterFinalEndProduction(
//                                 context,
//                                 productstatusid,
//                                 productid,
//                                 rmsissueid,
//                                 workcentreid,
//                                 token);
//                           },
//                           child: const Text(
//                             'Yes',
//                             style: TextStyle(
//                                 color: AppColors.whiteTheme,
//                                 fontWeight: FontWeight.bold),
//                           ))),
//                   Container(
//                       decoration: BoxDecoration(
//                           color: AppColors.redTheme,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: TextButton(
//                           onPressed: () {
//                             isClickedController.add(false);
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text(
//                             'No',
//                             style: TextStyle(
//                                 color: AppColors.whiteTheme,
//                                 fontWeight: FontWeight.bold),
//                           )))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//     return isClickedController.stream.first;
//   }

//   navigationAfterFinalEndProduction(
//       BuildContext context,
//       String productstatusid,
//       String productid,
//       String rmsissueid,
//       String workcentreid,
//       String token) {
//     Navigator.of(context).pop();
//     AlertDialog alert = AlertDialog(
//       content: SizedBox(
//         height: 108,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 height: 50,
//                 margin: const EdgeInsets.only(top: 10),
//                 child: const Text(
//                   'Do you want to final end Production?',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 )),
//             SizedBox(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                       decoration: BoxDecoration(
//                           color: AppColors.redTheme,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: TextButton(
//                           onPressed: () async {
//                             for (int i = 0; i <= 1; i++) {
//                               Navigator.of(context).pop();
//                             }
//                             // Navigator.popAndPushNamed(
//                             //     context, RouteName.barcodeScan, arguments: {
//                             //   'machinedata': arguments['machinedata']
//                             // });
//                           },
//                           child: const Text(
//                             'Go back',
//                             style: TextStyle(
//                                 color: AppColors.whiteTheme,
//                                 fontWeight: FontWeight.bold),
//                           ))),
//                   Container(
//                       decoration: BoxDecoration(
//                           color: AppColors.greenTheme,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: TextButton(
//                           onPressed: () {
//                             for (int i = 0; i <= 1; i++) {
//                               Navigator.of(context).pop();
//                             }
//                             OperatorRepository().finalEndProduction(context,
//                                 productid,'', rmsissueid, workcentreid, token);
//                             Navigator.popAndPushNamed(
//                                 context, RouteName.barcodeScan, arguments: {
//                               'machinedata': arguments['machinedata']
//                             });
//                           },
//                           child: const Text(
//                             'Final End Inspection',
//                             style: TextStyle(
//                                 color: AppColors.whiteTheme,
//                                 fontWeight: FontWeight.bold),
//                           )))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
