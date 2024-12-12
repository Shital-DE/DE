import 'dart:io';

abstract class ProgramConverter {}

class ProgramConverterEvent extends ProgramConverter {
  final String machinecategoryindex;
  final List<File> convertedfiles;
  final int newProgramlength;
   final int oldProgramlength;
  ProgramConverterEvent({
    required this.machinecategoryindex,
    required this.convertedfiles,
    required this.newProgramlength,
    required this.oldProgramlength
  });
}

class ProgramConverterInitialEvent extends ProgramConverter {
  ProgramConverterInitialEvent();
}
