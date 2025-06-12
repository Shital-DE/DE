// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/ppc/product_resource_management/product_resource_management_bloc.dart';
import '../../../../bloc/ppc/product_resource_management/product_resource_management_event.dart';
import '../../../../bloc/ppc/product_resource_management/product_resource_management_state.dart';
import '../../../../services/model/product/product_resource_management_model.dart';
import '../../../../services/repository/common/documents_repository.dart';
import '../../../../services/repository/product/product_resource_management_repo.dart';
import '../../../../services/session/user_login.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common/quickfix_widget.dart';
import '../../../widgets/table/custom_table.dart';
import '../../common/documents.dart';
import '../../common/prm_common.dart';

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Unverified machine programs ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class VerifyMachinePrograms extends StatelessWidget {
  const VerifyMachinePrograms({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider =
        BlocProvider.of<ProductResourceManagementBloc>(context);
    blocProvider.add(VerifyMachineProgramEvent());
    return BlocBuilder<ProductResourceManagementBloc,
        ProductResourceManagementState>(
      builder: (context, state) {
        if (state is UploadMachineProgramInitialState) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else if (state is VerifyMachineProgramState &&
            state.unVerifiedPrograms.isNotEmpty) {
          double tableWidth = MediaQuery.of(context).size.width,
              rowHeight = 50,
              tableHeight = (state.unVerifiedPrograms.length +
                      (state.unVerifiedPrograms.length < 12 ? 1 : 2)) *
                  rowHeight;
          return Container(
            width: tableWidth,
            height: tableHeight,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: CustomTable(
              tablewidth: tableWidth,
              tableheight: tableHeight - 5,
              columnWidth: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.width > 1300 ? 11.3 : 11.3),
              rowHeight: rowHeight,
              enableRowBottomBorder: true,
              tableheaderColor: Theme.of(context).primaryColorLight,
              tablebodyColor: Theme.of(context).colorScheme.surface,
              tableOutsideBorder: true,
              headerBorderThickness: .9,
              tableBorderColor: Theme.of(context).primaryColorDark,
              headerStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
              column: [
                ColumnData(width: 50, label: 'Index'),
                ColumnData(width: 202, label: 'Action'),
                ColumnData(label: 'Product'),
                ColumnData(label: 'Revision'),
                ColumnData(label: 'Workcentre'),
                ColumnData(label: 'Workstation'),
                ColumnData(label: 'Sequence No.'),
                ColumnData(label: 'Instruction'),
                ColumnData(label: 'File Name'),
                ColumnData(label: 'Uploader Name'),
                ColumnData(label: 'Uploaded Date'),
              ],
              rows: state.unVerifiedPrograms.map((e) {
                String filename = '';
                if (e.remark != null) {
                  if (e.remark.toString().contains(r'\')) {
                    List<String> parts = e.remark.toString().split(r'\');
                    filename = parts.last;
                  } else {
                    filename = e.remark.toString();
                  }
                }
                return RowData(cell: [
                  TableDataCell(
                      width: 50,
                      label: Text((((state.unVerifiedPrograms.indexOf(e)) +
                                  (50 * (state.index - 1))) +
                              1)
                          .toString())),
                  TableDataCell(
                      width: 202,
                      label: actionColumn(
                          e: e,
                          state: state,
                          context: context,
                          blocProvider: blocProvider)),
                  TableDataCell(label: Text(e.product.toString())),
                  TableDataCell(label: Text(e.revision.toString())),
                  TableDataCell(
                      label: Text(e.workcentre.toString().toUpperCase())),
                  TableDataCell(
                      label: Text(e.workstation.toString().toUpperCase())),
                  TableDataCell(label: Text(e.processSeqnumber.toString())),
                  TableDataCell(
                      label: Container(
                          padding: const EdgeInsets.only(top: 5, bottom: 7),
                          child: Text(e.instruction == null
                              ? ''
                              : e.instruction.toString()))),
                  TableDataCell(
                      label: Container(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 7),
                    child: Text(filename),
                  )),
                  TableDataCell(label: Text(e.uploader.toString())),
                  TableDataCell(
                      label: Column(
                    children: [
                      Text(DateTime.parse(e.updatedon.toString())
                          .toLocal()
                          .toString()
                          .substring(0, 10)),
                      Text(DateTime.parse(e.updatedon.toString())
                          .toLocal()
                          .toString()
                          .substring(11, 19)),
                    ],
                  )),
                ]);
              }).toList(),
              footer: state.unVerifiedPrograms.length < 50
                  ? const SizedBox(
                      height: .1,
                    )
                  : SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          state.index > 1
                              ? InkWell(
                                  onTap: () {
                                    blocProvider.add(VerifyMachineProgramEvent(
                                        index: state.index - 1));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 18,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      Text(
                                        'Back',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ))
                              : const Text(''),
                          state.unVerifiedPrograms.length == 50
                              ? InkWell(
                                  onTap: () {
                                    blocProvider.add(VerifyMachineProgramEvent(
                                        index: state.index + 1));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ],
                                  ))
                              : const Text('')
                        ],
                      ),
                    ),
            ),
          );
        } else {
          return const Center(
              child: Text('Programs are not available for verification'));
        }
      },
    );
  }

  Row actionColumn(
      {required UnVerifiedMachinePrograms e,
      required VerifyMachineProgramState state,
      required BuildContext context,
      required ProductResourceManagementBloc blocProvider}) {
    return Row(
      children: [
        Platform.isAndroid
            ? QuickFixUi.horizontalSpace(width: 10)
            : QuickFixUi.horizontalSpace(width: 20),
        e.pdfmdocId != null
            ? IconButton(
                onPressed: () async {
                  final docData = await DocumentsRepository()
                      .documents(state.token, e.pdfmdocId.toString());
                  if (docData != null) {
                    if (Platform.isAndroid) {
                      Documents().pdf(context, docData, e.product.toString(),
                          e.remark.toString(), e.revision.toString());
                    } else {
                      Documents().models(docData, e.product.toString(),
                          e.remark.toString(), '.pdf'.toString());
                    }
                  }
                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Theme.of(context).colorScheme.error,
                ))
            : const Stack(),
        viewPrograms(
            state: state, unVerifiedMachinePrograms: e, context: context),
        verifyProgramsButton(
            state: state,
            unVerifiedMachinePrograms: e,
            blocProvider: blocProvider,
            context: context),
        ProgramsVerificationCommon().deleteProgramButton(
            context: context,
            token: state.token,
            pdProductFolderTableId: e.id.toString(),
            mdocId: e.programmdocId.toString(),
            blocProvider: blocProvider,
            index: 0)
      ],
    );
  }

  IconButton verifyProgramsButton(
      {required VerifyMachineProgramState state,
      required UnVerifiedMachinePrograms unVerifiedMachinePrograms,
      required ProductResourceManagementBloc blocProvider,
      required BuildContext context}) {
    return IconButton(
      onPressed: () async {
        String response = await ProductResourceManagementRepository()
            .verifyMachinePrograms(token: state.token, payload: {
          'verify': true,
          'verifyby': state.userId,
          'id': unVerifiedMachinePrograms.id
        });
        if (response == 'Updated successfully') {
          blocProvider.add(VerifyMachineProgramEvent());
          QuickFixUi.successMessage('Program verified.', context);
        }
      },
      icon: const Icon(
        Icons.verified_user_rounded,
        color: AppColors.greenTheme,
      ),
    );
  }

  IconButton viewPrograms(
      {required VerifyMachineProgramState state,
      required UnVerifiedMachinePrograms unVerifiedMachinePrograms,
      required BuildContext context}) {
    return IconButton(
      onPressed: () async {
        await ProgramsVerificationCommon().viewMachineProgramsFromDatabase(
            token: state.token,
            mdocId: unVerifiedMachinePrograms.programmdocId.toString(),
            remark: unVerifiedMachinePrograms.remark.toString(),
            product: unVerifiedMachinePrograms.product.toString(),
            context: context);
      },
      icon: Icon(
        Icons.visibility,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Verified machine programs ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class VerifiedMachinePrograms extends StatelessWidget {
  const VerifiedMachinePrograms({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider =
        BlocProvider.of<ProductResourceManagementBloc>(context);
    blocProvider.add(VerifiedMachineProgramEvent());
    return Center(child: BlocBuilder<ProductResourceManagementBloc,
        ProductResourceManagementState>(builder: (context, state) {
      if (state is UploadMachineProgramInitialState) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else if (state is VerifiedMachineProgramsState &&
          state.verifiedMachinePrograms.isNotEmpty) {
        double tableWidth = MediaQuery.of(context).size.width,
            rowHeight = 50,
            tableHeight = (state.verifiedMachinePrograms.length +
                    (state.verifiedMachinePrograms.length < 12 ? 1 : 2)) *
                rowHeight;
        return Column(
          children: [
            Container(
              width: tableWidth,
              height: MediaQuery.of(context).size.height -
                  (Platform.isAndroid ? 175 : 150),
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: CustomTable(
                tablewidth: tableWidth,
                tableheight: tableHeight - 5,
                columnWidth: tableWidth /
                    (Platform.isAndroid
                        ? 10.8
                        : MediaQuery.of(context).size.width > 1300
                            ? 10.2
                            : 10.9),
                rowHeight: rowHeight,
                enableRowBottomBorder: true,
                tableheaderColor: Theme.of(context).colorScheme.errorContainer,
                tablebodyColor: Theme.of(context).colorScheme.surface,
                tableOutsideBorder: true,
                headerBorderThickness: .9,
                tableBorderColor: Theme.of(context).colorScheme.error,
                headerStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                column: [
                  ColumnData(width: 50, label: 'Index'),
                  ColumnData(width: 150, label: 'Action'),
                  ColumnData(label: 'Product'),
                  ColumnData(label: 'Revision'),
                  ColumnData(label: 'Workcentre'),
                  ColumnData(label: 'Workstation'),
                  ColumnData(label: 'Sequence No.'),
                  ColumnData(label: 'Instruction'),
                  ColumnData(label: 'File Name'),
                  ColumnData(label: 'Verifier'),
                  ColumnData(label: 'Verified Date'),
                ],
                rows: state.verifiedMachinePrograms.map((e) {
                  String filename = '';
                  if (e.remark != null) {
                    if (e.remark.toString().contains(r'\')) {
                      List<String> parts = e.remark.toString().split(r'\');
                      filename = parts.last;
                    } else {
                      filename = e.remark.toString();
                    }
                  }
                  return RowData(cell: [
                    TableDataCell(
                        width: 50,
                        label: Text(
                            (((state.verifiedMachinePrograms.indexOf(e)) +
                                        (50 * (state.index - 1))) +
                                    1)
                                .toString())),
                    TableDataCell(
                        width: 150,
                        label: actionColumn(
                            state: state,
                            e: e,
                            context: context,
                            blocProvider: blocProvider)),
                    TableDataCell(label: Text(e.product.toString())),
                    TableDataCell(label: Text(e.revision.toString())),
                    TableDataCell(
                        label: Text(e.workcentre.toString().toUpperCase())),
                    TableDataCell(
                        label: Text(e.workstation.toString().toUpperCase())),
                    TableDataCell(label: Text(e.processSeqnumber.toString())),
                    TableDataCell(
                        label: Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 7),
                            child: Text(e.instruction == null
                                ? ''
                                : e.instruction.toString()))),
                    TableDataCell(
                        label: Container(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 7),
                      child: Text(filename),
                    )),
                    TableDataCell(label: Text(e.verifier.toString())),
                    TableDataCell(
                        label: Column(children: [
                      Text(DateTime.parse(e.verificationdate.toString())
                          .toLocal()
                          .toString()
                          .substring(0, 10)),
                      Text(DateTime.parse(e.verificationdate.toString())
                          .toLocal()
                          .toString()
                          .substring(11, 19)),
                    ]))
                  ]);
                }).toList(),
                footer: state.verifiedMachinePrograms.length < 50
                    ? const Stack()
                    : Container(
                        height: 40,
                        width: tableWidth - 24,
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            state.index > 1
                                ? InkWell(
                                    onTap: () {
                                      blocProvider.add(
                                          VerifiedMachineProgramEvent(
                                              index: state.index - 1));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        Text(
                                          'Back',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                                : const Text(''),
                            state.verifiedMachinePrograms.length == 50
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: InkWell(
                                        onTap: () {
                                          blocProvider.add(
                                              VerifiedMachineProgramEvent(
                                                  index: state.index + 1));
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Next',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          ],
                                        )),
                                  )
                                : const Text('')
                          ],
                        ),
                      ),
              ),
            ),
          ],
        );
      } else if (state is VerifiedMachineProgramsState &&
          state.verifiedMachinePrograms.isEmpty) {
        return const Center(
          child: Text('Verified programs not available'),
        );
      } else {
        return const Stack();
      }
    }));
  }

  Row actionColumn(
      {required VerifiedMachineProgramsState state,
      required VerifiedMachineProgramsModel e,
      required BuildContext context,
      required ProductResourceManagementBloc blocProvider}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        e.mdocId != null
            ? IconButton(
                onPressed: () async {
                  await ProgramsVerificationCommon()
                      .viewMachineProgramsFromDatabase(
                          token: state.token,
                          mdocId: e.mdocId.toString(),
                          remark: e.remark.toString(),
                          product: e.product.toString(),
                          context: context);
                },
                icon: Icon(
                  Icons.visibility,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ))
            : const SizedBox(
                width: 50,
              ),
        IconButton(
            onPressed: () async {
              String response = await ProductResourceManagementRepository()
                  .verifyMachinePrograms(token: state.token, payload: {
                'verify': false,
                'verifyby': state.userId,
                'id': e.id
              });
              if (response == 'Updated successfully') {
                blocProvider.add(VerifiedMachineProgramEvent());
                QuickFixUi.successMessage('Program verified.', context);
              }
            },
            icon: Icon(
              Icons.cancel,
              color: Theme.of(context).colorScheme.error,
              size: 22,
            )),
        ProgramsVerificationCommon().deleteProgramButton(
            context: context,
            token: state.token,
            pdProductFolderTableId: e.id.toString(),
            mdocId: e.mdocId.toString(),
            blocProvider: blocProvider,
            index: 1)
      ],
    );
  }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ New Production product list +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class NewProductionProduct extends StatelessWidget {
  const NewProductionProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider =
        BlocProvider.of<ProductResourceManagementBloc>(context);
    blocProvider.add(NewProductionProductEvent());
    return Center(child: BlocBuilder<ProductResourceManagementBloc,
        ProductResourceManagementState>(builder: (context, state) {
      if (state is UploadMachineProgramInitialState) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else if (state is NewProductionproductState &&
          state.newProductionproduct.isNotEmpty) {
        double tableWidth = MediaQuery.of(context).size.width,
            rowHeight = 50,
            tableHeight = (state.newProductionproduct.length +
                    (state.newProductionproduct.length < 12 ? 1 : 2)) *
                rowHeight;
        return Column(
          children: [
            Container(
              width: tableWidth,
              height: MediaQuery.of(context).size.height -
                  (Platform.isAndroid ? 175 : 150),
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: CustomTable(
                tablewidth: tableWidth,
                tableheight: tableHeight,
                columnWidth: tableWidth /
                    (Platform.isAndroid
                        ? 9.3
                        : MediaQuery.of(context).size.width > 1300
                            ? 9.2
                            : 9.9),
                rowHeight: rowHeight,
                enableRowBottomBorder: true,
                tableheaderColor: Theme.of(context).colorScheme.errorContainer,
                tablebodyColor: Theme.of(context).colorScheme.surface,
                tableOutsideBorder: true,
                headerBorderThickness: .9,
                tableBorderColor: Theme.of(context).colorScheme.error,
                headerStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                column: [
                  ColumnData(width: 150, label: 'Index'),
                  ColumnData(width: 150, label: 'Action'),
                  ColumnData(label: 'Updatedon'),
                  ColumnData(label: 'Product'),
                  ColumnData(label: 'Revision'),
                  ColumnData(label: 'PO'),
                  ColumnData(label: 'PO_QTY'),
                  ColumnData(label: 'Workstation'),
                  ColumnData(width: 150, label: 'Employeename'),
                ],
                rows: state.newProductionproduct.map((e) {
                  return RowData(cell: [
                    TableDataCell(
                        width: 150,
                        label: Text((((state.newProductionproduct.indexOf(e)) +
                                    (50 * (state.index - 1))) +
                                1)
                            .toString())),
                    TableDataCell(
                        width: 150,
                        label: actionColumn(
                            state: state,
                            e: e,
                            context: context,
                            blocProvider: blocProvider)),
                    TableDataCell(
                        label: Column(children: [
                      Text(DateTime.parse(e.updatedon.toString())
                          .toLocal()
                          .toString()
                          .substring(0, 10)),
                      Text(DateTime.parse(e.updatedon.toString())
                          .toLocal()
                          .toString()
                          .substring(11, 19)),
                    ])),
                    TableDataCell(label: Text(e.product.toString())),
                    TableDataCell(label: Text(e.revision.toString())),
                    TableDataCell(
                        label: Text(e.ponumber.toString().toUpperCase())),
                    TableDataCell(
                        label: Text(e.poqty.toString().toUpperCase())),
                    TableDataCell(
                        label: Text(e.workstation.toString().toUpperCase())),
                    TableDataCell(
                        width: 150, label: Text(e.employeename.toString())),
                  ]);
                }).toList(),
                footer: state.newProductionproduct.length < 50
                    ? const Stack()
                    : SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            state.index > 1
                                ? InkWell(
                                    onTap: () {
                                      blocProvider.add(
                                          NewProductionProductEvent(
                                              index: state.index - 1));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        Text(
                                          'Back',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                                : const Text(''),
                            state.newProductionproduct.length == 50
                                ? InkWell(
                                    onTap: () {
                                      blocProvider.add(
                                          NewProductionProductEvent(
                                              index: state.index + 1));
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Next',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ],
                                    ))
                                : const Text('')
                          ],
                        ),
                      ),
              ),
            ),
          ],
        );
      } else if (state is NewProductionproductState &&
          state.newProductionproduct.isEmpty) {
        return const Center(
          child: Text('New Products not available'),
        );
      } else {
        return const Stack();
      }
    }));
  }

  Row actionColumn(
      {required NewProductionproductState state,
      required NewProductionProductmodel e,
      required BuildContext context,
      required ProductResourceManagementBloc blocProvider}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Platform.isAndroid
            ? QuickFixUi.horizontalSpace(width: 10)
            : QuickFixUi.horizontalSpace(width: 20),
        e.pdfmdocid != null
            ? IconButton(
                onPressed: () async {
                  final docData = await DocumentsRepository()
                      .documents(state.token, e.pdfmdocid.toString());
                  if (docData != null) {
                    if (Platform.isAndroid) {
                      Documents().pdf(context, docData, e.product.toString(),
                          e.description.toString(), e.revision.toString());
                    } else {
                      Documents().models(docData, e.product.toString(),
                          e.description.toString(), '.pdf'.toString());
                    }
                  }
                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Theme.of(context).colorScheme.error,
                ))
            : const Stack(),
        SizedBox(
          child: IconButton(
              onPressed: () async {
                confirmDelete(
                    newcontext: context,
                    state: state,
                    e: e,
                    blocProvider: blocProvider);
              },
              icon: Icon(
                Icons.delete,
                color: const Color.fromARGB(255, 235, 90, 90),
                size: Platform.isAndroid ? 25 : 20,
              )),
        ),
      ],
    );
  }

  Future<dynamic> confirmDelete(
      {required BuildContext newcontext,
      required NewProductionproductState state,
      required NewProductionProductmodel e,
      required ProductResourceManagementBloc blocProvider}) {
    return showDialog(
      context: newcontext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: const Text("Do you want to Delete?",
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
                  final saveddata = await UserData.getUserData();

                  String deleteresponce =
                      await ProductResourceManagementRepository()
                          .deleteNewproductionProduct(
                              token: saveddata['token'].toString(),
                              payload: {
                        'tableid': e.id.toString().trim(),
                      });

                  if (deleteresponce == 'Deleted successfully') {
                    Navigator.of(newcontext).pop();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      blocProvider.add(NewProductionProductEvent());
                      QuickFixUi.successMessage(
                          'Product deleted from list', context);
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
}
