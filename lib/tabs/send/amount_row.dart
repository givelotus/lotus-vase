import 'package:flutter/material.dart';

import '../../constants.dart';

class AmountRow extends StatelessWidget {
  final _amountController;

  AmountRow(this._amountController);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Padding(
              padding: stdPadding,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: InputDecoration(
                    suffixText: 'sats',
                    border: OutlineInputBorder(),
                    hintText: 'Enter amount'),
              ))),
      FlatButton(onPressed: () {}, child: Text('Max'))
    ]);
  }
}
