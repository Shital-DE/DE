import 'dart:io';

abstract class ProgramConverterState {}

class ProgramConverterinitialState extends ProgramConverterState {}

class ProgramConverterLoadingState extends ProgramConverterState {
  final String machinecategoryindex;
  final List<File> convertedfiles;
  final int newProgramlength;
  final int oldProgramlength;

  ProgramConverterLoadingState(
      {required this.machinecategoryindex,
      required this.convertedfiles,
      required this.newProgramlength,
      required this.oldProgramlength});
}

class ProgramConverterErrorState extends ProgramConverterState {
  final String errorMessage;
  ProgramConverterErrorState({required this.errorMessage});
}
