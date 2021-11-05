library custom_keyboard;

import 'package:flutter/widgets.dart';

import 'button_definitions.dart';
import 'calculator_button.dart';
import 'calculator.dart';

class CalculatorData {
  int? amount;
  String? function;
  CalculatorData({this.amount, this.function});
}

class CalculatorKeyboard extends StatelessWidget {
  final ValueNotifier<CalculatorData> dataNotifier;
  final List<String> stack = [];

  CalculatorKeyboard(
      {Key? key, String initialValue = '', required this.dataNotifier})
      : super(key: key) {
    stack.addAll(initialValue.split(''));
  }

  @override
  Widget build(BuildContext context) {
    int? amount = 0;

    final updateStack = () {
      final evaluatedStack = stack.sublist(0);
      evaluateExpression(evaluatedStack);
      final takenNumbers = takeNumbers(evaluatedStack.reversed.toList());
      amount = takenNumbers.isNaN ? 0 : (takenNumbers * 1000000).truncate();

      // This will be mutated, that's why we need to update the value.
      dataNotifier.value =
          CalculatorData(function: stack.join(''), amount: amount);
    };

    // FIXME: This seems like a terrible way to keep everything in sync on paste.
    dataNotifier.addListener(() {
      if (dataNotifier.value.amount == amount) {
        return;
      }
      amount = dataNotifier.value.amount;
      stack.clear();
      stack.addAll(dataNotifier.value.function!.split(''));
    });

    return Container(
        child: Column(
      children: [
        Column(
          children:
              CalculatorRows.map((List<CalculatorItem> calculatorRowButtons) {
            return Row(
              children: calculatorRowButtons.map((CalculatorItem item) {
                return CalculatorButton(
                  button: item,
                  stack: stack,
                  onPressed: updateStack,
                );
              }).toList(),
            );
          }).toList(),
        )
      ],
    ));
  }
}
