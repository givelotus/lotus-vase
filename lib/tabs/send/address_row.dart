import 'package:flutter/material.dart';

import '../../constants.dart';

class AddressRow extends StatelessWidget {
  final _addressController;

  AddressRow(this._addressController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: stdPadding,
        child: Row(
          children: [
            Expanded(
                child: TextField(
              keyboardType: TextInputType.text,
              controller: _addressController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter recipient address'),
            )),
            IconButton(
              icon: Icon(Icons.contacts),
              onPressed: () => {},
            )
          ],
        ));
  }
}
