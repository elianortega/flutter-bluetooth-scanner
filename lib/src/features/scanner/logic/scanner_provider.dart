import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'scanner_state.dart';
export 'scanner_state.dart';

part 'scanner_state_notifier.dart';

/// Provider to use the ScannerStateNotifier
final scannerNotifierProvider =
    StateNotifierProvider<ScannerNotifier, ScannerState>(
  (ref) => ScannerNotifier(
    flutterBlue: ref.watch(_flutterBlueProvider),
  )..resumeScan(),
);

final streamProvider = StreamProvider.autoDispose<List<ScanResult>>(
  (ref) async* {
    final flutterBlue = ref.watch(_flutterBlueProvider);

    // Parse the value received and emit a Message instance
    await for (final results in flutterBlue.scanResults) {
      yield results;
    }
  },
);

final _flutterBlueProvider = Provider<FlutterBlue>(
  (ref) => FlutterBlue.instance,
);
