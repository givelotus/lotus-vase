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
    _pingTimer = Timer(const Duration(seconds: 30), () {
      if (rpcSocket != null) {
        print('ping');
        serverPing();
      }
    });
  }

  Future<Object?> blockchainTransactionBroadcast(String transaction) {
    return call('blockchain.transaction.broadcast', [transaction]);
  }

  Future<Object?> serverPing() {
    return call('server.ping', []);
  }

  Future<List<ListUnspentResponseItem>> blockchainScripthashListunspent(
      String scriptHash) async {
    final List<dynamic> response =
        await (call('blockchain.scripthash.listunspent', [scriptHash]));

    // this is needed to prevent type errors
    if (response.isEmpty) return [];

    return response
        .map(
          (unspent) => ListUnspentResponseItem(
            unspent['height'],
            unspent['tx_pos'],
            unspent['tx_hash'],
            BigInt.from(unspent['value']),
          ),
        )
        .toList();
  }

  Future<GetBalanceResponse> blockchainScripthashGetBalance(
      String scripthash) async {
    final response =
        await (call('blockchain.scripthash.get_balance', [scripthash]));
    return GetBalanceResponse(response['confirmed'], response['unconfirmed']);
  }

  Future<List<String>> serverVersion(
      String ownVersion, String supportedVersion) async {
    final response =
        await (call('server.version', [ownVersion, supportedVersion]));
    return response.cast<String>();
  }

  Future<Object?> blockchainScripthashSubscribe(
      String scripthash, SubscriptionHandler resultHandler) {
    return subscribe(
        'blockchain.scripthash.subscribe', [scripthash], resultHandler);
  }
}

typedef ConnectHandler = Future<void> Function(ElectrumClient? client);

class ElectrumFactory {
  ElectrumFactory(this.urls, {this.onConnected});

  ElectrumClient? _client;
  List<String> urls;
  ConnectHandler? onConnected;

  /// Builds client if non-existent and attempts to connect before resolving.
  Future<ElectrumClient?> getInstance({int retry = 4}) async {
    try {
      if (_client == null) {
        _client = ElectrumClient(disconnectHandler: (error) {
          print('disconnect error $error');
          _client?.dispose();
          _client = null;
        });

        print("retry $retry");

        final urls = this.urls.sublist(0);
        final url = urls[retry % urls.length];
        await _client?.connect(Uri.parse(url));

        print('rpc called connect $onConnected');

        if (onConnected != null) {
          await onConnected!(_client);
        }
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
