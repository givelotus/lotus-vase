const satsPerLotus = 1000000;
final lotusPerSat = BigInt.from(1) / BigInt.from(satsPerLotus);

String formatAmount(BigInt amount) {
  return '${amount.toInt() * lotusPerSat} XPI';
}

BigInt lotusToSats(String amount) {
  final parsed = double.tryParse(amount) ?? 0;
  return BigInt.from((parsed * satsPerLotus).truncate());
}
