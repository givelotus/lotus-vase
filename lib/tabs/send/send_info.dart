import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:cashew/tabs/send/custom_keyboard/calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'sendModel.dart';
import '../../wallet/wallet.dart';
import '../../viewmodel.dart';
import '../../bitcoincash/address.dart';
import '../../bitcoincash/transaction/transaction.dart';
import '../../constants.dart';
import 'custom_keyboard/custom_keyboard.dart';

// TODO: This needs to be done. I've replicated in a seperate folder
// depending on how complex I think it might get, just ignore for now.
List<String> canSend(int amount, String address, int balance) {
  final errors = <String>[];

  if (amount < 0) {
    errors.add('Amount cannot be less than 0');
  }

  if (amount == 0) {
    errors.add('Amount cannot be 0');
  }

  if (amount > balance) {
    errors.add('Insufficient balance');
  }

  try {
    Address(address);
  } catch (err) {
    errors.add('Invalid address');
  }

  return errors;
}

// TODO: Add check amount is > 0 and < amount of sats in wallet.

Future showReceipt(BuildContext context, Transaction transaction) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Transaction sent'),
          content: Text(transaction.id),
        );
      });
}

Future showError(BuildContext context, String errMessage) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(errMessage),
        );
      });
}

class SendInfo extends StatelessWidget {
  final ValueNotifier<bool> visible;
  final Wallet wallet;
  final ValueListenable<List<String>> paymentStackNotifier;

  SendInfo({this.visible, @required this.wallet})
      : paymentStackNotifier = ValueNotifier<List<String>>([]);

  void sendTransaction(BuildContext context, String address, int amount) {
    wallet
        .sendTransaction(Address(address), BigInt.from(amount))
        .then((transaction) => showReceipt(context, transaction))
        .catchError((error) => showError(context, error.toString()));

    visible.value = false;
  }

  @override
  Widget build(context) {
    final walletModel = Provider.of<WalletModel>(context, listen: false);
    final balanceNotifier = walletModel.balance;
    paymentStackNotifier.addListener(() {
      final sendModel = Provider.of<SendModel>(context, listen: false);
      final evaluatedStack = paymentStackNotifier.value.sublist(0);
      evaluateExpression(evaluatedStack);
      final takenNumbers = takeNumbers(evaluatedStack.reversed.toList());
      final amount = takenNumbers.truncate();
      sendModel.sendAmount = amount;
    });

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Consumer<SendModel>(
          builder: (context, viewModel, child) => TextButton(
            onPressed: () {
              visible.value = false;
              viewModel.sendAmount = null;
              viewModel.sendToAddress = null;
            },
            child: Text('Cancel'),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AddressDisplay(),
            Consumer<SendModel>(builder: (context, viewModel, child) {
              final text = paymentStackNotifier.value.join('');
              return PaymentAmountDisplay(
                  amount: (viewModel.sendAmount ?? 0).toString(),
                  function: text);
            }),
            BalanceDisplay(balanceNotifier: balanceNotifier),
            CalculatorKeyboard(stackNotifier: paymentStackNotifier),
            // Confirm Amount button widget writes to global SendModel
            // and then switches to Slide to send button:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(child:
                      Consumer<SendModel>(builder: (context, viewModel, child) {
                    final errors = canSend(
                        viewModel.sendAmount ?? 0,
                        viewModel.sendToAddress,
                        walletModel.balance.value ?? 0);
                    return Column(
                        children: [
                      [
                        Row(children: [
                          Expanded(
                              child: ElevatedButton(
                            autofocus: true,
                            onPressed: errors.isEmpty
                                ? () {
                                    sendTransaction(
                                        context,
                                        viewModel.sendToAddress,
                                        viewModel.sendAmount);
                                  }
                                : null,
                            child: Text('Send'),
                          )),
                        ]),
                      ],
                      errors.map((errorText) =>
                          Row(children: [Expanded(child: Text(errorText))]))
                    ].expand((row) => row).toList());
                  }))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressDisplay extends StatelessWidget {
  @override
  Widget build(context) {
    return Padding(
      padding: stdPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<SendModel>(builder: (context, viewModel, child) {
            return GestureDetector(
                onTap: () async {
                  try {
                    final data = await Clipboard.getData('text/plain');
                    final parseObject = Uri.parse(data.text.toString());
                    final unparsedAmount =
                        parseObject.queryParameters['amount'];
                    final amount = unparsedAmount == null
                        ? double.nan
                        : double.parse(unparsedAmount, (value) => double.nan);

                    Address(parseObject.path);
                    // Use the unparsed version, so that it appears as it was originally copied
                    viewModel.sendToAddress = parseObject.path ?? '';
                    viewModel.sendAmount = amount.isNaN
                        ? viewModel.sendAmount
                        : (amount * 100000000).truncate();
                  } catch (err) {
                    await showError(context, 'Invalid clipboard data');
                    // Invalid address
                  }
                },
                child: Column(
                  children: [
                    Text(
                      'Tap to Paste Address',
                      style: TextStyle(
                          color: Colors.red.withOpacity(.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    RichText(
                      text: TextSpan(
                        text: viewModel.sendToAddress,
                        style: TextStyle(
                            color: Colors.black.withOpacity(.8), fontSize: 15),
                      ),
                    )
                  ],
                ));
          }),
        ],
      ),
    );
  }
}

class PaymentAmountDisplay extends StatelessWidget {
  final String amount;
  final String function;
  PaymentAmountDisplay({Key key, this.amount, this.function})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            '${function}',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ]),
        Text(
          '${amount} sats',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}

class BalanceDisplay extends StatelessWidget {
  final ValueNotifier<int> balanceNotifier;
  BalanceDisplay({@required this.balanceNotifier});

  @override
  Widget build(BuildContext context) {
    // Balance Display widget
    return Padding(
      padding: const EdgeInsets.fromLTRB(60.0, 0, 60.0, 30.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          color: Colors.grey[400].withOpacity(0.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                  valueListenable: balanceNotifier,
                  builder: (context, balance, child) {
                    if (balance == null) {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                            color: Colors.red.withOpacity(.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      );
                    }
                    return Text.rich(TextSpan(
                      text: 'Balance: ${balance}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: ' sats',
                          style: TextStyle(
                              color: Colors.black.withOpacity(.8),
                              fontSize: 15),
                        ),
                      ],
                    ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorKeyboard extends StatelessWidget {
  final ValueNotifier<List<String>> stackNotifier;
  final List<String> stack;

  CalculatorKeyboard({Key key, @required this.stackNotifier})
      : stack = stackNotifier.value,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final updateStack = () {
      // This will be mutated, that's why we need to update the value.
      stackNotifier.value = stack.sublist(0);
    };

    return Container(
        child: Column(
      children: [
        Column(
          children:
              CalculatorRows.map((List<CalculatorItem> calculatorRowButtons) {
            return Row(
              children: calculatorRowButtons.map((CalculatorItem item) {
                return CalculatorButton(
                  button: item,
                  stack: stack,
                  onPressed: updateStack,
                );
              }).toList(),
            );
          }).toList(),
        )
      ],
    ));
  }
}
