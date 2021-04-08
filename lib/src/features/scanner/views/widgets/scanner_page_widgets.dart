part of '../scanner_page.dart';

class _IconThemeToggler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDarkTheme = watch(themeProvider);
    return IconButton(
      onPressed: context.read(themeProvider.notifier).toggleTheme,
      icon: Icon(
        isDarkTheme ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
      ),
    );
  }
}

class _ListView extends ConsumerWidget {
  _ListView({required this.onTap});
  final void Function({required Widget page}) onTap;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // ignore: omit_local_variable_types
    AsyncValue<List<ScanResult>> data = watch(streamProvider);

    return data.when(
      data: (list) => Expanded(
        child: ListView.builder(
          key: kItemListKey,
          itemBuilder: (context, i) {
            final scanResult = list[i];
            return ListTile(
              title: Text('${scanResult.device.name}'),
              subtitle: Text('${scanResult.device.id}'),
              onTap: () {
                onTap(
                  page: DetailPage(scanResult: scanResult),
                );
              },
            );
          },
          itemCount: list.length,
        ),
      ),
      loading: () => const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
      error: (_, __) => const Text('Error'),
    );
  }
}

class _ButtonsConsumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(scannerNotifierProvider);
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            key: kScanButtonKey,
            child: state.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      key: kLoadingIndicatorKey,
                      strokeWidth: 3.0,
                    ),
                  )
                : const Text('Scan'),
            onPressed: !state.isLoading
                ? () {
                    context.read(scannerNotifierProvider.notifier).resumeScan();
                  }
                : null,
          ),
          ElevatedButton(
            child: const Text('Cancel Scan'),
            onPressed: state.isLoading
                ? () {
                    context.read(scannerNotifierProvider.notifier).pauseScan();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  FadeRouteBuilder({required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
  final Widget page;
}
