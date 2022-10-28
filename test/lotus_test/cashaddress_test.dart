import 'package:test/test.dart';
import 'package:vase/lotus/address.dart';
import 'package:vase/lotus/cashaddress.dart';

void main() {
  test('can decode and encode to base58', () async {
    const cashaddr = 'bitcoincash:qqeht8vnwag20yv8dvtcrd4ujx09fwxwsqqqw93w88';
    const legacy = '15h6MrWynwLTwhhYWNjw1RqCrhvKv3ZBsi';
    var address = Decode(cashaddr, 'bitcoincash');
    expect(
        Address.fromAddressBytes(address.addressBytes!,
                networkType: address.networkType,
                addressType: address.addressType)
            .toBase58(),
        legacy);
  });

  test('can decode and encode cashaddresses', () async {
    const cashaddr = 'bitcoincash:qqeht8vnwag20yv8dvtcrd4ujx09fwxwsqqqw93w88';
    var address = Decode(cashaddr, 'bitcoincash');
    var encodedCashaddr = Encode(address);

    expect(encodedCashaddr, cashaddr);
  });
}
