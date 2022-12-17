import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

const satsPerLotus = 1000000;
final lotusPerSat = BigInt.from(1) / BigInt.from(satsPerLotus);

final NumberFormat _formatter = NumberFormat();

String formatAmount({
  required BigInt amount,
  minimumFractionDigits = 0,
  maximumFractionDigits = 8,
}) {
  _formatter.minimumFractionDigits = minimumFractionDigits;
  _formatter.maximumFractionDigits = maximumFractionDigits;
  return '${_formatter.format(amount.toInt() * lotusPerSat)} XPI';
}

BigInt lotusToSats(String amount) {
  final parsed = double.tryParse(amount) ?? 0;
  return BigInt.from((parsed * satsPerLotus).truncate());
}

String satsToLotus(BigInt amount) {
  final NumberFormat formatter = NumberFormat.decimalPattern("en_US")
    ..turnOffGrouping()
    ..minimumFractionDigits = 0
    ..maximumFractionDigits = 8;
  return formatter.format(amount.toInt() * lotusPerSat);
}

List<String> formatNumpadInput(UnmodifiableListView<String> items) {
  final suffix = items.last == '.' ? '.' : '';
  final fractions = items.length - items.indexOf('.');
  final fractionDigits =
      fractions > 0 && fractions < items.length ? fractions - 1 : 0;
  _formatter.minimumFractionDigits = fractionDigits;
  _formatter.maximumFractionDigits = 8;
  return (_formatter.format(double.tryParse(items.join()) ?? 0) + suffix)
      .split('');
}
