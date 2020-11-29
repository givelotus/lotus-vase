import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cashew/wallet/wallet.dart';
import 'package:cashew/wallet/keys.dart';
import 'package:cashew/wallet/storage/keys.dart';
import 'package:cashew/constants.dart';

import 'package:cashew/bitcoincash/src/networks.dart';

import 'electrum/client.dart';

const SCHEMA_VERSION_KEY = 'schema_version';

const CURRENT_SCHEMA_VERSION = '0.2.0';

const STORAGE_SEED_KEY = 'seed';
const STORAGE_XPUB_KEY = 'rootKey';

/// Generate a fresh wallet.
Future<Wallet> generateNewWallet(String seed,
    {network = NetworkType.TEST}) async {
  final keys = await Keys.construct(seed);
  final electrumFactory = ElectrumFactory(electrumUrls);

  return Wallet(keys, electrumFactory, network: network);
}

class WalletModel with ChangeNotifier {
  Wallet _wallet;
  bool _initialized = false;
  String _seed = '';
  // Internally use a ValueNotifier here, as we don't want the entire wallet
  // to refresh when this field is updated.
  // We should probably introduce a secondary model of some sort.
  final ValueNotifier<int> balance;
  final FlutterSecureStorage _storage;

  // TODO: Storage should be injected
  WalletModel()
      : _storage = FlutterSecureStorage(),
        balance = ValueNotifier<int>(null) {
    initializeModel(); // Run in background.
  }

  Future<void> initializeModel() async {
    final readSucceed = await readFromDisk();
    if (!readSucceed) {
      // final testSeed =
      //     'festival shrimp feel before tackle pyramid immense banner fire wash steel fiscal';
      final mnemonicGenerator = Mnemonic();
      final seed = mnemonicGenerator.generateMnemonic();
      _seed = seed;

      // Don't notify listeners. Initlaize will do that
      _wallet = await generateNewWallet(_seed);
    }
    wallet.balanceUpdateHandler = (balance) => this.balance.value = balance;
    await wallet.initialize();
    initialized = true;
  }

  set initialized(bool newValue) {
    _initialized = newValue;
    notifyListeners();
  }

  String get seed => _seed;

  set seed(String newValue) {
    _seed = newValue;
    balance.value = null;
    _initialized = false;
    notifyListeners();
    generateNewWallet(_seed).then((newWallet) {
      _wallet = newWallet;
      wallet.balanceUpdateHandler = (balance) => this.balance.value = balance;
      wallet.initialize();
      initialized = true;
    });
  }

  bool get initialized => _initialized;

  Wallet get wallet => _wallet;

  set wallet(Wallet newValue) {
    _wallet = newValue;
    notifyListeners();
  }

  Future<String> readSchemaVersion() {
    final storage = FlutterSecureStorage();
    return storage.read(key: SCHEMA_VERSION_KEY);
  }

  Future<void> writeSchemaVersion() {
    final storage = FlutterSecureStorage();
    return storage.write(
        key: SCHEMA_VERSION_KEY, value: CURRENT_SCHEMA_VERSION);
  }

  Future<void> writeToDisk() async {
    // Persist schema version
    await writeSchemaVersion();

    // Persist keys
    // TODO: keys.keys is silly naming
    await writeKeysToDisk(wallet.keys.keys);
  }

  Future<bool> readFromDisk() async {
    // Persist schema version
    final schemaVersion = await readSchemaVersion();
    if (schemaVersion != CURRENT_SCHEMA_VERSION) {
      return false;
    }

    // Persist keys
    final keys = await readKeysFromDisk();

    wallet = Wallet(
      keys,
      ElectrumFactory(electrumUrls),
      network: network,
    );

    return true;
  }

  Future<void> writeKeysToDisk(List<KeyInfo> keys) async {
    // Write private keys
    final keyWrites = keys.asMap().entries.map((entry) {
      final index = entry.key;
      final keyInfo = entry.value;
      final storedKey = StoredKey.fromKeyInfo(keyInfo);
      return storedKey.writeToDisk(index);
    });
    await Future.wait(keyWrites);
    // Persist seed
    await _storage.write(
      key: STORAGE_SEED_KEY,
      value: seed,
    );

    // Persist XPub
    await _storage.write(
      key: STORAGE_XPUB_KEY,
      value: wallet.keys.rootKey.toString(),
    );

    // Write metadata
    final metadata = KeyStorageMetadata(keys.length);
    await metadata.writeToDisk();
  }

  Future<Keys> readKeysFromDisk() async {
    // Read metadata
    final metadata = await KeyStorageMetadata.readFromDisk();
    final keyCount = metadata.keyCount;

    // Read private keys
    final storedKeyFutures = List<Future<StoredKey>>.generate(
        keyCount, (index) => StoredKey.readFromDisk(index));
    final storedKeys = await Future.wait(storedKeyFutures);

    // Read seed
    final seed = await _storage.read(key: STORAGE_SEED_KEY);

    // Read root key to avoid regenerating from seed
    final xpubHex = await _storage.read(key: STORAGE_XPUB_KEY);
    final rootKey = HDPrivateKey.fromXpriv(xpubHex);

    // Convert to key info
    final keyInfo =
        storedKeys.map((storedKey) => storedKey.toKeyInfo(network)).toList();

    return Keys(seed, rootKey, keyInfo, network: network);
  }
}
