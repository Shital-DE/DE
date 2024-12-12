// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart' as newexcel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/common_mail/mails/common_mails_bloc.dart';
import '../../../bloc/common_mail/mails/common_mails_event.dart';
import '../../../bloc/common_mail/mails/common_mails_state.dart';
import '../../../services/repository/common/common_repository.dart';
import '../../../utils/common/quickfix_widget.dart';

import '../../widgets/table/custom_table.dart';

class BulkmailsModule extends StatelessWidget {
  const BulkmailsModule({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<CommonMailsBloc>(context);
    blocProvider.add(BulkmailsendEvent());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: CustomAppbar().appbar(context: context, title: 'Bulk Mails'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // QuickFixUi.verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  blocProvider.add(BulkmailsendEvent(excelData: []));
                  pickFile(blocProvider: blocProvider, context: context);
                },
                label: const Text(
                  'Pick Excel File',
                  style: TextStyle(
                    color: Color.fromARGB(255, 166, 213, 221),
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                icon: const Icon(Icons.attach_file),
              ),
            ],
          ),
          BlocBuilder<CommonMailsBloc, CommonMailState>(
              builder: (context, state) {
            if (state is UploadOrderState && state.excelData.isNotEmpty) {
              double rowHeight = 45, // tableheight = 99449;
                  tableheight = size.height - (Platform.isAndroid ? 230 : 190);
              return Container(
                color: Colors.green,
                width: size.width,
                height: tableheight - 10,
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: CustomTable(
                  tablewidth: size.width - 20,
                  tableheight:
                      ((state.excelData.length + 1.5) * rowHeight) > tableheight
                          ? tableheight
                          : ((state.excelData.length + 1.5) * rowHeight),
                  columnWidth: (size.width - 20) /
                      (state.rejectedOrders.isNotEmpty ? 6.7 : 6.2),
                  rowHeight: rowHeight,
                  showIndex: true,
                  headerStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                  tableheaderColor: Theme.of(context).colorScheme.surface,
                  tablebodyColor: Theme.of(context).colorScheme.surface,
                  tableBorderColor: Theme.of(context).primaryColor,
                  tableOutsideBorder: true,
                  enableRowBottomBorder: true,
                  enableHeaderBottomBorder: true,
                  headerBorderThickness: .8,
                  column: [
                    ColumnData(
                        width: state.rejectedOrders.isNotEmpty ? 100 : .1,
                        label: state.rejectedOrders.isNotEmpty ? 'Action' : ''),
                    ColumnData(label: state.excelData[0][1].toString()),
                    ColumnData(label: state.excelData[0][2].toString()),
                    ColumnData(label: state.excelData[0][3].toString()),
                    ColumnData(label: state.excelData[0][4].toString()),
                    ColumnData(label: state.excelData[0][5].toString()),
                    ColumnData(label: state.excelData[0][6].toString()),
                  ],
                  rows: state.excelData.skip(1).map((e) {
                    return RowData(cell: [
                      TableDataCell(
                          width: state.rejectedOrders.isNotEmpty ? 100 : .1,
                          label: state.rejectedOrders.isNotEmpty
                              ? isListPresentInList(e, state.rejectedOrders)
                                  ? const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                    )
                              : const Stack()),
                      TableDataCell(
                          label: Text(
                        e[1].toString(),
                        textAlign: TextAlign.center,
                      )),
                      TableDataCell(
                          label: Text(
                        e[2].toString(),
                        textAlign: TextAlign.center,
                      )),
                      TableDataCell(
                          label: Text(
                        e[3].toString(),
                        textAlign: TextAlign.center,
                      )),
                      TableDataCell(
                          label: Text(
                        e[4].toString(),
                        textAlign: TextAlign.center,
                      )),
                      TableDataCell(
                          label: Text(
                        e[5].toString(),
                        textAlign: TextAlign.center,
                      )),
                      TableDataCell(
                          label: Text(
                        e[6].toString(),
                        textAlign: TextAlign.center,
                      )),
                    ]);
                  }).toList(),
                  footer: Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            QuickFixUi().showProcessing(context: context);
                            List<List<String>> tabledata =
                                state.excelData.skip(1).map((row) {
                              return row
                                  .map((cell) => cell.toString())
                                  .toList();
                            }).toList();
                            debugPrint(tabledata.toString());
                            // debugPrint(tabledata[0][1].toString());

                            String response = await CommonRepository()
                                .sendbulkmail(
                                    token: state.token,
                                    payload: {'tabledata': tabledata});

                            debugPrint(response);
                            Map<String, dynamic> jsonResponse =
                                jsonDecode(response);
                            int statusCode = jsonResponse['status code'];
                            if (statusCode == 200) {
                              Navigator.of(context).pop();
                              QuickFixUi.successMessage(
                                  'Send all mails successfully ', context);
                            }
                          } catch (e) {
                            // QuickFixUi.errorMessage(
                            //     'Something went wrong.', context);
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Color.fromARGB(255, 134, 204, 221),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                  ),
                ),
              );
            } else {
              return const Stack();
            }
          })
        ],
      ),
    );
  }

  bool isListPresentInList(
      List<dynamic> list, List<List<dynamic>> listOfLists) {
    String listAsString = list.toString();
    return listOfLists.any((sublist) => sublist.toString() == listAsString);
  }

  Future<void> pickFile(
      {required CommonMailsBloc blocProvider,
      required BuildContext context}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);

      await loadExcel(file: file, blocProvider: blocProvider, context: context);
    }
  }

  Future<void> loadExcel(
      {required File file,
      required CommonMailsBloc blocProvider,
      required BuildContext context}) async {
    try {
      List<List<dynamic>> excelData = [];
      var bytes = await file.readAsBytes();
      var excel = newexcel.Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          excelData.add(row.map((cell) => cell?.value ?? '').toList());
        }
      }
      blocProvider.add(BulkmailsendEvent(excelData: excelData));
    } catch (e) {
      QuickFixUi.errorMessage('This file not support', context);
    }
  }
}
