// Author : Shital Gayakwad
// Created Date : 22 May 2023
// Description : ERPX_PPC -> Production bloc

import 'package:bloc/bloc.dart';
part 'production_event.dart';
part 'production_state.dart';

class ProductionBloc extends Bloc<ProductionEvent, ProductionState> {
  ProductionBloc() : super(ProductionInitial()) {
    on<ProductionInitialEvent>((event, emit) {
      emit(ProductionLoadingState(selectedIndex: event.selectedIndex));
    });
  }
}
