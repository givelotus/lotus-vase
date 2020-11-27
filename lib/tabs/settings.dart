import 'package:cashew/constants.dart';
import 'package:cashew/viewmodel.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatelessWidget {
  SettingsTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController(
      text: wallet.seed.value,
    );

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
                              controller: _controller,
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
                                  text: _controller.text,
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
              )
            ],
          )
        ],
      ),
    );
  }
}
