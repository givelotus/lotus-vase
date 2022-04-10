import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:vase/features/wallet/wallet_model.dart';

class WalletLifecycleWatcher extends HookWidget {
  const WalletLifecycleWatcher({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    useOnAppLifecycleStateChange(
      (prev, curr) async {
        // run on all state changes but detached
        if (curr != AppLifecycleState.detached) {
          final walletModel = context.read<WalletModel>();

          if (walletModel.initialized) {
            await walletModel.writeToDisk();

            // only update balance on resume
            if (curr == AppLifecycleState.resumed) {
              await walletModel.updateWallet();
            }
          }
        }
      },
    );

    return child;
  }
}
