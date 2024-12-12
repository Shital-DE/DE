// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../routes/route_names.dart';
import '../appbar.dart';

class PDFPreviewWidget extends StatelessWidget {
  const PDFPreviewWidget({
    super.key,
    required this.bytes,
  });

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true,
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 3.0,
      child: PdfPreview(
        build: (context) => bytes,
        initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }
}

class CertificateView extends StatelessWidget {
  const CertificateView({
    super.key,
    required this.bytes,
  });

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar().appbar(
          context: context, title: 'Instrument Registry & Calibration Log'),
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: PDFView(
            pdfData: bytes,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            onError: (error) {
              debugPrint(error.toString());
            },
            onPageError: (page, error) {},
            onLinkHandler: (String? uri) {},
          )),
    );
  }
}

class PDFCommon {
  // View pdf which is stored in local storage of the device
  Future<void> viewPDF(
      {required BuildContext context, required String instrumentName}) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/certificate.pdf');
    if (await file.exists()) {
      final Uint8List bytes = file.readAsBytesSync();
      Navigator.pushNamed(context, RouteName.pdf, arguments: {'data': bytes});
    } else {
      debugPrint('File not found');
    }
  }

  // Delete pdf which is stored in local storage of the device
  Future<void> deleteAll({required StreamController<bool> pdf}) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/certificate.pdf');
    if (await file.exists()) {
      await file.delete();
      pdf.add(false);
    }
  }

  // Crop image
  Future<File> cropImage(
      {required XFile pickedFile, required BuildContext context}) async {
    try {
      final imageCropper = ImageCropper();
      CroppedFile? croppedfile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9
        // ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedfile != null) {
        File file = File(croppedfile.path);
        return file;
      } else {
        return File(pickedFile.path);
      }
    } catch (e) {
      return File('');
    }
  }
}
