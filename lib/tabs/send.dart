import 'package:cashew/wallet/wallet.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

import '../constants.dart';

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
    final qrWidget = QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: overlay,
    );
    // final qrWidget = Text('Placeholder');
    final addressRow = AddressWidget(qrText: qrText);
    final sliderButton = SliderButton(
      buttonColor: Colors.blue,
      dismissible: false,
      shimmer: false,
      alignLabel: Alignment.center,
      height: 48,
      buttonSize: 48,
      width: double.infinity,
      label: Text('Slide to send!'),
      action: null,
      icon: Center(
          child: Icon(
        Icons.send,
        color: Colors.white,
      )),
    );
    final sendButton = Row(children: [
      Expanded(child: Padding(padding: stdPadding, child: sliderButton))
    ]);
    final amountWidget = AmountWidget();
    final sendSheet = Column(
      children: [addressRow, amountWidget, sendButton],
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Expanded(child: qrWidget),
        DraggableScrollableSheet(
            initialChildSize: 0.125,
            minChildSize: 0.125,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: sendSheet,
              );
            })
      ],
    );
  }
}

class AmountWidget extends StatelessWidget {
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Padding(
              padding: stdPadding,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _controller,
                decoration: InputDecoration(
                    suffixText: 'sats',
                    border: OutlineInputBorder(),
                    hintText: 'Enter amount'),
              ))),
      FlatButton(onPressed: () {}, child: Text('Max'))
    ]);
  }
}

class AddressWidget extends StatelessWidget {
  final String qrText;

  AddressWidget({Key key, this.qrText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: stdPadding,
        child: Row(
          children: [
            Expanded(
                child: TextField(
              keyboardType: TextInputType.text,
              controller: TextEditingController(text: qrText),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter recipient address'),
            )),
            IconButton(
              icon: Icon(Icons.contacts),
              onPressed: () => {}, //widget.wallet.send(this.qrText.value, 0)},
            )
          ],
        ));
  }
}
