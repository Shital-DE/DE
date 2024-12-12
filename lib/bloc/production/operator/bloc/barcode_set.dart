import 'dart:async';

import 'package:de/services/model/operator/oprator_models.dart';
import 'package:de/services/repository/operator/operator_repository.dart';

class BarcodeSetBloc {
  String barcodeNo = "";

  final _stateStreamController = StreamController<String>.broadcast();
  StreamSink<String> get barcodeSink => _stateStreamController.sink;
  Stream<String> get barcodeStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<String>();
  StreamSink<String> get eventSink => _eventStreamController.sink;
  Stream<String> get eventStream => _eventStreamController.stream;

  BarcodeSetBloc() {
    barcodeSink.add(barcodeNo);
    eventStream.listen((event) {
      if (event == "") {
        barcodeSink.add(event);
      } else if (event != "") {
        barcodeSink.add(event);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

class BarcodeData {
  Barcode barcodeData = Barcode();

  final _stateStreamController = StreamController<Barcode>.broadcast();
  StreamSink<Barcode> get barcodeSink => _stateStreamController.sink;
  Stream<Barcode> get barcodeStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<Map<String, String>>();
  StreamSink<Map<String, String>> get eventSink => _eventStreamController.sink;
  Stream<Map<String, String>> get eventStream => _eventStreamController.stream;

  BarcodeData() {
    barcodeSink.add(barcodeData);
    eventStream.listen((event) async {
      if (event.isNotEmpty) {
        barcodeData = await OperatorRepository.getBarcodeDataRepo(
            year: event['year'] ?? "", documentno: event['document_no'] ?? "");
        barcodeSink.add(barcodeData);
      } else {
        barcodeSink.add(barcodeData);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
