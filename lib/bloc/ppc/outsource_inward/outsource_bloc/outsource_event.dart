part of 'outsource_bloc.dart';

class OutsourceEvent {
  const OutsourceEvent();
}

class OutsourceInitEvent extends OutsourceEvent {}

class OutsourceListEvent extends OutsourceEvent {
  final ToggleOption option;
  final String fromDate, toDate;
  const OutsourceListEvent(
      {required this.option, required this.fromDate, required this.toDate});
} // all list

class SelectToggleEvent extends OutsourceEvent {
  final String fromDate, toDate;
  final ToggleOption option;
  final List<Outsource> mainList;
  const SelectToggleEvent(
      {required this.mainList,
      required this.option,
      required this.fromDate,
      required this.toDate});
}

class CheckListItemEvent extends OutsourceEvent {
  final ToggleOption option;
  final List<Outsource> mainList;
  final List<Outsource> subList;
  final Outsource item;
  bool isCheckVal;

  CheckListItemEvent({
    required this.option,
    required this.isCheckVal,
    required this.item,
    required this.subList,
    required this.mainList,
  });
} //select check box

class SearchProductEvent extends OutsourceEvent {
  final String product;
  final List<Outsource> subList;
  SearchProductEvent({
    required this.product,
    required this.subList,
  });
} //search product

class CreateChallanEvent extends OutsourceEvent {
  final String challanNo;
  final String subcontractor;
  final List<Outsource> outsourceList;
  CreateChallanEvent({
    required this.challanNo,
    required this.subcontractor,
    required this.outsourceList,
  });
}

class SendEmailEvent extends OutsourceEvent {
  final String challanNo;
  final Uint8List pdfdata;
  SendEmailEvent({required this.challanNo, required this.pdfdata});
}

class GetSubcontractorEvent extends OutsourceEvent {
  GetSubcontractorEvent();
}
