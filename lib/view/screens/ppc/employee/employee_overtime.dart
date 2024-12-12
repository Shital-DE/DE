// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:de/bloc/ppc/employeeovertime/employeeovertime_event.dart';
import 'package:de/services/model/po/po_models.dart';
import 'package:de/services/model/product/product.dart';
import 'package:de/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/employeeovertime/employeeovertime_bloc.dart';
import '../../../../bloc/ppc/employeeovertime/employeeovertime_state.dart';
import '../../../../services/model/employee_overtime/employee_model.dart';
import '../../../../services/repository/employee_overtime/employee_repository.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../../utils/constant.dart';
// import '../../../../utils/size_config.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/custom_datatable.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/date_range_picker.dart';
import '../../../widgets/debounce_button.dart';
import '../outsource/challan_pdf.dart';

// import 'package:multi_dropdown/multiselect_dropdown.dart';

// ignore: must_be_immutable
class EmployeeOverTime extends StatelessWidget {
  EmployeeOverTime({super.key});
  static List<AllProductModel> selectedtoollist = [];
  ToggleOvertimeOption view = ToggleOvertimeOption.outsource;

  Outsource empt = Outsource(isCheck: false);
  Future<void> _refreshData(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final blocprovider = BlocProvider.of<EOvertimeBLoc>(context);

    // blocprovider.add(EOvertimeInitialEvent());
    blocprovider.add(EOvertimeEvent(
      operator: [],
      empovertimews: [],
      employeeid: '',
      wsid: '',
      token: '',
      empovertimedata: [],
      remark: '',
      selectedtoollist: [],
      option: view,
      fromDate: '',
      toDate: '',
      subList: [],
      item: empt,
      isCheckVal: false,
      productselectedList: [],
      viewdetailsid: '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final blocprovider = BlocProvider.of<EOvertimeBLoc>(context);
    blocprovider.add(EOvertimeEvent(
      operator: [],
      empovertimews: [],
      employeeid: '',
      wsid: '',
      token: '',
      empovertimedata: [],
      remark: '',
      selectedtoollist: [],
      option: view,
      fromDate: '',
      toDate: '',
      subList: [],
      item: empt,
      isCheckVal: false,
      productselectedList: [],
      viewdetailsid: '',
    ));

    String employeeid = '', wsid = '', poid = '', productid = '';

    return Scaffold(
      appBar:
          CustomAppbar().appbar(context: context, title: 'Employee Overtime'),
      body: mainUI(blocprovider, context, employeeid, wsid, poid, productid),
    );
  }

  SafeArea mainUI(
    EOvertimeBLoc blocprovider,
    BuildContext context,
    String employeeid,
    String wsid,
    String poid,
    String productid,
  ) {
    TimeOfDay? selectedstartTime = TimeOfDay.now();
    TimeOfDay? selectedendTime = TimeOfDay.now();
    TextEditingController remarkcontroller = TextEditingController();
    TextEditingController startpickDate = TextEditingController();
    TextEditingController endpickDate = TextEditingController();
    TextEditingController startpicktime = TextEditingController();
    TextEditingController endpicktime = TextEditingController();
    List<TextEditingController> rowControllers = [];

    TextEditingController startDateTime = TextEditingController();
    TextEditingController endDateTime = TextEditingController();

    DateTime? dt1, dt2;
    String? ddt1, ddt2;
    DateTime? startdate;

    return SafeArea(
      child: MakeMeResponsiveScreen(
        horixontaltab: overtimescreenUI(
            context,
            employeeid,
            wsid,
            blocprovider,
            poid,
            productid,
            remarkcontroller,
            startdate,
            startpickDate,
            selectedstartTime,
            startpicktime,
            startDateTime,
            dt1,
            ddt1,
            endpickDate,
            selectedendTime,
            endpicktime,
            endDateTime,
            dt2,
            ddt2,
            rowControllers),
        windows: overtimescreenUI(
            context,
            employeeid,
            wsid,
            blocprovider,
            poid,
            productid,
            remarkcontroller,
            startdate,
            startpickDate,
            selectedstartTime,
            startpicktime,
            startDateTime,
            dt1,
            ddt1,
            endpickDate,
            selectedendTime,
            endpicktime,
            endDateTime,
            dt2,
            ddt2,
            rowControllers),
      ),
    );
  }

  Padding overtimescreenUI(
      BuildContext context,
      String employeeid,
      String wsid,
      EOvertimeBLoc blocprovider,
      String poid,
      String productid,
      TextEditingController remarkcontroller,
      DateTime? startdate,
      TextEditingController startpickDate,
      TimeOfDay? selectedstartTime,
      TextEditingController startpicktime,
      TextEditingController startDateTime,
      DateTime? dt1,
      String? ddt1,
      TextEditingController endpickDate,
      TimeOfDay? selectedendTime,
      TextEditingController endpicktime,
      TextEditingController endDateTime,
      DateTime? dt2,
      String? ddt2,
      List<TextEditingController> rowControllers) {
    //  StreamController<List<AllProductModel>> seletedtoollistcontroller =
    //     StreamController<List<AllProductModel>>.broadcast();
    //  StreamController<List<AllProductModel>> matchedTools =
    //     StreamController<List<AllProductModel>>.broadcast();

    TextEditingController rangeDate = TextEditingController();
    DateRangePickerHelper pickerHelper = DateRangePickerHelper();

    // ToggleOvertimeOption view = ToggleOvertimeOption.outsource;

    return Padding(
      padding: const EdgeInsets.all(23.0),
      child: RefreshIndicator(
        onRefresh: () async {
          await _refreshData(context);
          employeeid = '';
          wsid = '';
          rangeDate.text = '';
        },
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlocBuilder<EOvertimeBLoc, EOvertimeState>(
              builder: (context, state) {
                if (state is OvertimeinitialState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (state is OvertimeLoadingState) {
                  return Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: CustomDropdownSearch(
                                  items: state.operator,
                                  itemAsString: (s) => s.employeename!,
                                  onChanged: (s) {
                                    employeeid = s!.id!;
                                    blocprovider.add(EOvertimeEvent(
                                      operator: state.operator,
                                      empovertimews: state.empovertimews,
                                      employeeid: employeeid.toString().trim(),
                                      wsid: state.wsid,
                                      token: state.token,
                                      empovertimedata: state.empovertimedata,
                                      remark: state.remark,
                                      selectedtoollist: state.selectedtoollist,
                                      option: view,
                                      fromDate: '',
                                      toDate: '',
                                      subList: [],
                                      item: empt,
                                      isCheckVal: false,
                                      productselectedList:
                                          state.productselectedList,
                                      viewdetailsid: state.viewdetailsid,
                                    ));
                                  },
                                  hintText: "Select Employee"),
                            ),
                            const SizedBox(
                              width: 23,
                            ),
                            employeeid != ''
                                ? SizedBox(
                                    width: 300,
                                    child: CustomDropdownSearch(
                                      items: state.empovertimews,
                                      itemAsString: (s) => s.ws!,
                                      onChanged: (s) {
                                        wsid = s!.id!;
                                        blocprovider.add(EOvertimeEvent(
                                          operator: state.operator,
                                          empovertimews: state.empovertimews,
                                          employeeid: state.employeeid,
                                          wsid: wsid.toString().trim(),
                                          token: state.token,
                                          empovertimedata:
                                              state.empovertimedata,
                                          remark: state.remark,
                                          selectedtoollist:
                                              state.selectedtoollist,
                                          option: view,
                                          fromDate: '',
                                          toDate: '',
                                          subList: [],
                                          item: empt,
                                          isCheckVal: false,
                                          productselectedList:
                                              state.productselectedList,
                                          viewdetailsid: state.viewdetailsid,
                                        ));
                                      },
                                      hintText: "Select workstation",
                                    ),
                                  )
                                : const Stack(),
                            const SizedBox(
                              width: 23,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(right: 5, top: 1),
                                height: 50,
                                width: 300,
                                padding: const EdgeInsets.only(
                                    left: 1, bottom: 3, right: 5),
                                child: TextField(
                                  controller: rangeDate,
                                  onTap: () async {
                                    if (state.employeeid != '' &&
                                        state.wsid != '') {
                                      String selectedDates = (await pickerHelper
                                          .rangeDatePicker(context))!;
                                      if (selectedDates != '') {
                                        rangeDate.text = selectedDates;

                                        Future.microtask(() =>
                                            blocprovider.add(EOvertimeEvent(
                                              operator: state.operator,
                                              empovertimews:
                                                  state.empovertimews,
                                              employeeid: state.employeeid,
                                              wsid: state.wsid,
                                              token: state.token,
                                              empovertimedata:
                                                  state.empovertimedata,
                                              remark: state.remark,
                                              selectedtoollist:
                                                  state.selectedtoollist,
                                              fromDate:
                                                  rangeDate.text.split('TO')[0],
                                              toDate:
                                                  rangeDate.text.split('TO')[1],
                                              option: view,
                                              subList: state.outsourceList,
                                              item: empt,
                                              isCheckVal: false,
                                              productselectedList: [],
                                              viewdetailsid:
                                                  state.viewdetailsid,
                                            )));
                                      }
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    contentPadding: EdgeInsets.only(bottom: 6),
                                    icon: Icon(
                                      Icons.calendar_month_sharp,
                                      color: Color(0XFF01579b),
                                    ),
                                    hintText: "Select Dates",
                                    border: InputBorder.none,
                                  ),
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        state.outsourceList.isNotEmpty
                            ? Container(
                                height: 350,
                                // width: 800,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 206, 224, 231),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                margin: const EdgeInsets.only(top: 1),
                                child:
                                    BlocBuilder<EOvertimeBLoc, EOvertimeState>(
                                  builder: (context, state) {
                                    if (state is OvertimeLoadingState) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: CustomSearchDataTable(
                                            columnNames: const [
                                              'Select',
                                              'PO',
                                              'Product',
                                              'LineItem',
                                              'Seq',
                                              'Instruction'
                                            ],
                                            tableBorder: const TableBorder(
                                                top: BorderSide(),
                                                bottom: BorderSide(),
                                                left: BorderSide(),
                                                right: BorderSide()),
                                            columnIndexForSearchIcon: 2,
                                            rows: state.outsourceList
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 1.5,
                                                          child: Checkbox(
                                                            value: e.isCheck,
                                                            onChanged: (value) {
                                                              blocprovider.add(
                                                                  EOvertimeEvent(
                                                                operator: state
                                                                    .operator,
                                                                empovertimews: state
                                                                    .empovertimews,
                                                                employeeid: state
                                                                    .employeeid,
                                                                wsid:
                                                                    state.wsid,
                                                                token:
                                                                    state.token,
                                                                empovertimedata:
                                                                    state
                                                                        .empovertimedata,
                                                                remark: state
                                                                    .remark,
                                                                selectedtoollist:
                                                                    state
                                                                        .selectedtoollist,
                                                                option: state
                                                                    .option,
                                                                fromDate: rangeDate
                                                                    .text
                                                                    .split(
                                                                        'TO')[0],
                                                                toDate: rangeDate
                                                                    .text
                                                                    .split(
                                                                        'TO')[1],
                                                                subList: state
                                                                    .outsourceList,
                                                                item: e,
                                                                isCheckVal:
                                                                    value!,
                                                                productselectedList:
                                                                    state
                                                                        .productselectedList,
                                                                viewdetailsid: state
                                                                    .viewdetailsid,
                                                              ));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(CustomText(
                                                          e.salesorder!)),
                                                      DataCell(CustomText(e
                                                              .product! +
                                                          e.revisionnumber!)),
                                                      DataCell(CustomText(e
                                                          .lineitemnumber
                                                          .toString())),
                                                      DataCell(CustomText(e
                                                          .sequence
                                                          .toString())),
                                                      DataCell(CustomText(e
                                                          .instruction
                                                          .toString())),
                                                    ]))
                                                .toList(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                                // ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 23,
                        ),
                        state.outsourceList.isNotEmpty
                            ? Container(
                                margin: const EdgeInsets.only(top: 1),
                                // width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BlocBuilder<EOvertimeBLoc, EOvertimeState>(
                                      builder: (context, state) {
                                        if (state is OvertimeLoadingState) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () async {
                                              state.productselectedList = [];
                                              state.outsourceList.map((e) {
                                                if (e.isCheck == true) {
                                                  if (e.instruction!.length <
                                                      40) {
                                                    e.instruction =
                                                        e.instruction;
                                                  } else {
                                                    e.instruction = e
                                                        .instruction!
                                                        .substring(0, 40);
                                                  }
                                                  state.productselectedList
                                                      .add(e);
                                                  return e;
                                                }
                                              }).toList();
                                            },
                                            child: const Text("Save"),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 23,
                                    ),
                                    BlocBuilder<EOvertimeBLoc, EOvertimeState>(
                                      builder: (context, state) {
                                        if (state is OvertimeLoadingState) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () async {
                                              state.productselectedList = [];
                                              state.outsourceList.map((e) {
                                                if (e.isCheck == true) {
                                                  if (e.instruction!.length <
                                                      40) {
                                                    e.instruction =
                                                        e.instruction;
                                                  } else {
                                                    e.instruction = e
                                                        .instruction!
                                                        .substring(0, 40);
                                                  }
                                                  state.productselectedList
                                                      .add(e);
                                                  return e;
                                                }
                                              }).toList();
                                              showDialog(
                                                  context: context,
                                                  builder: (newcontext) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Selected Products"),
                                                      content: Container(
                                                          height: 450,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            child: previewChallanProducts(
                                                                outsourceList: state
                                                                    .productselectedList),
                                                          )),
                                                      actions: [
                                                        DebouncedButton(
                                                            text: "Close",
                                                            onPressed: () {
                                                              // state.productselectedList =
                                                              //     [];
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    WidgetStateProperty.resolveWith(
                                                                        (states) =>
                                                                            const Color(0XFF01579b))))
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: const Text("View products"),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                  ],
                                ))
                            : const Stack(),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 210,
                          child: TextField(
                            onTap: () {},
                            onChanged: (value) {
                              remarkcontroller.text = remarkcontroller.text;
                              remarkcontroller.text = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Remark',
                            ),
                            controller: remarkcontroller,
                          ),
                        ),
                        const SizedBox(
                          height: 46,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Select Start Time"),
                                  onPressed: () async {
                                    startdate = await dateTimePicker(context);
                                    if (startdate == null) return;

                                    List<String> pickeddate =
                                        startdate.toString().split(' ');
                                    startpickDate.text =
                                        pickeddate[0].toString();

                                    TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.dialOnly,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat:
                                                false, // Set to false for 12-hour format
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (time == null) return;
                                    selectedstartTime = time;
                                    startpicktime.text =
                                        '${selectedstartTime!.hour.toString().padLeft(2, '0')}:${selectedstartTime!.minute.toString().padLeft(2, '0')}';

                                    startDateTime.text =
                                        '${startpickDate.text} ${startpicktime.text}';

                                    String date1 =
                                        startDateTime.text.toString().trim();

                                    dt1 = DateTime.parse(date1);
                                    ddt1 = dt1.toString();
                                  },
                                )),
                            const SizedBox(
                              width: 23,
                            ),
                            SizedBox(
                              width: 350,
                              child: TextField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  //labelText: 'Remark',
                                  hintText: 'Start time',
                                ),
                                controller: startDateTime,
                              ),
                            ),
                            SizedBox(
                              child: IconButton(
                                  onPressed: () async {
                                    startpicktime.text = '';
                                    startDateTime.text = '';
                                    startpickDate.text = '';
                                    ddt1 = '';
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: const Color.fromARGB(
                                        255, 223, 123, 123),
                                    size: Platform.isAndroid ? 25 : 20,
                                  )),
                            ),
                            const SizedBox(
                              width: 23,
                            ),
                            SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Select end Time"),
                                  onPressed: () async {
                                    if (startDateTime.text != '') {
                                      startdate = await dateTimePicker(context);
                                      if (startdate == null) return;

                                      List<String> pickeddate =
                                          startdate.toString().split(' ');
                                      endpickDate.text =
                                          pickeddate[0].toString();

                                      TimeOfDay? time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        initialEntryMode:
                                            TimePickerEntryMode.dialOnly,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return MediaQuery(
                                            data:
                                                MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat:
                                                  false, // Set to false for 12-hour format
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (time == null) return;

                                      selectedendTime = time;
                                      endpicktime.text =
                                          '${selectedendTime!.hour.toString().padLeft(2, '0')}:${selectedendTime!.minute.toString().padLeft(2, '0')}';

                                      endDateTime.text =
                                          '${endpickDate.text} ${endpicktime.text}';

                                      String date2 =
                                          endDateTime.text.toString().trim();

                                      dt2 = DateTime.parse(date2);
                                      ddt2 = dt2.toString();

                                      if (dt1!.isBefore(dt2!)) {}
                                      if (dt1!.isAfter(dt2!)) {
                                        QuickFixUi().showCustomDialog(
                                            context: context,
                                            errorMessage:
                                                "Please select proper date and Time");
                                        endpickDate.text = '';
                                        endpicktime.text = '';
                                        endDateTime.text = '';
                                      }
                                    }
                                  },
                                )),
                            const SizedBox(
                              width: 23,
                            ),
                            SizedBox(
                              width: 350,
                              child: TextField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  //labelText: 'Remark',
                                  hintText: 'End time',
                                ),
                                controller: endDateTime,
                              ),
                            ),
                            SizedBox(
                              child: IconButton(
                                  onPressed: () async {
                                    endpicktime.text = '';
                                    endDateTime.text = '';
                                    endpickDate.text = '';

                                    ddt2 = '';
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: const Color.fromARGB(
                                        255, 223, 123, 123),
                                    size: Platform.isAndroid ? 25 : 20,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 23,
                        ),
                        const SizedBox(
                          height: 23,
                        ),
                        SizedBox(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 235, 32, 18)),
                          ),
                          onPressed: () async {
                            if (state.employeeid != '' &&
                                state.wsid != '' &&
                                ddt1 != '') {
                              confirmUpdate(
                                newcontext: context,
                                state: state,
                                loginid: state.loginid,
                                empid: state.employeeid,
                                wsid: state.wsid,
                                starttime: ddt1.toString(),
                                endtime: ddt2 ?? '',
                                token: state.token,
                                remark: remarkcontroller.text,
                                operator: state.operator,
                                productselectedList: state.productselectedList,
                              );

                              startpickDate.clear();
                              startpicktime.clear();
                              startDateTime.clear();
                              endDateTime.clear();
                              endpickDate.clear();
                              endpicktime.clear();
                              ddt1 = '';
                              ddt2 = '';
                              remarkcontroller.clear();
                              rangeDate.clear();
                              employeeid = '';
                              wsid = '';
                            } else {
                              QuickFixUi.errorMessage(
                                  "Please fill all required data ", context);
                            }
                          },
                          child: const Text("Submit"),
                        )),
                        const SizedBox(
                          height: 23,
                        ),
                        if (state.empovertimedata.isNotEmpty &&
                            state.employeeid != '')
                          overtimeDataTable(
                              blocprovider,
                              state,
                              state.token,
                              state.employeeid,
                              state.wsid,
                              rowControllers,
                              context)
                      ],
                    ),
                  );
                } else {
                  return const Stack();
                }
              },
            )),
      ),
    );
  }

  Container overtimeDataTable(
      EOvertimeBLoc blockprovider,
      OvertimeLoadingState state,
      String token,
      String employeeid,
      String wsid,
      List<TextEditingController> rowControllers,
      BuildContext context) {
    TimeOfDay? updatedselectedendTime = TimeOfDay.now();
    TextEditingController updatedEndDate = TextEditingController();
    TextEditingController updatedEndTime = TextEditingController();
    TextEditingController updatedEndDateTime = TextEditingController();
    DateTime? dt1, dt2, fenddate;

    int serialNumber = 1;
    return Container(
        width: 1300,
        height: 350, //size.height,
        margin: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 224, 224, 224),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              dataRowColor: WidgetStateProperty.all(Colors.white),
              columns: const [
                DataColumn(label: Text('Sr.No')),
                DataColumn(label: Text('Employee')),
                DataColumn(label: Text('Machine')),
                DataColumn(label: Text('Start time')),
                DataColumn(label: Text('End time')),
                DataColumn(label: Text('Remark')),
                DataColumn(label: Text('Action')),
              ],
              rows: state.empovertimedata.asMap().entries.map((entry) {
                int index = entry.key;
                EmployeeOvertimedata e = entry.value;
                rowControllers = List.generate(
                  state.empovertimedata.length,
                  (index) => TextEditingController(),
                );
                TextEditingController controller = rowControllers[
                    index]; // Retrieve the controller for this row
                int currentSerial = serialNumber++;

                return DataRow(
                  cells: [
                    DataCell(Text(currentSerial.toString())),
                    DataCell(SizedBox(
                        width: 150,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(e.employeename.toString())))),
                    DataCell(Text(
                      e.wscode.toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 58, 126, 153),
                      ),
                      // style: AppTextStyle.tableItem
                    )),
                    DataCell(Text(e.starttime.toString())),
                    DataCell(
                      e.endtime == '' || e.endtime == null
                          ? SizedBox(
                              width: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TextField(
                                  readOnly: true,
                                  controller: controller,
                                  onTap: () async {
                                    fenddate = await dateTimePicker(context);
                                    if (fenddate == null) return;

                                    List<String> pickeddate =
                                        fenddate.toString().split(' ');
                                    updatedEndDate.text =
                                        pickeddate[0].toString();

                                    TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.dialOnly,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat:
                                                false, // Set to false for 12-hour format
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (time == null) return;

                                    updatedselectedendTime = time;
                                    updatedEndTime.text =
                                        '${updatedselectedendTime!.hour.toString().padLeft(2, '0')}:${updatedselectedendTime!.minute.toString().padLeft(2, '0')}';

                                    updatedEndDateTime.text =
                                        '${updatedEndDate.text} ${updatedEndTime.text}';
                                    e.endtime = updatedEndDateTime.text
                                        .toString()
                                        .trim();

                                    dt1 =
                                        DateTime.parse(e.starttime.toString());
                                    dt2 = DateTime.parse(e.endtime.toString());

                                    if (dt1!.isBefore(dt2!)) {
                                      controller.text = e.endtime.toString();
                                    }
                                    if (dt1!.isAfter(dt2!)) {
                                      QuickFixUi().showCustomDialog(
                                          context: context,
                                          errorMessage:
                                              "Please select proper date and Time");
                                      //   e.endtime = '';
                                      controller.text = '';
                                      updatedEndDateTime.text = '';
                                      updatedEndTime.text = '';
                                      updatedEndDate.text = '';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            )
                          : Text(e.endtime.toString()),
                    ),
                    DataCell(SizedBox(
                        width: 200,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(e.remark.toString())))),
                    DataCell(Row(
                      children: [
                        e.endtime == ''
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateColor.resolveWith(
                                      (states) => Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (e.endtime != '') {
                                      dynamic check = await showDialog<String>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  "Do you want to update record?",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25)),
                                              actions: [
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor: WidgetStateColor
                                                            .resolveWith((states) =>
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .error)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop('cancel');
                                                    },
                                                    child: const Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .whiteTheme,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                QuickFixUi.horizontalSpace(
                                                    width: 180),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateColor
                                                                .resolveWith(
                                                                    (states) =>
                                                                        AppColors
                                                                            .greenTheme)),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop('confirm');
                                                    },
                                                    child: const Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .whiteTheme,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                                //})
                                              ],
                                            );
                                          });
                                      if (check == 'confirm') {
                                        Future.sync(() async {
                                          await EmployeeRepository
                                              .updateEmpOvertimeData(
                                            id: e.id.toString(),
                                            empid: state.employeeid,
                                            endtime: controller.text,
                                            token: token,
                                          );

                                          QuickFixUi.successMessage(
                                              "Updated Successfully", context);

                                          BlocProvider.of<EOvertimeBLoc>(
                                                  context)
                                              .add(EOvertimeEvent(
                                            operator: state.operator,
                                            empovertimews: state.empovertimews,
                                            employeeid: state.employeeid,
                                            wsid: state.wsid,
                                            token: state.token,
                                            empovertimedata:
                                                state.empovertimedata,
                                            remark: state.remark,
                                            selectedtoollist:
                                                state.selectedtoollist,
                                            option: state.option,
                                            fromDate: '',
                                            toDate: '',
                                            subList: state.outsourceList,
                                            item: empt,
                                            isCheckVal: false,
                                            productselectedList: [],
                                            viewdetailsid: state.viewdetailsid,
                                          ));
                                        });
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 12, 12, 12),
                                    ),
                                  ),
                                ),
                              )
                            : const Stack(),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                (states) => Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                            onPressed: () async {
                              String? viewdetailsid = e.id;

                              state.detailsofovertimeproduct =
                                  await EmployeeRepository
                                      .detailsempOvertimedata(
                                          viewdetailsid:
                                              viewdetailsid.toString().trim(),
                                          token: token);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Work on Product"),
                                      content: Container(
                                          height: 450,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: viewdetails(
                                                detailsproductList: state
                                                    .detailsofovertimeproduct),
                                          )),
                                      actions: [
                                        DebouncedButton(
                                            text: "Close",
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .resolveWith((states) =>
                                                            const Color(
                                                                0XFF01579b))))
                                      ],
                                    );
                                  });
                            },
                            child: const Text(
                              "View",
                              style: TextStyle(
                                color: Color.fromARGB(255, 12, 12, 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                );
              }).toList()),
        ));
  }

  Future<dynamic> confirmUpdate(
      {required BuildContext newcontext,
      required EOvertimeState state,
      required List<Employee> operator,
      required String loginid,
      required String empid,
      required String wsid,
      required String starttime,
      required String endtime,
      required String token,
      required String remark,
      required List<Outsource> productselectedList}) {
    return showDialog(
      context: newcontext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: const Text("Do you want to submit Overtime?",
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.error)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(
                      color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
                )),
            QuickFixUi.horizontalSpace(width: 180),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.greenTheme)),
                onPressed: () async {
                  String response =
                      await EmployeeRepository.sendEmpOvertimeData(
                          loginid: loginid,
                          empid: empid,
                          wsid: wsid,
                          starttime: starttime,
                          endtime: endtime,
                          token: token,
                          remark: remark,
                          productselectedList: productselectedList);

                  if (response == 'Inserted successfully') {
                    Navigator.of(context).pop();
                    final blocprovider =
                        BlocProvider.of<EOvertimeBLoc>(newcontext);
                    // blocprovider.add(EOvertimeInitialEvent());

                    Future.delayed(const Duration(milliseconds: 100), () {
                      blocprovider.add(EOvertimeEvent(
                        operator: operator,
                        empovertimews: [],
                        employeeid: empid,
                        wsid: '',
                        token: token,
                        empovertimedata: [],
                        remark: '',
                        selectedtoollist: [],
                        option: view,
                        fromDate: '',
                        toDate: '',
                        subList: [],
                        item: empt,
                        isCheckVal: false,
                        productselectedList: [],
                        viewdetailsid: '',
                      ));
                    });
                  }
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                      color: AppColors.whiteTheme, fontWeight: FontWeight.bold),
                ))
            //})
          ],
        );
      },
    );
  }

  CustomDataTable viewdetails({required List<EODdetails> detailsproductList}) {
    return CustomDataTable(
        columnNames: const [
          'SrNo',
          'PO',
          'Product',
          'LineItem',
          'Seqno',
          'instruction'
        ],
        rows: detailsproductList
            .map((e) => DataRow(cells: [
                  DataCell(Text('${detailsproductList.indexOf(e) + 1}')),
                  DataCell(Text(e.pono!)),
                  DataCell(Text(e.productcode!)),
                  DataCell(Text(e.lineitem.toString())),
                  DataCell(Text(e.seqno.toString())),
                  DataCell(Text(e.instruction!)),
                ]))
            .toList());
  }
}
