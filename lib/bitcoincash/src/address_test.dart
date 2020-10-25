import 'package:test/test.dart';

import 'address.dart';

void main() {
  test('can decode and encode an address', () async {
    final bitcoinABCAddress = '15h6MrWynwLTwhhYWNjw1RqCrhvKv3ZBsi';
    var address = Address(bitcoinABCAddress);
    expect(address.toBase58(), bitcoinABCAddress);
  });
}
