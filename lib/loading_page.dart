import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final loadingText = Padding(
        padding: EdgeInsets.all(64),
        child: Text(
          text,
          style: TextStyle(fontSize: 32),
        ));

    final indicator = SizedBox(
        height: 64,
        width: 64,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blue), strokeWidth: 5.0));
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [loadingText, indicator],
      ),
    ));
  }
}
