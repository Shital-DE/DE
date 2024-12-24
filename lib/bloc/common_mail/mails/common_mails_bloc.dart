// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/session/user_login.dart';
import 'common_mails_event.dart';
import 'common_mails_state.dart';

class CommonMailsBloc extends Bloc<CommonMailEvent, CommonMailState> {
  CommonMailsBloc(BuildContext context) : super(CommonMailInitialState()) {
    on<BulkmailsendEvent>((event, emit) async {
      final userDataAndToken = await UserData.getUserData();
      emit(UploadOrderState(
          excelData: event.excelData.isNotEmpty ? event.excelData : [],
          token: userDataAndToken['token'],
          userId: userDataAndToken['data'][0]['id'],
          rejectedOrders: event.rejectedOrders));
    });
  }
}
