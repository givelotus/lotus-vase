import 'package:cashew/constants.dart';
import 'package:cashew/viewmodel.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:cashew/bitcoincash/src/bip39/bip39.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatelessWidget {
  SettingsTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final showSeedTextController = TextEditingController(
      text: wallet.seed.value,
    );

    final newSeedController = TextEditingController();

    final balanceCard = Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Balance'),
            subtitle: Text('in satoshis'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<CashewModel>(
              builder: (context, model, child) {
                if (model.initialized) {
                  return Text(
                    '${model.activeWallet.balanceSatoshis()}',
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
      elevation: stdElevation,
    );

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
                            if (!mnemonicGenerator
                                .validateMnemonic(newSeedController.text)) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid Seed Phrase'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              return;
                            }
                            Navigator.of(context).pop();
                            wallet.seedPhrase = newSeedController.text;
                            showSeedTextController.text =
                                newSeedController.text;
                            // TODO: This is not behaving itself
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Saved!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
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

    final historyCard = Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('History'),
          )
        ],
      ),
      elevation: stdElevation,
    );

    return Scaffold(
      body: Column(
        children: [
          Padding(
            child: balanceCard,
            padding: stdPadding,
          ),
          Expanded(
            child: Padding(
              child: historyCard,
              padding: stdPadding,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: stdPadding,
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
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(6, 6, 6, 24),
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
