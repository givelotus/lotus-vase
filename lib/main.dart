import 'package:cashew/electrum/client.dart';
import 'package:cashew/loading_page.dart';
import 'package:cashew/tabs/balance.dart';
import 'package:cashew/tabs/receive.dart';
import 'package:cashew/tabs/send.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

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

class ConnectingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 25, child: Center(child: Text('Connecting...')));
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Wallet wallet;
  Future<bool> initialized;

  @override
  void initState() {
    super.initState();
    final electrumFactory = ElectrumFactory(Uri.parse(electrumUrl));
    wallet = Wallet('todo path', electrumFactory);
    initialized = wallet.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialized,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                // Show loading bottom bar while electrum hasn't
                bottomNavigationBar: FutureBuilder(
                    future: initialized,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ConnectingBottomSheet();
                      } else {
                        return Container(height: 0);
                      }
                    }),
                appBar: AppBar(
                  title: TabBar(
                    tabs: [
                      Tab(icon: Text('Send')),
                      Tab(icon: Text('Receive')),
                      Tab(icon: Text('Balance')),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    SendTab(
                      wallet: wallet,
                    ),
                    ReceiveTab(wallet: wallet),
                    BalanceTab(wallet: wallet),
                  ],
                ),
              ),
            );
          } else {
            return LoadingPage();
          }
        });
  }
}
