// Author : Shital Gayakwad
// Created Date : 15 November 2024
// Description : Sales orders bloc

import 'package:de/bloc/sales_order/sales_order_event.dart';
import 'package:de/bloc/sales_order/sales_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/model/product/product_structure_model.dart';
import '../../services/model/sales_order/sales_order_model.dart';
import '../../services/repository/product/pam_repository.dart';
import '../../services/repository/sales_order/sales_order_repository.dart';
import '../../services/session/user_login.dart';
import 'package:intl/intl.dart';

class SalesOrderBloc extends Bloc<SalesOrderEvent, SalesOrderState> {
  SalesOrderBloc() : super((InitialSalesOrderState())) {
    // All sales order bloc state management
    on<AllOrdersEvent>((event, emit) async {
      List<AllSalesOrdersModel> allSalesOrdersList = [];
      List<SelectedAssembliesComponentRequirements> selectedAssembliesDataList =
          [];
      // User data and token
      final saveddata = await UserData.getUserData();

      // All orders data

      if (event.fromdate != '' && event.todate != '') {
        allSalesOrdersList = await SalesOrderRepository().getAllSalesOrdersData(
            token: saveddata['token'].toString(),
            fromdate: event.fromdate,
            todate: event.todate);

        selectedAssembliesDataList = await SalesOrderRepository()
            .generatedAssemblyComponentsRequirements(
                token: saveddata['token'].toString());
      }
      if (event.fromdate != '' &&
          event.todate != '' &&
          allSalesOrdersList.isEmpty) {
        emit(SalesOrderErrorState(
            errorMessage:
                '''No orders found within the range of ${DateFormat('dd-MM-yyyy').format(DateTime.parse(event.fromdate))} to ${DateFormat('dd-MM-yyyy').format(DateTime.parse(event.todate))}.'''));
      } else {
        emit(AllOrdersState(
            allSalesOrdersList: allSalesOrdersList,
            userId: saveddata['data'][0]['id'],
            token: saveddata['token'].toString(),
            selectedAssembliesDataList: selectedAssembliesDataList,
            fromdate: event.fromdate,
            todate: event.todate));
      }
    });

    // Issue stpck for assembly
    on<IssueStockForAsssemblyEvent>((event, emit) async {
      ProductStructureDetailsModel node = ProductStructureDetailsModel();
      // List<Map<String, dynamic>> colorWithDefinitions = [
      //   {'color': Colors.red, 'definition': 'Stock not available.'},
      //   {'color': Colors.orange, 'definition': 'Stock 1% to 49% available.'},
      //   {'color': Colors.yellow, 'definition': 'Stock 50% to 99% available.'},
      //   {'color': Colors.green, 'definition': 'Stock fully available.'},
      //   {'color': Colors.grey, 'definition': 'Required quantity issued.'},
      // ];

      // User data and token
      final saveddata = await UserData.getUserData();

      if (event.selectedProduct != null &&
          event.selectedProduct!.assemblybomId != '') {
        node = await PamRepository().productStructureTreeRepresentation(
            token: saveddata['token'].toString(),
            payload: {
              'id': event.selectedProduct!.childproductId,
              'revision_number': event.selectedProduct!.revisionNumber,
              'quantity': event.selectedProduct!.quantity,
              'parentproduct_id': event.selectedProduct!.parentproductId,
              'sodetails_id': event.selectedProduct!.sodetailsId
            });
      }

      emit(IssueStockForAsssemblyState(
        node: node,
        token: saveddata['token'].toString(),
        userId: saveddata['data'][0]['id'],
        selectedProduct: event.selectedProduct != null
            ? event.selectedProduct!
            : SelectedAssembliesComponentRequirements(),
        // colorWithDefinitions: colorWithDefinitions
        // colorList: colorList,
        // colorDefinitionList: colorDefinitionList
      ));
    });
  }
}
