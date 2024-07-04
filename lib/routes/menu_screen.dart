import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewflutter/routes/login_screen.dart';
import 'package:webviewflutter/routes/scan_screen.dart';
import 'package:webviewflutter/routes/web_screen.dart';
import 'package:webviewflutter/widgets/boxes.dart';
import 'package:webviewflutter/widgets/labels.dart';
import 'package:webviewflutter/widgets/misc.dart';

import '../utilities/localization.dart';
import '../utilities/secured_storage.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            const Row(),
            const Gap(height: "regular"),
            Image.asset("images/logo.png", width: 100, fit: BoxFit.fitHeight),
            const Gap(height: "regular"),
            BasicLabel(text: AppLocalization.of(context).translate("title"), font: "super_large"),
            const Gap(height: "regular"),
            PaddingBox(
              child: SizedBox(
                width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    SecuredStorage securedStorage = Provider.of<SecuredStorage>(context, listen: false);
                    securedStorage.checkExpiry().then((response) {
                      if (!securedStorage.isEmpty()) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return const ScanScreen();
                        }));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return const LoginScreen();
                        }));
                      }
                    });
                  }, child: BasicLabel(text: AppLocalization.of(context).translate("scanner")))
              ),
            ),
            PaddingBox(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const WebScreen(initialUrl: ["https://admin.grandkecubunghotel.com/","https://admin.grandkecubunghotel.com/rasio/login/logout","https://admin.grandkecubunghotel.com/rasio/login"]);
                  }));
                }, child: BasicLabel(text: AppLocalization.of(context).translate("admin"))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
