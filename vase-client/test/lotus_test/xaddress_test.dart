import 'package:test/test.dart';
import 'dart:math';

import 'package:vase/lotus/xaddress.dart';
import 'package:vase/lotus/networks.dart';

void main() {
  test('can decode and encode XAddresses', () {
    var random = Random.secure();
    var values = List<int>.generate(20, (i) => random.nextInt(256));
    final xaddress = XAddress(
        network: NetworkType.MAIN,
        type: XAddressType.ScriptPubKey,
        payload: values);
    final decodedXaddress = XAddress.Decode(xaddress.Encode());
    expect(xaddress.prefix, decodedXaddress.prefix);
    expect(xaddress.network, decodedXaddress.network);
    expect(xaddress.type, decodedXaddress.type);
    expect(xaddress.payload, decodedXaddress.payload);
  });
}
