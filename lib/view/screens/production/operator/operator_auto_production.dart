// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:de/bloc/production/operator/bloc/operator_auto_production/operatorautoproduction_event.dart';
import 'package:de/utils/app_colors.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/production/operator/bloc/operator_auto_production/operatorautoproduction_bloc.dart';
import '../../../../bloc/production/operator/bloc/operator_auto_production/operatorautoproduction_state.dart';
import '../../../../services/model/operator/oprator_models.dart';
import '../../../../services/repository/operator/operator_repository.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/barcode_session.dart';
import '../../../widgets/production_automatic_docs.dart';
import '../../common/documents.dart';
// import '../../common/internet_connection.dart';

class OperatorAutoProduction extends StatelessWidget {
  const OperatorAutoProduction({super.key, required this.arguments});

  final Map<String, dynamic> arguments;
  // static String toolselectItem = '';
  static List<Tools> selectedtoollist = [];
  static Map<String, dynamic> productiontimedata = {};

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    String cprunnumber = arguments['cprunnumber'];
    String cpchildid = arguments['cpchildid'];
    final blocprovider = BlocProvider.of<OAPBloc>(context);
    blocprovider.add(OAPEvent(
        barcode: barcode!,
        machinedata: arguments['machinedata'],
        selectedtoollist: [],
        processrouteid: arguments['processrouteid'],
        seqno: arguments['seqno'],
        cprunnumber: cprunnumber,
        cpchildid: cpchildid,
        productionstatusid: ''));

    StreamController<String> okQtycontroller = StreamController<String>();
    final ApiClient apiClient = ApiClient();

    return
        // InternetConnectionCheck(
        //   widget:
        Scaffold(
            appBar: CustomAppbar()
                .appbar(context: context, title: "Operator AutoProduction"),
            body: mainUI(
                context, barcode, blocprovider, apiClient, okQtycontroller));
    // );
  }

  SafeArea mainUI(BuildContext context, Barcode barcode, OAPBloc blocprovider,
      ApiClient apiClient, StreamController<String> okQtycontroller) {
    TextEditingController okqty = TextEditingController();
    StreamController<int> rejqty = StreamController<int>.broadcast();
    TextEditingController rejresonsid = TextEditingController();

    // StreamController<List<Tools>> seletedtoollistcontroller =
    //     StreamController<List<Tools>>.broadcast();
    StreamController<List<Tools>> matchedTools =
        StreamController<List<Tools>>.broadcast();

    return SafeArea(
        child: MakeMeResponsiveScreen(
      horixontaltab: Container(
        decoration: const BoxDecoration(
            // color: Color.fromARGB(255, 253, 255, 255)
            ),
        child: ListView(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: BarcodeSession().barcodeData(
                          context: context,
                          parentWidth: 1300,
                          barcode: barcode),
                    ),
                  ],
                )),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color.fromARGB(255, 50, 84, 100),
            ),
            BlocConsumer<OAPBloc, OAPState>(listener: (context, state) {
              if (state is OAPLoadingState &&
                  state.isAlreadyEndProduction == true) {
                showDialog(
                  barrierDismissible: false,
                  barrierColor: Theme.of(context).colorScheme.surface,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(
                        "Final Production Done.",
                        style: TextStyle(
                          color: Color.fromARGB(255, 25, 25, 26),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      actions: [
                        FilledButton(
                            child: const Text('Go back'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  },
                );
              }
            }, builder: (context, state) {
              String instruction =
                  state is OAPLoadingState ? state.instruction : '';
              List<String> lines = instruction.split('\n');
              int numberOfLines = lines.length;
              int containerSize = 20;
              if (numberOfLines <= 3) {
                containerSize = 71;
              } else if (numberOfLines >= 4 && numberOfLines <= 5) {
                containerSize = 100;
              } else if (numberOfLines > 5) {
                containerSize = 150;
              }
              return Center(
                child: Container(
                  height: containerSize.toDouble(),
                  width: 1350,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 214, 231),
                      borderRadius: BorderRadius.only()),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 250,
                          ),
                          const Text(
                            "Sequance Number:   ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 25, 26),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            arguments['seqno'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 28, 29, 29),
                              //    fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          QuickFixUi.horizontalSpace(width: 51),
                          const Text(
                            "Process Instruction :   ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 8, 8, 8),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            //  width: 320,
                            // height: 30,
                            height: 150,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                state is OAPLoadingState
                                    ? state.instruction
                                    : '',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 20, 20, 20),
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          QuickFixUi.horizontalSpace(width: 51),
                        ],
                      )),
                ),
              );
            }),
            BlocBuilder<OAPBloc, OAPState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    width: 550,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(255, 36, 84, 112),
                        color: Color.fromARGB(255, 111, 146, 167),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25))),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 45,
                        ),
                        const Text(
                          "Production Started : ",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        SizedBox(
                            height: SizeConfig.blockSizeVertical! * 8,
                            width: SizeConfig.blockSizeHorizontal! * 20,
                            child: Align(
                                alignment: Alignment.center,
                                child: TextField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: state is OAPLoadingState
                                            ? state.getpreviousproductiontime
                                            : ''
                                        // text: state is OAPLoadingState &&
                                        //         (state.getpreviousproductiontime !=
                                        //                 '' ||
                                        //             state.getpreviousproductiontime !=
                                        //                 'null')
                                        //     ? DateTime.parse(state
                                        //             .getpreviousproductiontime)
                                        //         .toLocal()
                                        //         .toString()
                                        //     : state is OAPLoadingState &&
                                        //             state.settingtime != ''
                                        //         ? state.settingtime
                                        //         : ''
                                        ),
                                    textAlign: TextAlign.center,
                                    style: AppTheme.tabTextStyle()
                                        .copyWith(color: Colors.black)))),
                      ],
                    ),
                  ),
                );
              },
            ),
            pdfmodelbutton(),
            revisionnumber(),
            // selecttools(
            //     blocprovider: blocprovider,
            //     barcode: barcode,
            //     seletedtoollistcontroller: seletedtoollistcontroller,
            //     matchedTools: matchedTools),
            QuickFixUi.verticalSpace(height: 21),
            machineProductionStatus(
              apiClient: apiClient,
              barcode: barcode,
              okQtycontroller: okQtycontroller,
            ),
            QuickFixUi.verticalSpace(height: 21),
            operatorOKQTY(
                blocprovider: blocprovider,
                barcode: barcode,
                okqty: okqty,
                rejqty: rejqty,
                rejresonsid: rejresonsid),
            endprocessbutton(
                okqty: okqty,
                rejqty: rejqty,
                rejresonsid: rejresonsid,
                // seletedtoollistcontroller: seletedtoollistcontroller,
                matchedTools: matchedTools),
          ],
        ),
      ),
    ));
  }

  StreamBuilder<int> endprocessbutton(
      {required TextEditingController okqty,
      required StreamController<int> rejqty,
      required TextEditingController rejresonsid,
      // required StreamController<List<Tools>> seletedtoollistcontroller,
      required StreamController<List<Tools>> matchedTools}) {
    return StreamBuilder<int>(
        stream: rejqty.stream,
        builder: (context, snapshot) {
          return BlocBuilder<OAPBloc, OAPState>(
            builder: (context, state) {
              return Container(
                  margin: const EdgeInsets.only(top: 50),
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 60,
                        child: TextButton(
                          onPressed: () {
                            int newokqty =
                                okqty.text != '' ? int.parse(okqty.text) : 0;

                            String pcount = productiontimedata
                                    .containsKey('data')
                                ? productiontimedata['data'].length.toString()
                                : "0";

                            String productiontime =
                                productiontimedata.containsKey('productiontime')
                                    ? productiontimedata['productiontime']
                                        .toString()
                                    : "0";

                            String idletime =
                                productiontimedata.containsKey('idletime')
                                    ? productiontimedata['idletime'].toString()
                                    : "0";

                            String energyconsumed =
                                productiontimedata.containsKey('energyconsumed')
                                    ? productiontimedata['energyconsumed']
                                        .toStringAsFixed(2)
                                    : "0.00";

                            if (state is OAPLoadingState) {
                              if (newokqty <= 0) {
                                QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage: "Please fill OK QTY");
                              } else if (snapshot.data != null &&
                                  snapshot.data! > 0 &&
                                  rejresonsid.text == '') {
                                QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage:
                                        "Please select rejected reason");
                              } else {
                                confirmEndProcess(
                                    context: context,
                                    state: state,
                                    newrejqty: snapshot.data != null
                                        ? snapshot.data!
                                        : 0,
                                    okqty: okqty,
                                    rejqty: rejqty,
                                    rejresonsid: rejresonsid,
                                    producedcount: int.parse(pcount),
                                    productiontime: int.parse(productiontime),
                                    idletime: int.parse(idletime),
                                    energyconsumtion:
                                        double.parse(energyconsumed));
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 133, 166, 197),
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'End Process',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ));
            },
          );
        });
  }

  Row operatorOKQTY({
    required OAPBloc blocprovider,
    required Barcode barcode,
    required TextEditingController okqty,
    required StreamController<int> rejqty,
    required TextEditingController rejresonsid,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 58,
          width: SizeConfig.blockSizeHorizontal! * 20,
          decoration: QuickFixUi().borderContainer(borderThickness: 0.5),
          child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  okqty.text = value.toString();
                },
                decoration: const InputDecoration(
                  hintText: "OK QTY",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              )),
        ),
        QuickFixUi.horizontalSpace(width: 21),
        Container(
          height: 58,
          width: SizeConfig.blockSizeHorizontal! * 20,
          decoration: QuickFixUi().borderContainer(borderThickness: 0.5),
          child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.toString() == '0') {
                    rejresonsid.text = '';
                  }
                  try {
                    int qty = int.parse(value.toString());
                    rejqty.add(qty);
                  } catch (e) {
                    //
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Rejected QTY',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              )),
        ),
        QuickFixUi.horizontalSpace(width: 21),
        StreamBuilder<int>(
            stream: rejqty.stream,
            builder: (context, snapshot) {
              return BlocBuilder<OAPBloc, OAPState>(
                builder: (context, state) {
                  if (state is OAPLoadingState &&
                      snapshot.data != null &&
                      snapshot.data! > 0) {
                    return SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 21,
                      child: DropdownSearch<OperatorRejectedReasons>(
                        items:
                            // ignore: unnecessary_type_check
                            state is OAPLoadingState
                                ? state.operatorrejresons
                                : [],
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
                          rejresonsid.text = value!.id.toString();
                          // blocprovider.add(OAPEvent(
                          //     barcode: barcode,
                          //     machinedata: arguments['machinedata'],
                          //     selectedtoollist: selectedtoollist,
                          //     processrouteid: arguments['processrouteid'],
                          //     seqno: arguments['seqno'],
                          //     okqty: state.okqty,
                          //     rejqty: state.rejqty,
                          //     rejectedresonsid: value!.id.toString()));
                          // }
                        },
                      ),
                    );
                  } else {
                    return const Stack();
                  }
                },
              );
            })
      ],
    );
  }

  Future<dynamic> confirmEndProcess(
      {required BuildContext context,
      required OAPLoadingState state,
      // required String selectedlisttool,
      required int newrejqty,
      required TextEditingController okqty,
      required StreamController<int> rejqty,
      required TextEditingController rejresonsid,
      // required StreamController<List<Tools>> seletedtoollistcontroller,
      // required StreamController<List<Tools>> matchedTools,
      required int producedcount,
      required int productiontime,
      required int idletime,
      required double energyconsumtion}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: const Text("Do you want to end process?",
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.error)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(
                      color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
                )),
            QuickFixUi.horizontalSpace(width: 180),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.greenTheme)),
                onPressed: () async {
                  String response = await OperatorRepository().endProcess(
                      context,
                      state.productionstatusid,
                      okqty.text.toString(),
                      newrejqty.toString(),
                      rejresonsid.text,
                      state.barcode!.productid.toString(),
                      state.barcode!.rawmaterialissueid.toString(),
                      state.employeeId,
                      state.token,
                      producedcount,
                      productiontime,
                      idletime,
                      energyconsumtion);

                  if (response == 'End Process successfully') {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                  // if (response == 'End Process successfully') {
                  //   String repo = await OperatorRepository.inserttoollist(
                  //       productionstatusid: state.productionstatusid,
                  //       token: state.token,
                  //       toollist: selectedlisttool);

                  //   if (repo == 'Inserted successfully') {
                  //     selectedtoollist = [];
                  //   }
                  // }

                  // if (response == 'End Process successfully') {
                  //   String repo = await OperatorRepository.inserttoollist(
                  //       productionstatusid: state.productionstatusid,
                  //       token: state.token,
                  //       toollist: selectedlisttool);

                  //   if (repo == 'Inserted successfully') {
                  //     selectedtoollist = [];
                  //   }

                  //   // confirmEndProduction(
                  //   //     context: context,
                  //   //     state: state,
                  //   //     okqty: okqty,
                  //   //     rejqty: rejqty,
                  //   //     rejresonsid: rejresonsid,
                  //   //     seletedtoollistcontroller: seletedtoollistcontroller,
                  //   //     matchedTools: matchedTools);
                  //   Navigator.of(context).pop();
                  //   Navigator.of(context).pop();
                  // }
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                      color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
                ))
            //})
          ],
        );
      },
    );
  }

  Future<dynamic> confirmEndProduction(
      {required BuildContext context,
      required OAPLoadingState state,
      required TextEditingController okqty,
      required StreamController<int> rejqty,
      required TextEditingController rejresonsid,
      required StreamController<List<Tools>> seletedtoollistcontroller,
      required StreamController<List<Tools>> matchedTools}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Do you want to Final End Production?",
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.greenTheme)),
                onPressed: () async {
                  String response = await OperatorRepository()
                      .finalEndProduction(
                          context: context,
                          productid: state.barcode!.productid.toString(),
                          revisionno: state.barcode!.revisionnumber.toString(),
                          rmsissueid:
                              state.barcode!.rawmaterialissueid.toString(),
                          workcentreId: state.workcentreid.toString(),
                          token: state.token);

                  if (response == 'Updated successfully') {
                    for (int i = 0; i <= 2; i++) {
                      Navigator.of(context).pop();
                    }
                    okqty.dispose();
                    rejqty.close();
                    rejresonsid.dispose();
                    seletedtoollistcontroller.close();
                    matchedTools.close();
                    QuickFixUi.successMessage(
                        "Final End production successfully", context);
                  }
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                      color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
                )),
            QuickFixUi.horizontalSpace(width: 260),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.error)),
                onPressed: () {
                  seletedtoollistcontroller.close();
                  matchedTools.close();
                  for (int i = 0; i <= 2; i++) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "No",
                  style: TextStyle(
                      color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
                )),
          ],
        );
      },
    );
  }

  Row machineProductionStatus(
      {required ApiClient apiClient,
      required Barcode barcode,
      required okQtycontroller}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StreamBuilder<Object>(
          stream: Stream.periodic(const Duration(seconds: 21), (_) => true),
          builder: (context, snapshot) {
            return FutureBuilder<Map<String, dynamic>>(
              future: apiClient.fetchData(
                  barcode: barcode,
                  processrouteid: arguments['processrouteid']),
              builder: (context, snapshot) {
                productiontimedata = {};
                if (snapshot.hasData) {
                  final Map<String, dynamic>? data = snapshot.data;
                  productiontimedata = snapshot.data!;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      doneQtyWidget(
                          data: data!, okQtycontroller: okQtycontroller),
                      productionTimeWidget(data: data),
                      idleTimeWidget(data: data),
                      energyConsumedWidget(data: data),
                    ],
                  );
                } else {
                  return const Text("--");
                }
              },
            );
          },
        )
      ],
    );
  }

  Row energyConsumedWidget({required Map<String, dynamic> data}) {
    return Row(children: [
      const Text(
        "Energy Consumed: ",
        style: TextStyle(
            color: Color.fromARGB(255, 135, 185, 189),
            fontWeight: FontWeight.bold,
            fontSize: 21),
      ),
      Text(
        data.containsKey('energyconsumed')
            ? data['energyconsumed'].toStringAsFixed(2) + ' Wh'
            : "--",
        style: const TextStyle(
            color: Color.fromARGB(255, 55, 120, 124),
            fontWeight: FontWeight.bold,
            fontSize: 21),
      ),
      QuickFixUi.horizontalSpace(width: 51),
    ]);
  }

  Row idleTimeWidget({required Map<String, dynamic> data}) {
    return Row(children: [
      const Text(
        "Idle Time: ",
        style: TextStyle(
            color: Color.fromARGB(255, 135, 185, 189),
            fontWeight: FontWeight.bold,
            fontSize: 21),
      ),
      Text(
        data.containsKey('idletime')
            ? (data['idletime'] / 60).toStringAsFixed(2) + ' min'
            : "--",
        style: const TextStyle(
            color: Color.fromARGB(255, 55, 120, 124),
            fontWeight: FontWeight.bold,
            fontSize: 21),
      ),
      QuickFixUi.horizontalSpace(width: 51),
    ]);
  }

  Row productionTimeWidget({required Map<String, dynamic> data}) {
    return Row(children: [
      const Text(
        "Production Time: ",
        style: TextStyle(
            color: Color.fromARGB(255, 135, 185, 189),
            fontWeight: FontWeight.bold,
            fontSize: 21),
      ),
      Text(
        data.containsKey('productiontime')
            ? (data['productiontime'] / 60).toStringAsFixed(2) + ' min'
            : "--",
        style: const TextStyle(
            color: Color.fromARGB(255, 55, 120, 124),
            fontWeight: FontWeight.bold,
            fontSize: 21),
      ),
      QuickFixUi.horizontalSpace(width: 51),
    ]);
  }

  Row doneQtyWidget({
    required Map<String, dynamic> data,
    required StreamController<String> okQtycontroller,
  }) {
    String doneQTy =
        data.containsKey('data') ? data['data'].length.toString() : "--";

    // Add the count to the StreamController
    okQtycontroller.add(doneQTy);
    return Row(
      children: [
        const Text(
          "DoneQty: ",
          style: TextStyle(
            color: Color.fromARGB(255, 135, 185, 189),
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        Text(
          doneQTy,
          style: const TextStyle(
            color: Color.fromARGB(255, 55, 120, 124),
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        QuickFixUi.horizontalSpace(width: 51),
      ],
    );
  }

  BlocBuilder<OAPBloc, OAPState> pdfmodelbutton() {
    return BlocBuilder<OAPBloc, OAPState>(
      builder: (context, state) {
        if (state is OAPLoadingState) {
          return OperatorAutomaticDocuments().documentsButtons(
            context: context,
            alignment: Alignment.center,
            topMargin: 25,
            token: state.token,
            pdfMdocId: state.pdfmdocid,
            product: state.barcode!.product.toString(),
            productid: state.barcode!.productid.toString(),
            productrevisionno: state.barcode!.revisionnumber.toString(),
            productDescription: state.productDescription,
            pdfRevisionNo: state.pdfRevisionNo,
            modelMdocId: state.modelMdocid,
            modelimageType: state.imageType,
            machinename: state.machinename,
            workcentreid: state.workcentreid,
            workstationid: state.workstationid,
            seqno: arguments['seqno'],
            barcode: state.barcode,
            machineid: state.machineid,
            state: state,
            processrouteid: arguments['processrouteid'],
          );
        } else {
          return const Text('');
        }
      },
    );
  }

  BlocBuilder<OAPBloc, OAPState> revisionnumber() {
    return BlocBuilder<OAPBloc, OAPState>(builder: (context, state) {
      if (state is OAPLoadingState) {
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
            product: state.barcode!.product.toString(),
            productDescription: state.productDescription,
            token: state.token);
      } else {
        return const Text('');
      }
    });
  }

  BlocBuilder<OAPBloc, OAPState> selecttools(
      {required OAPBloc blocprovider,
      required Barcode barcode,
      required StreamController<List<Tools>> seletedtoollistcontroller,
      required StreamController<List<Tools>> matchedTools}) {
    return BlocBuilder<OAPBloc, OAPState>(
      builder: (context, state) {
        double conatinerwidth = 250;
        if (state is OAPLoadingState) {
          return Container(
              height: 120,
              width: conatinerwidth,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10.0),
              //   color: Color.fromARGB(255, 76, 116, 116),
              // ),

              decoration: const BoxDecoration(
                  // color: Color.fromARGB(255, 76, 116, 116),
                  color: Color.fromARGB(255, 186, 214, 231),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35))),
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(
                      height: 45,
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Select Tools",
                          hintStyle: const TextStyle(
                              // color: Color.fromARGB(255, 255, 255, 255),
                              color: Color.fromARGB(255, 5, 5, 5),
                              fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onTap: () {
                          multiselectionDropdown(
                              context: context,
                              state: state,
                              blocprovider: blocprovider,
                              barcode: barcode,
                              seletedtoollistcontroller:
                                  seletedtoollistcontroller,
                              matchedTools: matchedTools);
                        },
                      )),
                  SizedBox(
                    height: 65,
                    child: ListView.builder(
                      itemCount: state.selectedtoollist.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 99, 160, 209),
                              border: Border.all(
                                color: const Color.fromARGB(238, 165, 203, 218),
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Container(
                                height: 70,
                                margin: const EdgeInsets.only(left: 10),
                                child: Center(
                                  child: Text(
                                    state.selectedtoollist[index].toolname
                                        .toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (state.selectedtoollist.isNotEmpty) {
                                      selectedtoollist.removeWhere((element) =>
                                          element.id ==
                                          state.selectedtoollist[index].id);
                                      blocprovider.add(OAPEvent(
                                        barcode: barcode,
                                        machinedata: arguments['machinedata'],
                                        selectedtoollist: selectedtoollist,
                                        processrouteid:
                                            arguments['processrouteid'],
                                        seqno: arguments['seqno'],
                                        productionstatusid:
                                            state.productionstatusid,
                                        // okqty: state.okqty,
                                        // rejqty: state.rejqty,
                                        // rejectedresonsid:
                                        //     state.rejectedresonsid
                                      ));
                                    }
                                  },
                                  icon: const Icon(Icons.cancel))
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ));
        } else {
          return const Text(" ");
        }
      },
    );
  }

  Future<dynamic> multiselectionDropdown(
      {required BuildContext context,
      required OAPLoadingState state,
      required OAPBloc blocprovider,
      required Barcode barcode,
      required StreamController<List<Tools>> seletedtoollistcontroller,
      required StreamController<List<Tools>> matchedTools}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          List<Tools> searchableToollist = state.toollist;
          // StreamController<List<Tools>> seletedtoollistcontroller =
          //     StreamController<List<Tools>>.broadcast();
          // StreamController<List<Tools>> matchedTools =
          //     StreamController<List<Tools>>.broadcast();
          StreamController<bool> searchtoollistcontroller =
              StreamController<bool>.broadcast();
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: AlertDialog(
              title: StreamBuilder<bool>(
                  stream: searchtoollistcontroller.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == true) {
                        return TextFormField(
                          decoration:
                              const InputDecoration(hintText: "Search Tool"),
                          onChanged: (value) {
                            List<Tools> matchedItems = [];

                            matchedItems = searchableToollist.where((item) {
                              String itemString =
                                  item.toolname.toString().toLowerCase();
                              String searchValue = value.toLowerCase();

                              return itemString.contains(searchValue);
                            }).toList();
                            matchedTools.add(matchedItems);
                          },
                        );
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tool List',
                          style: TextStyle(
                              color: Color.fromARGB(255, 55, 120, 124),
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        IconButton(
                          onPressed: () {
                            searchtoollistcontroller.add(true);
                          },
                          icon: const Icon(Icons.search),
                          color: const Color.fromARGB(255, 223, 47, 47),
                        )
                      ],
                    );
                  }),
              content: SizedBox(
                  height: 350,
                  width: 550,
                  child: StreamBuilder<List<Tools>>(
                      stream: matchedTools.stream,
                      builder: (context, snapshot) {
                        List<Tools> toolsDataList = [];
                        if (snapshot.data != null) {
                          toolsDataList = snapshot.data!;
                        } else {
                          toolsDataList = state.toollist;
                        }
                        return ListView.builder(
                          itemCount: toolsDataList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              trailing: StreamBuilder<List<Tools>>(
                                  stream: seletedtoollistcontroller.stream,
                                  builder: (context, snapshot) {
                                    return Checkbox(
                                      activeColor: const Color.fromARGB(
                                          255, 86, 185, 156),
                                      value: selectedtoollist.any((tool) =>
                                          tool.id == toolsDataList[index].id),
                                      onChanged: (value) {
                                        if (value == true) {
                                          selectedtoollist.add(Tools(
                                              id: toolsDataList[index].id,
                                              toolname: toolsDataList[index]
                                                  .toolname));
                                        } else {
                                          selectedtoollist.removeWhere(
                                              (element) =>
                                                  element.id ==
                                                  toolsDataList[index].id);
                                        }

                                        seletedtoollistcontroller
                                            .add(selectedtoollist);

                                        blocprovider.add(OAPEvent(
                                          barcode: barcode,
                                          machinedata: arguments['machinedata'],
                                          selectedtoollist: selectedtoollist,
                                          processrouteid:
                                              arguments['processrouteid'],
                                          seqno: arguments['seqno'],
                                          productionstatusid:
                                              state.productionstatusid,
                                          // okqty: state.okqty,
                                          // rejqty: state.rejqty,
                                          // rejectedresonsid:
                                          //     state.rejectedresonsid
                                        ));
                                      },
                                    );
                                  }),
                              title: Text(
                                  toolsDataList[index].toolname.toString()),
                            );
                          },
                        );
                      })),
              actions: [
                TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        searchtoollistcontroller.close();

                        // seletedtoollistcontroller.close();
                        Navigator.of(context).pop();
                        blocprovider.add(OAPEvent(
                            barcode: barcode,
                            machinedata: arguments['machinedata'],
                            selectedtoollist: selectedtoollist,
                            processrouteid: arguments['processrouteid'],
                            seqno: arguments['seqno'],
                            // okqty: state.okqty,
                            // rejqty: state.rejqty,
                            // rejectedresonsid: state.rejectedresonsid
                            productionstatusid: state.productionstatusid));
                      });
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        searchtoollistcontroller.close();

                        // seletedtoollistcontroller.close();
                        Navigator.of(context).pop();
                        blocprovider.add(OAPEvent(
                            barcode: barcode,
                            machinedata: arguments['machinedata'],
                            selectedtoollist: selectedtoollist,
                            processrouteid: arguments['processrouteid'],
                            seqno: arguments['seqno'],
                            // okqty: state.okqty,
                            // rejqty: state.rejqty,
                            // rejectedresonsid: state.rejectedresonsid
                            productionstatusid: state.productionstatusid));
                      });
                    },
                    child: const Text('OK')),
              ],
            ),
          );
        });
  }
}
