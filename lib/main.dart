import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_scanner/src/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: BluetoothScannerApp(),
    ),
  );
}
