import 'dart:async';
import 'dart:io';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/responsive.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../bloc/ppc/machine_program_conveter/program_converter_bloc.dart';
import '../../../../bloc/ppc/machine_program_conveter/program_converter_event.dart';
import '../../../../bloc/ppc/machine_program_conveter/program_converter_state.dart';

import '../../../../services/model/product/product.dart';

import 'package:open_file/open_file.dart' as open_file;

// ignore: must_be_immutable
class MachineProgramConverter extends StatelessWidget {
  MachineProgramConverter({super.key});

  List<File> selectedFiles = [];
  List<File> convertedfiles = [];
  List<String> oldprogrampath = [];

  TextEditingController f1tof3 = TextEditingController();
  TextEditingController f1toHF = TextEditingController();
  TextEditingController f1to810 = TextEditingController();

  TextEditingController convertedProgram = TextEditingController();
  TextEditingController oldProgram = TextEditingController();

  String editedText = '';
  int convertedProgramlength = 0, oldProgramlength = 0;

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) {
      //  debugPrint("No file selected");
      return [];
    } else {
      List<File> files = result.files.map((file) => File(file.path!)).toList();
      return files;
    }
  }

  bool checkCenterDrill(String program) {
    List<String> lines = program.split("\n");
    String firstLine = lines.first;
    return firstLine.toLowerCase().contains("drill") ||
        firstLine.toLowerCase().contains("center");
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<ProgramConverterBLoc>(context);
    blocProvider.add(ProgramConverterEvent(
        machinecategoryindex: '',
        convertedfiles: [],
        newProgramlength: 0,
        oldProgramlength: 0));

    List<Machinecatergory> machineFormat = [
      Machinecatergory(id: '1', machinecategory: 'F1-F2'),
      Machinecatergory(id: '2', machinecategory: 'F3-F4'),
      Machinecatergory(id: '3', machinecategory: 'Hartford'),
      Machinecatergory(id: '4', machinecategory: '810'),
    ];
    String categoryone = '', categorytwo = '';
    return Scaffold(
      // appBar: CustomAppbar()
      //     .appbar(context: context, title: 'Machine Program Conveter'),
      body: MakeMeResponsiveScreen(
        horixontaltab: programconverter(
            blocProvider, context, machineFormat, categoryone, categorytwo),
        windows: programconverter(
            blocProvider, context, machineFormat, categoryone, categorytwo),
      ),
    );
  }

  Center programconverter(
      ProgramConverterBLoc blocProvider,
      BuildContext context,
      List<Machinecatergory> machineFormat,
      String categoryone,
      String categorytwo) {
    return Center(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<ProgramConverterBLoc, ProgramConverterState>(
              builder: (context, state) {
                if (state is ProgramConverterLoadingState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height - 210,
                          width: 450,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 209, 223),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Choose Machine Category",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(255, 10, 9, 10)),
                              ),
                              // Container(
                              //     width: 300, height: 50, child: Text("data")),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text(
                                "F1-F2",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(255, 10, 9, 10)),
                              ),
                              SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Transform.rotate(
                                    angle: -90 * 3.14 / 180,
                                    child: Icon(
                                      Icons.compare_arrows,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 30.0,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: DropdownSearch<Machinecatergory>(
                                    items: machineFormat,
                                    itemAsString: (item) =>
                                        item.machinecategory.toString(),
                                    popupProps: const PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          style: TextStyle(fontSize: 16),
                                        )),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                                    labelText:
                                                        "Machine Catergory",
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    15)))),
                                    onChanged: (value) {
                                      convertedfiles = [];
                                      categoryone = value!.id.toString();
                                      // debugPrint(categoryone);
                                      f1tof3.text = '';
                                      f1toHF.text = '';
                                      convertedProgram.text = '';
                                      oldProgram.text = '';
                                      convertedProgramlength = 0;
                                      oldProgramlength = 0;

                                      blocProvider.add(ProgramConverterEvent(
                                          machinecategoryindex: categoryone,
                                          convertedfiles: [],
                                          newProgramlength: 0,
                                          oldProgramlength: 0));
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    f1tof3.text = '';
                                    f1toHF.text = '';
                                    convertedProgram.text = '';
                                    oldProgram.text = '';
                                    convertedProgramlength = 0;
                                    oldProgramlength = 0;
                                    switch (
                                        int.parse(state.machinecategoryindex)) {
                                      case 2:
                                        {
                                          List<File> pickedFiles = [];
                                          convertedfiles = [];
                                          oldprogrampath = [];
                                          pickedFiles = await _pickFiles();

                                          for (int i = 0;
                                              i < pickedFiles.length;
                                              i++) {
                                            String program =
                                                await pickedFiles[i]
                                                    .readAsString();
                                            String oldfilePath =
                                                pickedFiles[i].path;
                                            oldprogrampath.add(oldfilePath);
                                            // debugPrint(
                                            //     'File Name: ${path.basename(pickedFiles[i].path)}');
                                            f1tof3.text = program.trim();
                                            String siemensProgram =
                                                translateF1ToF3(f1tof3.text);
                                            Directory appDir =
                                                await getApplicationDocumentsDirectory();
                                            String filePath =
                                                "${appDir.path}${"/F3-F4"}${"/Fanuc"}/${path.basename(pickedFiles[i].path)}";

                                            File file = File(filePath);
                                            file.writeAsString(
                                                siemensProgram.trim());
                                            convertedfiles.add(file);
                                          }
                                          blocProvider.add(
                                              ProgramConverterEvent(
                                                  machinecategoryindex:
                                                      categoryone,
                                                  convertedfiles:
                                                      convertedfiles,
                                                  newProgramlength: 0,
                                                  oldProgramlength: 0));
                                        }
                                        break;
                                      case 3:
                                        {
                                          List<File> pickedFiles = [];
                                          convertedfiles = [];
                                          oldprogrampath = [];
                                          f1to810.text = '';

                                          pickedFiles = await _pickFiles();
                                          for (int i = 0;
                                              i < pickedFiles.length;
                                              i++) {
                                            String program =
                                                await pickedFiles[i]
                                                    .readAsString();

                                            String oldfilePath =
                                                pickedFiles[i].path;
                                            oldprogrampath.add(oldfilePath);
                                            // debugPrint(
                                            //     'File Name: ${path.basename(pickedFiles[i].path)}');

                                            f1toHF.text = program.trim();
                                            String siemensProgram =
                                                translateF1ToHF(f1toHF.text);
                                            Directory appDir =
                                                await getApplicationDocumentsDirectory();

                                            String fileName = path
                                                .basename(pickedFiles[i].path);
                                            if (fileName.startsWith('O')) {
                                              fileName = fileName.substring(1);
                                            }

                                            String filePath =
                                                "${appDir.path}${"/Hartford"}/$fileName";

                                            File file = File(filePath);
                                            file.writeAsString(
                                                siemensProgram.trim());
                                            convertedfiles.add(file);

                                            // String program1334 = await file.readAsString();
                                            // debugPrint(program1334.toString());
                                          }
                                          blocProvider.add(
                                              ProgramConverterEvent(
                                                  machinecategoryindex:
                                                      categoryone,
                                                  convertedfiles:
                                                      convertedfiles,
                                                  newProgramlength: 0,
                                                  oldProgramlength: 0));
                                        }
                                        break;
                                      case 4:
                                        {
                                          List<File> pickedFiles = [];
                                          convertedfiles = [];
                                          oldprogrampath = [];
                                          f1to810.text = '';

                                          pickedFiles = await _pickFiles();

                                          for (int i = 0;
                                              i < pickedFiles.length;
                                              i++) {
                                            String pprogram =
                                                await pickedFiles[i]
                                                    .readAsString();

                                            String oldfilePath =
                                                pickedFiles[i].path;

                                            oldprogrampath.add(oldfilePath);

                                            f1to810.text = pprogram.trim();

                                            bool containsCenterDrill =
                                                checkCenterDrill(f1to810.text);

                                            if (containsCenterDrill) {
                                              String centredrillprogram =
                                                  translateF1To810CenterDrill(
                                                      f1to810.text);

                                              Directory appDir =
                                                  await getApplicationDocumentsDirectory();

                                              String fileName = path.basename(
                                                  pickedFiles[i].path);

                                              String filePath =
                                                  "${appDir.path}${"/810"}/$fileName.MPF";

                                              File file = File(filePath);
                                              file.writeAsString(
                                                  centredrillprogram.trim());
                                              convertedfiles.add(file);

                                              blocProvider.add(
                                                  ProgramConverterEvent(
                                                      machinecategoryindex:
                                                          categoryone,
                                                      convertedfiles:
                                                          convertedfiles,
                                                      newProgramlength: 0,
                                                      oldProgramlength: 0));
                                            } else {
                                              String otherprogram =
                                                  translateF1To810OtherProgram(
                                                      f1to810.text);

                                              Directory appDir =
                                                  await getApplicationDocumentsDirectory();

                                              String fileName = path.basename(
                                                  pickedFiles[i].path);

                                              String filePath =
                                                  "${appDir.path}${"/810"}/$fileName.MPF";

                                              File file = File(filePath);

                                              file.writeAsString(
                                                  otherprogram.trim());
                                              convertedfiles.add(file);

                                              blocProvider.add(
                                                  ProgramConverterEvent(
                                                      machinecategoryindex:
                                                          categoryone,
                                                      convertedfiles:
                                                          convertedfiles,
                                                      newProgramlength: 0,
                                                      oldProgramlength: 0));
                                            }
                                          }
                                        }
                                        break;

                                      default:
                                        {
                                          QuickFixUi.errorMessage(
                                              "please select proper machine category",
                                              context);
                                        }
                                    }
                                  },
                                  child: const Text("Pick files"),
                                ),
                              ),

                              const SizedBox(
                                height: 23,
                              ),
                              state.convertedfiles.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                546,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListView.builder(
                                          itemCount:
                                              state.convertedfiles.length,
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text(
                                              path.basename(state
                                                  .convertedfiles[index].path),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 159, 218, 203),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    open_file.OpenFile.open(
                                                        oldprogrampath[index]);
                                                  },
                                                  child: const Text("Old"),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 159, 218, 203),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    open_file.OpenFile.open(
                                                        state
                                                            .convertedfiles[
                                                                index]
                                                            .path);
                                                  },
                                                  child: const Text("New"),
                                                ),
                                                const SizedBox(
                                                  width: 21,
                                                ),
                                                /* IconButton(
                                                  onPressed: () async {
                                                    convertedProgram.text = '';
                                                    oldProgram.text = '';
                                                    convertedProgramlength = 0;
                                                    oldProgramlength = 0;
                                                    debugPrint(state
                                                        .convertedfiles[index]
                                                        .path
                                                        .toString());

                                                    convertedProgram.text =
                                                        await state
                                                            .convertedfiles[
                                                                index]
                                                            .readAsString();

                                                    // List<String> newlines =
                                                    //     convertedProgram.text
                                                    //         .split('\n');

                                                    // convertedProgramlength =
                                                    //     newlines.length;
                                                    List<String> liness =
                                                        await state
                                                            .convertedfiles[
                                                                index]
                                                            .readAsLines();
                                                    convertedProgramlength =
                                                        liness.length;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    File oldfilepath = File(
                                                        oldprogrampath[index]);
                                                    // debugPrint(
                                                    //     "old file path:----> ${oldfilepath.path}");
                                                    String oldp =
                                                        await oldfilepath
                                                            .readAsString();
                                                    oldProgram.text =
                                                        oldp.toString().trim();

                                                    List<String> lines =
                                                        await oldfilepath
                                                            .readAsLines();
                                                    oldProgramlength =
                                                        lines.length;

                                                    // List<String> oldlines =
                                                    //     oldProgram.text
                                                    //         .split('\n');

                                                    // oldProgramlength =
                                                    //     oldlines.length;

                                                    open_file.OpenFile.open(
                                                        oldprogrampath[index]);

                                                    blocProvider.add(
                                                        ProgramConverterEvent(
                                                            machinecategoryindex:
                                                                categoryone,
                                                            convertedfiles:
                                                                convertedfiles,
                                                            newProgramlength:
                                                                convertedProgramlength,
                                                            oldProgramlength:
                                                                oldProgramlength));
                                                  },
                                                  icon: const Icon(
                                                      Icons.visibility),
                                                  color: Colors.blue,
                                                ),*/
                                                IconButton(
                                                  onPressed: () async {
                                                    File file = state
                                                        .convertedfiles[index];
                                                    await file.delete();
                                                    state.convertedfiles
                                                        .removeAt(index);
                                                    oldprogrampath
                                                        .removeAt(index);
                                                    convertedProgram.text = '';
                                                    oldProgram.text = '';
                                                    convertedProgramlength = 0;
                                                    oldProgramlength = 0;
                                                    blocProvider.add(
                                                        ProgramConverterEvent(
                                                            machinecategoryindex:
                                                                categoryone,
                                                            convertedfiles:
                                                                convertedfiles,
                                                            newProgramlength: 0,
                                                            oldProgramlength:
                                                                0));
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Text("NO files selected")
                            ],
                          )),
                    ),
                  );
                } else {
                  return const Stack();
                }
              },
            ),
            BlocBuilder<ProgramConverterBLoc, ProgramConverterState>(
              builder: (context, state) {
                if (state is ProgramConverterLoadingState) {
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: state.newProgramlength != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "Old program length: ${state.oldProgramlength}",
                                      ),
                                    ),
                                    Container(
                                      height: //400
                                          MediaQuery.of(context).size.height -
                                              (Platform.isAndroid ? 175 : 200),
                                      width: 550,
                                      // MediaQuery.of(context).size.width - 620,
                                      color: const Color.fromARGB(
                                          255, 204, 227, 228),
                                      child: SingleChildScrollView(
                                        child: TextField(
                                          controller: oldProgram,
                                          maxLines:
                                              null, // Allows unlimited lines
                                          // readOnly: true, // Makes the text field read-only
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          // onChanged: (value) {
                                          //   editedText = value;
                                          // },
                                          // onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 23,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "New program length: ${state.newProgramlength}",
                                      ),
                                    ),
                                    Container(
                                      height: //400
                                          MediaQuery.of(context).size.height -
                                              (Platform.isAndroid ? 175 : 200),
                                      width: 550,
                                      // MediaQuery.of(context).size.width - 620,
                                      color: const Color.fromARGB(
                                          255, 211, 232, 233),
                                      child: SingleChildScrollView(
                                        child: TextField(
                                          controller: convertedProgram,
                                          maxLines:
                                              null, // Allows unlimited lines
                                          // readOnly: true, // Makes the text field read-only
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          // onChanged: (value) {
                                          //   editedText = value;
                                          // },
                                          // onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container()
                      //  ),
                      );
                } else {
                  return const Stack();
                }
              },
            ),
          ],
        )
      ]),
    );
  }

  String translateF1ToF3(String program16iM) {
    // String translateTo31iB(String program16iM) {
    // Split the 16i M program into individual lines
    List<String> lines16iM = program16iM.split('\n');
    // Translated program for 31i Model B
    String programofF3 = '';

    // Loop through each line of the 16i M program
    for (String line in lines16iM) {
      // Trim leading and trailing whitespaces
      line = line.trim();
      // Check the line type and convert accordingly
      if (line.startsWith('O') ||
          line.startsWith('M99') ||
          line.startsWith('%')) {
        // O, M99, and % codes remain the same in 31i Model B
        programofF3 += '$line\n';
      } else if (line.startsWith('G00')) {
        // Convert G00 rapid positioning
        programofF3 += '$line\n';
      } else if (line.startsWith('G01')) {
        // Convert G01 linear interpolation
        programofF3 += '$line\n';
      } else if (!line.startsWith('G08') && !line.startsWith('G05')) {
        // Exclude lines starting with G08 and G05
        programofF3 += '$line\n';
      }
    }
    return programofF3;
  }

  String translateF1To810CenterDrill(String program16iM) {
    List<String> lines16iM = program16iM.split('\n');
    String programof810 = "G0 Z100.\nG291\n;(";
    for (String line in lines16iM) {
      line = line.trim();
      programof810 += '$line\n';
    }
    return programof810;
  }

  String translateF1To810OtherProgram(String program16iM) {
    List<String> lines16iM = program16iM.split('\n');
    String programof810Other = "G0 Z100.\n;(";

    for (String line in lines16iM) {
      line = line.trim();
      if (!line.startsWith('G08') && !line.startsWith('G05')) {
        // Exclude lines starting with G08 and G05
        programof810Other += '$line\n';
      }
    }
    // Replace M99 with M30
    programof810Other = programof810Other.replaceAll('M99', 'M30');
    return programof810Other;
  }

  String translateF1ToHF(String program16iM) {
    // Split the 16i M program into individual lines
    List<String> lines16iM = program16iM.split('\n');
    // Translated program for Hartford Mitsubishi
    String hartfordMitsubishiProgram = '(';
    // Loop through each line of the 16i M program
    for (String line in lines16iM) {
      // Trim leading and trailing whitespaces
      line = line.trim();
      hartfordMitsubishiProgram += '$line\n';

      // Check the line type and convert accordingly
      /*if (line.startsWith('O') ||
          line.startsWith('M99') ||
          line.startsWith('%')) {
        // O, M99, and % codes remain the same in Hartford Mitsubishi
        hartfordMitsubishiProgram += '$line\n';
      }*/
      // else if (line.startsWith('G00')) {
      //   // Convert G00 rapid positioning
      //   hartfordMitsubishiProgram += '${line.replaceFirst('G00', 'G00')}\n';
      // }
      /* else if (line.startsWith('G')) {
        // Convert G01 linear interpolation
        hartfordMitsubishiProgram += '$line\n';
      }*/
      // else if (line.startsWith('G08') || line.startsWith('G05')) {
      //   // continue;
      //   hartfordMitsubishiProgram += '$line\n';
      // }
      /*  else if (line.startsWith('Z') ||
          line.startsWith('X') ||
          line.startsWith('Y')) {
        // Convert Z, X, and Y movements
        hartfordMitsubishiProgram += '$line\n';
      }*/
    }
    return hartfordMitsubishiProgram;
  }
}
