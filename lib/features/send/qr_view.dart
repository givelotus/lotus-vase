import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;
import 'package:vase/config/colors.dart';

final qrKey = GlobalKey(debugLabel: 'QR');

final overlay = qr.QrScannerOverlayShape(
  borderColor: AppColors.lotusPink,
  borderRadius: 8,
  borderWidth: 4,
  cutOutSize: 300,
);

class QRView extends HookWidget {
  const QRView({Key? key, required this.onScanResult}) : super(key: key);

  final Function(qr.Barcode) onScanResult;

  @override
  Widget build(BuildContext context) {
    return qr.QRView(
      key: qrKey,
      overlay: overlay,
      onQRViewCreated: (controller) {
        final throttledOnScanResult = throttle(onScanResult, 1000);
        controller.scannedDataStream.listen((scanData) async {
          throttledOnScanResult(scanData);
        });
      },
    );
  }
}

Function throttle(Function fn, int time) {
  var previous = 0;
  return (dynamic args) {
    var now = DateTime.now().millisecondsSinceEpoch;
    if (previous == 0 || now - previous >= time) {
      previous = now;
      fn(args);
    }
  };
}
