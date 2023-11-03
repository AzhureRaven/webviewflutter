import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:webviewflutter/models/voucher.dart';
import 'package:webviewflutter/utilities/constants.dart';
import 'package:webviewflutter/utilities/dates.dart';
import 'package:webviewflutter/widgets/labels.dart';

import '../dialogs/yes_no_dialog.dart';
import '../models/account.dart';
import '../utilities/http_api.dart';
import '../utilities/localization.dart';
import '../utilities/secured_storage.dart';
import '../widgets/boxes.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String id = "";
  String info = "";
  late SecuredStorage securedStorage;
  late Account account;
  late Voucher voucher;

  @override
  void initState() {
    super.initState();
    securedStorage = SecuredStorage();
    account = securedStorage.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("scanner").toString()),
        actions: [
          Text(account.nama.toString()),
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return YesNoDialog(
                    title: AppLocalization.of(context).translate("logout").toString(),
                    content: AppLocalization.of(context).translate("logout_content").toString(),
                    onSuccess: () {
                      securedStorage.removeSession();
                      Navigator.pop(context);
                    }
                );
              },
            );
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          PaddingBox(
            child: SizedBox(
                width: double.infinity,
                height: Constants.getLengthSize("medium"),
                child: ElevatedButton(
                    onPressed: _scanQR,
                    child: BasicLabel(text: AppLocalization.of(context).translate("start_scan").toString())
                )
            ),
          ),
          BasicLabel(text: id, font: "large"),
          BasicLabel(text: info),
        ],
      ),
    );
  }

  Future<void> _scanQR() async {
    String qrResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // scanner border color
      AppLocalization.of(context).translate("cancel").toString(), // cancel button text
      true, // flash on
      ScanMode.QR, // scan mode
    );
    if (!mounted) return;
    setState(() {
      if (qrResult != "-1") {
        id = qrResult;
        context.loaderOverlay.show();
        Map<String, String> data = {
          'kode':id.toString(),
          'user_name': account.username.toString(),
          'name': account.nama.toString()
        };
        HttpApi http = HttpApi(url: "https://admin.grandkecubunghotel.com/api/v1.0/redeem_voucher", data: data);
        Future<String> result = http.postStringData();
        result.then((response){
          context.loaderOverlay.hide();
          try{
            voucher = parseVoucher(response);
            setState(() {
              var local = AppLocalization.of(context);
              info = "${local.translate("success_1").toString()} ${voucher.nmbank} ${local.translate("success_2").toString()} ${voucher.nmsub} ${local.translate("success_3").toString()} ${getCurrentDateTime("yyyy-MM-dd HH:mm:ss")}";
            });
          }catch(e){
            print(e);
            setState(() {
              info = AppLocalization.of(context).translate("error_2").toString();
            });
          }
        }).catchError((e){
          context.loaderOverlay.hide();
          print(e);
          setState(() {
            info = AppLocalization.of(context).translate("error_1").toString();
          });
        });
      } else {
        info = AppLocalization.of(context).translate("qr_error").toString();
      }
    });
  }
}
