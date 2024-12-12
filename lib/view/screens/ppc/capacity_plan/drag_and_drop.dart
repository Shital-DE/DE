import 'package:de/bloc/ppc/capacity_plan/bloc/dragdrop_bloc/dragdrop_bloc.dart';
import 'package:de/utils/app_theme.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/appbar/appbar_bloc.dart';
import '../../../../bloc/ppc/capacity_plan/bloc/graph_bloc/graph_view_bloc.dart';
import '../../../../services/model/capacity_plan/model.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/custom_dropdown.dart';
import 'cp_execution.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({super.key});

  @override
  State<DragAndDrop> createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    BlocProvider.of<GraphViewBloc>(context).add(GraphViewInitEvent());

    return BlocProvider.value(
      value: DragDropBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: CustomAppbar().appbar(context: context, title: 'Drag and Drop'),
        body: buildUI(),
      ),
    );
  }

  Widget buildUI() {
    return Stack(
      children: [
        SafeArea(
          child: ListView(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  // height: SizeConfig.blockSizeVertical! * 8, //60
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
                            BlocProvider.of<DragDropBloc>(context)
                                .add(RunnumberEvent(runnumber: e!.runnumber!));
                          },
                        );
                      } else {
                        return const Text("data");
                      }
                    },
                  ),
                ),
                Container(
                    height: SizeConfig.screenHeight! * 0.06,
                    margin: const EdgeInsets.only(left: 30, top: 20),
                    child: BlocBuilder<DragDropBloc, DragDropState>(
                      builder: (context, state) {
                        return DebouncedButton(
                            text: "Assign",
                            onPressed: state.products.isNotEmpty
                                ? () {
                                    if (state is DragdropLoadedList) {
                                      BlocProvider.of<DragDropBloc>(context)
                                          .add(SaveAllCPProductEvent(
                                              product: state.products,
                                              runnumber: state.runnumber));
                                    }
                                  }
                                : () {
                                    QuickFixUi.errorMessage(
                                        "Empty List", context);
                                  },
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith(
                                        (states) => const Color(0XFF1978a5))));
                      },
                    )),
              ]),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      BlocBuilder<DragDropBloc, DragDropState>(
                        builder: (context, state) {
                          if (state is DragdropLoadedList) {
                            return Container(
                              margin: const EdgeInsets.only(left: 40),
                              decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF1978a5), //const Color.fromARGB(255, 190, 187, 187),
                                  borderRadius: BorderRadius.circular(5)),
                              width: SizeConfig.screenWidth! * 0.69, //900
                              height: SizeConfig.blockSizeVertical! * 5.8, //45,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    width: SizeConfig.blockSizeHorizontal! * 12,
                                    height: SizeConfig.blockSizeVertical! *
                                        5.2, //40,
                                    child: Text(
                                      "PO",
                                      style: AppTheme.tabSubTextStyle()
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 10),
                                    width: SizeConfig.blockSizeHorizontal! * 13,
                                    height: SizeConfig.blockSizeVertical! * 5.2,
                                    child: Text(
                                      "Product",
                                      style: AppTheme.tabSubTextStyle()
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    width: SizeConfig.blockSizeHorizontal! * 9,
                                    height: SizeConfig.blockSizeVertical! * 5.2,
                                    child: Text(
                                      "LineItem",
                                      style: AppTheme.tabSubTextStyle()
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    width: SizeConfig.blockSizeHorizontal! * 9,
                                    height: SizeConfig.blockSizeVertical! * 5.2,
                                    child: Text(
                                      "Sequence",
                                      style: AppTheme.tabSubTextStyle()
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    width:
                                        SizeConfig.blockSizeHorizontal! * 10.5,
                                    height: SizeConfig.blockSizeVertical! * 5.2,
                                    child: Text(
                                      "Qty",
                                      style: AppTheme.tabSubTextStyle()
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 10),
                                    width: SizeConfig.blockSizeHorizontal! * 12,
                                    height: SizeConfig.blockSizeVertical! * 5.2,
                                    child: Text(
                                      "Workcentre",
                                      style: AppTheme.tabSubTextStyle()
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 40, top: 7),
                          width: SizeConfig.screenWidth! * 0.69,
                          height: SizeConfig.screenHeight! * 0.68,
                          child: buildProductList()),
                    ]),
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 40),
                              width: SizeConfig.screenWidth! * 0.26,
                              height: SizeConfig.screenHeight! * 0.7,
                              child: buildWorkcentreGrid())
                        ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProductList() {
    return BlocBuilder<DragDropBloc, DragDropState>(
      builder: (context, state) {
        if (state is DragdropLoadedList && state.products.isNotEmpty) {
          return ListView.separated(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final item = state.products[index];

              return LongPressDraggable<ProductDragDrop>(
                data: item, //
                dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: Opacity(
                  opacity: 0.85,
                  child: displayProduct(item, const Color(0xFF11A692)),
                ),

                child: displayProduct(item, const Color(0xFF8dcdf2)),

                onDragCompleted: () {
                  QuickFixUi.successMessage("Dragged Successfully", context);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 7,
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildWorkcentreGrid() {
    return BlocBuilder<DragDropBloc, DragDropState>(
      builder: (context, state) {
        if (state is DragdropLoadedList) {
          return GridView.count(
              primary: false,
              padding: const EdgeInsets.only(
                  top: 2, left: 50, right: 50, bottom: 50),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children:
                  state.workcentre.map(buildWorkcentreWithDropZone).toList());
        } else {
          return const Text("");
        }
      },
    );
  }

  Widget buildWorkcentreWithDropZone(WorkcentreCP workCentre) {
    return BlocBuilder<DragDropBloc, DragDropState>(
      builder: (context, state) {
        return DragTarget<ProductDragDrop>(
          builder: (context, item, list) {
            if (state is DragdropLoadedList) {
              return WorkcentreDropZone(
                highlighted: item.isNotEmpty,
                workcentreCP: workCentre,
                runnumber: state.runnumber,
              );
            } else {
              return const SizedBox();
            }
          },
          onAcceptWithDetails: (item) {
            BlocProvider.of<DragDropBloc>(context).add(SaveCPProductEvent(
              product: item.data,
              workcentre: workCentre.id!,
            ));
          },
        );
      },
    );
  }
}

class WorkcentreDropZone extends StatelessWidget {
  const WorkcentreDropZone({
    super.key,
    required this.workcentreCP,
    this.highlighted = false,
    required this.runnumber,
  });

  final WorkcentreCP workcentreCP;
  final bool highlighted;
  final int runnumber;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.black : Colors.white;
    List<ProductDragDrop> wsProducts = [];
    return Transform.scale(
      scale: highlighted ? 1.020 : 1.0,
      child: BlocBuilder<DragDropBloc, DragDropState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              BlocProvider.of<DragDropBloc>(context).add(
                  ShowWorkcentreProductEvent(
                      runnumber: runnumber, workcentre: workcentreCP.id!));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (newcontext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<DragDropBloc>(context),
                          ),
                          BlocProvider<AppBarBloc>(
                            create: (BuildContext context) => AppBarBloc(),
                          ),
                        ],
                        child: BlocBuilder<DragDropBloc, DragDropState>(
                            builder: (context, state) {
                          if (state is DragdropLoadedList) {
                            wsProducts = state.wsProducts!;
                          }

                          return WorkstationCPProducts(
                              workcentre: workcentreCP.code.toString(),
                              wsProducts: wsProducts);
                        }),
                      )));
            },
            child: Material(
              elevation: highlighted ? 6 : 3,
              borderRadius: BorderRadius.circular(15),
              color: highlighted
                  ? const Color(0xFF11A692)
                  : const Color(0xFF1170A6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    workcentreCP.code.toString(),
                    style:
                        AppTheme.tabSubTextStyle().copyWith(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget displayProduct(ProductDragDrop product, Color color) {
  return Material(
    color: color,
    // elevation: 5,
    borderRadius: BorderRadius.circular(5),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: SizeConfig.blockSizeHorizontal! * 12,
          height: SizeConfig.blockSizeVertical! * 5.8, //45,
          // color: Colors.amber,
          padding: EdgeInsets.only(
              left: 20, top: (SizeConfig.blockSizeVertical! * 5.8) / 3),

          child: Text(
            product.po!,
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: 5, top: (SizeConfig.blockSizeVertical! * 5.8) / 3),
          width: SizeConfig.blockSizeHorizontal! * 13, //170,
          height: SizeConfig.blockSizeVertical! * 5.8,
          child: Text(
            "${product.product!}- ${product.revisionNumber!}",
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: 10, top: (SizeConfig.blockSizeVertical! * 5.8) / 3),
          width: SizeConfig.blockSizeHorizontal! * 9, //120,
          height: SizeConfig.blockSizeVertical! * 5.8,
          child: Text(
            product.lineitemnumber.toString(),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: 10, top: (SizeConfig.blockSizeVertical! * 5.8) / 3),
          width: SizeConfig.blockSizeHorizontal! * 9,
          height: SizeConfig.blockSizeVertical! * 5.8,
          child: Text(
            product.sequencenumber.toString(),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: 10, top: (SizeConfig.blockSizeVertical! * 5.8) / 3),
          width: SizeConfig.blockSizeHorizontal! * 10.5, //140,
          height: SizeConfig.blockSizeVertical! * 5.8,
          child: Text(
            product.quantity.toString().split('.')[0],
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: 5, top: (SizeConfig.blockSizeVertical! * 5.8) / 3),
          width: SizeConfig.blockSizeHorizontal! * 12, //150,
          height: SizeConfig.blockSizeVertical! * 5.8,
          child: Text(
            product.workcentre.toString(),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );
}
