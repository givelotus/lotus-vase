import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'sendModel.dart';
import '../../wallet/wallet.dart';
import '../../viewmodel.dart';
import '../../bitcoincash/address.dart';
import '../../bitcoincash/transaction/transaction.dart';
import '../../constants.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                  ),
                ],
              ),
            ),
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
                          var parseObject = Uri.parse(data);
                          var address = parseObject.path;
                          var amount = parseObject.queryParameters['amount'];
                          var map = {'address': address, 'amount': amount};

                          print(map);
                          return map;
                        }

                        Address(tryParse(data.text.toString())['address']);

                        viewModel.sendToAddress =
                            tryParse(data.text.toString())['address'];
                        viewModel.sendAmount =
                            tryParse(data.text.toString())['amount'];
                        print(viewModel.sendToAddress);
                        print(viewModel.sendAmount);
                      },
                      child: viewModel.sendToAddress == null
                          ? Container(
                              child: Text(
                                'Tap to Paste Address',
                                style: TextStyle(
                                    color: Colors.red.withOpacity(.8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            )
                          : Container(
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
                                          color: Colors.black.withOpacity(.8),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              )),
                    );
                  }),
                ],
              ),
            ),
            Row(children: [
              Expanded(
                child: Padding(
                  padding: stdPadding,
                  child: TextField(
                    autocorrect: false,
                    enableInteractiveSelection: true,
                    autofocus: false,
                    toolbarOptions: ToolbarOptions(
                      paste: true,
                      cut: true,
                      copy: true,
                      selectAll: true,
                    ),
                    readOnly: false,
                    focusNode: FocusNode(),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: 'sats',
                      border: OutlineInputBorder(),
                      hintText: 'Enter amount',
                    ),
                  ),
                ),
              ),
              // TODO: This needs to actually do something
              FlatButton(
                onPressed: () {},
                child: Text('Max'),
              )
            ]),
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
            )
          ],
        ),
      ),
    );
  }
}
