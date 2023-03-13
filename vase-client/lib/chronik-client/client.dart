import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'chronik.pb.dart' as proto;
import 'client.types.dart';
import 'hex.dart';

/// Client to access a Chronik instance.Plain object, without any
/// connections. */
class ChronikClient {
  final String _url;
  final String _wsUrl;

  /// Create a new client. This just creates an object, without any connections.
  ///
  /// @param url Url of a Chronik instance, with schema and without trailing
  /// slash. E.g. https://chronik.be.cash/xec.
  ChronikClient(String url)
      : _url = url,
        _wsUrl = url.startsWith('https://')
            ? 'wss://${url.substring('https://'.length)}'
            : (url.startsWith('http://')
                ? 'ws://${url.substring('http://'.length)}'
                : throw Exception(
                    "url must start with 'https://' or 'http://', got: $url")) {
    if (url.endsWith('/')) {
      throw Exception("url cannot end with '/', got: $url");
    }
  }

  /// Broadcasts the `rawTx` on the network.
  /// If `skipSlpCheck` is false, it will be checked that the tx doesn't burn
  /// any SLP tokens before broadcasting.
  Future<BroadcastTxResponse> broadcastTx({
    dynamic rawTx,
    skipSlpCheck = false,
  }) async {
    final request = proto.BroadcastTxRequest.fromJson(jsonEncode({
      'rawTx': rawTx is String ? fromHex(rawTx) : rawTx,
      'skipSlpCheck': skipSlpCheck,
    }));
    final data = await _post(
        url: _url, path: "/broadcast-tx", data: request.writeToBuffer());
    final broadcastResponse = proto.BroadcastTxResponse.fromBuffer(data);
    return BroadcastTxResponse(txid: toHexRev(broadcastResponse.txid));
  }

  /// Broadcasts the `rawTxs` on the network, only if all of them are valid.
  /// If `skipSlpCheck` is false, it will be checked that the txs don't burn
  /// any SLP tokens before broadcasting.
  Future<BroadcastTxsResponse> broadcastTxs({
    dynamic rawTxs,
    skipSlpCheck = false,
  }) async {
    final request = proto.BroadcastTxsRequest.fromJson(jsonEncode({
      'rawTxs': (rawTxs as List)
          .map((rawTx) => rawTx is String ? fromHex(rawTx) : rawTx)
          .toList() as Uint8List,
      'skipSlpCheck': skipSlpCheck,
    }));
    final data = await _post(
        url: _url, path: "/broadcast-txs", data: request.writeToBuffer());
    final broadcastResponse = proto.BroadcastTxsResponse.fromBuffer(data);
    return BroadcastTxsResponse(
        txids: broadcastResponse.txids.map(toHexRev).toList());
  }

  /// Fetch current info of the blockchain, such as tip hash and height. */
  Future<BlockchainInfo> blockchainInfo() async {
    final data = await _get(_url, '/blockchain-info');
    final blockchainInfo = proto.BlockchainInfo.fromBuffer(data);
    return convertToBlockchainInfo(blockchainInfo);
  }

  /// Fetch the block given hash or height. */
  Future<Block> block(dynamic hashOrHeight) async {
    final data = await _get(_url, '/block/$hashOrHeight');
    final block = proto.Block.fromBuffer(data);
    return convertToBlock(block);
  }

  /// Fetch block info of a range of blocks. `startHeight` and `endHeight` are
  /// inclusive ranges. */
  Future<List<BlockInfo>> blocks({
    required int startHeight,
    required int endHeight,
  }) async {
    final data = await _get(_url, '/blocks/$startHeight/$endHeight');
    final blocks = proto.Blocks.fromBuffer(data);
    return blocks.blocks.map(convertToBlockInfo).toList();
  }

  /// Fetch tx details given the txid. */
  Future<Tx> tx(String txid) async {
    final data = await _get(_url, '/tx/$txid');
    final tx = proto.Tx.fromBuffer(data);
    return convertToTx(tx);
  }

  /// Fetch token info and stats given the tokenId. */
  Future<Token> token(String tokenId) async {
    final data = await _get(_url, '/token/$tokenId');
    final token = proto.Token.fromBuffer(data);
    return convertToToken(token);
  }

  /// Validate the given outpoints: whether they are unspent, spent or
  /// never existed. */
  Future<List<UtxoState>> validateUtxos(List<proto.OutPoint> outpoints) async {
    final request = proto.ValidateUtxoRequest.fromJson(
        jsonEncode({'outpoints': outpoints.map(convertToOutPoint).toList()}));
    final data = await _post(
        url: _url, path: "/validate-utxos", data: request.writeToBuffer());
    final validationStates = proto.ValidateUtxoResponse.fromBuffer(data);
    return validationStates.utxoStates.map(convertToUxtoState).toList();
  }

  /// Create object that allows fetching script history or UTXOs. */
  ScriptEndpoint script(String scriptType, String scriptPayload) {
    return ScriptEndpoint(
        url: _url, scriptType: scriptType, scriptPayload: scriptPayload);
  }

  /// Open a WebSocket connection to listen for updates. */
  WsEndpoint ws(WsConfig config) {
    return WsEndpoint(wsUrl: '$_wsUrl/ws', config: config);
  }
}

/// Allows fetching script history and UTXOs. */
class ScriptEndpoint {
  final String url;
  final String scriptType;
  final String scriptPayload;

  ScriptEndpoint({
    required this.url,
    required this.scriptType,
    required this.scriptPayload,
  });

  /// Fetches the tx history of this script, in anti-chronological order.
  /// This means it's ordered by first-seen first. If the tx hasn't been seen
  /// by the indexer before, it's ordered by the block timestamp.
  /// @param page Page index of the tx history.
  /// @param pageSize Number of txs per page.
  Future<TxHistoryPage> history({
    int? page,
    int? pageSize,
  }) async {
    final query = page != null && pageSize != null
        ? '?page=$page&page_size=$pageSize'
        : page != null
            ? '?page=$page'
            : pageSize != null
                ? '?page_size=$pageSize'
                : "";
    final data = await _get(
      url,
      '/script/$scriptType/$scriptPayload/history$query',
    );
    final historyPage = proto.TxHistoryPage.fromBuffer(data);
    return TxHistoryPage(
      txs: historyPage.txs.map(convertToTx).toList(),
      numPages: historyPage.numPages,
    );
  }

  /// Fetches the current UTXO set for this script.
  /// It is grouped by output script, in case a script type can match multiple
  /// different output scripts (e.g. Taproot on Lotus). */
  Future<List<ScriptUtxos>> utxos() async {
    final data = await _get(
      url,
      '/script/$scriptType/$scriptPayload/utxos',
    );
    final utxos = proto.Utxos.fromBuffer(data);
    return utxos.scriptUtxos.map(convertToScriptUtxos).toList();
  }
}

/// Config for a WebSocket connection to Chronik.
class WsConfig {
  const WsConfig(
      {this.onMessage,
      this.onConnect,
      this.onReconnect,
      this.onError,
      this.onEnd,
      this.autoReconnect});

  /// Fired when a message is sent from the WebSocket.
  final void Function(SubscribeMsg)? onMessage;

  /// Fired when a connection has been (re)established.
  final void Function(MessageEvent)? onConnect;

  /// Fired after a connection has been unexpectedly closed, and before a
  /// reconnection attempt is made. Only fired if `autoReconnect` is true.
  final void Function()? onReconnect;

  /// Fired when an error with the WebSocket occurs.
  final void Function(MessageEvent)? onError;

  /// Fired after a connection has been manually closed, or if `autoReconnect`
  /// is false, if the WebSocket disconnects for any reason.
  final void Function()? onEnd;

  /// Whether to automatically reconnect on disconnect, default true.
  final bool? autoReconnect;
}

/// WebSocket connection to Chronik.
class WsEndpoint {
  /// Fired when a message is sent from the WebSocket.
  void Function(SubscribeMsg)? onMessage;

  /// Fired when a connection has been (re)established.
  void Function(MessageEvent)? onConnect;

  /// Fired after a connection has been unexpectedly closed, and before a
  /// reconnection attempt is made. Only fired if `autoReconnect` is true.
  void Function()? onReconnect;

  /// Fired when an error with the WebSocket occurs.
  void Function(ErrorEvent)? onError;

  /// Fired after a connection has been manually closed, or if `autoReconnect`
  /// is false, if the WebSocket disconnects for any reason.
  void Function()? onEnd;

  /// Whether to automatically reconnect on disconnect, default true.
  bool autoReconnect = false;

  WebSocketChannel? _ws;
  String _wsUrl = "";
  bool _manuallyClosed = false;
  List<Subscription> _subs = [];

  WsEndpoint({required wsUrl, required WsConfig config}) {
    onMessage = config.onMessage;
    onConnect = config.onConnect;
    onReconnect = config.onReconnect;
    onEnd = config.onEnd;
    autoReconnect = config.autoReconnect ?? true;
    _subs = [];
    _wsUrl = wsUrl;
    _manuallyClosed = false;
    _connect();
  }

  /// Wait for the WebSocket to be connected.
  waitForOpen() async {
    await _ws?.ready;
  }

  /// Subscribe to the given script type and payload.
  /// For "p2pkh", `scriptPayload` is the 20 byte key hash. */
  subscribe(String scriptType, String scriptPayload) {
    _subs.add(
        Subscription(scriptType: scriptType, scriptPayload: scriptPayload));
    if (_ws != null) {
      _subUnsub(
          isSubscribe: true,
          scriptType: scriptType,
          scriptPayload: scriptPayload);
    }
  }

  /// Unsubscribe from the given script type and payload. */
  unsubscribe(String scriptType, String scriptPayload) {
    _subs = _subs
        .where(
          (sub) =>
              sub.scriptType != scriptType ||
              sub.scriptPayload != scriptPayload,
        )
        .toList();
    if (_ws != null) {
      _subUnsub(
          isSubscribe: false,
          scriptType: scriptType,
          scriptPayload: scriptPayload);
    }
  }

  /// Close the WebSocket connection and prevent future any reconnection
  /// attempts. */
  close() {
    _manuallyClosed = true;
    _ws?.sink.close();
  }

  _connect() {
    _ws = WebSocketChannel.connect(Uri.parse(_wsUrl));
    _ws?.stream.listen((e) => _handleMsg(e),
        onError: (e) => onError?.call(e),
        onDone: () {
          // End if manually closed or no auto-reconnect
          if (_manuallyClosed || !autoReconnect) {
            if (onEnd != null) {
              onEnd?.call();
            }
            return;
          }
          if (onReconnect != null) {
            onReconnect?.call();
          }
          _connect();
        });
  }

  _subUnsub({
    required bool isSubscribe,
    required String scriptType,
    required String scriptPayload,
  }) {
    final encodedSubscription = proto.Subscription.fromJson(jsonEncode({
      'scriptType': scriptType,
      'payload': fromHex(scriptPayload),
      'isSubscribe': isSubscribe,
    }));
    if (_ws == null) {
      throw Exception("Invalid state; _ws is null");
    }
    _ws?.sink.add(encodedSubscription);
  }

  _handleMsg(Uint8List data) async {
    final msg = proto.SubscribeMsg.fromBuffer(data);
    print('Message received $msg');
    if (msg.hasError()) {
      onMessage?.call(MsgError(
        errorCode: msg.error.errorCode,
        msg: msg.error.msg,
        isUserError: msg.error.isUserError,
      ));
    } else if (msg.hasAddedToMempool()) {
      onMessage?.call(MsgAddedToMempool(
        txid: toHexRev(msg.addedToMempool.txid),
      ));
    } else if (msg.hasRemovedFromMempool()) {
      onMessage?.call(MsgRemovedFromMempool(
        txid: toHexRev(msg.removedFromMempool.txid),
      ));
    } else if (msg.hasConfirmed()) {
      onMessage?.call(MsgConfirmed(
        txid: toHexRev(msg.confirmed.txid),
      ));
    } else if (msg.hasReorg()) {
      onMessage?.call(MsgReorg(
        txid: toHexRev(msg.reorg.txid),
      ));
    } else if (msg.hasBlockConnected()) {
      onMessage?.call(MsgBlockConnected(
        blockHash: toHexRev(msg.blockConnected.blockHash),
      ));
    } else if (msg.hasBlockDisconnected()) {
      onMessage?.call(MsgBlockDisconnected(
        blockHash: toHexRev(msg.blockDisconnected.blockHash),
      ));
    } else {
      if (kDebugMode) {
        print("Silently ignored unknown Chronik message: $msg");
      }
    }
  }
}

Future<Uint8List> _get(String url, String path) async {
  final response = await http.get(Uri.parse('$url$path'));
  ensureResponseErrorThrown(response, path);
  return response.bodyBytes;
}

Future<Uint8List> _post({
  required String url,
  required String path,
  required Uint8List data,
}) async {
  final response =
      await http.post(Uri.parse('$url$path'), body: data, headers: {
    "Content-Type": "application/x-protobuf",
  });
  ensureResponseErrorThrown(response, path);
  return response.bodyBytes;
}

ensureResponseErrorThrown(http.Response response, String path) {
  if (response.statusCode != 200) {
    final error = proto.Error.fromBuffer(response.bodyBytes);
    throw Exception('Failed getting $path (${error.errorCode}): ${error.msg}');
  }
}
