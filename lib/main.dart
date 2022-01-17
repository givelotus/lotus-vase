import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:vase/components/numpad/numpad_model.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/features/home/home_page.dart';
import 'package:vase/tabs/send/sendModel.dart';
import 'package:vase/viewmodel.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c6a61e7ac13b413d8bb529c3c05b0ab1@o1111989.ingest.sentry.io/6141317';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => WalletModel()),
      ChangeNotifierProvider(create: (_) => SendModel()),
      ChangeNotifierProvider(create: (_) => NumpadModel()),
    ], child: VaseApp())),
  );
}

class VaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vase',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
