// Author : Shital Gayakwad
// Created Date : 23 April 2023
// Description : ERPX_PPC ->Document bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/model/common/document_model.dart';
import '../../services/model/product/product.dart';
import '../../services/repository/common/documents_repository.dart';
import '../../services/repository/product/product_repository.dart';
import '../../services/session/user_login.dart';
import 'documents_event.dart';
import 'documents_state.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc() : super(DocumentsInitialState()) {
    on<DocumentData>((event, emit) async {
      //User data
      final saveddata = await UserData.getUserData();

      //Token
      String token = saveddata['token'].toString();

      final allProductData =
          await ProductRepository().allProductList(token: token);

      final docData = await DocumentsRepository()
          .mergedDocData(id: event.productid.toString(), token: token);

      if (allProductData.toString() == 'Server unreachable' ||
          docData.toString() == 'Server unreachable') {
        emit(DocumentsError('Server unreachable'));
      } else {
        List<AllProductModel> allprodocutsList = allProductData;
        List<MergedDocumentsData> documentData = docData;
        emit(DocumentsLoadingState(
            allprodocutsList, documentData, token, event.productid));
      }
    });
  }
}
