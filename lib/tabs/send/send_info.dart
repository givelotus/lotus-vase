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

ValueNotifier<String> _paymentAmount = ValueNotifier('0');
ValueNotifier<bool> _showKeyboard = ValueNotifier<bool>(true);

String _validateAddress(String address) {
// TODO: if present, try checking scheme is 'bitcoincash' or throw error
// (scheme should be optional)
// check address conforms to Address class or throw error
// check amount function (>0, less than total in wallet)

  // Address(tryParse(data)['address']);
  // Address(address);
}

String _validateSendAmount(int amount) {
  if (amount == 0) {
    return 'Amount cannot be 0';
  }
  // if (amount > wallet.balanceSatoshis()) {
  //   return 'Amount cannot be more than wallet balance';
  // }
}

// TODO: Add check amount is > 0 and < amount of sats in wallet.

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

              _showKeyboard.value = true;
              _paymentAmount.value = '0';
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
                            // TODO / FIX : add amount parser back
                            // 'amount': (double.parse(
                            //             parseObject.queryParameters['amount']) *
                            //         100000000)
                            //     .round(),
                            'scheme': parseObject.scheme
                          };

                          _validateAddress(viewModel.sendToAddress);
                          // TODO / FIX : add amount parser back
                          // _validateSendAmount(viewModel.sendAmount);

                          // Dev purposes only:
                          print(map);
                          return map;
                        }

                        viewModel.sendToAddress = tryParse(data)['address'];
                        // TODO / FIX : when amount is present, display on screen:
                        // _paymentAmount.value =
                        //     tryParse(data)['amount'].toString();

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
                                        text:
                                            'bitcoincash:${viewModel.sendToAddress}',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(.8),
                                            fontSize: 15),
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
  PaymentAmountDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        ValueListenableBuilder(
            valueListenable: _paymentAmount,
            builder: (context, _paymentAmount, child) {
              return Text(
                // TODO: (Low priority)
                // - Add TextSpan widget for making 'sats' smaller size,
                // - Number formatter for value
                '${_paymentAmount} sats',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              );
            })
      ]),
    );
  }
}

class CalculatorKeyboard extends StatefulWidget {
  CalculatorKeyboard({Key key, @required Wallet wallet}) : super(key: key);

  @override
  _CalculatorKeyboardState createState() => _CalculatorKeyboardState();
}

class _CalculatorKeyboardState extends State<CalculatorKeyboard> {
  // TODO/FIX: Need to figure out what to do with these two variables
  // in conjuction with the setState just before the evaluateRefresh()
  // in _onPressed().
  bool isNewEquation = true;
  List<String> operations = [];
  // _paymentAmount holds the stack of the calculator values/operations
  // as a String array. When _onPressed is called for any buttton,
  // its label is checked against Calculations.OPERATIONS for appropriate parsing
  // and finally evaluation in evaluateRefresh().

  // Evaluate Expression & Refresh
  void evaluateRefresh() {
    print(_paymentAmount);
    _paymentAmount.value = Calculator.parseString(_paymentAmount.value);
    isNewEquation = false;

    print(_paymentAmount.value);
  }

  @override
  Widget build(BuildContext context) {
    Wallet wallet;
    final viewModel = Provider.of<SendModel>(context, listen: true);
    final walletModel = Provider.of<WalletModel>(context, listen: false);
    final balanceNotifier = walletModel.balance;

    // On every press of any button, checks for conditions and then executes
    void _onPressed({String buttonLabel}) {
      // Checks before adding any operation or any digit
      // 1. Divide by zero or 00 gives you ''.
      if ((buttonLabel == '0' || buttonLabel == '00') &&
          (_paymentAmount.value[_paymentAmount.value.length - 1] ==
              Calculations.DIVIDE)) {
        _paymentAmount.value = '';
        return;
      }

      // 2. Checks for when starting from '' or '0' (default)
      switch (_paymentAmount.value) {
        case '':
          {
            // Ignore 00 and 0 when _paymentAmount is currently empty.
            if (buttonLabel == '0' || buttonLabel == '00') {
              return;
            }
          }
          break;
        case '0':
          // Ignore all non-integers when _paymentAmount is '0'.
          if ((Calculations.NONINTEGERS.contains(buttonLabel))) {
            return;
          }
          // Get rid of leading zero '0' on legitimate integer input.
          if ((!Calculations.NONINTEGERS.contains(buttonLabel))) {
            _paymentAmount.value = "$buttonLabel";
            print(_paymentAmount.value);
            return;
          }
      }

      // Standard mathematical operations
      if (Calculations.OPERATIONS.contains(buttonLabel)) {
        return setState(() {
          switch (_paymentAmount.value.length) {
            case 0:
              {
                _paymentAmount.value = '';
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
                if (Calculations.OPERATIONS.contains(
                    _paymentAmount.value[_paymentAmount.value.length - 1])) {
                  switch (buttonLabel ==
                      _paymentAmount.value[_paymentAmount.value.length - 1]) {
                    case true:
                      {
                        // do NOTHING!
                      }
                      break;
                    default:
                      {
                        _paymentAmount.value = _paymentAmount.value
                            .substring(0, _paymentAmount.value.length - 1);
                        _paymentAmount.value += "$buttonLabel";
                      }
                  }
                } else {
                  _paymentAmount.value += "$buttonLabel";
                }
              }
          }
        });
      } else
      // On CLEAR press
      if (buttonLabel == Calculations.BACKSPACE) {
        return setState(() {
          switch (_paymentAmount.value.length) {
            case 1:
              {
                _paymentAmount.value = '';
              }
              break;
            default:
              {
                // Checks if decimal place in the string's penultimate position:
                // e.g., 12.9 - yes; 12.99 - no. 12 - no.
                // If so, makes sure decimal is also deleted along with the last digit
                // Else, delete only last item in string array.
                if (Calculations.PERIOD.contains(
                    _paymentAmount.value[_paymentAmount.value.length - 2])) {
                  _paymentAmount.value = _paymentAmount.value
                      .substring(0, _paymentAmount.value.length - 2);
                } else {
                  _paymentAmount.value = _paymentAmount.value
                      .substring(0, _paymentAmount.value.length - 1);
                }
              }
          }
        });
      }

      setState(() {
        _paymentAmount.value += buttonLabel;
      });

      evaluateRefresh();
    }

    int calStringToInt(String _paymentAmount) {
      // function returns int from String
      int amount;

      // rework rest of code for paymentmount .value
      // Check and delete operators at end of string.
      if (Calculations.OPERATIONS
          .contains(_paymentAmount[_paymentAmount.length - 1])) {
        _paymentAmount = _paymentAmount.substring(0, _paymentAmount.length - 1);
      }

      // Can we get rid of these two lines below... hmm..
      if (_paymentAmount == '0') {
        return amount = 0;
      } else {
        // Convert to double, then round up or down to nearest integer
        amount = (double.parse(_paymentAmount)).round();

        // Check if amount negative; return error
        if (amount <= 0) {
          return amount = 0;
        } else {
          return amount;
        }
      }
    }

    void sendButtonSwiped(BuildContext context, String address, int amount) {
      // This is at the 'swipe to send' level, after confirming the amount.
      // The address and amount should have been pre-validated at the form and corrected
      // by user before even being able to swipe send; we are thus sending direct to Electrum library.

      wallet
          .sendTransaction(Address(address), BigInt.from(amount))
          .then((transaction) => showReceipt(context, transaction))
          .catchError((error) => showError(context, error.toString()));

      // only close SendInfo screen in case transaction is successful
      // visible.value = false
    }

    return Container(
        child: Column(
      children: [
        PaymentAmountDisplay(),
        // Balance Display widget
        Padding(
          padding: const EdgeInsets.fromLTRB(60.0, 0, 60.0, 30.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
        ),
        // Confirm Amount button widget writes to global SendModel:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Consumer<SendModel>(
                  builder: (context, viewModel, child) {
                    switch (_showKeyboard.value) {
                      case true:
                        {
                          return ElevatedButton(
                            autofocus: true,
                            // TODO: we should probably have ValueNotifiable props
                            // specifically for this component
                            // Rather than wiring directly to the global viewmodel
                            // (I decided to keep it - aj 12/11/20)
                            onPressed: () {
                              int updatedAmount =
                                  calStringToInt(_paymentAmount.value);

                              setState(() {
                                _paymentAmount.value = updatedAmount.toString();
                                switch (updatedAmount) {
                                  case 0:
                                    {
                                      return; // Prefer not to show error; obvious that user needs to recalc.
                                    }
                                    break;
                                  default:
                                    _validateAddress(viewModel.sendToAddress);
                                    _validateSendAmount(updatedAmount);

                                    viewModel.sendAmount = updatedAmount;

                                    _showKeyboard.value = false;
                                }
                              });
                            },
                            child: Text('Confirm Amount'),
                          );
                        }
                        break;
                      default:
                        {
                          // TODO: Change the button to slide to send widget :)
                          return ElevatedButton(
                            autofocus: true,
                            onPressed: () {
                              // sendButtonSwiped(context, viewModel.sendToAddress,
                              //     viewModel.sendAmount);

                              wallet
                                  .sendTransaction(
                                      Address(viewModel.sendToAddress),
                                      BigInt.from(viewModel.sendAmount))
                                  .then((transaction) =>
                                      showReceipt(context, transaction))
                                  .catchError((error) =>
                                      showError(context, error.toString()));
                            },
                            child: Text(
                                'Send ${viewModel.sendAmount} sats to ${viewModel.sendToAddress} !'),
                          );
                        }
                        ;
                    }
                  },
                ),
              )
            ],
          ),
        ),
        ValueListenableBuilder(
            builder: (context, balance, child) {
              if (_showKeyboard.value == true) {
                return CalculatorButtons(onTap: _onPressed);
              } else {
                return Container(
                  height: 100,
                );
              }
            },
            valueListenable: _showKeyboard),
      ],
    ));
  }
}
