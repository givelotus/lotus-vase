import 'package:cashew/electrum/client.dart';
import 'package:cashew/tabs/settings.dart';
import 'package:cashew/tabs/receive.dart';
import 'package:cashew/tabs/send/send.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

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

class DisconnectedBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.redAccent,
        height: 25,
        child: Center(child: Text('Connecting to network...')));
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (BuildContext context) {
      return CashewModel(
          '', Wallet('todo path', ElectrumFactory(Uri.parse(electrumUrl))));
    }, builder: (context, child) {
      final model = Provider.of<CashewModel>(context);
      final wallet = model.activeWallet;
      return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // Show loading bottom bar while electrum hasn't
          bottomNavigationBar: FutureBuilder(builder: (context, snapshot) {
            if (!model.initialized) {
              return DisconnectedBottomSheet();
            }
            return Container(height: 0);
          }),
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(icon: Text('Settings')),
                Tab(icon: Text('Send')),
                Tab(icon: Text('Receive')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SettingsTab(wallet: wallet),
              SendTab(
                wallet: wallet,
              ),
              ReceiveTab(wallet: wallet),
            ],
          ),
        ),
      );
    });
  }
}
