// Author : Shital Gayakwad
// Created Date :  March 2023
// Description : ERPX_PPC -> Responsive UI
// Modified date : 21 May 2023

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MakeMeResponsiveScreen extends StatelessWidget {
  final Widget mobile, verticaltab, horixontaltab, windows, linux;
  const MakeMeResponsiveScreen(
      {super.key,
      this.horixontaltab = const Scaffold(
        body: Center(
          child: Text('This screen is not visible on this platform'),
        ),
      ),
      this.verticaltab = const Scaffold(
        body: Center(
          child: Text('This screen is not visible on this platform'),
        ),
      ),
      this.windows = const Scaffold(
        body: Center(
          child: Text('This screen is not visible on this platform'),
        ),
      ),
      this.linux = const Scaffold(
        body: Center(
          child: Text('This screen is not visible on this platform'),
        ),
      ),
      this.mobile = const Scaffold(
        body: Center(
          child: Text('This screen is not visible on this platform'),
        ),
      )});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isAndroid) {
        if (screenWidth < 650 && screenHeight >= 500) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp,
          ]);
          return mobile;
        } else if (screenWidth > 1200) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          if (screenWidth >= 1200 && screenHeight >= 600) {
            return horixontaltab;
          } else {
            return const Scaffold(
                body: Center(
                    child: Text(
                        'Resize window is not allowed for this application')));
          }
        } else {
          return const Scaffold(
              body:
                  Center(child: Text('Not visible in this type of platform')));
        }
      } else if (Platform.isWindows) {
        if (screenWidth >= 1280 && screenHeight >= 600) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          return windows;
        } else {
          return const Scaffold(
            body: Center(
                child:
                    Text('Resize window is not allowed for this application')),
          );
        }
      } else if (Platform.isLinux) {
        if (screenWidth >= 1280 && screenHeight >= 600) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          return linux;
        } else {
          return const Center(
              child: Text('Resize window is not allowed for this application'));
        }
      } else {
        return const Center(
            child: Text('Not visible in this type of platform'));
      }
    });
  }
}
