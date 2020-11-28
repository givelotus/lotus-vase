import 'package:cashew/tabs/settings.dart';
import 'package:cashew/tabs/receive.dart';
import 'package:cashew/tabs/send/send.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'bitcoincash/src/networks.dart';
import 'loading_page.dart';

void main() {
  runApp(CashewApp());
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

  Widget buildFromWallet(Wallet wallet, BuildContext context) {
    return ChangeNotifierProvider(create: (BuildContext context) {
      return CashewModel('', wallet);
    }, builder: (context, child) {
      final wallet = Provider.of<CashewModel>(context, listen: false).wallet;

      final pageView = PageView(
        controller: pagerController,
        children: [
          SettingsTab(wallet: wallet),
          SendTab(controller: pagerController),
          ReceiveTab(wallet: wallet),
        ],
      );

      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: pageView,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Wallet.loadFromDisk(network: NetworkType.MAIN),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Succesfully loaded wallet
            return buildFromWallet(snapshot.data, context);
          } else if (snapshot.hasError) {
            // Load from disk failed - generate then save seed.
            // TODO: Classify error:
            //    - If it's missing we need to generate
            //    - If it's corrupted we need to warn
            return FutureBuilder(
                future: Wallet.generateNew(network: NetworkType.MAIN),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildFromWallet(snapshot.data, context);
                  } else {
                    return LoadingPage(text: 'Generating new wallet...');
                  }
                });
          } else {
            // TODO: Put some sort of debounce here so it doesn't ever flash
            return LoadingPage(text: 'Loading wallet...');
          }
        });
  }
}
