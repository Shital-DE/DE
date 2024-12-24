import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/production/packing_bloc/packing_bloc.dart';
import '../../../../bloc/production/packing_bloc/packing_event.dart';
import '../../../../bloc/production/packing_bloc/packing_state.dart';
import '../../../../services/model/operator/oprator_models.dart';
import '../../../../services/repository/product/product_route_repo.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/barcode_session.dart';
import '../../../widgets/production_process_widget.dart';

class PackingProcessesScreen extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const PackingProcessesScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Barcode? barcode = arguments['barcode'];
    final blocProvider = BlocProvider.of<PackingBloc>(context);
    blocProvider.add(PackingProcessesEvent(barcode: barcode!));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          CustomAppbar().appbar(context: context, title: 'Packing processes'),
      body: BlocBuilder<PackingBloc, PackingState>(builder: (context, state) {
        if (state is PackingProcessesState) {
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
                        wantAction: true,
                        screenName: 'Packing')
                    : SizedBox(
                        width: size.width,
                        height: 60,
                        child: FilledButton(
                            onPressed: () async {
                              String response = await ProductRouteRepository()
                                  .fillDefaultProductRoute(
                                      token: state.token,
                                      payload: {
                                    'product_id': barcode.productid,
                                    'revision_number': barcode.revisionnumber,
                                    'created_by': state.userid
                                  });
                              if (response == 'success') {
                                blocProvider.add(
                                    PackingProcessesEvent(barcode: barcode));
                              }
                            },
                            child: const Text('Final inspection')),
                      ),
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
