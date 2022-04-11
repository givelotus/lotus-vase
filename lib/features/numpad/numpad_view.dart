import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vase/features/numpad/numpad.dart';
import 'package:vase/features/numpad/numpad_model.dart';
import 'package:vase/config/colors.dart';
import 'package:vase/features/send/send_model.dart';
import 'package:vase/utils/currency.dart';
import 'package:vase/features/wallet/wallet_model.dart';

class NumpadView extends HookWidget {
  const NumpadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balance =
        context.select<WalletModel, BigInt?>((model) => model.balance?.balance);
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 200));
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Consumer<NumpadModel>(
              builder: (context, numpadModel, widget) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        10 * sin(controller.value * 5 * pi),
                        0,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: formatNumpadInput(numpadModel.items)
                              .map(
                                (e) => Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 96,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height * 0.6,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints(minHeight: 36 * scaleFactor),
                    width: 200,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.lotusPurple1,
                    ),
                    child: Center(
                      child: balance == null
                          ? SizedBox(
                              height: 16 * scaleFactor,
                              width: 16 * scaleFactor,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              formatAmount(balance),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: width,
                      child: NumpadWidget(controller: controller)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Text(
                              'Request',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () => context.push('/request'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () async {
                              final walletModel = context.read<WalletModel>();
                              final numpadModel = context.read<NumpadModel>();
                              final balance = walletModel.balance?.balance;
                              final amount = lotusToSats(numpadModel.value);

                              if (balance == null || balance <= amount) {
                                controller.forward(from: 0);
                                if (await Vibrate.canVibrate) {
                                  Vibrate.feedback(FeedbackType.heavy);
                                }
                                return;
                              }

                              final sendModel = context.read<SendModel>();
                              sendModel.setAmount(amount);
                              context.push('/send');
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
