import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/views/scanner_page.dart';

class BluetoothScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScannerPage(),
    );
  }
}
