// Author : Shital Gayakwad
// Created Date : 22 May 2023
// Description : ERPX_PPC -> Production event

part of 'production_bloc.dart';

abstract class ProductionEvent {}

class ProductionInitialEvent extends ProductionEvent {
  final int selectedIndex;
  ProductionInitialEvent({this.selectedIndex = 1});
}
