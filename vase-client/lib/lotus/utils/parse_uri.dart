import 'package:vase/lotus/address.dart';

class ParseURIResult {
  String address;
  BigInt amount;

  ParseURIResult({required this.address, required this.amount});
}

ParseURIResult parseSendURI(String uri) {
  final parseObject = Uri.parse(uri);
  final unparsedAmount = parseObject.queryParameters['amount'];
  final amount = unparsedAmount == null
      ? BigInt.zero
      : BigInt.tryParse(unparsedAmount) ?? BigInt.zero;

  var address = parseObject.path;

  try {
    Address(address);
  } catch (e) {
    address = '';
  }

  return ParseURIResult(address: address, amount: amount);
}
