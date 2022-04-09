import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vase/components/numpad/numpad_model.dart';
import 'package:vase/config/colors.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/lotus/utils/sats.dart';
import 'package:vase/viewmodel.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({Key? key}) : super(key: key);

  String _createAddressUri(String address, String amount) {
    // Can't mutate the URI, so need a way to add query strings.
    final parsedAddress = Uri.parse(address);
    return Uri(
        scheme: parsedAddress.scheme,
        path: parsedAddress.path,
        queryParameters: {'amount': '$lotusToSats(amount)'}).toString();
  }

  @override
  Widget build(BuildContext context) {
    final keys = context.watch<WalletModel>().wallet?.keys.keys?.sublist(0);
    final amount = context.watch<NumpadModel>().value;

    final keyInfo = keys?.firstWhere((keyInfo) =>
        keyInfo.isChange == false && keyInfo.isDeprecated == false);
    final address = keyInfo?.address?.toXAddress() ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          splashRadius: AppTheme.splashRadius,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.navigate_before),
        ),
        title: const Text('Request'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: address.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: QrImage(
                        data: _createAddressUri(address, amount),
                        version: QrVersions.auto,
                        size: 300,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: AppColors.lotusPink),
                        border: InputBorder.none,
                      ),
                      controller: TextEditingController(text: '$amount XPI'),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 2,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              labelStyle: TextStyle(color: AppColors.lotusPink),
                              border: InputBorder.none,
                            ),
                            controller: TextEditingController(text: address),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white24,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: address,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied address to Clipboard'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
