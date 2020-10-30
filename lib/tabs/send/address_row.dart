import 'package:flutter/material.dart';

import '../../constants.dart';

class AddressRow extends StatelessWidget {
  final String qrText;

  AddressRow({Key key, this.qrText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: stdPadding,
        child: Row(
          children: [
            Expanded(
                child: TextField(
              keyboardType: TextInputType.text,
              controller: TextEditingController(text: qrText),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter recipient address'),
            )),
            IconButton(
              icon: Icon(Icons.contacts),
              onPressed: () => {}, //widget.wallet.send(this.qrText.value, 0)},
            )
          ],
        ));
  }
}
