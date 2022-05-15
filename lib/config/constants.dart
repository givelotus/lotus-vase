import 'package:flutter/material.dart';
import 'package:vase/lotus/networks.dart';

const network = NetworkType.MAIN;

final networkMainUrls = [
  'https://lotus.sunglasses.dev:50004',
  'https://fulcrum.cashweb.io'
];

// Wallet constants
final electrumUrlMap = <NetworkType, List<String>>{
  NetworkType.MAIN: networkMainUrls,
  NetworkType.TEST: ['https://tfulcrum.cashweb.io'],
  NetworkType.REGTEST: [],
  NetworkType.SCALINGTEST: [],
};

final electrumUrls = electrumUrlMap[network] ?? networkMainUrls;
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
