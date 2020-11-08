import 'dart:collection';

class Outpoint {
  Outpoint(this.transactionId, this.vout, this.amount);
  String transactionId;
  int vout;
  BigInt amount;
}

class Utxo {
  Utxo(this.outpoint, this.externalOutput, this.keyIndex);

  Outpoint outpoint;

  /// Is an external output? Else a change output.
  bool externalOutput;

  /// Index of the associated private key.
  int keyIndex;
}

/// The vault stores utxo outputs - that is, outputs together with
/// information required to spend them.
class Vault {
  Vault(Iterable<Utxo> utxos) {
    var zipped = {};
    for (final utxo in utxos) {
      zipped.update(
        utxo.outpoint.amount,
        (value) {
          value.add(utxo);
          return value;
        },
        ifAbsent: () => [utxo],
      );
    }
    _pool = SplayTreeMap.from(zipped);
  }
  SplayTreeMap<BigInt, List<Utxo>> _pool;

  /// Removes the smallest output more than a specific amount.
  Utxo smallestAbove(BigInt amount) {
    final key = _pool.firstKeyAfter(amount);
    return popAt(key);
  }

  /// Removes the largest output below a specific amount.
  Utxo largestBelow(BigInt amount) {
    final key = _pool.lastKeyBefore(amount);
    return popAt(key);
  }

  /// Remove all UTXOs under a specific key.
  void removeByKeyIndex(int keyIndex, bool externalOutput) {
    _pool.updateAll((key, utxos) {
      utxos.removeWhere((utxo) =>
          (utxo.externalOutput == externalOutput) &&
          (utxo.keyIndex == keyIndex));
      return utxos;
    });
  }

  /// Add a utxo output.
  void add(Utxo utxo) {
    _pool.update(
      utxo.outpoint.amount,
      (value) {
        value.add(utxo);
        return value;
      },
      ifAbsent: () => [utxo],
    );
  }

  /// Remove a utxo output at a given amount.
  Utxo popAt(BigInt amount) {
    final utxos = _pool.remove(amount);
    if (utxos != null) {
      final popped = utxos.removeLast();
      if (utxos.isNotEmpty) {
        addAll(utxos);
      }
      return popped;
    } else {
      return null;
    }
  }

  /// Add multiple utxos.
  void addAll(Iterable<Utxo> utxos) {
    for (final utxo in utxos) {
      _pool.update(
        utxo.outpoint.amount,
        (value) {
          value.add(utxo);
          return value;
        },
        ifAbsent: () => [utxo],
      );
    }
  }

  BigInt calculateBalance() {
    return _pool.keys.fold(BigInt.zero, (p, c) => p + c);
  }

  /// Collect enough utxos to cover the [amount] and any additional fees.
  ///
  /// The [baseFee] is the fee for the desired transaction ignoring inputs.
  /// The [feePerInput] is the cost per input.
  List<Utxo> collectUtxos(BigInt amount, BigInt baseFee, BigInt feePerInput) {
    // Create an intermediate pool which is commit on success
    var tempVault = this;

    var retUtxos = <Utxo>[];
    var remainingAmount = amount + baseFee;

    while (true) {
      remainingAmount += feePerInput;

      // Check whether there's a perfect sized UTXO
      final exactUtxo = tempVault.popAt(remainingAmount);
      if (exactUtxo != null) {
        retUtxos.add(exactUtxo);

        // Commit to new pool
        _pool = tempVault._pool;
        return retUtxos;
      }

      // Check whether large enough UTXO exists
      final aboveUtxo = tempVault.smallestAbove(remainingAmount);
      if (aboveUtxo != null) {
        retUtxos.add(aboveUtxo);

        // Commit to new pool
        _pool = tempVault._pool;
        return retUtxos;
      }

      // Find largest UTXO below the remaining amount
      final belowUtxo = tempVault.largestBelow(remainingAmount);
      if (belowUtxo == null) {
        // No UTXOs left
        throw Exception('Insufficient balance');
      }
      retUtxos.add(belowUtxo);
      remainingAmount -= belowUtxo.outpoint.amount;
    }
  }
}
