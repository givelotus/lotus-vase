import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';

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
  final String? method;
  @JsonKey(includeIfNull: true)
  final int? id;
  @JsonKey(includeIfNull: true)
  final Object? params;

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
class Error implements Exception {
  @JsonKey(disallowNullValue: true)
  final int? code;
  @JsonKey(disallowNullValue: true)
  final String? message;
  @JsonKey(includeIfNull: true)
  final Object? data;

  Error(this.code, this.message, {this.data});
  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorToJson(this);

  @override
  String toString() {
    return message!;
  }
}

@JsonSerializable()
class RPCResponse {
  @JsonKey(disallowNullValue: true)
  final String jsonrpc = '2.0';
  @JsonKey(includeIfNull: true)
  final Object? result;
  @JsonKey(includeIfNull: true)
  final Error? error;
  @JsonKey(disallowNullValue: true)
  final int? id;

  RPCResponse(this.result, {this.id, this.error});
  factory RPCResponse.fromJson(Map<String, dynamic> json) =>
      _$RPCResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RPCResponseToJson(this);
}

typedef ResponseHandler = void Function(RPCResponse response);
typedef SubscriptionHandler = void Function(List<Object>? result);

class GetBalanceResponse {
  GetBalanceResponse(this.confirmed, this.unconfirmed);

  int? confirmed;
  int? unconfirmed;
}

typedef DisconnectHandler = void Function(dynamic err);

class JSONRPCWebsocket {
  WebSocket? _rpcSocket;
  Map<int, ResponseHandler> outstandingRequests = {};
  Map<String, SubscriptionHandler> subscriptions = {};
  var currentRequestId = 0;
  DisconnectHandler? disconnectHandler;

  JSONRPCWebsocket({this.disconnectHandler});

  void _handleResponse(RPCResponse response) {
    final handler = outstandingRequests[response.id!] ??
        (RPCResponse _response) {
          // TODO: Log error here - electrum misbehaving.
        };
    handler(response);
  }

  void _handleNotification(RPCRequest notification) {
    final handler = subscriptions[notification.method!] ??
        (List<Object>? params) {
          // TODO: Log error here - electrum misbehaving.
        };
    handler(notification.params as List<Object>?);
  }

  Future<void> connect(Uri address) async {
    final r = Random();
    final key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));

    final client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: 1000);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final request = await client.getUrl(address);
    request.headers.add('Connection', 'upgrade');
    request.headers.add('Upgrade', 'websocket');
    request.headers
        .add('Sec-WebSocket-Version', '13'); // insert the correct version here
    request.headers.add('Sec-WebSocket-Key', key);

    final response = await request.close();
    // todo check the status code, key etc
    final socket = await response.detachSocket();

    _rpcSocket = WebSocket.fromUpgradedSocket(
      socket,
      serverSide: false,
    );

    _rpcSocket!.listen((dynamic data) {
      Map<String, dynamic> jsonResult = jsonDecode(data);
      // Attempt to deserialize response
      final response = RPCResponse.fromJson(jsonResult);
      if (response.id == null) {
        final notification = RPCRequest.fromJson(jsonResult);
        return _handleNotification(notification);
      }
      return _handleResponse(response);
    }, onError: (Object error) {
      if (disconnectHandler != null) {
        disconnectHandler!(error);
      }
      for (final requestHandler in outstandingRequests.entries) {
        requestHandler.value(RPCResponse(null,
            error: Error(
                0, 'Disconnected from electrum while awaiting response')));
      }
    }, onDone: () {
      if (disconnectHandler != null) {
        disconnectHandler!(null);
      }
      for (final requestHandler in outstandingRequests.entries) {
        requestHandler.value(RPCResponse(null,
            error: Error(
                0, 'Disconnected from electrum while awaiting response')));
      }
      // Nothing to do?
    }, cancelOnError: false);
  }

  WebSocket? get rpcSocket {
    if (_rpcSocket == null) {
      throw Exception('Socket disconnected prematurely');
    }
    return _rpcSocket;
  }

  Future<dynamic> call(String method, Object params) {
    final requestId = currentRequestId++;
    final completer = Completer();

    outstandingRequests[requestId] = (RPCResponse response) {
      if (response.error == null) {
        completer.complete(response.result);
      } else {
        completer.completeError(response.error!);
      }

      outstandingRequests.remove(requestId);
    };

    final payload =
        jsonEncode(RPCRequest(method, id: requestId, params: params).toJson());
    rpcSocket!.add(payload);

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
    rpcSocket!.add(payload);

    return completer.future;
  }

  void dispose() {
    _rpcSocket!.close();
  }
}
