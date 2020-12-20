import 'package:flutter/material.dart';
import 'button_definitions.dart';

typedef CalculatorButtonTapCallback = void Function({String buttonLabel});

class CalculatorButton extends StatelessWidget {
  final CalculatorItem button;
  final List<String> stack;
  final void Function() onPressed;

  CalculatorButton({this.button, this.stack, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        // TODO: Update UI optics on this. Make it snazzy.
        // TODO: Differentiate the look of operators from the numbers. Is the map
        // really the best way to do this?
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                width: 0.5,
              ),
            ),
            child: ButtonDefinitions[button].text == null
                ? FlatButton(
                    onPressed: () {
                      ButtonDefinitions[button].action(stack);
                      onPressed();
                    },
                    child: Icon(
                      ButtonDefinitions[button].icon,
                    ))
                : TextButton(
                    onPressed: () {
                      ButtonDefinitions[button].action(stack);
                      onPressed();
                    },
                    child: Text(
                      ButtonDefinitions[button].text,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    style: ButtonStyle(),
                  )));
  }
}
