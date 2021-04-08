import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_scanner/src/core/animations/simple_slide_animation.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/views/widgets/scanning_status.dart';
import './detail_page_i18n.dart';

///DetailPage
class DetailPage extends StatelessWidget {
  ///DetailPage constructor
  const DetailPage({Key? key, required this.scanResult}) : super(key: key);

  ///DetailPage [routeName]
  static const routeName = 'DetailPage';

  ///Router for DetailPage
  static Route route({required ScanResult scanResult}) {
    return MaterialPageRoute<void>(
      builder: (_) => DetailPage(
        scanResult: scanResult,
      ),
    );
  }

  final ScanResult scanResult;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    'assets/images/transparent_hypervolt_logo.png',
                    height: 150,
                  ),
                ),
                Text(
                  '${kScannedItemDetails.i18n}',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                SimpleSlideAnimation(
                  initialOffset: const Offset(100, 100),
                  child: Text(
                    '${kName.i18n} ${scanResult.device.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20.0),
                SimpleSlideAnimation(
                  initialOffset: const Offset(-100, -100),
                  child: Text(
                    '${kMac.i18n} ${scanResult.device.id}',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        const ScanningStatus(),
      ],
    );
  }
}
