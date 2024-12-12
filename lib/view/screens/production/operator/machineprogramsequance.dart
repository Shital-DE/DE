// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:de/bloc/production/operator/bloc/machine_program_sequance/machine_program_sequance_bloc.dart';
import 'package:de/bloc/production/operator/bloc/machine_Program_Sequance/machine_Program_Sequance_event.dart';
import 'package:de/bloc/production/operator/bloc/machine_Program_Sequance/machine_Program_Sequance_state.dart';
import 'package:de/services/model/operator/oprator_models.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../routes/production_route.dart';
import '../../../../services/repository/operator/operator_repository.dart';
import '../../../../services/session/user_login.dart';
import '../../../widgets/barcode_session.dart';
import 'package:http/http.dart' as http;

class MachinesequancePrograme extends StatelessWidget {
  const MachinesequancePrograme({
    super.key,
    required this.arguments,
  });
  final Map<String, dynamic> arguments;

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    String cprunnumber = arguments['cprunnumber'];
    String cpchildid = arguments['cpchildid'];
    final blocProvider = BlocProvider.of<MachineProgramSequanceBloc>(context);
    blocProvider.add(MachineProgramSequanceInitialEvent(
      statusofbarcode: false,
      barcode: barcode!,
      folderList: [],
      prmessagestatuscheck: false,
    ));
    return
        // InternetConnectionCheck(
        //   widget:
        Scaffold(
            appBar: CustomAppbar()
                .appbar(context: context, title: 'Product Process List'),
            body: SafeArea(
                child: MakeMeResponsiveScreen(
              horixontaltab: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: //const Text("Hello sequance number"),
                    BlocConsumer<MachineProgramSequanceBloc,
                        MachineProgramSequanceState>(
                  listener: (context, state) {
                    // if (state is MachineProgramSequanceLoadingState &&
                    //     state.productprocessList.isEmpty) {
                    //   noproductrouteaveable(context, state);
                    // }
                  },
                  builder: (context, state) {
                    if (state is MachineProgramSequanceLoadingState) {
                      return ListView.builder(
                        itemCount: 1, // Only one child, which is the DataTable
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  child: BarcodeSession().barcodeData(
                                      context: context,
                                      parentWidth: 1300,
                                      barcode: barcode),
                                ),
                                QuickFixUi.verticalSpace(height: 1),
                                // const SizedBox(
                                //   height: 12,
                                // ),
                                BlocConsumer<MachineProgramSequanceBloc,
                                    MachineProgramSequanceState>(
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    if (state
                                            is MachineProgramSequanceLoadingState &&
                                        state.productprocessList.isNotEmpty) {
                                      List<Productprocessseq>
                                          productprocesslist =
                                          state.productprocessList;

                                      return SizedBox(
                                        width: double.infinity,
                                        child: DataTable(
                                          // dataRowMinHeight: 25.0,
                                          dataRowMaxHeight: 150.0,
                                          headingRowColor:
                                              WidgetStateColor.resolveWith(
                                            (states) => const Color.fromARGB(
                                                255, 111, 158, 170),
                                          ),
                                          headingTextStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          columns: const [
                                            DataColumn(
                                              label: Text(
                                                'Sr.No',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Workcentre',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Product',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Runtime',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Setupmin',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'SeqNo',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Instrution',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Action',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(
                                              productprocesslist.length,
                                              (index) {
                                            Productprocessseq folder =
                                                productprocesslist[index];
                                            // String modifiedString =
                                            //     folder.remark!.substring(32);
                                            String instruction =
                                                folder.instruction.toString();
                                            List<String> lines =
                                                instruction.split('\n');
                                            int numberOfLines = lines.length;
                                            int paddingcount = 0;
                                            if (numberOfLines <= 3) {
                                              paddingcount = 40;
                                            }

                                            return DataRow(
                                              cells: [
                                                DataCell(Text(
                                                    (index + 1).toString())),
                                                DataCell(Text(folder.workcentre
                                                    .toString())),
                                                DataCell(
                                                    Text(folder.product ?? '')),
                                                DataCell(Text(folder
                                                    .runtimeminutes
                                                    .toString())),
                                                DataCell(Text(folder
                                                    .setupminutes
                                                    .toString())),
                                                DataCell(Text(
                                                  folder.seqno.toString(),
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: Color.fromARGB(
                                                        255, 112, 158, 167),
                                                  ),
                                                )),
                                                DataCell(
                                                  SizedBox(
                                                    width: 250,
                                                    height: 450,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: paddingcount
                                                              .toDouble(),
                                                          bottom: 0.0,
                                                          left: 0.0,
                                                          right: 0.0,
                                                        ),
                                                        child: Text(
                                                          folder.instruction
                                                              .toString(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  SizedBox(
                                                    width: 185,
                                                    child: Row(
                                                      children: [
                                                        BlocBuilder<
                                                            MachineProgramSequanceBloc,
                                                            MachineProgramSequanceState>(
                                                          builder:
                                                              (context, state) {
                                                            return ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 10,
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        190,
                                                                        174,
                                                                        204),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                side:
                                                                    const BorderSide(
                                                                  width: 1.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          180,
                                                                          84,
                                                                          209),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                if (state
                                                                    is MachineProgramSequanceLoadingState) {
                                                                  // if (state.machineid =='') {

                                                                  // } else {
                                                                  String
                                                                      checkresponce =
                                                                      //  'success';
                                                                      await OperatorRepository
                                                                          .jobProdutionloadApi(
                                                                    requestid:
                                                                        '',
                                                                    slipId: state
                                                                        .barcode!
                                                                        .rawmaterialissueid
                                                                        .toString()
                                                                        .trim(),
                                                                    productId: state
                                                                        .barcode!
                                                                        .productid
                                                                        .toString()
                                                                        .trim(),
                                                                    toBeProducedQty: state
                                                                        .barcode!
                                                                        .issueQty!
                                                                        .toInt(),
                                                                    machineId: state
                                                                        .machineid
                                                                        .toString()
                                                                        .trim(),
                                                                    timeStart:
                                                                        '',
                                                                    processid: folder
                                                                        .processrouteid
                                                                        .toString(),
                                                                    token: state
                                                                        .token,
                                                                    context:
                                                                        context,
                                                                  );

                                                                  if (checkresponce ==
                                                                      'success') {
                                                                    QuickFixUi.successMessage(
                                                                        checkresponce,
                                                                        context);
                                                                    await ProductionRoute().gotoOperatorScreen(
                                                                        context:
                                                                            context,
                                                                        barcode:
                                                                            barcode,
                                                                        processrouteid: folder
                                                                            .processrouteid
                                                                            .toString(),
                                                                        seqno: folder
                                                                            .seqno
                                                                            .toString(),
                                                                        cprunnumber:
                                                                            cprunnumber,
                                                                        cpchildid:
                                                                            cpchildid);
                                                                  } else {
                                                                    QuickFixUi.errorMessage(
                                                                        checkresponce,
                                                                        context);
                                                                  }
                                                                }
                                                                //   }
                                                              },
                                                              child: const Text(
                                                                  "Start Process"),
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          width: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      );
                                    } else if (state
                                            is MachineProgramSequanceLoadingState &&
                                        state.productprocessList.isEmpty) {
                                      //   bool isLoading = false;
                                      return continueWidget(
                                          state: state,
                                          context: context,
                                          barcode: barcode);
                                    }
                                    return const SizedBox();
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is MachineProgramSequanceErrorState) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              mobile: const Center(
                child: Text("This Screen support in tab view"),
              ),
              linux: const Center(
                child: Text("This Screen support in tab view"),
              ),
              windows: const Center(
                child: Text("This Screen support in tab view"),
              ),
              verticaltab: const Center(
                child: Text("This Screen support in tab view"),
              ),
            ))
            // ),
            );
  }

  StreamBuilder<bool> continueWidget(
      {required MachineProgramSequanceLoadingState state,
      required BuildContext context,
      required Barcode barcode}) {
    StreamController<bool> processing = StreamController<bool>.broadcast();
    return StreamBuilder<bool>(
        stream: processing.stream,
        builder: (context, snapshot) {
          return SizedBox(
              width: 350,
              height: 60,
              child:
                  // Stack(
                  //   children: [
                  FilledButton(
                child: snapshot.data != null && snapshot.data == true
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue"),
                onPressed: () async {
                  //isLoading = true;
                  processing.add(true);
                  // if (isLoading) // Show CircularProgressIndicator when isLoading is true
                  //   CircularProgressIndicator();

                  Map<String, dynamic> data = {};
                  final machinedata = await MachineData.geMachineData();
                  for (var element in machinedata) {
                    data = jsonDecode(element);
                  }

                  List<String> pr = await OperatorRepository()
                      .availableProductRoute(
                          productid: state.barcode!.productid.toString(),
                          revisionnumber:
                              state.barcode!.revisionnumber.toString(),
                          token: state.token,
                          context: context);
                  String prd = '';
                  if (pr.isNotEmpty) {
                    List<String> trimmedList = pr
                        .map((element) => element.trim())
                        .where((element) => element.isNotEmpty)
                        .toList();
                    prd = trimmedList.join(', ');
                  } else {
                    prd = 'NO Route Define';
                  }

                  if (state.prmessagestatuscheck == false) {
                    String whatsno = '';
                    List<String> whatsappno = [
                      // '917972858760',
                      // '919049990972',
                      // '917350707100'
                      '917875481775',
                      '918788848304',
                      '917972858760'
                    ];
                    if (whatsappno.isNotEmpty) {
                      List<String> trimmedList = whatsappno
                          .map((element) => element.trim())
                          .where((element) => element.isNotEmpty)
                          .toList();
                      whatsno = trimmedList.join(', ');
                    } else {
                      whatsno = 'NO Route Define';
                    }
                    String message1 =
                        "For ${state.barcode?.product.toString()} has no product route or instruction set for ${data['workcentre'].toString().trim()} workcentre., Available Product route is:- ,${prd.toString().trim()},";
                    String message = formatString(message1);
                    await OperatorRepository.prmessageinsert(
                        productid: state.barcode!.productid.toString(),
                        revisionnumber:
                            state.barcode!.revisionnumber.toString(),
                        rmsissueid:
                            state.barcode!.rawmaterialissueid.toString(),
                        poid: state.barcode!.poid.toString(),
                        lineitno: state.barcode!.lineitemnumber.toString(),
                        token: state.token,
                        employeeid: state.employeeid,
                        context: context,
                        message: message,
                        whatsupno: whatsno,
                        workcentreid: state.workcentreid);

                    await notifierMessage(barcode, whatsappno, message);
                    whatsappno = [];
                  } else {
                    // debugPrint(
                    //     "already PR message sent and inserted in table");
                  }

                  String checkresponce =
                      await OperatorRepository.jobProdutionloadApi(
                    requestid: '',
                    slipId: state.barcode!.rawmaterialissueid.toString().trim(),
                    productId: state.barcode!.productid.toString().trim(),
                    toBeProducedQty: state.barcode!.issueQty!.toInt(),
                    machineId: state.machineid.toString().trim(),
                    timeStart: '',
                    processid: 'noprocess',
                    token: state.token,
                    context: context,
                  );

                  // debugPrint('5-------------------$checkresponce');

                  if (checkresponce == 'success') {
                    QuickFixUi.successMessage(checkresponce, context);
                    // isLoading = true;
                    processing.add(false);
                    await ProductionRoute().gotoOperatorScreen(
                        context: context,
                        barcode: state.barcode!,
                        processrouteid: '',
                        seqno: '00',
                        cprunnumber: arguments['cprunnumber'],
                        cpchildid: arguments['cpchildid']);
                  } else {
                    QuickFixUi.errorMessage(checkresponce, context);
                    // debugPrint(checkresponce.toString());
                  }
                },
                // style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.resolveWith(
                //         (states) => const Color.fromARGB(255, 109, 165, 167)))),
                //   ],
              ));
        });
  }

  // Future<dynamic> noproductrouteaveable(BuildContext context, state) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (newcontext) {
  //       return AlertDialog(
  //         content: const Text(
  //           "This product have no Product route. Do you want to continue ?",
  //           style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.normal,
  //               color: Color.fromARGB(255, 221, 60, 60)),
  //         ),
  //         actions: [
  //           FilledButton(
  //               style: FilledButton.styleFrom(
  //                 elevation: 10,
  //                 backgroundColor: const Color.fromARGB(255, 241, 121, 121),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //               onPressed: () async {
  //                 // final scanCubit = BlocProvider.of<ScanCubit>(context);
  //                 // scanCubit.clearForm(false); // Clear the scan code
  //                 Navigator.of(newcontext).pop();
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text(
  //                 "Back",
  //                 style: TextStyle(color: Colors.black),
  //               )),
  //           FilledButton(
  //               style: FilledButton.styleFrom(
  //                 elevation: 10,
  //                 backgroundColor: const Color.fromARGB(255, 71, 190, 175),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //               onPressed: () async {
  //                 Map<String, dynamic> data = {};
  //                 Navigator.of(newcontext).pop();
  //                 final machinedata = await MachineData.geMachineData();
  //                 for (var element in machinedata) {
  //                   data = jsonDecode(element);
  //                 }

  //                 Barcode barcodedata = //arguments['barcode'];

  //                     await ProductData.getbarocodeData();

  //                 List<String> pr = await OperatorRepository()
  //                     .availableProductRoute(
  //                         productid: barcodedata.productid.toString(),
  //                         revisionnumber: barcodedata.revisionnumber.toString(),
  //                         token: state.token,
  //                         context: context);
  //                 String prd = '';
  //                 if (pr.isNotEmpty) {
  //                   List<String> trimmedList = pr
  //                       .map((element) => element.trim())
  //                       .where((element) => element.isNotEmpty)
  //                       .toList();
  //                   prd = trimmedList.join(', ');
  //                 } else {
  //                   prd = 'NO Route Define';
  //                 }

  //                 if (state is MachineProgramSequanceLoadingState) {
  //                   if (state.prmessagestatuscheck == false) {
  //                     String whatsno = '';
  //                     List<String> whatsappno = [
  //                       '917972858760',
  //                       '919049990972',
  //                       '917350707100'
  //                     ];
  //                     if (whatsappno.isNotEmpty) {
  //                       List<String> trimmedList = whatsappno
  //                           .map((element) => element.trim())
  //                           .where((element) => element.isNotEmpty)
  //                           .toList();
  //                       whatsno = trimmedList.join(', ');
  //                     } else {
  //                       whatsno = 'NO Route Define';
  //                     }
  //                     String message1 =
  //                         "For ${barcodedata.product} has no product route or instruction set for ${data['workcentre'].toString().trim()} workcentre., Available Product route is:- ,${prd.toString().trim()},";
  //                     String message = formatString(message1);
  //                     //  debugPrint(message.toString());

  //                     await OperatorRepository.prmessageinsert(
  //                         productid: barcodedata.productid.toString(),
  //                         revisionnumber: barcodedata.revisionnumber.toString(),
  //                         rmsissueid: barcodedata.rawmaterialissueid.toString(),
  //                         poid: barcodedata.poid.toString(),
  //                         lineitno: barcodedata.lineitemnumber.toString(),
  //                         token: state.token,
  //                         employeeid: state.employeeid,
  //                         context: context,
  //                         message: message,
  //                         whatsupno: whatsno,
  //                         workcentreid: state.workcentreid);

  //                     await notifierMessage(barcodedata, whatsappno, message);
  //                     whatsappno = [];
  //                   } else {
  //                     // debugPrint(
  //                     //     "already PR message sent and inserted in table");
  //                   }
  //                 }

  //                 String checkresponce =
  //                     await OperatorRepository.jobProdutionloadApi(
  //                   requestid: '',
  //                   slipId: barcodedata.rawmaterialissueid.toString().trim(),
  //                   productId: barcodedata.productid.toString().trim(),
  //                   toBeProducedQty: barcodedata.issueQty!.toInt(),
  //                   machineId: data['machineid'].toString().trim(),
  //                   timeStart: '',
  //                   processid: '',
  //                   token: state.token,
  //                   context: context,
  //                 );
  //                 if (checkresponce == 'success') {
  //                   QuickFixUi.successMessage(checkresponce, context);
  //                   await ProductionRoute().gotoOperatorScreen(
  //                       context: context,
  //                       barcode: barcodedata,
  //                       processrouteid: '',
  //                       seqno: '00');
  //                 } else {
  //                   QuickFixUi.errorMessage(checkresponce, context);
  //                   // debugPrint(checkresponce.toString());
  //                 }

  //                 // await ProductionRoute().gotoOperatorScreen(
  //                 //     context: context,
  //                 //     barcode: barcodedata,
  //                 //     processrouteid: '',
  //                 //     seqno: '00');
  //               },
  //               child: const Text(
  //                 "Continue",
  //                 style: TextStyle(color: Colors.black),
  //               ))
  //         ],
  //       );
  //     },
  //   );
  // }

  String formatString(String originalString) {
    List<String> segments =
        originalString.split(',').map((e) => e.trim()).toList();
    segments[0] = segments[0].replaceAll("Product details:-", "").trim();
    String formattedString = segments.join('\n');
    return formattedString;
  }

  Future notifierMessage(
      Barcode barcode, List whatsappno, String message) async {
    // ignore: dead_code
    for (int i = 0; i < whatsappno.length; i++) {
      try {
        String url =
            // "https://wawatext.com/api/send.php?number=${whatsappno[i]}&type=text&message=$message&instance_id=647AC5F48A6B4&access_token=8833b92c1d42631ef29ba1f641b3fe94";
            "https://apps.wawatext.com/api/send?number=${whatsappno[i]}&type=text&message=test+message&instance_id=661F8FED28545&access_token=648abb0bdf0bf";
        var request = http.MultipartRequest('POST', Uri.parse(url));
        final response = await request.send();
        response;
        // debugPrint(url.toString());
        // debugPrint(response.toString());
      } catch (e) {
        // debugPrint('Error reading file: $e');
        return "File Not Transfer";
      }
    }
    whatsappno = [];
  }
}
