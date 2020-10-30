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
  @JsonKey(disallowNullValue: true)
  final int id;

  RPCResponse(this.result, {this.id, this.error});
  factory RPCResponse.fromJson(Map<String, dynamic> json) =>
      _$RPCResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RPCResponseToJson(this);
}

typedef ResponseHandler = void Function(RPCResponse response);
typedef SubscriptionHandler = void Function(List<Object> result);

class GetBalanceResponse {
  GetBalanceResponse(this.confirmed, this.unconfirmed);

  int confirmed;
  int unconfirmed;
}

class JSONRPCWebsocket {
  WebSocket rpcSocket;
  Map<int, ResponseHandler> outstandingRequests = {};
  Map<String, SubscriptionHandler> subscriptions = {};
  var currentRequestId = 0;

  JSONRPCWebsocket();

  void _handleResponse(RPCResponse response) {
    final handler = outstandingRequests[response.id] ??
        (RPCResponse _response) {
          // TODO: Log error here - electrum misbehaving.
        };
    handler(response);
  }

  void _handleNotification(RPCRequest notification) {
    final handler = subscriptions[notification.method] ??
        (List<Object> params) {
          // TODO: Log error here - electrum misbehaving.
        };
    handler(notification.params);
  }

  Future<void> connect(Uri address) async {
    rpcSocket = await WebSocket.connect(address.toString());
    rpcSocket.listen((dynamic data) {
      Map<String, dynamic> jsonResult = jsonDecode(data);
      try {
        // Attempt to deserialize response
        final response = RPCResponse.fromJson(jsonResult);
        _handleResponse(response);
      } catch (_) {
        // Attempt to deserialize notifcation
        final notification = RPCRequest.fromJson(jsonResult);
        _handleNotification(notification);
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
      if (response.result != null) {
        completer.complete(response.result);
      } else {
        completer.completeError(response.error);
      }

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
