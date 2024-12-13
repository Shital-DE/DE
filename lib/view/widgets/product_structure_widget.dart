import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/model/product/product_structure_model.dart';

class LinePainter extends CustomPainter {
  final BuildContext context;
  final ProductStructureDetailsModel node;
  final double androidstartY;
  final double wendY;
  LinePainter(
      {required this.context,
      required this.node,
      this.androidstartY = -12,
      this.wendY = 24});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    final x = (size.width / 2) - 85;
    double startY = Platform.isAndroid ? androidstartY : -7;

    double endY = size.height - (Platform.isAndroid ? 32 : wendY);

    final startPoint = Offset(x, startY);
    final endPoint = Offset(x, endY);
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HorizontalLinePainter extends CustomPainter {
  final BuildContext context;
  final ProductStructureDetailsModel node;
  final String product;

  HorizontalLinePainter(
      {required this.context, required this.node, required this.product});
  @override
  void paint(Canvas canvas, Size size) {
    if (node.buildProductStructure![0].level! > 0) {
      final paint = Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.0;
      final y = size.height / 2;
      double startX = Platform.isAndroid ? -2 : -2.2;
      final endX = size.width / 2;
      final startPoint = Offset(startX, y);
      final endPoint = Offset(endX, y);
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ProductTypeStaticDataModel {
  static const String hardwareId = '402881e559cf1bb70159cf31148f000c';
  static const String consumablesId = 'Consumables';
  static const String partId = '4028b88151c96d3f0151c96fecf00002';
  static const String assemblyId = '4028b88151c96d3f0151c96fd3120001';
}
