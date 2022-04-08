import 'package:flutter/material.dart';
import 'package:vase/config/theme.dart';

class KeyWidgetOptions {
  final String label;
  final void Function() onPressed;

  KeyWidgetOptions({
    required this.label,
    required this.onPressed,
  });
}

class KeyWidget extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const KeyWidget({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: CircleBorder(),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).textTheme.button?.color,
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
