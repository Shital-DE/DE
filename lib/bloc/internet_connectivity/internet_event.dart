// Author : Shital Gayakwad
// Created Date : 23 Feb 2023
// Description : ERPX_PPC -> Internet connection events
// Modified Date :

abstract class InternetEvent {}

class InternetLostEvent extends InternetEvent {}

class InternetGainedEvent extends InternetEvent {}
