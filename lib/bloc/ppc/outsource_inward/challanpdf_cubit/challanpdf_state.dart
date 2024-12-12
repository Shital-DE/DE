part of 'challanpdf_cubit.dart';

class ChallanpdfState extends Equatable {
  final List<ChallanPDFList> challanPdflist;
  const ChallanpdfState({required this.challanPdflist});

  @override
  List<Object> get props => [];
}

final class ChallanpdfInitial extends ChallanpdfState {
  const ChallanpdfInitial({required super.challanPdflist});
}

final class ListChallanPDFState extends ChallanpdfState {
  final CompanyDetails company;
  const ListChallanPDFState(
      {required super.challanPdflist, required this.company});

  @override
  List<Object> get props => [challanPdflist];
}
