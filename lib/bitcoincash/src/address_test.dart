import 'package:test/test.dart';
import 'package:hex/hex.dart';

import 'address.dart';

void main() {
  test('can decode and encode an address', () async {
    final bitcoinABCAddress = '15h6MrWynwLTwhhYWNjw1RqCrhvKv3ZBsi';
    var address = Address(bitcoinABCAddress);
    expect(address.toBase58(), bitcoinABCAddress);
  });

  test('raw address construction works', () async {
    final legacyAddress = '15h6MrWynwLTwhhYWNjw1RqCrhvKv3ZBsi';
    var address = Address(legacyAddress);

    var decodedAddress = Address.fromAddressBytes(HEX.decode(address.toHex()),
        addressType: address.addressType, networkType: address.networkType);

    expect(address.toBase58(), decodedAddress.toBase58());

    expect(address.toBase58(), legacyAddress);
  });

  test('can decode from cashaddress and encode to base58', () async {
    final cashaddr = 'bitcoincash:qqeht8vnwag20yv8dvtcrd4ujx09fwxwsqqqw93w88';
    final legacy = '15h6MrWynwLTwhhYWNjw1RqCrhvKv3ZBsi';
    var address = Address(cashaddr);

    expect(address.toBase58(), legacy);
  });

  test('can decode from base58 and encode to cashaddress', () async {
    final cashaddr = 'bitcoincash:qqeht8vnwag20yv8dvtcrd4ujx09fwxwsqqqw93w88';
    final legacy = '15h6MrWynwLTwhhYWNjw1RqCrhvKv3ZBsi';
    var address = Address(legacy);

    expect(address.toCashAddress(), cashaddr);
  });
}
