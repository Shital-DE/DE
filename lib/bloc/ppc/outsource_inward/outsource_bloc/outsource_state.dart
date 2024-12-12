part of 'outsource_bloc.dart';

class OutsourceState extends Equatable {
  @override
  List<Object> get props => [];
}

final class OutsourceInitial extends OutsourceState {}

final class OutsourceClear extends OutsourceState {}

final class OutsourceAllListState extends OutsourceState {
  final List<Outsource> outsourceList;
  final List<Outsource> mainList;
  final ToggleOption option;
  OutsourceAllListState(
      {required this.option,
      required this.outsourceList,
      required this.mainList});

  @override
  List<Object> get props => [option, outsourceList, mainList];
}

final class SubcontractorListState extends OutsourceState {
  final List<AllSubContractor> subContractorList;
  final String challanNumber;
  final CompanyDetails company;

  SubcontractorListState(
      {required this.challanNumber, required this.subContractorList,required this.company});

  @override
  List<Object> get props => [subContractorList];
}
