// Author : Shital Gayakwad
// Created Date : 30 October 2024
// Description : Product registration

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../services/model/product/product_structure_model.dart';

class ProductRegistration extends StatelessWidget {
  final List<UOMDataModel> unitOfMeasurementList;
  final List<ProductTypeDataModel> productTypeList;
  const ProductRegistration(
      {super.key,
      required this.unitOfMeasurementList,
      required this.productTypeList});

  @override
  Widget build(BuildContext context) {
    double conWidth = 250, conHeight = 45;
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListView(
        children: [
          // Header
          Center(
              child: Text('Register Product',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 17))),
          // Product code
          Center(
            child: Container(
              width: conWidth,
              height: conHeight,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).primaryColorDark)),
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Product code',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
                onChanged: (value) {},
              ),
            ),
          ),

          // Revison
          Center(
            child: Container(
              width: conWidth,
              height: conHeight,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).primaryColorDark)),
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Product revision',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
                onChanged: (value) {},
              ),
            ),
          ),

          // Product type
          Center(
            child: Container(
                width: conWidth,
                height: conHeight,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Theme.of(context).primaryColorDark)),
                padding: const EdgeInsets.only(left: 20),
                child: DropdownSearch<ProductTypeDataModel>(
                  items: productTypeList,
                  itemAsString: (item) => item.producttypeName.toString(),
                  popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      )),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          hintText: 'Product type',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                          border: InputBorder.none)),
                )),
          ),

          // unit of measurement
          Center(
            child: Container(
                width: conWidth,
                height: conHeight,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Theme.of(context).primaryColorDark)),
                padding: const EdgeInsets.only(left: 20),
                child: DropdownSearch<UOMDataModel>(
                  items: unitOfMeasurementList,
                  itemAsString: (item) => item.uomName.toString(),
                  popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      )),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          hintText: 'Unit of measurement',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                          border: InputBorder.none)),
                )),
          ),

          // Storage location
          Center(
            child: Container(
              width: conWidth,
              height: conHeight,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).primaryColorDark)),
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Storage location',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
                onChanged: (value) {},
              ),
            ),
          ),

          // Rack number
          Center(
            child: Container(
              width: conWidth,
              height: conHeight,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).primaryColorDark)),
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Rack number',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
                onChanged: (value) {},
              ),
            ),
          ),

          // Description
          Center(
            child: Container(
              width: conWidth,
              height: conHeight,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).primaryColorDark)),
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
                onChanged: (value) {},
              ),
            ),
          ),

          // Submit
          Center(
            child: InkWell(
              onTap: () {},
              child: Container(
                width: conWidth - 100,
                height: conHeight - 5,
                margin: const EdgeInsets.only(top: 10),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorDark),
                child: const Center(
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
