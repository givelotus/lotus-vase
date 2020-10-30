import 'constants.dart';
import 'electrum/client.dart';

class Wallet {
  Wallet(String walletPath);

  int _balance;
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
