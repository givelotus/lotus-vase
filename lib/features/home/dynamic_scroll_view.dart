import 'package:flutter/material.dart';
import 'package:vase/config/theme.dart';

class DynamicScrollView extends StatelessWidget {
  const DynamicScrollView({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height >= AppTheme.xsHeight
        ? child
        : LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: child,
                  ),
                ),
              );
            },
          );
  }
}
