import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vase/config/colors.dart';

import '../../utils/currency.dart';
import '../wallet/wallet_model.dart';

class DashboardView extends HookWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletBalance =
        context.select<WalletModel, BigInt?>((model) => model.balance?.balance);
    final walletError =
        context.select<WalletModel, dynamic>((model) => model.balance?.error);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Balance",
            style: TextStyle(fontSize: 20),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: walletBalance == null && walletError == null
                ? Column(
                    children: const [
                      SizedBox(height: 16),
                      CircularProgressIndicator()
                    ],
                  )
                : walletBalance == null
                    ? Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                '${walletError ?? 'Error fetching balance'}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.replay,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Text(
                        formatAmount(walletBalance),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 96,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuickAction(
                icon: Icons.send,
                label: "Send",
                onPressed: () {
                  context.push('/send');
                },
              ),
              const SizedBox(width: 16),
              QuickAction(
                icon: Icons.qr_code,
                label: "Receive",
                onPressed: () {
                  context.push('/request');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: AppColors.lotusPurple2,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
