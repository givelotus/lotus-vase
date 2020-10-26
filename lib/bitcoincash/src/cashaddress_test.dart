import 'package:test/test.dart';

import 'cashaddress.dart';
import 'address.dart';

void main() {
  test('can decode and encode to base58', () async {
    final cashaddr = 'bitcoincash:qqeht8vnwag20yv8dvtcrd4ujx09fwxwsqqqw93w88';
    final legacy = '15h6MrWynwLTwhhYWNjw1RqCrhvKv3ZBsi';
    var address = Decode(cashaddr, 'bitcoincash');

    expect(
        Address.fromAddressBytes(address.addressBytes,
                networkType: address.networkType,
                addressType: address.addressType)
            .toBase58(),
        legacy);
  });
}
