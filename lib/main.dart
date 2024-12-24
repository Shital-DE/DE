import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MyApp());
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      if (lightDynamic != null && darkDynamic != null) {
        lightColorScheme = lightDynamic.harmonized()..copyWith();
        lightColorScheme =
            lightColorScheme.copyWith(secondary: AppColors.appTheme);
      } //else
      {
        lightColorScheme = ColorScheme.fromSeed(seedColor: AppColors.appTheme);
      }
      return MaterialApp(
        title: 'Datta Enterprises',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          fontFamily: 'font',
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteName.splash,
        onGenerateRoute: Routes.generateRoute,
      );
    });
  }
}
