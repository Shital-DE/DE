import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'program_converter_event.dart';
import 'program_converter_state.dart';

class ProgramConverterBLoc
    extends Bloc<ProgramConverter, ProgramConverterState> {
  final BuildContext context;

  ProgramConverterBLoc(this.context) : super(ProgramConverterinitialState()) {
    on<ProgramConverterEvent>((event, emit) async {
      emit(ProgramConverterLoadingState(
        machinecategoryindex: event.machinecategoryindex,
        convertedfiles: event.convertedfiles,
        newProgramlength: event.newProgramlength,
        oldProgramlength: event.oldProgramlength,
      ));
    });

    on<ProgramConverterInitialEvent>((event, emit) async {
      emit(ProgramConverterinitialState());
    });
  }
}
