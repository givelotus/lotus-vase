import 'package:cashew/wallet/wallet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cashew/constants.dart';

class ReceiveTab extends StatelessWidget {
  ReceiveTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final address = wallet.keys.getExternalAddress(0);
    final strAddress = address.toCashAddress();
    final _controller = TextEditingController(text: strAddress);

    final manualCard = Card(
        child: Column(children: [
          ListTile(
            title: const Text('Text Address'),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                readOnly: true,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ))
        ]),
        elevation: cardElevation);

    final qrCard = Card(
      child: Column(children: [
        ListTile(
          title: const Text('QR Address'),
        ),
        QrImage(data: strAddress, version: QrVersions.auto)
      ]),
      elevation: cardElevation,
    );
    return Column(children: [
      Padding(
        padding: cardPadding,
        child: qrCard,
      ),
      Padding(padding: cardPadding, child: manualCard)
    ]);
  }
}
