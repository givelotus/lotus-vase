import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vase/components/numpad/numpad.dart';
import 'package:vase/components/numpad/numpad_model.dart';

class NumpadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Consumer<NumpadModel>(
                builder: (context, model, widget) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: model.items
                        .map((e) => Text(
                              e,
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w800,
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: NumpadWidget()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text(
                    'Request',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
