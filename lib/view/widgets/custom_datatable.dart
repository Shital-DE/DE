import 'package:flutter/material.dart';
import '../../bloc/ppc/capacity_plan/bloc/capacity_bloc/capacity_plan_bloc.dart';
import '../../utils/app_theme.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columnNames;
  final List<DataRow> rows;
  final TableBorder? tableBorder;
  const CustomDataTable(
      {super.key,
      required this.columnNames,
      required this.rows,
      this.tableBorder});

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = columnNames
        .map((name) => DataColumn(
                label: Text(
              name,
              style: const TextStyle(fontSize: 16),
            )))
        .toList();

    return DataTable(
      headingRowColor: WidgetStateProperty.resolveWith(
          (states) => const Color.fromARGB(255, 122, 194, 230)),
      border: tableBorder,
      columns: columns,
      rows: rows,
    );
  }
}

// class CustomPaginatedTable1 extends StatelessWidget {
//   final List<String> columnNames;
//   final List<DataRow> rowData;

//   const CustomPaginatedTable1(
//       {super.key, required this.columnNames, required this.rowData});

//   static const int rowPerPage = 10;
//   static int _pageIndex = 0;
//   static List<DataRow> rows = [];

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: PaginatedDataTable(
//         columns: _buildColumns(),
//         source: _CustomDataTableSource(rowData),
//         rowsPerPage: rowPerPage, // Customize rows per page
//         availableRowsPerPage: const [10], // Customize available rows per page
//         onRowsPerPageChanged: (rowCount) {
//           _pageIndex = (_pageIndex * rowPerPage ~/ rowCount!);
//         },
//         onPageChanged: (newPage) {
//           // Handle page change here if needed
//         },
//       ),
//     );
//   }

//   List<DataColumn> _buildColumns() {
//     return columnNames.map((columnName) {
//       return DataColumn(
//         label: Text(columnName, style: AppTheme.tableHeaderTextStyle()),
//       );
//     }).toList();
//   }
// }

class _CustomDataTableSource extends DataTableSource {
  final List<DataRow> _rowData;

  _CustomDataTableSource(this._rowData);

  @override
  DataRow? getRow(int index) {
    if (index >= _rowData.length) {
      return null;
    }
    return _rowData[index];
  }

  @override
  int get rowCount => _rowData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

List<DataRow> paginatedTableList(
    CapacityPlanState state, BuildContext context) {
  return state.cplist
      .map((e) => DataRow(cells: [
            DataCell(Text((state.cplist.indexOf(e) + 1).toString())
                // Transform.scale(
                //   scale: 1.5,
                //   child: Checkbox(
                //     onChanged: (value) {
                //       // state.cplist.

                //       e.checkboxval = value!;

                //       // e.checkboxval = value!;
                //     },
                //     value: e.checkboxval,
                //   ))
                ),
            DataCell(
                Text(e.po.toString(), style: AppTheme.tableRowTextStyle())),
            DataCell(Text(e.productcode.toString(),
                style: AppTheme.tableRowTextStyle())),
            DataCell(Text(e.revisionNo.toString(),
                style: AppTheme.tableRowTextStyle())),
            DataCell(Text(e.lineitemnumber.toString(),
                style: AppTheme.tableRowTextStyle())),
            DataCell(Text(e.orderedqty.toString(),
                style: AppTheme.tableRowTextStyle())),
            DataCell(Text(e.plandate.toString(),
                style: AppTheme.tableRowTextStyle())),
            DataCell(TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(actions: [
                          Container(
                              width: 600,
                              // height: 300,
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  DataTable(
                                      columns: const [
                                        DataColumn(label: Text("Sequence")),
                                        DataColumn(label: Text("Workcentre")),
                                        DataColumn(
                                            label: Text("Setuptime(min)")),
                                        DataColumn(label: Text("Runtime(Min)")),
                                      ],
                                      rows: e.route!
                                          .map((item) => DataRow(cells: [
                                                DataCell(Text(item
                                                    .sequencenumber
                                                    .toString())),
                                                DataCell(Text(item.workcentre
                                                    .toString())),
                                                DataCell(Text(item.setuptimemins
                                                    .toString())),
                                                DataCell(Text(item.runtimemins
                                                    .toString())),
                                              ]))
                                          .toList()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("close")),
                                    ],
                                  )
                                ],
                              )),
                        ]);
                      });
                },
                child: Text(
                  "Route",
                  style: AppTheme.tableRowTextStyle().copyWith(
                      color: e.route?.isNotEmpty == true
                          ? const Color.fromARGB(255, 36, 151, 228)
                          : const Color.fromARGB(255, 228, 42, 36)),
                )))
          ]))
      .toList();
}

class CustomPaginatedTable extends StatefulWidget {
  final List<String> columnNames;
  final List<DataRow> rowData;
  final int? columnIndexForSearchIcon;

  const CustomPaginatedTable(
      {super.key,
      required this.columnNames,
      required this.rowData,
      this.columnIndexForSearchIcon});

  @override
  State<CustomPaginatedTable> createState() => _CustomPaginatedTableState();
}

class _CustomPaginatedTableState extends State<CustomPaginatedTable> {
  int rowPerPage = 10;
  int _pageIndex = 0;
  // List<DataRow> rows = [];
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  List<DataRow> filteredRows = [];
  bool mainCheckBox = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterRows() {
    setState(() {
      final searchValue = searchController.text.toLowerCase();
      if (searchValue.isEmpty) {
        filteredRows = widget.rowData;
        mainCheckBox = false;
      } else {
        filteredRows = widget.rowData.where((row) {
          String cellValue =
              row.cells[widget.columnIndexForSearchIcon!].child is Text
                  ? (row.cells[widget.columnIndexForSearchIcon!].child as Text)
                      .data!
                      .toLowerCase()
                  : '';
          // print(row.cells[0].child is Checkbox);
          return cellValue.contains(searchValue.toLowerCase());
        }).toList();
        if (filteredRows.any((e) =>
            ((e.cells[0].child as Transform).child as Checkbox).value ==
            false)) {
          mainCheckBox = false;
        } else if (filteredRows.isEmpty) {
          mainCheckBox = false;
        } else {
          mainCheckBox = true;
        }
      }
    });
  }

  void checkedRows(bool value, List<DataRow> filteredRows) {
    // setState(() {
    // final searchValue = searchController.text.toLowerCase();
    // if (searchValue.isEmpty) {
    //   filteredRows = widget.rowData;
    // } else {
    //   filteredRows = widget.rowData.where((row) {
    //     String cellValue =
    //         row.cells[widget.columnIndexForSearchIcon!].child is Text
    //             ? (row.cells[widget.columnIndexForSearchIcon!].child as Text)
    //                 .data!
    //                 .toLowerCase()
    //             : '';
    //     // print(row.cells[0].child is Checkbox);
    //     return cellValue.contains(searchValue.toLowerCase());
    //   }).toList();
    filteredRows.map((e) {
      Checkbox checkbox = (e.cells[0].child as Transform).child as Checkbox;

      checkbox.onChanged!(value);

      // print(checkbox.value);
    }).toList();
    // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      filterRows();
    });
    List<DataColumn> columns = widget.columnNames
        .asMap()
        .entries
        .map(
          (entry) => DataColumn(
            label: Row(
              children: [
                if (entry.key == widget.columnIndexForSearchIcon)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                      });
                    },
                  ),
                const SizedBox(width: 4),
                Text(
                  entry.value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        )
        .toList();
    return ListView(
      children: [
        if (widget.columnIndexForSearchIcon != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 150,
                child: filteredRows.any((e) =>
                        ((e.cells[0].child as Transform).child as Checkbox)
                            .value ==
                        true)
                    ? ListTile(
                        title: const CustomText("Clear"),
                        leading: IconButton(
                          onPressed: () {
                            // setState(() {
                            // mainCheckBox = value!;
                            checkedRows(false, filteredRows);
                            // });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      )
                    : const SizedBox(),
              ),*/
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 180,
                child: searchController.text.isNotEmpty
                    ? ListTile(
                        title: const CustomText("Select All"),
                        leading: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            onChanged: (value) {
                              // setState(() {

                              mainCheckBox = value!;
                              // });

                              checkedRows(mainCheckBox, filteredRows);
                            },
                            value: mainCheckBox,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 200,
                child: isSearch
                    ? TextField(
                        keyboardType: TextInputType.number,
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                isSearch = false;
                                mainCheckBox = false;
                              });
                            },
                          ),
                        ),
                        onChanged: (_) => filterRows(),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        PaginatedDataTable(
          columns: columns, // _buildColumns(),
          source: _CustomDataTableSource(filteredRows),
          rowsPerPage: rowPerPage, // Customize rows per page
          availableRowsPerPage: const [10], // Customize available rows per page
          onRowsPerPageChanged: (rowCount) {
            _pageIndex = (_pageIndex * rowPerPage ~/ rowCount!);
          },
          onPageChanged: (newPage) {
            // Handle page change here if needed
          },
        ),
      ],
    );
  }

  // List<DataColumn> _buildColumns() {
  //   return widget.columnNames.map((columnName) {
  //     return DataColumn(
  //       label: Text(columnName, style: AppTheme.tableHeaderTextStyle()),
  //     );
  //   }).toList();
  // }
}

class CustomSearchDataTable extends StatefulWidget {
  final List<String> columnNames;
  final List<DataRow> rows;
  final int? columnIndexForSearchIcon;
  final TableBorder? tableBorder;

  const CustomSearchDataTable(
      {Key? key,
      required this.columnNames,
      required this.rows,
      this.columnIndexForSearchIcon,
      this.tableBorder})
      : super(key: key);

  @override
  CustomDataTableState createState() => CustomDataTableState();
}

class CustomDataTableState extends State<CustomSearchDataTable> {
  TextEditingController searchController = TextEditingController();
  List<DataRow> filteredRows = [];
  bool isSearch = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterRows() {
    setState(() {
      final searchValue = searchController.text.toLowerCase();
      if (searchValue.isEmpty) {
        filteredRows = widget.rows;
      } else {
        filteredRows = widget.rows.where((row) {
          String cellValue =
              row.cells[widget.columnIndexForSearchIcon!].child is CustomText
                  ? (row.cells[widget.columnIndexForSearchIcon!].child
                          as CustomText)
                      .child
                      .toLowerCase()
                  : '';

          return cellValue.contains(searchValue.toLowerCase());
        }).toList();

        /*filteredRows = widget.rows.where((row) {
          return row.cells.any((cell) {
            final cellValue = cell.child.runtimeType == Text
                ? (cell.child as Text).data!.toLowerCase()
                : '';
            return cellValue.contains(searchValue);
          });
        }).toList();*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _filterRows();
    });
    final columns = widget.columnNames
        .asMap()
        .entries
        .map(
          (entry) => DataColumn(
            label: Row(
              children: [
                if (entry.key == widget.columnIndexForSearchIcon)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                      });
                    },
                  ),
                const SizedBox(width: 4),
                Text(
                  entry.value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        )
        .toList();

    return Column(
      children: [
        if (widget.columnIndexForSearchIcon != null)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: 200,
            child: isSearch
                ? TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            isSearch = false;
                          });
                        },
                      ),
                    ),
                    onChanged: (_) => _filterRows(),
                  )
                : const SizedBox(),
          ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            border: widget.tableBorder,
            headingRowColor: WidgetStateProperty.resolveWith(
              (states) => const Color.fromARGB(255, 122, 194, 230),
            ),
            columns: columns,
            rows: filteredRows,
          ),
        ),
      ],
    );
  }
}

class CustomText extends StatelessWidget {
  final String child;
  final TextStyle? style;

  const CustomText(
    this.child, {
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      child,
      style:
          style ?? const TextStyle(fontSize: 16.0), // Default font size: 16.0
    );
  }
}
