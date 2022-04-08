import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vase/components/numpad/numpad_model.dart';
import 'package:vase/viewmodel.dart';

class ReceivePage extends StatelessWidget {
  const ReceivePage();

  String _createAddressUri(String address, String amount) {
    // Can't mutate the URI, so need a way to add query strings.
    final parsedAddress = Uri.parse(address);
    return Uri(
        scheme: parsedAddress.scheme,
        path: parsedAddress.path,
        queryParameters: {'amount': amount}).toString();
  }

  @override
  Widget build(BuildContext context) {
    final keys = context.watch<WalletModel>().wallet?.keys.keys?.sublist(0);
    final amount = context.watch<NumpadModel>().value;

    final keyInfo = keys?.firstWhere((keyInfo) =>
        keyInfo.isChange == false && keyInfo.isDeprecated == false);
    final address = keyInfo?.address?.toXAddress();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: address != null
            ? Container(
                color: Colors.white,
                child: QrImage(
                  data: _createAddressUri(address, amount),
                  version: QrVersions.auto,
                  size: 300,
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
