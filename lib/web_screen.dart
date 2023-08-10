import 'dart:io';
//import 'package:file_picker/file_picker.dart';
//import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webviewflutter/dialogs/retry_dialog.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewflutter/dialogs/yes_no_dialog.dart';
import 'package:webviewflutter/utilities/localization.dart';

class WebScreen extends StatefulWidget {
  final List<String> initialUrl;
  const WebScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

//make internet checker and realod
class _WebScreenState extends State<WebScreen> {
  late String url;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    url = widget.initialUrl[0];
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    /*_webViewController = WebViewController()
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
    addFileSelectionListener();*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              onProgress: (int progress) {
                print("WebView is loading (progress : $progress%)");
              },
              navigationDelegate: (NavigationRequest request) {
                context.loaderOverlay.show();
                if (request.url.startsWith('https://www.youtube.com/')) {
                  context.loaderOverlay.show();
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                context.loaderOverlay.hide();
                print('Page finished loading: $url');
              },
              onWebResourceError: (WebResourceError webResourceError){
                context.loaderOverlay.hide();
                showDialog(
                    context: context,
                    builder: (context) => WillPopScope(
                      onWillPop: () async => false,
                      child: RetryDialog(
                        title: AppLocalization.of(context).translate("error_internet").toString(),
                        content: AppLocalization.of(context).translate("check_internet").toString(),
                        onRetry: (){
                            _webViewController.reload();
                            context.loaderOverlay.show();
                            },
                        onRollback: () async {
                          var navigator = Navigator.of(context);
                          if(await _webViewController.canGoBack() && !(await initialUrlsMatch())){
                            _webViewController.goBack();
                          }
                          else{
                            navigator.pop();
                          }
                        },
                      ),
                    ),
                );
              },
              gestureNavigationEnabled: true,
              geolocationEnabled: true,//support geolocation or not
            )
        ),
      ),
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

  Future<bool> initialUrlsMatch() async{
    for(url in widget.initialUrl){
      if(await _webViewController.currentUrl() == url) return true;
    }
    return false;
  }

  Future<bool> _onWillPop() async {
    var navigator = Navigator.of(context);
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
          onSuccess: (){navigator.pop();},
        ),
      )) ?? false;
    }
  }

}
