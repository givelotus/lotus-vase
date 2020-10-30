import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

import '../../wallet/wallet.dart';
import 'address_row.dart';
import 'amount_row.dart';
import 'button_row.dart';

class SendTab extends StatefulWidget {
  SendTab({Key key, this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  _SendTabState createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
  QRViewController controller;

  final _amountController = TextEditingController();
  int amount;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText = '';

  @override
  void initState() {
    super.initState();

    // Attempt to parse on amount text changee
    _amountController.addListener(() {
      setState(() {
        amount = int.tryParse(_amountController.text);
      });
    });
  }

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
    _amountController.dispose();
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
    final addressRow = AddressRow(qrText: qrText);
    final amountRow = AmountRow(_amountController);
    final buttonRow = ButtonRow(widget.wallet, amount, qrText);
    final sendSheet = Column(
      children: [addressRow, amountRow, buttonRow],
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
