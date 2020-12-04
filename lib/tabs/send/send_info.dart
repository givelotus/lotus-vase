import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'sendModel.dart';
import '../../wallet/wallet.dart';
import '../../viewmodel.dart';
import '../../bitcoincash/address.dart';
import '../../bitcoincash/transaction/transaction.dart';
import '../../constants.dart';
import 'custom_keyboard/custom_keyboard.dart';

Future showReceipt(BuildContext context, Transaction transaction) {
  // TODO: Create nice looking receipt dialog.
  print(transaction);

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
  // TODO: Create nice looking receipt dialog.
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error sending...'),
          content: Text(errMessage),
        );
      });
}

class SendInfo extends StatelessWidget {
  final ValueNotifier<bool> visible;
  final Wallet wallet;

  SendInfo({this.visible, @required this.wallet});

  Future<void> sendButtonClicked(
      BuildContext context, String address, int amount) async {
    final addressNotBlank = (address != null);
    final primaryValidation = (amount != null && amount > 0);
    // TODO: Need additional validation checks -- not spending sats
    // you don't have
    if (!primaryValidation || !addressNotBlank) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Get your facts right!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Or I\'ll bankrupt you.'),
                  Text('Consider yourself warned...!'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('um.. OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      ;
    }

    // TODO: Need address validation here. Should attach to entry field
    // somehow to indicate the address is bad.

 await wallet
        .sendTransaction(Address(address), BigInt.from(amount))
        .then((transaction) => showReceipt(context, transaction))
        .catchError((error) => showError(context, error.toString()));


    try {
      wallet
          .sendTransaction(Address(address), BigInt.from(amount))
          .then((transaction) => showReceipt(context, transaction));
    } on AddressFormatException {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Fix address please!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Or I\'ll bankrupt you.'),
                  Text('Consider yourself warned...!'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('um.. OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    // only close SendInfo screen in case transaction is successful
    visible.value = false;
  }

  @override
  Widget build(context) {
    var screenDimension = MediaQuery.of(context).size;
    final balanceNotifier =
        Provider.of<WalletModel>(context, listen: false).balance;
    final viewModel = Provider.of<SendModel>(context, listen: false);
    // final addressController =
    //     TextEditingController(text: viewModel.sendToAddress);

    // addressController.addListener(() {
    //   viewModel.sendToAddress = addressController.text;
    // });

    final amountController = TextEditingController(
        text: viewModel.sendAmount == null
            ? ''
            : viewModel.sendAmount.toString());

    amountController.addListener(() {
      viewModel.sendAmount = int.tryParse(amountController.text);
    });

// TODO: rework this so that the filler is checked properly before putting up QR
    final qrSendToAddress = ClipOval(
        child: Consumer<SendModel>(
      builder: (context, viewModel, child) => QrImage(
        size: 90,
        data: viewModel.sendToAddress ?? 'filler',
        version: QrVersions.auto,
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Send'),
        actions: [],
      ),
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: stdPadding,
              child: Row(
                children: [
                  Consumer<SendModel>(builder: (context, viewModel, child) {
                    return GestureDetector(
                      onTap: () async {
                        ClipboardData data =
                            await Clipboard.getData('text/plain');

                        // TODO: Need to throw errors here
                        Map tryParse(data) {
                          var parseObject = Uri.parse(data.text.toString());
                          var map = {
                            'address': parseObject.path,
                            'amount': (double.parse(
                                        parseObject.queryParameters['amount']) *
                                    100000000)
                                .round(),
                            'scheme': parseObject.scheme
                          };

                          // if present, try checking scheme is 'bitcoincash' or throw error
                          // (scheme should be optional)
                          // check address conforms to Address class or throw error
                          // check amount function (>0, less than total in wallet)

                          print(map);

                          return map;
                        }

                        Address(tryParse(data)['address']);

                        viewModel.sendToAddress = tryParse(data)['address'];
                        viewModel.sendAmount = tryParse(data)['amount'];
                        print(viewModel.sendToAddress);
                        print(viewModel.sendAmount);
                      },
                      child: viewModel.sendToAddress == null
                          ? Column(
                              children: [
                                qrSendToAddress,
                                Container(
                                  child: Text(
                                    'Tap to Paste Address',
                                    style: TextStyle(
                                        color: Colors.red.withOpacity(.8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                qrSendToAddress,
                                Container(
                                    width: screenDimension.width - 30,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'bch:',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(.8),
                                            fontSize: 15),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: viewModel.sendToAddress,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(.8),
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                    );
                  }),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: () {},
            //   child: Row(children: [PaymentAmountDisplay(value: '0 sats')]),
            // ),
            // Card(
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: ListTile(
            //           title: const Text('Balance'),
            //           subtitle: const Text('in satoshis'),
            //         ),
            //       ),
            //       Expanded(
            //         child: ValueListenableBuilder(
            //             valueListenable: balanceNotifier,
            //             builder: (context, balance, child) {
            //               if (balance == null) {
            //                 return Text(
            //                   'Loading...',
            //                   style: TextStyle(
            //                       color: Colors.red.withOpacity(.8),
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 13),
            //                 );
            //               }
            //               return Text.rich(TextSpan(
            //                 text: '${balance}',
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 17,
            //                 ),
            //                 children: [
            //                   TextSpan(
            //                     text: ' sats',
            //                     style: TextStyle(
            //                         color: Colors.white.withOpacity(.8),
            //                         fontSize: 15),
            //                   ),
            //                 ],
            //               ));
            //             }),
            //       ),
            //     ],
            //   ),
            // ),
            Row(
              children: [
                Expanded(
                  child: Consumer<SendModel>(
                    builder: (context, viewModel, child) => ElevatedButton(
                      // TODO: we should probably have ValueNotifiable props
                      // specifically for this component
                      // Rather than wiring directly to the global viewmodel
                      onPressed: () {
                        visible.value = false;
                        viewModel.sendAmount = null;
                        viewModel.sendToAddress = null;
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<SendModel>(
                    builder: (context, viewModel, child) => ElevatedButton(
                      autofocus: true,
                      // TODO: we should probably have ValueNotifiable props
                      // specifically for this component
                      // Rather than wiring directly to the global viewmodel
                      onPressed: () {
                        sendButtonClicked(
                          context,
                          viewModel.sendToAddress,
                          viewModel.sendAmount,
                        );
                        viewModel.sendAmount = null;
                        viewModel.sendToAddress = null;
                      },
                      child: Text('Send'),
                    ),
                  ),
                )
              ],
            ),
            Consumer<SendModel>(
                builder: (context, viewModel, child) =>
                    CalculatorKeyboard(amount: viewModel.sendAmount)),
          ],
        ),
      ),
    );
  }
}

class PaymentAmountDisplay extends StatelessWidget {
  PaymentAmountDisplay({this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Text(
              value.toString(),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ));
  }
}

class CalculatorKeyboard extends StatefulWidget {
  CalculatorKeyboard({Key key, int amount}) : super(key: key);

  @override
  _CalculatorKeyboardState createState() => _CalculatorKeyboardState();
}

class _CalculatorKeyboardState extends State<CalculatorKeyboard> {
  bool isNewEquation = true;
  // List<double> values = [];
  List<String> operations = [];
  List<String> calculations = [];
  int amount;
  String calculatorString;

  @override
  void initState() {
    super.initState();
    calculatorString = amount.toString ?? '';
  }

  // void updateAmount(newAmount) {
  //   setState(() {
  //     values.add(newAmount);
  //     String calculatorString = '500000';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // On Equals press
    void _onPressed({String buttonText}) {
      // Standard mathematical operations
      if (Calculations.OPERATIONS.contains(buttonText)) {
        return setState(() {
          operations.add(buttonText);
          calculatorString += " $buttonText ";
          print(operations);
          print(calculatorString);
        });
      }

      // On CLEAR press
      if (buttonText == Calculations.CLEAR) {
        return setState(() {
          operations.add(Calculations.CLEAR);
          calculatorString = "";
          operations = [];
          print(operations);
        });
      }

      // On Equals press
      void equalsRefresh() {
        // if (buttonText == Calculations.EQUAL) {
        String newCalculatorString = Calculator.parseString(calculatorString);

        return setState(() {
          // if (newCalculatorString != calculatorString) {
          //   // only add evaluated strings to calculations array
          //   calculations.add(calculatorString);
          //   print(operations);
          // }

          // operations.add(Calculations.EQUAL);
          calculatorString = newCalculatorString;
          isNewEquation = false;
        });
      }

      setState(() {
        if (!isNewEquation &&
            operations.length == 1 &&
            operations.last == Calculations.EQUAL) {
          calculatorString = buttonText;
          isNewEquation = true;
          print(operations);
        } else {
          calculatorString += buttonText;
          print(operations);
        }
      });

      equalsRefresh();
    }

    return Container(
        child: Column(
      children: [
        PaymentAmountDisplay(value: calculatorString),
        CalculatorButtons(onTap: _onPressed),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ));
  }
}
