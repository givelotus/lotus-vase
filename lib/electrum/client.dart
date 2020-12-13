import 'dart:async';

import 'package:cashew/electrum/rpc.dart';

class ListUnspentResponseItem {
  ListUnspentResponseItem(this.height, this.tx_pos, this.tx_hash, this.value);

  int height;
  int tx_pos;
  String tx_hash;
  BigInt value;
}

class ElectrumClient extends JSONRPCWebsocket {
  Timer _pingTimer;

  ElectrumClient({DisconnectHandler disconnectHandler})
      : super(disconnectHandler: disconnectHandler) {
    _pingTimer = Timer(Duration(seconds: 30), () {
      if (rpcSocket != null) {
        print('ping');
        serverPing();
      }
    });
  }

  Future<Object> blockchainTransactionBroadcast(String transaction) {
    return call('blockchain.transaction.broadcast', [transaction]);
  }

  Future<Object> serverPing() {
    return call('server.ping', []);
  }

  Future<List<ListUnspentResponseItem>> blockchainScripthashListunspent(
      String scriptHash) async {
    final List<dynamic> response =
        await call('blockchain.scripthash.listunspent', [scriptHash]);
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
        await call('blockchain.scripthash.get_balance', [scripthash]);
    return GetBalanceResponse(response['confirmed'], response['unconfirmed']);
  }

  Future<List<String>> serverVersion(
      String ownVersion, String supportedVersion) async {
    final List<dynamic> response =
        await call('server.version', [ownVersion, supportedVersion]);
    return response.cast<String>();
  }

  Future<Object> blockchainScripthashSubscribe(
      String scripthash, SubscriptionHandler resultHandler) {
    return subscribe(
        'blockchain.scripthash.subscribe', [scripthash], resultHandler);
  }
}

typedef ConnectHandler = Future<void> Function(ElectrumClient client);

class ElectrumFactory {
  ElectrumFactory(this.urls, {this.onConnected});

  Future<ElectrumClient> _client;
  List<String> urls;
  ConnectHandler onConnected;

  /// Builds client if non-existent and attempts to connect before resolving.
  Future<ElectrumClient> build() {
    if (_client == null) {
      final newClient =
          ElectrumClient(disconnectHandler: (error) => {_client = null});
      final urls = this.urls.sublist(0);
      urls.shuffle();
      _client = newClient
          .connect(Uri.parse(urls[0]))
          .then((_) => onConnected(newClient))
          .then((_) => newClient);
    }
    return _client;
  }
}
