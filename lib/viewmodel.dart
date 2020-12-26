import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cashew/wallet/wallet.dart';
import 'package:cashew/wallet/keys.dart';
import 'package:cashew/constants.dart';

import 'electrum/client.dart';

const SCHEMA_VERSION_KEY = 'schema_version';

const CURRENT_SCHEMA_VERSION = '3';

const STORAGE_SEED_KEY = 'seed';
const STORAGE_XPUB_KEY = 'rootKey';

/// Generate a fresh wallet.
Future<Wallet> generateNewWallet(String seed, {network = network}) async {
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
  final ValueNotifier<WalletBalance> balance;
  final FlutterSecureStorage _storage;

  // TODO: Storage should be injected
  WalletModel()
      : _storage = FlutterSecureStorage(),
        balance = ValueNotifier<WalletBalance>(WalletBalance()) {
    initializeModel(); // Run in background.
  }

  Future<void> initializeModel() async {
    final readSucceed = await readFromDisk();
    if (!readSucceed) {
      try {
        // try to recover from read errors. Maybe seed is still valid.
        _seed = await readSeedFromDisk();
        // ignore: empty_catches
      } catch (err) {}
      if (_seed == null || _seed.isEmpty) {
        final mnemonicGenerator = Mnemonic();
        final seed = mnemonicGenerator.generateMnemonic();
        _seed = seed;
      }
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
    await writeKeysToDisk();
  }

  Future<bool> readFromDisk() async {
    try {
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
    } catch (err) {
      print(err);
      return false;
    }

    return true;
  }

  Future<void> writeKeysToDisk() async {
    // Write private keys
    try {
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

      // TODO: Write metadata
    } catch (err) {
      print(err);
    }
  }

  Future<String> readSeedFromDisk() async {
    // TODO: Read metadata

    // Read seed
    return _storage.read(key: STORAGE_SEED_KEY);
  }

  Future<Keys> readKeysFromDisk() async {
    // TODO: Read metadata

    // Read seed
    _seed = await readSeedFromDisk();

    // Read root key to avoid regenerating from seed
    final xprivHex = await _storage.read(key: STORAGE_XPUB_KEY);
    final rootKey = HDPrivateKey.fromXpriv(xprivHex);

    // Convert to key info
    final childKeys = constructChildKeys(
      rootKey: rootKey,
      network: network,
      // TODO: maybe this should be configurable and saved/restored
      // However, it would be *nice* if we had a dynamic way to calculate
      // more keys when loading the balance.
      childKeyCount: defaultNumberOfChildKeys,
    );

    return Keys(seed, rootKey, childKeys, network: network);
  }
}
