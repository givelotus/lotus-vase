import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cashew/bitcoincash/src/address.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import './send_info.dart';

class SendTab extends StatefulWidget {
  final PageController controller;

  SendTab({Key key, @required this.controller}) : super(key: key);

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
    var screenDimension = MediaQuery.of(context).size;

    // WE don't want to be redrawing
    final viewModel = Provider.of<CashewModel>(context, listen: false);

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
        builder: (context, shouldShowSendInfoScreen, child) => Scaffold(
            body: shouldShowSendInfoScreen
                ? SendInfo(visible: showSendInfoScreen)
                : Scaffold(
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
                          onPressed: () => showSendInfoScreen.value = true,
                        ),
                      ),
                      Positioned(
                        top: screenDimension.height * .1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            color: Colors.grey[400].withOpacity(0.6),
                            child: Row(
                              children: [
                                Consumer<CashewModel>(
                                  builder: (context, model, child) {
                                    if (!model.initialized) {
                                      return Text(
                                        'Loading...',
                                        style: TextStyle(
                                            color: Colors.red.withOpacity(.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      );
                                    }
                                    return Text.rich(TextSpan(
                                      text:
                                          '${model.activeWallet.balanceSatoshis()}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' sats',
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.8),
                                              fontSize: 15),
                                        ),
                                      ],
                                    ));
                                  },
                                ),
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
                  )));
  }
}
