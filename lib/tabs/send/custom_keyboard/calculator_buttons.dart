import 'package:flutter/material.dart';
import 'calculator.dart';
import 'calculator_button.dart';
import 'calculator_row.dart';

class CalculatorButtons extends StatelessWidget {
  CalculatorButtons({@required this.onTap});

  final CalculatorButtonTapCallback onTap;
  final calculatorButtonRows = [
    ['1', '2', '3', Calculations.DIVIDE],
    ['4', '5', '6', Calculations.MULTIPLY],
    ['7', '8', '9', Calculations.SUBTRACT],
    ['00', '0', Calculations.BACKSPACE, Calculations.ADD]
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: calculatorButtonRows.map((calculatorRowButtons) {
      return CalculatorRow(
        buttons: calculatorRowButtons,
        onTap: onTap,
      );
    }).toList());
  }
}
