import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vase/features/numpad/numpad_model.dart';
import 'package:vase/config/colors.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/utils/currency.dart';
import 'package:vase/features/wallet/wallet_model.dart';

class RequestPage extends HookWidget {
  const RequestPage({Key? key}) : super(key: key);

  String _createAddressUri(String address, String amount) {
    // Can't mutate the URI, so need a way to add query strings.
    final parsedAddress = Uri.parse(address);
    final amountSats = lotusToSats(amount);
    return Uri(
        scheme: parsedAddress.scheme,
        path: parsedAddress.path,
        queryParameters: {'amount': '$amountSats'}).toString();
  }

  @override
  Widget build(BuildContext context) {
    final keys = context.watch<WalletModel>().wallet?.keys.keys?.sublist(0);
    final amount = context.watch<NumpadModel>().value;
    final hideAmount = useState((double.tryParse(amount) ?? 0) == 0);

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
        padding: const EdgeInsets.all(16),
        child: Center(
          child: address.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: QrImage(
                        data: _createAddressUri(
                            address, hideAmount.value ? '0' : amount),
                        version: QrVersions.auto,
                        size: 300,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!hideAmount.value)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IntrinsicWidth(
                          child: TextField(
                            minLines: 1,
                            maxLines: 2,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              labelStyle:
                                  const TextStyle(color: AppColors.lotusPink),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                splashRadius: AppTheme.splashRadius,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  hideAmount.value = true;
                                },
                              ),
                            ),
                            controller:
                                TextEditingController(text: '$amount XPI'),
                          ),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            minLines: 1,
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
