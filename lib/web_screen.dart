import 'dart:io';
//import 'package:file_picker/file_picker.dart';
//import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
//import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webviewflutter/dialogs/retry_dialog.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewflutter/dialogs/yes_no_dialog.dart';
import 'package:webviewflutter/utilities/localization.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class WebScreen extends StatefulWidget {
  final List<String> initialUrl;
  final ChromeSafariBrowser browser = MyChromeSafariBrowser();
  WebScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

//make internet checker and realod
class _WebScreenState extends State<WebScreen> {
  late String url;

  @override
  void initState() {
    super.initState();
    url = widget.initialUrl[0];
    widget.browser.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 1,
        label: 'Custom item menu 1',
        action: (url, title) {
          print('Custom item menu 1 clicked!');
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: WillPopScope(
            onWillPop: ()async {return false;},
            child: ElevatedButton(
            onPressed: () async {
              await widget.browser.open(
                  url: Uri.parse(url),
                  options: ChromeSafariBrowserClassOptions(
                    android: AndroidChromeCustomTabsOptions(
                        isTrustedWebActivity: true),
                  ));
            }, child: Text("Open Android TWA Browser"),
        ),
      ),
    )
    );
  }

  /*void addFileSelectionListener() async {
    if (Platform.isAndroid) {
      final androidController = _webViewController.platform as AndroidWebViewController;
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(final FileSelectorParams params) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      return [file.uri.toString()];
    }
    return [];
  }*/

  /*Future<bool> initialUrlsMatch() async{
    for(url in widget.initialUrl){
      if(await widget.browser == url) return true;
    }
    return false;
  }

  Future<bool> _onWillPop() async {
    if(await _webViewController.canGoBack() && !(await initialUrlsMatch())){
      _webViewController.goBack();
      return false;
    }
    else{
      return (await showDialog(
        context: context,
        builder: (context) => YesNoDialog(
          title: AppLocalization.of(context).translate("exit").toString(),
          content: AppLocalization.of(context).translate("exit_content").toString(),
          onSuccess: (){FlutterExitApp.exitApp();},
        ),
      )) ?? false;
    }
  }*/

}
