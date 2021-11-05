import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

import 'package:vase/constants.dart';
import 'package:vase/components/calculator_keyboard/keyboard.dart';
import '../viewmodel.dart';
import 'component/payment_amount_display.dart';
import 'component/balance_display.dart';

class ReceiveTab extends StatelessWidget {
  final ValueNotifier<CalculatorData> keyboardNotifier;

  ReceiveTab({Key? key})
      : keyboardNotifier = ValueNotifier<CalculatorData>(
            CalculatorData(amount: 0, function: '')),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WalletModel>(context);
    if (viewModel.wallet == null) {
      return Container();
    }
    final balanceNotifier = viewModel.balance;

    final keys = viewModel.wallet!.keys.keys!.sublist(0);
    keys.shuffle();

    final keyInfo = keys.firstWhere((keyInfo) =>
        keyInfo.isChange == false && keyInfo.isDeprecated == false);
    final strAddress = keyInfo.address!.toXAddress();
    final _controller = TextEditingController(text: strAddress);

    final createAddressUri = (CalculatorData data) {
      if (data.amount == 0) {
        return strAddress;
      }
      // Can't mutate the URI, so need a way to add query strings.
      final parsedAddress = Uri.parse(strAddress);
      return Uri(
          scheme: parsedAddress.scheme,
          path: parsedAddress.path,
          queryParameters: {'amount': data.amount.toString()}).toString();
    };

    keyboardNotifier.addListener(() {
      _controller.text = createAddressUri(keyboardNotifier.value);
    });

    final manualCard = ValueListenableBuilder(
        valueListenable: keyboardNotifier,
        builder: (context, CalculatorData balance, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Container(
                    height: 60.0,
                    child: OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: createAddressUri(balance),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          copiedAd,
                        );
                      },
                      child: Icon(Icons.copy),
                    ),
                  ),
                ),
              ],
            ));

    final qrCard = ValueListenableBuilder(
        valueListenable: keyboardNotifier,
        builder: (context, CalculatorData balance, child) => QrImage(
              data: createAddressUri(balance),
              version: QrVersions.auto,
            ));

    final calculatorKeyboard =
        CalculatorKeyboard(dataNotifier: keyboardNotifier, initialValue: '');
    // Confirm Amount button widget writes to global SendModel
    // and then switches to Slide to send button:

    return SafeArea(
        child: Padding(
      padding: stdPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BalanceDisplay(balanceNotifier: balanceNotifier),
          Text(
            'Receive Funds',
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(child: qrCard),
          manualCard,
          ValueListenableBuilder(
              valueListenable: keyboardNotifier,
              builder: (context, CalculatorData balance, child) =>
                  PaymentAmountDisplay(
                      amount: balance.amount, function: balance.function)),
          calculatorKeyboard,
        ],
      ),
    ));
  }
}
