import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  final List<String> initialUrl;
  const WebScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  late String url;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    url = widget.initialUrl[0];
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print(progress.toString());
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            context.loaderOverlay.hide();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            context.loaderOverlay.show();
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    addFileSelectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop,
    child: SafeArea(child: WebViewWidget(controller: _webViewController)));
  }

  void addFileSelectionListener() async {
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
  }

  Future<bool> initialUrlsMatch() async{
    for(url in widget.initialUrl){
      if(await _webViewController.currentUrl() == url) return true;
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
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      )) ?? false;
    }
  }

}
