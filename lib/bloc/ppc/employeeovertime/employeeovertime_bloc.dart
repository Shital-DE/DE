import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/model/employee_overtime/employee_model.dart';
import '../../../services/model/po/po_models.dart';
import '../../../services/model/product/product.dart';
import '../../../services/repository/employee_overtime/employee_repository.dart';
import '../../../services/repository/outsource/outsource_repository.dart';
import '../../../services/repository/product/product_repository.dart';
import '../../../services/session/user_login.dart';
import 'employeeovertime_event.dart';
import 'employeeovertime_state.dart';

enum ToggleOvertimeOption { outsource, inhouse }

class EOvertimeBLoc extends Bloc<EOvertime, EOvertimeState> {
  // final BuildContext context;

  EOvertimeBLoc(contex) : super(OvertimeinitialState()) {
    on<EOvertimeEvent>((event, emit) async {
      String token = '', loginid = '';
      List<EmployeeOvertimedata> empovertimedata = [];

      List<AllProductModel> allProductList = [];
      List<EmpOvertimeWorkstation> empovertimews = [];
      List<EODdetails> detailsofovertimeproduct = [];

      List<Outsource> outsourceList = [];
      final saveddata = await UserData.getUserData();
      token = saveddata['token'].toString();
      for (var userdata in saveddata['data']) {
        loginid = userdata['id'];
      }
      if (event.employeeid != '') {
        empovertimedata = await EmployeeRepository.empOvertimedata(
            empid: event.employeeid.toString().trim(), token: token);
      }
      List<Employee> operatorList = await EmployeeRepository.operatorList();
      empovertimews = await EmployeeRepository.workstationList();

      allProductList = await ProductRepository().allProductList(token: token);

      List<Outsource> list = await OutsourceRepository.getOutsourceList(
          fromdate: event.fromDate, todate: event.toDate);

      outsourceList = list.where((e) => e.isinhouse == 'Y').toList();
      if (event.isCheckVal == true) {
        List<Outsource> subList = List.from(event.subList);
        int subItemIndex = subList.indexWhere((e) => e == event.item);
        if (subItemIndex != -1) {
          subList[subItemIndex].isCheck = event.isCheckVal;
          outsourceList = subList;
        }
      }
      if (event.isCheckVal == false) {
        List<Outsource> subList = List.from(event.subList);
        int subItemIndex = subList.indexWhere((e) => e == event.item);
        if (subItemIndex != -1) {
          subList[subItemIndex].isCheck = event.isCheckVal;
          outsourceList = subList;
        }
      }

      emit(OvertimeLoadingState(
        operator: operatorList,
        empovertimews: empovertimews,
        employeeid: event.employeeid,
        wsid: event.wsid,
        empovertimedata: empovertimedata,
        token: token,
        loginid: loginid,
        remark: event.remark,
        productcodelist: allProductList,
        selectedtoollist: event.selectedtoollist,
        option: ToggleOvertimeOption.outsource,
        outsourceList: outsourceList,
        productselectedList: [],
        viewdetailsid: event.viewdetailsid,
        detailsofovertimeproduct: detailsofovertimeproduct,
      ));
    });
  }
}
