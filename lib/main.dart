import 'package:cashew/tabs/settings.dart';
import 'package:cashew/tabs/receive.dart';
import 'package:cashew/tabs/send/send.dart';
import 'package:cashew/viewmodel.dart';
import 'package:cashew/tabs/send/sendModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart'; // initialize sentry
import 'package:sentry/sentry.dart'; // contains exception handler

Future<void> main() async {
  await SentryFlutter.init((options) {
    // Options docs here: https://docs.sentry.io/platforms/flutter/configuration/options/
    options.dsn =
        'https://7588026571644baaadd4a711f9bb8762@o496612.ingest.sentry.io/5571577';
  },
      appRunner: () => runApp(MultiProvider(providers: [
            ChangeNotifierProvider(create: (_) => WalletModel()),
            ChangeNotifierProvider(create: (_) => SendModel()),
          ], child: CashewApp())));
}

class CashewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashew',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: 'Cashew'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController pagerController =
      PageController(keepPage: true, initialPage: 1);

  @override
  void initState() {
    super.initState();

    // Sample code to capture exception in Sentry:
    // try {
    //   throw Exception('whatever');
    // } catch (exception, stackTrace) {
    //   // await
    //   Sentry.captureException(
    //     exception,
    //     stackTrace: stackTrace,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WalletModel>(context);
    if (viewModel.initialized) {
      viewModel.writeToDisk();
    }
    final ScopePopper = (widget) => WillPopScope(
        onWillPop: () async {
          print(pagerController.page.toString());
          if (pagerController.page == 1.0) {
            return true;
          }
          return pagerController
              .animateToPage(1,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut)
              .then((_) async {
            return false;
          });
        },
        child: widget);

    final pageView = PageView(
      controller: pagerController,
      children: [
        ScopePopper(SettingsTab()),
        ScopePopper(SendTab(controller: pagerController)),
        ScopePopper(ReceiveTab()),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pageView,
    );
  }
}
