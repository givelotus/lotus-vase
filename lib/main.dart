import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    return "bchtest:dsajkdsa";
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
    final qrCard = Card(
      child: QrImage(data: address, version: QrVersions.auto),
      elevation: cardElevation,
    );
    final _controller = TextEditingController(text: wallet.getAddress());
    return Column(
      children: [
        Padding(
          padding: cardPadding,
          child: qrCard,
        ),
        TextField(
          controller: _controller,
          readOnly: true,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
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

Future<CameraDescription> getCamera() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  return cameras[0];
}

class SendTab extends StatelessWidget {
  SendTab({Key key, this.wallet, this.camera}) : super(key: key);
  final Wallet wallet;
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
            future: getCamera(),
            builder: (context, data) {
              if (data.hasData) {
                return QRScanner(
                  camera: data.data,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        Expanded(child: SendWidget())
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

class QRScanner extends StatefulWidget {
  QRScanner({Key key, this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
