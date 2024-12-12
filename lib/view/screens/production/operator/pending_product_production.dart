// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:de/bloc/production/operator/bloc/pending_production/machine_pending_production_bloc.dart';
import 'package:de/bloc/production/operator/bloc/pending_production/machine_pending_production_event.dart';
import 'package:de/bloc/production/operator/cubit/scan_cubit.dart';
import 'package:de/routes/route_names.dart';
import 'package:de/services/model/operator/oprator_models.dart';
import 'package:de/services/repository/operator/operator_repository.dart';
import 'package:de/utils/app_theme.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/constant.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/operator/bloc/pending_production/machine_pending_production_state.dart';
import '../../../../services/session/barcode.dart';
import '../../../../services/session/user_login.dart';
import 'package:http/http.dart' as http;

class PendingProduction extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const PendingProduction({super.key, required this.arguments});
  static const int rowPerPage = 10;
  static List<DataRow> rows = [];

  Future<void> _refreshData(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final scanCubit = BlocProvider.of<ScanCubit>(context);
    scanCubit.clearForm(false);
    final blocProvider = BlocProvider.of<PendingProductionBloc>(context);
    blocProvider.add(PendingProductionInitialEvent(
        statusofbarcode: false, cpmessagestatuscheck: false));
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<PendingProductionBloc>(context);
    callPendingProductionBloc(blocProvider: blocProvider);
    SizeConfig.init(context);

    return
        // InternetConnectionCheck(
        //   widget:
        Scaffold(
      body: SafeArea(
        child: MakeMeResponsiveScreen(
          horixontaltab: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 253, 255, 255)),
            child: BlocConsumer<PendingProductionBloc, PendingProductState>(
              listener: (context, state) {
                if (state is PendingProductionErrorState) {
                  QuickFixUi().showCustomDialog(
                      context: context, errorMessage: state.errorMessage);
                }
                //  else
                // if (state is PendingProductionLoadingState &&
                //     state.pendingproductlist.isEmpty &&
                //     state.statusofbarcode == true) {
                // withoutCpPlanConfirmationDialog(
                //     context: context,
                //     blocProvider: blocProvider,
                //     state: state);
                // }
              },
              builder: (context, state) {
                if (state is PendingProductionLoadingState) {
                  List<PendingProductlistforoperator> pendingproductlist =
                      state.pendingproductlist;

                  return RefreshIndicator(
                    onRefresh: () async {
                      await _refreshData(context);
                    },
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              const SizedBox(height: 25),
                              Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: scanBarcodeBtn(context),
                                  )),
                              const SizedBox(height: 25),
                              const Divider(
                                height: 10,
                                thickness: 2,
                                indent: 0,
                                endIndent: 0,
                                color: Color.fromARGB(255, 11, 17, 20),
                              ),
                              const Text('Product List From The Capacity Plan',
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 214, 146, 134))),
                              const Divider(
                                height: 10,
                                thickness: 2,
                                indent: 0,
                                endIndent: 0,
                                color: Color.fromARGB(255, 11, 17, 20),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  headingRowColor: WidgetStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 194, 224, 231),
                                  ),
                                  headingTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 32, 32, 32),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                  columns: const [
                                    DataColumn(
                                      label: Text('Sr.No',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                    DataColumn(
                                      label: Text('Runumber',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                    DataColumn(
                                      label: Text('PoNumber',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                    DataColumn(
                                      label: Text('ProductCode',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                    DataColumn(
                                      label: Text('RevisionNo',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                    DataColumn(
                                      label: Text('LineNo',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                    DataColumn(
                                      label: Text('ToBeProducedQty',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                    DataColumn(
                                      label: Text('Action',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20)),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(
                                      pendingproductlist.length, (index) {
                                    final item = pendingproductlist[index];
                                    String modifiedString =
                                        item.product!.trim();

                                    return DataRow(cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(
                                          Text((item.runnumber).toString())),
                                      DataCell(Text(
                                          item.ponumber!.trim().toString())),
                                      DataCell(Text(modifiedString)),
                                      DataCell(Text(item.revisionNo!.trim())),
                                      DataCell(Text(item.lineno!.trim())),
                                      DataCell(Text(item.toBeProducedQty!
                                          .trim()
                                          .toString())),
                                      DataCell(
                                        SizedBox(
                                          width: 185,
                                          child: Row(
                                            children: [
                                              BlocBuilder<ScanCubit, ScanState>(
                                                builder: (context, state) {
                                                  return ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 10,
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              159,
                                                              218,
                                                              203),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      side: const BorderSide(
                                                          width: 1.0,
                                                          color: Color.fromARGB(
                                                              255,
                                                              235,
                                                              32,
                                                              18)),
                                                    ),
                                                    onPressed: () async {
                                                      if (state.isScan) {
                                                        // debugPrint(
                                                        //     "${item.capacityplanChildId}-------${item.runnumber}---------------->>>");
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteName
                                                                .machineProgramSequance,
                                                            arguments: {
                                                              'barcode':
                                                                  state.barcode,
                                                              'machinedata': state
                                                                  .machinedata,
                                                              'cprunnumber':
                                                                  item.runnumber,
                                                              'cpchildid': item
                                                                  .capacityplanChildId,
                                                            });
                                                      } else {
                                                        // debugPrint(
                                                        //     "${item.id}-------${item.runnumber}---------------->>>");
                                                        showErrorDialog(
                                                            context: context,
                                                            message:
                                                                "Please Scan first...!");
                                                      }
                                                    },
                                                    child: const Text(
                                                        "Get Process"),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is PendingProductionErrorState) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 4.0,
                    ),
                  );
                }
              },
            ),
          ),
          // mobile: const Center(
          //   child: Text("This Screen support in tab view"),
          // ),
          // linux: const Center(
          //   child: Text("This Screen support in tab view"),
          // ),
          // windows: const Center(
          //   child: Text("This Screen support in tab view"),
          // ),
          // verticaltab: const Center(
          //   child: Text("This Screen support in tab view"),
          // ),
        ),
      ),
      // ),
    );
  }

  callPendingProductionBloc({required PendingProductionBloc blocProvider}) {
    ProductData.getbarocodeData().then((value) {
      // if (value.productid == '') {
      blocProvider.add(PendingProductionInitialEvent(
          statusofbarcode: false, cpmessagestatuscheck: false));
      //  }
    });
  }

  Future<dynamic> withoutCpPlanConfirmationDialog(
      {required BuildContext context,
      required PendingProductionBloc blocProvider,
      required PendingProductionLoadingState state}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (newcontext) {
        return AlertDialog(
          content: const Text(
            "Product is not in capacity plan. Do you want to continue?",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 36, 35, 35)),
          ),
          actions: [
            FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 10,
                  backgroundColor: const Color.fromARGB(255, 245, 165, 165),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final scanCubit = BlocProvider.of<ScanCubit>(context);
                  scanCubit.clearForm(false);
                  await ProductData.removeBorcodeSession();
                  blocProvider.add(PendingProductionInitialEvent(
                      statusofbarcode: false,
                      cpmessagestatuscheck: state.cpmessagestatuscheck));
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Back",
                  style: TextStyle(color: Colors.black),
                )),
            FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 10,
                  backgroundColor: const Color.fromARGB(255, 123, 228, 214),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  Map<String, dynamic> data = {};
                  final machinedata = await MachineData.geMachineData();

                  for (var element in machinedata) {
                    data = jsonDecode(element);
                  }
                  Barcode barcodedata = await ProductData.getbarocodeData();

                  if (state.cpmessagestatuscheck == false) {
                    List whatsappno = [
                      // 917972858760,
                      // 919049990972,
                      // 917350707100

                      '7875481775',
                      '8788848304',
                      '7972858760'
                    ];
                    String message1 =
                        "This product is not in capacity plan,, Product details:-, Product:${barcodedata.product},  RevisionNo: ${barcodedata.revisionnumber}, PO: ${barcodedata.po},  LineNo: ${barcodedata.lineitemnumber} ";
                    String message = formatString(message1);
                    await OperatorRepository.cpmessageinsert(
                        productid: barcodedata.productid.toString(),
                        revisionnumber: barcodedata.revisionnumber.toString(),
                        rmsissueid: barcodedata.rawmaterialissueid.toString(),
                        poid: barcodedata.poid.toString(),
                        lineitno: barcodedata.lineitemnumber.toString(),
                        token: state.token,
                        employeeid: state.employeeid,
                        context: context);
                    await notifierMessage(barcodedata, whatsappno, message);
                    whatsappno = [];
                  } else {
                    //
                  }
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, RouteName.machineProgramSequance,
                      arguments: {'barcode': barcodedata, 'machinedata': data});
                  await ProductData.removeBorcodeSession();
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      },
    );
  }

  String formatString(String originalString) {
    List<String> segments =
        originalString.split(',').map((e) => e.trim()).toList();
    segments[0] = segments[0].replaceAll("Product details:-", "").trim();
    String formattedString = segments.join('\n');
    return formattedString;
  }

  Future<dynamic> showErrorDialog(
      {required BuildContext context, required String message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          )),
          actions: [
            Center(
              child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            )
          ],
        );
      },
    );
  }

  List<Widget> scanBarcodeBtn(
    BuildContext context,
  ) {
    StreamController<bool> processing = StreamController<bool>.broadcast();
    return [
      Container(
          margin: const EdgeInsets.only(top: 0),
          height: SizeConfig.blockSizeVertical! * 8,
          width: SizeConfig.blockSizeHorizontal! * 30,
          child: BlocBuilder<PendingProductionBloc, PendingProductState>(
            builder: (context, state) {
              return BlocBuilder<ScanCubit, ScanState>(
                builder: (context, barcodestate) {
                  if (barcodestate.code != '' &&
                      barcodestate.isScan == true &&
                      state is PendingProductionLoadingState &&
                      state.statusofbarcode != true) {
                    BlocProvider.of<PendingProductionBloc>(context).add(
                        PendingProductionInitialEvent(
                            statusofbarcode: true,
                            cpmessagestatuscheck: false));
                  }
                  return FilledButton.icon(
                    icon: Image.asset(
                      scanIcon,
                      color: Colors.white,
                      width: SizeConfig.blockSizeHorizontal! * 4,
                      height: SizeConfig.blockSizeVertical! * 5,
                    ),
                    label: Text(
                      'Scan',
                      style: SizeConfig.screenWidth! < 500
                          ? AppTheme.mobileTextStyle()
                          : AppTheme.tabTextStyle(),
                    ),
                    onPressed: () async {
                      await ProductData.removeBorcodeSession();
                      await _refreshData(context);
                      BlocProvider.of<ScanCubit>(context)
                          .scanCode(val: true, context: context);
                    },
                  );
                },
              );
            },
          )),
      const SizedBox(
        width: 20,
      ),
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 253, 253),
          borderRadius: BorderRadius.circular(5),
        ),
        height: SizeConfig.blockSizeVertical! * 8,
        width: SizeConfig.blockSizeHorizontal! * 30,
        child: Align(
          alignment: Alignment.center,
          child: BlocBuilder<ScanCubit, ScanState>(
            builder: (context, state) {
              if (state.isScan) {
                return TextField(
                  decoration: const InputDecoration(border: InputBorder.none),
                  readOnly: true,
                  controller: TextEditingController(
                    text: state.code != "" ? state.code : "",
                  ),
                  textAlign: TextAlign.center,
                  style: AppTheme.tabTextStyle().copyWith(color: Colors.black),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 253, 253),
          borderRadius: BorderRadius.circular(5),
        ),
        height: 50,
        width: 255,
        child: BlocBuilder<PendingProductionBloc, PendingProductState>(
          builder: (context, state) {
            if (state is PendingProductionLoadingState &&
                state.pendingproductlist.isEmpty &&
                state.statusofbarcode == true) {
              return StreamBuilder<bool>(
                  stream: processing.stream,
                  builder: (context, snapshot) {
                    //debugPrint(snapshot.data.toString());
                    return FilledButton(
                      onPressed: () async {
                        processing.add(true);
                        Map<String, dynamic> data = {};
                        final machinedata = await MachineData.geMachineData();
                        for (var element in machinedata) {
                          data = jsonDecode(element);
                        }
                        Barcode barcodedata =
                            await ProductData.getbarocodeData();
                        if (state.cpmessagestatuscheck == false) {
                          List whatsappno = [
                            // 917972858760,
                            // 919049990972,
                            // 917350707100
                            917875481775,
                            918788848304,
                            917972858760
                          ];
                          String message1 =
                              "This product is not in capacity plan, Product details:-, Product:${barcodedata.product},  RevisionNo: ${barcodedata.revisionnumber}, PO: ${barcodedata.po},  LineNo: ${barcodedata.lineitemnumber} ";
                          String message = formatString(message1);
                          await OperatorRepository.cpmessageinsert(
                              productid: barcodedata.productid.toString(),
                              revisionnumber:
                                  barcodedata.revisionnumber.toString(),
                              rmsissueid:
                                  barcodedata.rawmaterialissueid.toString(),
                              poid: barcodedata.poid.toString(),
                              lineitno: barcodedata.lineitemnumber.toString(),
                              token: state.token,
                              employeeid: state.employeeid,
                              context: context);
                          await notifierMessage(
                              barcodedata, whatsappno, message);
                          whatsappno = [];
                          processing.add(false);
                        } else {
                          processing.add(false);
                        }

                        // Navigator.of(context).pop();

                        Navigator.pushNamed(
                            context, RouteName.machineProgramSequance,
                            arguments: {
                              'barcode': barcodedata,
                              'machinedata': data,
                              'cprunnumber': '0',
                              'cpchildid': '0',
                            });

                        // await ProductData.removeBorcodeSession();
                      },
                      // style: ButtonStyle(
                      //   backgroundColor: MaterialStateProperty.resolveWith(
                      //     (states) => Color.fromARGB(255, 149, 202, 214),
                      //   ),
                      // ),
                      // Add return here
                      child: snapshot.data != null && snapshot.data == true
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Get Process"),
                    );
                  });
            }
            return Container(); // Add a default return
          },
        ),
      )
    ];
  }

  Future notifierMessage(
      Barcode barcode, List whatsappno, String message) async {
    for (int i = 0; i < whatsappno.length; i++) {
      try {
        String url =
            // "https://wawatext.com/api/send.php?number=${whatsappno[i]}&type=text&message=$message&instance_id=647AC5F48A6B4&access_token=8833b92c1d42631ef29ba1f641b3fe94";
            "https://apps.wawatext.com/api/send?number=${whatsappno[i]}&type=text&message=$message&instance_id=661F8FED28545&access_token=648abb0bdf0bf";
        var request = http.MultipartRequest('GET', Uri.parse(url));
        // ignore: unused_local_variable
        //       debugPrint(request.toString());
        final response = await request.send();
        response;
      } catch (e) {
        return "File Not Transfer";
      }
    }
    whatsappno = [];
  }
}
