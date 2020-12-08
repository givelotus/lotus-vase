import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:flutter/cupertino.dart';
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

void _validateAddress(String address) {
  // Address(tryParse(data)['address']);
  // Address(address);
}

void _validateSendAmount(int amount) {
  if (amount == 0) {
    return;
  }
}

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

  @override
  Widget build(context) {
    var screenDimension = MediaQuery.of(context).size;
    // final viewModel = Provider.of<SendModel>(context, listen: false);

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
      appBar: CupertinoNavigationBar(
        middle: Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Consumer<SendModel>(
          builder: (context, viewModel, child) => TextButton(
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: stdPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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

                          // Dev purposes only:
                          print(map);
                          return map;
                        }

                        _validateAddress(viewModel.sendToAddress);
                        viewModel.sendToAddress = tryParse(data)['address'];

                        _validateSendAmount(viewModel.sendAmount);
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
            CalculatorKeyboard(wallet: wallet)
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // TODO: - FIX Add default = 0 sats
              // - Add TextSpan widget for making 'sats' smaller size,
              // - and number formatter for value
              '${value ?? '0'} sats',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class CalculatorKeyboard extends StatefulWidget {
// TODO: Work on UI here (in library)

  CalculatorKeyboard({Key key, @required Wallet wallet}) : super(key: key);

  @override
  _CalculatorKeyboardState createState() => _CalculatorKeyboardState();
}

class _CalculatorKeyboardState extends State<CalculatorKeyboard> {
  Wallet wallet;

  // TODO/FIX: Need to figure out what to do with these two variables
  // in conjuction with the setState just before the evaluateRefresh()
  // in _onPressed().
  bool isNewEquation = true;
  List<String> operations = [];
  // calculatorString holds the stack of the calculator values/operations
  // as a String array. When _onPressed is called for any buttton,
  // its label is checked against Calculations.OPERATIONS for appropriate parsing
  // and finally evaluation in evaluateRefresh().
  String calculatorString = '0';

  // Evaluate Expression & Refresh
  void evaluateRefresh() {
    return setState(() {
      calculatorString = Calculator.parseString(calculatorString);
      isNewEquation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // On every press of any button, checks for conditions and then executes
    void _onPressed({String buttonLabel}) {
      // Checks before adding any operation or any digit
      // 1. Divide by zero or 00 gives you ''.
      if ((buttonLabel == '0' || buttonLabel == '00') &&
          (calculatorString[calculatorString.length - 1] ==
              Calculations.DIVIDE)) {
        setState(() {
          calculatorString = '';
        });
        return;
      }

      // 2. Checks for when starting from '' or '0' (default)
      switch (calculatorString) {
        case '':
          {
            // Ignore 00 and 0 when calculatorString is currently empty.
            if (buttonLabel == '0' || buttonLabel == '00') {
              return;
            }
          }
          break;
        case '0':
          // Ignore all non-integers when calculatorString is '0'.
          if ((Calculations.NONINTEGERS.contains(buttonLabel))) {
            return;
          }
          // Get rid of leading zero '0' on legitimate integer input.
          if ((!Calculations.NONINTEGERS.contains(buttonLabel))) {
            setState(() {
              calculatorString = "$buttonLabel";
            });
            return;
          }
      }

      // Standard mathematical operations
      if (Calculations.OPERATIONS.contains(buttonLabel)) {
        return setState(() {
          switch (calculatorString.length) {
            case 0:
              {
                calculatorString = '';
              }
              break;
            default:
              {
                // Checks if last item in string array is operator;
                // If so:
                // - Check if last item is same as input (buttonText) - do nothing
                // - If not, replace with new operator (default case in switch)
                // If last item in string array not already operator, then
                // safe to add operator to last item in string.
                if (Calculations.OPERATIONS
                    .contains(calculatorString[calculatorString.length - 1])) {
                  switch (buttonLabel ==
                      calculatorString[calculatorString.length - 1]) {
                    case true:
                      {
                        // do NOTHING!
                      }
                      break;
                    default:
                      {
                        calculatorString = calculatorString.substring(
                            0, calculatorString.length - 1);
                        calculatorString += "$buttonLabel";
                      }
                  }
                } else {
                  calculatorString += "$buttonLabel";
                }
              }
          }
        });
      } else
      // On CLEAR press
      if (buttonLabel == Calculations.BACKSPACE) {
        return setState(() {
          switch (calculatorString.length) {
            case 1:
              {
                calculatorString = '';
              }
              break;
            default:
              {
                // Checks if decimal place in the string's penultimate position:
                // e.g., 12.9 - yes; 12.99 - no. 12 - no.
                // If so, makes sure decimal is also deleted along with the last digit
                // Else, delete only last item in string array.
                if (Calculations.PERIOD
                    .contains(calculatorString[calculatorString.length - 2])) {
                  calculatorString = calculatorString.substring(
                      0, calculatorString.length - 2);
                } else {
                  calculatorString = calculatorString.substring(
                      0, calculatorString.length - 1);
                }
              }
          }
        });
      }

      setState(() {
        calculatorString += buttonLabel;
      });

      evaluateRefresh();
    }

    int calStringToInt(String calculatorString) {
      // function returns this
      int amount;

      // Check and delete operators at end of string.
      if (Calculations.OPERATIONS
          .contains(calculatorString[calculatorString.length - 1])) {
        calculatorString =
            calculatorString.substring(0, calculatorString.length - 1);
      }

      // Can we get rid of these two lines below... hmm..
      if (calculatorString == '0') {
        return amount = 0;
      } else {
        // Convert to double, then round up or down to nearest integer
        amount = (double.parse(calculatorString)).round();

        // Check if amount negative; return error
        if (amount <= 0) {
          return amount = 0;
        } else {
          return amount;
        }
      }
    }

    Future<void> sendButtonSwiped(
        BuildContext context, String address, int amount) async {
      // This is at the 'swipe to send' level, after confirming the amount.
      // The address and amount should have been pre-validated at the form and corrected
      // by user before even being able to swipe send; we are thus sending direct to Electrum library.

      await {
        wallet
            .sendTransaction(Address(address), BigInt.from(amount))
            .then((transaction) => showReceipt(context, transaction))
            .catchError((error) => showError(context, error.toString()))
      };

      // only close SendInfo screen in case transaction is successful
      // visible.value = false
    }

    final viewModel = Provider.of<SendModel>(context, listen: true);
    final walletModel = Provider.of<WalletModel>(context, listen: false);
    final balanceNotifier = walletModel.balance;

    return Container(
        child: Column(
      children: [
        PaymentAmountDisplay(value: calculatorString),
        Card(
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Balance'),
                  subtitle: const Text('in satoshis'),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
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
                        text: '${balance}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: ' sats',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontSize: 15),
                          ),
                        ],
                      ));
                    }),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Consumer<SendModel>(
                  builder: (context, viewModel, child) => ElevatedButton(
                    autofocus: true,
                    // TODO: we should probably have ValueNotifiable props
                    // specifically for this component
                    // Rather than wiring directly to the global viewmodel
                    onPressed: () {
                      int updatedAmount = calStringToInt(calculatorString);

                      setState(() {
                        calculatorString = updatedAmount.toString();
                        switch (updatedAmount) {
                          case 0:
                            {
                              // Do nothing
                              // Prefer not to show error; obvious that user needs to
                              // recalc things...
                            }
                            break;
                          default:
                            _validateSendAmount(updatedAmount);
                            viewModel.sendAmount = updatedAmount;
                            print(updatedAmount);
                          // TODO: Change the button to slide to send widget :)
                        }

                        _validateAddress(viewModel.sendToAddress);
                      });
                    },
                    child: Text('Confirm Amount'),
                  ),
                ),
              )
            ],
          ),
        ),
        CalculatorButtons(onTap: _onPressed),
      ],
    ));
  }
}
