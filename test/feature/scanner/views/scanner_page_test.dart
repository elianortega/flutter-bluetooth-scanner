import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/logic/scanner_provider.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/logic/scanner_state.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/views/widgets/scanning_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_bluetooth_scanner/src/features/scanner/views/scanner_page.dart';

class MockFlutterBlue extends Mock implements FlutterBlue {}

void main() {
  group('ScannerPage', () {
    test('has a route', () {
      expect(ScannerPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a ScannerPage', (tester) async {
      ///act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ScannerPage(),
          ),
        ),
      );

      ///expect
      expect(find.byKey(kScannerPageKey), findsOneWidget);
    });

    testWidgets('renders a Scan Status Widget when page loaded',
        (tester) async {
      ///act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            scannerNotifierProvider.overrideWithValue(
              ScannerNotifier(
                flutterBlue: MockFlutterBlue(),
                initialState: const ScannerState.initial(),
              ),
            ),
          ],
          child: MaterialApp(
            home: ScannerPage(),
          ),
        ),
      );

      ///expect
      expect(find.byKey(kScanningStatusWidgetKey), findsOneWidget);
    });

    testWidgets('renders ScannerStatusGreen For ScannerState.Loading',
        (tester) async {
      ///Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            scannerNotifierProvider.overrideWithValue(
              ScannerNotifier(
                flutterBlue: MockFlutterBlue(),
                initialState: const ScannerState.loading(),
              ),
            ),
          ],
          child: MaterialApp(
            home: ScannerPage(),
          ),
        ),
      );

      ///Expect
      expect(find.byKey(kScanningKey), findsOneWidget);
    });
  });
}
