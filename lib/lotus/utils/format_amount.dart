String formatAmount(dynamic amount) {
  if (amount is String) {
    return amount;
  }
  if (amount < 1000000) {
    return '$amount sats';
  }
  return '${amount / 1000000} XPI';
}
