// Author : Shital Gayakwad
// Created Date : 23 April 2023
// Description : ERPX_PPC -> Document state

import '../../services/model/common/document_model.dart';
import '../../services/model/product/product.dart';

abstract class DocumentsState {}

class DocumentsInitialState extends DocumentsState {
  DocumentsInitialState();
}

class DocumentsLoadingState extends DocumentsState {
  final List<AllProductModel> allprodocutsList;
  final List<MergedDocumentsData> documentData;
  final String token, productid;
  DocumentsLoadingState(
      this.allprodocutsList, this.documentData, this.token, this.productid);
}

class DocumentsError extends DocumentsState {
  final String errorMessage;
  DocumentsError(this.errorMessage);
}
