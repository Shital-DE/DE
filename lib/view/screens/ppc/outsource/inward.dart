import 'package:de/utils/common/quickfix_widget.dart';
import 'package:de/utils/size_config.dart';
import 'package:de/view/widgets/appbar.dart';
import 'package:de/view/widgets/custom_datatable.dart';
import 'package:de/view/widgets/debounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/ppc/outsource_inward/inward_bloc/inward_bloc.dart';
import '../../../../bloc/ppc/outsource_inward/outsource_bloc/outsource_bloc.dart';
import '../../../../services/model/registration/subcontractor_models.dart';
import '../../../widgets/custom_dropdown.dart';

class InwardProducts extends StatelessWidget {
  const InwardProducts({super.key});

//   @override
//   State<InwardProducts> createState() => _InwardProductsState();
// }

// class _InwardProductsState extends State<InwardProducts> {
  @override
  Widget build(BuildContext context) {
    String subcontractorId = "";
    bool checkBoxVal = false;
    int qty = 0;
    bool status = false;
    SizeConfig.init(context);
    BlocProvider.of<OutsourceBloc>(context).add(GetSubcontractorEvent());
    return Scaffold(
      appBar: CustomAppbar().appbar(context: context, title: "Inward Products"),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: 10, right: SizeConfig.blockSizeHorizontal!),
                width: SizeConfig.blockSizeHorizontal! * 25,
                child: BlocBuilder<OutsourceBloc, OutsourceState>(
                  builder: (context, state) {
                    if (state is SubcontractorListState) {
                      return CustomDropdownSearch<AllSubContractor>(
                          items: state.subContractorList,
                          itemAsString: (i) => i.name.toString(),
                          onChanged: (value) {
                            subcontractorId = value?.id ?? '';
                            // partyData = value!;
                            BlocProvider.of<InwardBloc>(context).add(
                                InwardListLoadEvent(
                                    subcontractorid: value!.id!));
                          },
                          hintText: "Select Subcontractor");
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Container(
                  width: 300,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    leading: Transform.scale(
                      scale: 1.4,
                      child: BlocBuilder<InwardBloc, InwardState>(
                        builder: (context, state) {
                          // if (state is FinishedInwardState || state is InwardListLoadedState) {
                          checkBoxVal = state.check;

                          return Checkbox(
                            activeColor: Colors.green[700],
                            onChanged: (value) async {
                              BlocProvider.of<InwardBloc>(context).add(
                                  FinishedInwardListLoadEvent(
                                      subcontractorid: subcontractorId,
                                      check: value!));
                            },
                            value: checkBoxVal,
                          );
                        },
                      ),
                    ),
                    title: const Text(
                      "Finished Inward",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),

          Container(
            height: SizeConfig.screenHeight! * 0.66, //500,
            // width: SizeConfig.screenWidth! + 100,
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 10),
            child: BlocBuilder<InwardBloc, InwardState>(
              builder: (context, state) {
                if (state is InwardListLoadedState ||
                    state is FinishedInwardState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: CustomDataTable(
                        // dataRowHeight: SizeConfig.blockSizeVertical! * 2,
                        columnNames: const [
                          'Challan',
                          'Challan Date',
                          'PO',
                          'Product',
                          // 'LineItem',
                          'Process',
                          'Outward',
                          'Pending',
                          'Inward',
                          'Current Qty'
                        ],
                        tableBorder: const TableBorder(
                            top: BorderSide(),
                            bottom: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide()),
                        // columnIndexForSearchIcon: 2,
                        rows: state.inwardList
                            .map((e) => DataRow(
                                    cells: [
                                      DataCell(CustomText(e
                                          .challan!.outwardchallan
                                          .toString())),
                                      DataCell(CustomText(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(e
                                                      .challan!.outsourcedate
                                                      .toString())
                                                  .toLocal()))),
                                      DataCell(CustomText(
                                          e.outsource!.salesorder.toString())),
                                      DataCell(CustomText(
                                          e.outsource!.product! +
                                              e.outsource!.revisionnumber!)),
                                      // DataCell(CustomText(e
                                      //     .outsource!.lineitemnumber
                                      //     .toString())),
                                      DataCell(SizedBox(
                                        width: 150,
                                        child: e.outsource!.process
                                                    .toString() !=
                                                'null'
                                            ? CustomText(
                                                e.outsource!.process ?? "")
                                            : Text(
                                                e.outsource!.instruction!,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      )),
                                      // DataCell(
                                      //     Text(e.outsource!.instruction.toString())),

                                      DataCell(CustomText(
                                          e.outsource!.quantity.toString())),
                                      DataCell(CustomText(
                                          "${e.outsource!.quantity! - e.challan!.inwardqty!}")),
                                      DataCell(CustomText(
                                          e.challan!.inwardqty.toString())),
                                      DataCell(e.outsource!.quantity! !=
                                              e.challan!.inwardqty!
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width: 80,
                                                    child: TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            TextEditingController(
                                                                text: "0"),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .deny(RegExp(
                                                                  r'[-.]')),
                                                        ],
                                                        onChanged: (value) {
                                                          if (value
                                                                  .isNotEmpty &&
                                                              value != '') {
                                                            if (int.parse(
                                                                        value) +
                                                                    e.challan!
                                                                        .inwardqty! >
                                                                e.outsource!
                                                                    .quantity!) {
                                                              qty = int.parse(
                                                                  value);
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          const Text(
                                                                              "Quantity exceeded"),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            qty =
                                                                                0;

                                                                            Navigator.of(context).pop(qty);
                                                                          },
                                                                          child:
                                                                              const Text('OK'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              qty = int.parse(
                                                                  value);
                                                            }
                                                          } else {
                                                            qty = 0;
                                                          }
                                                        })),
                                                Container(
                                                  width: 110,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: DebouncedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty
                                                                .resolveWith((states) =>
                                                                    const Color(
                                                                        0xFF1978a5))),
                                                    onPressed: () {
                                                      if ((qty +
                                                              e.challan!
                                                                  .inwardqty!) ==
                                                          e.outsource!
                                                              .quantity!) {
                                                        status = true;
                                                      } else {
                                                        status = false;
                                                      }
                                                      if (qty != 0 &&
                                                          qty.toString() !=
                                                              "" &&
                                                          qty <=
                                                              e.outsource!
                                                                  .quantity!) {
                                                        BlocProvider.of<
                                                                    InwardBloc>(
                                                                context)
                                                            .add(InwardSaveEvent(
                                                                inwardData: e,
                                                                qty: qty,
                                                                status: status,
                                                                subcontractorid:
                                                                    subcontractorId));
                                                        QuickFixUi.successMessage(
                                                            "Inward Successfully",
                                                            context);
                                                        qty = 0;
                                                      } else {
                                                        QuickFixUi.errorMessage(
                                                            "Check Quantity",
                                                            context);
                                                      }
                                                    },
                                                    text: "Inward",
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              "Completed",
                                              style: TextStyle(fontSize: 16.0),
                                            ))
                                    ],
                                    color: e.outsource!.process.toString() !=
                                            'null'
                                        ? WidgetStateProperty.resolveWith(
                                            (states) => Colors.white)
                                        : WidgetStateProperty.resolveWith(
                                            (states) => const Color.fromARGB(
                                                255, 156, 228, 222))))
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          // ),
        ],
      ),
    );
  }

  Future<dynamic> showMsg(BuildContext context, String msg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
