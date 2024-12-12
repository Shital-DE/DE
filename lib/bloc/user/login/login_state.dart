// Author : Shital Gayakwad
// Created Date : 26 Feb 2023
// Description : ERPX_PPC -> Login state
// Modified data : 21 May 2023

import 'package:flutter/material.dart';

abstract class UserLoginstate {}

class LoginInitialState extends UserLoginstate {
  LoginInitialState();
}

class LoginState extends UserLoginstate {
  final String username, password;
  final ValueNotifier obsecurePassword;
  final bool submitting;
  LoginState(
      {required this.username,
      required this.password,
      required this.obsecurePassword,
      this.submitting = false});
}

class LoginErrorState extends UserLoginstate {
  final String errorMessage, username, password;
  LoginErrorState(
      {required this.errorMessage, this.username = '', this.password = ''});
}
