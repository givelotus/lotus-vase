import 'package:intl/intl.dart';

const satsPerLotus = 1000000;
final lotusPerSat = BigInt.from(1) / BigInt.from(satsPerLotus);

final NumberFormat _formatter = NumberFormat()
  ..minimumFractionDigits = 0
  ..maximumFractionDigits = 8;

String formatAmount(BigInt amount) {
  return '${_formatter.format(amount.toInt() * lotusPerSat)} XPI';
}

BigInt lotusToSats(String amount) {
  final parsed = double.tryParse(amount) ?? 0;
  return BigInt.from((parsed * satsPerLotus).truncate());
}
