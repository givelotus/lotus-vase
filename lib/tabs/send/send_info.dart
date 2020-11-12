import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel.dart';
import '../../wallet/wallet.dart';
import '../../bitcoincash/src/address.dart';
import '../../bitcoincash/src/transaction/transaction.dart';
import '../../constants.dart';

Future showReceipt(BuildContext context, Transaction transaction) {
  // TODO: Create nice looking receipt dialog.
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Receipt'),
          content: Text('TODO'),
        );
      });
}

class SendInfo extends StatelessWidget {
  final ValueNotifier<bool> visible;

  SendInfo({this.visible});

  void sendButtonClicked(
      BuildContext context, Wallet wallet, String address, int amount) {
    final primaryValidation = (amount != null && amount > 0);
    if (!primaryValidation) {
      return;
    }
    try {
      // TODO: Need address validation here. Should attach to entry field
      // somehow to indicate the address is bad.
      wallet
          .sendTransaction(Address(address), BigInt.from(amount))
          .then((transaction) => showReceipt(context, transaction));
    } catch (e) {}
  }

  @override
  Widget build(context) {
    final viewModel = Provider.of<CashewModel>(context, listen: false);

    final addressController =
        TextEditingController(text: viewModel.sendToAddress);

    addressController.addListener(() {
      viewModel.sendToAddress = addressController.text;
    });

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
                    child: Text('${viewModel.activeWallet.balanceSatoshis()}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: stdPadding,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autocorrect: false,
                      enableInteractiveSelection: true,
                      autofocus: true,
                      toolbarOptions: ToolbarOptions(
                        paste: true,
                        cut: true,
                        copy: true,
                        selectAll: true,
                      ),
                      readOnly: false,
                      focusNode: FocusNode(),
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter recipient address',
                      ),
                    ),
                  )
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
                  child: Consumer<CashewModel>(
                    builder: (context, viewModel, child) => ElevatedButton(
                      // TODO: we should probably have ValueNotifiable props
                      // specifically for this component
                      // Rather than wiring directly to the global viewmodel
                      onPressed: () {
                        visible.value = false;
                        viewModel.sendAmount = null;
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<CashewModel>(
                    builder: (context, viewModel, child) => ElevatedButton(
                      autofocus: true,
                      // TODO: we should probably have ValueNotifiable props
                      // specifically for this component
                      // Rather than wiring directly to the global viewmodel
                      onPressed: () {
                        sendButtonClicked(
                          context,
                          viewModel.activeWallet,
                          viewModel.sendToAddress,
                          viewModel.sendAmount,
                        );
                        visible.value = false;
                        viewModel.sendAmount = null;
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
