// Author : Shital Gayakwad
// Created Date : 26 Feb 2023
// Description : ERPX_PPC -> Appbar state
// Modified data : 21 May 2023

import 'package:flutter/material.dart';

abstract class AppbarState {}

class AppBarInitial extends AppbarState {
  AppBarInitial();
}

class AppbarLoading extends AppbarState {
  final String workcentreName,
      workstationname,
      employeename,
      employeeid,
      deviceid,
      wcid,
      wsid,
      token;

  final ImageProvider employeeProfile;
  AppbarLoading(
      {required this.workcentreName,
      required this.workstationname,
      required this.employeeProfile,
      required this.employeename,
      required this.employeeid,
      required this.deviceid,
      required this.wcid,
      required this.wsid,
      required this.token});
}

class AppBarErrorState extends AppbarState {
  final String errorName;
  AppBarErrorState({required this.errorName});
}
