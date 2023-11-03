import 'dart:io';
//import 'package:file_picker/file_picker.dart';
//import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webviewflutter/dialogs/retry_dialog.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewflutter/dialogs/yes_no_dialog.dart';
import 'package:webviewflutter/utilities/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class WebScreen extends StatefulWidget {
  final List<String> initialUrl;
  const WebScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

//make internet checker and realod
class _WebScreenState extends State<WebScreen> {
  late String url;
  late InAppWebViewController webViewController;
  PullToRefreshController? pullToRefreshController;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewSettings settings = InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    geolocationEnabled: true,
    javaScriptEnabled: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    useShouldOverrideUrlLoading: true,
    useHybridComposition: true
  );

  @override
  void initState() {
    super.initState();
    url = widget.initialUrl[0];

    pullToRefreshController = kIsWeb ? null : PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController.loadUrl(
              urlRequest: URLRequest(url: await webViewController.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: getWebView()
        ),
      ),
    );
  }

  Widget getWebView() {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: settings,
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStart: (controller, url) {
        context.loaderOverlay.show();
        setState(() {
          this.url = url.toString();
        });
      },
      onPermissionRequest: (controller, request) async {
        final resources = <PermissionResourceType>[];
        if (request.resources.contains(PermissionResourceType.CAMERA)) {
          final cameraStatus = await Permission.camera.request();
          if (!cameraStatus.isDenied) {
            resources.add(PermissionResourceType.CAMERA);
          }
        }
        if (request.resources
            .contains(PermissionResourceType.MICROPHONE)) {
          final microphoneStatus =
          await Permission.microphone.request();
          if (!microphoneStatus.isDenied) {
            resources.add(PermissionResourceType.MICROPHONE);
          }
        }
        // only for iOS and macOS
        if (request.resources
            .contains(PermissionResourceType.CAMERA_AND_MICROPHONE)) {
          final cameraStatus = await Permission.camera.request();
          final microphoneStatus =
          await Permission.microphone.request();
          if (!cameraStatus.isDenied && !microphoneStatus.isDenied) {
            resources.add(PermissionResourceType.CAMERA_AND_MICROPHONE);
          }
        }

        return PermissionResponse(
            resources: resources,
            action: resources.isEmpty
                ? PermissionResponseAction.DENY
                : PermissionResponseAction.GRANT);
      },
      shouldOverrideUrlLoading:
          (controller, navigationAction) async {
        var uri = navigationAction.request.url!;

        if (![
          "http",
          "https",
          "file",
          "chrome",
          "data",
          "javascript",
          "about"
        ].contains(uri.scheme)) {
          if (await canLaunchUrl(uri)) {
            // Launch the App
            await launchUrl(
              uri,
            );
            // and cancel the request
            return NavigationActionPolicy.CANCEL;
          }
        }

        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (controller, url) async {
        pullToRefreshController?.endRefreshing();
        context.loaderOverlay.hide();
        setState(() {
          this.url = url.toString();
        });
      },
      onReceivedError: (controller, request, error) {
        pullToRefreshController?.endRefreshing();
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (context) =>
              WillPopScope(
                onWillPop: () async => false,
                child: RetryDialog(
                  title: AppLocalization.of(context)
                      .translate("error_internet")
                      .toString(),
                  content: AppLocalization.of(context).translate(
                      "check_internet").toString(),
                  onRetry: () {
                    webViewController.reload();
                    context.loaderOverlay.show();
                  },
                  onRollback: () async {
                    var navigator = Navigator.of(context);
                    if (await webViewController.canGoBack() &&
                        !(await initialUrlsMatch())) {
                      webViewController.goBack();
                    }
                    else {
                      navigator.pop();
                    }
                  },
                ),
              ),
        );
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          pullToRefreshController?.endRefreshing();
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        setState(() {
          this.url = url.toString();
        });
      },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage);
      },
    );
  }

  Future<bool> initialUrlsMatch() async{
    for(url in widget.initialUrl){
      var uri = await webViewController.getUrl();
      if(uri?.uriValue.toString() == url.toString()) return true;
    }
    return false;
  }

  Future<bool> _onWillPop() async {
    if(await webViewController.canGoBack() && !(await initialUrlsMatch())){
      webViewController.goBack();
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
  }

}
