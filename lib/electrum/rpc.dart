import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'rpc.g.dart';

@JsonSerializable()
class RPCRequest {
  @JsonKey(disallowNullValue: true)
  final String jsonrpc = "2.0";
  @JsonKey(disallowNullValue: true)
  final String method;
  @JsonKey(includeIfNull: true)
  final int id;
  @JsonKey(includeIfNull: true)
  final List params;

  RPCRequest(this.method, {this.id, this.params});
  factory RPCRequest.fromJson(Map<String, dynamic> json) =>
      _$RPCRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RPCRequestToJson(this);
}

class RequestConverter extends Converter<Map<String, dynamic>, RPCRequest> {
  @override
  convert(input) {
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
  final String jsonrpc = "2.0";
  @JsonKey(includeIfNull: true)
  final Object result;
  @JsonKey(includeIfNull: true)
  final Error error;
  @JsonKey(includeIfNull: true)
  final int id;

  RPCResponse(this.result, {this.id, this.error});
  factory RPCResponse.fromJson(Map<String, dynamic> json) =>
      _$RPCResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RPCResponseToJson(this);
}

typedef void ResponseHandler(RPCResponse data);

class JSONRPCWebsocket {
  WebSocket channel;
  Map<int, Completer<Object>> completers = new Map();
  var currentRequestId = 0;

  JSONRPCWebsocket();

  connect(Uri address) async {
    channel = await WebSocket.connect(address.toString());
    channel.listen((dynamic data) {
      Map<String, dynamic> jsonResult = jsonDecode(data);
      final response = RPCResponse.fromJson(jsonResult);
      if (!completers.containsKey(response.id)) {
        print('Missing completion');
        return;
      }
      final completer = completers[response.id] ?? new Completer();
      completers.remove(response.id);
      completer.complete(response.result);
    }, onError: (Object error) {
      print(error);
    }, onDone: () {
      print('done');
    }, cancelOnError: false);
  }

  Future<Object> sendMessage(String method, List<dynamic> params) {
    final requestId = currentRequestId++;
    Completer completer = new Completer();

    completers[requestId] = completer;
    final payload =
        jsonEncode(RPCRequest(method, id: requestId, params: params).toJson());
    channel.add(payload);

    return completer.future;
  }

  void dispose() {
    channel.close();
  }
}
