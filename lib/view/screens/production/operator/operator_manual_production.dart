// ignore_for_file: use_build_context_synchronously, must_be_immutable, unnecessary_null_comparison

import 'dart:async';

// import 'package:de/services/session/user_login.dart';
import 'package:de/utils/responsive.dart';
// import 'package:de/view/screens/common/internet_connection.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/production/operator/bloc/operator_manual_production/operator_manual_production_bloc.dart';
import '../../../../bloc/production/operator/bloc/operator_manual_production/operator_manual_production_event.dart';
import '../../../../bloc/production/operator/bloc/operator_manual_production/operator_manual_production_state.dart';
// import '../../../../routes/route_names.dart';
import '../../../../services/model/operator/oprator_models.dart';
import '../../../../services/repository/operator/operator_repository.dart';
import '../../../../services/repository/product/product_machine_route_repository.dart';
import '../../../../services/repository/quality/quality_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/barcode_session.dart';
import '../../common/documents.dart';

class OperatorManualProduction extends StatelessWidget {
  OperatorManualProduction({
    super.key,
    required this.arguments,
  });
  final Map<String, dynamic> arguments;
  String rejresonselect = '';
  @override
  Widget build(BuildContext context) {
    // debugPrint('build');
    Barcode? barcode = arguments['barcode'];
    final blocprovider = BlocProvider.of<OMPBloc>(context);
    blocprovider.add(
        OMPEvent([], '', '', 0, barcode!, arguments['machinedata'], 0, ''));
    // blocprovider.add(OMPEvent(selectedItems, '', '', 0, [], barcode!,
    //     arguments['machinedata'], 0, ''));
    return Scaffold(
        appBar: CustomAppbar()
            .appbar(context: context, title: "Operator Manual Production"),
        body: SafeArea(
          child: MakeMeResponsiveScreen(
            horixontaltab: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 253, 253, 253)),
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // decoration:  BoxDecoration(
                            //      borderRadius: BorderRadius.circular(10),
                            //     boxShadow: [
                            //       BoxShadow(
                            //           color: Colors.black.withOpacity(0.50),
                            //           spreadRadius: 5.0,
                            //           blurRadius: 8.0)
                            //     ],
                            //     color: Color.fromARGB(255, 194, 171, 171)),
                            child: BarcodeSession().barcodeData(
                                context: context,
                                parentWidth: 1300,
                                barcode: barcode),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Color.fromARGB(255, 50, 84, 100),
                    ),
                    pdfmodelbutton(),
                    revisionnumber(),
                    const Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Color.fromARGB(255, 50, 84, 100),
                    ),
                    startbutton(blocprovider),
                    BlocBuilder<OMPBloc, OMPState>(
                      builder: (context, state) {
                        return Container(
                          width: SizeConfig.screenWidth,
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // fillokqtytextformfild(
                              //     state, context, blocprovider),
                              QuickFixUi.horizontalSpace(width: 21),
                              Container(
                                height: 58,
                                width: SizeConfig.blockSizeHorizontal! * 20,
                                decoration: QuickFixUi()
                                    .borderContainer(borderThickness: 0.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: BlocBuilder<OMPBloc, OMPState>(
                                    builder: (context, state) {
                                      if (state is OMPLoadingState) {
                                        return TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            try {
                                              int okqty =
                                                  int.parse(value.toString());
                                              blocprovider.add(OMPEvent([],
                                                  state.settingtime,
                                                  state.startproductiontime,
                                                  okqty,
                                                  state.barcode,
                                                  arguments['machinedata'],
                                                  state.rejqty,
                                                  state.rejresons));
                                            } catch (e) {
                                              debugPrint("okqty not getting");
                                            }
                                          },
                                          onTap: () {
                                            blocprovider.add(OMPEvent([],
                                                state.settingtime,
                                                state.startproductiontime,
                                                state.okqty,
                                                state.barcode,
                                                arguments['machinedata'],
                                                state.rejqty,
                                                state.rejresons));
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Filled OK Qty',
                                            border: OutlineInputBorder(
                                              // Remove the underline
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Stack();
                                      }
                                    },
                                  ),
                                ),
                              ),

                              // rejectqtyTextFormfild(
                              //     state, context, blocprovider),
                              QuickFixUi.horizontalSpace(width: 21),
                              Container(
                                height: 58,
                                width: SizeConfig.blockSizeHorizontal! * 20,
                                decoration: QuickFixUi()
                                    .borderContainer(borderThickness: 0.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: BlocBuilder<OMPBloc, OMPState>(
                                    builder: (context, state) {
                                      if (state is OMPLoadingState) {
                                        return TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            try {
                                              int rejqty =
                                                  int.parse(value.toString());

                                              blocprovider.add(OMPEvent([],
                                                  state.settingtime,
                                                  state.startproductiontime,
                                                  state.okqty,
                                                  state.barcode,
                                                  arguments['machinedata'],
                                                  rejqty,
                                                  state.rejresons));
                                            } catch (e) {
                                              debugPrint("rejqty not getting");
                                            }
                                          },
                                          onTap: () {
                                            blocprovider.add(OMPEvent([],
                                                state.settingtime,
                                                state.startproductiontime,
                                                state.okqty,
                                                state.barcode,
                                                arguments['machinedata'],
                                                state.rejqty,
                                                state.rejresons));
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Filled Reject Qty',
                                            border: OutlineInputBorder(
                                              // Remove the underline
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Stack();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              // SizedBox(
                              //   width: SizeConfig.blockSizeHorizontal! * 20,
                              //   child: DropdownSearch<OperatorRejectedReasons>(
                              //     items: state is OMPLoadingState
                              //         ? state.operatorrejresons
                              //         : [],
                              //     itemAsString: (item) =>
                              //         item.rejectedreasons.toString(),
                              //     popupProps: const PopupProps.menu(
                              //         showSearchBox: true,
                              //         searchFieldProps: TextFieldProps(
                              //           style: TextStyle(fontSize: 18),
                              //         )),
                              //     dropdownDecoratorProps:
                              //         DropDownDecoratorProps(
                              //             dropdownSearchDecoration:
                              //                 InputDecoration(
                              //                     labelText: "Rejected reasons",
                              //                     border: OutlineInputBorder(
                              //                         borderRadius:
                              //                             BorderRadius.circular(
                              //                                 10)))),
                              //     onChanged: (value) {
                              //       rejresonselect = '';

                              //       if (state is OMPLoadingState) {
                              //         if (state.rejqty == 0) {
                              //           return QuickFixUi.errorMessage(
                              //               'Reject Qty is empty', context);
                              //         } else {
                              //           if (state.rejqty > 0) {
                              //             rejresonselect = value!.id.toString();

                              //             blocprovider.add(OMPEvent([],
                              //                 state.settingtime,
                              //                 state.startproductiontime,
                              //                 state.okqty,
                              //                 state.barcode,
                              //                 arguments['machinedata'],
                              //                 state.rejqty,
                              //                 rejresonselect));
                              //             debugPrint(rejresonselect);
                              //           }
                              //         }
                              //       }
                              //     },
                              //   ),
                              // ),

                              rejectedReasonsDropdown(
                                blocprovider: blocprovider,
                                barcode: barcode,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    endprocessButton(blocprovider, barcode: barcode),
                    // BlocBuilder<OMPBloc, OMPState>(
                    //   builder: (context, state) {
                    //     return Container(
                    //         margin: const EdgeInsets.only(top: 50),
                    //         width: SizeConfig.screenWidth,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             SizedBox(
                    //               width: 200,
                    //               height: 50,
                    //               child: DebouncedButton(
                    //                 onPressed: () async {
                    //                   if (state is OperatorManualLoadingState) {
                    //                     if (state.settingtime == null &&
                    //                             state.getpreviousproductiontime[
                    //                                     'startprocesstime'] !=
                    //                                 null ||
                    //                         state.settingtime != null &&
                    //                             state.getpreviousproductiontime[
                    //                                     'startprocesstime'] ==
                    //                                 null) {
                    //                       return QuickFixUi.errorMessage(
                    //                           ' Startsetting first', context);
                    //                     } else if (state.getpreviousproductiontime[
                    //                                     'startproductiontime'] ==
                    //                                 null &&
                    //                             state.startproductiontime !=
                    //                                 null ||
                    //                         state.getpreviousproductiontime[
                    //                                     'startproductiontime'] !=
                    //                                 null &&
                    //                             state.startproductiontime ==
                    //                                 null) {
                    //                       return QuickFixUi.errorMessage(
                    //                           'start prodution first.',
                    //                           context);
                    //                     } else if (state
                    //                             .selectedItems.isEmpty ||
                    //                         state.selectedtoollist.isEmpty) {
                    //                       return QuickFixUi.errorMessage(
                    //                           'Select Process and Tools',
                    //                           context);
                    //                     } else if (state.okqty == 0) {
                    //                       return QuickFixUi.errorMessage(
                    //                           'fill Ok Qty', context);
                    //                     } else if (state.rejqty > 0 &&
                    //                         toolselectItem.isEmpty) {
                    //                       return QuickFixUi.errorMessage(
                    //                           'Please Choose Reject Reasons',
                    //                           context);
                    //                     } else {
                    //                       List<String> selecttool = [];
                    //                       for (var data
                    //                           in state.selectedtoollist) {
                    //                         selecttool.add(data.id.toString());
                    //                       }
                    //                       await confirmEndProcess(
                    //                           context,
                    //                           state.productionstatusid,
                    //                           state.okqty,
                    //                           state.rejqty,
                    //                           toolselectItem.toString(),
                    //                           state.barcode.productid
                    //                               .toString(),
                    //                           state.barcode.rawmaterialissueid
                    //                               .toString(),
                    //                           state.employeeID,
                    //                           state.token,
                    //                           state.workcentreid,
                    //                           state.workstationid);
                    //                     }
                    //                   }
                    //                 },
                    //                 text: 'End Process',
                    //                 style: ButtonStyle(
                    //                     textStyle: MaterialStateProperty
                    //                         .resolveWith((states) =>
                    //                             AppTheme.mobileTextStyle())),
                    //               ),
                    //             )
                    //           ],
                    //         ));
                    //   },
                    // ),
                  ],
                )),
          ),
        ));
  }

  // SizedBox fillokqtytextformfild(
  //     OMPState state, BuildContext context, OMPBloc blocprovider) {
  //   return SizedBox(
  //       width: SizeConfig.blockSizeHorizontal! * 20,
  //       child: TextFormField(
  //         readOnly: true,
  //         controller: TextEditingController(
  //             text: state is OMPLoadingState && state.okqty != 0
  //                 ? state.okqty.toString()
  //                 : ''),
  //         decoration: InputDecoration(
  //             hintText: "Fill OK Qty",
  //             hintStyle: AppTheme.tableRowTextStyle()
  //                 .copyWith(color: Colors.grey, fontWeight: FontWeight.w200),
  //             filled: true,
  //             fillColor: Colors.white,
  //             suffixIcon: IconButton(
  //               icon: const Icon(
  //                 size: 30,
  //                 Icons.edit,
  //                 color: Colors.blue,
  //               ),
  //               onPressed: () {
  //                 if (state is OMPLoadingState) {
  //                   showDialog(
  //                       barrierDismissible: false,
  //                       context: context,
  //                       builder: (context) {
  //                         TextEditingController textEditingController =
  //                             TextEditingController(text: '0');
  //                         return AlertDialog(
  //                           title: const Center(child: Text("Quantity")),
  //                           content: TextField(
  //                             keyboardType: TextInputType.number,
  //                             controller: textEditingController,
  //                             decoration: const InputDecoration(
  //                                 focusedBorder: OutlineInputBorder(
  //                                     borderSide: BorderSide(width: 0.5)),
  //                                 enabledBorder: OutlineInputBorder(
  //                                     borderSide: BorderSide(width: 0.5)),
  //                                 border: InputBorder.none),
  //                           ),
  //                           actions: [
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceEvenly,
  //                               children: [
  //                                 SizedBox(
  //                                   width: 100,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       try {
  //                                         int okqty = int.parse(
  //                                             textEditingController.text);
  //                                         FocusScope.of(context).unfocus();
  //                                         Future.delayed(
  //                                             const Duration(milliseconds: 500),
  //                                             () {
  //                                           // blocprovider.add(
  //                                           //     OMPEvent(
  //                                           //         state.selectedItems,
  //                                           //         state.settingtime,
  //                                           //         state.startproductiontime,
  //                                           //         okqty,
  //                                           //         state.selectedtoollist,
  //                                           //         state.barcode,
  //                                           //         arguments['machinedata'],
  //                                           //         state.rejqty,
  //                                           //         ''));

  //                                           Navigator.of(context).pop();
  //                                         });
  //                                       } catch (e) {
  //                                         debugPrint(e.toString());
  //                                       }
  //                                     },
  //                                     style: AppTheme.roundedButtonStyle(),
  //                                     child: const Text("OK"),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 100,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       try {
  //                                         int okqty = int.parse(
  //                                             textEditingController.text);
  //                                         FocusScope.of(context).unfocus();
  //                                         Future.delayed(
  //                                             const Duration(milliseconds: 500),
  //                                             () {
  //                                           // blocprovider.add(
  //                                           //     OMPEvent(
  //                                           //         state.selectedItems,
  //                                           //         state.settingtime,
  //                                           //         state.startproductiontime,
  //                                           //         okqty,
  //                                           //         state.selectedtoollist,
  //                                           //         state.barcode,
  //                                           //         arguments['machinedata'],
  //                                           //         state.rejqty,
  //                                           //         ''));

  //                                           Navigator.of(context).pop();
  //                                         });
  //                                       } catch (e) {
  //                                         debugPrint(e.toString());
  //                                       }
  //                                     },
  //                                     style: AppTheme.roundedButtonStyle(),
  //                                     child: const Text("Cancel"),
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           ],
  //                         );
  //                       });
  //                   // blocprovider.add(OMPEvent(
  //                   //     state.selectedItems,
  //                   //     state.settingtime,
  //                   //     state.startproductiontime,
  //                   //     state.okqty,
  //                   //     state.selectedtoollist,
  //                   //     state.barcode,
  //                   //     arguments['machinedata'],
  //                   //     state.rejqty,
  //                   //     ''));
  //                 }
  //               },
  //             ),
  //             border: InputBorder.none,
  //             enabledBorder:
  //                 const OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
  //             focusedBorder:
  //                 const OutlineInputBorder(borderSide: BorderSide(width: 0.5))),
  //       ));
  // }

  // SizedBox rejectqtyTextFormfild(
  //     OMPState state, BuildContext context, OMPBloc blocprovider) {
  //   return SizedBox(
  //       width: SizeConfig.blockSizeHorizontal! * 20,
  //       child: TextFormField(
  //         readOnly: true,
  //         controller: TextEditingController(
  //             text: state is OMPLoadingState && state.rejqty != 0
  //                 ? state.rejqty.toString()
  //                 : ''),
  //         decoration: InputDecoration(
  //             hintText: "Fill Reject Qty",
  //             hintStyle: AppTheme.tableRowTextStyle()
  //                 .copyWith(color: Colors.grey, fontWeight: FontWeight.w200),
  //             filled: true,
  //             fillColor: Colors.white,
  //             suffixIcon: IconButton(
  //               icon: const Icon(
  //                 size: 30,
  //                 Icons.edit,
  //                 color: Colors.blue,
  //               ),
  //               onPressed: () {
  //                 if (state is OMPLoadingState) {
  //                   showDialog(
  //                       barrierDismissible: true,
  //                       context: context,
  //                       builder: (context) {
  //                         TextEditingController textEditingController =
  //                             TextEditingController(text: '0');
  //                         return AlertDialog(
  //                           title: const Center(child: Text("Reject Quantity")),
  //                           content: TextField(
  //                             keyboardType: TextInputType.number,
  //                             controller: textEditingController,
  //                             decoration: const InputDecoration(
  //                                 focusedBorder: OutlineInputBorder(
  //                                     borderSide: BorderSide(width: 0.5)),
  //                                 enabledBorder: OutlineInputBorder(
  //                                     borderSide: BorderSide(width: 0.5)),
  //                                 border: InputBorder.none),
  //                           ),
  //                           actions: [
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceEvenly,
  //                               children: [
  //                                 SizedBox(
  //                                   width: 100,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       try {
  //                                         int rejqty = int.parse(
  //                                             textEditingController.text);
  //                                         FocusScope.of(context).unfocus();

  //                                         Future.delayed(
  //                                             const Duration(milliseconds: 500),
  //                                             () {
  //                                           // blocprovider.add(
  //                                           //     OperatorScreenEvent(
  //                                           //         state.selectedItems,
  //                                           //         state.settingtime,
  //                                           //         state.startproductiontime,
  //                                           //         state.okqty,
  //                                           //         state.selectedtoollist,
  //                                           //         state.barcode,
  //                                           //         arguments['machinedata'],
  //                                           //         rejqty,
  //                                           //         ''));

  //                                           Navigator.of(context).pop();
  //                                         });
  //                                       } catch (e) {
  //                                         debugPrint(e.toString());
  //                                       }
  //                                     },
  //                                     style: AppTheme.roundedButtonStyle(),
  //                                     child: const Text("OK"),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 100,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       try {
  //                                         int rejqty = int.parse(
  //                                             textEditingController.text);
  //                                         FocusScope.of(context).unfocus();
  //                                         Future.delayed(
  //                                             const Duration(milliseconds: 500),
  //                                             () {
  //                                           // blocprovider.add(
  //                                           //     OperatorScreenEvent(
  //                                           //         state.selectedItems,
  //                                           //         state.settingtime,
  //                                           //         state.startproductiontime,
  //                                           //         state.okqty,
  //                                           //         state.selectedtoollist,
  //                                           //         state.barcode,
  //                                           //         arguments['machinedata'],
  //                                           //         rejqty,
  //                                           //         ''));

  //                                           Navigator.of(context).pop();
  //                                         });
  //                                       } catch (e) {
  //                                         debugPrint(e.toString());
  //                                       }
  //                                     },
  //                                     style: AppTheme.roundedButtonStyle(),
  //                                     child: const Text("Cancel"),
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           ],
  //                         );
  //                       });
  //                   // blocprovider.add(OperatorScreenEvent(
  //                   //     state.selectedItems,
  //                   //     state.settingtime,
  //                   //     state.startproductiontime,
  //                   //     state.okqty,
  //                   //     state.selectedtoollist,
  //                   //     state.barcode,
  //                   //     arguments['machinedata'],
  //                   //     state.rejqty,
  //                   //     ''));
  //                 }
  //               },
  //             ),
  //             border: InputBorder.none,
  //             enabledBorder:
  //                 const OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
  //             focusedBorder:
  //                 const OutlineInputBorder(borderSide: BorderSide(width: 0.5))),
  //       ));
  // }

  BlocBuilder<OMPBloc, OMPState> rejectedReasonsDropdown(
      {required OMPBloc blocprovider, required Barcode barcode}) {
    return BlocBuilder<OMPBloc, OMPState>(
      builder: (context, state) {
        if (state is OMPLoadingState && state.rejqty > 0) {
          return SizedBox(
            width: SizeConfig.blockSizeHorizontal! * 21,
            child: DropdownSearch<OperatorRejectedReasons>(
              items:
                  // ignore: unnecessary_type_check
                  state is OMPLoadingState ? state.operatorrejresons : [],
              itemAsString: (item) => item.rejectedreasons.toString(),
              popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    style: TextStyle(fontSize: 16),
                  )),
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      labelText: "Rejected reasons",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              onChanged: (value) {
                rejresonselect = value!.id.toString();

                blocprovider.add(OMPEvent([],
                    state.settingtime,
                    state.startproductiontime,
                    state.okqty,
                    state.barcode,
                    arguments['machinedata'],
                    state.rejqty,
                    rejresonselect));
              },
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<OMPBloc, OMPState> endprocessButton(OMPBloc blockprovider,
      {required Barcode barcode}) {
    return BlocBuilder<OMPBloc, OMPState>(
      builder: (context, state) {
        if (state is OMPLoadingState) {
          return Container(
              width: SizeConfig.screenWidth,
              // height: 45,
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: FilledButton(
                        onPressed: () async {
                          if (state.settingtime == null &&
                                  state.getpreviousproductiontime[
                                          'startprocesstime'] !=
                                      null ||
                              state.settingtime != null &&
                                  state.getpreviousproductiontime[
                                          'startprocesstime'] ==
                                      null) {
                            return QuickFixUi.errorMessage(
                                ' Startsetting first', context);
                          } else if (state.getpreviousproductiontime[
                                          'startproductiontime'] ==
                                      null &&
                                  state.startproductiontime != null ||
                              state.getpreviousproductiontime[
                                          'startproductiontime'] !=
                                      null &&
                                  state.startproductiontime == null) {
                            return QuickFixUi.errorMessage(
                                'start prodution first.', context);
                          }
                          //else if (state
                          //         .selectedItems.isEmpty ||
                          //     state.selectedtoollist.isEmpty) {
                          //   return QuickFixUi.errorMessage(
                          //       'Select Process and Tools',
                          //       context);
                          // }
                          else if (state.okqty == 0) {
                            return QuickFixUi.errorMessage(
                                'fill Ok Qty', context);
                          } else if (state.rejqty > 0 &&
                              state.rejresons.isEmpty) {
                            return QuickFixUi.errorMessage(
                                'Please Choose Reject Reasons', context);
                          } else {
                            // List<String> selecttool = [];
                            // for (var data in state.selectedtoollist) {
                            //   selecttool.add(data.id.toString());
                            // }
                            await confirmEndProcess(
                              blockprovider,
                              context,
                              state.productionstatusid,
                              state.okqty,
                              state.rejqty,
                              state.rejresons,
                              state.token,
                              state,
                              barcode,
                            );
                            // debugPrint("end process button press");
                            // debugPrint(state.okqty.toString());
                            // debugPrint(state.rejresons.toString());
                          }
                        },
                        child: const Text(
                          'End Process',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                  ),
                ],
              ));
        } else {
          return const Stack();
        }
      },
    );
  }

  confirmEndProcess(
      OMPBloc blockprovider,
      BuildContext context,
      String productstatusid,
      int oKquantity,
      int rejectedquantity,
      String rejectedReasons,
      String token,
      state,
      Barcode barcode) {
    StreamController<bool> isClickedController = StreamController<bool>();
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 108,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  'Do you want to end Process?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: AppColors.greenTheme,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          onPressed: () async {
                            await OperatorRepository().ompendProcess(
                                context,
                                productstatusid,
                                oKquantity,
                                rejectedquantity,
                                rejectedReasons,
                                token);

                            isClickedController.add(true);
                            navigationAfterFinalEndProduction(
                                blockprovider, context, state, token, barcode);
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                                color: AppColors.whiteTheme,
                                fontWeight: FontWeight.bold),
                          ))),
                  Container(
                      decoration: BoxDecoration(
                          color: AppColors.redTheme,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          onPressed: () {
                            isClickedController.add(false);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                                color: AppColors.whiteTheme,
                                fontWeight: FontWeight.bold),
                          )))
                ],
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return isClickedController.stream.first;
  }

  navigationAfterFinalEndProduction(OMPBloc blockprovider, BuildContext context,
      state, String token, Barcode barcode) {
    Navigator.of(context).pop();
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 108,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  'Do you want to final end Production?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: AppColors.redTheme,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          onPressed: () async {
                            for (int i = 0; i <= 1; i++) {
                              Navigator.of(context).pop();
                            }
                            // Navigator.popAndPushNamed(
                            //     context, RouteName.barcodeScan, arguments: {
                            //   'machinedata': arguments['machinedata']
                            // });
                          },
                          child: const Text(
                            'Go back',
                            style: TextStyle(
                                color: AppColors.whiteTheme,
                                fontWeight: FontWeight.bold),
                          ))),
                  Container(
                      decoration: BoxDecoration(
                          color: AppColors.greenTheme,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          onPressed: () async {
                            for (int i = 0; i <= 1; i++) {
                              Navigator.of(context).pop();
                            }
                            if (state is OMPLoadingState) {
                              await OperatorRepository().ompfinalEndProduction(
                                  context: context,
                                  productid: barcode.productid.toString(),
                                  revisionno: barcode.revisionnumber.toString(),
                                  rmsid: barcode.rawmaterialissueid.toString(),
                                  wcid: state.workcentreid,
                                  token: state.token);
                            }
                          },
                          child: const Text(
                            'Final End Inspection',
                            style: TextStyle(
                                color: AppColors.whiteTheme,
                                fontWeight: FontWeight.bold),
                          )))
                ],
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  BlocBuilder<OMPBloc, OMPState> pdfmodelbutton() {
    return BlocBuilder<OMPBloc, OMPState>(
      builder: (context, state) {
        if (state is OMPLoadingState) {
          return Documents().documentsButtons(
            context: context,
            alignment: Alignment.center,
            topMargin: 15,
            token: state.token,
            pdfMdocId: state.pdfmdocid,
            product: state.barcode.product.toString(),
            // productid: state.barcode.productid.toString(),
            productDescription: state.productDescription,
            pdfRevisionNo: state.pdfRevisionNo,
            modelMdocId: state.modelMdocid,
            modelimageType: state.imageType,
            // machinename: ''
          );
        } else {
          return const Text('');
        }
      },
    );
  }

  BlocBuilder<OMPBloc, OMPState> revisionnumber() {
    return BlocBuilder<OMPBloc, OMPState>(builder: (context, state) {
      if (state is OMPLoadingState) {
        return Documents().horizontalVersions(
            context: context,
            topMargin: 15,
            pdfMdocId: state.pdfmdocid,
            pdfRevisionNo: state.pdfRevisionNo,
            modelMdocId: state.modelMdocid,
            modelRevisionNo: state.modelRevisionNumber,
            modelsDetails: state.modelsDetails,
            pdfDetails: state.pdfDetails,
            modelimageType: state.imageType,
            product: state.barcode.product.toString(),
            productDescription: state.productDescription,
            token: state.token);
      } else {
        return const Text('');
      }
    });
  }

  BlocBuilder<OMPBloc, OMPState> startbutton(OMPBloc blocprovider) {
    return BlocBuilder<OMPBloc, OMPState>(
      builder: (context, state) {
        return SizedBox(
          //  margin: const EdgeInsets.only(top: 10),
          width: SizeConfig.screenWidth,
          height: 100,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
                width: 180,
                height: 50,
                margin: EdgeInsets.zero,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state is OMPLoadingState &&
                              state.getpreviousproductiontime.isEmpty
                          ? (state.settingtime == ''
                              ? AppColors.startsettingbuttonColor
                              : AppColors.buttonDisableColor)
                          : AppColors.buttonDisableColor,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () async {
                      if (state is OMPLoadingState && state.settingtime == '') {
                        String settingtime = await QualityInspectionRepository()
                            .currentDatabaseTime(state.token);

                        blocprovider.add(OMPEvent([],
                            settingtime,
                            state.startproductiontime,
                            state.okqty,
                            state.barcode,
                            arguments['machinedata'],
                            state.rejqty,
                            state.rejresons));
                        await OperatorRepository.ompstartsettinginsert(
                            state.barcode.productid.toString(),
                            state.barcode.rawmaterialissueid.toString(),
                            state.workcentreid,
                            state.workstationid,
                            state.employeeID,
                            state.barcode.revisionnumber.toString(),
                            state.token,
                            context);

                        await ProductMachineRoute().registerProductMachineRoute(
                            token: state.token,
                            payload: {
                              'product_id': state.barcode.productid,
                              'product_revision': state.barcode.revisionnumber,
                              'workcentre_id': state.workcentreid,
                              'workstation_id': state.workstationid
                            });

                        // if (state.productRouteDetails.isEmpty) {
                        //   await OperatorRepository.createMachineProductRoute(
                        //     state.barcode.productid.toString(),
                        //     state.workcentreid,
                        //     state.workstationid,
                        //     state.productbomid['productBOMiD'].toString(),
                        //     state.barcode.revisionnumber.toString(),
                        //     state.token,
                        //     context,
                        //   );
                        // } else {
                        //   int nseqno = 0;
                        //   int ver = 0;

                        //   if (state.productRouteDetails['productid'] ==
                        //           state.barcode.productid.toString() &&
                        //       state.productRouteDetails['wcid'] !=
                        //           state.workcentreid &&
                        //       state.productRouteDetails['wcid'] !=
                        //           '4028817165f0a36c0165f0a95e1c0006') {
                        //     debugPrint("The values are not same of wc machine");
                        //     if (state.workcentreid ==
                        //         '4028817165f0a36c0165f0a89c410004') {
                        //       nseqno = 800;
                        //     } else if (state.workcentreid ==
                        //         '4028817165f0a36c0165f0a9020e0005') {
                        //       nseqno = 900;
                        //     } else if (state.workcentreid ==
                        //         '4028817165f0a36c0165f0a95e1c0006') {
                        //       nseqno = 1000;
                        //     } else {
                        //       nseqno = state.productRouteDetails['seqno'] + 10;
                        //     }

                        //     ver = state.productRouteDetails['Route_version'];
                        //     debugPrint(
                        //         "new diff seqno.....$ver/////>>>>>>>>>>>>>>>>>>>>");

                        //     ///create function here for revision route create
                        //     OperatorRepository
                        //         .createMachineProductRouteDiffSeqNo(
                        //       state.barcode.productid.toString(),
                        //       state.workcentreid,
                        //       state.workstationid,
                        //       state.productbomid['productBOMiD'].toString(),
                        //       state.barcode.revisionnumber.toString(),
                        //       nseqno,
                        //       ver,
                        //       state.token,
                        //       context,
                        //     );
                        //   } else if (state.productRouteDetails['productid'] ==
                        //           state.barcode.productid.toString() &&
                        //       state.productRouteDetails['wcid'] !=
                        //           state.workcentreid) {
                        //     debugPrint("previous workcenter is same");
                        //   } else if (state.productRouteDetails['productid'] ==
                        //           state.barcode.productid.toString() &&
                        //       state.productRouteDetails['wcid'] ==
                        //           '4028817165f0a36c0165f0a95e1c0006') {
                        //     if (state.workcentreid ==
                        //         '4028817165f0a36c0165f0a95e1c0006') {
                        //       debugPrint("First Product route complete");
                        //     } else if (state.productRouteDetails['wcid'] !=
                        //         state.workcentreid) {
                        //       int rversion =
                        //           state.productRouteDetails['Route_version'] +
                        //               1;

                        //       OperatorRepository
                        //           .createMachineProductRouteDiffRevision(
                        //         state.barcode.productid.toString(),
                        //         state.workcentreid,
                        //         state.workstationid,
                        //         state.productbomid['productBOMiD'].toString(),
                        //         state.barcode.revisionnumber.toString(),
                        //         rversion,
                        //         state.token,
                        //         context,
                        //       );
                        //       debugPrint(
                        //           "new version new route----------$rversion");
                        //     }
                        //   }
                        // }
                      }
                    },
                    child: const Text(
                      "Start Setting",
                    ))),
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 239, 239),
                    borderRadius: BorderRadius.circular(5)),
                height: SizeConfig.blockSizeVertical! * 7,
                width: SizeConfig.blockSizeHorizontal! * 19,
                child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        readOnly: true,
                        controller: TextEditingController(
                            text: state is OMPLoadingState &&
                                    state.getpreviousproductiontime['startprocesstime'] !=
                                        null
                                ? DateTime.parse(state.getpreviousproductiontime[
                                        'startprocesstime'])
                                    .toLocal()
                                    .toString()
                                : (state is OMPLoadingState &&
                                        state.settingtime != ''
                                    ? DateTime.parse(state.settingtime)
                                        .toLocal()
                                        .toString()
                                    : '')),
                        textAlign: TextAlign.center,
                        style: AppTheme.tabTextStyle()
                            .copyWith(color: Colors.black)))),
            Container(
                width: 180,
                height: 50,
                margin: EdgeInsets.zero,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state is OMPLoadingState &&
                              state.getpreviousproductiontime[
                                      'startproductiontime'] ==
                                  null
                          ? ((state.settingtime != '' ||
                                  state.getpreviousproductiontime[
                                              'startprocesstime'] !=
                                          null &&
                                      state.startproductiontime == '')
                              ? AppColors.startproductionbuttonColor
                              : AppColors.buttonDisableColor)
                          : AppColors.buttonDisableColor,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () async {
                      if (state is OMPLoadingState &&
                          state.startproductiontime == '' &&
                          (state.settingtime != '' ||
                              state.getpreviousproductiontime[
                                      'startprocesstime'] !=
                                  null)) {
                        String startproductiontime =
                            await QualityInspectionRepository()
                                .currentDatabaseTime(state.token);

                        blocprovider.add(OMPEvent([],
                            state.settingtime,
                            startproductiontime,
                            state.okqty,
                            state.barcode,
                            arguments['machinedata'],
                            state.rejqty,
                            state.rejresons));
                        OperatorRepository.updatestartproductionrecord(
                            state.barcode.productid.toString(),
                            state.barcode.rawmaterialissueid.toString(),
                            state.workcentreid,
                            state.workstationid,
                            state.employeeID,
                            state.token,
                            state.productionstatusid,
                            context);
                        blocprovider.add(OMPEvent([],
                            state.settingtime,
                            startproductiontime,
                            0,
                            state.barcode,
                            arguments['machinedata'],
                            state.rejqty,
                            ''));
                      } else {
                        return QuickFixUi.errorMessage(
                            "Start Setting First", context);
                      }
                    },
                    child: const Text(
                      "Start Production",
                    ))),
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 239, 239),
                    borderRadius: BorderRadius.circular(5)),
                height: SizeConfig.blockSizeVertical! * 8,
                width: SizeConfig.blockSizeHorizontal! * 20,
                child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        readOnly: true,
                        controller: TextEditingController(
                            text: state is OMPLoadingState &&
                                    state.getpreviousproductiontime['startproductiontime'] !=
                                        null
                                ? DateTime.parse(state.getpreviousproductiontime[
                                        'startproductiontime'])
                                    .toLocal()
                                    .toString()
                                : (state is OMPLoadingState &&
                                        state.startproductiontime != ''
                                    ? DateTime.parse(state.startproductiontime)
                                        .toLocal()
                                        .toString()
                                    : '')),
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.tabTextStyle().copyWith(color: Colors.black)))),
          ]),
        );
      },
    );
  }
}
