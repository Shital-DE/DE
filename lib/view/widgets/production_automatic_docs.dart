// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import '../../bloc/production/operator/bloc/operator_auto_production/operatorautoproduction_state.dart';
import '../../services/model/common/document_model.dart';
import '../../services/model/operator/oprator_models.dart';
import '../../services/repository/common/documents_repository.dart';
import '../../services/repository/operator/operator_repository.dart';
import '../../services/repository/product/product_repository.dart';
import '../../utils/app_colors.dart';
import '../../utils/common/buttons.dart';
import '../../utils/common/quickfix_widget.dart';
import '../../utils/size_config.dart';
import '../screens/common/documents.dart';
import 'table/custom_table.dart';

class OperatorAutomaticDocuments {
  Widget documentsButtons(
      {required BuildContext context,
      required Alignment alignment,
      required double topMargin,
      required String token,
      required String pdfMdocId,
      required String product,
      required String productid,
      required String productrevisionno,
      required String productDescription,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelimageType,
      required String machinename,
      required String workcentreid,
      required String workstationid,
      required String seqno,
      required Barcode? barcode,
      required String machineid,
      required OAPLoadingState state,
      required String processrouteid}) {
    StreamController<bool> processingworkstatus =
        StreamController<bool>.broadcast();
    StreamController<bool> processingpdf = StreamController<bool>.broadcast();
    StreamController<bool> processing3d = StreamController<bool>.broadcast();
    StreamController<bool> processingproductprogram =
        StreamController<bool>.broadcast();
    StreamController<bool> processingmachineprogram =
        StreamController<bool>.broadcast();
    return Align(
      alignment: alignment,
      child: Container(
        width: 800,
        height: 60,
        margin: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state.employeeId != '')
              StreamBuilder<bool>(
                  stream: processingworkstatus.stream,
                  builder: (context, snapshot) {
                    return Workstatus(
                        child: snapshot.data != null && snapshot.data == true
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : QuickFixUi.buttonText('Work status'),
                        onPressed: () async {
                          processingworkstatus.add(true);
                          List<Operatorworkstatuslist> operatorworkstatuslist =
                              await OperatorRepository.operatorworkstatus(
                                  state.employeeId.toString(), token);
                          // final saveddata = await UserData.getUserData();

                          processingworkstatus.add(false);
                          operatorworkstatus(
                              token, context, operatorworkstatuslist, state);
                        });
                  }),
            if (pdfMdocId != '')
              StreamBuilder<bool>(
                  stream: processingpdf.stream,
                  builder: (context, snapshot) {
                    return PdfButton(
                        child: snapshot.data != null && snapshot.data == true
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : QuickFixUi.buttonText('PDF'),
                        onPressed: () async {
                          processingpdf.add(true);
                          final docData = await DocumentsRepository()
                              .documents(token, pdfMdocId);
                          processingpdf.add(false);
                          pdf(context, docData, product, productDescription,
                              pdfRevisionNo);
                        });
                  }),
            if (modelMdocId != '')
              StreamBuilder<bool>(
                  stream: processing3d.stream,
                  builder: (context, snapshot) {
                    return ModelButton(
                        child: snapshot.data != null && snapshot.data == true
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : QuickFixUi.buttonText('3D Model'),
                        onPressed: () async {
                          processing3d.add(true);
                          final docData = await DocumentsRepository()
                              .documents(token, modelMdocId);
                          processing3d.add(false);
                          models(docData, product, productDescription,
                              modelimageType);
                        });
                  }),
            if (productid != '')
              StreamBuilder<bool>(
                  stream: processingproductprogram.stream,
                  builder: (context, snapshot) {
                    return ProgrameuploadButton(
                        child: snapshot.data != null && snapshot.data == true
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : QuickFixUi.buttonText('Product Program'),
                        onPressed: () async {
                          processingproductprogram.add(true);
                          List<MachineProgramListFromERP> seqwiseprogramList =
                              await OperatorRepository
                                  .getMachineProgramListFromERP(
                                      productid.toString(),
                                      productrevisionno,
                                      workcentreid,
                                      seqno,
                                      token);
                          // final String folderList = await DocumentsRepository()
                          //     .documentsfolderdetails(token, mdoclist);
                          //  debugPrint(seqwiseprogramList.toString());

                          List<MachinIpUsername> machineuserData =
                              await OperatorRepository.getmachineuserdata(
                                  wc: workcentreid,
                                  ws: workstationid,
                                  token: token);

                          processingproductprogram.add(false);

                          if (seqwiseprogramList.isNotEmpty) {
                            productProgramList(
                                token,
                                context,
                                seqwiseprogramList,
                                product,
                                productDescription,
                                machineid,
                                machineuserData[0].machineip.toString().trim(),
                                machineuserData[0]
                                    .machineuser
                                    .toString()
                                    .trim());
                          } else {
                            QuickFixUi().showCustomDialog(
                                context: context,
                                errorMessage: "No programs available...!");
                          }
                        });
                  }),
            if (machinename != '')
              StreamBuilder<Object>(
                  stream: processingmachineprogram.stream,
                  builder: (context, snapshot) {
                    return ProgrameDownloadeButton(
                        child: snapshot.data != null && snapshot.data == true
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : QuickFixUi.buttonText('Machine Program'),
                        onPressed: () async {
                          processingmachineprogram.add(true);
                          // List<MachinIpUsername> machineuserData =
                          //     await OperatorRepository.getmachineuserdata(
                          //         wc: workcentreid,
                          //         ws: workstationid,
                          //         token: token);
                          // if (machineuserData[0]
                          //         .machineuser
                          //         .toString()
                          //         .trim() ==
                          //     'USB') {
                          //   await usbrefresh(
                          //       machineuserData[0].machineip.toString().trim());
                          // } else {
                          //   // debugPrint("No refresh required");
                          // }

                          final String machineprogramList =
                              await DocumentsRepository()
                                  .getprogramListFromMachine(machineid);

                          processingmachineprogram.add(false);

                          if (machineprogramList.isNotEmpty) {
                            List<ProgramListfromMachine> programs =
                                parsePrograms(machineprogramList);
                            machineProgramList(
                                token: token,
                                context: context,
                                programs: programs,
                                machineid: machineid,
                                product: product,
                                productrevisionno: productrevisionno,
                                seqno: seqno,
                                productdescription: productDescription,
                                barcode: barcode,
                                workcentreid: workcentreid,
                                workstationid: workstationid,
                                state: state,
                                processrouteid: processrouteid,
                                machinename: machinename);
                          }
                        });
                  })
          ],
        ),
      ),
    );
  }

  List<ProgramListfromMachine> parsePrograms(String jsonString) {
    final parsed = json.decode(jsonString);
    final programs = parsed['programs'] as List<dynamic>;
    return programs
        .map((program) => ProgramListfromMachine(
              name: program['name'],
              size: program['size'],
              date: DateTime.parse(program['date']),
            ))
        .toList();
  }

  void productProgramList(
      token,
      BuildContext context,
      List<MachineProgramListFromERP> foldername,
      String product,
      String productdescription,
      String machineid,
      String machinip,
      String machineuser) {
    // List<Map<String, dynamic>> folderList =
    //     (jsonDecode(foldername) as List<dynamic>).cast<Map<String, dynamic>>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Programs List from ERP        $product        Description:$productdescription',
            style: const TextStyle(color: Color.fromARGB(255, 196, 80, 76)),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: 1250,
              child: DataTable(
                // dataRowMinHeight: 25.0,
                dataRowMaxHeight: 80.0,
                headingRowColor: WidgetStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 111, 158, 170),
                ),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Sr.No',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Product',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'SeqNo',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ProgramName',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(foldername.length, (index) {
                  MachineProgramListFromERP folder = foldername[index];
                  // String modifiedString =
                  //     folder.remark!.substring(32);

                  return DataRow(
                    cells: [
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(folder.product.toString())),
                      DataCell(Text(folder.processSeqnumber.toString())),
                      DataCell(Text(folder.remark.toString())),
                      DataCell(SizedBox(
                        width: 280,
                        child: Row(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor:
                                      const Color.fromARGB(255, 204, 167, 164),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () async {
                                  final docData = await DocumentsRepository()
                                      .documents(
                                          token, folder.mdocId.toString());
                                  if (docData != null) {
                                    String filePath = folder.remark
                                        .toString()
                                        .replaceAll(r'\', '/');
                                    String fileName = path.basename(filePath);
                                    String fileExtension = path
                                        .extension(folder.remark.toString());
                                    final String dirpath = (await path_provider
                                            .getApplicationSupportDirectory())
                                        .path;
                                    final String vertualfilename =
                                        '$dirpath/$fileName.$fileExtension';
                                    final File file = File(vertualfilename);
                                    final data = base64.decode(docData);
                                    await file.writeAsBytes(data, flush: true);
                                    String content = await file.readAsString();
                                    if (Platform.isAndroid) {
                                      QuickFixUi().readTextFile(
                                          context: context,
                                          content: content,
                                          filename: fileName);
                                    } else {
                                      Documents().models(
                                          docData,
                                          '',
                                          folder.remark.toString(),
                                          fileExtension.substring(1));
                                    }
                                  }
                                },
                                child: const Text('View')),
                            const SizedBox(
                              width: 21,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor:
                                      //const Color.fromARGB(255, 204, 167, 164),
                                      const Color.fromARGB(255, 176, 204, 204),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () async {
                                  String modifiedString = '';
                                  if (folder.remark!.length >= 69) {
                                    modifiedString = //folder.remark.toString();
                                        folder.remark.toString().substring(69);
                                  } else {
                                    modifiedString = folder.remark.toString();
                                  }
                                  final docData = await DocumentsRepository()
                                      .documents(
                                          token, folder.mdocId.toString());

                                  final data = base64.decode(docData);
                                  final String path = (await path_provider
                                          .getApplicationSupportDirectory())
                                      .path;
                                  final String fileName =
                                      '$path/${modifiedString.toString().trim()}';

                                  final File file = File(fileName);
                                  await file.writeAsBytes(data, flush: true);
                                  File finalfilepath = File(fileName);
                                  String mssge = await sendFileToApi(
                                      finalfilepath, machineid);

                                  String refreshmssge = '';
                                  if (machineuser == 'USB') {
                                    refreshmssge = await usbrefresh(machinip);
                                  } else {
                                    // debugPrint("No refresh required");
                                  }
                                  showSuccessDialog(
                                      context: context,
                                      message: '$mssge $refreshmssge');
                                },
                                child: const Text("Send To Machine")),
                          ],
                        ),
                      )),
                    ],
                  );
                }),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void operatorworkstatus(token, BuildContext context,
      List<Operatorworkstatuslist> foldername, OAPLoadingState state) {
    // List<Map<String, dynamic>> folderList =
    //     (jsonDecode(foldername) as List<dynamic>).cast<Map<String, dynamic>>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double tableWidth = MediaQuery.of(context).size.width,
            rowHeight = 50,
            tableHeight = (foldername.length + 2) * rowHeight;
        return AlertDialog(
          title: const Text(
            'Operator Work Status',
            style: TextStyle(color: Color.fromARGB(255, 196, 80, 76)),
          ),
          content: Column(
            children: [
              Container(
                width: tableWidth,
                height: MediaQuery.of(context).size.height -
                    (Platform.isAndroid ? 251 : 150),
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: CustomTable(
                  tablewidth: tableWidth,
                  tableheight: tableHeight,
                  columnWidth: tableWidth /
                      (Platform.isAndroid
                          ? 10.8
                          : MediaQuery.of(context).size.width > 1300
                              ? 10.2
                              : 10.9),
                  rowHeight: rowHeight,
                  enableRowBottomBorder: true,
                  tableheaderColor: Theme.of(context).colorScheme.onError,
                  tablebodyColor: Theme.of(context).colorScheme.surface,
                  tableOutsideBorder: true,
                  headerBorderThickness: .9,
                  tableBorderColor: Theme.of(context).colorScheme.error,
                  headerStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                  column: [
                    ColumnData(
                        //width: 50,
                        label: 'Index'),
                    ColumnData(label: 'Action'),
                    ColumnData(label: 'Status'),
                    ColumnData(label: 'Product'),
                    ColumnData(label: 'Revision'),
                    ColumnData(label: 'PO'),
                    ColumnData(label: 'LineNo'),
                    ColumnData(label: 'SeqNo.'),
                    ColumnData(label: 'PoQty'),
                    ColumnData(label: 'OkQty'),
                    ColumnData(label: 'Machine'),
                    ColumnData(label: 'Starttime'),
                    ColumnData(label: 'EndTime'),
                  ],
                  rows: foldername.asMap().entries.map((entry) {
                    // String filename = '';
                    // if (e.remark != null) {
                    //   if (e.remark.toString().contains(r'\')) {
                    //     List<String> parts = e.remark.toString().split(r'\');
                    //     filename = parts.last;
                    //   } else {
                    //     filename = e.remark.toString();
                    //   }
                    // }
                    int index = entry.key;
                    var e = entry.value;
                    return RowData(cell: [
                      // TableDataCell(
                      //     //  width: 50,
                      //     label: Text((((foldername.indexOf(e)) +
                      //                 (50 * (foldername.indexOf(e) - 1))) +
                      //             1)
                      //         .toString())),
                      TableDataCell(
                        label: Text(
                          ((index + 1).toString()),
                          // + (50 * index)).toString()
                        ),
                      ),
                      TableDataCell(
                          label: actionColumn(
                        e: e,
                        state: state,
                        context: context,
                      )),
                      TableDataCell(
                          label: Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 7),
                              child: e.startprocesstime != null &&
                                      e.endprocesstime == null
                                  ? const Text('Inprocess',
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              241, 24, 24, 0.973)))
                                  : const Text('Completed',
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              66, 240, 43, 0.976))))),
                      TableDataCell(label: Text(e.product.toString())),
                      TableDataCell(label: Text(e.revisionno.toString())),
                      TableDataCell(
                          label: Container(
                        padding: const EdgeInsets.only(
                            left: 15, right: 0, top: 0, bottom: 0),
                        child: Text(e.po.toString()),
                      )),
                      TableDataCell(label: Text(e.lineitno.toString())),
                      TableDataCell(label: Text(e.seqno.toString())),
                      TableDataCell(
                          label: Text(e.tobeproducedquantity.toString())),
                      TableDataCell(label: Text(e.producedqty.toString())),
                      // TableDataCell(label: Text(e.workstation.toString())),
                      TableDataCell(
                          label: Container(
                        padding: const EdgeInsets.only(
                            left: 50, right: 0, top: 0, bottom: 0),
                        child: Text(e.workstation.toString()),
                      )),
                      TableDataCell(
                        label: Text(
                            DateTime.parse(e.startprocesstime.toString())
                                .toLocal()
                                .toString()
                                .substring(0, 16)),
                      ),
                      TableDataCell(
                          label: Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 7),
                              child: Text(e.endprocesstime == null
                                  ? ''
                                  : DateTime.parse(e.endprocesstime.toString())
                                      .toLocal()
                                      .toString()
                                      .substring(0, 16)))),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Row actionColumn({
    required Operatorworkstatuslist e,
    required OAPLoadingState state,
    required BuildContext context,
    // required ProductResourceManagementBloc blocProvider
  }) {
    return Row(
      children: [
        Platform.isAndroid
            ? QuickFixUi.horizontalSpace(width: 30)
            : QuickFixUi.horizontalSpace(width: 20),
        e.pdfmdcid != null
            ? Center(
                child: IconButton(
                    onPressed: () async {
                      final docData = await DocumentsRepository()
                          .documents(state.token, e.pdfmdcid.toString());
                      if (docData != null) {
                        if (Platform.isAndroid) {
                          Documents().pdf(
                              context,
                              docData,
                              e.product.toString(),
                              '',
                              e.revisionno.toString());
                        } else {
                          Documents().models(docData, e.product.toString(), '',
                              '.pdf'.toString());
                        }
                      }
                    },
                    icon: Icon(
                      Icons.picture_as_pdf,
                      color: Theme.of(context).colorScheme.error,
                    )),
              )
            : const Stack(),
      ],
    );
  }

  void machineProgramList(
      {required String token,
      required BuildContext context,
      required List<ProgramListfromMachine> programs,
      required String machinename,
      required String product,
      required String productrevisionno,
      required String seqno,
      required String productdescription,
      required Barcode? barcode,
      required String machineid,
      required String workcentreid,
      required String workstationid,
      required OAPLoadingState state,
      required String processrouteid}) {
    List<ProgramListfromMachine> programsSublist =
        programs.length > 50 ? programs.sublist(0, 50) : programs;
    StreamController<List<ProgramListfromMachine>> searchedPrograms =
        StreamController<List<ProgramListfromMachine>>.broadcast();
    TextEditingController searchValue = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Program List from Machine: $machinename    $product    $productdescription',
                style: const TextStyle(
                    color: Color.fromARGB(255, 196, 80, 76), fontSize: 18),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search programs',
                      ),
                      onChanged: (value) {
                        searchValue.text = value.toString();
                      },
                    ),
                  ),
                  IconButton.filled(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      List<ProgramListfromMachine> searchedData =
                          programs.where((item) {
                        String itemString = item.name.toString().toLowerCase();
                        return itemString
                            .contains(searchValue.text.toLowerCase());
                      }).toList();
                      searchedPrograms.add(searchedData);
                    },
                  )
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: 1200,
              child: StreamBuilder<List<ProgramListfromMachine>>(
                  stream: searchedPrograms.stream,
                  builder: (context, snapshot) {
                    return machineProgramDataTable(
                        programs: snapshot.data != null
                            ? snapshot.data!
                            : programsSublist,
                        machineid: machineid,
                        token: token,
                        state: state,
                        processrouteid: processrouteid,
                        seqno: seqno,
                        context: context);
                  }),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  DataTable machineProgramDataTable(
      {required List<ProgramListfromMachine> programs,
      required String machineid,
      required String token,
      required OAPLoadingState state,
      required String processrouteid,
      required String seqno,
      required BuildContext context}) {
    int serialNumber = 1;
    return DataTable(
        columns: const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Program_Name')),
          DataColumn(label: Text('Size')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Action')),
        ],
        rows: programs.map((e) {
          int currentSerial = serialNumber++;
          return DataRow(
            cells: [
              DataCell(Text(currentSerial.toString())),
              DataCell(Text(e.name)),
              DataCell(Text(e.size.toString())),
              DataCell(Text(e.date.toLocal().toString())),
              DataCell(SizedBox(
                width: 250,
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor:
                              const Color.fromARGB(255, 204, 167, 164),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final programdata = await DocumentsRepository()
                              .getProgramFileByID(machineid, e.name);
                          showStringDialogalldata(context, programdata, e.name);
                        },
                        child: const Text("View")),
                    const SizedBox(
                      width: 21,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor:
                                const Color.fromARGB(255, 176, 204, 204),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 205, 214, 228))),
                        onPressed: () async {
                          final programdata = await DocumentsRepository()
                              .getProgramFileByID(machineid, e.name);
                          //.getProgramFileByID('0008', e.name);

                          // debugPrint(programdata.toString());
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final file = File('${directory.path}/${e.name}');
                          await file.writeAsString(programdata);

                          List<int> savedFileContent = await file.readAsBytes();
                          String programdatafile =
                              base64Encode(savedFileContent);
                          String fileExtension = '';

                          if (e.name.contains('.')) {
                            List<String> parts = e.name.split('.');
                            fileExtension = parts[1];
                          }

                          String response = await ProductRepository()
                              .uploadMachinePrograms(token: token, payload: {
                            'createdby': state.employeeId,
                            'pd_product_id': state.barcode!.productid,
                            'revision_number': state.barcode!.revisionnumber,
                            'workstation_id': state.workstationid,
                            'workcenter_id': state.workcentreid,
                            'process_route_id': processrouteid,
                            'process_seq': seqno,
                            'remark': e.name,
                            'imagetype_code': fileExtension,
                            'data': programdatafile
                          });
                          if (response == 'File uploaded successfully') {
                            await file.delete();
                            QuickFixUi().showCustomDialog(
                                context: context, errorMessage: response);
                          } else {
                            QuickFixUi().showCustomDialog(
                                context: context, errorMessage: response);
                            await file.delete();
                          }

                          // showStringDialogalldata(context, programdata, e.name);
                        },
                        child: const Text("Send to ERP")),
                  ],
                ),
              )),
            ],
          );
        }).toList());
  }

  ElevatedButton openProgramFile(
      {required String filePath, required BuildContext context}) {
    return ElevatedButton(
        onPressed: () async {
          File file = File(filePath);
          if (await file.exists()) {
            try {
              String content = await file.readAsString();
              if (Platform.isAndroid) {
                String newFilename = path.basename(filePath);
                return QuickFixUi().readTextFile(
                    context: context, content: content, filename: newFilename);
              } else {
                await open_file.OpenFile.open(filePath);
              }
            } catch (e) {
              QuickFixUi().showCustomDialog(
                  context: context, errorMessage: 'Unable to open file.');
            }
          } else {
            QuickFixUi().showCustomDialog(
                context: context, errorMessage: 'File not found.');
          }
        },
        child: const Text('View'));
  }

  void showStringDialogalldata(
      BuildContext context, String data, String programname) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(programname),
          content: SizedBox(
            width: 450,
            height: 450,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(data),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget viewprogram(BuildContext context, ddata) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(ddata)),
      ),
    );
  }

  Future<dynamic> showSuccessDialog(
      {required BuildContext context, required String message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          )),
          actions: [
            Center(
              child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> showProgressDialog(
      {required BuildContext context, required String message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          )),
          actions: [
            Center(
                child: Container(
              height: 150.0, // Set the desired height
              width: 150.0, // Set the desired width
              color: const Color.fromARGB(255, 230, 64, 64),
              child: const CircularProgressIndicator(),
            ))
          ],
        );
      },
    );
  }

  Future<String> writeAndStoreData(String data, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    try {
      final file = File(filePath);

      await file.create(recursive: true); // Create necessary directories
      await file.writeAsString(data);
      // debugPrint('Data written and stored successfully at: $filePath');
    } catch (e) {
      // debugPrint('Error writing and storing data: $e');
    }
    return filePath;
  }

  void readStoredData(String filePath) async {
    try {
      final file = File(filePath);
      final fileContent = await file.readAsString();
      debugPrint(fileContent);
    } catch (e) {
      // debugPrint('Error reading file: $e');
    }
  }

  Future sendFileToApi(File filepath, String machineid) async {
    try {
      // var link =AppUrl.
      File file = File(filepath.path);
      // debugPrint("file.pathdebug file path....");
      // debugPrint(file.path);
      var request = http.MultipartRequest('POST',
          Uri.parse('http://192.168.0.55:3213/v1/industry40/putProgramFile'));
      request.fields.addAll({'machineid': machineid});
      request.files
          .add(await http.MultipartFile.fromPath('programs', file.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        // debugPrint('File sent successfully');
        return "Sent Successfully";
      } else {
        // debugPrint('Failed to send file. Status code: ${response.statusCode}');
        return "File Not Transfer";
      }
    } catch (e) {
      // debugPrint('Error reading file: $e');
      return "File Not Transfer";
    }
  }

  Future usbrefresh(String machineip) async {
    try {
      var url = Uri.parse("http://$machineip/refresh-usb");
      var response = await http.get(
        url,
        //  body: jsonEncode(<String, String>{}),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        // debugPrint('USB Refreshed');
        return "USB Refreshed";
      } else {
        // debugPrint('Failed to USB Refreshed:${response.statusCode}');
        return " Failed to USB Refreshed";
      }
    } catch (e) {
      // debugPrint('Failed to USB Refreshed: $e');
      return "Failed to USB Refreshed";
    }
  }

  List<int> hexToBytes(String hex) {
    var result = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      var byte = int.parse(hex.substring(i, i + 2), radix: 16);
      result.add(byte);
    }
    return result;
  }

  Widget horizontalVersions(
      {required BuildContext context,
      required double topMargin,
      required String pdfMdocId,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelRevisionNo,
      required List<DocumentDetails> modelsDetails,
      required List<DocumentDetails> pdfDetails,
      required String modelimageType,
      required String product,
      required String productDescription,
      required String token}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            versionAlert(
                modelMdocId: modelMdocId,
                modelRevisionNo: modelRevisionNo,
                pdfMdocId: pdfMdocId,
                pdfRevisionNo: pdfRevisionNo),
            pdfDetails.isNotEmpty && modelsDetails.isNotEmpty
                ? viewButton(
                    context: context,
                    modelsDetails: modelsDetails,
                    pdfDetails: pdfDetails,
                    imageType: modelimageType,
                    product: product,
                    productDescription: productDescription,
                    token: token)
                : const Text('')
          ],
        ),
      ),
    );
  }

  Widget verticalVersions(
      {required BuildContext context,
      required double topMargin,
      required String pdfMdocId,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelRevisionNo,
      required List<DocumentDetails> modelsDetails,
      required List<DocumentDetails> pdfDetails,
      required String imageType,
      required String product,
      required String productDescription,
      required String token}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: topMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            versionAlert(
                modelMdocId: modelMdocId,
                modelRevisionNo: modelRevisionNo,
                pdfMdocId: pdfMdocId,
                pdfRevisionNo: pdfRevisionNo),
            pdfDetails.isNotEmpty && modelsDetails.isNotEmpty
                ? viewButton(
                    context: context,
                    modelsDetails: modelsDetails,
                    pdfDetails: pdfDetails,
                    imageType: imageType,
                    product: product,
                    productDescription: productDescription,
                    token: token)
                : const Text('')
          ],
        ),
      ),
    );
  }

  Widget versionAlert(
      {required String pdfMdocId,
      required String pdfRevisionNo,
      required String modelMdocId,
      required String modelRevisionNo}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Latest versions = PDF version : ',
          style: TextStyle(
              fontSize: 17,
              color: AppColors.greenTheme,
              fontWeight: FontWeight.bold),
        ),
        Text(
          pdfMdocId != '' ? pdfRevisionNo : 'Pdf not available ',
          style: TextStyle(
              fontSize: 17,
              color:
                  pdfMdocId != '' ? AppColors.greenTheme : AppColors.redTheme,
              fontWeight: FontWeight.bold),
        ),
        const Text(
          ', 3D model version : ',
          style: TextStyle(
              fontSize: 17,
              color: AppColors.greenTheme,
              fontWeight: FontWeight.bold),
        ),
        Text(
          modelMdocId != '' ? modelRevisionNo : '3D model not available ',
          style: TextStyle(
              fontSize: 17,
              color:
                  modelMdocId != '' ? AppColors.greenTheme : AppColors.redTheme,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget viewButton(
      {required BuildContext context,
      required List<DocumentDetails> pdfDetails,
      required List<DocumentDetails> modelsDetails,
      required String product,
      required String token,
      required String productDescription,
      required String imageType}) {
    return TextButton(
        onPressed: () {
          Documents().viewDocumentsVersionwise(context, pdfDetails,
              modelsDetails, product, token, productDescription, imageType);
        },
        child: const Text('Available versions'));
  }

  pdf(BuildContext context, String docData, String product, String description,
      String version) {
    int? currentPage = 0;
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: SizedBox(
        width: 1100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Product : $product'),
            SizeConfig.screenWidth! > 900
                ? Text('Product Description : $description')
                : const Text(''),
            Text('Version $version')
          ],
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: 1100,
            height: 600,
            child: PDFView(
              pdfData: base64.decode(docData),
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              onRender: (pages) {
                pages = pages;
              },
              onError: (error) {
                // debugPrint(error.toString());
              },
              onPageError: (page, error) {},
              onLinkHandler: (String? uri) {},
              onPageChanged: (int? page, int? total) {
                // debugPrint('page change: $page/$total');
                currentPage = page;
              },
            )),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future models(String docData, String product, String description,
      String extension) async {
    final data = base64.decode(docData);
    final String path =
        (await path_provider.getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\${description.toString().trim()}.${extension.toString().trim()}'
        : '$path/Product Name : ${product.toString().trim()}, Product Description : ${description.toString().trim()}.${extension.toString().trim()}';
    final File file = File(fileName);
    await file.writeAsBytes(data, flush: true);
    open_file.OpenFile.open(fileName);
  }

  viewDocumentsVersionwise(
      BuildContext context,
      List<DocumentDetails> pdfDetails,
      List<DocumentDetails> modelsDetails,
      String product,
      String token,
      String description,
      String imageType) {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: SizedBox(
        width: 300,
        child: Text('Product : $product'),
      ),
      content: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              height: 60,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      'PDF versions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteTheme),
                    ),
                  ),
                  Center(
                    child: Text(
                      '3D model versions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteTheme),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  height: 180,
                  child: ListView.builder(
                    itemCount: pdfDetails.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: AppColors.blueColor,
                        child: TextButton(
                            onPressed: () async {
                              final docData = await DocumentsRepository()
                                  .documents(token,
                                      pdfDetails[index].mdocId.toString());
                              Documents().pdf(
                                  context,
                                  docData,
                                  product,
                                  description,
                                  pdfDetails[index].revisionNumber.toString());
                            },
                            child: Text(
                              pdfDetails[index].revisionNumber.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            )),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 180,
                  child: ListView.builder(
                    itemCount: modelsDetails.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: AppColors.blueColor,
                        child: TextButton(
                            onPressed: () async {
                              final docData = await DocumentsRepository()
                                  .documents(token,
                                      modelsDetails[index].mdocId.toString());
                              Documents().models(
                                  docData, product, description, imageType);
                            },
                            child: Text(
                              modelsDetails[index].revisionNumber.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
