import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

import '../../constants.dart';
import '../../wallet/wallet.dart';

Future showReceipt(BuildContext context, Transaction transaction) {
  // TODO: Create nice looking receipt dialog.
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Receipt'),
          content: Text('TODO'),
        );
      });
}

class ButtonRow extends StatelessWidget {
  ButtonRow(this.wallet, this.amount, this.strAddress);
  final Wallet wallet;
  final int amount;
  final String strAddress;

  @override
  Widget build(BuildContext context) {
    var sliderButtonColor = Colors.blueGrey;
    var action = () {};
    var vibrationFlag = false;
    final primaryValidation = (amount != null && amount > 0);
    if (primaryValidation) {
      try {
        final address = Address(strAddress);
        sliderButtonColor = Colors.blue;
        vibrationFlag = true;
        action = () {
          final bigAmount = BigInt.from(amount);
          wallet
              .send(address, bigAmount)
              .then((transaction) => showReceipt(context, transaction));
        };
      } catch (e) {}
    }
    final sliderButton = SliderButton(
      vibrationFlag: vibrationFlag,
      buttonColor: sliderButtonColor,
      dismissible: false,
      shimmer: false,
      alignLabel: Alignment.center,
      height: 48,
      buttonSize: 48,
      width: MediaQuery.of(context).size.width * 0.95,
      label: Text('Slide to send!'),
      icon: Center(
          child: Icon(
        Icons.send,
        color: Colors.white,
      )),
      action: action,
    );
    return Row(children: [
      Expanded(child: Padding(padding: stdPadding, child: sliderButton))
    ]);
  }
}
