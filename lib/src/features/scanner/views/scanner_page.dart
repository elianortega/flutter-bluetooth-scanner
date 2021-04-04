import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bluetooth_scanner/src/core/global_providers/theme_provider.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/views/detail_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rect_getter/rect_getter.dart';

import '../logic/scanner_provider.dart';
import '../logic/scanner_state.dart';
import './scanner_page_i18n.dart';

///ScannerPage
class ScannerPage extends HookWidget {
  ///ScannerPage constructor
  ScannerPage({Key? key}) : super(key: key);

  ///ScannerPage [routeName]
  static const routeName = 'ScannerPage';

  ///Router for ScannerPage
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ScannerPage());
  }

  /// Animation variables
  final _reactGetterKey = RectGetter.createGlobalKey();
  final Duration animationDuration = const Duration(milliseconds: 300);
  final Duration delay = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final rect = useState<Rect?>(null);

    void _onTap({required Widget page}) async {
      rect.value = RectGetter.getRectFromKey(_reactGetterKey);
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) {
          rect.value = rect.value
              ?.inflate(1.3 * MediaQuery.of(context).size.longestSide);

          Future.delayed(
            animationDuration + delay,
            () => Navigator.of(context)
                .push(FadeRouteBuilder(page: page))
                .then((_) => rect.value = null),
          );
        },
      );
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Scanner Page'),
            leading: Hero(
              tag: 'app_logo',
              child: Image.asset(
                'assets/images/transparent_hypervolt_logo.png',
              ),
            ),
            actions: [
              _IconThemeToggler(),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Text(kWelcomeMessage.i18n),
                Expanded(
                  child: _ListView(
                    onTap: _onTap,
                  ),
                ),
                RectGetter(
                  key: _reactGetterKey,
                  child: _ButtonsConsumer(),
                ),
              ],
            ),
          ),
        ),
        rect.value == null
            ? Container()
            : AnimatedPositioned(
                duration: animationDuration,
                left: rect.value!.left,
                right: MediaQuery.of(context).size.width - rect.value!.right,
                top: rect.value!.top,
                bottom: MediaQuery.of(context).size.height - rect.value!.bottom,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff42B982),
                  ),
                ),
              ),
      ],
    );
  }
}

class _IconThemeToggler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDarkTheme = watch(themeProvider.state);
    return IconButton(
      onPressed: context.read(themeProvider).toggleTheme,
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
      data: (list) => ListView.builder(
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
