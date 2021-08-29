import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:vase/constants.dart';
import 'package:vase/viewmodel.dart';
import 'package:vase/lotus/bip39/bip39.dart';
import 'component/balance_display.dart';

class SettingsTab extends StatelessWidget {
  SettingsTab({Key key}) : super(key: key);

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

    return SafeArea(
        child: Padding(
            padding: stdPadding,
            child: Column(
              children: [
                BalanceDisplay(balanceNotifier: balanceNotifier),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => showSeedDialog(),
                        child: Text(
                          'Show Seed',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => showEnterSeedDialog(),
                        child: Text(
                          'Import Seed',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
