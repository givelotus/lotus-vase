import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

const STORAGE_SEED_KEY = 'seed';

class Bip39Seed {
  Bip39Seed({@required this.value}) : _storage = FlutterSecureStorage();

  final String value;
  final FlutterSecureStorage _storage;

  static Future<Bip39Seed> readFromDisk() async {
    var storage = FlutterSecureStorage();
    var value = await storage.read(key: STORAGE_SEED_KEY);

    return Bip39Seed(value: value);
  }

  Future<void> writeToDisk() async {
    await _storage.write(
      key: STORAGE_SEED_KEY,
      value: value,
    );
  }

  @override
  String toString() => value;
}
