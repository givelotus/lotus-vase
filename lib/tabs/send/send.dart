import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cashew/bitcoincash/address.dart';
import 'dart:math';
import 'dart:core';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import './send_info.dart';
import './sendModel.dart';

class SendTab extends StatefulWidget {
  final PageController controller;

  SendTab({Key key, @required this.controller}) : super(key: key);

  @override
  _SendTabState createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _SendTabState() : super();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenDimension = MediaQuery.of(context).size;

    // WE don't want to be redrawing
    final viewModel = Provider.of<SendModel>(context, listen: false);
    final walletModel = Provider.of<WalletModel>(context, listen: false);
    final balanceNotifier = walletModel.balance;

    final overlay = QrScannerOverlayShape(
      borderColor: Colors.green,
      borderRadius: 10,
      borderLength: 30,
      borderWidth: 10,
      cutOutSize: screenDimension.width - 50,
    );

    final qrWidget = QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        controller.scannedDataStream.listen((scanData) {
          try {
            final parseObject = Uri.parse(scanData);
            final unparsedAmount = parseObject.queryParameters['amount'];
            final amount = unparsedAmount == null
                ? double.nan
                : double.parse(unparsedAmount, (value) => double.nan);

            Address(parseObject.path);
            // Use the unparsed version, so that it appears as it was originally copied
            viewModel.sendToAddress = parseObject.path ?? '';
            viewModel.sendAmount = amount.isNaN
                ? viewModel.sendAmount
                : (amount * 100000000).truncate();

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendInfo(),
                ));
          } catch (err) {
            showError(context, 'Unable to parse QR code');
            // Invalid address
          }
        });
      },
      overlay: overlay,
    );

    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Container(
            child: qrWidget,
            width: screenDimension.width,
            height: screenDimension.height),
        Positioned(
          bottom: 5,
          child: IconButton(
              icon: Icon(Icons.send),
              iconSize: 95.00,
              color: Colors.white,
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendInfo(),
                    ),
                  )),
        ),
        Positioned(
          top: screenDimension.height * .1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              color: Colors.grey[400].withOpacity(0.6),
              child: Row(
                children: [
                  // TODO: Dedupe this widget.
                  ValueListenableBuilder(
                      valueListenable: balanceNotifier,
                      builder: (context, balance, child) {
                        if (balance != null && balance.error != null) {
                          return Text(
                            balance.error.message,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          );
                        }
                        if (balance == null || balance.balance == null) {
                          return Text(
                            'Loading...',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          );
                        }
                        return Text.rich(TextSpan(
                          text: '${balance.balance}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: ' sats',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 15),
                            ),
                          ],
                        ));
                      }),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 35.0,
          left: 20.0,
          child: IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            iconSize: 50.00,
            onPressed: () {
              widget.controller.animateToPage(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        Positioned(
          bottom: 35.0,
          right: 20.0,
          child: IconButton(
            icon: Icon(Icons.save_alt),
            color: Colors.white,
            iconSize: 50.00,
            onPressed: () {
              widget.controller.animateToPage(
                2,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ]),
    );
  }
}
