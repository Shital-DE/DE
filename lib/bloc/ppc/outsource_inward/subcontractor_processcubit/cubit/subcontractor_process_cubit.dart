import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../services/model/po/po_models.dart';
import '../../../../../services/model/product/product_route.dart';
import '../../../../../services/model/registration/subcontractor_models.dart';
import '../../../../../services/repository/outsource/outsource_repository.dart';
import '../../../../../services/repository/product/product_route_repo.dart';
import '../../../../../services/session/user_login.dart';
part 'subcontractor_process_state.dart';

class SubcontractorProcessCubit extends Cubit<SubcontractorProcessState> {
  SubcontractorProcessCubit()
      : super(const SubcontractorProcessInitial(
            listProcessCapability: [], process: [], subcontractor: []));
  void listSubcontractorProcess(String token) async {
    ProductRouteRepository ob = ProductRouteRepository();

    final saveddata = await UserData.getUserData();

    List<Process> processList =
        await ob.processes(token: saveddata['token'].toString());

    List<AllSubContractor> subcontractorList =
        await OutsourceRepository.getSubcontrctorList();

    List<ProcessCapability> listProcessCapability =
        await OutsourceRepository.listProcessCapability();

    emit(SubcontractorProcessLoadList(
        process: processList,
        subcontractor: subcontractorList,
        listProcessCapability: listProcessCapability));
  }

  void saveSubcontractorProcessCapabilities(
      {required String subcontractorId, required String processId}) async {
    await OutsourceRepository.savesubcontractorProcessCapability(
        subcontractorId: subcontractorId, processId: processId);
    List<ProcessCapability> listProcessCapability =
        await OutsourceRepository.listProcessCapability();

    ProductRouteRepository ob = ProductRouteRepository();

    final saveddata = await UserData.getUserData();

    List<Process> processList =
        await ob.processes(token: saveddata['token'].toString());
    List<AllSubContractor> subcontractorList =
        await OutsourceRepository.getSubcontrctorList();

    Future.delayed(const Duration(milliseconds: 30), () {
      emit(const SubcontractorProcessInitial(
          process: [], subcontractor: [], listProcessCapability: []));
    });
    Future.delayed(const Duration(seconds: 1), () {
      emit(SubcontractorProcessLoadList(
          process: processList,
          subcontractor: subcontractorList,
          listProcessCapability: listProcessCapability));
    });
  }

  void deleteSubcontractorProcess({required String id}) async {
    await OutsourceRepository.deleteProcessCapability(id: id);

    List<ProcessCapability> listProcessCapability =
        await OutsourceRepository.listProcessCapability();

    ProductRouteRepository ob = ProductRouteRepository();

    final saveddata = await UserData.getUserData();

    List<Process> processList =
        await ob.processes(token: saveddata['token'].toString());

    List<AllSubContractor> subcontractorList =
        await OutsourceRepository.getSubcontrctorList();

    emit(SubcontractorProcessLoadList(
        listProcessCapability: listProcessCapability,
        subcontractor: subcontractorList,
        process: processList));
  }
}
