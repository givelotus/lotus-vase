import 'package:cashew/constants.dart';
import 'package:cashew/wallet.dart';
import 'package:flutter/material.dart';

class BalanceTab extends StatelessWidget {
  BalanceTab({Key key, this.wallet}) : super(key: key);

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final balance = wallet.balanceSatoshis();
    final balanceCard = Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("Balance"),
            subtitle: Text("in satoshis"),
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
      elevation: cardElevation,
    );

    final historyCard = Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("History"),
          )
        ],
      ),
      elevation: cardElevation,
    );

    return Column(
      children: [
        Padding(child: balanceCard, padding: cardPadding),
        Expanded(child: Padding(child: historyCard, padding: cardPadding)),
      ],
    );
  }
}
