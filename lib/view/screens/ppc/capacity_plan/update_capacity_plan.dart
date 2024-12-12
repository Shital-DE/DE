import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/capacity_plan/bloc/capacity_bloc/capacity_plan_bloc.dart';
import '../../../../bloc/ppc/capacity_plan/bloc/graph_bloc/graph_view_bloc.dart';
import '../../../../services/model/capacity_plan/model.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/custom_datatable.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/debounce_button.dart';

class UpdateCapacityPlan extends StatelessWidget {
  const UpdateCapacityPlan({super.key});
  static const int rowPerPage = 10;

  static List<DataRow> rows = [];
  @override
  Widget build(BuildContext context) {
    String fromDate = '', toDate = '';
    int runnumber = 0;
    SizeConfig.init(context);
    BlocProvider.of<GraphViewBloc>(context).add(GraphViewInitEvent());
    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Update Capacity Plan'),
      body: ListView(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, right: 20),
              width: SizeConfig.blockSizeHorizontal! * 25,
              child: BlocBuilder<GraphViewBloc, GraphViewState>(
                builder: (context, state) {
                  if (state is GraphViewLoadState ||
                      state is GraphViewInitial) {
                    return CustomDropdownSearch<CapacityPlanList>(
                      items: state.cpList!,
                      hintText: "Select CP",
                      itemAsString: (item) => item.capacityPlanName!,
                      onChanged: (e) {
                        fromDate = e!.fromDate!;
                        toDate = e.toDate!;
                        runnumber = e.runnumber!;
                        BlocProvider.of<CapacityPlanBloc>(context).add(
                            AddNewProductsCPEvent(
                                toDate: e.toDate!,
                                fromDate: e.fromDate!,
                                runnumber: e.runnumber!));
                      },
                    );
                  } else {
                    return const Text("data");
                  }
                },
              ),
            ),
            BlocBuilder<CapacityPlanBloc, CapacityPlanState>(
                builder: (context, state) {
              if (state is CapacityPlanListState &&
                  state.cplist.isEmpty != true &&
                  state.cplist
                          .toList()
                          .any((element) => element.route!.isEmpty) !=
                      true) {
                return Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 250,
                    height: 45,
                    child: DebouncedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                              (states) => const Color(0xFF1978a5))),
                      onPressed: () {
                        BlocProvider.of<CapacityPlanBloc>(context).add(
                            UpdateCPEvent(
                                fromDate: fromDate,
                                toDate: toDate,
                                runnumber: runnumber,
                                cpList: state.cplist));
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                                child: AlertDialog(
                                  icon: const Icon(Icons.check_circle),
                                  content: const Text(
                                    "Capacity Plan Updated",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK"))
                                  ],
                                ),
                              );
                            });
                      },
                      text: "Update Capacity Plan",
                    ));
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight! * 1,
              child: BlocBuilder<CapacityPlanBloc, CapacityPlanState>(
                builder: (context, state) {
                  if (state is CapacityPlanListState) {
                    // return FutureBuilder(
                    //     future: isLoading(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData != false) {
                    rows = paginatedTableList(state, context);
                    return paginatedTable(rows);
                    //   } else {
                    //     return const Center(
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   }
                    // });
                  } else if (state is CapacityPlanInitial) {
                    rows = paginatedTableList(state, context);
                    return paginatedTable(rows);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget paginatedTable(List<DataRow> rows) {
    return CustomPaginatedTable(
      // columnIndexForSearchIcon: 1,
      columnNames: const [
        'SrNo',
        'PO',
        'Product',
        'RevisionNo',
        'LineItemNo',
        'Qty',
        'PlanDate',
        'Workcentre-Route'
      ],
      rowData: rows,
    );
  }
}
