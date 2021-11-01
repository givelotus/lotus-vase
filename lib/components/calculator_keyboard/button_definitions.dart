import 'package:flutter/material.dart';
import 'calculator.dart';

enum CalculatorItem {
  ZERO,
  ONE,
  TWO,
  THREE,
  FOUR,
  FIVE,
  SIX,
  SEVEN,
  EIGHT,
  NINE,
  PERIOD,
  MULTIPLY,
  SUBTRACT,
  ADD,
  DIVIDE,
  BACKSPACE,
  EQUAL,
  ZEROZERO,
  CLEAR,
  BLANK,
}

final CalculatorRows = [
  [
    CalculatorItem.SEVEN,
    CalculatorItem.EIGHT,
    CalculatorItem.NINE,
    CalculatorItem.DIVIDE
  ],
  [
    CalculatorItem.FOUR,
    CalculatorItem.FIVE,
    CalculatorItem.SIX,
    CalculatorItem.MULTIPLY,
  ],
  [
    CalculatorItem.ONE,
    CalculatorItem.TWO,
    CalculatorItem.THREE,
    CalculatorItem.SUBTRACT,
  ],
  [
    CalculatorItem.PERIOD,
    CalculatorItem.ZERO,
    CalculatorItem.BACKSPACE,
    CalculatorItem.ADD,
  ],
];

final operationButtonStyle = TextButton.styleFrom(
  padding: EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
  primary: Colors.black,
  backgroundColor: Colors.grey[300],
);

typedef CalculatorButtonAction = void Function(List<String> stack);

class CalculatorButtonDefinition {
  IconData? icon;
  CalculatorButtonAction? action;
  String? text;
  ButtonStyle? style;

  CalculatorButtonDefinition({this.icon, this.text, this.action, this.style});
}

final CalculatorButtonAction NOP = (items) => items;

typedef PushLambda = CalculatorButtonAction Function(String Number);
CalculatorButtonAction pushNumber(String number) {
  return (List<String>? stack) {
    stack!.add(number);
  };
}

CalculatorButtonAction pushOperation(String operator) {
  return (List<String> stack) {
    if (stack.isEmpty) return;

    final lastItem = stack.removeLast();
    // Replace opertators
    if (!operators.contains(lastItem)) {
      stack.add(lastItem);
    }
    stack.add(operator);
    evaluateExpression(stack);
  };
}

void pushDecimal(List<String> stack) {
  for (var i = stack.length - 1; i > 0; i--) {
    if (stack[i] == '.') {
      return;
    }
    if (operators.contains(stack[i])) {
      break;
    }
  }
  stack.add('.');
}

final ButtonDefinitions = {
  CalculatorItem.ZEROZERO: CalculatorButtonDefinition(
    text: '00',
    action: (stack) => {
      stack.addAll(['0', '0'])
    },
  ),
  CalculatorItem.ZERO: CalculatorButtonDefinition(
    text: '0',
    action: pushNumber('0'),
  ),
  CalculatorItem.ONE: CalculatorButtonDefinition(
    text: '1',
    action: pushNumber('1'),
  ),
  CalculatorItem.TWO: CalculatorButtonDefinition(
    text: '2',
    action: pushNumber('2'),
  ),
  CalculatorItem.THREE: CalculatorButtonDefinition(
    text: '3',
    action: pushNumber('3'),
  ),
  CalculatorItem.FOUR: CalculatorButtonDefinition(
    text: '4',
    action: pushNumber('4'),
  ),
  CalculatorItem.FIVE: CalculatorButtonDefinition(
    text: '5',
    action: pushNumber('5'),
  ),
  CalculatorItem.SIX: CalculatorButtonDefinition(
    text: '6',
    action: pushNumber('6'),
  ),
  CalculatorItem.SEVEN: CalculatorButtonDefinition(
    text: '7',
    action: pushNumber('7'),
  ),
  CalculatorItem.EIGHT: CalculatorButtonDefinition(
    text: '8',
    action: pushNumber('8'),
  ),
  CalculatorItem.NINE: CalculatorButtonDefinition(
    text: '9',
    action: pushNumber('9'),
  ),
  CalculatorItem.PERIOD: CalculatorButtonDefinition(
    text: '.',
    action: pushDecimal,
    style: operationButtonStyle,
  ),
  CalculatorItem.MULTIPLY: CalculatorButtonDefinition(
    text: '✖️',
    action: pushOperation('✖️'),
    style: operationButtonStyle,
  ),
  CalculatorItem.SUBTRACT: CalculatorButtonDefinition(
    text: '➖',
    action: pushOperation('➖'),
    style: operationButtonStyle,
  ),
  CalculatorItem.ADD: CalculatorButtonDefinition(
    text: '➕',
    action: pushOperation('➕'),
    style: operationButtonStyle,
  ),
  CalculatorItem.DIVIDE: CalculatorButtonDefinition(
    text: '➗',
    action: pushOperation('➗'),
    style: operationButtonStyle,
  ),
  CalculatorItem.BACKSPACE: CalculatorButtonDefinition(
    text: '⬅️',
    action: (List<String> stack) {
      if (stack.isEmpty) {
        return;
      }
      stack.removeLast();
    },
    style: operationButtonStyle,
  ),
  CalculatorItem.CLEAR: CalculatorButtonDefinition(
    text: 'AC',
    action: (List<String> stack) {
      stack.clear();
    },
    style: operationButtonStyle,
  ),
  CalculatorItem.EQUAL:
      CalculatorButtonDefinition(text: '=', action: evaluateExpression),
  CalculatorItem.BLANK: CalculatorButtonDefinition(text: '', action: NOP),
};
