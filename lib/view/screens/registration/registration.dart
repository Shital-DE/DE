// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/registration/registration_bloc.dart';
import '../../../routes/route_data.dart';
import '../../../routes/route_names.dart';
import '../../../services/model/user/user_model.dart';
import '../../../services/repository/registration/program_access_management_repo.dart';
import '../../../services/repository/user/user_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/common/quickfix_widget.dart';
import '../../../utils/responsive.dart';

class Registration extends StatelessWidget {
  final Map<String, dynamic> arguments;
  const Registration({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<RegistrationBloc>(context);
    blocProvider.add(RegistrationInitialEvent(folder: arguments['folder']));

    return Scaffold(
      body: MakeMeResponsiveScreen(
        horixontaltab:
            userRegistrationUi(crossAxisCount: 4, blocProvider: blocProvider),
        verticaltab:
            userRegistrationUi(crossAxisCount: 2, blocProvider: blocProvider),
        windows:
            userRegistrationUi(crossAxisCount: 4, blocProvider: blocProvider),
        linux: QuickFixUi.notVisible(),
        mobile: QuickFixUi.notVisible(),
      ),
      bottomNavigationBar: registrationBottomNavigation(
          context: context, blocProvider: blocProvider),
    );
  }

  BlocBuilder<RegistrationBloc, RegistrationState> userRegistrationUi(
      {required int crossAxisCount, required RegistrationBloc blocProvider}) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state is RegistrationLoadingState) {
          return Builder(builder: (context) {
            if (state.programsList.length < 2) {
              return defaultProgram(
                  state, context, blocProvider, crossAxisCount);
            } else {
              final element = state.programsList.elementAt(state.selectedIndex);
              if (element.programname == 'Employee Registration') {
                return employeeRegistrationWidget(
                    state: state,
                    context: context,
                    crossAxisCount: 3,
                    blocProvider: blocProvider);
              } else if (element.programname == 'User modules') {
                return userModulesWidget(
                    state: state,
                    context: context,
                    crossAxisCount: crossAxisCount,
                    blocProvider: blocProvider);
              } else if (element.programname == 'Machine Registration') {
                return RouteData.getRouteData(
                    context, RouteName.machineRegistration, {});
              } else if (element.programname == 'Tablet Registration') {
                return RouteData.getRouteData(
                    context, RouteName.tabletRegistration, {});
              } else if (element.programname ==
                  'Production related registration') {
                return RouteData.getRouteData(
                    context, RouteName.subcontractorRegistration, {});
              } else if (element.programname == 'Program access management') {
                return RouteData.getRouteData(
                    context, RouteName.programsAssignedToRoles, {});
              } else {
                return const Center(child: Text(''));
              }
            }
          });
        } else {
          return const Text('');
        }
      },
    );
  }

  defaultProgram(RegistrationLoadingState state, BuildContext context,
      RegistrationBloc blocProvider, int crossAxisCount) {
    if (state.programsList[0].programname.toString().trim() ==
        'Employee Registration') {
      return employeeRegistrationWidget(
          state: state,
          context: context,
          crossAxisCount: 3,
          blocProvider: blocProvider);
    } else if (state.programsList[0].programname.toString().trim() ==
        'User modules') {
      return userModulesWidget(
          state: state,
          context: context,
          crossAxisCount: crossAxisCount,
          blocProvider: blocProvider);
    } else if (state.programsList[0].programname.toString().trim() ==
        'Machine Registration') {
      return RouteData.getRouteData(context, RouteName.machineRegistration, {});
    } else if (state.programsList[0].programname.toString().trim() ==
        'Tablet Registration') {
      return RouteData.getRouteData(context, RouteName.tabletRegistration, {});
    } else if (state.programsList[0].programname.toString().trim() ==
        'Production related registration') {
      return RouteData.getRouteData(
          context, RouteName.subcontractorRegistration, {});
    } else if (state.programsList[0].programname.toString().trim() ==
        'Program access management') {
      return RouteData.getRouteData(
          context, RouteName.programsAssignedToRoles, {});
    } else {
      return const Center(child: Text(''));
    }
  }

  Center userModulesWidget(
      {required RegistrationLoadingState state,
      required BuildContext context,
      required int crossAxisCount,
      required RegistrationBloc blocProvider}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 200, right: 200, top: 100),
        child: GridView.count(
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.all(40.0),
          mainAxisSpacing: 40.0,
          crossAxisSpacing: 40.0,
          children: state.buttonList
              .map(
                (e) => InkWell(
                    onTap: () {
                      if (e == 'Register role') {
                        registerRole(
                            context: context,
                            state: state,
                            blocProvider: blocProvider);
                      } else if (e == 'Assign user role') {
                        assignUserRole(
                            context: context,
                            state: state,
                            blocProvider: blocProvider);
                      } else if (e == 'Register program') {
                        registerProgram(
                            context: context,
                            state: state,
                            blocProvider: blocProvider);
                      } else if (e == 'Register folder') {
                        registerFolder(
                            context: context,
                            state: state,
                            blocProvider: blocProvider);
                      } else if (e == 'Add program to folder') {
                        addProgramToFolder(
                            context: context,
                            state: state,
                            blocProvider: blocProvider);
                      } else if (e == 'Assign program to role') {
                        assignProgramsToRole(
                            context: context,
                            state: state,
                            blocProvider: blocProvider);
                      }
                    },
                    child: Container(
                      color: AppColors.blueColor,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyIconGenerator.getIcon(
                                name: e.toString(),
                                iconColor: AppColors.blackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              e,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
              .toList(),
        ),
      ),
    );
  }

  Center employeeRegistrationWidget(
      {required RegistrationLoadingState state,
      required BuildContext context,
      required int crossAxisCount,
      required RegistrationBloc blocProvider}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 300, right: 300, top: 100),
        child: GridView.count(
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.all(40.0),
          mainAxisSpacing: 40.0,
          crossAxisSpacing: 40.0,
          children: state.employeeRegistrationbuttonList
              .map(
                (e) => InkWell(
                    onTap: () {
                      if (e == 'Employee registration') {
                        Navigator.pushNamed(
                            context, RouteName.employeeRegistration);
                      } else if (e == 'Assign login credentials') {
                        assignLoginCredentials(
                            context: context,
                            state: state,
                            blocProvider: blocProvider);
                      } else if (e == 'Update employee details') {
                        Navigator.pushNamed(
                            context, RouteName.updateEmployeeDetails);
                      }
                    },
                    child: Container(
                      color: AppColors.blueColor,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyIconGenerator.getIcon(
                                name: e.toString(),
                                iconColor: AppColors.blackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              e,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<dynamic> assignProgramsToRole(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required RegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController roleid = TextEditingController();
        StreamController<bool> showListController =
            StreamController<bool>.broadcast();
        showListController.add(false);
        List<AllPrograms> selectedPrograms = [];
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assign program to role',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showListController.add(true);
                },
                child: StreamBuilder<bool>(
                    stream: showListController.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const Text('');
                      } else {
                        return const Text('View');
                      }
                    }),
              ),
            ],
          ),
          content: SizedBox(
              child: StreamBuilder<bool>(
                  stream: showListController.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return SizedBox(
                        width: 600,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.listOfProgramsAssignedToRole.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              margin: const EdgeInsets.all(2),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: Center(
                                      child: Text((index + 1).toString()),
                                    ),
                                  ),
                                  Container(
                                    width: 180,
                                    height: 40,
                                    margin: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(
                                        state
                                            .listOfProgramsAssignedToRole[index]
                                            .rolename
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: state
                                        .listOfProgramsAssignedToRole[index]
                                        .programNames!
                                        .asMap()
                                        .entries
                                        .map((e) {
                                      int i = e.key;
                                      String newValue = e.value;
                                      return Container(
                                        width: 270,
                                        margin: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 220,
                                              child: Text(
                                                newValue,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                String response =
                                                    await ProgramAccessManagementRepository()
                                                        .deleteProgramFromRole(
                                                            token: state.token,
                                                            payload: {
                                                      'id': state
                                                          .listOfProgramsAssignedToRole[
                                                              index]
                                                          .programIds![i]
                                                          .toString()
                                                    });
                                                if (response ==
                                                    'Updated successfully') {
                                                  blocProvider.add(
                                                    RegistrationInitialEvent(
                                                      folder: state.folder,
                                                      selectedIndex:
                                                          state.selectedIndex,
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                  QuickFixUi.successMessage(
                                                      response, context);
                                                }
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 150,
                        width: 400,
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DropdownSearch<EmployeeRole>(
                                  items: state.employeeRole,
                                  itemAsString: (item) =>
                                      item.rolename.toString(),
                                  popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label:
                                                      const Text('Select Role'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                  onChanged: (value) {
                                    roleid.text = value!.id.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DropdownSearch<AllPrograms>.multiSelection(
                                  items: state.allProgramsList,
                                  itemAsString: (item) =>
                                      item.programname.toString(),
                                  popupProps:
                                      const PopupPropsMultiSelection.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            style: TextStyle(fontSize: 18),
                                          )),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: const Text(
                                                      'Select programs'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                  onChanged: (value) {
                                    selectedPrograms = value;
                                  },
                                ),
                              ]),
                        ),
                      );
                    }
                  })),
          actions: [
            StreamBuilder<bool>(
                stream: showListController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return FilledButton(
                      onPressed: () {
                        showListController.add(false);
                      },
                      child: const Text('Back'),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                            onPressed: () async {
                              if (roleid.text == '') {
                                return QuickFixUi().showCustomDialog(
                                    errorMessage: 'Please select role',
                                    context: context);
                              } else if (selectedPrograms.isEmpty) {
                                return QuickFixUi().showCustomDialog(
                                    errorMessage:
                                        'Please select atleast 1 program',
                                    context: context);
                              } else {
                                String response = await UserRepository()
                                    .assignProgramToRole(
                                        token: state.token,
                                        createdby: state.empName,
                                        roleid: roleid.text,
                                        programs: selectedPrograms);
                                if (response.toString() ==
                                    'Inserted successfully') {
                                  roleid.dispose();
                                  Navigator.of(context).pop();
                                  blocProvider.add(RegistrationInitialEvent(
                                      folder: arguments['folder'],
                                      selectedIndex: state.selectedIndex));
                                  return QuickFixUi.successMessage(
                                      'Inserted successfully', context);
                                }
                              }
                            },
                            child: const Text('Register')),
                        const SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'))
                      ],
                    );
                  }
                })
          ],
        );
      },
    );
  }

  Future<dynamic> addProgramToFolder(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required RegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController folderid = TextEditingController();
        StreamController<bool> showListController =
            StreamController<bool>.broadcast();
        showListController.add(false);
        List<ProgramsNotInFolder> selectedPrograms = [];
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add program to folder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showListController.add(true);
                },
                child: StreamBuilder<bool>(
                    stream: showListController.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const Text('');
                      } else {
                        return const Text('View');
                      }
                    }),
              ),
            ],
          ),
          content: SizedBox(
              child: StreamBuilder<bool>(
                  stream: showListController.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return SizedBox(
                        width: 600,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.listOfProgramsInFolder.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              margin: const EdgeInsets.all(2),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: Center(
                                      child: Text((index + 1).toString()),
                                    ),
                                  ),
                                  Container(
                                    width: 180,
                                    height: 40,
                                    margin: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(
                                        state.listOfProgramsInFolder[index]
                                            .foldername
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: state
                                        .listOfProgramsInFolder[index]
                                        .programNames!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int i = entry.key;
                                      String e = entry.value;
                                      return Container(
                                        width: 270,
                                        margin: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: 220, child: Text(e)),
                                            IconButton(
                                              onPressed: () async {
                                                String response =
                                                    await UserRepository()
                                                        .deleteProgramsInFolder(
                                                  token: state.token.toString(),
                                                  payload: {
                                                    'id': state
                                                        .listOfProgramsInFolder[
                                                            index]
                                                        .programIds![i]
                                                  },
                                                );
                                                if (response ==
                                                    'Deleted successfully') {
                                                  blocProvider.add(
                                                    RegistrationInitialEvent(
                                                      folder: state.folder,
                                                      selectedIndex:
                                                          state.selectedIndex,
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                  QuickFixUi.successMessage(
                                                      response, context);
                                                }
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 150,
                        width: 400,
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DropdownSearch<AllFolders>(
                                  items: state.allFoldersList,
                                  itemAsString: (item) =>
                                      item.foldername.toString(),
                                  popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: const Text(
                                                      'Select Folder'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                  onChanged: (value) {
                                    folderid.text = value!.id.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DropdownSearch<
                                    ProgramsNotInFolder>.multiSelection(
                                  items: state.listOfProgramsNotInFolder,
                                  itemAsString: (item) =>
                                      item.programname.toString(),
                                  popupProps:
                                      const PopupPropsMultiSelection.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            style: TextStyle(fontSize: 18),
                                          )),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  label: const Text(
                                                      'Select programs'),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                  onChanged: (value) {
                                    selectedPrograms = value;
                                  },
                                ),
                              ]),
                        ),
                      );
                    }
                  })),
          actions: [
            StreamBuilder<bool>(
                stream: showListController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return FilledButton(
                      onPressed: () {
                        showListController.add(false);
                      },
                      child: const Text('Back'),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                            onPressed: () async {
                              if (folderid.text == '') {
                                return QuickFixUi().showCustomDialog(
                                    errorMessage: 'Please select folder',
                                    context: context);
                              } else if (selectedPrograms.isEmpty) {
                                return QuickFixUi().showCustomDialog(
                                    errorMessage:
                                        'Please select atleast 1 program',
                                    context: context);
                              } else {
                                String response = await UserRepository()
                                    .addProgramsToFolder(
                                        token: state.token,
                                        createdby: state.empName,
                                        folderid: folderid.text,
                                        programs: selectedPrograms);
                                if (response.toString() ==
                                    'Inserted successfully') {
                                  folderid.dispose();
                                  Navigator.of(context).pop();
                                  blocProvider.add(RegistrationInitialEvent(
                                      folder: arguments['folder'],
                                      selectedIndex: state.selectedIndex));
                                  return QuickFixUi.successMessage(
                                      'Inserted successfully', context);
                                }
                              }
                            },
                            child: const Text('Register')),
                        const SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'))
                      ],
                    );
                  }
                })
          ],
        );
      },
    );
  }

  Future<dynamic> registerFolder(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required RegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      builder: (context) {
        StreamController<bool> showListController =
            StreamController<bool>.broadcast();
        TextEditingController folder = TextEditingController();
        showListController.add(false);
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Register folder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showListController.add(true);
                },
                child: StreamBuilder<bool>(
                    stream: showListController.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const Text('');
                      } else {
                        return const Text('View');
                      }
                    }),
              ),
            ],
          ),
          content: SizedBox(
              width: 400,
              child: StreamBuilder<bool>(
                  stream: showListController.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return SizedBox(
                        height: 400,
                        child: ListView.builder(
                          itemCount: state.allFoldersList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              margin: const EdgeInsets.all(2),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 40,
                                    child: Center(
                                      child: Text((index + 1).toString()),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 295,
                                      child: Center(
                                        child: Text(state
                                            .allFoldersList[index].foldername
                                            .toString()),
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        String response = await UserRepository()
                                            .deleteFolder(
                                                token: state.token.toString(),
                                                payload: {
                                              'id': state
                                                  .allFoldersList[index].id
                                                  .toString()
                                            });
                                        if (response ==
                                            'Deleted successfully') {
                                          blocProvider.add(
                                              RegistrationInitialEvent(
                                                  folder: state.folder,
                                                  selectedIndex:
                                                      state.selectedIndex));
                                          Navigator.of(context).pop();
                                          QuickFixUi.successMessage(
                                              response, context);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 70,
                        child: Column(children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Folder name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              folder.text = value.toString();
                            },
                          ),
                        ]),
                      );
                    }
                  })),
          actions: [
            StreamBuilder<bool>(
                stream: showListController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return FilledButton(
                      onPressed: () {
                        showListController.add(false);
                      },
                      child: const Text('Back'),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                            onPressed: () async {
                              if (folder.text == '') {
                                return QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage: 'Folder name not found');
                              } else {
                                String valid = await UserRepository()
                                    .validateFolderRegistration(
                                        foldername: folder.text.toString(),
                                        token: state.token);
                                if (valid == 'not found') {
                                  final response = await UserRepository()
                                      .registerFolder(
                                          token: state.token,
                                          createdby: state.empName,
                                          foldername: folder.text);
                                  if (response.toString() ==
                                      'Inserted successfully') {
                                    folder.dispose();
                                    Navigator.of(context).pop();
                                    blocProvider.add(RegistrationInitialEvent(
                                        folder: arguments['folder'],
                                        selectedIndex: state.selectedIndex));
                                    return QuickFixUi.successMessage(
                                        'Inserted successfully', context);
                                  }
                                } else {
                                  QuickFixUi().showCustomDialog(
                                      context: context,
                                      errorMessage:
                                          'Folder $valid is already registered');
                                }
                              }
                            },
                            child: const Text('Register')),
                        const SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'))
                      ],
                    );
                  }
                })
          ],
        );
      },
    );
  }

  Future<dynamic> registerProgram(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required RegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController programname = TextEditingController();
        TextEditingController schemaname = TextEditingController();
        StreamController<bool> showListController =
            StreamController<bool>.broadcast();
        showListController.add(false);
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Register program',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showListController.add(true);
                },
                child: StreamBuilder<bool>(
                    stream: showListController.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const Text('');
                      } else {
                        return const Text('View');
                      }
                    }),
              ),
            ],
          ),
          content: SizedBox(
              width: 400,
              child: StreamBuilder<bool>(
                  stream: showListController.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return ListView.builder(
                        itemCount: state.allProgramsList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            margin: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 40,
                                  child: Center(
                                    child: Text((index + 1).toString()),
                                  ),
                                ),
                                SizedBox(
                                  width: 295,
                                  child: Center(
                                    child: Text(state
                                        .allProgramsList[index].programname
                                        .toString()),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      String response = await UserRepository()
                                          .deleteProgram(
                                              token: state.token.toString(),
                                              payload: {
                                            'id': state
                                                .allProgramsList[index].id
                                                .toString()
                                          });
                                      if (response == 'Deleted successfully') {
                                        blocProvider.add(
                                            RegistrationInitialEvent(
                                                folder: state.folder,
                                                selectedIndex:
                                                    state.selectedIndex));
                                        Navigator.of(context).pop();
                                        QuickFixUi.successMessage(
                                            response, context);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ))
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox(
                        height: 140,
                        child: Column(children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Program name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              programname.text = value.toString();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Schema name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              schemaname.text = value.toString();
                            },
                          )
                        ]),
                      );
                    }
                  })),
          actions: [
            StreamBuilder<bool>(
                stream: showListController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return FilledButton(
                      onPressed: () {
                        showListController.add(false);
                      },
                      child: const Text('Back'),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                            onPressed: () async {
                              if (programname.text == '') {
                                QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage: 'Program name not found');
                              } else if (schemaname.text == '') {
                                QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage: 'Program name not found');
                              } else {
                                String valid = await UserRepository()
                                    .validateProgramRegistration(
                                        programname:
                                            programname.text.toString(),
                                        token: state.token);
                                if (valid == 'not found') {
                                  final response = await UserRepository()
                                      .registerProgram(
                                          token: state.token,
                                          createdby: state.empName,
                                          programname: programname.text,
                                          schemaname: schemaname.text);
                                  if (response.toString() ==
                                      'Inserted successfully') {
                                    programname.clear();
                                    schemaname.clear();
                                    QuickFixUi.successMessage(
                                        'Inserted successfully', context);
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  QuickFixUi().showCustomDialog(
                                      context: context,
                                      errorMessage:
                                          'Program $valid is already registered');
                                }
                              }
                              blocProvider.add(RegistrationInitialEvent(
                                  folder: arguments['folder'],
                                  selectedIndex: state.selectedIndex));
                            },
                            child: const Text('Register')),
                        const SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                            onPressed: () {
                              // blocProvider.add(RegistrationInitialEvent(
                              //     folder: arguments['folder']));
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'))
                      ],
                    );
                  }
                })
          ],
        );
      },
    );
  }

  Future<dynamic> assignUserRole(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required RegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController user = TextEditingController();
        TextEditingController role = TextEditingController();

        return AlertDialog(
          title: const Text(
            'Assign role to user',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 150,
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownSearch<AllUsers>(
                  items: state.allusersList,
                  itemAsString: (item) => item.username.toString(),
                  popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(fontSize: 18),
                      )),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          label: const Text('Select user'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  onChanged: (value) {
                    user.text = value!.id.toString();
                  },
                ),
                DropdownSearch<EmployeeRole>(
                  items: state.employeeRole,
                  itemAsString: (item) => item.rolename.toString(),
                  popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(fontSize: 18),
                      )),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          label: const Text('Select role'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  onChanged: (value) {
                    role.text = value!.id.toString();
                  },
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
                onPressed: () async {
                  if (user.text == '') {
                    QuickFixUi().showCustomDialog(
                        context: context, errorMessage: 'Please select user');
                  } else if (role.text == '') {
                    QuickFixUi().showCustomDialog(
                        context: context, errorMessage: 'Please select role');
                  } else {
                    String valid = await UserRepository()
                        .validateRoleAssignedOrNot(
                            userid: user.text.toString(), token: state.token);
                    if (valid == 'not found') {
                      final response = await UserRepository().assignUserRole(
                          token: state.token,
                          createdby: state.empName,
                          userid: user.text,
                          roleid: role.text);

                      if (response.toString() == 'Inserted successfully') {
                        user.clear();
                        role.clear();
                        QuickFixUi.successMessage(
                            'Inserted successfully.', context);
                        user.dispose();
                        role.dispose();
                        Navigator.of(context).pop();
                      }
                    } else {
                      QuickFixUi().showCustomDialog(
                          context: context,
                          errorMessage:
                              'Role $valid is already assigned to this user.');
                    }
                    blocProvider.add(RegistrationInitialEvent(
                        folder: arguments['folder'],
                        selectedIndex: state.selectedIndex));
                  }
                },
                child: const Text('Assign')),
            FilledButton(
                onPressed: () {
                  user.dispose();
                  role.dispose();
                  // blocProvider.add(
                  //     RegistrationInitialEvent(folder: arguments['folder']));
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'))
          ],
        );
      },
    );
  }

  Future<dynamic> registerRole(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required RegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController userrole = TextEditingController();
        StreamController<bool> showListController =
            StreamController<bool>.broadcast();
        showListController.add(false);

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Register new role',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showListController.add(true);
                },
                child: StreamBuilder<bool>(
                    stream: showListController.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const Text('');
                      } else {
                        return const Text('View');
                      }
                    }),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: StreamBuilder<bool>(
              stream: showListController.stream,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: state.employeeRole.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          margin: const EdgeInsets.all(2),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 40,
                                child: Center(
                                  child: Text((index + 1).toString()),
                                ),
                              ),
                              SizedBox(
                                width: 295,
                                child: Center(
                                  child: Text(state.employeeRole[index].rolename
                                      .toString()),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    String response = await UserRepository()
                                        .deleteRole(
                                            token: state.token.toString(),
                                            payload: {
                                          'id': state.employeeRole[index].id
                                              .toString()
                                        });
                                    if (response == 'Deleted successfully') {
                                      blocProvider.add(RegistrationInitialEvent(
                                          folder: state.folder,
                                          selectedIndex: state.selectedIndex));
                                      Navigator.of(context).pop();
                                      QuickFixUi.successMessage(
                                          response, context);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                  ))
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return TextField(
                    decoration: InputDecoration(
                      hintText: 'User role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      userrole.text = value.toString();
                    },
                  );
                }
              },
            ),
          ),
          actions: [
            StreamBuilder<bool>(
                stream: showListController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return FilledButton(
                      onPressed: () {
                        showListController.add(false);
                      },
                      child: const Text('Back'),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            if (userrole.text == '') {
                              QuickFixUi().showCustomDialog(
                                  context: context,
                                  errorMessage: 'User role not found');
                            } else {
                              String valid = await UserRepository()
                                  .validateUserRole(
                                      rolename: userrole.text.toString(),
                                      token: state.token);
                              if (valid == 'user found') {
                                QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage:
                                        'This role is already registered');
                              } else {
                                confirmRoleRegistration(
                                    context: context,
                                    state: state,
                                    userrole: userrole,
                                    blocProvider: blocProvider,
                                    showListController: showListController);
                              }
                            }
                          },
                          child: const Text('Register'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FilledButton(
                          onPressed: () {
                            showListController.close();
                            userrole.dispose();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  }
                }),
          ],
        );
      },
    );
  }

  Future<dynamic> confirmRoleRegistration(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required TextEditingController userrole,
      required RegistrationBloc blocProvider,
      required StreamController<bool> showListController}) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (diaContext) {
          return AlertDialog(
            content: const SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  'Are you sure?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            actions: [
              FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.redTheme),
                  ),
                  child: const Text('No')),
              FilledButton(
                  onPressed: () async {
                    final response = await UserRepository()
                        .registerEmployeeRole(
                            token: state.token,
                            role: userrole.text.toString(),
                            createdby: state.empName);
                    if (response.toString() == 'Inserted successfully') {
                      userrole.clear();
                      QuickFixUi.successMessage(
                          'Inserted successfully', context);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                    blocProvider.add(RegistrationInitialEvent(
                        folder: arguments['folder'],
                        selectedIndex: state.selectedIndex));
                    showListController.close();
                    userrole.dispose();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.greenTheme),
                  ),
                  child: const Text('Yes'))
            ],
          );
        });
  }

  Future<dynamic> assignLoginCredentials(
      {required BuildContext context,
      required RegistrationLoadingState state,
      required RegistrationBloc blocProvider}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController mobileno = TextEditingController();
        TextEditingController empId = TextEditingController();
        StreamController<String> username =
            StreamController<String>.broadcast();
        StreamController<String> password =
            StreamController<String>.broadcast();
        return AlertDialog(
          title: const Text(
            """Create employee's username and password""",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 220,
            width: 400,
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownSearch<EmployeeName>(
                    items: state.employeeName,
                    itemAsString: (item) => item.employeename.toString(),
                    popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: TextStyle(fontSize: 18),
                        )),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            label: const Text('Select employee'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    onChanged: (value) {
                      mobileno.text = value!.mobile.toString();
                      empId.text = value.id.toString();
                      username.add(
                        value.employeeusername.toString().trim(),
                      );
                      password
                          .add(value.employeeuserpassword.toString().trim());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<String>(
                      stream: username.stream,
                      builder: (context, snapshot) {
                        return TextField(
                          decoration: InputDecoration(
                              hintText: snapshot.data == null
                                  ? ''
                                  : snapshot.data.toString(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onTap: () {
                            username.add(
                              '',
                            );
                          },
                          onChanged: (value) {
                            username.add(
                              value.toString().trim(),
                            );
                          },
                        );
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<String>(
                      stream: password.stream,
                      builder: (context, snapshot) {
                        return TextField(
                          decoration: InputDecoration(
                              hintText: snapshot.data == null
                                  ? ''
                                  : snapshot.data.toString(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.number,
                          onTap: () {
                            password.add(
                              '',
                            );
                          },
                          onChanged: (value) {
                            password.add(value.toString().trim());
                          },
                        );
                      })
                ],
              ),
            ),
          ),
          actions: [
            StreamBuilder<String>(
                stream: username.stream,
                builder: (context, snapshotuser) {
                  return StreamBuilder<String>(
                      stream: password.stream,
                      builder: (context, snapshotpass) {
                        return FilledButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              // if (mobileno.text == '') {
                              //   QuickFixUi().showCustomDialog(
                              //       context: context,
                              //       errorMessage: 'Select employee first');
                              // }
                              // else
                              if (snapshotuser.data == '') {
                                QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage: 'Username not found');
                              } else if (snapshotpass.data == '') {
                                QuickFixUi().showCustomDialog(
                                    context: context,
                                    errorMessage: 'Password not found');
                              } else {
                                String valid = await UserRepository()
                                    .validateUsername(
                                        username: snapshotuser.data.toString(),
                                        token: state.token);
                                if (valid == 'user found') {
                                  QuickFixUi().showCustomDialog(
                                      context: context,
                                      errorMessage:
                                          'Already registered this username. \nPlease choose a different username.');
                                } else {
                                  final response = await UserRepository()
                                      .createLoginCredential(
                                          createdby: state.empName,
                                          username:
                                              snapshotuser.data.toString(),
                                          password:
                                              snapshotpass.data.toString(),
                                          mobileno: mobileno.text,
                                          token: state.token,
                                          empId: empId.text);
                                  if (response.toString() ==
                                      'Inserted successfully') {
                                    blocProvider.add(RegistrationInitialEvent(
                                        folder: arguments['folder'],
                                        selectedIndex: state.selectedIndex));
                                    QuickFixUi.successMessage(
                                        'Inserted successfully', context);
                                    mobileno.dispose();
                                    username.close();
                                    password.close();
                                    navigator.pop();
                                  }
                                }
                              }
                            },
                            child: const Text('Create'));
                      });
                }),
            FilledButton(
                onPressed: () {
                  mobileno.dispose();
                  username.close();
                  password.close();
                  // blocProvider.add(
                  //     RegistrationInitialEvent(folder: arguments['folder']));
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'))
          ],
        );
      },
    );
  }

  registrationBottomNavigation(
      {required BuildContext context, required RegistrationBloc blocProvider}) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state is RegistrationLoadingState &&
            state.programsList.length >= 2) {
          return NavigationBar(
              selectedIndex: state.selectedIndex,
              onDestinationSelected: (value) {
                blocProvider.add(RegistrationInitialEvent(
                    folder: state.folder, selectedIndex: value));
              },
              destinations: state.programsList
                  .map((e) => NavigationDestination(
                        icon: MyIconGenerator.getIcon(
                            name: e.programname.toString(),
                            iconColor: Colors.black),
                        label: e.programname.toString(),
                      ))
                  .toList());
        } else {
          return const Text('');
        }
      },
    );
  }
}
