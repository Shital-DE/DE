// Author : Shital Gayakwad
// Created Date :  22 Dec 2024
// Description : ERPX_PPC -> Cutting process screen

import 'package:de/bloc/production/cutting_bloc/cutting_bloc.dart';
import 'package:de/bloc/production/cutting_bloc/cutting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/cutting_bloc/cutting_event.dart';
import '../../../../services/model/operator/oprator_models.dart';
import '../../../../services/repository/product/product_route_repo.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/barcode_session.dart';
import '../../../widgets/production_process_widget.dart';

class CuttingProcessesScreen extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const CuttingProcessesScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    Size size = MediaQuery.of(context).size;
    final blocProvider = BlocProvider.of<CuttingBloc>(context);
    blocProvider.add(CuttingProductionProcessesEvent(
      barcode: arguments['barcode'],
    ));
    return Scaffold(
      appBar:
          CustomAppbar().appbar(context: context, title: 'Cutting processes'),
      body: BlocBuilder<CuttingBloc, CuttingState>(builder: (context, state) {
        if (state is CuttingProductionProcessesState) {
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
                        barcode: barcode!,
                        wantAction: true,
                        screenName: 'Cutting')
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
                                        'product_id': barcode!.productid,
                                        'created_by': state.userId,
                                        'productbillofmaterial_id': '',
                                        'workstation_id': state.workstationId,
                                        'workcentre_id': state.workcentreId,
                                        'setup_min': '0',
                                        'runtime_min': '0',
                                        'revision_number':
                                            barcode.revisionnumber,
                                        'sequencenumber': '5',
                                        'description': 'Cutting process',
                                        'top_bottom_data_aaray': [0, 10],
                                        'new_process_id': ''
                                      });
                                  if (response ==
                                      'Product route registered successfully') {
                                    blocProvider
                                        .add(CuttingProductionProcessesEvent(
                                      barcode: arguments['barcode'],
                                    ));
                                  }
                                },
                                child: const Text('Generate route'))
                          ],
                        ),
                      )
              ],
            ),
          );
        }
        return Container();
      }),
    );
  }
}
