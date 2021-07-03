import 'package:flutter/material.dart';

import 'package:vase/lotus/networks.dart';

const network = NetworkType.TEST;

// Wallet constants
const electrumUrlMap = {
  NetworkType.MAIN: ['https://fulcrum.cashweb.io'],
  NetworkType.TEST: ['https://tfulcrum.cashweb.io'],
};

final electrumUrls = electrumUrlMap[network];
const inputSize = 148;
const outputSize = 34;
const defaultFeePerByte = 10;
const defaultNumberOfChildKeys = 10;

// UI constants
const stdElevation =
    0.0; // I like a flat look, the shadows were tacky to me  -aj
const stdPadding = EdgeInsets.all(12.0);

const copiedAd = SnackBar(
  content: Text('Copied address to Clipboard'),
  duration: Duration(seconds: 1),
);
