// Author : Shital Gayakwad
// Created Date : 12 March 2023
// Description : ERPX_PPC -> Machine registration
// Modified Date :

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/registration/machine_registration/machine_register_bloc.dart';
import '../../../services/model/registration/machine_registration_model.dart';
import '../../../services/repository/machine/machine_registration_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../../utils/responsive.dart';
import '../../widgets/appbar.dart';
import '../common/server.dart';

class MachineRegistration extends StatelessWidget {
  const MachineRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MachineRegisterBloc>(context).add(MachineScreenLoadingEvent(
        false, '', '', '', '', '', '', false, '', -1, ''));
    return Scaffold(
        appBar: CustomAppbar()
            .appbar(context: context, title: 'Machine Registration'),
        body: SingleChildScrollView(
          child: MakeMeResponsiveScreen(
              horixontaltab: Stack(
                children: [
                  workCentre(context, Alignment.center, Alignment.centerLeft,
                      800, 545, 400, 620),
                  registerWorkcentreForm(Alignment.topLeft, 700, 500, 480, 0),
                  workstations(Alignment.topLeft, 170, 430, 10)
                ],
              ),
              verticaltab: Stack(
                children: [
                  workCentre(
                    context,
                    Alignment.center,
                    Alignment.topCenter,
                    700,
                    500,
                    700,
                    450,
                  ),
                  registerWorkcentreForm(Alignment.center, 700, 500, 0, 480),
                  workstations(Alignment.center, 170, 10, 500)
                ],
              ),
              windows: Stack(
                children: [
                  workCentre(context, Alignment.center, Alignment.centerLeft,
                      800, 510, 400, 620),
                  registerWorkcentreForm(Alignment.topLeft, 700, 500, 480, 0),
                  workstations(Alignment.topLeft, 160, 430, 10)
                ],
              ),
              linux: const Text('Linux'),
              mobile: const Text('Mobile')),
        ));
  }

  Widget workCentre(
      BuildContext context,
      Alignment alignment,
      Alignment afterClickAlignment,
      double containerWidth,
      double containerHeight,
      double afterClickcontainerWidth,
      double afterClickcontainerHeight) {
    return BlocBuilder<MachineRegisterBloc, MachineRegisterState>(
      builder: (context, state) {
        if (state is MachineRegisterLoading) {
          return const Text('');
        }
        if (state is MachineErrorState) {
          if (state.errorMessage == 'Server unreachable') {
            return Container(
              margin: const EdgeInsets.only(top: 150),
              child: Server().serverUnreachable(
                  context: context, screenname: 'machine_registration'),
            );
          }
        }
        return Align(
          alignment: state is MachineLoaded &&
                  (state.isAddButtonClicked == true ||
                      state.isWorkstationVisible == true)
              ? afterClickAlignment
              : alignment,
          child: Container(
            width: state is MachineLoaded &&
                    (state.isAddButtonClicked == true ||
                        state.isWorkstationVisible == true)
                ? afterClickcontainerWidth
                : containerWidth,
            height: state is MachineLoaded &&
                    (state.isAddButtonClicked == true ||
                        state.isWorkstationVisible == true)
                ? afterClickcontainerHeight
                : containerHeight,
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 10,
              left: 10,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Stack(children: [
              state is MachineLoaded &&
                      (state.isAddButtonClicked == true ||
                          state.isWorkstationVisible == true)
                  ? const Text('')
                  : Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: FilledButton(
                          // buttonWidth: 100,
                          // buttonHeight: 40,
                          child: const Text('Add'),
                          onPressed: () {
                            BlocProvider.of<MachineRegisterBloc>(context).add(
                                MachineScreenLoadingEvent(true, '', '', '', '',
                                    '', '', false, '', -1, ''));
                          },
                        ),
                      ),
                    ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                          state is MachineLoaded &&
                                  (state.isAddButtonClicked == true ||
                                      state.isWorkstationVisible == true)
                              ? 'Workcentres'
                              : 'Workcentre Registration',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)))),
              Align(
                alignment: state is MachineLoaded
                    ? Alignment.topLeft
                    : Alignment.bottomCenter,
                child: Container(
                  width: 750,
                  height: state is MachineLoaded ? 900 : 420,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 120,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15),
                    itemCount: state is MachineLoaded
                        ? state.isinhouseWorkcentres.length
                        : null,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                state is MachineLoaded && state.index == index
                                    ? AppColors.greenTheme
                                    : AppColors.blueColor),
                        child: Center(
                          child: TextButton(
                            child: Text(
                              state is MachineLoaded
                                  ? state.isinhouseWorkcentres[index].code
                                      .toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              BlocProvider.of<MachineRegisterBloc>(context).add(
                                  MachineScreenLoadingEvent(
                                      false,
                                      state is MachineLoaded
                                          ? state
                                              .isinhouseWorkcentres[index].code
                                              .toString()
                                          : '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      true,
                                      state is MachineLoaded
                                          ? state.isinhouseWorkcentres[index].id
                                              .toString()
                                          : '',
                                      index,
                                      ''));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  Widget registerWorkcentreForm(Alignment alignment, double width,
      double height, double leftMargine, double topMargin) {
    return BlocBuilder<MachineRegisterBloc, MachineRegisterState>(
      builder: (context, state) {
        return Align(
            alignment: alignment,
            child: state is MachineLoaded && state.isAddButtonClicked == true
                ? Container(
                    width: width,
                    height: height,
                    margin: EdgeInsets.only(left: leftMargine, top: topMargin),
                    // color: Colors.amssber,
                    child: Container(
                      // color: Colors.green,
                      margin: const EdgeInsets.only(left: 100, right: 100),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                margin: const EdgeInsets.all(20),
                                child: const Text(
                                    'Workcentre Registration Form',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22))),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                margin: const EdgeInsets.only(top: 80),
                                child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Enter workcentre name',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onChanged: (value) {
                                      BlocProvider.of<MachineRegisterBloc>(
                                              context)
                                          .add(MachineScreenLoadingEvent(
                                              true,
                                              value.toString(),
                                              '',
                                              '',
                                              '',
                                              '',
                                              '',
                                              false,
                                              '',
                                              -1,
                                              ''));
                                    })),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                margin: const EdgeInsets.only(
                                  top: 150,
                                ),
                                child: DropdownSearch<ShiftPattern>(
                                  items: state.shiftPatternList,
                                  itemAsString: (item) => item.code.toString(),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          label: const Text(
                                              'Select shift pattern'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)))),
                                  onChanged: (value) {
                                    BlocProvider.of<MachineRegisterBloc>(
                                            context)
                                        .add(MachineScreenLoadingEvent(
                                            true,
                                            state.workcentre,
                                            value!.id.toString(),
                                            '',
                                            '',
                                            '',
                                            '',
                                            false,
                                            '',
                                            -1,
                                            ''));
                                  },
                                )),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                margin: const EdgeInsets.only(
                                  top: 220,
                                ),
                                child: DropdownSearch<Company>(
                                  items: state.companyList,
                                  itemAsString: (item) => item.code.toString(),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: const Text(
                                                      'Select company'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                  onChanged: (value) {
                                    BlocProvider.of<MachineRegisterBloc>(
                                            context)
                                        .add(MachineScreenLoadingEvent(
                                            true,
                                            state.workcentre,
                                            state.shiftPatternId,
                                            value!.id.toString(),
                                            value.code.toString(),
                                            '',
                                            '',
                                            false,
                                            '',
                                            -1,
                                            ''));
                                  },
                                )),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                margin: const EdgeInsets.only(top: 290),
                                child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Default minutes per day',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      BlocProvider.of<MachineRegisterBloc>(
                                              context)
                                          .add(MachineScreenLoadingEvent(
                                              true,
                                              state.workcentre,
                                              state.shiftPatternId,
                                              state.companyId,
                                              state.companyCode,
                                              value.toString(),
                                              '',
                                              false,
                                              '',
                                              -1,
                                              ''));
                                    })),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                margin: const EdgeInsets.only(top: 360),
                                child: DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                    disabledItemFn: (String s) =>
                                        s.startsWith('I'),
                                  ),
                                  items: const ["Y", "N"],
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  labelText: "Is in house",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                  onChanged: (String? val) {
                                    BlocProvider.of<MachineRegisterBloc>(
                                            context)
                                        .add(MachineScreenLoadingEvent(
                                            true,
                                            state.workcentre,
                                            state.shiftPatternId,
                                            state.companyId,
                                            state.companyCode,
                                            state.defaultmin,
                                            val.toString(),
                                            false,
                                            '',
                                            -1,
                                            ''));
                                  },
                                  selectedItem: "Y",
                                )),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  margin: const EdgeInsets.only(top: 440),
                                  child: FilledButton(
                                      child: const Text('Submit'),
                                      onPressed: () {
                                        if (state.workcentre == '') {
                                          return QuickFixUi.errorMessage(
                                              'Workcentre not found', context);
                                        } else if (state.shiftPatternId == '') {
                                          return QuickFixUi.errorMessage(
                                              'Shift pattern not found',
                                              context);
                                        } else if (state.companyId == '' &&
                                            state.companyCode == '') {
                                          return QuickFixUi.errorMessage(
                                              'Company name not found',
                                              context);
                                        } else if (state.defaultmin == '') {
                                          return QuickFixUi.errorMessage(
                                              'Default minutes not found',
                                              context);
                                        } else if (state.isinhouse == '') {
                                          return QuickFixUi.errorMessage(
                                              'Please select is in house or not',
                                              context);
                                        } else {
                                          MachineRegistrationRepository()
                                              .registerWorkcentre(
                                                  state.token,
                                                  state.workcentre,
                                                  state.shiftPatternId,
                                                  state.companyId,
                                                  state.companyCode,
                                                  state.defaultmin,
                                                  state.isinhouse,
                                                  context);
                                        }
                                      })))
                        ],
                      ),
                    )
                    // : const Text('Not an enough space for form visibility'),
                    )
                : const Text(''));
      },
    );
  }

  Widget workstations(
      Alignment alignment, double top, double leftMargine, double topMargin) {
    return BlocBuilder<MachineRegisterBloc, MachineRegisterState>(
      builder: (context, state) {
        return state is MachineLoaded && state.isWorkstationVisible == true
            ? Align(
                alignment: alignment,
                child: Container(
                    margin: EdgeInsets.only(left: leftMargine, top: topMargin),
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                              state.isWorkstationVisible == true
                                  ? '${state.workcentre.toString().trim()} workstations'
                                  : '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                      ),
                      Container(
                        height: 80,
                        margin: const EdgeInsets.only(top: 50, right: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: ListView.builder(
                            itemCount: state.workstationsList.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(right: 20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.workstationsList[index].code
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 500,
                          height: 370,
                          margin: EdgeInsets.only(
                            top: top,
                          ),
                          child: Stack(children: [
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Text('Workstation Registration',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: const EdgeInsets.only(top: 50),
                                    child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        controller: TextEditingController(
                                            text: state.isWorkstationVisible ==
                                                    true
                                                ? state.workcentre
                                                    .toString()
                                                    .trim()
                                                : ''),
                                        onChanged: (value) {}))),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: const EdgeInsets.only(top: 120),
                                    child: TextField(
                                        decoration: InputDecoration(
                                            hintText: 'Enter workstation name',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        onChanged: (value) {
                                          BlocProvider.of<MachineRegisterBloc>(
                                                  context)
                                              .add(
                                                  MachineScreenLoadingEvent(
                                                      false,
                                                      state.workcentre
                                                          .toString()
                                                          .trim(),
                                                      '',
                                                      '',
                                                      '',
                                                      '',
                                                      '',
                                                      true,
                                                      state.workcentreid
                                                          .toString()
                                                          .trim(),
                                                      state.index,
                                                      value.toString()));
                                        }))),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: const EdgeInsets.only(top: 190),
                                    child: DropdownSearch<ShiftPattern>(
                                      items: state.shiftPatternList,
                                      itemAsString: (item) =>
                                          item.code.toString(),
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                      label: const Text(
                                                          'Select shift pattern'),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)))),
                                      onChanged: (value) {
                                        BlocProvider.of<MachineRegisterBloc>(
                                                context)
                                            .add(
                                                MachineScreenLoadingEvent(
                                                    false,
                                                    state.workcentre
                                                        .toString()
                                                        .trim(),
                                                    value!.id.toString(),
                                                    '',
                                                    '',
                                                    '',
                                                    '',
                                                    true,
                                                    state.workcentreid
                                                        .toString()
                                                        .trim(),
                                                    state.index,
                                                    state.workstationcode));
                                      },
                                    ))),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: const EdgeInsets.only(top: 260),
                                    child: DropdownSearch<String>(
                                      popupProps: PopupProps.menu(
                                        showSelectedItems: true,
                                        disabledItemFn: (String s) =>
                                            s.startsWith('I'),
                                      ),
                                      items: const ["Y", "N"],
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                      labelText: "Is in house",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)))),
                                      onChanged: (String? val) {
                                        BlocProvider.of<MachineRegisterBloc>(
                                                context)
                                            .add(
                                                MachineScreenLoadingEvent(
                                                    false,
                                                    state.workcentre
                                                        .toString()
                                                        .trim(),
                                                    state.shiftPatternId
                                                        .toString(),
                                                    '',
                                                    '',
                                                    '',
                                                    val.toString(),
                                                    true,
                                                    state.workcentreid
                                                        .toString()
                                                        .trim(),
                                                    state.index,
                                                    state.workstationcode));
                                      },
                                      selectedItem: "Y",
                                    ))),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: const EdgeInsets.only(top: 330),
                                    child: FilledButton(
                                      child: const Text('Submit'),
                                      onPressed: () {
                                        if (state.workcentreid == '' &&
                                            state.workcentre == '') {
                                          return QuickFixUi.errorMessage(
                                              'Workcentre name not found',
                                              context);
                                        } else if (state.workstationcode ==
                                            '') {
                                          return QuickFixUi.errorMessage(
                                              'Workstation name not found',
                                              context);
                                        } else if (state.shiftPatternId == '') {
                                          return QuickFixUi.errorMessage(
                                              'Shift pattern id not found',
                                              context);
                                        } else if (state.isinhouse == '') {
                                          return QuickFixUi.errorMessage(
                                              'Defaultly selecting Yes',
                                              context);
                                        } else {
                                          MachineRegistrationRepository()
                                              .registerWorkstation(
                                                  state.workcentreid,
                                                  state.shiftPatternId,
                                                  state.workstationcode,
                                                  state.workcentre,
                                                  state.isinhouse,
                                                  state.token,
                                                  context);
                                        }
                                      },
                                    ))),
                          ]),
                        ),
                      )
                    ])))
            : const Text('');
      },
    );
  }
}
