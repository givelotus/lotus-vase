import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vase/lotus/utils/sats.dart';

class PaymentAmountDisplay extends StatelessWidget {
  final int? amount;
  final String? function;
  PaymentAmountDisplay({Key? key, this.amount, this.function})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
            child: Text(
          '$function',
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
              fontWeight: FontWeight.bold),
        ))
      ]),
      Row(children: [
        Expanded(
            child: Text(
          '= ${formatAmount(BigInt.from(amount ?? 0))}',
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
              fontWeight: FontWeight.bold),
        ))
      ]),
    ]);
  }
}
