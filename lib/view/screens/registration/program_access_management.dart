// Author : Shital Gayakwad
// Created Date : 28 May 2024
// Description : Program access management

// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/registration/program_access_management/pam_bloc.dart';
import '../../../bloc/registration/program_access_management/pam_event.dart';
import '../../../bloc/registration/program_access_management/pam_state.dart';
import '../../../services/model/registration/program_access_management_model.dart';
import '../../../services/repository/registration/program_access_management_repo.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../widgets/appbar.dart';
import '../../widgets/table/custom_table.dart';

class ProgramsAssignedToRoles extends StatefulWidget {
  const ProgramsAssignedToRoles({super.key});

  @override
  State<ProgramsAssignedToRoles> createState() =>
      _ProgramsAssignedToRolesState();
}

class _ProgramsAssignedToRolesState extends State<ProgramsAssignedToRoles> {
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<ProgramAccessManagementBloc>(context);
    blocProvider.add(PAMDetailsEvent());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: 'Program access management'),
      body: Center(child: BlocBuilder<ProgramAccessManagementBloc,
          ProgramAccessManagementState>(builder: (context, state) {
        if (state is PAMDetailsState) {
          return Container(
            width: size.width,
            height: size.height,
            margin: const EdgeInsets.all(10),
            child: CustomTable(
              tableheight: size.height - 20,
              tablewidth: size.width - 20,
              enableBorder: true,
              rowHeight: 45,
              tableOutsideBorder: true,
              tableheaderColor: Theme.of(context).colorScheme.errorContainer,
              tablebodyColor: Colors.white,
              headerStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold),
              tableBorderColor: Theme.of(context).colorScheme.error,
              column: [
                ColumnData(label: 'Role', width: 200),
                ColumnData(label: 'Employee Data', width: 270),
                ColumnData(
                  label: 'Programs in folder',
                  width: (size.width - 20) - 473,
                ),
              ],
              rows: state.programAccessManagementData.map((e) {
                return RowData(cell: [
                  TableDataCell(
                      width: 200,
                      height: rowHeight(e: e),
                      label: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(e.rolename == null
                                    ? ''
                                    : e.rolename.toString()),
                              ],
                            ),
                          ],
                        ),
                      )),
                  TableDataCell(
                      width: 270,
                      height: rowHeight(e: e),
                      label: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: e.userInfo != null
                                  ? e.userInfo!
                                      .map((newe) => newe.employeeName == null
                                          ? const SizedBox(
                                              height: .1,
                                            )
                                          : SizedBox(
                                              width: 270 - 30,
                                              height: 45,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(newe.employeeName
                                                      .toString()
                                                      .trim()),
                                                  IconButton(
                                                      onPressed: () async {
                                                        confirmUserDeletion(
                                                            context: context,
                                                            newe: newe,
                                                            e: e,
                                                            state: state,
                                                            blocProvider:
                                                                blocProvider);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error,
                                                      ))
                                                ],
                                              )))
                                      .toList()
                                  : [],
                            ),
                          ],
                        ),
                      )),
                  TableDataCell(
                    width: (size.width - 20) - 473,
                    height: rowHeight(e: e),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: e.folderInfo != null
                              ? e.folderInfo!
                                  .map((ele) => Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .errorContainer
                                            .withOpacity(.4),
                                        margin: const EdgeInsets.only(
                                            left: 7, right: 5, top: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 250,
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                    ele.foldername == null
                                                        ? ''
                                                        : ele.foldername
                                                            .toString())),
                                            SizedBox(
                                              width: ((size.width - 20) - 457) -
                                                  280,
                                              child: Column(
                                                children: ele.programsInFolder!
                                                    .map((element) => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              height: 45,
                                                              child: Text(
                                                                element
                                                                    .programname
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (newDialogContext) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              SizedBox(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                'Do you want to delete program ${element.programname.toString().trim()} which is assigned to the role ${e.rolename}?',
                                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            FilledButton(
                                                                                onPressed: () async {
                                                                                  String response = await ProgramAccessManagementRepository().deleteProgramFromRole(token: state.token, payload: {
                                                                                    'id': element.programRoleId.toString()
                                                                                  });
                                                                                  if (response == 'Updated successfully') {
                                                                                    blocProvider.add(PAMDetailsEvent());
                                                                                    Navigator.of(context).pop();
                                                                                    QuickFixUi.successMessage('Deleted successfully', context);
                                                                                  }
                                                                                },
                                                                                style: ButtonStyle(
                                                                                  backgroundColor: WidgetStateProperty.all<Color>(AppColors.redTheme),
                                                                                ),
                                                                                child: const Text('Yes')),
                                                                            FilledButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                style: ButtonStyle(
                                                                                  backgroundColor: WidgetStateProperty.all<Color>(AppColors.greenTheme),
                                                                                ),
                                                                                child: const Text('No'))
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error,
                                                                ))
                                                          ],
                                                        ))
                                                    .toList(),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                  .toList()
                              : [],
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        } else {
          return const Text('Data not found.');
        }
      })),
    );
  }

  Future<dynamic> confirmUserDeletion(
      {required BuildContext context,
      required UserInfo newe,
      required ProgramAccessManagementModel e,
      required PAMDetailsState state,
      required ProgramAccessManagementBloc blocProvider}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (newContext) {
          return AlertDialog(
            content: SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  'Do you want to delete this user (${newe.employeeName.toString().trim()}) from role ${e.rolename}?',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            actions: [
              FilledButton(
                  onPressed: () async {
                    String response = await ProgramAccessManagementRepository()
                        .deleteUserFromRole(
                            token: state.token,
                            payload: {'id': newe.userRoleId.toString()});
                    if (response == 'Updated successfully') {
                      blocProvider.add(PAMDetailsEvent());
                      Navigator.of(context).pop();
                      QuickFixUi.successMessage(
                          'Deleted successfully', context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.redTheme),
                  ),
                  child: const Text('Yes')),
              FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.greenTheme),
                  ),
                  child: const Text('No'))
            ],
          );
        });
  }

  double rowHeight({required ProgramAccessManagementModel e}) {
    double newHeight = 0, innerlistheight = 0;
    if (e.folderInfo == null) {
      if (e.userInfo == null) {
        newHeight = 55;
      } else {
        for (var user in e.userInfo!) {
          if (user.employeeName == null) {
            newHeight = 69;
          } else {
            newHeight = e.userInfo!.length * 69;
          }
        }
      }
    } else {
      for (var data in e.folderInfo!) {
        if (e.userInfo == null) {
          newHeight =
              e.folderInfo!.length * (data.programsInFolder!.length * 55);
        } else {
          if (e.userInfo!.length < e.folderInfo!.length) {
            for (var element in data.programsInFolder!) {
              element;
              innerlistheight = innerlistheight + 1;
            }
            newHeight = innerlistheight * 55;
          } else {
            newHeight = e.userInfo!.length * 57;
          }
        }
      }
    }
    return newHeight;
  }
}
