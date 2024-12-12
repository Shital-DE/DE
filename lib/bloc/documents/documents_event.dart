// Author : Shital Gayakwad
// Created Date : 23 April 2023
// Description : ERPX_PPC -> Document event

abstract class DocumentsEvent {}

class DocumentData extends DocumentsEvent {
  final String productid;
  DocumentData({required this.productid});
}
