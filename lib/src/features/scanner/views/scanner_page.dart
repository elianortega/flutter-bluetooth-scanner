import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_scanner/src/core/constants/app_images.dart';
import 'package:flutter_bluetooth_scanner/src/core/global_providers/theme_provider.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/views/detail_page.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/views/widgets/scanning_status.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logic/scanner_provider.dart';
import '../logic/scanner_state.dart';
import './scanner_page_i18n.dart';

part './widgets/scanner_page_widgets.dart';

///Keys for testing
final kScanningStatusWidgetKey = UniqueKey();
final kScanButtonKey = UniqueKey();
final kItemListKey = UniqueKey();
final kScannerPageKey = UniqueKey();
final kLoadingIndicatorKey = UniqueKey();

//Rect animation provider
final rectAnimationProvider = StateProvider<Rect?>((ref) => null);

///ScannerPage
class ScannerPage extends StatelessWidget {
  ///ScannerPage constructor
  ScannerPage() : super(key: kScannerPageKey);

  ///ScannerPage [routeName]
  static const routeName = 'ScannerPage';

  ///Router for ScannerPage
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ScannerPage());
  }

  /// Animation variables
  final Duration animationDuration = const Duration(milliseconds: 300);
  final Duration delay = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    void _onTap({required Widget page}) async {
      context.read(rectAnimationProvider).state =
          const Rect.fromLTRB(0.0, 733.3, 375.0, 812.0);
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) {
          context.read(rectAnimationProvider).state = context
              .read(rectAnimationProvider)
              .state
              ?.inflate(1.3 * MediaQuery.of(context).size.longestSide);

          Future.delayed(animationDuration + delay, () {
            context.read(scannerNotifierProvider.notifier).pauseScan();
            return Navigator.of(context)
                .push(FadeRouteBuilder(page: page))
                .then(
              (_) {
                context.read(scannerNotifierProvider.notifier).resumeScan();
                context.read(rectAnimationProvider).state = null;
              },
            );
          });
        },
      );
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(kScannerPage.i18n),
            leading: Hero(
              tag: 'app_logo',
              child: Image.asset(
                AppImages.transparentLog,
              ),
            ),
            actions: [_IconThemeToggler()],
          ),
          body: Column(
            children: [
              Text(kWelcomeMessage.i18n),
              _ListView(
                onTap: _onTap,
              ),
              // _ButtonsConsumer(),
            ],
          ),
        ),
        const _RippleAnimation(),
        ScanningStatus(
          key: kScanningStatusWidgetKey,
        ),
      ],
    );
  }
}

class _RippleAnimation extends ConsumerWidget {
  const _RippleAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rect = watch(rectAnimationProvider).state;

    return rect == null
        ? Container()
        : AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: rect.left,
            right: MediaQuery.of(context).size.width - rect.right,
            top: rect.top,
            bottom: MediaQuery.of(context).size.height - rect.bottom,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff42B982),
              ),
            ),
          );
  }
}
