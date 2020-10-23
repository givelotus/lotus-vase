import 'dart:_http';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/io.dart';
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

class ResponseConverter extends Converter<Map<String, dynamic>, RpcResponse> {
  @override
  convert(input) {
    return RpcResponse.fromJson(input);
  }
}

class JsonRpcCodec extends Codec {
  @override
  Converter get decoder {
    return ResponseConverter();
  }

  @override
  Converter get encoder {
    return RequestConverter();
  }
}

class RpcChannel extends HtmlWebSocketChannel {
  RpcChannel.connect(url) : super.connect(url);

  RpcChannel connect(String address) {
    final socket = HtmlWebSocketChannel.connect(address);

    // Transform to JSON
    final jsonTransformer = StreamChannelTransformer.fromCodec(
        JsonCodec.withReviver((key, value) => null));
    final jsonSocket = socket.transform(jsonTransformer);

    // Transform to JSONRPC
    final rpcTransformer = StreamChannelTransformer.fromCodec(JsonRpcCodec());
    final rpcSocket = jsonSocket.transform(rpcTransformer);

    return rpcSocket;
  }
}
