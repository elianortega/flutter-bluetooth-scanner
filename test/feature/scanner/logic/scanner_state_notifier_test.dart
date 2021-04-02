import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/logic/scanner_provider.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/logic/scanner_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFutterBlue extends Mock implements FlutterBlue {}

class Listener extends Mock {
  void call(ScannerState state);
}

void main() {
  group('QrGeneratorStateNotifier', () {
    late MockFutterBlue _flutterBlue;

    setUp(() {
      _flutterBlue = MockFutterBlue();
    });

    test(
      'initial state is ScannerState.initial()',
      () {
        expect(
          ScannerNotifier(flutterBlue: _flutterBlue).debugState,
          const ScannerState.initial(),
        );
      },
    );
  });
}
