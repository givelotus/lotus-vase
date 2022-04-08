import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/constants.dart';
import 'package:vase/lotus/bip39/bip39.dart';
import 'package:vase/viewmodel.dart';

final packageInfoFuture = PackageInfo.fromPlatform();

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletModel = Provider.of<WalletModel>(context, listen: false);
    final showSeedTextController = TextEditingController(
      text: walletModel.seed,
    );
    final showPasswordTextController = TextEditingController(
      text: walletModel.password,
    );
    final balanceNotifier = walletModel.balance;

    final newSeedController = TextEditingController();
    final newPasswordController = TextEditingController();

    void showSeedDialog() {
      showDialog(
        context: context,
        builder: (context) => GestureDetector(
          // leave the dialogContext open when it has been copied,
          // only close it when the user decides to close it
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
              builder: (context) => GestureDetector(
                onTap: () {},
                child: SimpleDialog(
                  contentPadding: stdPadding,
                  title: const Text('Seed Phrase'),
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            minLines: 2,
                            controller: showSeedTextController,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                          child: OutlinedButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: showSeedTextController.text,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied seed to Clipboard'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Icon(Icons.copy),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text(
                          'Password (Optional)',
                        )),
                    Row(children: [
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          minLines: 2,
                          controller: showPasswordTextController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    void showEnterSeedDialog() {
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Enter Seed Phrase'),
          contentPadding: stdPadding,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Text('Seed'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    minLines: 2,
                    controller: newSeedController,
                    readOnly: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Text(
                  'Password (Optional)',
                )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    minLines: 2,
                    controller: newPasswordController,
                    readOnly: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  height: 60.0,
                  child: OutlinedButton(
                    onPressed: () {
                      final mnemonicGenerator = Mnemonic();
                      final enteredSeed =
                          newSeedController.text.trim().toLowerCase();
                      final enteredPassword =
                          newPasswordController.text.trim().toLowerCase();

                      if (!mnemonicGenerator.validateMnemonic(enteredSeed)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid Seed Phrase'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        return;
                      }
                      // This will regenerate everything
                      walletModel.setSeed(enteredSeed,
                          password: enteredPassword);
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Future<Null> Function() _launchUrl(String url) => () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        };

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: Icon(Icons.navigate_before),
                      onPressed: () => context.pop(),
                      splashRadius: AppTheme.splashRadius,
                    ),
                  ),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // settings menu
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text(
                      'Wallet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Seed Phrase'),
                    leading: Icon(Icons.nature),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => showSeedDialog(),
                  ),
                  ListTile(
                    title: const Text('Import Seed Phrase'),
                    leading: Icon(Icons.upload),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => showEnterSeedDialog(),
                  ),
                  Divider(),
                  ListTile(
                    title: const Text(
                      'More',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Help'),
                    leading: Icon(Icons.help),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: _launchUrl('https://t.me/cashewwallet'),
                  ),
                  ListTile(
                      title: const Text('Website'),
                      leading: Icon(Icons.web),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: _launchUrl('https://givelotus.org')),
                  ListTile(
                    title: const Text('Community'),
                    leading: Icon(Icons.group),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: _launchUrl('https://t.me/givelotus'),
                  ),
                  ListTile(
                    title: const Text('Version'),
                    subtitle: FutureBuilder<PackageInfo>(
                      future: packageInfoFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('${snapshot.data?.version}');
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    leading: Icon(Icons.info),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
