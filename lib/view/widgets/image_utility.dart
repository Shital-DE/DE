// Author : Shital Gayakwad
// Description : Image crop
// Created Date : 25 August 2024

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageUtility {
  // Image crop
  Future cropImage(
      {required XFile pickedFile, required BuildContext context}) async {
    try {
      final imageCropper = ImageCropper();

      CroppedFile? croppedfile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Theme.of(context).colorScheme.inversePrimary,
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
      }
    } catch (e) {
      return File(pickedFile.path);
    }
  }

// Image Compress
  Future<dynamic> imageCompresser({required File profile}) async {
    dynamic cmpressedImage;
    try {
      cmpressedImage = await FlutterImageCompress.compressWithFile(profile.path,
          format: CompressFormat.jpeg, quality: 70);
    } catch (e) {
      cmpressedImage = profile;
    }
    return cmpressedImage;
  }
}
