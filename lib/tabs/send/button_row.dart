import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

import '../../constants.dart';
import '../../wallet/wallet.dart';

class ButtonRow extends StatelessWidget {
  ButtonRow(this.wallet, this.amount, this.address);
  final Wallet wallet;
  final int amount;
  final String address;

  @override
  Widget build(BuildContext context) {
    var sliderButtonColor;
    if (amount != null) {
      sliderButtonColor = Colors.blue;
    } else {
      sliderButtonColor = Colors.blueGrey;
    }
    final sliderButton = SliderButton(
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
      action: () {
        print(amount);
      },
    );
    return Row(children: [
      Expanded(child: Padding(padding: stdPadding, child: sliderButton))
    ]);
  }
}
