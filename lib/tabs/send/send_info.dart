import 'dart:async';

import 'package:vase/lotus/lotus.dart';
import 'package:vase/lotus/utils/parse_uri.dart';
import 'package:vase/components/calculator_keyboard/keyboard.dart';
import 'package:vase/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'sendModel.dart';
import '../../viewmodel.dart';
import '../../lotus/address.dart';
import '../../lotus/transaction/transaction.dart';
import '../component/payment_amount_display.dart';
import '../component/balance_display.dart';

const MIN_SATS = 1024;

List<String> canSend(int amount, String address, int balance) {
  final errors = <String>[];

  if (amount < MIN_SATS) {
    errors.add('Minimum send amount is $MIN_SATS satoshi');
  }

  if (amount > balance) {
    errors.add('Wallet balance too low');
  }

  try {
    Address(address);
  } catch (err) {
    errors.add('Invalid address');
  }

  return errors;
}

Future showReceipt(BuildContext context, Transaction? transaction) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Transaction sent'),
          content: Text(transaction!.id!),
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

class SendInfo extends StatefulWidget {
  SendInfo({Key? key});

  @override
  State<SendInfo> createState() => _SendInfoState();
}

class _SendInfoState extends State<SendInfo> {
  var submitted = false;
  var errors = [];

  @override
  Widget build(context) {
    final walletModel = Provider.of<WalletModel>(context, listen: false);
    final balanceNotifier = walletModel.balance;
    final sendModel = Provider.of<SendModel>(context, listen: false);
    final keyboardNotifier =
        ValueNotifier<CalculatorData>(CalculatorData(amount: 0, function: ''));

    keyboardNotifier.addListener(() {
      sendModel.sendAmount = keyboardNotifier.value.amount;
      errors = [];
    });

    void sendTransaction(BuildContext context, String address, int amount) {
      walletModel.wallet!
          .sendTransaction(Address(address), BigInt.from(amount))
          .then((transaction) {
            sendModel.sendAmount = null;
            sendModel.sendToAddress = null;
            return showReceipt(context, transaction);
          })
          .catchError((error) => showError(context, error.toString()))
          .then((_) => Navigator.pop(context));
    }

    final pasteAddress = () async {
      // TODO: Dedupe this with QR Scanning.
      try {
        final data = await (Clipboard.getData('text/plain'));
        final parseResult = parseSendURI(data?.text?.toString().trim() ?? '');

        // Use the unparsed version, so that it appears as it was originally copied
        sendModel.sendToAddress = parseResult.address ?? '';
        sendModel.sendAmount = parseResult.amount ?? 0;

        keyboardNotifier.value = CalculatorData(
            amount: sendModel.sendAmount,
            function: sendModel.sendAmount == 0
                ? ''
                : sendModel.sendAmount.toString());
      } catch (err) {
        await showError(context, 'Invalid clipboard data');
        // Invalid address
      }
    };

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Consumer<SendModel>(
          builder: (context, viewModel, child) => TextButton(
            onPressed: () {
              viewModel.sendAmount = null;
              viewModel.sendToAddress = null;
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ),
      ),
      body: Padding(
        padding: stdPadding,
        child: SafeArea(
          child: Consumer<SendModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (errors.isNotEmpty)
                    Text(
                      'Not able to send:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15),
                    ),
                  for (final error in errors)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: error,
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  BalanceDisplay(balanceNotifier: balanceNotifier),
                  AddressDisplay(onTap: pasteAddress),
                  PaymentAmountDisplay(
                      amount: viewModel.sendAmount ?? 0,
                      function: keyboardNotifier.value.function ?? ''),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          autofocus: true,
                          onPressed: errors.isEmpty
                              ? () {
                                  final errs = canSend(
                                      viewModel.sendAmount ?? 0,
                                      viewModel.sendToAddress ?? '',
                                      walletModel.balance.value!.balance ?? 0);

                                  setState(() {
                                    errors = errs;
                                  });

                                  if (errs.isEmpty) {
                                    sendTransaction(
                                        context,
                                        viewModel.sendToAddress!,
                                        viewModel.sendAmount!);
                                  }
                                }
                              : null,
                          child: Text('Send'),
                        ),
                      ),
                    ],
                  ),
                  if (child != null) child
                ],
              );
            },
            child: CalculatorKeyboard(
              dataNotifier: keyboardNotifier,
              initialValue: '${sendModel.sendAmount ?? ''}',
            ),
          ),
        ),
      ),
    );
  }
}

String clipString(String data) {
  return '${data.substring(0, 6)}...${data.substring(data.length - 6, data.length)}';
}

class AddressDisplay extends StatelessWidget {
  final void Function()? onTap;

  AddressDisplay({this.onTap}) : super();

  @override
  Widget build(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Consumer<SendModel>(
          builder: (context, viewModel, child) => GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Row(children: [
                    Text('Send To Address:',
                        style: Theme.of(context).textTheme.caption),
                    Icon(
                      Icons.paste,
                    )
                  ]),
                  RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: viewModel.sendToAddress != null &&
                                viewModel.sendToAddress!.isNotEmpty
                            ? clipString(viewModel.sendToAddress!)
                            : 'Tap to Paste Address',
                        // TODO: This is waaay too small. We need to split the
                        // address up over multiple lines.
                        style: Theme.of(context).textTheme.headline6,
                      )),
                ],
              )))
    ]);
  }
}
