// Author : Shital Gayakwad
// Created Date : 22 Feb 2023
// Description : ERPX_PPC ->Custom table bloc

import 'package:flutter_bloc/flutter_bloc.dart';

//Events
abstract class AppTableEvent {}

class AppTableScrollDirectionEvent extends AppTableEvent {
  final List<int> selectedRowList;
  AppTableScrollDirectionEvent(this.selectedRowList);
}

//States
abstract class AppTableState {}

class AppTableInitialState extends AppTableState {
  AppTableInitialState();
}

class AppTableScrollDirectionState extends AppTableState {
  final List<int> selectedRowList;
  AppTableScrollDirectionState(this.selectedRowList);
}

//Bloc
class AppTableBloc extends Bloc<AppTableEvent, AppTableState> {
  AppTableBloc() : super(AppTableInitialState()) {
    on<AppTableScrollDirectionEvent>((event, emit) {
      emit(AppTableScrollDirectionState(event.selectedRowList));
    });
  }
}
