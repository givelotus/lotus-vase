import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'rpc.g.dart';

class UnhandledElectrumMessage implements Exception {
  String cause;
  String message;

  UnhandledElectrumMessage(this.cause, this.message);
}

class UnknownElectrumError implements Exception {
  String cause;
  String message;

  UnknownElectrumError(this.cause, this.message);
}

@JsonSerializable()
class RPCRequest {
  @JsonKey(disallowNullValue: true)
  final String jsonrpc = '2.0';
  @JsonKey(disallowNullValue: true)
  final String method;
  @JsonKey(includeIfNull: true)
  final int id;
  @JsonKey(includeIfNull: true)
  final Object params;

  RPCRequest(this.method, {this.id, this.params});
  factory RPCRequest.fromJson(Map<String, dynamic> json) =>
      _$RPCRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RPCRequestToJson(this);
}

class RequestConverter extends Converter<Map<String, dynamic>, RPCRequest> {
  @override
  RPCRequest convert(input) {
    return RPCRequest.fromJson(input);
  }
}

@JsonSerializable()
class Error {
  @JsonKey(disallowNullValue: true)
  final int code;
  @JsonKey(disallowNullValue: true)
  final String message;
  @JsonKey(includeIfNull: true)
  final Object data;

  Error(this.code, this.message, {this.data});
  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}

@JsonSerializable()
class RPCResponse {
  @JsonKey(disallowNullValue: true)
  final String jsonrpc = '2.0';
  @JsonKey(includeIfNull: true)
  final Object result;
  @JsonKey(includeIfNull: true)
  final Error error;
  @JsonKey(includeIfNull: true)
  final int id;
  @JsonKey(includeIfNull: true)
  final String method;
  @JsonKey(includeIfNull: true)
  final List<Object> params;

  RPCResponse(this.result, {this.id, this.error, this.method, this.params});
  factory RPCResponse.fromJson(Map<String, dynamic> json) =>
      _$RPCResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RPCResponseToJson(this);
}

typedef ResponseHandler = void Function(RPCResponse response);
typedef SubscriptionHandler = void Function(List<Object> result);

class JSONRPCWebsocket {
  WebSocket rpcSocket;
  Map<int, ResponseHandler> outstandingRequests = {};
  Map<String, SubscriptionHandler> subscriptions = {};
  var currentRequestId = 0;

  JSONRPCWebsocket();

  void connect(Uri address) async {
    rpcSocket = await WebSocket.connect(address.toString());
    rpcSocket.listen((dynamic data) {
      Map<String, dynamic> jsonResult = jsonDecode(data);
      final response = RPCResponse.fromJson(jsonResult);
      if (response.id == null && response.method == null) {
        throw UnhandledElectrumMessage('Missing response handler', data);
        return;
      }
      if (outstandingRequests.containsKey(response.id)) {
        final handler = outstandingRequests[response.id] ??
            (RPCResponse _response) {
              assert(false,
                  'We should not be here. Checked above. This code was for type-safety');
            };
        handler(response);
        return;
      }

      if (subscriptions.containsKey(response.method)) {
        final handler = subscriptions[response.method] ??
            (List<Object> params) {
              assert(false,
                  'We should not be here. Checked above. This code was for type-safety');
            };
        handler(response.params);
        return;
      }
    }, onError: (Object error) {
      throw UnknownElectrumError('Websocket errored to electrum server', error);
    }, onDone: () {
      // Nothing to do?
    }, cancelOnError: false);
  }

  Future<dynamic> call(String method, Object params) {
    final requestId = currentRequestId++;
    final completer = Completer();

    outstandingRequests[requestId] = (RPCResponse response) {
      completer.complete(response.result);
      outstandingRequests.remove(requestId);
    };

    final payload =
        jsonEncode(RPCRequest(method, id: requestId, params: params).toJson());
    rpcSocket.add(payload);

    return completer.future;
  }

  Future<dynamic> subscribe(
      String method, Object params, SubscriptionHandler handler) {
    final requestId = currentRequestId++;
    final completer = Completer();

    subscriptions[method] = handler;

    outstandingRequests[requestId] = (RPCResponse response) {
      completer.complete(response.result);
      outstandingRequests.remove(requestId);
    };

    final payload =
        jsonEncode(RPCRequest(method, id: requestId, params: params).toJson());
    rpcSocket.add(payload);

    return completer.future;
  }

  void dispose() {
    rpcSocket.close();
  }
}

class ElectrumClient extends JSONRPCWebsocket {
  Future<Object> blockchainTransactionBroadcast(String transaction) {
    return call('blockchain.transaction.broadcast', [transaction]);
  }

  Future<Object> blockchainScripthashListunspent(String scriptHash) {
    // TODO: Add interface here for this call specifically
    return call('blockchain.scripthash.listunspent', [scriptHash]);
  }

  Future<Object> blockchainScripthashSubscribe(
      String scripthash, SubscriptionHandler resultHandler) {
    return subscribe(
        'blockchain.scripthash.subscribe', [scripthash], resultHandler);
  }
}
