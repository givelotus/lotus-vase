import 'package:cashew/wallet.dart';
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
  final ValueNotifier<String> qrText = ValueNotifier<String>('');

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText.value = scanData;
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

class SendWidget extends StatefulWidget {
  final ValueNotifier<String> qrText;

  SendWidget({Key key, this.wallet, this.qrText}) : super(key: key);

  final Wallet wallet;

  @override
  _SendWidgetState createState() => _SendWidgetState(qrText: qrText);
}

class _SendWidgetState extends State<SendWidget> {
  TextEditingController _controller;
  final ValueNotifier<String> qrText;

  _SendWidgetState({this.qrText}) : super() {
    _controller = TextEditingController(text: this.qrText.value);
    qrText.addListener(() {
      _controller.text = this.qrText.value;
    });
  }

  void initState() {
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter an address'),
            )),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => {widget.wallet.send(_controller.text, 0)},
            )
          ],
        ));
  }
}
