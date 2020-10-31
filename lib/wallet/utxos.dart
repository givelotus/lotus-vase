import 'dart:collection';

import 'package:cashew/bitcoincash/bitcoincash.dart';

class UtxoStorage {
  UtxoStorage(Iterable<TransactionOutput> utxos) {
    final zipped = {for (final utxo in utxos) utxo.satoshis: utxo};
    _utxoPool = SplayTreeMap.from(zipped);
  }
  SplayTreeMap<BigInt, TransactionOutput> _utxoPool;

  /// Gets the smallest output more than a specific amount.
  TransactionOutput smallestAbove(BigInt amount) {
    final key = _utxoPool.firstKeyAfter(amount);
    return _utxoPool[key];
  }

  /// Gets the largest output below a specific amount.
  TransactionOutput largestBelow(BigInt amount) {
    final key = _utxoPool.lastKeyBefore(amount);
    return _utxoPool[key];
  }

  /// Add transaction output.
  void add(TransactionOutput utxo) {
    _utxoPool[utxo.satoshis] = utxo;
  }

  /// Add transaction outputs.
  void addAll(Iterable<TransactionOutput> utxos) {
    final zipped = {for (final utxo in utxos) utxo.satoshis: utxo};
    _utxoPool.addAll(zipped);
  }

  /// Collect enough outputs to cover the [amount] and any additional fees.
  ///
  /// The [baseFee] is the fee for the desired transaction ignoring inputs.
  /// The [feePerInput] is the cost per input.
  List<TransactionOutput> collectOutputs(
      BigInt amount, BigInt baseFee, BigInt feePerInput) {
    // Create an intermediate pool which is commit on success
    var pool = _utxoPool;

    var utxos = [];
    var remainingAmount = amount + baseFee;

    while (true) {
      remainingAmount += feePerInput;

      // Check whether there's a perfect sized UTXO
      final exactOutput = _utxoPool[remainingAmount];
      if (exactOutput != null) {
        utxos.add(exactOutput);
        _utxoPool = pool;
        return utxos;
      }

      // Check whether large enough UTXO exists
      final aboveOutput = smallestAbove(remainingAmount);
      if (aboveOutput != null) {
        utxos.add(aboveOutput);
        _utxoPool = pool; // Commit
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
