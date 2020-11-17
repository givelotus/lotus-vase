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
    var screenDimension = MediaQuery.of(context).size;

    // WE don't want to be redrawing
    final viewModel = Provider.of<CashewModel>(context, listen: false);

    final overlay = QrScannerOverlayShape(
      borderColor: Colors.red,
      borderRadius: 10,
      borderLength: 30,
      borderWidth: 10,
      cutOutSize: screenDimension.width-50,
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
      builder: (context, shouldShowSendInfoScreen, child) => Stack(
        children: shouldShowSendInfoScreen
            ? SendInfo(visible: showSendInfoScreen) :
            [Positioned.fill(
                      child: qrWidget),


                  Positioned(
                    bottom: 50,
                    left: (screenDimension.width - 100.00) / 2, 
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.grey,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 100.00,
                        onPressed: () => showSendInfoScreen.value = true,
                      ),
                    ),
                  ),
                 

                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: 
                    Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Balance',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),

                                    // style: DefaultTextStyle.of(context).style,
                                  ),
                                  TextSpan(
                                    text: ' in satoshis',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Consumer<CashewModel>(
                          builder: (context, model, child) {
                            Widget result;
                            if (model.initialized) {
                              result = Expanded(
                                child: Text(
                                  '${model.activeWallet.balanceSatoshis()}',
                                ),
                              );
                            } else {
                              result = Flexible(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return result;
                          },
                        ),
                      ],
                    ),
                  ),),


                ])

                // Expanded(child: qrWidget),
              ,
      )
    ;
  }
}
