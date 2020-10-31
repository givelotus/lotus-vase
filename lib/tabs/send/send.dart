import 'dart:math' as math;

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
  QRViewController _qrController;

  final _amountController = TextEditingController();
  final _addressController = TextEditingController();
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
    this._qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
    _addressController.addListener(() {
      setState(() {
        qrText = _addressController.text;
      });
    });
  }

  @override
  void dispose() {
    _qrController?.dispose();
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

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(child: qrWidget),
        SliverList(
            delegate: SliverChildListDelegate([
          AddressRow(_addressController),
          AmountRow(_amountController),
          ButtonRow(widget.wallet, amount, qrText)
        ]))
      ],
    );
  }
}
