import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

const satsPerLotus = 1000000;
final lotusPerSat = BigInt.from(1) / BigInt.from(satsPerLotus);

final NumberFormat _formatter = NumberFormat()..maximumFractionDigits = 8;

String formatAmount(BigInt amount) {
  _formatter.minimumFractionDigits = 0;
  return '${_formatter.format(amount.toInt() * lotusPerSat)} XPI';
}

BigInt lotusToSats(String amount) {
  final parsed = double.tryParse(amount) ?? 0;
  return BigInt.from((parsed * satsPerLotus).truncate());
}

List<String> formatNumpadInput(UnmodifiableListView<String> items) {
  final suffix = items.last == '.' ? '.' : '';
  final fractions = items.length - items.indexOf('.');
  final fractionDigits =
      fractions > 0 && fractions < items.length ? fractions - 1 : 0;
  _formatter.minimumFractionDigits = fractionDigits;
  return (_formatter.format(double.tryParse(items.join()) ?? 0) + suffix)
      .split('');
}
