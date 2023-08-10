import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:webviewflutter/utilities/constants.dart';
import 'package:webviewflutter/widgets/labels.dart';

import '../utilities/localization.dart';
import '../widgets/boxes.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String id = "";
  String info = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("scanner").toString()),
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
          BasicLabel(text: info)
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
        setState(() {
          id = qrResult;
        });
      } else {
        id = AppLocalization.of(context).translate("qr_error").toString();
      }
    });
  }
}
