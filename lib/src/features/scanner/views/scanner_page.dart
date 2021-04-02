import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/logic/scanner_provider.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/logic/scanner_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///ScannerPage
class ScannerPage extends StatelessWidget {
  ///ScannerPage constructor
  const ScannerPage({Key? key}) : super(key: key);

  ///ScannerPage [routeName]
  static const routeName = 'ScannerPage';

  ///Router for ScannerPage
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ScannerPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Page'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _ListView(),
            ),
            _ButtonsConsumer(),
          ],
        ),
      ),
    );
  }
}

class _ListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // ignore: omit_local_variable_types
    AsyncValue<List<ScanResult>> data = watch(streamProvider);

    return data.when(
      data: (list) => ListView.builder(
        itemBuilder: (context, i) => ListTile(
          title: Text('${list[i].device.name}'),
          subtitle: Text('${list[i].device.id}'),
        ),
        itemCount: list.length,
      ),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Error'),
    );
  }
}

class _ButtonsConsumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(scannerNotifierProvider.state);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          child: state.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ),
                )
              : const Text('Scan'),
          onPressed: !state.isLoading
              ? () {
                  context.read(scannerNotifierProvider).scan();
                }
              : null,
        ),
        ElevatedButton(
          child: const Text('Cancel Scan'),
          onPressed: state.isLoading
              ? () {
                  context.read(scannerNotifierProvider).stopScan();
                }
              : null,
        ),
      ],
    );
  }
}
