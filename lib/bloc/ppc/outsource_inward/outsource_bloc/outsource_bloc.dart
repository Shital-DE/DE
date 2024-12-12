import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../services/model/po/po_models.dart';
import '../../../../../services/model/registration/subcontractor_models.dart';
import '../../../../services/repository/outsource/outsource_repository.dart';
part 'outsource_event.dart';
part 'outsource_state.dart';

enum ToggleOption { outsource, inhouse }

class OutsourceBloc extends Bloc<OutsourceEvent, OutsourceState> {
  OutsourceBloc() : super(OutsourceInitial()) {
    on<OutsourceInitEvent>((event, emit) => emit(OutsourceInitial()));

    on<OutsourceListEvent>((event, emit) async {
      List<Outsource> list = await OutsourceRepository.getOutsourceList(
          fromdate: event.fromDate, todate: event.toDate);
      List<Outsource> outsourceList = [];
      
      outsourceList = list.where((e) => e.isinhouse == 'N').toList();

      emit(OutsourceAllListState(
          option: ToggleOption.outsource,
          outsourceList: outsourceList,
          mainList: list));
    });

    //----------***-----------//
    on<SelectToggleEvent>((event, emit) async {
      List<Outsource> list = [];
      if (event.mainList.isNotEmpty) {
        list = event.mainList;
      } else {
        list = await OutsourceRepository.getOutsourceList(
            fromdate: event.fromDate, todate: event.toDate);
      }
      if (event.option == ToggleOption.outsource) {
        List<Outsource> outsourceList = [];
        
        outsourceList = list.where((e) => e.isinhouse == 'N').toList();
        
        emit(OutsourceAllListState(
            option: event.option,
            outsourceList: outsourceList,
            mainList: list));
      } else {
        List<Outsource> inhouseList = [];
      
        inhouseList = list.where((e) => e.isinhouse == 'Y').toList();

        emit(OutsourceAllListState(
            option: event.option, outsourceList: inhouseList, mainList: list));
      }
    });

    on<CheckListItemEvent>((event, emit) async {
      List<Outsource> subList = List.from(event.subList);
      List<Outsource> mainList = List.from(event.mainList);

      int mainItemIndex = mainList.indexWhere((e) => e == event.item);
      if (mainItemIndex != -1) {
        mainList[mainItemIndex].isCheck = event.isCheckVal;
      }

      int subItemIndex = subList.indexWhere((e) => e == event.item);
      if (subItemIndex != -1) {
        subList[subItemIndex].isCheck = event.isCheckVal;
      }

      emit(OutsourceInitial());
      emit(OutsourceAllListState(
          option: event.option, outsourceList: subList, mainList: mainList));
    });

    on<CreateChallanEvent>((event, emit) async {
      await OutsourceRepository.saveChallan(
          challanNo: event.challanNo,
          subcontractor: event.subcontractor,
          outsourceList: event.outsourceList);

      emit(OutsourceInitial());
    });

    on<GetSubcontractorEvent>((event, emit) async {
      List<AllSubContractor> list =
          await OutsourceRepository.getSubcontrctorList();
      String challanNo = await OutsourceRepository.getChallanNo();
      CompanyDetails company = await OutsourceRepository.companyDetails();

      emit(SubcontractorListState(
          subContractorList: list, challanNumber: challanNo, company: company));
    });

    on<SendEmailEvent>((event, emit) async {
      await OutsourceRepository.sendMail(
          challanNo: event.challanNo, pdf: event.pdfdata);
      // emit(OutsourceInitial());
    });
  }
}
