import 'package:de/bloc/ppc/outsource_inward/subcontractor_processcubit/cubit/subcontractor_process_cubit.dart';
import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:de/view/widgets/custom_datatable.dart';
import 'package:de/view/widgets/custom_dropdown.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubcontractorProcessCapability extends StatelessWidget {
  const SubcontractorProcessCapability({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    String subcontractor = '', process = '';

    BlocProvider.of<SubcontractorProcessCubit>(context)
        .listSubcontractorProcess("token");

    return Scaffold(
      appBar: CustomAppbar()
          .appbar(context: context, title: "Subcontractor Process"),
      body: ListView(
        children: [
          Row(
            children: [
              SizedBox(
                height: 100,
                width: SizeConfig.screenWidth,
                child: BlocBuilder<SubcontractorProcessCubit,
                    SubcontractorProcessState>(
                  builder: (context, state) {
                    if (state is SubcontractorProcessLoadList) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 30),
                            width: SizeConfig.screenWidth! * 0.3,
                            child: CustomDropdownSearch(
                                items: state.subcontractor,
                                itemAsString: (i) => i.name!,
                                onChanged: (value) {
                                  subcontractor = value!.id!;
                                },
                                hintText: "Select Subcontractor"),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 30),
                            width: SizeConfig.screenWidth! * 0.16,
                            child: CustomDropdownSearch(
                                items: state.process,
                                itemAsString: (i) => i.code!,
                                onChanged: (value) {
                                  process = value!.id!;
                                },
                                hintText: "Select Process"),
                          ),
                          SizedBox(
                              width: 100,
                              child: DebouncedButton(
                                text: "Add",
                                onPressed: () {
                                  if (process == "" || subcontractor == "") {
                                    QuickFixUi.errorMessage(
                                        "Fill all the fields", context);
                                  } else {
                                    Future.sync(() {
                                      BlocProvider.of<
                                                  SubcontractorProcessCubit>(
                                              context)
                                          .saveSubcontractorProcessCapabilities(
                                              subcontractorId: subcontractor,
                                              processId: process);

                                      QuickFixUi.successMessage(
                                          "Inserted Successfully", context);
                                      process = "";
                                      subcontractor = "";
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith(
                                            (states) =>
                                                const Color(0XFF01579b))),
                              ))
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(right: 10, left: 10),
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight! * 0.6,
                child: BlocBuilder<SubcontractorProcessCubit,
                    SubcontractorProcessState>(
                  builder: (context, state) {
                    if (state is SubcontractorProcessInitial) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CustomDataTable(
                            columnNames: const [
                              "Subcontractor",
                              "Process",
                              "Action"
                            ],
                            tableBorder: const TableBorder(
                                top: BorderSide(),
                                bottom: BorderSide(),
                                left: BorderSide(),
                                right: BorderSide()),
                            rows: state.listProcessCapability
                                .map((e) => DataRow(cells: [
                                      DataCell(
                                          CustomText(e.subcontractorName!)),
                                      DataCell(CustomText(e.processCode!)),
                                      DataCell(IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Color.fromARGB(
                                                255, 197, 65, 56)),
                                        onPressed: () async {
                                          dynamic check = await showDialog<
                                                  String>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: const Text(
                                                      'are you sure you want to delete this item'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop('cancel');
                                                        },
                                                        child: const Text(
                                                            'Cancel')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop('confirm');
                                                        },
                                                        child:
                                                            const Text('OK')),
                                                  ],
                                                );
                                              });
                                          if (check == 'confirm') {
                                            Future.sync(() {
                                              BlocProvider.of<
                                                          SubcontractorProcessCubit>(
                                                      context)
                                                  .deleteSubcontractorProcess(
                                                      id: e.id!);
                                              QuickFixUi.successMessage(
                                                  "Deleted Successfully",
                                                  context);
                                            });
                                          }
                                        },
                                      )),
                                    ]))
                                .toList()),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
