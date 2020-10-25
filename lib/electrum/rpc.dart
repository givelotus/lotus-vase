import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

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
  Map<int, ResponseHandler> callbacks = new Map();
  var currentRequestId = 0;

  ElectrumRPCChannel();

  connect(Uri address) async {
    channel = await WebSocket.connect(address.toString());
    channel.listen((dynamic data) {
      print('got something?');
      final text = data as String;
      if (!callbacks.containsKey(text)) {
        print('callback missing');
        return;
      }
      Map<String, dynamic> jsonResult = jsonDecode(data);
      print(jsonResult);
      final response = RpcResponse.fromJson(jsonResult);
      print(response);
      final callback = callbacks[response.id] ?? (data) {};
      callbacks.remove(response.id);
      callback(response);
    }, onError: (Object error) {
      print(error);
    }, onDone: () {
      print('done');
    }, cancelOnError: false);
  }

  void sendMessage(String text) {
    final requestId = currentRequestId++;
    callbacks[requestId] = (response) {
      print(requestId);
      print(response.id);
    };
    final payload =
        jsonEncode(RpcRequest("echo", id: requestId, params: [text]).toJson());
    print(payload);
    channel.add(payload);
  }

  void dispose() {
    channel.close();
  }
}
