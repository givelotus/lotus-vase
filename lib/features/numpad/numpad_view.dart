import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vase/components/numpad/numpad.dart';
import 'package:vase/components/numpad/numpad_model.dart';
import 'package:vase/config/features.dart';
import 'package:vase/config/theme.dart';

class NumpadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              splashRadius: AppTheme.splashRadius,
              onPressed: () {},
              icon: Icon(Icons.qr_code_scanner),
            ),
            const Spacer(),
            Visibility(
              visible: FeatureFlags.profiles,
              child: IconButton(
                splashRadius: AppTheme.splashRadius,
                onPressed: () {},
                icon: Icon(Icons.face),
              ),
            ),
            Visibility(
              visible: FeatureFlags.notifications,
              child: IconButton(
                splashRadius: AppTheme.splashRadius,
                onPressed: () {},
                icon: Icon(Icons.notifications),
              ),
            ),
            IconButton(
              splashRadius: AppTheme.splashRadius,
              onPressed: () {},
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        Expanded(
          flex: 2,
          child: Padding(
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
                  child: Text('Request'),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text('Send'),
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
