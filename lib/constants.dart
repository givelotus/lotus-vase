import 'package:flutter/material.dart';

import 'package:cashew/bitcoincash/src/networks.dart';

// Wallet constants
const electrumUrls = [
  'http://bchabc.fmarcosh.xyz:50003',
  'https://electrum.bitcoinabc.org:50004',
  'https://fulcrum.cashweb.io',
];

const inputSize = 148;
const outputSize = 34;
const defaultFeePerByte = 10;

// UI constants
const stdElevation =
    0.0; // I like a flat look, the shadows were tacky to me  -aj
const stdPadding = EdgeInsets.all(12.0);

const copiedAd = SnackBar(
  content: Text('Copied address to Clipboard'),
  duration: Duration(seconds: 1),
);

const network = NetworkType.MAIN;
