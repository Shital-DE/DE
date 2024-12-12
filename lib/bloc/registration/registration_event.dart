part of 'registration_bloc.dart';
// Author : Shital Gayakwad
// Created Date : 27 May 2023
// Description : ERPX_PPC -> Registration event

abstract class RegistrationEvent {}

class RegistrationInitialEvent extends RegistrationEvent {
  final Map<String, dynamic> folder;
  final int selectedIndex;
  RegistrationInitialEvent({required this.folder, this.selectedIndex = 2});
}
