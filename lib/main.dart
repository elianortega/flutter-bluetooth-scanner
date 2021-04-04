import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_scanner/src/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ProviderScope(
      child: BluetoothScannerApp(),
    ),
  );
}
