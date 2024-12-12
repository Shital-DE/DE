// Author : Shital Gayakwad
// Created Date : 17 November 2024
// Description : Assembly component requirement

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:de/utils/app_colors.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/sales_order/sales_order_bloc.dart';
import '../../../bloc/sales_order/sales_order_event.dart';
import '../../../bloc/sales_order/sales_order_state.dart';
import '../../../services/model/product/product_structure_model.dart';
import '../../../services/model/sales_order/sales_order_model.dart';
import '../../../services/repository/product/pam_repository.dart';
import '../../widgets/appbar.dart';
import '../../widgets/product_structure_widget.dart';

class IssueStockForAssembly extends StatefulWidget {
  final List<SelectedAssembliesComponentRequirements>
      selectedAssembliesDataList;
  const IssueStockForAssembly(
      {super.key, required this.selectedAssembliesDataList});

  @override
  State<IssueStockForAssembly> createState() => _IssueStockForAssemblyState();
}

class _IssueStockForAssemblyState extends State<IssueStockForAssembly> {
  // Scroll controller
  final ScrollController horizontalScrollController = ScrollController();

  // Stream controller
  StreamController<bool> screenBackEventController =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    final blocProvider = BlocProvider.of<SalesOrderBloc>(context);
    blocProvider.add(AllOrdersEvent());
    super.initState();
  }

  @override
  void dispose() {
    // Scroll controller
    horizontalScrollController.dispose();

    // Stream controller
    screenBackEventController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<SalesOrderBloc>(context);
    Size size = MediaQuery.of(context).size;
    double staticRowHeight = 35,
        tableHeight = (size.height - 20) >
                (((widget.selectedAssembliesDataList.length + 2) *
                        staticRowHeight) -
                    20)
            ? (((widget.selectedAssembliesDataList.length + 2) *
                    staticRowHeight) -
                20)
            : (size.height - 20);
    NavigatorState navigator = Navigator.of(context);
    return StreamBuilder<bool>(
        stream: screenBackEventController.stream,
        builder: (context, screenBackEventControllerSnapshot) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              if (screenBackEventControllerSnapshot.data != null &&
                  screenBackEventControllerSnapshot.data! == true) {
                screenBackEventController.add(false);
                blocProvider.add(AllOrdersEvent());
              } else {
                navigator.pop();
              }
            },
            child: Scaffold(
              appBar:
                  CustomAppbar().appbar(context: context, title: 'Issue stock'),
              body: BlocBuilder<SalesOrderBloc, SalesOrderState>(
                  builder: (context, state) {
                if (state is IssueStockForAsssemblyState) {
                  return Stack(
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                children:
                                    AppColors.colorWithDefinitions.map((e) {
                              return stockColorPalette(
                                  color: e['color'],
                                  defination: e['definition']);
                            }).toList()),
                          )),
                      SizedBox(
                        width: size.width,
                        height: tableHeight,
                        child: Row(
                          children: [
                            table(
                                size: size,
                                staticRowHeight: staticRowHeight,
                                context: context,
                                blocProvider: blocProvider,
                                state: state,
                                tableHeight: tableHeight),
                            state.node.buildProductStructure != null
                                ? SizedBox(
                                    width: (size.width - 20) / 2,
                                    height: tableHeight,
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SizedBox(
                                            child: Scrollbar(
                                              thumbVisibility: true,
                                              controller:
                                                  horizontalScrollController,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                controller:
                                                    horizontalScrollController,
                                                child: Container(
                                                  child: buildTree(
                                                      node: state.node,
                                                      context: context,
                                                      parentPart: state
                                                          .node
                                                          .buildProductStructure![
                                                              0]
                                                          .part!,
                                                      size: size,
                                                      state: state,
                                                      blocProvider:
                                                          blocProvider),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return tableWidget(
                      size: size,
                      staticRowHeight: staticRowHeight,
                      context: context,
                      blocProvider: blocProvider,
                      tableWidth: size.width - 20,
                      tableHeight: tableHeight,
                      columns: [
                        ColumnData(label: 'PO'),
                        ColumnData(label: 'Product'),
                        ColumnData(label: 'Revision number'),
                        ColumnData(label: 'Description'),
                        ColumnData(label: 'Due date'),
                        ColumnData(label: 'Order quantity'),
                        ColumnData(label: 'Action'),
                      ],
                      rows: widget.selectedAssembliesDataList.map((element) {
                        double rowHeight = staticRowHeight;

                        return RowData(cell: [
                          TableDataCell(
                            height: rowHeight,
                            label: Text(
                              element.po.toString(),
                              textAlign: TextAlign.center,
                              style: rowTextStyle(),
                            ),
                          ),
                          TableDataCell(
                              height: rowHeight,
                              label: Text(
                                element.childproduct.toString(),
                                textAlign: TextAlign.center,
                                style: rowTextStyle(),
                              )),
                          TableDataCell(
                              height: rowHeight,
                              label: Text(
                                element.revisionNumber.toString(),
                                textAlign: TextAlign.center,
                                style: rowTextStyle(),
                              )),
                          TableDataCell(
                              height: rowHeight,
                              label: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  element.productDescription.toString(),
                                  textAlign: TextAlign.center,
                                  style: rowTextStyle(),
                                ),
                              )),
                          TableDataCell(
                            height: rowHeight,
                            label: Text(
                              DateTime.parse(element.duedate.toString())
                                  .toLocal()
                                  .toString()
                                  .substring(0, 10),
                              textAlign: TextAlign.center,
                              style: rowTextStyle(),
                            ),
                          ),
                          TableDataCell(
                              height: rowHeight,
                              label: Text(
                                element.quantity.toString(),
                                textAlign: TextAlign.center,
                                style: rowTextStyle(),
                              )),
                          actionDataCell(
                              rowHeight: rowHeight,
                              context: context,
                              blocProvider: blocProvider,
                              element: element,
                              color: Theme.of(context).primaryColor),
                        ]);
                      }).toList());
                }
              }),
            ),
          );
        });
  }

  SizedBox stockColorPalette(
      {required Color color, required String defination}) {
    return SizedBox(
      width: 200,
      height: 20,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            defination,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildTree(
      {required ProductStructureDetailsModel node,
      required BuildContext context,
      required String parentPart,
      required Size size,
      required IssueStockForAsssemblyState state,
      required SalesOrderBloc blocProvider}) {
    return Column(
      children: [
        CustomPaint(
            painter: HorizontalLinePainter(
              node: node,
              context: context,
              product: parentPart,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 220,
                height: 50,
                child: InkWell(
                    // style: ElevatedButton.styleFrom(
                    // backgroundColor: AppColors().getColorDependingUponStock(
                    //     currentStock:
                    //         node.buildProductStructure![0].currentstock!,
                    //     requiredQuantity: node
                    //         .buildProductStructure![0].quantity!
                    //         .toDouble(),
                    //     issuedQuantity: node
                    //         .buildProductStructure![0].issuedquantity!)),
                    onTap: () async {
                      double dialogWidth = 600, rowHeight = 35;
                      List<IssuedStockModel> issuedStock = await PamRepository()
                          .selectedProductIssuedStock(
                              token: state.token,
                              productId: node.buildProductStructure![0].partId
                                  .toString(),
                              revision: node.buildProductStructure![0].revision
                                  .toString(),
                              parentProductId: node
                                  .buildProductStructure![0].parentpartId
                                  .toString(),
                              soDetailsId:
                                  state.selectedProduct.sodetailsId.toString());

                      issueStockDialog(
                          context: context,
                          dialogWidth: dialogWidth,
                          issuedStock: issuedStock,
                          rowHeight: rowHeight,
                          node: node,
                          state: state,
                          blocProvider: blocProvider);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColors().getColorDependingUponStock(
                                currentStock: node
                                    .buildProductStructure![0].currentstock!,
                                requiredQuantity: node
                                    .buildProductStructure![0].quantity!
                                    .toDouble(),
                                issuedQuantity: node
                                    .buildProductStructure![0].issuedquantity!),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                node.buildProductStructure![0].part!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              )),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Required : ${node.buildProductStructure![0].quantity}",
                                  style: buttonFontSize()),
                              Text(
                                  "Issued : ${node.buildProductStructure![0].issuedquantity}",
                                  style: buttonFontSize()),
                              Text(
                                  "Stock : ${node.buildProductStructure![0].currentstock}",
                                  style: buttonFontSize()),
                            ],
                          ),
                        )
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Container(
                        //       child: Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 8),
                        //         child: Text(
                        //           node.buildProductStructure![0].part!,
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontWeight: Platform.isAndroid
                        //                   ? size.width < 550
                        //                       ? FontWeight.normal
                        //                       : FontWeight.bold
                        //                   : size.width < 1350
                        //                       ? FontWeight.normal
                        //                       : FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       width: 105,
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        // Text(
                        //     "Required : ${node.buildProductStructure![0].quantity}",
                        //     style: buttonFontSize()),
                        // Text(
                        //     "Issued : ${node.buildProductStructure![0].issuedquantity}",
                        //     style: buttonFontSize()),
                        // Text(
                        //     "Stock : ${node.buildProductStructure![0].currentstock}",
                        //     style: buttonFontSize()),
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // ),
                        )),
                // child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: AppColors().getColorDependingUponStock(
                //             currentStock:
                //                 node.buildProductStructure![0].currentstock!,
                //             requiredQuantity: node
                //                 .buildProductStructure![0].quantity!
                //                 .toDouble(),
                //             issuedQuantity: node
                //                 .buildProductStructure![0].issuedquantity!)),
                //     onPressed: () async {
                //       double dialogWidth = 600, rowHeight = 35;
                //       List<IssuedStockModel> issuedStock = await PamRepository()
                //           .selectedProductIssuedStock(
                //               token: state.token,
                //               productId: node.buildProductStructure![0].partId
                //                   .toString(),
                //               revision: node.buildProductStructure![0].revision
                //                   .toString(),
                //               parentProductId: node
                //                   .buildProductStructure![0].parentpartId
                //                   .toString(),
                //               soDetailsId:
                //                   state.selectedProduct.sodetailsId.toString());

                //       issueStockDialog(
                //           context: context,
                //           dialogWidth: dialogWidth,
                //           issuedStock: issuedStock,
                //           rowHeight: rowHeight,
                //           node: node,
                //           state: state,
                //           blocProvider: blocProvider);
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         Text(
                //           node.buildProductStructure![0].part!,
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: Platform.isAndroid
                //                   ? size.width < 550
                //                       ? FontWeight.normal
                //                       : FontWeight.bold
                //                   : size.width < 1350
                //                       ? FontWeight.normal
                //                       : FontWeight.bold),
                //         ),
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //                 "Required : ${node.buildProductStructure![0].quantity}",
                //                 style: buttonFontSize()),
                //             Text(
                //                 "Issued : ${node.buildProductStructure![0].issuedquantity}",
                //                 style: buttonFontSize()),
                //             Text(
                //                 "Stock : ${node.buildProductStructure![0].currentstock}",
                //                 style: buttonFontSize()),
                //           ],
                //         )
                //       ],
                //     )),
              ),
            )),
        if (node.buildProductStructure![0].children!.isNotEmpty)
          CustomPaint(
            size: const Size(16, 16),
            painter: LinePainter(
              node: node,
              context: context,
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 72), // 50
              child: Column(
                children: node.buildProductStructure![0].children!
                    .map((child) => buildTree(
                        node: ProductStructureDetailsModel(
                            buildProductStructure: [child]),
                        context: context,
                        parentPart: parentPart,
                        size: size,
                        state: state,
                        blocProvider: blocProvider))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  TextStyle buttonFontSize() => const TextStyle(
      fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black);

  Future<dynamic> issueStockDialog(
      {required BuildContext context,
      required double dialogWidth,
      required List<IssuedStockModel> issuedStock,
      required double rowHeight,
      required ProductStructureDetailsModel node,
      required IssueStockForAsssemblyState state,
      required SalesOrderBloc blocProvider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: dialogTitle(context: context),
            content: Container(
              width: dialogWidth,
              height: issuedStock.isEmpty
                  ? 100
                  : (100 + ((issuedStock.length + 2) * rowHeight)) >= 600
                      ? 600
                      : (100 + ((issuedStock.length + 2) * rowHeight)),
              margin: const EdgeInsets.all(1),
              child: ListView(
                children: [
                  staticRowWidget(
                      label1: 'Product',
                      text1: node.buildProductStructure![0].part.toString(),
                      label2: 'Revision number',
                      text2: node.buildProductStructure![0].revision.toString(),
                      width: dialogWidth / 2),
                  staticRowWidget(
                      label1: 'Required quantity',
                      text1: node.buildProductStructure![0].quantity.toString(),
                      label2: 'Available stock',
                      text2: node.buildProductStructure![0].currentstock
                          .toString(),
                      width: dialogWidth / 2),
                  issuedStock.isNotEmpty
                      ? issuedStockTable(
                          dialogWidth: dialogWidth,
                          issuedStock: issuedStock,
                          rowHeight: rowHeight,
                          context: context,
                          node: node)
                      : const Text('')
                ],
              ),
            ),
            actions: [
              node.buildProductStructure![0].currentstock == 0
                  ? const Text('')
                  : node.buildProductStructure![0].issuedquantity! <
                          node.buildProductStructure![0].quantity!.toDouble()
                      ? issueButton(
                          context: context,
                          state: state,
                          node: node,
                          blocProvider: blocProvider)
                      : const Text(''),
              cancelButton(context: context)
            ],
          );
        });
  }

  Center dialogTitle({required BuildContext context}) {
    return Center(
      child: Text(
        'Issue stock',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  FilledButton cancelButton({required BuildContext context}) {
    return FilledButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.error),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteTheme),
        ));
  }

  FilledButton issueButton(
      {required BuildContext context,
      required IssueStockForAsssemblyState state,
      required ProductStructureDetailsModel node,
      required SalesOrderBloc blocProvider}) {
    return FilledButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.error),
        ),
        onPressed: () async {
          String response = await PamRepository()
              .productStockRegister(token: state.token, payload: {
            'product_id': node.buildProductStructure![0].partId,
            'revision_number': node.buildProductStructure![0].revision,
            'createdby': state.userId,
            'new_quantity':
                node.buildProductStructure![0].quantity!.toDouble() -
                    node.buildProductStructure![0].issuedquantity!,
            'preUOM': node.buildProductStructure![0].unitOfMeasurementId,
            'postUOM': node.buildProductStructure![0].unitOfMeasurementId,
            'drcr': 'C',
            'parentproduct_id': node.buildProductStructure![0].parentpartId,
            'sodetails_id': state.selectedProduct.sodetailsId
          });
          if (response == 'Success') {
            Navigator.of(context).pop();
            blocProvider.add(IssueStockForAsssemblyEvent(
                selectedProduct: state.selectedProduct));
          } else {
            QuickFixUi()
                .showCustomDialog(context: context, errorMessage: response);
          }
        },
        child: const Text(
          'Issue',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteTheme),
        ));
  }

  SizedBox issuedStockTable(
      {required double dialogWidth,
      required List<IssuedStockModel> issuedStock,
      required double rowHeight,
      required BuildContext context,
      required ProductStructureDetailsModel node}) {
    return SizedBox(
      width: dialogWidth,
      height: (issuedStock.length + 2) * rowHeight,
      child: CustomTable(
          tablewidth: dialogWidth,
          tableheight: (issuedStock.length + 2) * rowHeight,
          columnWidth: 200,
          showIndex: true,
          rowHeight: rowHeight,
          headerHeight: rowHeight,
          headerStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Theme.of(context).colorScheme.error),
          tableheaderColor: AppColors.whiteTheme,
          tableBorderColor: Theme.of(context).colorScheme.error,
          tableOutsideBorder: true,
          enableHeaderBottomBorder: true,
          enableRowBottomBorder: true,
          headerBorderThickness: .5,
          headerBorderColor: Theme.of(context).colorScheme.error,
          column: [
            ColumnData(label: 'Issued date'),
            ColumnData(label: 'Issued by'),
            ColumnData(width: 200 - rowHeight, label: 'Issued quantity'),
          ],
          rows: [
            ...issuedStock.map((element) {
              return RowData(cell: [
                TableDataCell(
                    label: Text(
                  DateTime.parse(element.issuedOn.toString())
                      .toLocal()
                      .toString()
                      .substring(0, 10),
                  style: textStyle(),
                )),
                TableDataCell(
                    label: Text(
                  element.issuedBy.toString(),
                  style: textStyle(),
                )),
                TableDataCell(
                    width: 200 - rowHeight,
                    label: Text(
                      element.issuedQuantity.toString(),
                      style: textStyle(),
                    )),
              ]);
            }).toList(),
            RowData(cell: [
              TableDataCell(
                  width: 200,
                  label: Text(
                    'Total',
                    style: textStyle(),
                  )),
              TableDataCell(width: 200, label: const Text('')),
              TableDataCell(
                  width: 200 - rowHeight,
                  label: Text(
                    node.buildProductStructure![0].issuedquantity.toString(),
                    style: textStyle(),
                  )),
            ])
          ]),
    );
  }

  TextStyle textStyle() => const TextStyle(fontSize: 12);

  Row staticRowWidget(
      {required String label1,
      required String text1,
      required String label2,
      required String text2,
      required double width}) {
    return Row(
      children: [
        staticTextWidget(headerTextData: label1, text: text1, width: width),
        staticTextWidget(headerTextData: label2, text: text2, width: width)
      ],
    );
  }

  SizedBox staticTextWidget(
      {required String headerTextData,
      required String text,
      required double width}) {
    return SizedBox(
      width: width,
      height: 50,
      child: Row(
        children: [
          headerText(text: headerTextData),
          SizedBox(
            width: 110,
            height: 50,
            child: Text(text, style: const TextStyle(fontSize: 12)),
          )
        ],
      ),
    );
  }

  Row headerText({required String text}) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 50,
          child: Text(text,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(
          width: 20,
          height: 50,
          child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Container table(
      {required Size size,
      required double staticRowHeight,
      required BuildContext context,
      required SalesOrderBloc blocProvider,
      required IssueStockForAsssemblyState state,
      required double tableHeight}) {
    return tableWidget(
        size: size,
        staticRowHeight: staticRowHeight,
        context: context,
        blocProvider: blocProvider,
        tableWidth: (size.width - 20) / 2,
        tableHeight: tableHeight,
        columns: [
          ColumnData(label: 'PO'),
          ColumnData(label: 'Product'),
          ColumnData(label: 'Revision number'),
          ColumnData(label: 'Quantity'),
          ColumnData(label: 'Action'),
        ],
        rows: widget.selectedAssembliesDataList.map((element) {
          double rowHeight = staticRowHeight;
          return RowData(
              rowColor:
                  state.selectedProduct.assemblybomId == element.assemblybomId
                      ? AppColors.greenTheme.withOpacity(.7)
                      : Colors.white,
              cell: [
                TableDataCell(
                  height: rowHeight,
                  label: Text(
                    element.po.toString(),
                    textAlign: TextAlign.center,
                    style: rowTextStyle(
                        isRowSelected: state.selectedProduct.assemblybomId ==
                            element.assemblybomId),
                  ),
                ),
                TableDataCell(
                    height: rowHeight,
                    label: Text(
                      element.childproduct.toString(),
                      textAlign: TextAlign.center,
                      style: rowTextStyle(
                          isRowSelected: state.selectedProduct.assemblybomId ==
                              element.assemblybomId),
                    )),
                TableDataCell(
                    height: rowHeight,
                    label: Text(
                      element.revisionNumber.toString(),
                      textAlign: TextAlign.center,
                      style: rowTextStyle(
                          isRowSelected: state.selectedProduct.assemblybomId ==
                              element.assemblybomId),
                    )),
                TableDataCell(
                  height: rowHeight,
                  label: Text(
                    element.quantity == null ? '' : element.quantity.toString(),
                    textAlign: TextAlign.center,
                    style: rowTextStyle(
                        isRowSelected: state.selectedProduct.assemblybomId ==
                            element.assemblybomId),
                  ),
                ),
                actionDataCell(
                    rowHeight: rowHeight,
                    context: context,
                    blocProvider: blocProvider,
                    element: element,
                    color: state.selectedProduct.assemblybomId ==
                            element.assemblybomId
                        ? Colors.green
                        : Theme.of(context).primaryColor)
              ]);
        }).toList());
  }

  TableDataCell actionDataCell(
      {required double rowHeight,
      required BuildContext context,
      required SalesOrderBloc blocProvider,
      required SelectedAssembliesComponentRequirements element,
      required Color color}) {
    return TableDataCell(
        height: rowHeight,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ElevatedButton(
            child: Text(
              'View',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 12),
            ),
            onPressed: () {
              screenBackEventController.add(true);
              blocProvider
                  .add(IssueStockForAsssemblyEvent(selectedProduct: element));
            },
          ),
        ));
  }

  Container tableWidget(
      {required Size size,
      required double staticRowHeight,
      required BuildContext context,
      required SalesOrderBloc blocProvider,
      required List<ColumnData> columns,
      required List<RowData> rows,
      required double tableWidth,
      required double tableHeight}) {
    return Container(
      width: tableWidth,
      height: tableHeight,
      margin: const EdgeInsets.all(10),
      child: CustomTable(
          tablewidth: tableWidth,
          tableheight: tableHeight,
          columnWidth: tableWidth / columns.length,
          tableheaderColor: AppColors.whiteTheme,
          headerStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Platform.isAndroid ? 14 : 12,
              color: Theme.of(context).primaryColor),
          tableOutsideBorder: true,
          enableRowBottomBorder: true,
          enableHeaderBottomBorder: true,
          headerBorderThickness: .7,
          tableBorderColor: Theme.of(context).primaryColor,
          headerHeight: staticRowHeight,
          column: columns,
          rows: rows),
    );
  }

  TextStyle rowTextStyle({bool isRowSelected = false}) => TextStyle(
      fontSize: Platform.isAndroid ? 14 : 12,
      color:
          isRowSelected == true ? AppColors.whiteTheme : AppColors.blackColor);
}
