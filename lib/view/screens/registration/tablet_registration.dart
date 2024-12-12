// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> Tablet registration
// Modified Date : 3 Sept 2023

// ignore_for_file: use_build_context_synchronously
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/registration/tablet_registration/tablet_bloc.dart';
import '../../../bloc/registration/tablet_registration/tablet_event.dart';
import '../../../services/model/machine/workcentre.dart';
import '../../../services/model/machine/workstation.dart';
import '../../../services/repository/common/tablet_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../../utils/responsive.dart';
import '../../widgets/appbar.dart';
import '../../widgets/table/custom_table.dart';

class TabletRegistration extends StatelessWidget {
  const TabletRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<TabletBloc>(context);
    blocProvider.add(TabletFormEvent());
    return MakeMeResponsiveScreen(
      horixontaltab: Scaffold(
        appBar: CustomAppbar()
            .appbar(context: context, title: 'Tablet Registration'),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              tabletRegister(blocProvider: blocProvider),
              QuickFixUi.horizontalSpace(width: 30),
              backbutton(blocProvider),
              allTabletDataTable(blocProvider: blocProvider)
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<TabletBloc, TabletState> backbutton(TabletBloc blocProvider) {
    return BlocBuilder<TabletBloc, TabletState>(
      builder: (context, state) {
        if (state is TabletLoaded &&
            state.checkALreadyRegisteredTabletList == true) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: IconButton(
                    onPressed: () {
                      blocProvider.add(TabletFormEvent());
                    },
                    icon: Icon(
                      Icons.arrow_circle_left,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
              ),
            ],
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<TabletBloc, TabletState> allTabletDataTable(
      {required TabletBloc blocProvider}) {
    return BlocBuilder<TabletBloc, TabletState>(
      builder: (context, state) {
        if (state is TabletLoaded &&
            state.checkALreadyRegisteredTabletList == true) {
          return SizedBox(
            width: 600,
            height: 550,
            child: CustomTable(
                tablewidth: 600,
                tableheight: 550,
                columnWidth: 200,
                enableRowBottomBorder: true,
                rowHeight: 50,
                column: [
                  ColumnData(label: 'Workcentre'),
                  ColumnData(label: 'Workstation'),
                  ColumnData(label: 'Action')
                ],
                rows: state.allTabAssignedList
                    .map((e) => RowData(cell: [
                          TableDataCell(
                              label: Text(
                            e.workcentre.toString(),
                            textAlign: TextAlign.center,
                          )),
                          TableDataCell(
                              label: Text(
                            e.workstation.toString(),
                            textAlign: TextAlign.center,
                          )),
                          TableDataCell(
                              label: e.androidId == null
                                  ? const Text(
                                      'Not Assigned',
                                      textAlign: TextAlign.end,
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const SizedBox(
                                                height: 25,
                                                child: Center(
                                                    child: Text(
                                                  'Do you want to delete it?',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                )),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateColor
                                                              .resolveWith(
                                                                  (states) =>
                                                                      AppColors
                                                                          .redTheme),
                                                    ),
                                                    onPressed: () async {
                                                      final cont =
                                                          Navigator.of(context);
                                                      String response =
                                                          await TabletRepository()
                                                              .deleteTablet(
                                                                  token: state
                                                                      .token,
                                                                  payload: {
                                                            'id':
                                                                e.id.toString()
                                                          });
                                                      if (response ==
                                                          'Deleted successfully') {
                                                        blocProvider.add(
                                                            TabletFormEvent());
                                                        cont.pop();
                                                        QuickFixUi
                                                            .successMessage(
                                                                response,
                                                                context);
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .whiteTheme,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateColor
                                                              .resolveWith(
                                                                  (states) =>
                                                                      AppColors
                                                                          .greenTheme),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .whiteTheme,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      color: AppColors.redTheme,
                                      iconSize: 30,
                                      icon: const Icon(Icons.delete))),
                        ]))
                    .toList()),
          );
        } else {
          return const Stack();
        }
      },
    );
  }

  BlocBuilder<TabletBloc, TabletState> tabletRegister(
      {required TabletBloc blocProvider}) {
    return BlocBuilder<TabletBloc, TabletState>(
      builder: (context, state) {
        if (state is TabletLoaded &&
            state.checkALreadyRegisteredTabletList == false) {
          String androidId = '';
          for (var data in state.checkTabIsAssignedList) {
            androidId = data.androidId.toString().trim();
          }
          return Container(
            width: 400,
            margin: const EdgeInsets.only(top: 200),
            child: ListView(
              children: [
                Container(
                    width: 400,
                    height: 45,
                    decoration:
                        QuickFixUi().borderContainer(borderThickness: .5),
                    child: Center(
                      child: Text(
                        state.androidId,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                QuickFixUi.verticalSpace(height: 10),
                Container(
                  decoration: QuickFixUi().borderContainer(borderThickness: .5),
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownSearch<Workcentre>(
                    items: state.workcentreList,
                    itemAsString: (item) => item.code.toString(),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Select workcentre')),
                    popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps()),
                    onChanged: (value) {
                      blocProvider.add(
                          TabletFormEvent(workcentreId: value!.id.toString()));
                    },
                  ),
                ),
                QuickFixUi.verticalSpace(height: 10),
                Container(
                  decoration: QuickFixUi().borderContainer(borderThickness: .5),
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownSearch<WorkstationByWorkcentreId>(
                    items: state.workstationList,
                    itemAsString: (item) => item.code.toString(),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Select workstation')),
                    popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps()),
                    onChanged: (value) {
                      blocProvider.add(TabletFormEvent(
                          workcentreId: state.workcentreId,
                          workstationId: value!.id.toString()));
                    },
                  ),
                ),
                QuickFixUi.verticalSpace(height: 10),
                (state.checkTabIsAssignedList.isNotEmpty && androidId != 'null')
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'This tab is already assigned',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          TextButton(
                              onPressed: () {
                                blocProvider.add(TabletFormEvent(
                                    workcentreId: state.workcentreId,
                                    workstationId: state.workstationId,
                                    checkALreadyRegisteredTabletList: true));
                              },
                              child: const Text('Check'))
                        ],
                      )
                    : const Stack(),
                (state.checkTabIsAssignedList.isNotEmpty && androidId != 'null')
                    ? const Stack()
                    : QuickFixUi.verticalSpace(height: 10),
                SizedBox(
                  width: 300,
                  child: FilledButton(
                      onPressed: () async {
                        if (state.androidId == '') {
                          QuickFixUi.errorMessage(
                              'Android id not found', context);
                        } else if (state.workcentreId == '') {
                          QuickFixUi.errorMessage(
                              'Please select workcentre first.', context);
                        } else if (state.workstationId == '') {
                          QuickFixUi.errorMessage(
                              'Please select workstation first', context);
                        } else {
                          String androidId = '';
                          for (var data in state.checkTabIsAssignedList) {
                            androidId = data.androidId.toString().trim();
                          }
                          if (state.checkTabIsAssignedList.isNotEmpty &&
                              androidId != 'null') {
                            return QuickFixUi.errorMessage(
                                'Tab is already assigned', context);
                          } else {
                            await TabletRepository().registerTablet(
                                context,
                                state.androidId,
                                state.workcentreId,
                                state.workstationId,
                                state.token);
                            blocProvider.add(TabletFormEvent(
                                workcentreId: state.workcentreId,
                                workstationId: state.workstationId));
                          }
                        }
                      },
                      child: const Text('Submit')),
                )
              ],
            ),
          );
        } else {
          return const Stack();
        }
      },
    );
  }
}
