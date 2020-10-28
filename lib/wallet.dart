import 'bitcoincash/bitcoincash.dart';
import 'constants.dart';
import 'electrum/rpc.dart';

class Wallet {
  Wallet(String walletPath);

  int _balance;
  String bip39Seed =
      'witch collapse practice feed shame open despair creek road again ice least';
  List<BCHPrivateKey> externalKeys;
  List<BCHPrivateKey> changeKeys;
  ElectrumClient client = ElectrumClient();

  Future<void> refreshWallet() async {
    const exampleScriptHash =
        '8b01df4e368ea28f8dc0423bcf7a4923e3a12d307c875e47a0cfbf90b5c39161';
    final response =
        await client.blockchainScripthashGetBalance(exampleScriptHash);

    final totalBalance = response.confirmed + response.unconfirmed;
    _balance = totalBalance;
  }

  Future<void> initWallet() async {
    // TODO: Load from disk or generate
    final seed = Mnemonic().toSeedHex(bip39Seed);

    final rootKey = HDPrivateKey.fromSeed(seed, bitcoinNetwork);

    // TODO: Do this with child numbers
    final parentKey = rootKey.deriveChildKey("m/44'/145'");
    final parentExternalKey = parentKey.deriveChildNumber(0);
    externalKeys = List<BCHPrivateKey>.generate(
        32, (index) => parentExternalKey.deriveChildNumber(index).privateKey);
    final parentChangeKey = parentKey.deriveChildKey("1'");
    changeKeys = List<BCHPrivateKey>.generate(
        32, (index) => parentExternalKey.deriveChildNumber(index).privateKey);
    await client.connect(Uri.parse(electrumUrl));
    await refreshWallet();
  }

  int balanceSatoshis() {
    return _balance;
  }

  String getAddress() {
    return 'bchtest:dsajkdsaadfghfgfhhggjkhgjhjghjbhjk';
  }

  void send(String address, int satoshis) {
    // TODO
  }
}
