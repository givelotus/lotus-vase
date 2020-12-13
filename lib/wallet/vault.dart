import 'dart:collection';

class Outpoint {
  Outpoint(this.transactionId, this.vout, this.amount);
  String transactionId;
  int vout;
  BigInt amount;
}

class Utxo {
  Utxo(this.outpoint, this.keyIndex);

  Outpoint outpoint;

  /// Index of the associated private key.
  int keyIndex;
}

/// The vault stores utxo outputs - that is, outputs together with
/// information required to spend them.
class Vault extends SplayTreeMap<BigInt, List<Utxo>> {
  Vault(Iterable<Utxo> utxos) : super() {
    addAllUtxos(utxos);
  }

  Vault.from(Vault vault) : super() {
    addAll(vault);
  }

  /// Removes the smallest output more than a specific amount.
  Utxo smallestAbove(BigInt amount) {
    final key = firstKeyAfter(amount);
    return popAt(key);
  }

  /// Removes the largest output below a specific amount.
  Utxo largestBelow(BigInt amount) {
    final key = lastKeyBefore(amount);
    return popAt(key);
  }

  /// Remove all UTXOs under a specific key.
  void removeByKeyIndex(int keyIndex) {
    updateAll((key, utxos) {
      utxos.removeWhere((utxo) => utxo.keyIndex == keyIndex);
      return utxos;
    });
  }

  /// Add a utxo output.
  void removeUtxo(Utxo utxo) {
    update(utxo.outpoint.amount, (value) {
      value.remove(utxo);
      return value;
    });
  }

  /// Add a utxo output.
  void addUtxo(Utxo utxo) {
    update(
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
    final utxos = remove(amount);
    if (utxos != null) {
      final popped = utxos.removeLast();
      if (utxos.isNotEmpty) {
        this[amount] = utxos;
      }
      return popped;
    } else {
      return null;
    }
  }

  /// Add multiple utxos.
  void addAllUtxos(Iterable<Utxo> utxos) {
    for (final utxo in utxos) {
      addUtxo(utxo);
    }
  }

  BigInt calculateBalance() {
    return values.fold(
        BigInt.zero,
        (p, c) =>
            p +
            c.fold(
                BigInt.zero,
                (totalOutputs, output) =>
                    totalOutputs + output.outpoint.amount));
  }
}
