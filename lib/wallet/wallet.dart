import 'keys.dart';
import '../electrum/client.dart';

class Wallet {
  Wallet(this.walletPath, this.electrumFactory);

  String walletPath;

  int _balance = 0;
  ElectrumFactory electrumFactory;
  Keys keys;
  String bip39Seed;

  Future<void> refreshBalance() async {
    final client = await electrumFactory.build();
    const exampleScriptHash =
        '8b01df4e368ea28f8dc0423bcf7a4923e3a12d307c875e47a0cfbf90b5c39161';
    final response =
        await client.blockchainScripthashGetBalance(exampleScriptHash);

    final totalBalance = response.confirmed + response.unconfirmed;
    _balance = totalBalance;
  }

  /// Read wallet file from disk. Returns true if successful.
  Future<bool> loadFromDisk() async {
    // TODO
    return false;
  }

  Future<void> writeToDisk() async {
    // TODO
  }

  /// Generate new random seed.
  String newSeed() {
    // TODO: Randomize and can we move to bytes
    // rather than string (crypto API awkard)?
    String bip39Seed =
        'witch collapse practice feed shame open despair creek road again ice least';
    return bip39Seed;
  }

  /// Generate new wallet from scratch.
  Future<void> generateWallet() async {
    final seed = newSeed();
    keys = await Keys.construct(seed);
  }

  /// Attempts to load wallet from disk, else constructs a new wallet.
  Future<bool> initialize() async {
    final loaded = await loadFromDisk();
    if (!loaded) {
      await generateWallet();
    }
    try {
      await refreshBalance();
      return true;
    } catch (err) {
      return false;
    }
  }

  int balanceSatoshis() {
    return _balance;
  }

  void send(String address, int satoshis) {
    // TODO
  }
}
