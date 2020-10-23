import 'package:cashew/electrum.dart';
import 'package:cashew/tabs/balance.dart';
import 'package:cashew/tabs/receive.dart';
import 'package:cashew/tabs/send.dart';
import 'package:cashew/wallet.dart';
import 'package:flutter/material.dart';
import 'package:cashew/electrum/rpc.dart';

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

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Wallet wallet = new Wallet("todo");
  ElectrumClient client = new ElectrumClient.connect(electrumUrl);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(icon: Text("Send")),
              Tab(icon: Text("Receive")),
              Tab(icon: Text("Balance")),
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
  }
}
