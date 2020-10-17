import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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

Future<CameraDescription> getCamera() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  return cameras[0];
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
            FutureBuilder(
                future: getCamera(),
                builder: (context, data) {
                  if (data.hasData) {
                    return SendTab(
                      wallet: wallet,
                      camera: data.data,
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            Icon(Icons.directions_transit),
            BalanceTab(balance: wallet.balanceSatoshis().toString()),
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
}

class BalanceTab extends StatelessWidget {
  BalanceTab({Key key, this.balance}) : super(key: key);

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(this.balance));
  }
}

class SendTab extends StatefulWidget {
  SendTab({Key key, this.wallet, this.camera}) : super(key: key);

  final Wallet wallet;
  final CameraDescription camera;

  @override
  _SendTabState createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
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
