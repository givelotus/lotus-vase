import '../../../wallet/wallet.dart';

String _validateAddress(String address) {
// TODO: if present, try checking scheme is 'bitcoincash' or throw error
// (scheme should be optional)
// check address conforms to Address class or throw error
// check amount function (>0, less than total in wallet)

  // Address(tryParse(data)['address']);
  // Address(address);
}

// TODO: Add check amount is > 0 and < amount of sats in wallet.
String _validateSendAmount(int amount, Wallet wallet) {
  if (amount == 0) {
    return 'Amount cannot be 0';
  }
  if (amount > wallet.balanceSatoshis()) {
    return 'Amount cannot be more than wallet balance';
  }
}
