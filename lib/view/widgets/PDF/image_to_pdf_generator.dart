// ignore_for_file: use_build_context_synchronously, must_be_immutable, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
// import 'package:de_opc/utils/common/quickfix_widget.dart';
// import 'package:de_opc/view/widgets/PDF/pdf.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

import '../../../utils/common/quickfix_widget.dart';
import 'pdf.dart';

class ImageToPDFGenerator extends StatelessWidget {
  final VoidCallback? onFilePicked;
  const ImageToPDFGenerator({super.key, this.onFilePicked});

  @override
  Widget build(BuildContext context) {
    StreamController<bool> pdfPath = StreamController<bool>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          pdfPath.add(false);
          PDFCommon().deleteAll(pdf: pdfPath);
          return;
        }
      },
      child: StreamBuilder<bool>(
          stream: pdfPath.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data == true) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        PDFCommon().viewPDF(
                            context: context, instrumentName: 'Certificate');
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Theme.of(context).colorScheme.error,
                      )),
                  IconButton(
                      onPressed: () {
                        if (onFilePicked != null) {
                          onFilePicked!();
                        }
                        pdfPath.add(false);
                        PDFCommon().deleteAll(pdf: pdfPath);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      )),
                ],
              );
            } else {
              return IconButton(
                onPressed: () async {
                  if (Platform.isAndroid) {
                    try {
                      final ImagePicker picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        File croppedfile = await PDFCommon().cropImage(
                            pickedFile: pickedFile, context: context);
                        if (croppedfile.path.toString() != '') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PDFGenerator(
                                        pdfPath: pdfPath,
                                        initialImage: croppedfile,
                                        onFilePicked: onFilePicked,
                                      )));
                        }
                      }
                    } catch (e) {
                      //
                    }
                  } else {
                    QuickFixUi.errorMessage(
                        'You will upload certificate on android device only.',
                        context);
                  }
                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }),
    );
  }
}

class PDFGenerator extends StatefulWidget {
  final File initialImage;
  final StreamController<bool> pdfPath;
  final VoidCallback? onFilePicked;
  const PDFGenerator(
      {Key? key,
      required this.initialImage,
      required this.pdfPath,
      this.onFilePicked})
      : super(key: key);

  @override
  PDFGeneratorState createState() => PDFGeneratorState();
}

class PDFGeneratorState extends State<PDFGenerator> {
  late StreamController<List<File>> pdfData;
  List<File> fileList = [];
  double rotationAngle = 0.0;
  bool isClockwiseRotation = true;

  void toggleRotationDirection() {
    setState(() {
      isClockwiseRotation = !isClockwiseRotation;
    });
  }

  @override
  void initState() {
    super.initState();
    pdfData = StreamController<List<File>>.broadcast();
    fileList.add(widget.initialImage);
    pdfData.add(fileList);
  }

  @override
  void dispose() {
    pdfData.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    StreamController<File> selectedFile = StreamController<File>.broadcast();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: const Text(
          'Image to PDF Generator',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (pickedFile != null) {
                File croppedFile = await PDFCommon().cropImage(
                  pickedFile: pickedFile,
                  context: context,
                );
                selectedFile.add(croppedFile);
                fileList.add(croppedFile);
                pdfData.add(fileList);
              }
            },
            icon: Icon(
              Icons.add_a_photo,
              color: Theme.of(context).primaryColor,
            ),
          ),
          StreamBuilder<List<File>>(
              stream: pdfData.stream,
              builder: (context, newSnap) {
                return StreamBuilder<File>(
                    stream: selectedFile.stream,
                    builder: (context, snapshot) {
                      return IconButton(
                        onPressed: () async {
                          double angle = isClockwiseRotation ? 90.0 : -90.0;
                          if (snapshot.data != null && newSnap.data != null) {
                            img.Image image = img.decodeImage(
                                await snapshot.data!.readAsBytes())!;
                            image = img.copyRotate(image, angle: angle.toInt());
                            File rotatedFile =
                                File('${snapshot.data!.path}$angle');
                            await rotatedFile
                                .writeAsBytes(img.encodeJpg(image));
                            int index = newSnap.data!.indexOf(snapshot.data!);
                            if (index != -1) {
                              newSnap.data!.removeAt(index);
                              newSnap.data!.insert(index, rotatedFile);
                              pdfData.add(newSnap.data!);
                              selectedFile.add(rotatedFile);
                            }
                          } else {
                            img.Image image = img.decodeImage(
                                await fileList.last.readAsBytes())!;
                            image = img.copyRotate(image, angle: angle.toInt());
                            File rotatedFile =
                                File('${fileList.last.path}$angle');
                            await rotatedFile
                                .writeAsBytes(img.encodeJpg(image));
                            fileList.removeLast();
                            fileList.add(rotatedFile);
                            pdfData.add(fileList);
                          }
                        },
                        icon: Icon(
                          isClockwiseRotation
                              ? Icons.rotate_right
                              : Icons.rotate_left,
                        ),
                      );
                    });
              }),
          StreamBuilder<List<File>>(
              stream: pdfData.stream,
              builder: (context, snapshot) {
                return StreamBuilder<File>(
                    stream: selectedFile.stream,
                    builder: (context, selectedSnapshot) {
                      return IconButton(
                        onPressed: () async {
                          if (fileList.isNotEmpty) {
                            if (fileList.length == 1) {
                              fileList = [];
                              pdfData.add(fileList);
                              widget.pdfPath.add(false);
                              Navigator.of(context).pop();
                            } else {
                              fileList.remove(selectedSnapshot.data);
                              selectedFile.add(File(''));
                              pdfData.add(fileList);
                            }
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      );
                    });
              }),
          FilledButton(
            onPressed: () {
              saveAsPDF(context: context, scannedImages: fileList);
            },
            child: const Text('Save'),
          ),
          QuickFixUi.horizontalSpace(width: 10)
        ],
      ),
      body: pdfGeneratorUI(size: size, selectedFile: selectedFile),
    );
  }

  Center pdfGeneratorUI(
      {required Size size, required StreamController<File> selectedFile}) {
    try {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 210,
              height: size.height,
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: StreamBuilder<List<File>>(
                stream: pdfData.stream,
                builder: (context, snapshot) {
                  return ListView(
                    children: snapshot.data != null
                        ? snapshot.data!
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  selectedFile.add(e);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.file(e),
                                ),
                              ),
                            )
                            .toList()
                        : [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.file(File(fileList.last.path)),
                            ),
                          ],
                  );
                },
              ),
            ),
            Container(
              width: size.width - 250,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: StreamBuilder<File>(
                stream: selectedFile.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data!.path != '') {
                    return viewImageFile(
                      file: File(snapshot.data!.path),
                      rotationAngle: rotationAngle,
                      isClockwiseRotation: isClockwiseRotation,
                    );
                  } else {
                    return StreamBuilder<List<File>>(
                        stream: pdfData.stream,
                        builder: (context, newSnap) {
                          if (newSnap.data != null &&
                              newSnap.data!.isNotEmpty) {
                            return viewImageFile(
                              file: File(newSnap.data!.last.path),
                              rotationAngle: rotationAngle,
                              isClockwiseRotation: isClockwiseRotation,
                            );
                          } else {
                            if (fileList.isNotEmpty) {
                              return viewImageFile(
                                file: File(fileList.last.path),
                                rotationAngle: rotationAngle,
                                isClockwiseRotation: isClockwiseRotation,
                              );
                            } else {
                              return const Center(
                                child: Text('File not found.'),
                              );
                            }
                          }
                        });
                  }
                },
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const Center();
    }
  }

  Widget viewImageFile({
    required File file,
    required double rotationAngle,
    required bool isClockwiseRotation,
  }) {
    return InteractiveViewer(
      panEnabled: true,
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 3.0,
      child: Image.file(file),
    );
  }

  Future<void> saveAsPDF(
      {required List<File> scannedImages,
      required BuildContext context}) async {
    try {
      final pdf = pw.Document();

      for (var scannedImage in scannedImages) {
        final Uint8List bytes = scannedImage.readAsBytesSync();
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Image(pw.MemoryImage(bytes));
            },
          ),
        );
      }

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final File file = File('$path/certificate.pdf');
      await file.writeAsBytes(await pdf.save());
      widget.pdfPath.add(true);
      if (widget.onFilePicked != null) {
        widget.onFilePicked!();
      }
      Navigator.of(context).pop();
    } catch (e) {
      //
    }
  }
}
