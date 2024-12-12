import 'package:flutter/material.dart';
import '../app_colors.dart';

class QuickFixUi {
  // TextFild Circular
  static OutlineInputBorder makeTextFieldCircular() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    );
  }

// Error snack bar
  static void errorMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.redTheme,
        content: Text(message),
      ),
    );
  }

//Success snack bar
  static void successMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.greenTheme,
        content: Text(message),
      ),
    );
  }

// Scrren visiblity message
  static Scaffold notVisible() {
    return const Scaffold(
      body: Center(
        child: Text(
          'This screen not visible on this platform',
        ),
      ),
    );
  }

// Common dialog for message only
  Future<dynamic> showCustomDialog(
      {required BuildContext context, required String errorMessage}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            errorMessage,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          )),
          actions: [
            Center(
              child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            )
          ],
        );
      },
    );
  }

// Navigation button Text
  static Widget buttonText(String buttonName) {
    return Text(
      buttonName,
      style: const TextStyle(color: Colors.white),
    );
  }

  //Space between widgets
  //Horizontal
  static Widget horizontalSpace({required double width}) {
    return SizedBox(
      width: width,
    );
  }

// Vertical
  static Widget verticalSpace({required double height}) {
    return SizedBox(
      height: height,
    );
  }

  Future<DateTime?> dateTimePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(5000));
    return pickedDate;
  }

  BoxDecoration borderContainer(
      {required double borderThickness, double radius = 5}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(width: borderThickness));
  }

  Future<void> readTextFile(
      {required BuildContext context,
      required String content,
      required String filename}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(filename,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17)),
          content: Center(
              child: Scrollbar(
            child: SingleChildScrollView(
              child: Text(
                content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )),
          actions: [
            Center(
              child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> showProcessing({required BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: SizedBox(
                width: 100,
                height: 140,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 5.0,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Go back',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    )
                  ],
                ),
              ))),
        );
      },
    );
  }
}
