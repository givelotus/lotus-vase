import 'package:cashew/wallet/wallet.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class SendTab extends StatefulWidget {
  SendTab({Key key, this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  _SendTabState createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText = '';

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = QrScannerOverlayShape(
      borderColor: Colors.red,
      borderRadius: 10,
      borderLength: 30,
      borderWidth: 10,
      cutOutSize: 300,
    );
    return Column(
      children: [
        Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: overlay,
            )),
        Expanded(flex: 1, child: SendWidget(qrText: qrText))
      ],
    );
  }
}

class SendWidget extends StatelessWidget {
  final String qrText;

  SendWidget({Key key, this.wallet, this.qrText}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: TextEditingController(text: qrText),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter an address'),
            )),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => {}, //widget.wallet.send(this.qrText.value, 0)},
            )
          ],
        ));
  }
}
