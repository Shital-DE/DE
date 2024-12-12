import 'package:de/bloc/ppc/capacity_plan/bloc/dragdrop_bloc/dragdrop_bloc.dart';
import 'package:de/services/model/machine/workstation.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/model/capacity_plan/model.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/size_config.dart';
import '../../../widgets/appbar.dart';

class WorkstationCPProducts extends StatefulWidget {
  const WorkstationCPProducts(
      {super.key, required this.workcentre, required this.wsProducts});
  final String workcentre;
  final List<ProductDragDrop> wsProducts;

  @override
  State<WorkstationCPProducts> createState() => _WorkstationCPProductsState();
}

class _WorkstationCPProductsState extends State<WorkstationCPProducts> {
  @override
  void dispose() {
    super.dispose();
  }

  int deleteListIndex = -1;
  void deleteProduct(int index) {
    setState(() {
      deleteListIndex = index;
      widget.wsProducts.removeAt(index);
      deleteListIndex = -1;
    });
  }

  int updateListIndex = -1;
  void updateWSProduct(int index) {
    setState(() {
      updateListIndex = index;
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        updateListIndex = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Workcentre : ${widget.workcentre}'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 40),
                        width: SizeConfig.screenWidth! * 0.72, //950,959
                        height: SizeConfig.screenHeight! * 0.07, //50,54
                        decoration: BoxDecoration(
                            color: const Color(0xFF1978a5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              width: SizeConfig.blockSizeHorizontal! * 12, //159
                              height: SizeConfig.blockSizeVertical! * 5.2, //40
                              child: Text(
                                "PO",
                                style: AppTheme.tabSubTextStyle()
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5, top: 10),
                              width:
                                  SizeConfig.blockSizeHorizontal! * 12.8, //173
                              height: SizeConfig.blockSizeVertical! * 5.2,
                              child: Text(
                                "Product",
                                style: AppTheme.tabSubTextStyle()
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              width: SizeConfig.blockSizeHorizontal! * 9, //119
                              height: SizeConfig.blockSizeVertical! * 5.2,
                              child: Text(
                                "LineItem",
                                style: AppTheme.tabSubTextStyle()
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 10),
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              width: SizeConfig.blockSizeHorizontal! * 8.2,
                              height: SizeConfig.blockSizeVertical! * 5.2,
                              child: Text(
                                "Qty",
                                style: AppTheme.tabSubTextStyle()
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5, top: 10),
                              width:
                                  SizeConfig.blockSizeHorizontal! * 12, //159,
                              height: SizeConfig.blockSizeVertical! * 5.2,
                              child: Text(
                                "Workstation",
                                style: AppTheme.tabSubTextStyle()
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              width: SizeConfig.blockSizeHorizontal! * 9, //120,
                              height: SizeConfig.blockSizeVertical! * 5.2,
                              child: Text(
                                "Action",
                                style: AppTheme.tabSubTextStyle()
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 7, left: 40),
                          width: SizeConfig.screenWidth! * 0.72, //950,959
                          height: SizeConfig.screenHeight! * 0.71, //550,557

                          child:
                              // FutureBuilder<bool>(
                              //     future: isLoading(),
                              //     builder: (context, snapshot) {
                              //       if (snapshot.hasData != false) {
                              //         return
                              ListView.separated(
                            itemCount: widget.wsProducts.length,
                            itemBuilder: (context, index) {
                              final product = widget.wsProducts[index];
                              return LongPressDraggable(
                                data: widget.wsProducts[index],
                                dragAnchorStrategy: pointerDragAnchorStrategy,
                                feedback: buildwsProductList(
                                    drag: 'drag',
                                    product: product,
                                    context: context,
                                    color: const Color(
                                      0xFF11A692,
                                    ),
                                    index: index),
                                child: buildwsProductList(
                                    drag: '',
                                    product: product,
                                    context: context,
                                    color: const Color(0xFF8dcdf2),
                                    index: index),
                                onDragCompleted: () {
                                  updateWSProduct(index);
                                  QuickFixUi.successMessage(
                                      "Workstation Assigned", context);
                                },
                              );
                            },
                            separatorBuilder: (_, int index) {
                              return SizedBox(
                                height: SizeConfig.blockSizeVertical,
                              );
                            },
                          )
                          //   } else {
                          //     return BlocBuilder<DragDropBloc,
                          //         DragDropState>(
                          //       builder: (context, state) {
                          //         return const Center(
                          //             child: CircularProgressIndicator());
                          //       },
                          //     );
                          //   }
                          // })
                          ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: SizeConfig.screenWidth! * 0.24, //320,327
                          height: SizeConfig.screenHeight! * 0.8, //620,627

                          child: buildWorkstationGrid())
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildwsProductList(
      {required String drag,
      required ProductDragDrop product,
      required BuildContext context,
      required Color color,
      required int index}) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(5),
      child:
          // deleteListIndex == index
          //     ? Row(
          //         children: [
          //           SizedBox(
          //               width: 40,
          //               height: SizeConfig.blockSizeVertical! * 5.2,
          //               child: const CircularProgressIndicator()),
          //           const SizedBox(
          //             width: 12.0,
          //           ),
          //           const Text('Deleting...'),
          //         ],
          //       )
          //     :
          Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 10),
            width: SizeConfig.blockSizeHorizontal! * 12, //159
            height: SizeConfig.blockSizeVertical! * 5.2, //40
            child: Text(
              product.po!,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5, top: 10),
            width: SizeConfig.blockSizeHorizontal! * 13, //173
            height: SizeConfig.blockSizeVertical! * 5.2,
            child: Text(
              "${product.product!}${product.revisionNumber!}",
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            width: SizeConfig.blockSizeHorizontal! * 9, //119
            height: SizeConfig.blockSizeVertical! * 5.2,
            child: Text(
              product.lineitemnumber.toString(),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            width: SizeConfig.blockSizeHorizontal! * 9, //119
            height: SizeConfig.blockSizeVertical! * 5.2,
            child: Text(
              product.sequencenumber.toString(),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            width: SizeConfig.blockSizeHorizontal! * 10,
            height: SizeConfig.blockSizeVertical! * 5.2,
            child: Text(
              product.quantity.toString().split('.')[0],
              textAlign: TextAlign.left,
            ),
          ),
          updateListIndex == index
              ? SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 10,
                  height: SizeConfig.blockSizeVertical! * 5.2,
                  child: const Row(children: [CircularProgressIndicator()]))
              : Container(
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  width: SizeConfig.blockSizeHorizontal! * 10,
                  height: SizeConfig.blockSizeVertical! * 5.2,
                  child: Text(
                    product.workstation.toString(),
                    textAlign: TextAlign.left,
                  ),
                ),
          drag != 'drag'
              ? deleteListIndex == index
                  ? const Text('')
                  : IconButton(
                      onPressed: () {
                        BlocProvider.of<DragDropBloc>(context).add(
                            DeleteWCProductEvent(
                                runnumber: product.runnumber!,
                                workcentre: product.workcentreId!,
                                cpChildId: product.cpchildId!));

                        deleteProduct(index);
                        QuickFixUi.successMessage(
                            "Deleted Successfully", context);
                      },
                      icon: const Icon(Icons.delete))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget buildWorkstationGrid() {
    return FutureBuilder<Object>(
        future: isLoading(),
        builder: (context, snapshot) {
          if (snapshot.hasData != false) {
            return BlocBuilder<DragDropBloc, DragDropState>(
              builder: (context, state) {
                if (state is DragdropLoadedList) {
                  return GridView.count(
                      primary: false,
                      padding: const EdgeInsets.only(
                          top: 5, left: 40, right: 30, bottom: 30),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: state.workstations!
                          .map(buildWorkstationWithDropZone)
                          .toList());
                } else {
                  return const Text("");
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget buildWorkstationWithDropZone(WorkstationByWorkcentreId workStation) {
    return BlocBuilder<DragDropBloc, DragDropState>(
      builder: (context, state) {
        return DragTarget<ProductDragDrop>(
          builder: (context, productItems, rejectedItems) {
            if (state is DragdropLoadedList) {
              return WorkstationDropZone(
                highlighted: productItems.isNotEmpty,
                workStation: workStation,
                runnumber: state.runnumber,
              );
            } else {
              return const SizedBox();
            }
          },
          onAcceptWithDetails: (item) {
            BlocProvider.of<DragDropBloc>(context).add(UpdateWorkstationEvent(
                cpId: item.data.cpid!,
                cpChildId: item.data.cpchildId!,
                runnumber: item.data.runnumber!,
                workstationid: workStation.id!,
                workcentreId: item.data.workcentreId!));
          },
        );
      },
    );
  }
}

class WorkstationDropZone extends StatelessWidget {
  const WorkstationDropZone({
    super.key,
    required this.workStation,
    this.highlighted = false,
    required this.runnumber,
  });

  final WorkstationByWorkcentreId workStation;
  final bool highlighted;
  final int runnumber;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.black : Colors.white;

    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: BlocBuilder<DragDropBloc, DragDropState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {},
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
                    workStation.code.toString(),
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
