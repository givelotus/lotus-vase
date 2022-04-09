import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vase/features/numpad/numpad_model.dart';
import 'package:vase/features/send/send_model.dart';
import 'package:vase/main.dart';
import 'package:vase/features/wallet/wallet_model.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => WalletModel()),
      ChangeNotifierProvider(create: (_) => SendModel()),
      ChangeNotifierProvider(create: (_) => NumpadModel()),
    ], child: VaseApp()));

    final materialApp = find.byType(MaterialApp);

    expect(materialApp, findsOneWidget);
  });
}
