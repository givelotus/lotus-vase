import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vase/config/colors.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/features/send/send_model.dart';
import 'package:vase/lotus/lotus.dart';
import 'package:vase/lotus/utils/sats.dart';
import 'package:vase/viewmodel.dart';

class SendPage extends HookWidget {
  const SendPage({Key? key}) : super(key: key);

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
    final sendModel = context.watch<SendModel>();
    final amount = sendModel.amount;
    final addressCtrl = useTextEditingController(text: sendModel.address);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          splashRadius: AppTheme.splashRadius,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.navigate_before),
        ),
        title: const Text('Send'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: AppColors.lotusPink),
                  border: InputBorder.none,
                ),
                controller: TextEditingController(text: formatAmount(amount)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'To',
                        labelStyle: TextStyle(color: AppColors.lotusPink),
                        border: InputBorder.none,
                      ),
                      controller: addressCtrl,
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
                    onPressed: () async {
                      final data = await Clipboard.getData('text/plain');
                      addressCtrl.text = data?.text ?? '';
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pasted address from clipboard'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.paste,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
