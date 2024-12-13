// import 'package:de_opc/utils/app_colors.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static TextStyle loginHeaderTextStyle() {
    return GoogleFonts.mitr(
        textStyle: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w700,
            color: AppColors.appTheme));
  }

  //App Logo
  static TextStyle appLogoFont = GoogleFonts.kavoon(
      fontWeight: FontWeight.w100, fontSize: 100, color: AppColors.appTheme);

  AppTheme._();
  static ThemeData appThemeData = ThemeData(
      primarySwatch: AppColors.primarySwatchColor,
      primaryColor: Colors.white,
      canvasColor: AppColors.canvasColor);

  static TextStyle mobileTextStyle({FontWeight? fontWeight, Color? color}) {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white));
  }

  static TextStyle tabTextStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white));
  }

  static TextStyle tableHeaderTextStyle() {
    return GoogleFonts.nunitoSans(
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black));
  }

  static TextStyle tableRowTextStyle({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.nunitoSans(
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black));
  }

  static ButtonStyle roundedButtonStyle() {
    return ElevatedButton.styleFrom(
        textStyle: GoogleFonts.roboto(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
  }

  static TextStyle tabTextStyleBold() {
    return GoogleFonts.poppins(
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white));
  }

  static TextStyle tabTextStyleNormal() {
    return GoogleFonts.poppins(
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white));
  }

  static TextStyle tabSubTextStyle() {
    return GoogleFonts.nunitoSans(
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black));
  }

  static TextStyle labelTextStyle({bool isFontBold = false}) {
    return TextStyle(
        fontSize: Platform.isAndroid ? 15 : 13,
        fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal);
  }

  static TextStyle tablerowTextStyle({bool isFontBold = false}) {
    return TextStyle(
        fontSize: Platform.isAndroid ? 15 : 12,
        fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal);
  }
}
