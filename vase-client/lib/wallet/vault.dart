import 'dart:collection';

class VaultOutpoint {
  VaultOutpoint(this.transactionId, this.vout, this.amount, this.height);
  String? transactionId;
  int? vout;
  BigInt amount;
  int? height;
}

class VaultUtxo {
  VaultUtxo(this.outpoint, this.keyIndex);

  VaultOutpoint outpoint;

  /// Index of the associated private key.
  int? keyIndex;
}

/// The vault stores utxo outputs - that is, outputs together with
/// information required to spend them.
class Vault extends SplayTreeMap<BigInt, List<VaultUtxo>> {
  Vault(Iterable<VaultUtxo> utxos) : super() {
    addAllUtxos(utxos);
  }

  Vault.from(Vault vault) : super() {
    addAll(vault);
  }

  /// Remove all UTXOs under a specific key.
  void removeByKeyIndex(int? keyIndex) {
    updateAll((key, utxos) {
      utxos.removeWhere((utxo) => utxo.keyIndex == keyIndex);
      return utxos;
    });
  }

  /// Remove a utxo output.
  void removeUtxo(VaultUtxo utxo) {
    update(utxo.outpoint.amount, (value) {
      value.removeWhere((checkUtxo) =>
          checkUtxo.outpoint.transactionId == utxo.outpoint.transactionId &&
          checkUtxo.outpoint.vout == utxo.outpoint.vout);
      return value;
    }, ifAbsent: () => []);
  }

  /// Add a utxo output.
  void addUtxo(VaultUtxo utxo) {
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
  VaultUtxo? popAt(BigInt amount) {
    final List<VaultUtxo>? utxos = remove(amount);
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
  void addAllUtxos(Iterable<VaultUtxo> utxos) {
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
