import 'package:flutter/material.dart';

const stdElevation = 6.0;
const stdPadding = EdgeInsets.all(12.0);
const electrumUrls = [
  'http://bchabc.fmarcosh.xyz:50003',
  'https://electrum.bitcoinabc.org:50004',
];

const inputSize = 148;
const outputSize = 34;
const defaultFeePerByte = 1.5;

const copiedAd = SnackBar(
  content: Text('Copied address to Clipboard'),
  duration: Duration(seconds: 1),
);
