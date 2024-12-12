import 'package:flutter_bloc/flutter_bloc.dart';

// DropDown Month
//Event
abstract class MonthDropDownEvent {}

class MonthDropDownInitialEvent extends MonthDropDownEvent {
  final Map<String, dynamic> monthSelection;
  final Map<String, dynamic> yearSelection;
  MonthDropDownInitialEvent(this.monthSelection, this.yearSelection);
}

//State

abstract class MonthDropDownState {}

class MonthDropDownInitialState extends MonthDropDownState {
  MonthDropDownInitialState();
}

class MonthDropDownLoading extends MonthDropDownState {
  final Map<String, dynamic> monthSelection;
  final Map<String, dynamic> yearSelection;
  MonthDropDownLoading(this.monthSelection, this.yearSelection);
}

//Bloc
class MonthDropDownBloc extends Bloc<MonthDropDownEvent, MonthDropDownState> {
  MonthDropDownBloc() : super(MonthDropDownInitialState()) {
    on<MonthDropDownInitialEvent>((event, emit) async {
      emit(MonthDropDownLoading(event.monthSelection, event.yearSelection));
    });
  }
}
