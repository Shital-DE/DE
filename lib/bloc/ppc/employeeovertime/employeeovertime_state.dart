import '../../../services/model/employee_overtime/employee_model.dart';
import '../../../services/model/po/po_models.dart';
import '../../../services/model/product/product.dart';
import 'employeeovertime_bloc.dart';

abstract class EOvertimeState {}

class OvertimeinitialState extends EOvertimeState {}

class OvertimeLoadingState extends EOvertimeState {
  final List<Employee> operator;
  final List<EmpOvertimeWorkstation> empovertimews;
  final String employeeid, wsid, token, remark, loginid, viewdetailsid;
  final List<EmployeeOvertimedata> empovertimedata;

  final List<Outsource> outsourceList;
  final ToggleOvertimeOption option;
  List<Outsource> productselectedList;
  List<EODdetails> detailsofovertimeproduct;

  List<AllProductModel> productcodelist, selectedtoollist;

  OvertimeLoadingState(
      {required this.operator,
      required this.empovertimews,
      required this.employeeid,
      required this.wsid,
      required this.empovertimedata,
      required this.token,
      required this.loginid,
      required this.remark,
      required this.productcodelist,
      required this.selectedtoollist,
      required this.option,
      required this.outsourceList,
      required this.productselectedList,
      required this.viewdetailsid,
      required this.detailsofovertimeproduct});
}

class EOvertimeErrorState extends EOvertimeState {
  final String errorMessage;
  EOvertimeErrorState({required this.errorMessage});
}
