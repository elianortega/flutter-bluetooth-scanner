import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_bluetooth_scanner/src/core/global_providers/theme_provider.dart';
import 'package:flutter_bluetooth_scanner/src/features/scanner/views/scanner_page.dart';

class BluetoothScannerApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDarkTheme = watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: (isDarkTheme ? ThemeData.dark() : ThemeData.light()).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => const Color(0xff42B982)),
          ),
        ),
        primaryColor: const Color(0xff42B982),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff42B982),
        ),
      ),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
      ],
      home: ScannerPage(),
    );
  }
}
