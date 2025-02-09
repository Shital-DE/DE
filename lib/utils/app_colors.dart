import 'package:flutter/material.dart';
import '../view/widgets/product_structure_widget.dart';

class AppColors {
  static const Color appTheme = Color(0XFF2e4999);
  static const Color whiteTheme = Color(0XFFffffff);
  static const Color redTheme = Color(0XFFf10303);
  static const Color greenTheme = Color.fromARGB(255, 21, 167, 16);
  static const Color blueColor = Colors.blue;
  static const Color greyColor = Colors.grey;
  static const Color blackColor = Colors.black;
  static const Color listColor = Color.fromARGB(255, 144, 197, 241);
  static const Color appbarColor = Color.fromARGB(255, 161, 184, 248);

//Login
  static const Color secondarybackgroundColor =
      Color.fromARGB(255, 214, 219, 233);

  static MaterialColor primarySwatchColor =
      const MaterialColor(0XFF01579b, <int, Color>{
    50: Color(0XFF29b6f6), //10%
    100: Color(0XFF03a9f4), //20%
    200: Color(0XFF039be5), //30%
    300: Color(0XFF0288d1), //40%
    400: Color(0XFF0277bd), //50%
    500: Color(0XFF01579b), //60%
    600: Color(0XFF1e88e5), //70%
    700: Color(0XFF1976d2), //80%
    800: Color(0XFF1565c0), //90%
    900: Color(0XFF111D38)
  });

  static Color canvasColor = const Color.fromARGB(255, 219, 217, 217);

//Operator screen
  static const Color startsettingbuttonColor =
      Color.fromARGB(255, 245, 141, 122);
  static const Color startproductionbuttonColor =
      Color.fromARGB(255, 96, 182, 146);
  static const Color statusButtonListColor = Color.fromARGB(255, 106, 214, 218);
  static const buttonListColor = Color.fromARGB(255, 141, 179, 248);
  static const Color buttonDisableColor = Color.fromARGB(255, 197, 194, 194);
  static const Color buttonDisableTextColor =
      Color.fromARGB(255, 100, 100, 100);
  static const programuploadcolor = Color.fromARGB(255, 132, 91, 148);
  static const programdownloadcolor = Color.fromARGB(255, 218, 176, 100);

  Color? getColorsDependUponProductType(
      {required String productType, required int value}) {
    switch (productType) {
      case ProductTypeStaticDataModel.assemblyId:
        return Colors.blue[value];
      case ProductTypeStaticDataModel.partId:
        return Colors.amber[value];
      case ProductTypeStaticDataModel.hardwareId:
        return Colors.green[value];
      case ProductTypeStaticDataModel.consumablesId:
        return Colors.pink[value];
      case ProductTypeStaticDataModel.rawMaterialId:
        return Colors.indigo[value];
      default:
        return Colors.white;
    }
  }

  static List<Map<String, dynamic>> colorWithDefinitions = [
    {'color': Colors.red[200], 'definition': 'Stock not available.'},
    {'color': Colors.orange[200], 'definition': 'Stock 1% to 49% available.'},
    {'color': Colors.yellow[200], 'definition': 'Stock 50% to 99% available.'},
    {'color': Colors.green[200], 'definition': 'Stock fully available.'},
    {'color': Colors.grey[300], 'definition': 'Required quantity issued.'},
  ];

  Color getColorDependingUponStock(
      {required double currentStock,
      required double requiredQuantity,
      required double issuedQuantity}) {
    double quantity;
    if (requiredQuantity == issuedQuantity) {
      quantity = 0;
    } else if (currentStock == 0) {
      return colorWithDefinitions[0]['color'];
    } else {
      quantity = (currentStock / (requiredQuantity - issuedQuantity)) * 100;
    }
    if (quantity == 0) {
      return colorWithDefinitions[4]['color'];
    } else if (quantity > 0 && quantity < 50) {
      return colorWithDefinitions[1]['color'];
    } else if (quantity >= 50 && quantity < 100) {
      return colorWithDefinitions[2]['color'];
    } else if (quantity >= 100) {
      return colorWithDefinitions[3]['color'];
    } else {
      return Colors.white;
    }
  }

  Color? getColors({required int level, required value}) {
    switch (level) {
      case 0:
        return Colors.blue[value];
      case 1:
        return Colors.amber[value];
      case 2:
        return Colors.purple[value];
      case 3:
        return Colors.green[value];
      case 4:
        return Colors.pink[value];
      case 5:
        return Colors.brown[value];
      case 6:
        return Colors.cyan[value];
      case 7:
        return Colors.red[value];
      case 8:
        return Colors.indigo[value];
      case 9:
        return Colors.teal[value];
      case 10:
        return Colors.orange[value];
      case 11:
        return Colors.lime[value];
      case 12:
        return Colors.blueGrey[value];
      case 13:
        return Colors.yellow[value];
      case 14:
        return Colors.deepPurple[value];
      case 15:
        return Colors.lightGreen[value];
      case 16:
        return Colors.deepOrange[value];
      case 17:
        return Colors.limeAccent[value];
      case 18:
        return Colors.blueAccent[value];
      case 19:
        return Colors.pinkAccent[value];
      case 20:
        return Colors.redAccent[value];
      case 21:
        return Colors.greenAccent[value];
      case 22:
        return Colors.purpleAccent[value];
      case 23:
        return Colors.tealAccent[value];
      case 24:
        return Colors.amberAccent[value];
      case 25:
        return Colors.grey[value];
      case 26:
        return Colors.blueGrey[value];
      case 27:
        return Colors.lightBlue[value];
      case 28:
        return Colors.lightBlueAccent[value];
      case 29:
        return Colors.deepPurpleAccent[value];
      case 30:
        return Colors.lightBlue[value];
      case 31:
        return Colors.lightBlueAccent[value];
      case 32:
        return Colors.deepPurpleAccent[value];
      case 33:
        return Colors.red[value];
      case 34:
        return Colors.green[value];
      case 35:
        return Colors.blue[value];
      case 36:
        return Colors.amber[value];
      case 37:
        return Colors.teal[value];
      case 38:
        return Colors.orange[value];
      case 39:
        return Colors.indigo[value];
      case 40:
        return Colors.lime[value];
      case 41:
        return Colors.pink[value];
      case 42:
        return Colors.purple[value];
      case 43:
        return Colors.redAccent[value];
      case 44:
        return Colors.blueAccent[value];
      case 45:
        return Colors.pinkAccent[value];
      case 46:
        return Colors.tealAccent[value];
      case 47:
        return Colors.amberAccent[value];
      case 48:
        return Colors.limeAccent[value];
      case 49:
        return Colors.indigoAccent[value];
      case 50:
        return Colors.brown[value];
      default:
        return Colors.blue[value];
    }
  }
}
