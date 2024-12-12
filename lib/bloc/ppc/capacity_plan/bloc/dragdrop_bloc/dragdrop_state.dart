part of 'dragdrop_bloc.dart';

abstract class DragDropState extends Equatable {
  const DragDropState({required this.products});
  final List<ProductDragDrop> products;
  // final List
}

class DragdropInitial extends DragDropState {
  const DragdropInitial({required super.products});

  @override
  List<Object> get props => [products];
}

class DragdropLoadedList extends DragDropState {
  final List<WorkcentreCP> workcentre;
  final int runnumber;
  final List<ProductDragDrop>? wsProducts;
  final List<WorkstationByWorkcentreId>? workstations;
  const DragdropLoadedList(
      {required super.products,
      required this.workcentre,
      required this.runnumber,
      this.wsProducts = const [],
      this.workstations = const []});

  @override
  List<Object> get props =>
      [products, workcentre, runnumber, wsProducts!, workstations!];
}
