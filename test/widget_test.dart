import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vase/main.dart';
import 'package:vase/tabs/receive.dart';
import 'package:vase/tabs/send/send.dart';
import 'package:vase/tabs/send/sendModel.dart';
import 'package:vase/tabs/settings.dart';
import 'package:vase/viewmodel.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => WalletModel()),
      ChangeNotifierProvider(create: (_) => SendModel()),
    ], child: LotusApp()));

    final materialApp = find.byType(MaterialApp);
    final sendTab = find.byType(SendTab);
    final qrView = find.byType(QRView);

    expect(materialApp, findsOneWidget);
    expect(sendTab, findsOneWidget);
    expect(qrView, findsOneWidget);
  });

  testWidgets('App initializes on send tab', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => WalletModel()),
      ChangeNotifierProvider(create: (_) => SendModel()),
    ], child: LotusApp()));

    final sendTab = find.byType(SendTab);
    final receiveTab = find.byType(ReceiveTab);
    final settingsTab = find.byType(SettingsTab);

    expect(sendTab, findsOneWidget);
    expect(receiveTab, findsNothing);
    expect(settingsTab, findsNothing);
  });

  testWidgets('App navigates to receive tab', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => WalletModel()),
      ChangeNotifierProvider(create: (_) => SendModel()),
    ], child: LotusApp()));

    final sendTab = find.byType(SendTab);
    expect(sendTab, findsOneWidget);

    final receiveButton = find.byIcon(Icons.save_alt);
    expect(receiveButton, findsOneWidget);

    await tester.tap(receiveButton);

    await tester.pumpAndSettle();

    final receiveTab = find.byType(ReceiveTab);
    final settingsTab = find.byType(SettingsTab);

    expect(receiveTab, findsOneWidget);
    expect(settingsTab, findsNothing);
  });

  testWidgets('App navigates to settings tab', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => WalletModel()),
      ChangeNotifierProvider(create: (_) => SendModel()),
    ], child: LotusApp()));

    final sendTab = find.byType(SendTab);
    expect(sendTab, findsOneWidget);

    final settingsButton = find.byIcon(Icons.settings);
    expect(settingsButton, findsOneWidget);

    await tester.tap(settingsButton);

    await tester.pumpAndSettle();

    final receiveTab = find.byType(ReceiveTab);
    final settingsTab = find.byType(SettingsTab);

    expect(receiveTab, findsNothing);
    expect(settingsTab, findsOneWidget);
  });
}
