import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/config/constants.dart';
import 'package:vase/lotus/bip39/bip39.dart';
import 'package:vase/features/wallet/wallet_model.dart';

final packageInfoFuture = PackageInfo.fromPlatform();

class SettingsPage extends HookWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showSeedTextController = useTextEditingController();
    final showPasswordTextController = useTextEditingController();
    final newSeedController = useTextEditingController();
    final newPasswordController = useTextEditingController();

    void showSeedDialog() {
      showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) {
          final walletModel = context.watch<WalletModel>();
          showSeedTextController.text = walletModel.seed ?? '';
          showPasswordTextController.text = walletModel.password ?? '';
          return Stack(
            children: [
              const IgnorePointer(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                ),
              ),
              AlertDialog(
                title: showSeedTextController.text.isNotEmpty
                    ? const Text('Seed Phrase')
                    : null,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showSeedTextController.text.isEmpty)
                      const Center(child: CircularProgressIndicator()),
                    if (showSeedTextController.text.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              minLines: 2,
                              controller: showSeedTextController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                            child: OutlinedButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: showSeedTextController.text,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied seed to Clipboard'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Icon(Icons.copy),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ])
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    void showEnterSeedDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter Seed Phrase'),
          contentPadding: stdPadding,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final mnemonicGenerator = Mnemonic();
                final enteredSeed = newSeedController.text.trim().toLowerCase();
                final enteredPassword =
                    newPasswordController.text.trim().toLowerCase();

                if (!mnemonicGenerator.validateMnemonic(enteredSeed)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid Seed Phrase'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  return;
                }

                final walletModel = context.read<WalletModel>();
                // This will regenerate everything
                walletModel.setSeed(enteredSeed, password: enteredPassword);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          splashRadius: AppTheme.splashRadius,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.navigate_before),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Wallet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Seed Phrase'),
            leading: const Icon(Icons.nature),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => showSeedDialog(),
          ),
          ListTile(
            title: const Text('Import Seed Phrase'),
            leading: const Icon(Icons.upload),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => showEnterSeedDialog(),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'More',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Help'),
            leading: const Icon(Icons.help),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: _launchUrl('https://t.me/cashewwallet'),
          ),
          ListTile(
              title: const Text('Website'),
              leading: const Icon(Icons.web),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: _launchUrl('https://givelotus.org')),
          ListTile(
            title: const Text('Community'),
            leading: const Icon(Icons.group),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: _launchUrl('https://discord.gg/ebbFsWRdgb'),
          ),
          ListTile(
            title: const Text('Version'),
            subtitle: FutureBuilder<PackageInfo>(
              future: packageInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data?.version}');
                }
                return const SizedBox.shrink();
              },
            ),
            leading: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
