import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vase/config/colors.dart';
import 'package:vase/features/send/send_model.dart';
import 'package:vase/lotus/utils/parse_uri.dart';

final qrKey = GlobalKey(debugLabel: 'QR');

class QRScanPage extends HookWidget {
  const QRScanPage({Key? key}) : super(key: key);

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanned = useState(false);
    final overlay = QrScannerOverlayShape(
      borderColor: AppColors.lotusPink,
      borderRadius: 8,
      borderWidth: 4,
      cutOutSize: 300,
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              overlay: overlay,
              onQRViewCreated: (controller) {
                controller.scannedDataStream.listen((scanData) async {
                  // ensure we dont process multiple scan events
                  if (scanned.value) {
                    return;
                  }

                  scanned.value = true;
                  final parseResult = parseSendURI(scanData.code);
                  final address = parseResult.address;
                  final amount = parseResult.amount;

                  if (address.isEmpty || amount < BigInt.zero) {
                    _showSnackBar(context, 'Unable to parse QR code');
                    scanned.value = false;
                    return;
                  }

                  final sendModel = context.read<SendModel>();
                  sendModel.setAddress(address);
                  sendModel.setAmount(amount);

                  context.push('/send');
                  scanned.value = false;
                });
              },
            ),
            Positioned(
              top: 4,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  primary: Colors.black26,
                  elevation: 0,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
