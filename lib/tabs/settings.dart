import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:cashew/constants.dart';
import 'package:cashew/viewmodel.dart';
import 'package:cashew/bitcoincash/bip39/bip39.dart';
import 'component/balance_display.dart';

class SettingsTab extends StatelessWidget {
  SettingsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletModel = Provider.of<WalletModel>(context, listen: false);
    final showSeedTextController = TextEditingController(
      text: walletModel.seed,
    );
    final balanceNotifier = walletModel.balance;

    final newSeedController = TextEditingController();

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
                  title: const Text('Seed Phrase'),
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
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
                        ),
                        Container(
                          height: 60.0,
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: showSeedTextController.text,
                                ),
                              );
                              Scaffold.of(context).showSnackBar(
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
        builder: (context) => GestureDetector(
          // leave the dialogContext open when it has been copied,
          // only close it when the user decides to close it
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
              builder: (context) => SimpleDialog(
                title: const Text('Enter Seed Phrase'),
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                      ),
                      Container(
                        height: 60.0,
                        padding: const EdgeInsets.only(
                          right: 16.0,
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            final mnemonicGenerator = Mnemonic();
                            final enteredSeed =
                                newSeedController.text.trim().toLowerCase();
                            if (!mnemonicGenerator
                                .validateMnemonic(enteredSeed)) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid Seed Phrase'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              return;
                            }
                            // This will regenerate everything
                            walletModel.seed = enteredSeed;
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                      child: RaisedButton(
                        color: Colors.blue,
                        elevation: stdElevation,
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
                      child: RaisedButton(
                        color: Colors.blue,
                        elevation: stdElevation,
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
