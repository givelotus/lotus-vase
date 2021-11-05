import 'package:flutter/material.dart';
import 'button_definitions.dart';

typedef CalculatorButtonTapCallback = void Function({String? buttonLabel});

class CalculatorButton extends StatelessWidget {
  final CalculatorItem? button;
  final List<String> stack;
  final void Function() onPressed;

  CalculatorButton({this.button, required this.stack, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        // TODO: Update UI optics on this. Make it snazzy.
        // TODO: Differentiate the look of operators from the numbers. Is the map
        // really the best way to do this?
        child: Container(
      child: Padding(
          padding: EdgeInsets.all(3.0),
          child: ElevatedButton(
              style: ButtonDefinitions[button!]!.style ??
                  TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
                    primary: Colors.black,
                    backgroundColor: Colors.white,
                  ),
              onPressed: () {
                ButtonDefinitions[button!]!.action!(stack);
                onPressed();
              },
              child: ButtonDefinitions[button!]!.text == null
                  ? Icon(
                      ButtonDefinitions[button!]!.icon,
                    )
                  : Text(ButtonDefinitions[button!]!.text!,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline5!.fontSize,
                          fontWeight: FontWeight.bold)))),
    ));
  }
}
