import 'dart:collection';

import 'package:cashew/bitcoincash/bitcoincash.dart';

class UtxoStorage {
  UtxoStorage(Iterable<TransactionOutput> utxos) {
    final zipped = {for (final utxo in utxos) utxo.satoshis: utxo};
    utxoPool = SplayTreeMap.from(zipped);
  }
  SplayTreeMap<BigInt, TransactionOutput> utxoPool;

  /// Gets the smallest output more than a specific amount.
  TransactionOutput smallestAbove(BigInt amount) {
    final key = utxoPool.firstKeyAfter(amount);
    return utxoPool[key];
  }

  /// Gets the largest output below a specific amount.
  TransactionOutput largestBelow(BigInt amount) {
    final key = utxoPool.lastKeyBefore(amount);
    return utxoPool[key];
  }

  List<TransactionOutput> collectOutputs(BigInt amount) {
    // Create an intermediate pool which is commit on success
    var pool = utxoPool;

    var utxos = [];
    var remainingAmount = amount;

    while (true) {
      // Check whether there's a perfect sized UTXO
      final exactOutput = utxoPool[remainingAmount];
      if (exactOutput != null) {
        utxos.add(exactOutput);
        utxoPool = pool;
        return utxos;
      }

      // Check whether large enough UTXO exists
      final aboveOutput = smallestAbove(remainingAmount);
      if (aboveOutput != null) {
        utxos.add(aboveOutput);
        utxoPool = pool; // Commit
        return utxos;
      }

      // Find largest UTXO below the remaining amount
      final belowOutput = largestBelow(remainingAmount);
      if (belowOutput == null) {
        // No UTXOs left
        throw Exception('Insufficient balance');
      }
      utxos.add(belowOutput);
      remainingAmount -= belowOutput.satoshis;
    }
  }
}
