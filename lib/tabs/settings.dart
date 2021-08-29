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
                          height: 60.0,
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
                contentPadding: stdPadding,
                children: <Widget>[
                  Text('Seed'),
                  Spacer(),
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
                  Spacer(),
                  Text(
                    'Password (Optional)',
                  ),
                  Spacer(),
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
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        height: 60.0,
                        child: OutlinedButton(
                          onPressed: () {
                            final mnemonicGenerator = Mnemonic();
                            final enteredSeed =
                                newSeedController.text.trim().toLowerCase();
                            final enteredPassword =
                                newPasswordController.text.trim().toLowerCase();

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
