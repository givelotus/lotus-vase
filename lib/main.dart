import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:vase/tabs/settings.dart';
import 'package:vase/tabs/receive.dart';
import 'package:vase/tabs/send/send.dart';
import 'package:vase/viewmodel.dart';
import 'package:vase/tabs/send/sendModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

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
    ], child: LotusApp())),
  );
}

class LotusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: 'Vase'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  AppLifecycleState? _notification;

  final PageController pagerController =
      PageController(keepPage: true, initialPage: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_notification == state) {
      return;
    }
    setState(() {
      print(_notification);
      _notification = state;
      print(_notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WalletModel>(context);
    if (viewModel.initialized) {
      viewModel.writeToDisk();
    }
    if (viewModel.initialized && _notification == AppLifecycleState.resumed) {
      viewModel.updateWallet();
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
