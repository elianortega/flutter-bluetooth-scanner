import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

abstract class IScannerRepository {
  Stream scan();
}

class ScannerRepository implements IScannerRepository {
  @override
  Stream<List<ScanResult>> scan() {
    final flutterBlue = FlutterBlue.instance;

    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 5));

    // Listen to scan results
    return flutterBlue.scanResults;
  }
}
