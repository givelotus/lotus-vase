import 'package:cashew/bitcoincash/address.dart';

class ParseURIResult {
  String address;
  int amount;

  ParseURIResult({this.address, this.amount});
}

ParseURIResult parseSendURI(String uri) {
  final parseObject = Uri.parse(uri);
  final unparsedAmount = parseObject.queryParameters['amount'];
  final amount = unparsedAmount == null
      ? double.nan
      : double.parse(unparsedAmount, (value) => double.nan);

  Address(parseObject.path);

  if (amount.isNaN) {
    return ParseURIResult(address: parseObject.path ?? '', amount: null);
  }

  int intAmount;
  if (amount.truncateToDouble() != amount) {
    intAmount = (amount * 100000000).truncate();
  } else {
    intAmount = amount.truncate();
  }

  return ParseURIResult(address: parseObject.path ?? '', amount: intAmount);
}
