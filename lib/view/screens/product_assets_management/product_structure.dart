// Author : Shital Gayakwad
// Created Date : 23 October 2024
// Description : Product structure

import 'dart:async';
import 'dart:io';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/responsive.dart';
import 'package:de/view/widgets/table/custom_table.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/product_dashboard/product_dashboard_bloc.dart';
import '../../../bloc/product_dashboard/product_dashboard_event.dart';
import '../../../bloc/product_dashboard/product_dashboard_state.dart';
import '../../../services/model/product/product_structure_model.dart';
import '../../../services/repository/product/pam_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_theme.dart';
import '../../widgets/product_structure_widget.dart';

class ProductStructure extends StatefulWidget {
  const ProductStructure({super.key});

  @override
  State<ProductStructure> createState() => _ProductStructureState();
}

class _ProductStructureState extends State<ProductStructure> {
  final ScrollController horizontalScrollController = ScrollController();

  // Stream controllers
  StreamController<ProductStructureDetailsModel> productDetailsData =
      StreamController<ProductStructureDetailsModel>.broadcast();
  StreamController<List<String>> revisionListData =
      StreamController<List<String>>.broadcast();
  StreamController<ProductStructureDetailsModel> productTreeData =
      StreamController<ProductStructureDetailsModel>.broadcast();
  StreamController<bool> isDataAdded = StreamController<bool>.broadcast();
  StreamController<List<ProductsWithRevisionDataModel>> searchedProducts =
      StreamController<List<ProductsWithRevisionDataModel>>.broadcast();
  StreamController<List<SelectedProductModel>> selectedProducts =
      StreamController<List<SelectedProductModel>>.broadcast();
  StreamController<Map<String, String>> textfieldRevision =
      StreamController<Map<String, String>>.broadcast();
  StreamController<ProductBOMDetails> productBomDetails =
      StreamController<ProductBOMDetails>.broadcast();
  // StreamController<RawMaterialDataModel> selectedRawMaterial =
  //     StreamController<RawMaterialDataModel>.broadcast();

  // TextEditing controller
  TextEditingController quantityController = TextEditingController();
  TextEditingController minOrderQuantityController = TextEditingController();
  TextEditingController reorderLevelController = TextEditingController();
  TextEditingController leadtimeController = TextEditingController();
  TextEditingController searchedString = TextEditingController();
  TextEditingController parentProduct = TextEditingController();
  TextEditingController parentRevision = TextEditingController();

  @override
  void initState() {
    final blocProvider = BlocProvider.of<ProductDashboardBloc>(context);
    blocProvider.add(ProductStructureEvent());
    super.initState();
  }

  @override
  void dispose() {
    // Scroll controller
    horizontalScrollController.dispose();

    // Stream controllers
    productDetailsData.close();
    revisionListData.close();
    productTreeData.close();
    isDataAdded.close();
    searchedProducts.close();
    selectedProducts.close();
    textfieldRevision.close();
    productBomDetails.close();

    // TextEditing controller
    quantityController.dispose();
    minOrderQuantityController.dispose();
    reorderLevelController.dispose();
    leadtimeController.dispose();
    searchedString.dispose();
    parentProduct.dispose();
    parentRevision.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: MakeMeResponsiveScreen(
        horixontaltab: productStructureScreen(size: size),
        windows: productStructureScreen(size: size),
        linux: productStructureScreen(size: size),
      ),
    );
  }

  Row productStructureScreen({required Size size}) {
    return Row(
      children: [
        // Product tree
        Container(
            width: size.width / 2,
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                // Product and revision selection
                Container(
                    width: size.width / 2,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: BlocBuilder<ProductDashboardBloc,
                        ProductDashboardState>(builder: (context, state) {
                      if (state is ProductAssetsManagementInitialState) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        );
                      } else if (state is ProductStructureState &&
                          state.productsList.isNotEmpty) {
                        double i = 0;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Product selection
                            productDropdowanWidget(state: state),
                            // Revision Selection
                            productRevisionDopdownWidget(state: state),
                            SizedBox(
                                height: 50,
                                width: 160,
                                child: Stack(
                                    children: state.productTypeList.map((e) {
                                  i++;
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: 30, top: (i > 0 ? 10 * i : 0)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 7,
                                            height: 7,
                                            padding: const EdgeInsets.all(2),
                                            color: AppColors()
                                                .getColorsDependUponProductType(
                                                    productType: e[1],
                                                    value: 200),
                                          ),
                                          Container(
                                            width: 130 - 10,
                                            height: 10,
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Text(
                                              e[0],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8),
                                            ),
                                          ),
                                        ]),
                                  );
                                }).toList()))
                          ],
                        );
                      } else {
                        return const Stack();
                      }
                    })),

                // Product tree
                productTreeWidget(size: size)
              ],
            )),

        // Product Details
        productDetailsWidget(size: size)
      ],
    );
  }

  Container productTreeWidget({required Size size}) {
    return Container(
      width: size.width / 2,
      height: size.height - 241,
      padding: const EdgeInsets.only(right: 50),
      child: BlocBuilder<ProductDashboardBloc, ProductDashboardState>(
          builder: (context, state) {
        if (state is ProductStructureState && state.productsList.isNotEmpty) {
          return Align(
            alignment: Alignment.topLeft,
            child: StreamBuilder<ProductStructureDetailsModel>(
              stream: productTreeData.stream,
              builder: (context, productTreeDataSnapshot) {
                return StreamBuilder<ProductStructureDetailsModel>(
                    stream: productDetailsData.stream,
                    builder: (context, productDetailsDataSnapshot) {
                      if (productTreeDataSnapshot.data != null &&
                          productDetailsDataSnapshot
                                  .data!.buildProductStructure !=
                              null &&
                          productDetailsDataSnapshot
                                  .data!.buildProductStructure![0].level! >=
                              0 &&
                          productTreeDataSnapshot.data!.buildProductStructure !=
                              null &&
                          productTreeDataSnapshot
                                  .data!.buildProductStructure![0].part !=
                              '') {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: horizontalScrollController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScrollController,
                                child: Container(
                                  child: buildTree(
                                      node: productTreeDataSnapshot.data!,
                                      context: context,
                                      parentPart: productDetailsDataSnapshot
                                          .data!
                                          .buildProductStructure![0]
                                          .part!,
                                      size: size,
                                      state: state),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Stack();
                      }
                    });
              },
            ),
          );
        } else {
          return const Stack();
        }
      }),
    );
  }

  Widget buildTree(
      {required ProductStructureDetailsModel node,
      required BuildContext context,
      required String parentPart,
      required Size size,
      required ProductStructureState state}) {
    return Column(
      children: [
        CustomPaint(
            painter: HorizontalLinePainter(
                node: node, context: context, product: parentPart),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors()
                          .getColorsDependUponProductType(
                              productType: node
                                  .buildProductStructure![0].producttypeId
                                  .toString(),
                              value: 100),
                    ),
                    onPressed: () async {
                      productDetailsData.add(ProductStructureDetailsModel());
                      productBomDetails.add(ProductBOMDetails());
                      if (node.buildProductStructure![0].revision == 'null' ||
                          node.buildProductStructure![0].revision == '') {
                        QuickFixUi().showCustomDialog(
                            context: context,
                            errorMessage: 'Product revision not found.');
                      }
                      // Add data in model
                      ProductStructureDetailsModel data =
                          ProductStructureDetailsModel(buildProductStructure: [
                        BuildProductStructure(
                            level: node.buildProductStructure![0].level,
                            parentPart:
                                node.buildProductStructure![0].level == 0
                                    ? 'Self'
                                    : node.buildProductStructure![0].parentPart,
                            parentpartId:
                                node.buildProductStructure![0].parentpartId,
                            part:
                                node.buildProductStructure![0].part.toString(),
                            partId: node.buildProductStructure![0].partId,
                            revision: node.buildProductStructure![0].revision,
                            description:
                                node.buildProductStructure![0].description,
                            producttype:
                                node.buildProductStructure![0].producttype,
                            producttypeId:
                                node.buildProductStructure![0].producttypeId,
                            quantity: node.buildProductStructure![0].quantity,
                            unitOfMeasurement: node
                                .buildProductStructure![0].unitOfMeasurement,
                            unitOfMeasurementId: node
                                .buildProductStructure![0].unitOfMeasurementId,
                            minOrderQuantity:
                                node.buildProductStructure![0].minOrderQuantity,
                            reorderLevel:
                                node.buildProductStructure![0].reorderLevel,
                            leadtime: node.buildProductStructure![0].leadtime,
                            structureTableId:
                                node.buildProductStructure![0].structureTableId,
                            children: node.buildProductStructure![0].children,
                            oldStructureTableId: node
                                .buildProductStructure![0].oldStructureTableId)
                      ]);
                      productDetailsData.add(data);
                      if (node.buildProductStructure![0].children!.isEmpty) {
                        ProductBOMDetails bomDetails = await PamRepository()
                            .getBOMDetails(
                                token: state.token,
                                productId: node.buildProductStructure![0].partId
                                    .toString());
                        productBomDetails.add(bomDetails);
                      }
                    },
                    child: Text(
                      node.buildProductStructure![0].part!,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: Platform.isAndroid
                              ? size.width < 550
                                  ? FontWeight.normal
                                  : FontWeight.bold
                              : size.width < 1350
                                  ? FontWeight.normal
                                  : FontWeight.bold),
                    )),
              ),
            )),
        if (node.buildProductStructure![0].children!.isNotEmpty)
          CustomPaint(
            size: const Size(16, 16),
            painter: LinePainter(node: node, context: context),
            child: Container(
              padding: const EdgeInsets.only(left: 50),
              child: Column(
                children: node.buildProductStructure![0].children!
                    .map((child) => buildTree(
                        node: ProductStructureDetailsModel(
                            buildProductStructure: [child]),
                        context: context,
                        parentPart: parentPart,
                        size: size,
                        state: state))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  productDetailsWidget({required Size size}) {
    double widgetHeight = 40;
    return BlocBuilder<ProductDashboardBloc, ProductDashboardState>(
        builder: (context, state) {
      double tableHeight = (size.height - (Platform.isAndroid ? 495 : 455)),
          rowHeight = 45;
      if (state is ProductStructureState) {
        return StreamBuilder<ProductStructureDetailsModel>(
            stream: productTreeData.stream,
            builder: (context, productTreeDataSnapshot) {
              return StreamBuilder<ProductStructureDetailsModel>(
                  stream: productDetailsData.stream,
                  builder: (context, productDetailsDataSnapshot) {
                    if (productDetailsDataSnapshot.data != null &&
                        productDetailsDataSnapshot
                                .data!.buildProductStructure !=
                            null &&
                        productDetailsDataSnapshot
                                .data!.buildProductStructure![0].revision !=
                            '') {
                      return StreamBuilder<bool>(
                          stream: isDataAdded.stream,
                          builder: (context, isDataAddedSnapshot) {
                            return Container(
                              width: size.width / 2,
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 5, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors()
                                      .getColorsDependUponProductType(
                                          productType:
                                              productDetailsDataSnapshot
                                                  .data!
                                                  .buildProductStructure![0]
                                                  .producttypeId
                                                  .toString(),
                                          value: 100),
                                ),
                                child: ListView(
                                  children: [
                                    // Product details header
                                    detailsHeaderWidget(
                                        productDetailsDataSnapshot:
                                            productDetailsDataSnapshot),

                                    // Product level and parent part row
                                    detailsDataRow(
                                        size: size,
                                        widgetHeight: widgetHeight,
                                        productDetailsDataSnapshot:
                                            productDetailsDataSnapshot,
                                        headerText1: 'Level',
                                        widget1: levelWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot),
                                        headerText2: 'Parent part',
                                        widget2: parentPartWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot)),

                                    // Part and revision row
                                    detailsDataRow(
                                        size: size,
                                        widgetHeight: widgetHeight,
                                        productDetailsDataSnapshot:
                                            productDetailsDataSnapshot,
                                        headerText1: 'Part',
                                        widget1: partWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot),
                                        headerText2: 'Revision',
                                        widget2: revisionWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot)),

                                    // Description and product type
                                    detailsDataRow(
                                        size: size,
                                        widgetHeight: widgetHeight,
                                        productDetailsDataSnapshot:
                                            productDetailsDataSnapshot,
                                        headerText1: 'Description',
                                        widget1: descriptionWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot),
                                        headerText2: 'Product type',
                                        widget2: productTypeWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot)),

                                    // Quantity and minimum order quantity
                                    detailsDataRow(
                                        size: size,
                                        widgetHeight: widgetHeight,
                                        productDetailsDataSnapshot:
                                            productDetailsDataSnapshot,
                                        headerText1: 'Quantity',
                                        widget1: quantityWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot,
                                            isDataAddedSnapshot:
                                                isDataAddedSnapshot,
                                            size: size),
                                        headerText2: 'Min. order quantity',
                                        widget2: minimumOrderQuantityWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot,
                                            isDataAddedSnapshot:
                                                isDataAddedSnapshot)),

                                    const SizedBox(height: 5),

                                    // Reorder level and lead time
                                    detailsDataRow(
                                        size: size,
                                        widgetHeight: widgetHeight,
                                        productDetailsDataSnapshot:
                                            productDetailsDataSnapshot,
                                        headerText1: 'Reorder level',
                                        widget1: reorderLevelWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot,
                                            isDataAddedSnapshot:
                                                isDataAddedSnapshot),
                                        headerText2: 'Lead time (Days)',
                                        widget2: leadTimeWidget(
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot,
                                            isDataAddedSnapshot:
                                                isDataAddedSnapshot)),

                                    const SizedBox(height: 5),

                                    // Buttons row
                                    Row(
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    left: 10, bottom: 5),
                                            child: ((productTreeDataSnapshot.data != null &&
                                                        productTreeDataSnapshot.data!
                                                                .buildProductStructure !=
                                                            null &&
                                                        productTreeDataSnapshot
                                                                .data!
                                                                .buildProductStructure![
                                                                    0]
                                                                .part !=
                                                            '') &&
                                                    isDataAddedSnapshot.data !=
                                                        null &&
                                                    isDataAddedSnapshot.data ==
                                                        true)
                                                ? updateButton(
                                                    context: context,
                                                    state: state,
                                                    productTreeDataSnapshot:
                                                        productTreeDataSnapshot,
                                                    productDetailsDataSnapshot:
                                                        productDetailsDataSnapshot)
                                                : (productTreeDataSnapshot.data != null &&
                                                        productTreeDataSnapshot
                                                                .data!
                                                                .buildProductStructure ==
                                                            null)
                                                    ? exploadButton(
                                                        context: context,
                                                        productDetailsDataSnapshot:
                                                            productDetailsDataSnapshot,
                                                        state: state)
                                                    : const Stack()),
                                        productDetailsDataSnapshot
                                                    .data!
                                                    .buildProductStructure![0]
                                                    .producttypeId
                                                    .toString()
                                                    .trim() ==
                                                '4028b88151c96d3f0151c96fd3120001'
                                            ? (isDataAddedSnapshot.data !=
                                                        null &&
                                                    isDataAddedSnapshot.data ==
                                                        true)
                                                ? const Text('')
                                                : (productTreeDataSnapshot
                                                                .data !=
                                                            null &&
                                                        productTreeDataSnapshot.data!
                                                                .buildProductStructure !=
                                                            null &&
                                                        productTreeDataSnapshot
                                                                .data!
                                                                .buildProductStructure![
                                                                    0]
                                                                .part !=
                                                            '')
                                                    ? childButton(
                                                        isDataAddedSnapshot:
                                                            isDataAddedSnapshot,
                                                        context: context,
                                                        size: size,
                                                        productDetailsDataSnapshot:
                                                            productDetailsDataSnapshot,
                                                        state: state)
                                                    : const Text('')
                                            : const Text(''),
                                        (productDetailsDataSnapshot
                                                        .data!
                                                        .buildProductStructure![
                                                            0]
                                                        .producttypeId
                                                        .toString()
                                                        .trim() ==
                                                    '4028b88151c96d3f0151c96fecf00002' &&
                                                productDetailsDataSnapshot
                                                        .data!
                                                        .buildProductStructure![
                                                            0]
                                                        .children !=
                                                    null &&
                                                productDetailsDataSnapshot
                                                    .data!
                                                    .buildProductStructure![0]
                                                    .children!
                                                    .isEmpty)
                                            ? StreamBuilder<ProductBOMDetails>(
                                                stream:
                                                    productBomDetails.stream,
                                                builder: (context,
                                                    productBomDetailsSnapshot) {
                                                  if (productBomDetailsSnapshot
                                                              .data !=
                                                          null &&
                                                      productBomDetailsSnapshot
                                                              .data!.bomId !=
                                                          null) {
                                                    return copyRawMaterialButton(
                                                        context: context,
                                                        productBomDetailsSnapshot:
                                                            productBomDetailsSnapshot,
                                                        state: state,
                                                        productDetailsDataSnapshot:
                                                            productDetailsDataSnapshot);
                                                  } else {
                                                    return ElevatedButton(
                                                        onPressed: () async {
                                                          List<SelectedProductModel>
                                                              dataList = [];
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Assign raw material',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize: Platform.isAndroid
                                                                            ? 15
                                                                            : 14,
                                                                        color: AppColors().getColorsDependUponProductType(
                                                                                productType: productDetailsDataSnapshot.data!.buildProductStructure![0].producttypeId.toString(),
                                                                                value: 800) ??
                                                                            Colors.black),
                                                                  ),
                                                                  content:
                                                                      SizedBox(
                                                                    width: 200,
                                                                    height: 45,
                                                                    child: DropdownSearch<
                                                                        RawMaterialDataModel>(
                                                                      items: state
                                                                          .rawMaterialList,
                                                                      itemAsString: (item) => item
                                                                          .productdescription
                                                                          .toString(),
                                                                      popupProps:
                                                                          PopupProps
                                                                              .menu(
                                                                        itemBuilder: (context,
                                                                            item,
                                                                            isSelected) {
                                                                          return ListTile(
                                                                            title:
                                                                                Text(
                                                                              'Raw material : ${item.product}\nDescription : ${item.productdescription}',
                                                                              style: AppTheme.labelTextStyle(),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      dropdownDecoratorProps: DropDownDecoratorProps(
                                                                          dropdownSearchDecoration: InputDecoration(
                                                                              hintText: 'Select raw material',
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)))),
                                                                      onChanged:
                                                                          (value) {
                                                                        dataList =
                                                                            [];
                                                                        dataList.add(SelectedProductModel(
                                                                            productid: value!.id
                                                                                .toString()
                                                                                .trim(),
                                                                            revision:
                                                                                '00',
                                                                            productTypeId:
                                                                                value.producttypeId.toString().trim()));
                                                                      },
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    cancelButton(
                                                                        navigator:
                                                                            Navigator.of(
                                                                                context),
                                                                        productDetailsDataSnapshot:
                                                                            productDetailsDataSnapshot),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          // Navigator
                                                                          final navigator =
                                                                              Navigator.of(context);
                                                                          QuickFixUi()
                                                                              .showProcessing(context: context);

                                                                          List<Map<String, dynamic>>
                                                                              jsonDataList =
                                                                              dataList.map((item) => item.toJson()).toList();

                                                                          // Copy raw material
                                                                          Map<String, dynamic> response = await PamRepository().registerProductStructure(
                                                                              token: state.token,
                                                                              payload: {
                                                                                'createdby': state.userId,
                                                                                'selectedProducts': jsonDataList,
                                                                                'parentproduct_id': productDetailsDataSnapshot.data!.buildProductStructure![0].structureTableId,
                                                                                'level': 1
                                                                              },
                                                                              wantId: true);
                                                                          if (response['Message'] ==
                                                                              'Success') {
                                                                            // QuickFixUi().showCustomDialog(
                                                                            //     context: context,
                                                                            //     errorMessage: response['data'][0][0]['id']);
                                                                            // debugPrint('${response[2]['data'][0][0]['id']}--------------------------------------------------------');
                                                                            // Get tree data to represent product tree
                                                                            ProductStructureDetailsModel
                                                                                node =
                                                                                await PamRepository().productStructureTreeRepresentation(token: state.token, payload: {
                                                                              'id': parentProduct.text,
                                                                              'revision_number': parentRevision.text
                                                                            });

                                                                            if (node.buildProductStructure![0].part !=
                                                                                '') {
                                                                              // Add tree data in controller to represent
                                                                              productTreeData.add(node);
                                                                              // Get updated data
                                                                              ProductStructureDetailsModel updatedData = await PamRepository().productStructureTreeRepresentation(token: state.token, payload: {
                                                                                'id': productDetailsDataSnapshot.data!.buildProductStructure![0].partId,
                                                                                'revision_number': productDetailsDataSnapshot.data!.buildProductStructure![0].revision
                                                                              });
                                                                              if (updatedData.buildProductStructure![0].part != '') {
                                                                                // Add data in controller to represent selected product data
                                                                                productDetailsData.add(updatedData);

                                                                                // Empty dataList
                                                                                dataList = [];
                                                                                // Close processing window
                                                                                navigator.pop();
                                                                              }
                                                                            }
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                            'Submit',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, color: AppColors().getColorsDependUponProductType(productType: productDetailsDataSnapshot.data!.buildProductStructure![0].producttypeId.toString(), value: 800) ?? Colors.black)))
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Text(
                                                            'Assign raw material',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors().getColorsDependUponProductType(
                                                                        productType: productDetailsDataSnapshot
                                                                            .data!
                                                                            .buildProductStructure![
                                                                                0]
                                                                            .producttypeId
                                                                            .toString(),
                                                                        value:
                                                                            800) ??
                                                                    Colors
                                                                        .black)));
                                                  }
                                                })
                                            : const Text('')
                                      ],
                                    ),
                                    // Children's view table
                                    productDetailsDataSnapshot.data != null &&
                                            productDetailsDataSnapshot.data!
                                                    .buildProductStructure !=
                                                null &&
                                            productDetailsDataSnapshot
                                                    .data!
                                                    .buildProductStructure![0]
                                                    .children !=
                                                null &&
                                            productDetailsDataSnapshot
                                                .data!
                                                .buildProductStructure![0]
                                                .children!
                                                .isNotEmpty
                                        ? childrensViewTable(
                                            size: size,
                                            productDetailsDataSnapshot:
                                                productDetailsDataSnapshot,
                                            rowHeight: rowHeight,
                                            tableHeight: tableHeight,
                                            context: context,
                                            state: state)
                                        : const Stack()
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Stack();
                    }
                  });
            });
      } else {
        return const Stack();
      }
    });
  }

  ElevatedButton copyRawMaterialButton(
      {required BuildContext context,
      required AsyncSnapshot<ProductBOMDetails> productBomDetailsSnapshot,
      required ProductStructureState state,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return ElevatedButton(
        onPressed: () async {
          // Navigator
          final navigator = Navigator.of(context);
          QuickFixUi().showProcessing(context: context);

          // Add data to list to send list
          List<SelectedProductModel> dataList = [];
          dataList.add(SelectedProductModel(
              productid:
                  productBomDetailsSnapshot.data!.productId.toString().trim(),
              revision: '00',
              productTypeId: productBomDetailsSnapshot.data!.producttypeId
                  .toString()
                  .trim()));
          List<Map<String, dynamic>> jsonDataList =
              dataList.map((item) => item.toJson()).toList();

          // Copy raw material
          String response = await PamRepository()
              .registerProductStructure(token: state.token, payload: {
            'createdby': state.userId,
            'selectedProducts': jsonDataList,
            'parentproduct_id': productDetailsDataSnapshot
                .data!.buildProductStructure![0].structureTableId,
            'level': 1,
          });
          if (response == 'Success') {
            // Get tree data to represent product tree
            ProductStructureDetailsModel node = await PamRepository()
                .productStructureTreeRepresentation(
                    token: state.token,
                    payload: {
                  'id': parentProduct.text,
                  'revision_number': parentRevision.text
                });

            if (node.buildProductStructure![0].part != '') {
              // Add tree data in controller to represent
              productTreeData.add(node);
              // Get updated data
              ProductStructureDetailsModel updatedData = await PamRepository()
                  .productStructureTreeRepresentation(
                      token: state.token,
                      payload: {
                    'id': productDetailsDataSnapshot
                        .data!.buildProductStructure![0].partId,
                    'revision_number': productDetailsDataSnapshot
                        .data!.buildProductStructure![0].revision
                  });
              if (updatedData.buildProductStructure![0].part != '') {
                // Add data in controller to represent selected product data
                productDetailsData.add(updatedData);

                // Empty datalist
                dataList = [];
                // Close processing window
                navigator.pop();
              }
            }
          }
        },
        child: Text('Copy raw material',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors().getColorsDependUponProductType(
                        productType: productDetailsDataSnapshot
                            .data!.buildProductStructure![0].producttypeId
                            .toString(),
                        value: 800) ??
                    Colors.black)));
  }

  Container childrensViewTable(
      {required Size size,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required double rowHeight,
      required double tableHeight,
      required BuildContext context,
      required ProductStructureState state}) {
    return Container(
      width: size.width / 2,
      height: ((productDetailsDataSnapshot
                          .data!.buildProductStructure![0].children!.length +
                      1.2) *
                  rowHeight) >
              tableHeight
          ? tableHeight
          : ((productDetailsDataSnapshot
                      .data!.buildProductStructure![0].children!.length +
                  1.2) *
              rowHeight),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: CustomTable(
          tablewidth: size.width / 2,
          tableheight: ((productDetailsDataSnapshot.data!.buildProductStructure![0].children!.length + 1.2) * rowHeight) > tableHeight
              ? tableHeight
              : ((productDetailsDataSnapshot.data!.buildProductStructure![0].children!.length + 1.2) *
                  rowHeight),
          headerHeight: rowHeight,
          rowHeight: rowHeight,
          columnWidth: ((size.width / 2) - 20) / 5,
          tableheaderColor: Theme.of(context).dialogBackgroundColor,
          tablebodyColor: Theme.of(context).dialogBackgroundColor,
          tableBorderColor: AppColors().getColorsDependUponProductType(
                  productType: productDetailsDataSnapshot
                      .data!.buildProductStructure![0].producttypeId
                      .toString(),
                  value: 800) ??
              Colors.black,
          tableOutsideBorder: true,
          enableRowBottomBorder: true,
          enableHeaderBottomBorder: true,
          headerStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors().getColorsDependUponProductType(
                  productType: productDetailsDataSnapshot
                      .data!.buildProductStructure![0].producttypeId
                      .toString(),
                  value: 800)),
          headerBorderThickness: 1,
          headerBorderColor:
              AppColors().getColorsDependUponProductType(productType: productDetailsDataSnapshot.data!.buildProductStructure![0].producttypeId.toString(), value: 800) ?? Colors.black,
          column: [
            ColumnData(label: 'Product'),
            ColumnData(label: 'Revision'),
            ColumnData(label: 'Product type'),
            ColumnData(label: 'Description'),
            ColumnData(label: 'Action'),
          ],
          rows: productDetailsDataSnapshot.data!.buildProductStructure![0].children!.map((childElement) {
            return childtableRows(
                childElement: ProductStructureDetailsModel(
                    buildProductStructure: [childElement]),
                context: context,
                state: state,
                productDetailsDataSnapshot: productDetailsDataSnapshot);
          }).toList()),
    );
  }

  RowData childtableRows(
      {required ProductStructureDetailsModel childElement,
      required BuildContext context,
      required ProductStructureState state,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return RowData(cell: [
      TableDataCell(
          label: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          childElement.buildProductStructure![0].part.toString(),
          textAlign: TextAlign.center,
        ),
      )),
      TableDataCell(
          label: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          childElement.buildProductStructure![0].revision.toString(),
          textAlign: TextAlign.center,
        ),
      )),
      TableDataCell(
          label: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          childElement.buildProductStructure![0].producttype.toString(),
          textAlign: TextAlign.center,
        ),
      )),
      TableDataCell(
          label: InkWell(
        onTap: () {
          QuickFixUi().showCustomDialog(
              context: context,
              errorMessage: childElement.buildProductStructure![0].description
                  .toString());
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            childElement.buildProductStructure![0].description.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      )),
      TableDataCell(
          label: IconButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                deleteConfirmationDialog(
                    context: context,
                    navigator: navigator,
                    state: state,
                    childElement: childElement,
                    productDetailsDataSnapshot: productDetailsDataSnapshot);
              },
              icon: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.error)))
    ]);
  }

  Future<dynamic> deleteConfirmationDialog(
      {required BuildContext context,
      required NavigatorState navigator,
      required ProductStructureState state,
      required ProductStructureDetailsModel childElement,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: const SizedBox(
              height: 25,
              child: Center(
                  child: Text(
                'Are you sure?',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
            actions: [
              noButton(navigator: navigator),
              yesButton(
                  navigator: navigator,
                  context: context,
                  state: state,
                  childElement: childElement,
                  productDetailsDataSnapshot: productDetailsDataSnapshot)
            ],
          );
        });
  }

  ElevatedButton noButton({required NavigatorState navigator}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        onPressed: () {
          navigator.pop();
        },
        child: const Text('No',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
  }

  ElevatedButton yesButton(
      {required NavigatorState navigator,
      required BuildContext context,
      required ProductStructureState state,
      required ProductStructureDetailsModel childElement,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () async {
          // Show processing
          navigator.pop();
          QuickFixUi().showProcessing(context: context);
          String response = await PamRepository()
              .deleteProductFromProductStructure(token: state.token, payload: {
            'id': childElement.buildProductStructure![0].structureTableId!
          });
          if (response == 'Deleted successfully') {
            // Get tree data to represent product tree
            ProductStructureDetailsModel node = await PamRepository()
                .productStructureTreeRepresentation(
                    token: state.token,
                    payload: {
                  'id': parentProduct.text,
                  'revision_number': parentRevision.text
                });

            if (node.buildProductStructure![0].part != '') {
              // Add tree data in controller to represent
              productTreeData.add(node);
              // Get selected product data
              ProductStructureDetailsModel updatedData = await PamRepository()
                  .productStructureTreeRepresentation(
                      token: state.token,
                      payload: {
                    'id': productDetailsDataSnapshot
                        .data!.buildProductStructure![0].partId,
                    'revision_number': productDetailsDataSnapshot
                        .data!.buildProductStructure![0].revision
                  });
              if (updatedData.buildProductStructure![0].part != '') {
                // Add data in controller to represent selected product data
                productDetailsData.add(updatedData);

                // Close child registration window
                navigator.pop();
              }
            }
          }
        },
        child: const Text('Yes',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
  }

  Padding childButton(
      {required AsyncSnapshot<bool> isDataAddedSnapshot,
      required BuildContext context,
      required Size size,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required ProductStructureState state}) {
    return Padding(
      padding: EdgeInsets.only(
          left: (isDataAddedSnapshot.data != null &&
                  isDataAddedSnapshot.data == true)
              ? 10
              : 0),
      child: ElevatedButton(
          onPressed: () {
            final navigator = Navigator.of(context);
            childRegistrationDialog(
                context: context,
                size: size,
                productDetailsDataSnapshot: productDetailsDataSnapshot,
                state: state,
                navigator: navigator);
          },
          child: Text(
            'Child',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors().getColorsDependUponProductType(
                        productType: productDetailsDataSnapshot
                            .data!.buildProductStructure![0].producttypeId
                            .toString(),
                        value: 800) ??
                    Colors.black),
          )),
    );
  }

  Future<dynamic> childRegistrationDialog(
      {required BuildContext context,
      required Size size,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required ProductStructureState state,
      required NavigatorState navigator}) {
    double columnWidth = 190;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: SizedBox(
              width: columnWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  registrationDialogTitle(
                      productDetailsDataSnapshot: productDetailsDataSnapshot),
                  productSearchWidget(
                      productDetailsDataSnapshot: productDetailsDataSnapshot,
                      state: state,
                      context: context)
                ],
              ),
            ),
            content: childRegisrationTable(
                size: size,
                state: state,
                productDetailsDataSnapshot: productDetailsDataSnapshot,
                columnWidth: columnWidth),
            actions: [
              cancelButton(
                  navigator: navigator,
                  productDetailsDataSnapshot: productDetailsDataSnapshot),
              StreamBuilder<List<SelectedProductModel>>(
                  stream: selectedProducts.stream,
                  builder: (context, selectedProductsSnapshot) {
                    if (selectedProductsSnapshot.data != null &&
                        selectedProductsSnapshot.data!.isNotEmpty) {
                      return addButton(
                          context: context,
                          selectedProductsSnapshot: selectedProductsSnapshot,
                          state: state,
                          productDetailsDataSnapshot:
                              productDetailsDataSnapshot,
                          navigator: navigator);
                    } else {
                      return const Stack();
                    }
                  })
            ],
          );
        });
  }

  Text registrationDialogTitle(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return Text(
        '''Register ${productDetailsDataSnapshot.data!.buildProductStructure![0].part} product's child's ''',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors().getColorsDependUponProductType(
                productType: productDetailsDataSnapshot
                    .data!.buildProductStructure![0].producttypeId
                    .toString(),
                value: 800)));
  }

  SizedBox productSearchWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required ProductStructureState state,
      required BuildContext context}) {
    return SizedBox(
      width: 200,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: TextField(
              decoration: const InputDecoration(hintText: 'Search product'),
              onChanged: (value) {
                searchedString.text = value;
              },
            ),
          ),
          Container(
              width: 40,
              height: 40,
              color: AppColors().getColorsDependUponProductType(
                      productType: productDetailsDataSnapshot
                          .data!.buildProductStructure![0].producttypeId
                          .toString(),
                      value: 800) ??
                  Colors.black,
              child: IconButton(
                onPressed: () {
                  List<ProductsWithRevisionDataModel> data = state.productsList
                      .where((product) => product.product
                          .toString()
                          .toLowerCase()
                          .contains(
                              searchedString.text.toString().toLowerCase()))
                      .toList();
                  if (data.isNotEmpty) {
                    searchedProducts.add(data);
                    textfieldRevision.add({});
                  } else {
                    QuickFixUi().showCustomDialog(
                        errorMessage: 'Product not found.', context: context);
                  }
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }

  Container childRegisrationTable(
      {required Size size,
      required ProductStructureState state,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required double columnWidth}) {
    return Container(
      width: columnWidth * 6,
      height: size.height - 30,
      padding: const EdgeInsets.all(5),
      child: StreamBuilder<List<ProductsWithRevisionDataModel>>(
          stream: searchedProducts.stream,
          builder: (context, searchedProductsSnapshot) {
            return StreamBuilder<List<SelectedProductModel>>(
                stream: selectedProducts.stream,
                builder: (context, selectedProductsSnapshot) {
                  return CustomTable(
                      tablewidth: columnWidth * 6,
                      tableheight:
                          ((searchedProductsSnapshot.data != null && searchedProductsSnapshot.data!.isNotEmpty ? searchedProductsSnapshot.data! : state.productsList.take(100)).length + 2) *
                              45,
                      columnWidth: columnWidth,
                      tablebodyColor: Theme.of(context).dialogBackgroundColor,
                      tableheaderColor: Theme.of(context).dialogBackgroundColor,
                      headerStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors().getColorsDependUponProductType(
                              productType: productDetailsDataSnapshot
                                  .data!.buildProductStructure![0].producttypeId
                                  .toString(),
                              value: 800)),
                      tableOutsideBorder: true,
                      enableHeaderBottomBorder: true,
                      headerBorderThickness: 1,
                      enableRowBottomBorder: true,
                      tableBorderColor: AppColors().getColorsDependUponProductType(
                              productType: productDetailsDataSnapshot
                                  .data!.buildProductStructure![0].producttypeId
                                  .toString(),
                              value: 800) ??
                          Colors.black,
                      headerHeight: 45,
                      rowHeight: 45,
                      column: childRegistrationTableColumns,
                      rows: ((searchedProductsSnapshot.data != null &&
                                  searchedProductsSnapshot.data!.isNotEmpty)
                              ? searchedProductsSnapshot.data!
                              : state.productsList.take(100))
                          .map((element) {
                        double rowheight = 0;
                        if (element.revisionNumbers != null &&
                            element.revisionNumbers!.isNotEmpty) {
                          rowheight = element.revisionNumbers!.length * 45;
                        } else {
                          rowheight = 45;
                        }
                        return childRegistrationTableRows(
                            rowheight: rowheight,
                            element: element,
                            productDetailsDataSnapshot:
                                productDetailsDataSnapshot,
                            selectedProductsSnapshot: selectedProductsSnapshot,
                            state: state);
                      }).toList());
                });
          }),
    );
  }

  List<ColumnData> get childRegistrationTableColumns {
    return [
      ColumnData(label: 'Product'),
      ColumnData(label: 'Revision'),
      ColumnData(label: 'Product type'),
      ColumnData(label: 'Unit of measurement'),
      ColumnData(label: 'Description'),
      ColumnData(label: 'Action')
    ];
  }

  RowData childRegistrationTableRows(
      {required double rowheight,
      required ProductsWithRevisionDataModel element,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required AsyncSnapshot<List<SelectedProductModel>>
          selectedProductsSnapshot,
      required ProductStructureState state}) {
    return RowData(cell: [
      TableDataCell(
          height: rowheight,
          label: cellTextWidget(text: element.product.toString())),
      TableDataCell(
          height: rowheight,
          label: ListView(
            children: element.revisionNumbers != null &&
                    element.revisionNumbers!.isNotEmpty
                ? element.revisionNumbers!.map((e) {
                    if (e.trim() == '') {
                      return addnewRevisionWidget(
                          rowheight: rowheight, element: element);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: cellTextWidget(text: e),
                        ),
                      );
                    }
                  }).toList()
                : [
                    addnewRevisionWidget(rowheight: rowheight, element: element)
                  ],
          )),
      TableDataCell(
          height: rowheight,
          label: cellTextWidget(text: element.producttype.toString())),
      TableDataCell(
          height: rowheight,
          label: cellTextWidget(text: element.uom.toString())),
      TableDataCell(
          height: rowheight,
          label: cellTextWidget(text: element.description.toString())),
      checkboxDataCell(
          rowheight: rowheight,
          productDetailsDataSnapshot: productDetailsDataSnapshot,
          element: element,
          selectedProductsSnapshot: selectedProductsSnapshot)
    ]);
  }

  Center addnewRevisionWidget(
      {required double rowheight,
      required ProductsWithRevisionDataModel element}) {
    return Center(
      child: SizedBox(
        height: rowheight - 3,
        child: StreamBuilder<Map<String, String>>(
            stream: textfieldRevision.stream,
            builder: (context, textfieldRevisionSnapshot) {
              final controller = TextEditingController(
                text: textfieldRevisionSnapshot.data != null &&
                        textfieldRevisionSnapshot.data!['revision']
                                .toString() !=
                            '' &&
                        textfieldRevisionSnapshot.data!['revision'] != null &&
                        textfieldRevisionSnapshot.data!['id'].toString() ==
                            element.productId
                    ? textfieldRevisionSnapshot.data!['revision'].toString()
                    : '',
              );
              return TextField(
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Revision',
                    hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                onTap: () {
                  if (textfieldRevisionSnapshot.data != null &&
                      textfieldRevisionSnapshot.data!['revision'].toString() !=
                          '' &&
                      textfieldRevisionSnapshot.data!['id'].toString() !=
                          element.productId) {
                    textfieldRevision.add({});
                  }
                },
                onChanged: (value) {
                  if (value.toString().length >= 2) {
                    textfieldRevision.add({
                      'id': element.productId.toString(),
                      'revision': value.toString()
                    });
                  }
                },
              );
            }),
      ),
    );
  }

  TableDataCell checkboxDataCell(
      {required double rowheight,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required ProductsWithRevisionDataModel element,
      required AsyncSnapshot<List<SelectedProductModel>>
          selectedProductsSnapshot}) {
    return TableDataCell(
        height: rowheight,
        label: productDetailsDataSnapshot.data != null &&
                productDetailsDataSnapshot
                        .data!.buildProductStructure![0].part ==
                    element.product.toString().trim()
            ? const Text(
                'Parent',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              )
            : (productDetailsDataSnapshot.data != null &&
                    productDetailsDataSnapshot
                        .data!.buildProductStructure![0].children!
                        .any((e) =>
                            e.partId.toString().trim() ==
                            element.productId.toString().trim()))
                ? Text(
                    'Enrolled',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors().getColorsDependUponProductType(
                            productType: productDetailsDataSnapshot
                                .data!.buildProductStructure![0].producttypeId
                                .toString(),
                            value: 800)),
                  )
                : StreamBuilder<Map<String, String>>(
                    stream: textfieldRevision.stream,
                    builder: (context, textfieldRevisionSnapshot) {
                      return ListView(
                        children: element.revisionNumbers != null &&
                                element.revisionNumbers!.isNotEmpty
                            ? element.revisionNumbers!.map((e) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: (e == 'null' || e == '')
                                        ? const Text('')
                                        : Checkbox(
                                            activeColor: AppColors()
                                                .getColorsDependUponProductType(
                                                    productType:
                                                        productDetailsDataSnapshot
                                                            .data!
                                                            .buildProductStructure![
                                                                0]
                                                            .producttypeId
                                                            .toString(),
                                                    value: 800),
                                            value: checkboxValue(
                                                selectedProductsSnapshot:
                                                    selectedProductsSnapshot,
                                                element: element,
                                                revision: e),
                                            onChanged: (value) {
                                              List<SelectedProductModel>
                                                  dataList = [];
                                              if (selectedProductsSnapshot
                                                      .data !=
                                                  null) {
                                                dataList =
                                                    selectedProductsSnapshot
                                                        .data!;
                                              }
                                              if (checkboxValue(
                                                  selectedProductsSnapshot:
                                                      selectedProductsSnapshot,
                                                  element: element,
                                                  revision: e)) {
                                                dataList.removeWhere(
                                                    (selectedProduct) =>
                                                        selectedProduct
                                                            .productid ==
                                                        element.productId
                                                            .toString());
                                                selectedProducts.add(dataList);
                                              } else {
                                                dataList.add(
                                                    SelectedProductModel(
                                                        productid: element
                                                            .productId
                                                            .toString()
                                                            .trim(),
                                                        revision: e.trim(),
                                                        productTypeId: element
                                                            .producttypeId
                                                            .toString()
                                                            .trim()));
                                                if (textfieldRevisionSnapshot
                                                            .data !=
                                                        null &&
                                                    textfieldRevisionSnapshot
                                                        .data!.isNotEmpty) {
                                                  dataList = dataList
                                                      .map((selectedProduct) {
                                                    if (selectedProduct
                                                            .productid ==
                                                        element.productId
                                                            .toString()) {
                                                      selectedProduct.revision =
                                                          textfieldRevisionSnapshot
                                                              .data!['revision']
                                                              .toString();
                                                    }
                                                    return selectedProduct;
                                                  }).toList();
                                                }
                                                selectedProducts.add(dataList);
                                              }
                                            }),
                                  ),
                                );
                              }).toList()
                            : [
                                ((textfieldRevisionSnapshot.data != null &&
                                            textfieldRevisionSnapshot
                                                .data!.isNotEmpty &&
                                            textfieldRevisionSnapshot
                                                    .data!['revision']
                                                    .toString()
                                                    .length >=
                                                2 &&
                                            textfieldRevisionSnapshot
                                                    .data!['id']
                                                    .toString() ==
                                                element.productId.toString()) ||
                                        (selectedProductsSnapshot.data !=
                                                null &&
                                            selectedProductsSnapshot.data!.any(
                                                (selectedProduct) =>
                                                    selectedProduct.productid ==
                                                    element.productId)))
                                    ? SizedBox(
                                        height: rowheight - 4,
                                        child: Checkbox(
                                            activeColor: AppColors().getColorsDependUponProductType(
                                                productType: productDetailsDataSnapshot
                                                    .data!
                                                    .buildProductStructure![0]
                                                    .producttypeId
                                                    .toString(),
                                                value: 800),
                                            value: checkboxValue(
                                                selectedProductsSnapshot:
                                                    selectedProductsSnapshot,
                                                element: element,
                                                revision: (textfieldRevisionSnapshot.data !=
                                                            null &&
                                                        textfieldRevisionSnapshot
                                                            .data!.isNotEmpty &&
                                                        textfieldRevisionSnapshot.data!['revision']
                                                                .toString()
                                                                .length >=
                                                            2)
                                                    ? textfieldRevisionSnapshot
                                                        .data!['revision']
                                                        .toString()
                                                    : selectedProductsSnapshot.data !=
                                                            null
                                                        ? selectedProductsSnapshot.data!
                                                            .where((newE) =>
                                                                newE.productid ==
                                                                element.productId)
                                                            .first
                                                            .revision
                                                        : ''),
                                            onChanged: (value) {
                                              List<SelectedProductModel>
                                                  dataList = [];
                                              if (selectedProductsSnapshot
                                                      .data !=
                                                  null) {
                                                dataList =
                                                    selectedProductsSnapshot
                                                        .data!;
                                              }

                                              if (checkboxValue(
                                                  selectedProductsSnapshot:
                                                      selectedProductsSnapshot,
                                                  element: element,
                                                  revision: (textfieldRevisionSnapshot
                                                                  .data !=
                                                              null &&
                                                          textfieldRevisionSnapshot
                                                              .data!
                                                              .isNotEmpty &&
                                                          textfieldRevisionSnapshot
                                                                  .data![
                                                                      'revision']
                                                                  .toString()
                                                                  .length >=
                                                              2)
                                                      ? textfieldRevisionSnapshot
                                                          .data!['revision']
                                                          .toString()
                                                      : selectedProductsSnapshot
                                                                  .data !=
                                                              null
                                                          ? selectedProductsSnapshot
                                                              .data!
                                                              .where((newE) =>
                                                                  newE.productid ==
                                                                  element
                                                                      .productId)
                                                              .first
                                                              .revision
                                                          : '')) {
                                                dataList.removeWhere(
                                                    (selectedProduct) =>
                                                        selectedProduct
                                                            .productid ==
                                                        element.productId
                                                            .toString());
                                                selectedProducts.add(dataList);
                                              } else {
                                                dataList.add(
                                                    SelectedProductModel(
                                                        productid: element
                                                            .productId
                                                            .toString()
                                                            .trim(),
                                                        revision: '',
                                                        productTypeId: element
                                                            .producttypeId
                                                            .toString()
                                                            .trim()));

                                                dataList = dataList
                                                    .map((selectedProduct) {
                                                  if (selectedProduct
                                                          .productid ==
                                                      element.productId
                                                          .toString()) {
                                                    selectedProduct.revision =
                                                        textfieldRevisionSnapshot
                                                            .data!['revision']
                                                            .toString();
                                                  }
                                                  return selectedProduct;
                                                }).toList();

                                                selectedProducts.add(dataList);
                                              }
                                            }),
                                      )
                                    : const Text('')
                              ],
                      );
                    }));
  }

  ElevatedButton cancelButton(
      {required NavigatorState navigator,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return ElevatedButton(
        onPressed: () {
          searchedProducts.add([]);
          selectedProducts.add([]);
          navigator.pop();
        },
        child: Text('Cancel',
            style: buttonStyle(
                productDetailsDataSnapshot: productDetailsDataSnapshot)));
  }

  ElevatedButton addButton(
      {required BuildContext context,
      required AsyncSnapshot<List<SelectedProductModel>>
          selectedProductsSnapshot,
      required ProductStructureState state,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required NavigatorState navigator}) {
    return ElevatedButton(
        onPressed: () async {
          QuickFixUi().showProcessing(context: context);
          List<Map<String, dynamic>> jsonDataList = selectedProductsSnapshot
              .data!
              .map((item) => item.toJson())
              .toList();

          String response = await PamRepository()
              .registerProductStructure(token: state.token, payload: {
            'createdby': state.userId,
            'selectedProducts': jsonDataList,
            'parentproduct_id': productDetailsDataSnapshot
                .data!.buildProductStructure![0].structureTableId,
            'level': 1,
          });

          if (response == 'Success') {
            // Get tree data to represent product tree
            ProductStructureDetailsModel node = await PamRepository()
                .productStructureTreeRepresentation(
                    token: state.token,
                    payload: {
                  'id': parentProduct.text,
                  'revision_number': parentRevision.text
                });

            if (node.buildProductStructure![0].part != '') {
              // Add tree data in controller to represent
              productTreeData.add(node);
              // Get updated data
              ProductStructureDetailsModel updatedData = await PamRepository()
                  .productStructureTreeRepresentation(
                      token: state.token,
                      payload: {
                    'id': productDetailsDataSnapshot
                        .data!.buildProductStructure![0].partId,
                    'revision_number': productDetailsDataSnapshot
                        .data!.buildProductStructure![0].revision
                  });
              if (updatedData.buildProductStructure![0].part != '') {
                // Add data in controller to represent selected product data
                productDetailsData.add(updatedData);
                // Close processing window
                navigator.pop();
                // Close child registration window
                navigator.pop();
              }
            }
          }
        },
        child: Text('Add',
            style: buttonStyle(
                productDetailsDataSnapshot: productDetailsDataSnapshot)));
  }

  TextStyle buttonStyle(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors().getColorsDependUponProductType(
            productType: productDetailsDataSnapshot
                .data!.buildProductStructure![0].producttypeId
                .toString(),
            value: 800));
  }

  bool checkboxValue(
          {required AsyncSnapshot<List<SelectedProductModel>>
              selectedProductsSnapshot,
          required ProductsWithRevisionDataModel element,
          required String revision}) =>
      selectedProductsSnapshot.data != null &&
      selectedProductsSnapshot.data!.isNotEmpty &&
      selectedProductsSnapshot.data!.any((selectedProduct) =>
          selectedProduct.productid == element.productId &&
          selectedProduct.revision == revision);

  Text cellTextWidget({required String text}) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }

  TextField leadTimeWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required AsyncSnapshot<bool> isDataAddedSnapshot}) {
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      cursorWidth: 1,
      controller: leadtimeController.text == ''
          ? TextEditingController(
              text: productDetailsDataSnapshot
                          .data!.buildProductStructure![0].leadtime !=
                      null
                  ? productDetailsDataSnapshot
                      .data!.buildProductStructure![0].leadtime
                      .toString()
                  : '0')
          : leadtimeController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5, left: 10),
          border: OutlineInputBorder()),
      onTap: () {
        if (isDataAddedSnapshot.data == null) {
          isDataAdded.add(true);
        } else if (isDataAddedSnapshot.data == false) {
          isDataAdded.add(true);
        }
      },
      onChanged: (value) {
        leadtimeController.text = value.toString();
      },
    );
  }

  TextField reorderLevelWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required AsyncSnapshot<bool> isDataAddedSnapshot}) {
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      cursorWidth: 1,
      controller: reorderLevelController.text == ''
          ? TextEditingController(
              text: productDetailsDataSnapshot
                          .data!.buildProductStructure![0].reorderLevel !=
                      null
                  ? productDetailsDataSnapshot
                      .data!.buildProductStructure![0].reorderLevel
                      .toString()
                  : '0')
          : reorderLevelController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5, left: 10),
          border: OutlineInputBorder()),
      onTap: () {
        if (isDataAddedSnapshot.data == null) {
          isDataAdded.add(true);
        } else if (isDataAddedSnapshot.data == false) {
          isDataAdded.add(true);
        }
      },
      onChanged: (value) {
        reorderLevelController.text = value.toString();
      },
    );
  }

  TextField minimumOrderQuantityWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required AsyncSnapshot<bool> isDataAddedSnapshot}) {
    return TextField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.number,
      cursorWidth: 1,
      controller: minOrderQuantityController.text == ''
          ? TextEditingController(
              text: productDetailsDataSnapshot
                          .data!.buildProductStructure![0].minOrderQuantity !=
                      null
                  ? productDetailsDataSnapshot
                      .data!.buildProductStructure![0].minOrderQuantity
                      .toString()
                  : '0')
          : minOrderQuantityController,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5, left: 10),
          border: OutlineInputBorder()),
      onTap: () {
        if (isDataAddedSnapshot.data == null) {
          isDataAdded.add(true);
        } else if (isDataAddedSnapshot.data == false) {
          isDataAdded.add(true);
        }
      },
      onChanged: (value) {
        minOrderQuantityController.text = value.toString();
      },
    );
  }

  Row quantityWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required AsyncSnapshot<bool> isDataAddedSnapshot,
      required Size size}) {
    return Row(
      children: [
        SizedBox(
          width: ((size.width / 8) - 30) - 65,
          child: TextField(
            readOnly: productDetailsDataSnapshot
                        .data!.buildProductStructure![0].level ==
                    0
                ? true
                : false,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            cursorWidth: 1,
            controller: quantityController.text == ''
                ? TextEditingController(
                    text: productDetailsDataSnapshot
                                .data!.buildProductStructure![0].quantity !=
                            null
                        ? '${productDetailsDataSnapshot.data!.buildProductStructure![0].quantity}'
                        : '0')
                : quantityController,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 5, left: 10),
                border: OutlineInputBorder()),
            onTap: () {
              if (isDataAddedSnapshot.data == null) {
                isDataAdded.add(true);
              } else if (isDataAddedSnapshot.data == false) {
                isDataAdded.add(true);
              }
            },
            onChanged: (value) {
              quantityController.text = value.toString();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: InkWell(
            onTap: () {
              QuickFixUi().showCustomDialog(
                  context: context,
                  errorMessage: productDetailsDataSnapshot
                      .data!.buildProductStructure![0].unitOfMeasurement
                      .toString());
            },
            child: SizedBox(
              width: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  productDetailsDataSnapshot
                      .data!.buildProductStructure![0].unitOfMeasurement
                      .toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Text productTypeWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return Text(
      productDetailsDataSnapshot.data!.buildProductStructure![0].producttype
          .toString(),
    );
  }

  descriptionWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return InkWell(
      onTap: () {
        QuickFixUi().showCustomDialog(
            context: context,
            errorMessage: productDetailsDataSnapshot
                .data!.buildProductStructure![0].description
                .toString());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          productDetailsDataSnapshot.data!.buildProductStructure![0].description
              .toString(),
        ),
      ),
    );
  }

  Text revisionWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return Text(
      productDetailsDataSnapshot.data!.buildProductStructure![0].revision
          .toString(),
    );
  }

  SingleChildScrollView partWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        productDetailsDataSnapshot.data!.buildProductStructure![0].part
            .toString(),
      ),
    );
  }

  Text levelWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return Text(
      productDetailsDataSnapshot.data!.buildProductStructure![0].level
          .toString(),
    );
  }

  SingleChildScrollView parentPartWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        productDetailsDataSnapshot.data!.buildProductStructure![0].parentPart
                    .toString() ==
                'null'
            ? ''
            : productDetailsDataSnapshot
                .data!.buildProductStructure![0].parentPart
                .toString(),
      ),
    );
  }

  Center detailsHeaderWidget(
      {required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Text(
        'Product details',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors().getColorsDependUponProductType(
                productType: productDetailsDataSnapshot
                    .data!.buildProductStructure![0].producttypeId
                    .toString(),
                value: 800)),
      ),
    ));
  }

  ElevatedButton updateButton(
      {required BuildContext context,
      required ProductStructureState state,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productTreeDataSnapshot,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) {
    return ElevatedButton(
        onPressed: () async {
          double quality = 0;

          // Add quantity in controller
          if (quantityController.text != '') {
            quality = double.parse(quantityController.text);
          } else {
            quality = double.parse(productDetailsDataSnapshot
                .data!.buildProductStructure![0].quantity
                .toString());
          }

          if (quality > 0) {
            // Initialize navigator
            NavigatorState navigator = Navigator.of(context);

            // Show processing screen
            QuickFixUi().showProcessing(context: context);

            // Update product details
            debugPrint(productDetailsDataSnapshot
                .data!.buildProductStructure![0].oldStructureTableId
                .toString());
            String response = await PamRepository()
                .updateProductDetails(token: state.token, payload: {
              'createdby': state.userId,
              'id': productDetailsDataSnapshot
                  .data!.buildProductStructure![0].oldStructureTableId,
              'old_quantity': productDetailsDataSnapshot
                  .data!.buildProductStructure![0].quantity,
              'old_minimumorderqty': productDetailsDataSnapshot
                  .data!.buildProductStructure![0].minOrderQuantity,
              'old_reorderlevel': productDetailsDataSnapshot
                  .data!.buildProductStructure![0].reorderLevel,
              'old_leadtime': productDetailsDataSnapshot
                  .data!.buildProductStructure![0].leadtime,
              'new_quantity': quantityController.text == ''
                  ? productDetailsDataSnapshot
                      .data!.buildProductStructure![0].quantity
                  : quantityController.text,
              'new_minimumorderqty': minOrderQuantityController.text == ''
                  ? productDetailsDataSnapshot
                      .data!.buildProductStructure![0].minOrderQuantity
                  : minOrderQuantityController.text,
              'new_reorderlevel': reorderLevelController.text == ''
                  ? productDetailsDataSnapshot
                      .data!.buildProductStructure![0].reorderLevel
                  : reorderLevelController.text,
              'new_leadtime': leadtimeController.text == ''
                  ? productDetailsDataSnapshot
                      .data!.buildProductStructure![0].leadtime
                  : leadtimeController.text
            });

            if (response == 'Updated successfully') {
              // Get tree data to represent product tree
              ProductStructureDetailsModel node = await PamRepository()
                  .productStructureTreeRepresentation(
                      token: state.token,
                      payload: {
                    'id': parentProduct.text,
                    'revision_number': parentRevision.text
                  });

              if (node.buildProductStructure![0].part != '') {
                // Add tree data in controller to represent
                productTreeData.add(node);

                // Get updated data
                ProductStructureDetailsModel updatedData = await PamRepository()
                    .productStructureTreeRepresentation(
                        token: state.token,
                        payload: {
                      'stucture_table_id': productDetailsDataSnapshot
                          .data!.buildProductStructure![0].oldStructureTableId,
                    });

                if (updatedData.buildProductStructure![0].part != '') {
                  // Add data in controller to represent selected product datas
                  productDetailsData.add(updatedData);

                  // Close is updated button
                  isDataAdded.add(false);

                  // Close processing window
                  navigator.pop();

                  // Close all controllers
                  quantityController.text = '';
                  minOrderQuantityController.text = '';
                  reorderLevelController.text = '';
                  leadtimeController.text = '';
                }
              }
            }
          } else {
            QuickFixUi.errorMessage(
                'Quantity should be greater than 0', context);
          }
        },
        child: Text(
          'Update',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors().getColorsDependUponProductType(
                  productType: productDetailsDataSnapshot
                      .data!.buildProductStructure![0].producttypeId
                      .toString(),
                  value: 800)),
        ));
  }

  ElevatedButton exploadButton(
      {required BuildContext context,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required ProductStructureState state}) {
    return ElevatedButton(
        onPressed: () async {
          // Initialize navigator
          NavigatorState navigator = Navigator.of(context);
          // Show processing
          QuickFixUi().showProcessing(context: context);
          try {
            // Initialize quantity
            double quality = 0;

            // Add quantity in controller
            if (quantityController.text != '') {
              quality = double.parse(quantityController.text);
            } else {
              quality = double.parse(productDetailsDataSnapshot
                  .data!.buildProductStructure![0].quantity
                  .toString());
            }

            if (quality > 0) {
              // Register product in product structure
              String response = await PamRepository()
                  .registerProductStructure(token: state.token, payload: {
                'createdby': state.userId.toString().trim(),
                'childproduct_id': productDetailsDataSnapshot
                    .data!.buildProductStructure![0].partId
                    .toString()
                    .trim(),
                'parentproduct_id': productDetailsDataSnapshot
                    .data!.buildProductStructure![0].parentpartId
                    .toString()
                    .trim(),
                'level': 0,
                'quantity':
                    quantityController.text != '' ? quantityController.text : 1,
                'reorderlevel': reorderLevelController.text != ''
                    ? reorderLevelController.text
                    : 0,
                'minimumorderqty': minOrderQuantityController.text != ''
                    ? minOrderQuantityController.text
                    : 0,
                'leadtime':
                    leadtimeController.text != '' ? leadtimeController.text : 0,
                'revision_number': productDetailsDataSnapshot
                    .data!.buildProductStructure![0].revision
                    .toString()
                    .trim()
              });

              if (response.length == 32) {
                // Get tree data to represent product tree
                ProductStructureDetailsModel node = await PamRepository()
                    .productStructureTreeRepresentation(
                        token: state.token,
                        payload: {
                      'id': parentProduct.text,
                      'revision_number': parentRevision.text
                    });

                if (node.buildProductStructure![0].part != '') {
                  // Add tree data in controller to represent
                  productTreeData.add(node);

                  if (node.buildProductStructure![0].part != '') {
                    // Add data in controller to represent selected product data
                    productDetailsData.add(node);

                    // Close is updated button
                    isDataAdded.add(false);

                    // Close processing window
                    navigator.pop();

                    // Close all controllers
                    quantityController.text = '';
                    minOrderQuantityController.text = '';
                    reorderLevelController.text = '';
                    leadtimeController.text = '';
                  }
                }
              }
            } else {
              QuickFixUi.errorMessage(
                  'The quantity should be greater than 0.', context);
            }
          } catch (e) {
            //
          }
        },
        child: Text('Expload',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors().getColorsDependUponProductType(
                    productType: productDetailsDataSnapshot
                        .data!.buildProductStructure![0].producttypeId
                        .toString(),
                    value: 800))));
  }

  detailsDataRow(
      {required Size size,
      required double widgetHeight,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot,
      required String headerText1,
      required Widget widget1,
      required String headerText2,
      required Widget widget2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: (size.width / 4) - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: (size.width / 8) - 20,
                  height: widgetHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        headerText1,
                        style: headerTextStyle(),
                      ),
                      Text(
                        ':',
                        style: headerTextStyle(),
                      )
                    ],
                  )),
              Container(
                width: (size.width / 8) - 20,
                height: widgetHeight,
                padding: const EdgeInsets.only(left: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: (size.width / 8) - 30, child: widget1),
                ]),
              )
            ],
          ),
        ),
        SizedBox(
          width: (size.width / 4) - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: (size.width / 8) - 20,
                  height: widgetHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        headerText2,
                        style: headerTextStyle(),
                      ),
                      Text(
                        ':',
                        style: headerTextStyle(),
                      )
                    ],
                  )),
              Container(
                width: (size.width / 8) - 20,
                height: widgetHeight,
                padding: const EdgeInsets.only(left: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: (size.width / 8) - 30, child: widget2),
                ]),
              )
            ],
          ),
        ),
      ],
    );
  }

  TextStyle headerTextStyle() {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  StreamBuilder<List<String>> productRevisionDopdownWidget(
      {required ProductStructureState state}) {
    return StreamBuilder<List<String>>(
        stream: revisionListData.stream,
        builder: (context, revisionListDataSnapshot) {
          return StreamBuilder<ProductStructureDetailsModel>(
              stream: productDetailsData.stream,
              builder: (context, productDetailsDataSnapshot) {
                if (revisionListDataSnapshot.data != null &&
                    revisionListDataSnapshot.data!.isNotEmpty &&
                    productDetailsDataSnapshot.data != null &&
                    productDetailsDataSnapshot.data!.buildProductStructure !=
                        null &&
                    productDetailsDataSnapshot
                            .data!.buildProductStructure![0].level! >=
                        0) {
                  return Container(
                    width: 200,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.only(left: 20),
                    margin: const EdgeInsets.only(left: 20),
                    child: DropdownSearch<String>(
                        items: revisionListDataSnapshot.data!,
                        itemAsString: (item) => item.toString(),
                        popupProps: const PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            )),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                hintText: 'Select revision',
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.normal),
                                border: InputBorder.none)),
                        onChanged: (value) async {
                          await setStructureData(
                              context: context,
                              value: value,
                              state: state,
                              productDetailsDataSnapshot:
                                  productDetailsDataSnapshot);
                        }),
                  );
                } else if (productDetailsDataSnapshot.data != null &&
                    productDetailsDataSnapshot.data!.buildProductStructure !=
                        null &&
                    productDetailsDataSnapshot
                            .data!.buildProductStructure![0].level! >=
                        0) {
                  return Container(
                    width: 200,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.only(left: 20),
                    margin: const EdgeInsets.only(left: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Enter revision'),
                      onChanged: (value) async {
                        if (value.length >= 2) {
                          await setStructureData(
                              context: context,
                              value: value,
                              state: state,
                              productDetailsDataSnapshot:
                                  productDetailsDataSnapshot);
                        }
                      },
                    ),
                  );
                } else {
                  return const Stack();
                }
              });
        });
  }

  Future<void> setStructureData(
      {required BuildContext context,
      required String? value,
      required ProductStructureState state,
      required AsyncSnapshot<ProductStructureDetailsModel>
          productDetailsDataSnapshot}) async {
    productTreeData.add(ProductStructureDetailsModel());
    isDataAdded.add(false);
    NavigatorState navigator = Navigator.of(context);
    QuickFixUi().showProcessing(context: context);
    parentRevision.text = value.toString();
    ProductStructureDetailsModel node = await PamRepository()
        .productStructureTreeRepresentation(token: state.token, payload: {
      'id': parentProduct.text,
      'revision_number': parentRevision.text
    });

    if (node.buildProductStructure != null &&
        node.buildProductStructure!.isNotEmpty &&
        node.buildProductStructure![0].part != '') {
      productTreeData.add(node);
      ProductStructureDetailsModel data = ProductStructureDetailsModel(
        buildProductStructure: [
          BuildProductStructure(
              level: node.buildProductStructure![0].level,
              parentPart: node.buildProductStructure![0].level == 0
                  ? 'Self'
                  : node.buildProductStructure![0].parentPart,
              parentpartId: node.buildProductStructure![0].parentpartId,
              part: node.buildProductStructure![0].part.toString(),
              partId: node.buildProductStructure![0].partId,
              revision: node.buildProductStructure![0].revision,
              description: node.buildProductStructure![0].description,
              producttype: node.buildProductStructure![0].producttype,
              producttypeId: node.buildProductStructure![0].producttypeId,
              quantity: node.buildProductStructure![0].quantity,
              unitOfMeasurement:
                  node.buildProductStructure![0].unitOfMeasurement,
              unitOfMeasurementId:
                  node.buildProductStructure![0].unitOfMeasurementId,
              minOrderQuantity: node.buildProductStructure![0].minOrderQuantity,
              reorderLevel: node.buildProductStructure![0].reorderLevel,
              leadtime: node.buildProductStructure![0].leadtime,
              structureTableId: node.buildProductStructure![0].structureTableId,
              children: node.buildProductStructure![0].children,
              oldStructureTableId:
                  node.buildProductStructure![0].oldStructureTableId)
        ],
      );
      if (data.buildProductStructure![0].part != '') {
        productDetailsData.add(data);
      }
    } else {
      ProductStructureDetailsModel data = ProductStructureDetailsModel(
        buildProductStructure: [
          BuildProductStructure(
              level: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].level,
              parentPart: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].parentPart,
              parentpartId: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].parentpartId,
              part: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].part
                  .toString(),
              partId: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].partId,
              revision: value.toString(),
              description: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].description,
              producttype: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].producttype,
              producttypeId: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].producttypeId,
              quantity: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].quantity,
              unitOfMeasurement: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].unitOfMeasurement,
              unitOfMeasurementId: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].unitOfMeasurementId,
              oldStructureTableId: productDetailsDataSnapshot
                  .data!.buildProductStructure![0].oldStructureTableId)
        ],
      );
      if (data.buildProductStructure![0].part != '') {
        productDetailsData.add(data);
      }
    }

    navigator.pop();
  }

  Container productDropdowanWidget({required ProductStructureState state}) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.only(left: 20),
      child: DropdownSearch<ProductsWithRevisionDataModel>(
          items: state.productsList,
          itemAsString: (item) => item.product.toString(),
          popupProps: const PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              )),
          dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  hintText: 'Select product',
                  hintStyle: TextStyle(fontWeight: FontWeight.normal),
                  border: InputBorder.none)),
          onChanged: (value) {
            parentProduct.text = value!.productId!;
            productTreeData.add(ProductStructureDetailsModel());
            productDetailsData.add(ProductStructureDetailsModel());
            isDataAdded.add(false);
            Future.delayed(const Duration(milliseconds: 700), () {
              revisionListData.add(value.revisionNumbers == null ||
                      value.revisionNumbers!.isEmpty
                  ? []
                  : value.revisionNumbers!);
              productDetailsData.add(ProductStructureDetailsModel(
                buildProductStructure: [
                  BuildProductStructure(
                      level: 0,
                      parentPart: 'Self',
                      parentpartId: '',
                      part: value.product.toString(),
                      partId: value.productId.toString(),
                      revision: '',
                      description: value.description.toString(),
                      producttype: value.producttype.toString(),
                      producttypeId: value.producttypeId.toString(),
                      quantity: 1,
                      unitOfMeasurement: value.uom.toString(),
                      unitOfMeasurementId: value.uomId.toString())
                ],
              ));
            });
          }),
    );
  }
}
