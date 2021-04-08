import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/logic/scanner_provider.dart';

final kScanningKey = UniqueKey();
final kNoScanningKey = UniqueKey();

class ScanningStatus extends ConsumerWidget {
  const ScanningStatus({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(scannerNotifierProvider);
    return Positioned(
      bottom: 20,
      right: 20,
      child: SafeArea(
        child: AnimatedContainer(
          key: state.isLoading ? kScanningKey : kNoScanningKey,
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state.isLoading ? Colors.green : Colors.red,
          ),
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
