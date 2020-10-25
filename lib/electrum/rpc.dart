import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'rpc.g.dart';

@JsonSerializable()
class RpcRequest {
  @JsonKey(disallowNullValue: true)
  final String jsonrpc = "2.0";
  @JsonKey(disallowNullValue: true)
  final String method;
  @JsonKey(includeIfNull: true)
  final int id;
  @JsonKey(includeIfNull: true)
  final Object params; // nullable

  RpcRequest(this.method, {this.id, this.params});
  factory RpcRequest.fromJson(Map<String, dynamic> json) =>
      _$RpcRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RpcRequestToJson(this);
}

class RequestConverter extends Converter<Map<String, dynamic>, RpcRequest> {
  @override
  convert(input) {
    return RpcRequest.fromJson(input);
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
class RpcResponse {
  @JsonKey(disallowNullValue: true)
  final String jsonrpc = "2.0";
  @JsonKey(includeIfNull: true)
  final Object result;
  @JsonKey(includeIfNull: true)
  final Error error;
  @JsonKey(includeIfNull: true)
  final int id;

  RpcResponse(this.result, {this.id, this.error});
  factory RpcResponse.fromJson(Map<String, dynamic> json) =>
      _$RpcResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RpcResponseToJson(this);
}

typedef void ResponseHandler(RpcResponse data);

class ElectrumRPCChannel {
  WebSocket channel;
  Map<int, Completer<Object>> completers = new Map();
  var currentRequestId = 0;

  ElectrumRPCChannel();

  connect(Uri address) async {
    channel = await WebSocket.connect(address.toString());
    channel.listen((dynamic data) {
      Map<String, dynamic> jsonResult = jsonDecode(data);
      final response = RpcResponse.fromJson(jsonResult);
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

  Future<Object> sendMessage(String text) {
    final requestId = currentRequestId++;
    Completer<Object> completer = new Completer();

    completers[requestId] = completer;
    final payload =
        jsonEncode(RpcRequest("echo", id: requestId, params: [text]).toJson());
    channel.add(payload);

    return completer.future;
  }

  void dispose() {
    channel.close();
  }
}
