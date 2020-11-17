import 'package:cashew/electrum/client.dart';
import 'package:cashew/tabs/settings.dart';
import 'package:cashew/tabs/receive.dart';
import 'package:cashew/tabs/send/send.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:cashew/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'pager.dart';
// import 'controls.dart';

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

  double offsetRatio = 0.0;
  double offsetFromOne = 0.0;

  final PageController pagerController =
      new PageController(keepPage: true, initialPage: 1);

    bool onPageView(ScrollNotification notification) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      setState(() {
        offsetFromOne = 1.0 - pagerController.page;
        offsetRatio = offsetFromOne.abs();
      });
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (BuildContext context) {
      return CashewModel(
          '', Wallet(
            'todo path', 
            ElectrumFactory(electrumUrls)));
    }, builder: (context, child) {
      final wallet =
          Provider.of<CashewModel>(context, listen: false).activeWallet;
      return Stack(
            children: <Widget>[
              new SendTab(),   
              new NotificationListener<ScrollNotification>(
                onNotification: onPageView,
                child: new Pager(
                  controller: pagerController,
                  leftWidget: SettingsTab(wallet: wallet),
                  rightWidget: ReceiveTab(wallet: wallet),
                )
              ),
              //    new ControlsLayer(
              //   offset: offsetRatio,
              //   onTap: () {
              //     playPause();
              //   },
              //   cameraIcon: new CameraIcon(),
              //   onCameraTap: () async {
              //     await flipCamera();
              //     setState(() {});
              //   },
              // )


]);
    });
  }
}





//       DefaultTabController(
//         length: 3,
//         initialIndex: 1,
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           // Show loading bottom bar while electrum hasn't
//           bottomNavigationBar:
//               Consumer<CashewModel>(builder: (context, model, child) {
//             if (!model.initialized) {
//               return DisconnectedBottomSheet();
//             }
//             return Container(height: 0);
//           }),
//           // appBar: AppBar(
//           //   title: TabBar(
//           //     tabs: [
//           //       Tab(icon: Text('Settings')),
//           //       Tab(icon: Text('Send')),
//           //       Tab(icon: Text('Receive')),
//           //     ],
//           //   ),
//           //     backgroundColor: Colors.transparent, //No more green
//           //   elevation: 0.0, 
//           // ),
//           body: TabBarView(
//             children: [
//               SettingsTab(wallet: wallet),
//               SendTab(),
//               ReceiveTab(wallet: wallet),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
