import 'dart:collection';

class Outpoint {
  Outpoint(this.transactionId, this.vout, this.amount, this.height);
  String transactionId;
  int vout;
  BigInt amount;
  int height;
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

  /// Remove all UTXOs under a specific key.
  void removeByKeyIndex(int keyIndex) {
    updateAll((key, utxos) {
      utxos.removeWhere((utxo) => utxo.keyIndex == keyIndex);
      return utxos;
    });
  }

  /// Remove a utxo output.
  void removeUtxo(Utxo utxo) {
    update(utxo.outpoint.amount, (value) {
      value.removeWhere((checkUtxo) =>
          checkUtxo.outpoint.transactionId == utxo.outpoint.transactionId &&
          checkUtxo.outpoint.vout == utxo.outpoint.vout);
      return value;
    }, ifAbsent: () => []);
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
