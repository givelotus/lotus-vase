import 'package:vase/lotus/lotus.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:vase/wallet/wallet.dart';
import 'package:vase/wallet/keys.dart';
import 'package:vase/constants.dart';

import 'electrum/client.dart';

const SCHEMA_VERSION_KEY = 'schema_version';

const CURRENT_SCHEMA_VERSION = '3';

const STORAGE_SEED_KEY = 'seed';
const STORAGE_PASSWORD_KEY = 'password';
const STORAGE_XPUB_KEY = 'rootKey';

/// Generate a fresh wallet.
Future<Wallet> generateNewWallet(String seed,
    {NetworkType network = network, String password = ''}) async {
  final keys = await Keys.construct(seed, password);
  final electrumFactory = ElectrumFactory(electrumUrls);

  return Wallet(keys, electrumFactory, network: network);
}

class WalletModel with ChangeNotifier {
  Wallet _wallet;
  bool _initialized = false;
  String _seed = '';
  String _password = '';
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
      try {
        // try to recover from read errors. Maybe seed is still valid.
        _password = await readPasswordFromDisk();
        // ignore: empty_catches
      } catch (err) {
        // Don't care
      }
      if (_seed == null || _seed.isEmpty) {
        final mnemonicGenerator = Mnemonic();
        final seed = mnemonicGenerator.generateMnemonic();
        _seed = seed;
      }
      // Don't notify listeners. Initialize will do that
      _wallet = await generateNewWallet(_seed, password: _password);
    }
    wallet.balanceUpdateHandler = (balance) => this.balance.value = balance;
    wallet.initialize();
    initialized = true;
  }

  Future<void> updateWallet() async {
    wallet.initialize();
  }

  set initialized(bool newValue) {
    _initialized = newValue;
    notifyListeners();
  }

  String get seed => _seed;
  String get password => _password;

  void setSeed(String newValue, {String password = ''}) {
    _seed = newValue;
    _password = password;
    balance.value = null;
    _initialized = false;
    notifyListeners();
    generateNewWallet(_seed, password: _password).then((newWallet) {
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

      // Persist password
      await _storage.write(
        key: STORAGE_PASSWORD_KEY,
        value: password,
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

  Future<String> readPasswordFromDisk() async {
    // TODO: Read metadata

    // Read seed
    return _storage.read(key: STORAGE_PASSWORD_KEY);
  }

  Future<Keys> readKeysFromDisk() async {
    // TODO: Read metadata

    // Read seed
    _seed = await readSeedFromDisk();
    _password = await readPasswordFromDisk();

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

    return Keys(seed, password, rootKey, childKeys, network: network);
  }
}
