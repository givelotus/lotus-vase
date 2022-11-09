import 'package:vase/electrum/client.dart';
import 'package:vase/lotus/lotus.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/digests/sha256.dart';

String toElectrumScriptHash(String address) {
  final p2pkhBuilder = P2PKHLockBuilder(Address(address));
  final script = p2pkhBuilder.getScriptPubkey();
  final scriptHash = SHA256Digest().process(script.buffer).toList();
  return HEX.encode(scriptHash.reversed.toList());
}

const bitcoinABCAddress =
    'bitcoincash:qqeht8vnwag20yv8dvtcrd4ujx09fwxwsqqqw93w88';

void main() async {
  final electrumClient = ElectrumClient();
  await electrumClient.connect(Uri.parse('ws://51.79.81.158:50003'));

  List<Object> unspent = await electrumClient
      .blockchainScripthashListunspent(toElectrumScriptHash(bitcoinABCAddress));
  print(unspent[0]);

  final res = await electrumClient.blockchainScripthashSubscribe(
      toElectrumScriptHash(bitcoinABCAddress), (params) {
    print(params.toString());
  });
  print(res.toString());

// Wait 120 seconds before quitting.
  await Future.delayed(Duration(seconds: 120));

  electrumClient.dispose();
}
