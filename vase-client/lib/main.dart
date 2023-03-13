import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:vase/chronik-client/client.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/features/home/home_page.dart';
import 'package:vase/features/numpad/numpad_model.dart';
import 'package:vase/features/request/request_page.dart';
import 'package:vase/features/send/send_model.dart';
import 'package:vase/features/send/send_page.dart';
import 'package:vase/features/settings/settings_page.dart';
import 'package:vase/features/wallet/wallet_lifecycle_watcher.dart';
import 'package:vase/features/wallet/wallet_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init((options) {
    options.dsn =
        'https://c6a61e7ac13b413d8bb529c3c05b0ab1@o1111989.ingest.sentry.io/6141317';
    options.tracesSampleRate = kReleaseMode ? 1.0 : 0.0;
    options.environment = kReleaseMode ? 'production' : 'development';
  }, appRunner: () async {
    final chronik = ChronikClient("https://chronik.be.cash/xpi");
    return runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WalletModel(chronik)),
          ChangeNotifierProvider(create: (_) => SendModel()),
          ChangeNotifierProvider(create: (_) => NumpadModel()),
        ],
        child: VaseApp(),
      ),
    );
  });
}

class VaseApp extends StatelessWidget {
  VaseApp({Key? key}) : super(key: key);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, state) => const HomePage(),
      ),
      GoRoute(path: '/settings', builder: (ctx, state) => const SettingsPage()),
      GoRoute(path: '/request', builder: (ctx, state) => const RequestPage()),
      GoRoute(path: '/send', builder: (ctx, state) => const SendPage()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WalletLifecycleWatcher(
      child: MaterialApp.router(
        title: 'Vase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lotusTheme,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
