// import 'package:de_opc/services/splash_service.dart';
// import 'package:de_opc/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/splash_service.dart';
import '../../../utils/responsive.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    SplashServices().checkAuthentication(context);
    return MakeMeResponsiveScreen(
      mobile: splashwidget(context),
      horixontaltab: splashwidget(context),
      windows: splashwidget(context),
      linux: splashwidget(context),
    );
  }

  Scaffold splashwidget(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.inversePrimary,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.inversePrimary,
            ],
            stops: const [0.2, 0.4, 0.6, 0.8],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 130.0),
          child: Center(
              child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: Container(
                    width: 90,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.orange[900],
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(left: 2, top: 4),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'D',
                            style: GoogleFonts.delaGothicOne(
                                color: Colors.white, fontSize: 50),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, top: 17),
                          child: Text(
                            'E',
                            style: GoogleFonts.delaGothicOne(
                                color: Colors.white, fontSize: 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
