import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webviewflutter/utilities/localization.dart';
import 'package:webviewflutter/web_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      kDebugMode &&
      defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: 'Web View Flutter',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
              accentColor: Colors.blueAccent,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
            ).copyWith(tertiary: Colors.green),
            primaryColorDark: Colors.white,
            dividerColor: Colors.grey[400],
            //disabledColor: Colors.grey[400],
            disabledColor: Colors.black,
            cardTheme: const CardTheme(color: Colors.white,elevation: 3),
            fontFamily: 'Arimo'
        ),
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue,
                accentColor: Colors.blueAccent,
                brightness: Brightness.dark,
                backgroundColor: Colors.grey[900]
            ).copyWith(tertiary: Colors.green),
            primaryColorDark: Colors.white,
            dividerColor: Colors.grey[700],
            //disabledColor: Colors.grey[700],
            disabledColor: Colors.white,
            cardTheme: CardTheme(color: Colors.grey[800], elevation: 3),
            fontFamily: 'Arimo'
        ),
        supportedLocales: const [Locale('en'),Locale('id')],
        localizationsDelegates: const [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const WebScreen(initialUrl: ["https://arie.ls/filetest/","https://reward.grandkecubunghotel.com/", "https://reward.grandkecubunghotel.com/rasio/login/&url=https:-*%7C%7C*-reward.grandkecubunghotel.com/rasio/","https://reward.grandkecubunghotel.com/rasio/home"]),
      ),
    );
  }
}
