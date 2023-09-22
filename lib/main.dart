import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webviewflutter/utilities/constants.dart';
import 'package:webviewflutter/utilities/localization.dart';
import 'package:webviewflutter/routes/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      kDebugMode &&
      defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  await Constants.load();
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
        title: 'Kecubung Admin',
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
        ),
        supportedLocales: const [Locale('en'),Locale('id')],
        localizationsDelegates: const [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const MenuScreen(),
      ),
    );
  }
}
