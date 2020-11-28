import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

const STORAGE_SEED_KEY = 'seed';

class Bip39Seed {
  Bip39Seed(this.seed) : _storage = FlutterSecureStorage();

  final String seed;
  final FlutterSecureStorage _storage;

  static Future<Bip39Seed> readFromDisk() async {
    var storage = FlutterSecureStorage();
    var seed = await storage.read(key: STORAGE_SEED_KEY);

    return Bip39Seed(seed);
  }

  factory Bip39Seed.random() {
    final mnemonicGenerator = Mnemonic();
    //'festival shrimp feel before tackle pyramid immense banner fire wash steel fiscal'
    return Bip39Seed(mnemonicGenerator.generateMnemonic());
  }

  Future<void> writeToDisk() async {
    await _storage.write(
      key: STORAGE_SEED_KEY,
      value: seed,
    );
  }

  @override
  String toString() => seed;
}
