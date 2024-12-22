// ignore_for_file: use_build_context_synchronously, must_be_immutable, unnecessary_null_comparison, unnecessary_type_check

import 'dart:async';
import 'package:de/utils/responsive.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/operator/bloc/operator_manual_production/operator_manual_production_bloc.dart';
import '../../../../bloc/production/operator/bloc/operator_manual_production/operator_manual_production_event.dart';
import '../../../../bloc/production/operator/bloc/operator_manual_production/operator_manual_production_state.dart';
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
    Barcode? barcode = arguments['barcode'];
    final blocprovider = BlocProvider.of<OMPBloc>(context);
    blocprovider.add(
        OMPEvent([], '', '', 0, barcode!, arguments['machinedata'], 0, ''));
    Size size = MediaQuery.of(context).size;
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
                    BarcodeSession().barcodeData(
                        context: context,
                        parentWidth: size.width,
                        barcode: barcode),
                    const SizedBox(height: 10),
                    pdfmodelbutton(),
                    revisionnumber(),
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: Theme.of(context).primaryColor,
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
                  ],
                )),
          ),
        ));
  }

  BlocBuilder<OMPBloc, OMPState> rejectedReasonsDropdown(
      {required OMPBloc blocprovider, required Barcode barcode}) {
    return BlocBuilder<OMPBloc, OMPState>(
      builder: (context, state) {
        if (state is OMPLoadingState && state.rejqty > 0) {
          return SizedBox(
            width: SizeConfig.blockSizeHorizontal! * 21,
            child: DropdownSearch<OperatorRejectedReasons>(
              items: state is OMPLoadingState ? state.operatorrejresons : [],
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
                          } else if (state.okqty == 0) {
                            return QuickFixUi.errorMessage(
                                'fill Ok Qty', context);
                          } else if (state.rejqty > 0 &&
                              state.rejresons.isEmpty) {
                            return QuickFixUi.errorMessage(
                                'Please Choose Reject Reasons', context);
                          } else {
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
            productDescription: state.productDescription,
            pdfRevisionNo: state.pdfRevisionNo,
            modelMdocId: state.modelMdocid,
            modelimageType: state.imageType,
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
                            token: state.token,
                            context: context,
                            payload: {
                              'product_id': state.barcode.productid.toString(),
                              'rms_issue_id':
                                  state.barcode.rawmaterialissueid.toString(),
                              'workcentre_id': state.workcentreid,
                              'workstation_id': state.workstationid,
                              'employee_id': state.employeeID,
                              'revisionno':
                                  state.barcode.revisionnumber.toString(),
                              'process_sequence': '0'
                            });

                        await ProductMachineRoute().registerProductMachineRoute(
                            token: state.token,
                            payload: {
                              'product_id': state.barcode.productid,
                              'product_revision': state.barcode.revisionnumber,
                              'workcentre_id': state.workcentreid,
                              'workstation_id': state.workstationid
                            });
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
