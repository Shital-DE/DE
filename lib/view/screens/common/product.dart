// Author : shital Gayakwad
// Created date : 20 July 2023
// Description : Product search

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/documents/documents_bloc.dart';
import '../../../bloc/documents/documents_event.dart';
import '../../../bloc/documents/documents_state.dart';
import '../../../services/model/product/product.dart';
import '../../../utils/common/quickfix_widget.dart';

class ProductSearch extends StatelessWidget {
  final void Function()? onTap;
  final void Function(AllProductModel? value) onChanged;
  const ProductSearch({super.key, this.onTap, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<DocumentsBloc>(context);
    blocProvider.add(DocumentData(productid: ''));
    return Scaffold(body: BlocBuilder<DocumentsBloc, DocumentsState>(
      builder: (context, state) {
        if (state is DocumentsInitialState) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        } else if (state is DocumentsLoadingState) {
          return Container(
            width: 300,
            height: 50,
            padding: const EdgeInsets.only(left: 20),
            decoration: QuickFixUi().borderContainer(borderThickness: .5),
            child: DropdownSearch<AllProductModel>(
                items: state.allprodocutsList.isNotEmpty
                    ? state.allprodocutsList
                    : [],
                itemAsString: (item) => item.code.toString(),
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 18),
                        onTap: onTap)),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        hintText: "Select product", border: InputBorder.none)),
                onChanged: onChanged),
          );
        } else {
          return const Stack();
        }
      },
    ));
  }
}
