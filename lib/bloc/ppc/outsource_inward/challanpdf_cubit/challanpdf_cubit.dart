import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../services/model/po/po_models.dart';
import '../../../../services/repository/outsource/outsource_repository.dart';

part 'challanpdf_state.dart';

class ChallanpdfCubit extends Cubit<ChallanpdfState> {
  ChallanpdfCubit() : super(const ChallanpdfInitial(challanPdflist: []));

  void getAllChallanPdfList(
      {required String subcontractorId,
      required int month,
      required int year}) async {
    List<ChallanPDFList> challanlist = await OutsourceRepository.listChallanPdf(
        subcontractorId: subcontractorId, month: month, year: year);
    CompanyDetails company = await OutsourceRepository.companyDetails();
    emit(ListChallanPDFState(challanPdflist: challanlist, company: company));
  }
}
