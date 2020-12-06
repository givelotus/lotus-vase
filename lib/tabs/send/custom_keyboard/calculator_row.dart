import 'package:flutter/material.dart';
import 'calculator_button.dart';

class CalculatorRow extends StatelessWidget {
  CalculatorRow({@required this.buttons, @required this.onTap});

  final List<String> buttons;
  final CalculatorButtonTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: rowButtons(),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  List<Widget> rowButtons() {
    List<Widget> rowButtons = [];

    buttons.forEach((String buttonLabel) {
      rowButtons.add(
        CalculatorButton(
          text: buttonLabel,
          onTap: onTap,
        ),
      );
    });

    return rowButtons;
  }
}