import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(CashewApp());
}

const cardElevation = 6.0;
const cardPadding = EdgeInsets.all(12.0);

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

class Wallet {
  Wallet(String walletPath) {}

  int balanceSatoshis() {
    return 1000;
  }

  String getAddress() {
    return "bchtest:dsajkdsaadfghfgfhhggjkhgjhjghjbhjk";
  }

  void send(String address, int satoshis) {
    // TODO
  }
}

class ReceiveTab extends StatelessWidget {
  ReceiveTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final address = wallet.getAddress();
    final _controller = TextEditingController(text: wallet.getAddress());

    final manualCard = Card(
        child: Column(children: [
          ListTile(
            title: const Text("Text Address"),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                readOnly: true,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ))
        ]),
        elevation: cardElevation);

    final qrCard = Card(
      child: Column(children: [
        ListTile(
          title: const Text("QR Address"),
        ),
        QrImage(data: address, version: QrVersions.auto)
      ]),
      elevation: cardElevation,
    );
    return Column(children: [
      Padding(
        padding: cardPadding,
        child: qrCard,
      ),
      Padding(padding: cardPadding, child: manualCard)
    ]);
  }
}

class BalanceTab extends StatelessWidget {
  BalanceTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final balance = wallet.balanceSatoshis();
    final balanceCard = Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("Balance"),
            subtitle: Text("in satoshis"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              balance.toString(),
              style:
                  TextStyle(fontSize: 24, color: Colors.black.withOpacity(0.6)),
            ),
          )
        ],
      ),
      elevation: cardElevation,
    );

    final historyCard = Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("History"),
          )
        ],
      ),
      elevation: cardElevation,
    );

    return Column(
      children: [
        Padding(child: balanceCard, padding: cardPadding),
        Expanded(child: Padding(child: historyCard, padding: cardPadding)),
      ],
    );
  }
}

class SendTab extends StatefulWidget {
  SendTab({Key key, this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  _SendTabState createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = '';

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = QrScannerOverlayShape(
      borderColor: Colors.red,
      borderRadius: 10,
      borderLength: 30,
      borderWidth: 10,
      cutOutSize: 300,
    );
    return Column(
      children: [
        Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: overlay,
            )),
        Expanded(flex: 1, child: SendWidget())
      ],
    );
  }
}

class SendWidget extends StatefulWidget {
  SendWidget({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  _SendWidgetState createState() => _SendWidgetState();
}

class _SendWidgetState extends State<SendWidget> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter an address'),
            )),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => {widget.wallet.send(_controller.text, 0)},
            )
          ],
        ));
  }
}
