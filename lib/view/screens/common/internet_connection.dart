// // Author : Shital Gayakwad
// // Created Date : 23 Feb 2023
// // Description : ERPX_PPC -> Internet state handling UI
// // Modified Date : 17 March 2023

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../bloc/internet_connectivity/internet_bloc.dart';
// import '../../../bloc/internet_connectivity/internet_state.dart';

// class InternetConnectionCheck extends StatelessWidget {
//   final Widget widget;
//   const InternetConnectionCheck({super.key, required this.widget});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => InternetBloc(),
//       child:
//           BlocBuilder<InternetBloc, InternetState>(builder: (context, state) {
//         if (state is InternetGainedState) {
//           return widget;
//         } else if (state is InternetLostState) {
//           return Scaffold(
//             body: Center(
//               child: Stack(
//                 children: [
//                   const Align(
//                       alignment: Alignment.center,
//                       child: Icon(
//                         Icons.wifi_off_outlined,
//                         size: 200,
//                         color: Colors.grey,
//                       )),
//                   Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                           margin: const EdgeInsets.only(top: 190),
//                           child: const Text(
//                             'No internet connection',
//                             style: TextStyle(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 30),
//                           )))
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return widget;
//         }
//       }),
//     );
//   }
// }
