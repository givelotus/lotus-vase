import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = Text(
      'Loading wallet...',
      style: TextStyle(fontSize: 24),
    );
    final indicator = SizedBox(
        height: 48,
        width: 48,
        child: CircularProgressIndicator(
          strokeWidth: 6,
        ));
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            child: text,
            padding: EdgeInsets.all(24),
          ),
          Padding(child: indicator, padding: EdgeInsets.all(24))
        ],
      )),
    );
  }
}
