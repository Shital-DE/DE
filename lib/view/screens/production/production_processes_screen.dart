// Author : Shital Gayakwad
// Created Date :  20 Dec 2024
// Description : ERPX_PPC -> Production process screen

// ignore_for_file: use_build_context_synchronously

import 'package:de/bloc/production/quality/quality_dashboard_event.dart';
import 'package:de/bloc/production/quality/quality_dashboard_state.dart';
import 'package:de/services/repository/product/product_route_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/production/quality/quality_dashboard_bloc.dart';
import '../../../routes/route_names.dart';
import '../../../services/model/operator/oprator_models.dart';
import '../../widgets/appbar.dart';
import '../../widgets/barcode_session.dart';
import '../../widgets/production_process_widget.dart';

class ProductionProcessScreen extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const ProductionProcessScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    final blocProvider = BlocProvider.of<QualityBloc>(context);
    blocProvider.add(QualityProductionProcessesEvents(barcode: barcode!));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Production processes screen'),
      body: BlocBuilder<QualityBloc, QualityState>(builder: (context, state) {
        if (state is QualityProductionProcessesState) {
          return Container(
            width: size.width,
            height: size.height,
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                BarcodeSession().barcodeData(
                    context: context,
                    parentWidth: size.width - 10,
                    barcode: barcode),
                state.productProcessRouteList.isNotEmpty
                    ? ProductionProcessWidget().processTable(
                        context: context,
                        productProcessRouteList: state.productProcessRouteList,
                        barcode: barcode,
                        wantAction: true)
                    : SizedBox(
                        width: size.width,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton(
                                onPressed: () async {
                                  String response =
                                      await ProductRouteRepository()
                                          .registerProductRoute(
                                              token: state.token,
                                              payload: {
                                        'product_id': barcode.productid,
                                        'created_by': state.userId,
                                        'productbillofmaterial_id': '',
                                        'workstation_id': state.workstationId,
                                        'workcentre_id': state.workcentreId,
                                        'setup_min': '0',
                                        'runtime_min': '0',
                                        'revision_number':
                                            barcode.revisionnumber,
                                        'sequencenumber': '25',
                                        'description': 'In process inspection',
                                        'top_bottom_data_aaray': '',
                                        'new_process_id': ''
                                      });
                                  if (response ==
                                      'Product route registered successfully') {
                                    blocProvider.add(
                                        QualityProductionProcessesEvents(
                                            barcode: barcode));
                                    // Navigator.pushNamed(
                                    //     context, RouteName.qualityScreen,
                                    //     arguments: {
                                    //       'barcode': barcode,
                                    //     });
                                  }
                                },
                                child: const Text('In process inspection')),
                            const SizedBox(width: 10),
                            FilledButton(
                                onPressed: () async {
                                  String response =
                                      await ProductRouteRepository()
                                          .fillDefaultProductRoute(
                                              token: state.token,
                                              payload: {
                                        'product_id': barcode.productid,
                                        'revision_number':
                                            barcode.revisionnumber,
                                        'created_by': state.userId
                                      });
                                  if (response == 'success') {
                                    blocProvider.add(
                                        QualityProductionProcessesEvents(
                                            barcode: barcode));
                                    // Navigator.pushNamed(
                                    //     context, RouteName.qualityScreen,
                                    //     arguments: {
                                    //       'barcode': barcode,
                                    //     });
                                  }
                                },
                                child: const Text('Final inspection')),
                          ],
                        )),
              ],
            ),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      }),
    );
  }
}
