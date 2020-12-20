import 'package:cashew/tabs/settings.dart';
import 'package:cashew/tabs/receive.dart';
import 'package:cashew/tabs/send/send.dart';
import 'package:cashew/viewmodel.dart';
import 'package:cashew/tabs/send/sendModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WalletModel()),
    ChangeNotifierProvider(create: (_) => SendModel()),
  ], child: CashewApp()));
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
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WalletModel>(context);
    if (viewModel.initialized) {
      viewModel.writeToDisk();
    }
    final pageView = PageView(
      controller: pagerController,
      children: [
        SettingsTab(),
        SendTab(controller: pagerController),
        ReceiveTab(),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pageView,
    );
  }
}
