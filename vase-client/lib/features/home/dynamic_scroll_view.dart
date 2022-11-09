import 'package:flutter/material.dart';

class DynamicScrollView extends StatelessWidget {
  const DynamicScrollView({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              key: key,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
