import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vase/components/numpad/numpad_model.dart';

class WalletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Consumer<NumpadModel>(
              builder: (context, model, widget) {
                return Text(
                  model.value,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
