import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:test/test.dart';

void main() {
  test('PrivateKey Generation', () {
    final secrets = [
      BigInt.from(5000),
      BigInt.from(2018).pow(5),
      BigInt.parse('deadbeef12345', radix: 16),
    ];

    final privateHex = [
      '0000000000000000000000000000000000000000000000000000000000001388',
      '0000000000000000000000000000000000000000000000000076e54a40efb620',
      '000000000000000000000000000000000000000000000000000deadbeef12345',
    ];

    final base58MainAddress = [
      '15A8MkDwDQg7BnD6iqMFeeSAM3VVu1kYZb',
      '1EWULdL4BCdAd2hvH7Daf48uEUWKPNo9KR',
      '1GcHiDpV4u62uk2tz6Li8mLe6mMzmt4KV6',
    ];
    final base58TestAddress = [
      'mjg5eoJv2S7MxtgiSQKdUZeVD36CipN3SW',
      'mu2RdgR2zE4RQ9BXzgBxUyME6U72HYu113',
      'mw8F1GuTsvXHgrWWhfK5xgYxxkxhfvkKyd',
    ];

    for (var i = 0; i < secrets.length; i++) {
      final pk = BCHPrivateKey.fromBigInt(secrets[i]);

      expect(
        pk.toHex(),
        equals(privateHex[i]),
      );
      expect(
        pk.toAddress(networkType: NetworkType.MAIN).toBase58(),
        equals(base58MainAddress[i]),
      );
      expect(
        pk.toAddress(networkType: NetworkType.TEST).toBase58(),
        equals(base58TestAddress[i]),
      );
    }
  });

  test('PrivateKey WIF', () {
    // Secret, Expected
    final arguments = [
      [
        BigInt.two.pow(256) - BigInt.two.pow(199),
        'L5oLkpV3aqBJ4BgssVAsax1iRa77G5CVYnv9adQ6Z87te7TyUdSC'
      ],
      [
        BigInt.two.pow(256) - BigInt.two.pow(201),
        'L5oLkpV3aq9y7UdETcvtFSSNP8fyyLreCCb9miWkCJp7bLU2TxEC'
      ],
      [
        BigInt.parse(
          '0dba685b4511dbd3d368e5c4358a1277de9486447af7b3604a69b8d9d8b7889d',
          radix: 16,
        ),
        'KwgPxV49aFG6K72E95uu5kKvJch9226e9yzAyrw59mcpyszqaNkk'
      ],
      [
        BigInt.parse(
          '1cca23de92fd1862fb5b76e5f4f50eb082165e5191e116c18ed1a6b24be6a53f',
          radix: 16,
        ),
        'KxBg3zhNPXg5qs3LfCHB6YPndGf4PiB1QHYTyEgXsGNQKSmuxZgE'
      ],
    ];

    for (final arg in arguments) {
      final pk = BCHPrivateKey.fromBigInt(
        arg[0],
      );

      expect(
        pk.toWIF(),
        equals(arg[1]),
      );
    }
  });
}
