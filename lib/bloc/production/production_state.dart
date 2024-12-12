// Author : Shital Gayakwad
// Created Date : 22 May 2023
// Description : ERPX_PPC -> Production state

part of 'production_bloc.dart';

abstract class ProductionState {}

class ProductionInitial extends ProductionState {}

class ProductionLoadingState extends ProductionState {
  final int selectedIndex;
  ProductionLoadingState({required this.selectedIndex});
}

class ProductionErrorState extends ProductionState {
  final String errorMessage;
  ProductionErrorState({required this.errorMessage});
}
