import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'address_row.dart';
import 'amount_row.dart';
import 'button_row.dart';

class SendTab extends StatelessWidget {
  SendTab({Key key}) : super(key: key);

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CashewModel>(context, listen: false);

    final overlay = QrScannerOverlayShape(
      borderColor: Colors.red,
      borderRadius: 10,
      borderLength: 30,
      borderWidth: 10,
      cutOutSize: 300,
    );

    final _amountController = TextEditingController();
    final _addressController = TextEditingController();

    final qrWidget = QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        controller.scannedDataStream.listen((scanData) {
          viewModel.sendToAddress = scanData;
          _addressController.text = scanData;
        });
      },
      overlay: overlay,
    );

    _amountController.addListener(() {
      viewModel.sendAmount = int.tryParse(_amountController.text);
    });

    _addressController.addListener(() {
      viewModel.sendToAddress = _addressController.text;
    });

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(child: qrWidget),
        SliverList(
            delegate: SliverChildListDelegate([
          AddressRow(_addressController),
          AmountRow(_amountController),
          ButtonRow()
        ]))
      ],
    );
  }
}
