import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vase/lotus/utils/sats.dart';

import '../../constants.dart';
import '../../wallet/wallet.dart';

class BalanceDisplay extends StatelessWidget {
  final ValueNotifier<WalletBalance?> balanceNotifier;
  BalanceDisplay({required this.balanceNotifier});

  @override
  Widget build(BuildContext context) {
    // Balance Display widget
    return Padding(
      padding: stdPadding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          color: Colors.grey[400]!.withOpacity(0.6),
          child: ValueListenableBuilder<WalletBalance?>(
              valueListenable: balanceNotifier,
              builder: (context, balance, child) {
                final error = balance?.error;
                if (error != null) {
                  return Text(
                    showFriendlyError(error),
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  );
                }
                if (balance == null || balance.balance == null) {
                  return Text(
                    'Loading...',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  );
                }
                return Text.rich(TextSpan(
                  text: '${formatAmount(balance.balance ?? BigInt.zero)} ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ));
              }),
        ),
      ),
    );
  }
}

String showFriendlyError(Exception error) {
  if (error is SocketException) {
    return 'Error connecting to the network. Please restart the app.';
  }

  return error.toString();
}
