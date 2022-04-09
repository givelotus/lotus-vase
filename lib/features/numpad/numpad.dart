import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:vase/features/numpad/key_widget.dart';
import 'package:vase/features/numpad/numpad_model.dart';

enum KeyValue {
  Zero,
  One,
  Two,
  Three,
  Four,
  Five,
  Six,
  Seven,
  Eight,
  Nine,
  Period,
  Back
}

extension KeyValueExts on KeyValue {
  String get value {
    switch (this) {
      case KeyValue.Zero:
        return '0';
      case KeyValue.One:
        return '1';
      case KeyValue.Two:
        return '2';
      case KeyValue.Three:
        return '3';
      case KeyValue.Four:
        return '4';
      case KeyValue.Five:
        return '5';
      case KeyValue.Six:
        return '6';
      case KeyValue.Seven:
        return '7';
      case KeyValue.Eight:
        return '8';
      case KeyValue.Nine:
        return '9';
      case KeyValue.Period:
        return '.';
      case KeyValue.Back:
        return '<';
      default:
        throw Exception();
    }
  }
}

final defaultOperation = (NumpadModel model, KeyValue value) {
  model.addValue(value.value);
};

final defaultValidator = (NumpadModel model) => model.items.length < maxLength;

final periodValidator = (NumpadModel model) =>
    defaultValidator(model) &&
    model.items.indexWhere((element) => element == KeyValue.Period.value) == -1;

final backValidator = (NumpadModel model) =>
    model.items.length > 1 ||
    (model.items.length == 1 && model.items.first != '0');

final backOperation = (NumpadModel model) {
  model.removeLast();
};

final List<List<KeyValue>> rows = [
  [
    KeyValue.One,
    KeyValue.Two,
    KeyValue.Three,
  ],
  [
    KeyValue.Four,
    KeyValue.Five,
    KeyValue.Six,
  ],
  [
    KeyValue.Seven,
    KeyValue.Eight,
    KeyValue.Nine,
  ],
  [
    KeyValue.Period,
    KeyValue.Zero,
    KeyValue.Back,
  ],
];

class NumpadWidget extends StatelessWidget {
  const NumpadWidget({Key? key, required this.controller}) : super(key: key);

  final AnimationController controller;

  void _vibrate() async {
    controller.forward(from: 0);
    if (await Vibrate.canVibrate) {
      Vibrate.feedback(FeedbackType.heavy);
    }
  }

  void Function() _handleClick(NumpadModel model, KeyValue value) => () {
        switch (value) {
          case KeyValue.Zero:
          case KeyValue.One:
          case KeyValue.Two:
          case KeyValue.Three:
          case KeyValue.Four:
          case KeyValue.Five:
          case KeyValue.Six:
          case KeyValue.Seven:
          case KeyValue.Eight:
          case KeyValue.Nine:
            if (defaultValidator(model)) {
              defaultOperation(model, value);
            } else {
              _vibrate();
            }
            break;
          case KeyValue.Period:
            if (periodValidator(model)) {
              defaultOperation(model, value);
            } else {
              _vibrate();
            }
            break;
          case KeyValue.Back:
            if (backValidator(model)) {
              backOperation(model);
            } else {
              _vibrate();
            }
            break;
          default:
            throw Exception();
        }
      };

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NumpadModel>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final col in row)
                KeyWidget(
                  onPressed: _handleClick(model, col),
                  label: col.value,
                ),
            ],
          ),
      ],
    );
  }
}
