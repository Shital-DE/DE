import '../../../services/model/employee_overtime/employee_model.dart';
import '../../../services/model/po/po_models.dart';
import '../../../services/model/product/product.dart';
import 'employeeovertime_bloc.dart';

// abstract

class EOvertime {
  const EOvertime();
}

class EOvertimeEvent extends EOvertime {
  final List<Employee> operator;
  final List<EmpOvertimeWorkstation> empovertimews;
  final String employeeid, wsid, token, remark;
  final List<EmployeeOvertimedata> empovertimedata;
  final List<AllProductModel> selectedtoollist;
  final ToggleOvertimeOption option;
  final String fromDate, toDate, viewdetailsid;
  final List<Outsource> subList;
  final Outsource item;
  bool isCheckVal;
  List<Outsource> productselectedList;
  EOvertimeEvent({
    required this.operator,
    required this.empovertimews,
    required this.employeeid,
    required this.wsid,
    required this.token,
    required this.empovertimedata,
    required this.remark,
    required this.selectedtoollist,
    required this.option,
    required this.fromDate,
    required this.toDate,
    required this.subList,
    required this.item,
    required this.isCheckVal,
    required this.productselectedList,
    required this.viewdetailsid,
  });
}

class OvertimeCheckListItemEvent extends EOvertime {
  final ToggleOvertimeOption option;
  final List<Outsource> subList;
  final Outsource item;
  bool isCheckVal;

  OvertimeCheckListItemEvent({
    required this.option,
    required this.isCheckVal,
    required this.item,
    required this.subList,
  });
}

class EOvertimeInitialEvent extends EOvertime {
  EOvertimeInitialEvent();
}
