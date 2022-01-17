import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vase/components/numpad/numpad.dart';
import 'package:vase/components/numpad/numpad_model.dart';

class WalletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("wallet");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Consumer<NumpadModel>(
              builder: (context, model, widget) {
                print(model.items);
                return Text(
                  model.items.map((e) => e.value).join(),
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
