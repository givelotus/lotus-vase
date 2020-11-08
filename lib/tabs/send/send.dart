import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cashew/bitcoincash/src/address.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import './send_info.dart';

class SendTab extends StatefulWidget {
  SendTab({Key key}) : super(key: key);

  @override
  _SendTabState createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  ValueNotifier<bool> showSendInfoScreen;

  @override
  void initState() {
    // TODO: implement initState
    showSendInfoScreen = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // WE don't want to be redrawing
    final viewModel = Provider.of<CashewModel>(context, listen: false);

    final overlay = QrScannerOverlayShape(
      borderColor: Colors.red,
      borderRadius: 10,
      borderLength: 30,
      borderWidth: 10,
      cutOutSize: 300,
    );

    final qrWidget = QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        controller.scannedDataStream.listen((scanData) {
          try {
            // Try parsing
            // TODO: We need a tryParse function. Exceptions for validity check is
            // not desirable.
            Address(scanData);
            if (scanData != viewModel.sendToAddress) {
              showSendInfoScreen.value = true;
            }
          } catch (e) {
            print('error parsing address');
          }
          viewModel.sendToAddress = scanData;
        });
      },
      overlay: overlay,
    );

    return ValueListenableBuilder(
        valueListenable: showSendInfoScreen,
        builder: (context, shouldShowSendInfoScreen, child) => Column(
            children: shouldShowSendInfoScreen
                ? [SendInfo(visible: showSendInfoScreen)]
                : [
                    Expanded(child: qrWidget),
                    Row(children: [
                      Expanded(
                          child: ElevatedButton(
                        autofocus: true,
                        onPressed: () => showSendInfoScreen.value = true,
                        child: Text('Enter Address'),
                      ))
                    ]),
                  ]));
  }
}
