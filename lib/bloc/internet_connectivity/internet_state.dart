// Author : Shital Gayakwad
// Created Date : 23 Feb 2023
// Description : ERPX_PPC -> Internet connection state
// Modified Date :

abstract class InternetState {}

class InternetInitialState extends InternetState {}

class InternetLostState extends InternetState {}

class InternetGainedState extends InternetState {}
