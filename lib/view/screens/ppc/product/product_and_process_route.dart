//  Author : Shital Gayakwad
// Description : ERPX_PPC -> Product and Process route
// Created : 24 August 2023

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/Product_And_Process_Route/product_and_process_route_bloc.dart';
import '../../../../services/model/machine/workcentre.dart';
import '../../../../services/model/machine/workstation.dart';
import '../../../../services/model/product/product_route.dart';
import '../../../../services/repository/product/product_route_repo.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/product.dart';

class ProductAndProcessRouteScreen extends StatelessWidget {
  const ProductAndProcessRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MakeMeResponsiveScreen(
      horixontaltab: Scaffold(
          appBar: CustomAppbar().appbar(
              context: context,
              title: 'Product route and product process route'),
          body: productRouteProcessRoute(
            context: context,
            columnWidth: [79, 170, 160, 160, 310, 90, 100, 350],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          )),
      windows: Scaffold(
        appBar: CustomAppbar().appbar(
            context: context, title: 'Product route and product process route'),
        body: productRouteProcessRoute(
            context: context,
            columnWidth: MediaQuery.of(context).size.width <= 1300
                ? [70, 160, 150, 150, 290, 80, 100, 350]
                : [100, 200, 170, 170, 310, 100, 100, 400],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  Center productRouteProcessRoute(
      {required BuildContext context,
      required List<double> columnWidth,
      required TextStyle style}) {
    final blocProvider = BlocProvider.of<ProductAndProcessRouteBloc>(context);
    BlocProvider.of<ProductRouteBloc>(context).add(const GetProductRouteData());
    return Center(
      child: ListView(
        children: [
          Padding(
            padding: MediaQuery.of(context).size.width > 1350
                ? const EdgeInsets.only(left: 230, right: 230)
                : const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      productSearch(blocProvider: blocProvider),
                      QuickFixUi.horizontalSpace(width: 30),
                      selectProductRevision(blocProvider: blocProvider),
                    ],
                  ),
                ),
                alreadyFilledRouteDataWidget()
              ],
            ),
          ),
          QuickFixUi.verticalSpace(height: 10),
          productAndProcessRouteWidget(
              blocProvider: blocProvider,
              columnWidth: columnWidth,
              style: style),
        ],
      ),
    );
  }

// Already filled products route widget
  BlocBuilder<ProductRouteBloc, ProductRouteDataState>
      alreadyFilledRouteDataWidget() {
    return BlocBuilder<ProductRouteBloc, ProductRouteDataState>(
        builder: (context, state) {
      if (state is SetProductRouteData) {
        return TextButton(
          child: Row(
            children: [
              const Text(
                'Registered route : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  state.routeCount.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
            ],
          ),
          onPressed: () {
            StreamController<List<FilledProductAndProcessRoute>>
                searchedProducts = StreamController<
                    List<FilledProductAndProcessRoute>>.broadcast();
            filledProductsDialog(
                context: context,
                state: state,
                searchedProducts: searchedProducts);
          },
        );
      } else {
        return const Stack();
      }
    });
  }

  Future<dynamic> filledProductsDialog(
      {required BuildContext context,
      required SetProductRouteData state,
      required StreamController<List<FilledProductAndProcessRoute>>
          searchedProducts}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        double width = 500, height = 700, columnWidth = 150;
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filled product route',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              SizedBox(
                  width: 160,
                  height: 40,
                  child: TextField(
                    decoration: const InputDecoration(
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.search_sharp,
                            size: 20,
                          ),
                        ),
                        hintText: 'Search product'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      List<FilledProductAndProcessRoute> searchedData =
                          state.routeData.where((item) {
                        String itemString =
                            item.product.toString().toLowerCase();
                        return itemString.contains(value.toLowerCase());
                      }).toList();
                      searchedProducts.add(searchedData);
                    },
                  ))
            ],
          ),
          content: StreamBuilder<List<FilledProductAndProcessRoute>>(
              stream: searchedProducts.stream,
              builder: (context, snapshot) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: CustomTable(
                      tablewidth: width,
                      tableheight: height,
                      rowHeight: 50,
                      showIndex: true,
                      tableheaderColor:
                          Theme.of(context).colorScheme.errorContainer,
                      headerStyle: const TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold),
                      enableRowBottomBorder: true,
                      column: [
                        ColumnData(label: 'Product', width: columnWidth),
                        ColumnData(label: 'Revision no', width: columnWidth),
                        ColumnData(label: 'Last updated', width: columnWidth),
                      ],
                      rows: snapshot.hasData
                          ? snapshot.data!
                              .map((searchedData) =>
                                  filledProductRow(searchedData, columnWidth))
                              .toList()
                          : state.routeData
                              .map((allData) =>
                                  filledProductRow(allData, columnWidth))
                              .toList()),
                );
              }),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

// Filled products data tables row widget
  RowData filledProductRow(
      FilledProductAndProcessRoute routeData, double columnWidth) {
    DateTime time = DateTime.parse(routeData.lastUpdated.toString());
    return RowData(cell: [
      TableDataCell(
          label: Text(
            routeData.product.toString(),
            textAlign: TextAlign.center,
          ),
          width: columnWidth),
      TableDataCell(
          label: Text(routeData.revisionNumber.toString()), width: columnWidth),
      TableDataCell(
          label: Column(
            children: [
              Text(time.toLocal().toString().substring(0, 10)),
              Text(time.toLocal().toString().substring(11, 19)),
            ],
          ),
          width: columnWidth)
    ]);
  }

  // Product route and process route table widget
  BlocConsumer<ProductAndProcessRouteBloc, ProductAndProcessRouteState>
      productAndProcessRouteWidget(
          {required ProductAndProcessRouteBloc blocProvider,
          required List<double> columnWidth,
          required TextStyle style}) {
    StreamController<String> descriptionController =
        StreamController<String>.broadcast();
    StreamController<String> setupController =
        StreamController<String>.broadcast();
    StreamController<String> runtimeController =
        StreamController<String>.broadcast();

    return BlocConsumer<ProductAndProcessRouteBloc,
        ProductAndProcessRouteState>(
      listener: (context, state) {
        if (state is ProductProcessRouteErrorState &&
            state.errorMessage == 'Product bill of material id not found') {
          QuickFixUi().showCustomDialog(
              context: context,
              errorMessage: 'Product bill of material not found');
        }
      },
      builder: (context, state) {
        if (state is SetProductProcessRouteParams &&
            state.productRevision != '') {
          if (state.productAndProcessRouteDataList.length == 3) {
            state.productAndProcessRouteDataList.insert(
                0,
                ProductAndProcessRouteModel(
                  combinedSequence: -1,
                ));
          }
          double rowHeight = 50,
              tableWidth = MediaQuery.of(context).size.width,
              tableheight = state.productAndProcessRouteDataList.isNotEmpty
                  ? (state.productAndProcessRouteDataList.length + 1) *
                      rowHeight
                  : rowHeight * 2;

          descriptionController.add(state.desciption);
          setupController.add(state.setupMinutes);
          runtimeController.add(state.runtimeMinutes);
          return Center(
            child: Container(
              width: tableWidth,
              height: tableheight,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: CustomTable(
                  tablewidth: tableWidth,
                  tableheight: tableheight + 100,
                  rowHeight: rowHeight,
                  tableheaderColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  tablebodyColor: Theme.of(context).colorScheme.surface,
                  headerStyle: style,
                  tableBorderColor: Theme.of(context).colorScheme.primary,
                  showIndex: true,
                  enableBorder: true,
                  column: [
                    ColumnData(label: 'Seq. No.', width: columnWidth[0]),
                    ColumnData(label: 'Workcentre', width: columnWidth[1]),
                    ColumnData(label: 'Workstation', width: columnWidth[2]),
                    state.workcentreid ==
                                ProductRouteRepository.outsourceWcId ||
                            state.processData.isNotEmpty
                        ? ColumnData(label: 'Process', width: columnWidth[3])
                        : ColumnData(width: 0.1),
                    ColumnData(label: 'Instructions', width: columnWidth[4]),
                    ColumnData(label: 'Setup Min.', width: columnWidth[5]),
                    ColumnData(label: 'Runtime Min.', width: columnWidth[6]),
                    ColumnData(label: 'Action', width: columnWidth[7]),
                  ],
                  rows: state.productAndProcessRouteDataList.isEmpty
                      ? [
                          RowData(cell: [
                            sequenceWidget(
                                state: state,
                                blocProvider: blocProvider,
                                width: columnWidth[0]),
                            workcentreWidget(
                                state: state,
                                blocProvider: blocProvider,
                                width: columnWidth[1]),
                            workstationWidget(
                                state: state,
                                blocProvider: blocProvider,
                                width: columnWidth[2]),
                            processWidget(
                                state: state,
                                blocProvider: blocProvider,
                                width: columnWidth[3]),
                            descriptionWidget(
                                width: columnWidth[4],
                                descriptionController: descriptionController,
                                descriptiondata: state.desciption),
                            setUpMinWidget(
                                width: columnWidth[5],
                                setupController: setupController,
                                setupMinutesData: state.setupMinutes),
                            runtimeMinWidget(
                                width: columnWidth[6],
                                runtimeController: runtimeController,
                                runMinData: state.runtimeMinutes),
                            submitButton(
                                state: state,
                                context: context,
                                blocProvider: blocProvider,
                                width: columnWidth[7],
                                descriptionController: descriptionController,
                                setupController: setupController,
                                runtimeController: runtimeController)
                          ])
                        ]
                      : state.productAndProcessRouteDataList
                          .map((e) => RowData(cell: [
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? TableDataCell(
                                                width: columnWidth[0],
                                                label: Text(
                                                  e.combinedSequence.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ))
                                            : sequenceWidget(
                                                state: state,
                                                blocProvider: blocProvider,
                                                width: columnWidth[0]))
                                        : sequenceWidget(
                                            state: state,
                                            blocProvider: blocProvider,
                                            width: columnWidth[0]))
                                    : sequenceWidget(
                                        state: state,
                                        blocProvider: blocProvider,
                                        width: columnWidth[0]),
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? TableDataCell(
                                                width: columnWidth[1],
                                                label: Text(
                                                    e.workcentre.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                        fontSize: 15)),
                                              )
                                            : workcentreWidget(
                                                state: state,
                                                blocProvider: blocProvider,
                                                width: columnWidth[1]))
                                        : workcentreWidget(
                                            state: state,
                                            blocProvider: blocProvider,
                                            width: columnWidth[1]))
                                    : workcentreWidget(
                                        state: state,
                                        blocProvider: blocProvider,
                                        width: columnWidth[1]),
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? TableDataCell(
                                                width: columnWidth[2],
                                                label: Text(
                                                  e.workstation != null
                                                      ? e.workstation.toString()
                                                      : '',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ))
                                            : workstationWidget(
                                                state: state,
                                                blocProvider: blocProvider,
                                                width: columnWidth[2]))
                                        : workstationWidget(
                                            state: state,
                                            blocProvider: blocProvider,
                                            width: columnWidth[2]))
                                    : workstationWidget(
                                        state: state,
                                        blocProvider: blocProvider,
                                        width: columnWidth[2]),
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? (state.processData.isNotEmpty ||
                                                    state.workcentreid ==
                                                        ProductRouteRepository
                                                            .outsourceWcId
                                                ? TableDataCell(
                                                    width: columnWidth[3],
                                                    label: Center(
                                                      child: Text(
                                                        e.process != null
                                                            ? e.process
                                                                .toString()
                                                            : '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                      ),
                                                    ))
                                                : TableDataCell(
                                                    label: const Stack(),
                                                    width: 0.1))
                                            : processWidget(
                                                state: state,
                                                blocProvider: blocProvider,
                                                width: columnWidth[3]))
                                        : (state.workcentreid ==
                                                ProductRouteRepository
                                                    .outsourceWcId
                                            ? processWidget(
                                                state: state,
                                                blocProvider: blocProvider,
                                                width: columnWidth[3])
                                            : TableDataCell(
                                                width:
                                                    state.processData.isNotEmpty
                                                        ? (columnWidth[3])
                                                        : 0.1,
                                                label: const Center(
                                                  child: Text(
                                                    '',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                ))))
                                    : processWidget(
                                        state: state,
                                        blocProvider: blocProvider,
                                        width: columnWidth[3]),
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? TableDataCell(
                                                width: columnWidth[4],
                                                label: Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4, bottom: 4),
                                                    child: Text(
                                                      e.instruction != null
                                                          ? e.instruction
                                                              .toString()
                                                          : '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ))
                                            : descriptionWidget(
                                                width: columnWidth[4],
                                                descriptionController:
                                                    descriptionController,
                                                descriptiondata:
                                                    state.desciption))
                                        : descriptionWidget(
                                            width: columnWidth[4],
                                            descriptionController:
                                                descriptionController,
                                            descriptiondata: state.desciption))
                                    : descriptionWidget(
                                        width: columnWidth[4],
                                        descriptionController:
                                            descriptionController,
                                        descriptiondata: state.desciption),
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? TableDataCell(
                                                width: columnWidth[5],
                                                label: Text(
                                                  e.setuptimemins != null
                                                      ? e.setuptimemins
                                                          .toString()
                                                      : '0',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ))
                                            : setUpMinWidget(
                                                width: columnWidth[5],
                                                setupController:
                                                    setupController,
                                                setupMinutesData:
                                                    state.setupMinutes))
                                        : setUpMinWidget(
                                            width: columnWidth[5],
                                            setupController: setupController,
                                            setupMinutesData:
                                                state.setupMinutes))
                                    : setUpMinWidget(
                                        width: columnWidth[5],
                                        setupController: setupController,
                                        setupMinutesData: state.setupMinutes),
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? TableDataCell(
                                                width: 100,
                                                label: Text(
                                                  e.runtimemins != null
                                                      ? e.runtimemins.toString()
                                                      : '0',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ))
                                            : runtimeMinWidget(
                                                width: columnWidth[6],
                                                runtimeController:
                                                    runtimeController,
                                                runMinData:
                                                    state.runtimeMinutes))
                                        : runtimeMinWidget(
                                            width: columnWidth[6],
                                            runtimeController:
                                                runtimeController,
                                            runMinData: state.runtimeMinutes))
                                    : runtimeMinWidget(
                                        width: columnWidth[6],
                                        runtimeController: runtimeController,
                                        runMinData: state.runtimeMinutes),
                                state.updateData !=
                                        e.combinedSequence.toString()
                                    ? (state.addNewRow !=
                                            e.combinedSequence.toString()
                                        ? (e.combinedSequence != -1
                                            ? TableDataCell(
                                                width: columnWidth[7],
                                                label: e.isButton == true
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          addNew(
                                                              state: state,
                                                              routeData: e,
                                                              blocProvider:
                                                                  blocProvider,
                                                              context: context),
                                                          carryForward(
                                                              state: state,
                                                              routeData: e,
                                                              blocProvider:
                                                                  blocProvider,
                                                              context: context),
                                                          QuickFixUi
                                                              .horizontalSpace(
                                                            width: 10,
                                                          ),
                                                          update(
                                                              state: state,
                                                              blocProvider:
                                                                  blocProvider,
                                                              context: context,
                                                              routeData: e),
                                                          delete(
                                                              state: state,
                                                              rowData: e,
                                                              context: context,
                                                              blocProvider:
                                                                  blocProvider)
                                                        ],
                                                      )
                                                    : const Text(''))
                                            : submitButton(
                                                state: state,
                                                context: context,
                                                blocProvider: blocProvider,
                                                width: columnWidth[7],
                                                descriptionController:
                                                    descriptionController,
                                                setupController:
                                                    setupController,
                                                runtimeController:
                                                    runtimeController))
                                        : submitButton(
                                            state: state,
                                            context: context,
                                            blocProvider: blocProvider,
                                            width: columnWidth[7],
                                            descriptionController:
                                                descriptionController,
                                            setupController: setupController,
                                            runtimeController:
                                                runtimeController))
                                    : updateData(
                                        blocProvider: blocProvider,
                                        state: state,
                                        context: context,
                                        routeData: e,
                                        descriptionController:
                                            descriptionController,
                                        setupController: setupController,
                                        runtimeController: runtimeController,
                                        width: columnWidth[7]),
                              ]))
                          .toList()),
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  TableDataCell processWidget(
      {required SetProductProcessRouteParams state,
      required ProductAndProcessRouteBloc blocProvider,
      required double width}) {
    return state.workcentreid == ProductRouteRepository.outsourceWcId ||
            state.processData.isNotEmpty
        ? TableDataCell(
            width: width,
            label: DropdownSearch<Process>(
                items: state.processList,
                itemAsString: (item) => item.code.toString(),
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      style: const TextStyle(fontSize: 18),
                      onTap: () {},
                    )),
                dropdownDecoratorProps: DropDownDecoratorProps(
                    textAlign: TextAlign.center,
                    dropdownSearchDecoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: state.processName == ''
                            ? 'Select Process'
                            : state.processName,
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 15))),
                onChanged: (value) {
                  if (state.addNewRow != '' || state.updateData != '') {
                    blocProvider.add(GetProductProcessRouteParams(
                        productId: state.productId,
                        productRevision: state.productRevision,
                        productAndProcessRouteDataList:
                            state.productAndProcessRouteDataList,
                        addNewRow: state.addNewRow,
                        sequencenumber: state.sequencenumber,
                        workcentre: state.workcentre,
                        workcentreid: state.workcentreid,
                        workstationid: state.workstationid,
                        workstation: state.workstation,
                        desciption: state.desciption,
                        setupMinutes: state.setupMinutes,
                        runtimeMinutes: state.runtimeMinutes,
                        topBottomDataAaray: state.topBottomDataAaray,
                        updateData: state.updateData,
                        processId: value!.id.toString(),
                        processName: value.code.toString()));
                  } else {
                    blocProvider.add(GetProductProcessRouteParams(
                        productId: state.productId,
                        productRevision: state.productRevision,
                        workcentre: state.workcentre,
                        workcentreid: state.workcentreid,
                        workstationid: state.workstationid,
                        workstation: state.workstation,
                        desciption: state.desciption,
                        setupMinutes: state.setupMinutes,
                        runtimeMinutes: state.runtimeMinutes,
                        topBottomDataAaray: state.topBottomDataAaray,
                        updateData: state.updateData,
                        processId: value!.id.toString(),
                        processName: value.code.toString()));
                  }
                }))
        : TableDataCell(label: const Stack(), width: 0.1);
  }

  TableDataCell updateData(
      {required ProductAndProcessRouteBloc blocProvider,
      required SetProductProcessRouteParams state,
      required BuildContext context,
      required ProductAndProcessRouteModel routeData,
      required StreamController<String> descriptionController,
      required StreamController<String> setupController,
      required StreamController<String> runtimeController,
      required double width}) {
    return TableDataCell(
        width: width,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<String>(
                stream: descriptionController.stream,
                builder: (context, description) {
                  return StreamBuilder<String>(
                      stream: setupController.stream,
                      builder: (context, setUpMin) {
                        return StreamBuilder<String>(
                            stream: runtimeController.stream,
                            builder: (context, runtimeMin) {
                              return FilledButton(
                                  onPressed: () async {
                                    String response =
                                        await ProductRouteRepository()
                                            .updateProductAndProcessRoute(
                                                token: state.token,
                                                payload: {
                                          'product_route_id':
                                              routeData.productRouteId,
                                          'process_route_id':
                                              routeData.processRouteId,
                                          'product_id': state.productId,
                                          'product_revision':
                                              state.productRevision,
                                          'new_sequence':
                                              state.sequencenumber ==
                                                      routeData.combinedSequence
                                                  ? 0
                                                  : state.sequencenumber,
                                          'new_workcentre_id':
                                              state.workcentreid ==
                                                      routeData.workcentreId
                                                  ? ''
                                                  : state.workcentreid,
                                          'new_workstation_id':
                                              state.workstationid ==
                                                      routeData.workstationId
                                                  ? ''
                                                  : state.workstationid,
                                          'new_createdby': state.userId,
                                          'new_totalsetuptimemins':
                                              setUpMin.data.toString() == '' ||
                                                      setUpMin.data == null
                                                  ? state.setupMinutes
                                                  : setUpMin.data.toString(),
                                          'new_totalruntimemins':
                                              runtimeMin.data.toString() ==
                                                          '' ||
                                                      runtimeMin.data == null
                                                  ? state.runtimeMinutes
                                                  : runtimeMin.data.toString(),
                                          'existing_totalsetuptimemins':
                                              routeData.setuptimemins,
                                          'existing_totalruntimemins':
                                              routeData.runtimemins,
                                          'new_description':
                                              description.data.toString() ==
                                                          '' ||
                                                      description.data == null
                                                  ? state.desciption
                                                  : description.data.toString(),
                                          'new_process_id': state.processId ==
                                                  'null'
                                              ? ''
                                              : routeData.workcentreId ==
                                                      state.workcentreid
                                                  ? routeData.processId
                                                  : state.processId ==
                                                          routeData.processId
                                                      ? ''
                                                      : state.processId !=
                                                              'null'
                                                          ? state.processId
                                                          : ''
                                        });
                                    if (response == 'Updated successfully') {
                                      String productId = state.productId,
                                          revisionNo = state.productRevision;

                                      QuickFixUi.successMessage(
                                          response, context);
                                      blocProvider
                                          .add(GetProductProcessRouteParams());
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        blocProvider
                                            .add(GetProductProcessRouteParams(
                                          productId: productId,
                                          productRevision: revisionNo,
                                        ));
                                      });
                                    } else {
                                      QuickFixUi.errorMessage(
                                          response, context);
                                    }
                                  },
                                  child: const Text('Update'));
                            });
                      });
                }),
            QuickFixUi.horizontalSpace(width: 20),
            FilledButton(
                onPressed: () {
                  blocProvider.add(GetProductProcessRouteParams(
                      productId: state.productId,
                      productRevision: state.productRevision,
                      updateData: ''));
                },
                child: const Text('Cancel')),
          ],
        ));
  }

  FilledButton update(
      {required SetProductProcessRouteParams state,
      required ProductAndProcessRouteBloc blocProvider,
      required BuildContext context,
      required ProductAndProcessRouteModel routeData}) {
    return FilledButton(
        onPressed: () {
          blocProvider.add(GetProductProcessRouteParams(
              productId: state.productId,
              productRevision: state.productRevision,
              updateData: routeData.combinedSequence.toString(),
              sequencenumber: routeData.combinedSequence!,
              workcentre: routeData.workcentre!,
              workcentreid: routeData.workcentreId!,
              workstation: routeData.workstation!,
              workstationid: routeData.workstationId!,
              setupMinutes: routeData.setuptimemins.toString(),
              runtimeMinutes: routeData.runtimemins.toString(),
              desciption: routeData.instruction.toString(),
              processId: routeData.processId.toString(),
              processName: routeData.process.toString()));
        },
        child: const Text('Update'));
  }

  //delete
  IconButton delete(
      {required SetProductProcessRouteParams state,
      required ProductAndProcessRouteModel rowData,
      required BuildContext context,
      required ProductAndProcessRouteBloc blocProvider}) {
    return IconButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const SizedBox(
                  height: 25,
                  child: Center(
                    child: Text(
                      'Do you want to delete it permanently?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => AppColors.redTheme),
                      ),
                      onPressed: () async {
                        String response = await ProductRouteRepository()
                            .deleteProductAndProcessRoute(
                                token: state.token,
                                payload: {
                              'product_route_id':
                                  rowData.productRouteId.toString(),
                              'process_route_id':
                                  rowData.processRouteId.toString(),
                              'setupmin': rowData.setuptimemins.toString(),
                              'runmin': rowData.runtimemins.toString()
                            });
                        if (response == 'Deleted successfully') {
                          String productId = state.productId,
                              revisionNo = state.productRevision;

                          QuickFixUi.successMessage(response, context);
                          blocProvider.add(GetProductProcessRouteParams());
                          Future.delayed(const Duration(milliseconds: 500), () {
                            blocProvider.add(GetProductProcessRouteParams(
                              productId: productId,
                              productRevision: revisionNo,
                            ));
                          });
                          Navigator.of(context).pop();
                        } else {
                          QuickFixUi.errorMessage(response, context);
                        }
                      },
                      child: const Text(
                        'YES',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteTheme),
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => AppColors.greenTheme),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'NO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteTheme),
                      )),
                ],
              );
            },
          );
        },
        icon: Icon(
          Icons.delete,
          size: 35,
          color: Theme.of(context).colorScheme.error,
        ));
  }

  // Carry forword button widget
  FilledButton carryForward(
      {required SetProductProcessRouteParams state,
      required ProductAndProcessRouteModel routeData,
      required ProductAndProcessRouteBloc blocProvider,
      required BuildContext context}) {
    return FilledButton(
        onPressed: () async {
          if (state.addNewRow == '') {
            List<String> seqList = [];
            if (state.productAndProcessRouteDataList.isNotEmpty) {
              int index = state.productAndProcessRouteDataList.indexWhere(
                  (element) =>
                      element.processRouteSeq == routeData.processRouteSeq);
              for (int i = 0; i < 2; i++) {
                seqList.add(state
                    .productAndProcessRouteDataList[index].productRouteId!);
                index++;
              }
            }
            bool sequenceFound = state.productAndProcessRouteDataList.any(
                (ele) =>
                    ele.combinedSequence == routeData.combinedSequence! + 10);
            int seq = 0;
            if (sequenceFound == false) {
              seq = routeData.combinedSequence! + 10;
            } else {
              seq = 0;
            }
            state.productAndProcessRouteDataList.insert(
                state.productAndProcessRouteDataList.indexWhere((element) =>
                        element.combinedSequence ==
                        routeData.combinedSequence) +
                    1,
                ProductAndProcessRouteModel(
                    combinedSequence: seq,
                    workcentre: routeData.workcentre!,
                    workstation: routeData.workstation,
                    instruction: routeData.instruction,
                    setuptimemins: routeData.setuptimemins,
                    runtimemins: routeData.runtimemins,
                    productRouteId: routeData.productRouteId,
                    processRouteId: routeData.processRouteId,
                    workstationId: routeData.workstationId,
                    isButton: routeData.isButton));

            blocProvider.add(GetProductProcessRouteParams(
                productId: state.productId,
                productRevision: state.productRevision,
                productAndProcessRouteDataList:
                    state.productAndProcessRouteDataList,
                addNewRow: seq.toString(),
                sequencenumber: seq,
                workcentre: routeData.workcentre.toString(),
                workcentreid: routeData.workcentreId.toString(),
                workstationid: state.workstationid,
                workstation: state.workstation,
                desciption: routeData.instruction.toString(),
                setupMinutes: routeData.setuptimemins.toString(),
                runtimeMinutes: routeData.runtimemins.toString(),
                topBottomDataAaray: seqList.isNotEmpty ? seqList : ['', '']));
          } else {
            QuickFixUi().showCustomDialog(
                context: context,
                errorMessage:
                    'Please submit the previously created row data first.');
          }
        },
        child: const Text('Carry forward'));
  }

  // Add new route button
  IconButton addNew(
      {required SetProductProcessRouteParams state,
      required ProductAndProcessRouteModel routeData,
      required ProductAndProcessRouteBloc blocProvider,
      required BuildContext context}) {
    return IconButton(
        onPressed: () {
          if (state.addNewRow == '') {
            List<String> seqList = [];
            if (state.productAndProcessRouteDataList.isNotEmpty) {
              int index = state.productAndProcessRouteDataList.indexWhere(
                  (element) =>
                      element.processRouteSeq == routeData.processRouteSeq);
              for (int i = 0; i < 2; i++) {
                seqList.add(state
                    .productAndProcessRouteDataList[index].productRouteId!);
                index++;
              }
            }
            bool sequenceFound = state.productAndProcessRouteDataList.any(
                (ele) =>
                    ele.combinedSequence == routeData.combinedSequence! + 10);
            int seq = 0;

            if (sequenceFound == false) {
              if (routeData.combinedSequence! % 10 == 0) {
                seq = routeData.combinedSequence! + 10;
              } else {
                seq = 0;
              }
            } else {
              seq = 0;
            }
            state.productAndProcessRouteDataList.insert(
                state.productAndProcessRouteDataList.indexWhere((element) =>
                        element.combinedSequence ==
                        routeData.combinedSequence) +
                    1,
                ProductAndProcessRouteModel(
                    combinedSequence: seq,
                    workcentre: routeData.workcentre!,
                    workstation: routeData.workstation,
                    instruction: routeData.instruction,
                    setuptimemins: routeData.setuptimemins,
                    runtimemins: routeData.runtimemins,
                    productRouteId: routeData.productRouteId,
                    processRouteId: routeData.processRouteId,
                    workstationId: routeData.workstationId,
                    process: routeData.process,
                    processId: routeData.processId,
                    isButton: routeData.isButton));

            blocProvider.add(GetProductProcessRouteParams(
                productId: state.productId,
                productRevision: state.productRevision,
                productAndProcessRouteDataList:
                    state.productAndProcessRouteDataList,
                addNewRow: seq.toString(),
                sequencenumber: seq,
                topBottomDataAaray: seqList.isNotEmpty ? seqList : ['', '']));
          } else {
            QuickFixUi().showCustomDialog(
                context: context,
                errorMessage:
                    'Please submit the previously created row data first.');
          }
        },
        icon: Icon(
          Icons.add_circle_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 35,
        ));
  }

  // Submit button widget
  TableDataCell submitButton(
      {required SetProductProcessRouteParams state,
      required BuildContext context,
      required ProductAndProcessRouteBloc blocProvider,
      required double width,
      required StreamController<String> descriptionController,
      required StreamController<String> setupController,
      required StreamController<String> runtimeController}) {
    return TableDataCell(
      width: width,
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<String>(
              stream: descriptionController.stream,
              builder: (context, description) {
                return StreamBuilder<String>(
                    stream: setupController.stream,
                    builder: (context, setUpMin) {
                      return StreamBuilder<String>(
                          stream: runtimeController.stream,
                          builder: (context, runtimeMin) {
                            return FilledButton(
                              onPressed: () async {
                                Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () async {
                                  if (state.sequencenumber == 0) {
                                    QuickFixUi.errorMessage(
                                        'Please enter sequence number',
                                        context);
                                  } else if (state.sequencenumber < 10) {
                                    QuickFixUi.errorMessage(
                                        'Kindly choose sequence numbers that exceed 10.',
                                        context);
                                  } else if (state.workcentreid == '') {
                                    QuickFixUi.errorMessage(
                                        'Please select workcentre', context);
                                  } else if (((description.data.toString() ==
                                                  '' ||
                                              description.data == null) &&
                                          state.desciption == '') &&
                                      state.processId == '') {
                                    QuickFixUi.errorMessage(
                                        'Please fill out one of the instructions or processes.',
                                        context);
                                  } else {
                                    String response =
                                        await ProductRouteRepository()
                                            .registerProductRoute(
                                                token: state.token,
                                                payload: {
                                          'product_id': state.productId,
                                          'created_by': state.userId,
                                          'productbillofmaterial_id':
                                              state.productbillofmaterialId,
                                          'workstation_id': state.workstationid,
                                          'workcentre_id': state.workcentreid,
                                          'setup_min':
                                              setUpMin.data.toString() == '' ||
                                                      setUpMin.data == null
                                                  ? state.setupMinutes
                                                  : setUpMin.data,
                                          'runtime_min':
                                              runtimeMin.data.toString() ==
                                                          '' ||
                                                      runtimeMin.data == null
                                                  ? state.runtimeMinutes
                                                  : runtimeMin.data,
                                          'revision_number':
                                              state.productRevision,
                                          'sequencenumber':
                                              state.sequencenumber,
                                          'description': description.data ??
                                              state.desciption,
                                          'top_bottom_data_aaray':
                                              state.topBottomDataAaray,
                                          'new_process_id': state.processId
                                        });
                                    if (response ==
                                        'Product route registered successfully') {
                                      String productId = state.productId,
                                          revisionNo = state.productRevision;

                                      QuickFixUi.successMessage(
                                          response, context);
                                      blocProvider
                                          .add(GetProductProcessRouteParams());
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        blocProvider
                                            .add(GetProductProcessRouteParams(
                                          productId: productId,
                                          productRevision: revisionNo,
                                        ));
                                      });
                                      BlocProvider.of<ProductRouteBloc>(context)
                                          .add(const GetProductRouteData());
                                    } else {
                                      QuickFixUi.errorMessage(
                                          response, context);
                                    }
                                  }
                                });
                              },
                              child: const Text('Submit'),
                            );
                          });
                    });
              }),
          QuickFixUi.horizontalSpace(width: 10),
          state.addNewRow == ''
              ? const Stack()
              : FilledButton(
                  onPressed: () {
                    state.productAndProcessRouteDataList.removeWhere(
                        (element) =>
                            element.combinedSequence.toString() ==
                            state.addNewRow);
                    blocProvider.add(GetProductProcessRouteParams(
                        productId: state.productId,
                        productRevision: state.productRevision,
                        productAndProcessRouteDataList:
                            state.productAndProcessRouteDataList));
                  },
                  child: const Text('Cancel'))
        ],
      ),
    );
  }

  // Runtime minutes widget
  TableDataCell runtimeMinWidget(
      {required double width,
      required StreamController<String> runtimeController,
      required String runMinData}) {
    TextEditingController runtimeMinutes = TextEditingController();
    runtimeMinutes.text = runMinData;
    return TableDataCell(
      width: width,
      label: Center(
        child: StreamBuilder<String>(
            stream: runtimeController.stream,
            builder: (context, snapshot) {
              if (snapshot.data.toString() != '' && snapshot.data != null) {
                final cursorPosition = runtimeMinutes.selection.baseOffset;
                runtimeMinutes.text = snapshot.data.toString();
                final newCursorPosition = cursorPosition +
                    (snapshot.data.toString().length -
                        runtimeMinutes.text.length);
                runtimeMinutes.selection = TextSelection.fromPosition(
                  TextPosition(offset: newCursorPosition),
                );
              }
              return TextField(
                controller: runtimeMinutes,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 15)),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  runtimeController.add(value.toString());
                },
              );
            }),
      ),
    );
  }

  // Setup minutes widget
  TableDataCell setUpMinWidget(
      {required double width,
      required StreamController<String> setupController,
      required String setupMinutesData}) {
    TextEditingController setupMin = TextEditingController();
    setupMin.text = setupMinutesData;
    return TableDataCell(
      width: width,
      label: Center(
        child: StreamBuilder<String>(
            stream: setupController.stream,
            builder: (context, snapshot) {
              if (snapshot.data.toString() != '' && snapshot.data != null) {
                final cursorPosition = setupMin.selection.baseOffset;
                setupMin.text = snapshot.data.toString();
                final newCursorPosition = cursorPosition +
                    (snapshot.data.toString().length - setupMin.text.length);
                setupMin.selection = TextSelection.fromPosition(
                  TextPosition(offset: newCursorPosition),
                );
              }
              return TextField(
                controller: setupMin,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 15)),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setupController.add(value.toString());
                },
              );
            }),
      ),
    );
  }

  TableDataCell descriptionWidget({
    required double width,
    required StreamController<String> descriptionController,
    required String descriptiondata,
  }) {
    TextEditingController description = TextEditingController();
    description.text = descriptiondata;
    int previousCursorPosition = 0;

    return TableDataCell(
      width: width,
      label: Container(
        margin: const EdgeInsets.only(left: 5),
        child: Center(
          child: StreamBuilder<String>(
            stream: descriptionController.stream,
            builder: (context, snapshot) {
              if (snapshot.data.toString() != '' && snapshot.data != null) {
                previousCursorPosition = description.selection.baseOffset;
                description.value = TextEditingValue(
                  text: snapshot.data.toString(),
                  selection: TextSelection.collapsed(
                    offset: previousCursorPosition,
                  ),
                );
              }
              return TextField(
                controller: description,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                onChanged: (value) {
                  descriptionController.add(value);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Workstation selection dropdown
  TableDataCell workstationWidget(
      {required SetProductProcessRouteParams state,
      required ProductAndProcessRouteBloc blocProvider,
      required double width}) {
    return TableDataCell(
        width: width,
        label: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 5, bottom: 2),
            child: DropdownSearch<WorkstationByWorkcentreId>(
              items: state.workstationList,
              itemAsString: (item) => item.code.toString(),
              popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    style: const TextStyle(fontSize: 18),
                    onTap: () {},
                  )),
              dropdownDecoratorProps: DropDownDecoratorProps(
                  textAlign: TextAlign.center,
                  dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.workstation == ''
                          ? 'Select Workstation'
                          : state.workstation,
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 15))),
              onChanged: (value) {
                if (state.addNewRow != '' || state.updateData != '') {
                  blocProvider.add(GetProductProcessRouteParams(
                      productId: state.productId,
                      productRevision: state.productRevision,
                      productAndProcessRouteDataList:
                          state.productAndProcessRouteDataList,
                      addNewRow: state.addNewRow,
                      sequencenumber: state.sequencenumber,
                      workcentre: state.workcentre,
                      workcentreid: state.workcentreid,
                      workstationid: value!.id.toString(),
                      workstation: value.code.toString(),
                      desciption: state.desciption,
                      setupMinutes: state.setupMinutes,
                      runtimeMinutes: state.runtimeMinutes,
                      topBottomDataAaray: state.topBottomDataAaray,
                      updateData: state.updateData,
                      processId: state.processId,
                      processName: state.processName));
                } else {
                  blocProvider.add(GetProductProcessRouteParams(
                      productId: state.productId,
                      productRevision: state.productRevision,
                      workcentre: state.workcentre,
                      workcentreid: state.workcentreid,
                      workstationid: value!.id.toString(),
                      workstation: value.code.toString(),
                      desciption: state.desciption,
                      setupMinutes: state.setupMinutes,
                      runtimeMinutes: state.runtimeMinutes,
                      topBottomDataAaray: state.topBottomDataAaray,
                      updateData: state.updateData,
                      processId: state.processId,
                      processName: state.processName));
                }
              },
            ),
          ),
        ));
  }

  // Workcentre selection dropdown
  TableDataCell workcentreWidget({
    required SetProductProcessRouteParams state,
    required ProductAndProcessRouteBloc blocProvider,
    required double width,
  }) {
    return TableDataCell(
        width: width,
        label: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 5, bottom: 2),
            child: DropdownSearch<Workcentre>(
                items: state.workcentreList,
                itemAsString: (item) => item.code.toString(),
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      style: const TextStyle(fontSize: 18),
                      onTap: () {},
                    )),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  textAlign: TextAlign.center,
                  dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: state.workcentre == ''
                          ? 'Select workcentre'
                          : state.workcentre,
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 15)),
                ),
                onChanged: (value) async {
                  if (state.addNewRow != '' || state.updateData != '') {
                    blocProvider.add(GetProductProcessRouteParams(
                        productId: state.productId,
                        productRevision: state.productRevision,
                        productAndProcessRouteDataList:
                            state.productAndProcessRouteDataList,
                        addNewRow: state.addNewRow,
                        sequencenumber: state.sequencenumber,
                        workcentreid: value!.id.toString(),
                        workcentre: value.code.toString(),
                        desciption: state.desciption,
                        setupMinutes: state.setupMinutes,
                        runtimeMinutes: state.runtimeMinutes,
                        topBottomDataAaray: state.topBottomDataAaray,
                        updateData: state.updateData,
                        processId: state.processId,
                        processName: state.processName));
                  } else {
                    blocProvider.add(GetProductProcessRouteParams(
                        productId: state.productId,
                        productRevision: state.productRevision,
                        workcentreid: value!.id.toString(),
                        workcentre: value.code.toString(),
                        desciption: state.desciption,
                        setupMinutes: state.setupMinutes,
                        runtimeMinutes: state.runtimeMinutes,
                        topBottomDataAaray: state.topBottomDataAaray,
                        updateData: state.updateData,
                        processId: state.processId,
                        processName: state.processName));
                  }
                }),
          ),
        ));
  }

  // Product route sequence
  TableDataCell sequenceWidget({
    required SetProductProcessRouteParams state,
    required ProductAndProcessRouteBloc blocProvider,
    required double width,
  }) {
    return TableDataCell(
        width: width,
        label: Center(
          child: TextField(
            decoration: InputDecoration(
                hintText: state.sequencenumber.toString(),
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 15),
                border: InputBorder.none),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onTap: () {
              blocProvider.add(GetProductProcessRouteParams(
                  productId: state.productId,
                  productRevision: state.productRevision,
                  productAndProcessRouteDataList:
                      state.productAndProcessRouteDataList,
                  addNewRow: state.addNewRow,
                  sequencenumber: 0,
                  workcentre: state.workcentre.toString(),
                  workcentreid: state.workcentreid,
                  workstation: state.workstation,
                  workstationid: state.workstationid,
                  desciption: state.desciption,
                  setupMinutes: state.setupMinutes,
                  runtimeMinutes: state.runtimeMinutes,
                  topBottomDataAaray: state.topBottomDataAaray,
                  updateData: state.updateData,
                  processId: state.processId,
                  processName: state.processName));
            },
            onChanged: (value) {
              try {
                int seq = int.parse(value.toString());
                if (state.addNewRow != '' || state.updateData != '') {
                  blocProvider.add(GetProductProcessRouteParams(
                      productId: state.productId,
                      productRevision: state.productRevision,
                      productAndProcessRouteDataList:
                          state.productAndProcessRouteDataList,
                      addNewRow: state.addNewRow,
                      sequencenumber:
                          value.toString() == '' ? state.sequencenumber : seq,
                      workcentre: state.workcentre.toString(),
                      workcentreid: state.workcentreid,
                      workstation: state.workstation,
                      workstationid: state.workstationid,
                      desciption: state.desciption,
                      setupMinutes: state.setupMinutes,
                      runtimeMinutes: state.runtimeMinutes,
                      topBottomDataAaray: state.topBottomDataAaray,
                      updateData: state.updateData,
                      processId: state.processId,
                      processName: state.processName));
                }
              } catch (e) {
                // debugPrint(e.toString());
              }
            },
          ),
        ));
  }

  // Product revision search dropdown
  BlocBuilder<ProductAndProcessRouteBloc, ProductAndProcessRouteState>
      selectProductRevision(
          {required ProductAndProcessRouteBloc blocProvider}) {
    return BlocBuilder<ProductAndProcessRouteBloc, ProductAndProcessRouteState>(
      builder: (context, state) {
        if (state is SetProductProcessRouteParams && state.productId != '') {
          if (state.productRevisionList.length == 1 &&
              state.productRevisionList[0].revisionNumber.toString().trim() ==
                  '') {
            return const Text(
              'Product revision not available for this product.',
              style: TextStyle(
                  color: AppColors.redTheme,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            );
          } else {
            return Container(
              width: 200,
              height: 50,
              margin: const EdgeInsets.only(top: 10),
              decoration: QuickFixUi().borderContainer(
                borderThickness: .5,
              ),
              child: DropdownSearch(
                items: state.productRevisionList,
                itemAsString: (item) => item.revisionNumber.toString(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    textAlign: TextAlign.center,
                    dropdownSearchDecoration: InputDecoration(
                        hintText: 'Product revision',
                        border: InputBorder.none)),
                onChanged: (value) {
                  blocProvider.add(GetProductProcessRouteParams(
                      productId: state.productId,
                      productRevision:
                          value!.revisionNumber.toString().trim()));
                },
              ),
            );
          }
        } else {
          return const Stack();
        }
      },
    );
  }

  // Product search widget
  Center productSearch({required ProductAndProcessRouteBloc blocProvider}) {
    return Center(
      child: Container(
          width: 300,
          height: 50,
          margin: const EdgeInsets.only(top: 10),
          child: ProductSearch(
            onTap: () {
              blocProvider.add(GetProductProcessRouteParams(productId: ''));
            },
            onChanged: (value) {
              blocProvider.add(GetProductProcessRouteParams(productId: ''));
              Future.delayed(const Duration(milliseconds: 500), () {
                blocProvider.add(GetProductProcessRouteParams(
                    productId: value!.id.toString()));
              });
            },
          )),
    );
  }
}
