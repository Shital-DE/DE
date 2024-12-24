import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../services/model/capacity_plan/model.dart';
import '../../../../../services/model/machine/workstation.dart';
import '../../../../../services/repository/capacity_plan/capacity_plan_repository.dart';

part 'dragdrop_event.dart';
part 'dragdrop_state.dart';

class DragDropBloc extends Bloc<DragDropEvent, DragDropState> {
  DragDropBloc() : super(const DragdropInitial(products: [])) {
    on<RunnumberEvent>((event, emit) async {
      List<ProductDragDrop> products =
          await CapacityPlanRepository.cpDragAndDrop(event.runnumber);

      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();
      emit(DragdropLoadedList(
          products: products,
          workcentre: workcentre,
          runnumber: event.runnumber,
          wsProducts: const []));
    });

    on<SaveCPProductEvent>((event, emit) async {
      await CapacityPlanRepository.saveDraggedProduct(
          product: event.product, workcentreId: event.workcentre);
      List<ProductDragDrop> products =
          await CapacityPlanRepository.cpDragAndDrop(event.product.runnumber!);

      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();
      emit(DragdropLoadedList(
          products: products,
          workcentre: workcentre,
          runnumber: event.product.runnumber!,
          wsProducts: const []));
    });

    on<SaveAllCPProductEvent>((event, emit) async {
      String str = await CapacityPlanRepository.saveAllDragDropProduct(
          product: event.product);
      if (str == 'success') {
        List<WorkcentreCP> workcentre =
            await CapacityPlanRepository.cpWorkcentreList();
        emit(DragdropLoadedList(
            products: const [],
            workcentre: workcentre,
            runnumber: event.runnumber,
            wsProducts: const []));
      }
    });

    on<ShowWorkcentreProductEvent>((event, emit) async {
      List<ProductDragDrop> products =
          await CapacityPlanRepository.cpDragAndDrop(event.runnumber);
      List<WorkstationByWorkcentreId> workstation =
          await CapacityPlanRepository.cpWorkstationList(event.workcentre);
      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();
      List<ProductDragDrop> data =
          await CapacityPlanRepository.getWorkcentreAssignProducts(
              workcentreId: event.workcentre, runnumber: event.runnumber);

      emit(DragdropLoadedList(
          products: products,
          workcentre: workcentre,
          runnumber: event.runnumber,
          wsProducts: data,
          workstations: workstation));
    });

    on<DeleteWCProductEvent>((event, emit) async {
      await CapacityPlanRepository.deleteWCProductCP(
          cpChildId: event.cpChildId);

      List<ProductDragDrop> products =
          await CapacityPlanRepository.cpDragAndDrop(
              event.runnumber); // list view
      List<WorkstationByWorkcentreId> workstation =
          await CapacityPlanRepository.cpWorkstationList(event.workcentre);
      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();
      List<ProductDragDrop> data =
          await CapacityPlanRepository.getWorkcentreAssignProducts(
              workcentreId: event.workcentre,
              runnumber: event.runnumber); // delete product list

      emit(DragdropLoadedList(
          products: products,
          workcentre: workcentre,
          runnumber: event.runnumber,
          wsProducts: data,
          workstations: workstation));
    });

    on<UpdateWorkstationEvent>((event, emit) async {
      await CapacityPlanRepository.updateWStoCPproduction(
          workstationId: event.workstationid,
          capacityplanId: event.cpId,
          cpChildId: event.cpChildId);

      List<ProductDragDrop> data =
          await CapacityPlanRepository.getWorkcentreAssignProducts(
              workcentreId: event.workcentreId, runnumber: event.runnumber);
      List<ProductDragDrop> products =
          await CapacityPlanRepository.cpDragAndDrop(event.runnumber);
      List<WorkstationByWorkcentreId> workstation =
          await CapacityPlanRepository.cpWorkstationList(event.workcentreId);
      List<WorkcentreCP> workcentre =
          await CapacityPlanRepository.cpWorkcentreList();
      emit(DragdropLoadedList(
          products: products,
          workcentre: workcentre,
          runnumber: event.runnumber,
          wsProducts: data,
          workstations: workstation));
    });
  }
}
