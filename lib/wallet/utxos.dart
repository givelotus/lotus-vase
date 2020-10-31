import 'dart:collection';
import 'dart:ffi';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:dartz/dartz.dart';

class Outpoint {
  String transactionId;
  Uint32 vout;
}

class SpendableOutput {
  Outpoint outpoint;
  TransactionOutput output;

  /// Is an external output? Else a change output.
  bool externalOutput;

  /// Index of the associated private key.
  int keyIndex;
}

class UtxoStorage {
  UtxoStorage(Iterable<SpendableOutput> bundles) {
    final zipped = {
      for (final bundle in bundles) bundle.output.satoshis: bundle
    };
    _utxoPool = SplayTreeMap.from(zipped);
  }
  SplayTreeMap<BigInt, SpendableOutput> _utxoPool;

  /// Gets the smallest output more than a specific amount.
  SpendableOutput smallestAbove(BigInt amount) {
    final key = _utxoPool.firstKeyAfter(amount);
    return _utxoPool[key];
  }

  /// Gets the largest output below a specific amount.
  SpendableOutput largestBelow(BigInt amount) {
    final key = _utxoPool.lastKeyBefore(amount);
    return _utxoPool[key];
  }

  /// Add transaction output.
  void add(SpendableOutput bundle) {
    _utxoPool[bundle.output.satoshis] = bundle;
  }

  /// Add transaction outputs.
  void addAll(Iterable<SpendableOutput> bundles) {
    final zipped = {
      for (final bundle in bundles) bundle.output.satoshis: bundle
    };
    _utxoPool.addAll(zipped);
  }

  /// Collect enough outputs to cover the [amount] and any additional fees.
  ///
  /// The [baseFee] is the fee for the desired transaction ignoring inputs.
  /// The [feePerInput] is the cost per input.
  List<SpendableOutput> collectOutputs(
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
      remainingAmount -= belowOutput.output.satoshis;
    }
  }
}
