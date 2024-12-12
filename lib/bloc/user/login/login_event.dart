// Author : Shital Gayakwad
// Created Date : 26 Feb 2023
// Description : ERPX_PPC -> Login event
// Modified data : 21 May 2023

import 'package:flutter/material.dart';

abstract class UserLoginEvent {}

class LoginCredentialsEvent extends UserLoginEvent {
  final String username, password;
  final ValueNotifier obsecurePassword;
  final bool submitting;
  LoginCredentialsEvent(
      {this.username = '',
      this.password = '',
      required this.obsecurePassword,
      this.submitting = false});
}

class SubmitUserCredentials extends UserLoginEvent {
  SubmitUserCredentials();
}
