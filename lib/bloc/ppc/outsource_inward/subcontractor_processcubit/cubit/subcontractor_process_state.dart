part of 'subcontractor_process_cubit.dart';

class SubcontractorProcessState extends Equatable {
  const SubcontractorProcessState();
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class SubcontractorProcessInitial extends SubcontractorProcessState {
  final List<Process> process;
  final List<AllSubContractor> subcontractor;
  final List<ProcessCapability> listProcessCapability;
  const SubcontractorProcessInitial(
      {required this.process,
      required this.subcontractor,
      required this.listProcessCapability});

  @override
  List<Object> get props => [process, subcontractor, listProcessCapability];
}

final class SubcontractorProcessLoadList extends SubcontractorProcessInitial {
  const SubcontractorProcessLoadList(
      {required super.process,
      required super.subcontractor,
      required super.listProcessCapability});

  @override
  List<Object> get props =>
      [super.process, super.subcontractor, super.listProcessCapability];
}
