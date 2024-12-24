import 'package:flutter/material.dart';
import '../../../routes/route_names.dart';
import '../../../utils/app_colors.dart';

class Server {
  serverUnreachable(
      {required BuildContext context, required String screenname}) {
    double conHeight = 270;
    double conWidth = 500;
    return Center(
      child: SizedBox(
        width: conWidth,
        height: conHeight,
        child: Column(
          children: [
            Container(
                height: 40,
                width: conWidth,
                color: AppColors.appTheme,
                child: const Center(
                    child: Text(
                  'Server Unreachable !',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ))),
            Container(
              height: conHeight - 40,
              width: conWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.appTheme,
                  width: 2,
                ),
              ),
              child: Center(
                  child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: (conHeight - 40) - 60,
                      child: const Center(
                        child: Text(
                          """The server didn't respond. You may retry your request when the server comes back""",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                          child: const Text('Try to connect'),
                          onPressed: () {
                            if (screenname == 'dashboard') {
                              Navigator.popAndPushNamed(
                                  context, RouteName.dashboard);
                            } else if (screenname == 'machine_registration') {
                            } else if (screenname == 'machineStatus') {
                            } else {
                              Navigator.of(context).pop();
                            }
                          }),
                    )
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
