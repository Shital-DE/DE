// ignore_for_file: use_build_context_synchronously

import 'package:de/bloc/dashboard/dashboard_bloc.dart';
import 'package:de/bloc/dashboard/dashboard_event.dart';
import 'package:de/bloc/production/operator/cubit/scan_cubit.dart';
import 'package:de/routes/production_route.dart';
import 'package:de/services/model/dashboard/dashboard_model.dart';
import 'package:de/utils/app_colors.dart';
import 'package:de/utils/app_theme.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/constant.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarcodeScan extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const BarcodeScan({super.key, required this.arguments});
  final bool isEnable = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: MakeMeResponsiveScreen(
          horixontaltab: Center(
            child: ListView(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: scanBarcodeBtn(context),
                    )),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    productDescription(w: SizeConfig.blockSizeHorizontal! * 35),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: SizeConfig.blockSizeVertical! * 8,
                        width: SizeConfig.blockSizeHorizontal! * 30,
                        margin: const EdgeInsets.only(top: 50),
                        child: BlocBuilder<ScanCubit, ScanState>(
                          builder: (context, state) {
                            return FilledButton(
                              onPressed: state.code != ''
                                  ? () async {
                                      BlocProvider.of<ScanCubit>(context)
                                          .clearForm(false);
                                      List<Programs> programsList =
                                          arguments['programs'];

                                      if (programsList.length > 1) {
                                        ProductionRoute()
                                            .gotoSupervisorProduction(
                                                context, programsList, state);
                                      } else {
                                        for (var data in programsList) {
                                          if (data.programname.toString() ==
                                              'Packing Dashboard') {
                                            ProductionRoute()
                                                .gotoPacking(context, state);
                                          } else if (data.programname
                                                  .toString() ==
                                              'QC Dashboard') {
                                            ProductionRoute()
                                                .gotoQuality(context, state);
                                          } else if (data.programname
                                                  .toString() ==
                                              'Cutting') {
                                            ProductionRoute()
                                                .gotoCutting(context, state);
                                          } else if (data.programname
                                                  .toString() ==
                                              'Operator  Dashboard') {
                                            await ProductionRoute()
                                                .gotoOperatorScreen(
                                                    context: context,
                                                    barcode: state.barcode!,
                                                    seqno: '',
                                                    processrouteid: '',
                                                    cprunnumber: '',
                                                    cpchildid: '');
                                          } else {
                                            debugPrint("No program found");
                                          }
                                        }
                                      }
                                    }
                                  : null,
                              child: Text(
                                "Next",
                                style: AppTheme.tabTextStyle().copyWith(
                                    color: state.code == ''
                                        ? Colors.grey
                                        : Colors.white),
                              ),
                            );
                          },
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          verticaltab: QuickFixUi.notVisible(),
          mobile: const Center(
            child: Text("This Screen support in tab view"),
          ),
          windows: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: scanBarcodeBtn(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  productDescription(w: SizeConfig.blockSizeHorizontal! * 50),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical! * 8,
                    width: SizeConfig.blockSizeHorizontal! * 30,
                    margin: const EdgeInsets.only(top: 50),
                    child: BlocListener<ScanCubit, ScanState>(
                      listener: (context, state) {
                        // print("==========${state.code}");
                      },
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Enter", style: AppTheme.tabTextStyle()),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          linux: QuickFixUi.notVisible(),
        ),
      ),
    );
  }

  Container productDescription({double h = 0, double w = 80}) {
    return Container(
        // color: Colors.amber,
        margin: const EdgeInsets.only(top: 50),
        child: BlocBuilder<ScanCubit, ScanState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                barcodeDetails(
                    detailName: "PO",
                    detailDesc: state.barcode?.po ?? "",
                    w: w),
                barcodeDetails(
                    detailName: "Product",
                    detailDesc: state.barcode?.product ?? "",
                    w: w),
                barcodeDetails(
                    detailName: "Line No",
                    detailDesc: state.barcode?.lineitemnumber ?? "",
                    w: w),
                barcodeDetails(
                    detailName: "Rawmaterial",
                    detailDesc: state.barcode?.rawmaterial ?? "",
                    w: w),
                barcodeDetails(
                    detailName: "Dispatch",
                    detailDesc: state.barcode?.dispatchDate ?? "",
                    w: w),
                barcodeDetails(
                    detailName: "Issued Qty",
                    detailDesc: state.barcode?.issueQty.toString() ?? "",
                    w: w),
              ],
            );
          },
        ));
  }

  Widget barcodeDetails(
      {String? detailName, dynamic detailDesc, double h = 0, double w = 120}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: AppColors.whiteTheme,
          border: Border.all(width: 0.5, color: Colors.black45),
          borderRadius: BorderRadius.circular(6),
        ),
        width: w,
        height: SizeConfig.blockSizeVertical! * 7,
        child: Stack(
          children: [
            Positioned(
                top: SizeConfig.blockSizeVertical! * 7 / 3.5,
                left: 70,
                child: Text("${detailName!} : ",
                    style: AppTheme.tabSubTextStyle())),
            Positioned(
                top: SizeConfig.blockSizeVertical! * 7 / 3.5,
                left: 230,
                child: Text(detailDesc.toString(),
                    style: AppTheme.tabSubTextStyle()))
          ],
        ),
      ),
    );
  }

  List<Widget> scanBarcodeBtn(BuildContext context) {
    return [
      Container(
          margin: const EdgeInsets.only(top: 0),
          height: SizeConfig.blockSizeVertical! * 8,
          width: SizeConfig.blockSizeHorizontal! * 30,
          child: FilledButton.icon(
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
            onPressed: () {
              BlocProvider.of<ScanCubit>(context)
                  .scanCode(val: true, context: context);
              BlocProvider.of<DashboardBloc>(context).add(DashboardMenuEvent());
            },
          )),
      const SizedBox(
        width: 20,
      ),
      Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          height: SizeConfig.blockSizeVertical! * 8,
          width: SizeConfig.blockSizeHorizontal! * 30,
          child: Align(
              alignment: Alignment.center,
              child: BlocBuilder<ScanCubit, ScanState>(
                builder: (context, state) {
                  return TextField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      readOnly: true,
                      controller: TextEditingController(
                        text: state.code != "" ? state.code : "",
                      ),
                      textAlign: TextAlign.center,
                      style: AppTheme.tabTextStyle()
                          .copyWith(color: Colors.black));
                },
              )))
    ];
  }
}
