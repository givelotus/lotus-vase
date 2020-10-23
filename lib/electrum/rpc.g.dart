// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RpcRequest _$RpcRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['method']);
  return RpcRequest(
    json['method'] as String,
    id: json['id'] as int,
    params: json['params'],
  );
}

Map<String, dynamic> _$RpcRequestToJson(RpcRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('method', instance.method);
  val['id'] = instance.id;
  val['params'] = instance.params;
  return val;
}

Error _$ErrorFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['code', 'message']);
  return Error(
    json['code'] as int,
    json['message'] as String,
    data: json['data'],
  );
}

Map<String, dynamic> _$ErrorToJson(Error instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('message', instance.message);
  val['data'] = instance.data;
  return val;
}

RpcResponse _$RpcResponseFromJson(Map<String, dynamic> json) {
  return RpcResponse(
    json['result'],
    id: json['id'] as int,
    error: json['error'] == null
        ? null
        : Error.fromJson(json['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RpcResponseToJson(RpcResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'error': instance.error,
      'id': instance.id,
    };
