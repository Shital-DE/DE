// // Author : Shital Gayakwad
// // Created Date : 23 Feb 2023
// // Description : ERPX_PPC -> Internet connection bloc
// // Modified Date :

// import 'dart:async';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'internet_event.dart';
// import 'internet_state.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class InternetBloc extends Bloc<InternetEvent, InternetState> {
//   Connectivity connectivity = Connectivity();
//   StreamSubscription? connectivitySubscription;
//   InternetBloc() : super(InternetInitialState()) {
//     //Internet Lost
//     on<InternetLostEvent>(
//       (event, emit) => emit(InternetLostState()),
//     );

//     //Internet Gained
//     on<InternetGainedEvent>(
//       (event, emit) => emit(InternetGainedState()),
//     );

//     connectivitySubscription =
//         connectivity.onConnectivityChanged.listen((result) {
//       if (result == ConnectivityResult.mobile ||
//           result == ConnectivityResult.wifi) {
//         add(InternetGainedEvent());
//       } else {
//         add(InternetLostEvent());
//       }
//     });
//   }

//   @override
//   Future<void> close() {
//     connectivitySubscription?.cancel();
//     return super.close();
//   }
// }
