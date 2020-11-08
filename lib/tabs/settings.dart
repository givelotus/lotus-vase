import 'package:cashew/constants.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsTab extends StatelessWidget {
  SettingsTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController(text: wallet.bip39Seed);
    final balance = wallet.balanceSatoshis();
    final balanceCard = Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Balance'),
            subtitle: Text('in satoshis'),
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
      elevation: stdElevation,
    );

    void showSeedDialog() {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return SimpleDialog(
            title: const Text('Seed Phrase'),
            children: <Widget>[
              Padding(
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: _controller.text,
                      ),
                    );
                    Navigator.pop(dialogContext);
                    Scaffold.of(context).showSnackBar(
                      copiedAd,
                    );
                  },
                  child: Text('Copy'),
                ),
              ),
            ],
          );
        },
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

    return Column(
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
                  child: Text('Show Seed'),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
