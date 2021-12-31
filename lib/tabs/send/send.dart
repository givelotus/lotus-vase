import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vase/lotus/utils/parse_uri.dart';
import 'package:vase/viewmodel.dart';

import './sendModel.dart';
import './send_info.dart';
import '../../constants.dart';
import '../../lotus/utils/parse_uri.dart';
import '../component/balance_display.dart';

class SendTab extends StatefulWidget {
  final PageController controller;

  SendTab({Key? key, required this.controller}) : super(key: key);

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
    final topPadding = MediaQuery.of(context).padding.top;
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
            final parseResult = parseSendURI(scanData.code);
            // Don't keep pushing send info pages if the viewModel has already been updated.
            // TODO: Seems like there should be a better way to handle this.
            if (viewModel.sendToAddress == parseResult.address) {
              return;
            }

            // Use the unparsed version, so that it appears as it was originally copied
            viewModel.sendToAddress = parseResult.address ?? '';
            viewModel.sendAmount = parseResult.amount;

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
            width: screenDimension.width,
            height: screenDimension.height,
            child: qrWidget),
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
          top: topPadding,
          child: Container(
              constraints: BoxConstraints(maxWidth: screenDimension.width),
              padding: stdPadding,
              child: BalanceDisplay(balanceNotifier: balanceNotifier)),
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
