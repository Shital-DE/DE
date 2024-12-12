// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/session/user_login.dart';
import 'common_mails_event.dart';
import 'common_mails_state.dart';

class CommonMailsBloc extends Bloc<CommonMailEvent, CommonMailState> {
  CommonMailsBloc(BuildContext context) : super(CommonMailInitialState()) {
    // Upload purchase orders
    on<BulkmailsendEvent>((event, emit) async {
      //  final userDataAndToken = await LoginSession.getUserData();
      final userDataAndToken = await UserData.getUserData();
      emit(UploadOrderState(
          excelData: event.excelData.isNotEmpty ? event.excelData : [],
          token: userDataAndToken['token'],
          userId: userDataAndToken['data'][0]['id'],
          rejectedOrders: event.rejectedOrders));
    });

    // // View all orders
    // on<OtherEvent>((event, emit) async {
    //   final userDataAndToken = await UserData.getUserData();
    //   List<MaterialinwardList> allInstrumentsList = [];
    //   allInstrumentsList = await Rawmaterialinward.rawmaterialinwardlist(
    //       token: userDataAndToken['token'],
    //       // context: context,
    //       fromdate: '',
    //       todate: '',
    //       range: event.range,
    //       searchString: event.searchString);
    //   // debugPrint(allInstrumentsList.toList().toString());

    //   emit(OthersState(
    //     // poId: event.poId,
    //     token: userDataAndToken['token'], userId: '',
    //     materialinwardlist: allInstrumentsList,
    //     index: event.index,
    //     searchString: event.searchString,
    //     range: event.range,
    //     // userId: userDataAndToken['data'][0]['id'],
    //     // reservedStock: reservedStock
    //   ));
    // });

    // Stock Check
    // on<StockCheckEvent>((event, emit) async {
    //   final userDataAndToken = await UserData.getUserData();
    //   // To be produce products
    //   List<ToBeProduceProducts> tobeProduceProducts =
    //       await SalesOrderRepository()
    //           .tobeProduceProducts(token: userDataAndToken['token']);
    //   emit(StockCheckState(
    //       tobeProduceProducts: tobeProduceProducts,
    //       token: userDataAndToken['token'],
    //       selectedProductsToIssue: event.selectedProductsToIssue,
    //       userId: userDataAndToken['data'][0]['id'],
    //       issuedProducts: event.issuedProducts));
    // });
  }
}
