import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T)? itemAsString;
  final void Function(T?)? onChanged;
  final T? selectedItem;
  final String hintText;

  const CustomDropdownSearch(
      {super.key,
      required this.items,
      required this.itemAsString,
      required this.onChanged,
      required this.hintText,
      this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      popupProps: const PopupProps.menu(
        menuProps: MenuProps(),
        showSearchBox: true,
      ),
      items: items,
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      dropdownButtonProps: const DropdownButtonProps(
        icon: Icon(color: Colors.black, Icons.arrow_drop_down),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(),
          floatingLabelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          hintText: hintText,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
