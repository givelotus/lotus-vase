import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cashew/bitcoincash/src/address.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import './send_info.dart';

class SendTab extends StatelessWidget {
  SendTab({Key key}) : super(key: key);

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CashewModel>(context);

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
              viewModel.showSendInfoScreen = true;
            }
          } catch (e) {
            print('error parsing address');
          }
          viewModel.sendToAddress = scanData;
        });
      },
      overlay: overlay,
    );

    return (Column(
        children: viewModel.showSendInfoScreen
            ? [SendInfo()]
            : [
                Expanded(child: qrWidget),
                Row(children: [
                  Expanded(
                      child: ElevatedButton(
                    autofocus: true,
                    onPressed: () => viewModel.showSendInfoScreen = true,
                    child: Text('Enter Address'),
                  ))
                ]),
              ]));
  }
}
