import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/lotus/address.dart';
import 'package:vase/lotus/transaction/transaction.dart';
import 'package:vase/lotus/utils/parse_uri.dart';
import 'package:vase/viewmodel.dart';

final qrKey = GlobalKey(debugLabel: 'QR');

class QRScanPage extends HookWidget {
  const QRScanPage();

  Future<Transaction?> _sendTransaction(
      BuildContext context, String address, int amount) async {
    try {
      final walletModel = context.read<WalletModel>();
      return await walletModel.wallet
          ?.sendTransaction(Address(address), BigInt.from(amount));
    } catch (error) {
      _showSnackBar(context, error.toString());
      return null;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogOpen = useState(false);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: Icon(Icons.navigate_before),
                      onPressed: () => context.pop(),
                      splashRadius: AppTheme.splashRadius,
                    ),
                  ),
                  const Text(
                    'QR Scanner',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: (controller) {
                  controller.scannedDataStream.listen((scanData) {
                    if (dialogOpen.value) {
                      return;
                    }

                    final parseResult = parseSendURI(scanData.code);
                    final address = parseResult.address ?? '';
                    final amount = parseResult.amount ?? 0;

                    if (address.isEmpty || amount <= 0) {
                      _showSnackBar(context, 'Unable to parse QR code');
                      return;
                    }

                    dialogOpen.value = true;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        void _closeDialog() {
                          Navigator.of(context).pop();
                          dialogOpen.value = false;
                        }

                        return AlertDialog(
                          title: Text('Send Lotus?'),
                          content:
                              Text('You will send $amount Lotus to $address'),
                          actions: [
                            TextButton(
                              onPressed: _closeDialog,
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () async {
                                final transaction = await _sendTransaction(
                                    context, address, amount);
                                _showSnackBar(
                                    context, 'Sent! TxId: ${transaction?.id}');
                                _closeDialog();
                              },
                            )
                          ],
                        );
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
