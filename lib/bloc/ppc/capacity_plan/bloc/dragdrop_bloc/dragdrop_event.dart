part of 'dragdrop_bloc.dart';

abstract class DragDropEvent {
  const DragDropEvent();
  // final int runnumber;
}

class RunnumberEvent extends DragDropEvent {
  final int runnumber;
  const RunnumberEvent({required this.runnumber});
}

class SaveCPProductEvent extends DragDropEvent {
  final ProductDragDrop product;
  final String workcentre;
  const SaveCPProductEvent({
    required this.product,
    required this.workcentre,
  });
}

class SaveAllCPProductEvent extends DragDropEvent {
  final List<ProductDragDrop> product;
  final int runnumber;

  const SaveAllCPProductEvent({required this.product, required this.runnumber});
}

class ShowWorkcentreProductEvent extends DragDropEvent {
  final String workcentre;
  final int runnumber;
  const ShowWorkcentreProductEvent({
    required this.workcentre,
    required this.runnumber,
  });
}

class DeleteWCProductEvent extends ShowWorkcentreProductEvent {
  final String cpChildId;
  const DeleteWCProductEvent(
      {required super.workcentre,
      required super.runnumber,
      required this.cpChildId});
}

class UpdateWorkstationEvent extends DragDropEvent {
  final String workstationid;
  final String cpId;
  final String cpChildId;
  final int runnumber;
  final String workcentreId;

  const UpdateWorkstationEvent(
      {required this.cpId,
      required this.cpChildId,
      required this.runnumber,
      required this.workcentreId,
      required this.workstationid});
}
