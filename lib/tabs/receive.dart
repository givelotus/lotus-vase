import 'package:cashew/wallet/wallet.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cashew/constants.dart';

class ReceiveTab extends StatelessWidget {
  ReceiveTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    if (wallet == null) {
      return Container();
    }

    final keys = wallet.keys.keys.sublist(0);
    keys.shuffle();

    final keyInfo = keys.firstWhere((keyInfo) => keyInfo.isChange == false);
    final strAddress = keyInfo.address.toCashAddress();
    final _controller = TextEditingController(text: strAddress);

    final manualCard = Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  height: 60.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: strAddress,
                        ),
                      );

                      Scaffold.of(context).showSnackBar(
                        copiedAd,
                      );
                    },
                    child: Icon(Icons.copy),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      elevation: stdElevation,
    );

    final qrCard = Card(
      child: QrImage(
        data: strAddress,
        version: QrVersions.auto,
      ),
      elevation: stdElevation,
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: stdPadding,
              child: qrCard,
            ),
            Padding(
              padding: stdPadding,
              child: manualCard,
            ),
          ],
        ),
      ),
    );
  }
}
