import 'dart:async';

import 'package:vase/electrum/rpc.dart';

class ListUnspentResponseItem {
  ListUnspentResponseItem(this.height, this.tx_pos, this.tx_hash, this.value);

  int? height;
  int? tx_pos;
  String? tx_hash;
  BigInt value;
}

class ElectrumClient extends JSONRPCWebsocket {
  // ignore: unused_field
  Timer? _pingTimer;

  ElectrumClient({DisconnectHandler? disconnectHandler})
      : super(disconnectHandler: disconnectHandler) {
    _pingTimer = Timer(Duration(seconds: 30), () {
      if (rpcSocket != null) {
        print('ping');
        serverPing();
      }
    });
  }

  Future<Object> blockchainTransactionBroadcast(String transaction) {
    return call('blockchain.transaction.broadcast', [transaction]).then((value) => value as Object);
  }

  Future<Object> serverPing() {
    return call('server.ping', []).then((value) => value as Object);
  }

  Future<List<ListUnspentResponseItem>> blockchainScripthashListunspent(
      String scriptHash) async {
    final List<dynamic> response =
        await (call('blockchain.scripthash.listunspent', [scriptHash]) as FutureOr<List<dynamic>>);
    return response
        .map((unspent) => ListUnspentResponseItem(
            unspent['height'],
            unspent['tx_pos'],
            unspent['tx_hash'],
            BigInt.from(unspent['value'])))
        .toList();
  }

  Future<GetBalanceResponse> blockchainScripthashGetBalance(
      String scripthash) async {
    final Map<String, dynamic> response =
        await (call('blockchain.scripthash.get_balance', [scripthash]) as FutureOr<Map<String, dynamic>>);
    return GetBalanceResponse(response['confirmed'], response['unconfirmed']);
  }

  Future<List<String>> serverVersion(
      String ownVersion, String supportedVersion) async {
    final List<dynamic> response =
        await (call('server.version', [ownVersion, supportedVersion]) as FutureOr<List<dynamic>>);
    return response.cast<String>();
  }

  Future<Object> blockchainScripthashSubscribe(
      String scripthash, SubscriptionHandler resultHandler) {
    return subscribe(
        'blockchain.scripthash.subscribe', [scripthash], resultHandler).then((value) => value as Object);
  }
}

typedef ConnectHandler = Future<void> Function(ElectrumClient? client);

class ElectrumFactory {
  ElectrumFactory(this.urls, {this.onConnected});

  ElectrumClient? _client;
  List<String>? urls;
  ConnectHandler? onConnected;

  /// Builds client if non-existent and attempts to connect before resolving.
  Future<ElectrumClient?> getInstance({int retry = 2}) async {
    try {
      if (_client == null) {
        _client = ElectrumClient(disconnectHandler: (error) {
          _client!.dispose();
          _client = null;
        });
        final urls = this.urls!.sublist(0);
        urls.shuffle();
        await _client!.connect(Uri.parse(urls[0]));
        await onConnected!(_client);
      }
    } catch (err) {
      print(err);
      _client = null;
      if (retry == 0) {
        rethrow;
      }
      return await getInstance(retry: retry - 1);
    }
    return _client;
  }
}
