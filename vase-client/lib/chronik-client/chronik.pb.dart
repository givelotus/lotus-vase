///
//  Generated code. Do not modify.
//  source: chronik.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chronik.pbenum.dart';

export 'chronik.pbenum.dart';

class ValidateUtxoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ValidateUtxoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..pc<OutPoint>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outpoints', $pb.PbFieldType.PM, subBuilder: OutPoint.create)
    ..hasRequiredFields = false
  ;

  ValidateUtxoRequest._() : super();
  factory ValidateUtxoRequest({
    $core.Iterable<OutPoint>? outpoints,
  }) {
    final _result = create();
    if (outpoints != null) {
      _result.outpoints.addAll(outpoints);
    }
    return _result;
  }
  factory ValidateUtxoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateUtxoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateUtxoRequest clone() => ValidateUtxoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateUtxoRequest copyWith(void Function(ValidateUtxoRequest) updates) => super.copyWith((message) => updates(message as ValidateUtxoRequest)) as ValidateUtxoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ValidateUtxoRequest create() => ValidateUtxoRequest._();
  ValidateUtxoRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateUtxoRequest> createRepeated() => $pb.PbList<ValidateUtxoRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateUtxoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateUtxoRequest>(create);
  static ValidateUtxoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<OutPoint> get outpoints => $_getList(0);
}

class ValidateUtxoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ValidateUtxoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..pc<UtxoState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'utxoStates', $pb.PbFieldType.PM, subBuilder: UtxoState.create)
    ..hasRequiredFields = false
  ;

  ValidateUtxoResponse._() : super();
  factory ValidateUtxoResponse({
    $core.Iterable<UtxoState>? utxoStates,
  }) {
    final _result = create();
    if (utxoStates != null) {
      _result.utxoStates.addAll(utxoStates);
    }
    return _result;
  }
  factory ValidateUtxoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateUtxoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateUtxoResponse clone() => ValidateUtxoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateUtxoResponse copyWith(void Function(ValidateUtxoResponse) updates) => super.copyWith((message) => updates(message as ValidateUtxoResponse)) as ValidateUtxoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ValidateUtxoResponse create() => ValidateUtxoResponse._();
  ValidateUtxoResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateUtxoResponse> createRepeated() => $pb.PbList<ValidateUtxoResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateUtxoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateUtxoResponse>(create);
  static ValidateUtxoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<UtxoState> get utxoStates => $_getList(0);
}

class BroadcastTxRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastTxRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawTx', $pb.PbFieldType.OY)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skipSlpCheck')
    ..hasRequiredFields = false
  ;

  BroadcastTxRequest._() : super();
  factory BroadcastTxRequest({
    $core.List<$core.int>? rawTx,
    $core.bool? skipSlpCheck,
  }) {
    final _result = create();
    if (rawTx != null) {
      _result.rawTx = rawTx;
    }
    if (skipSlpCheck != null) {
      _result.skipSlpCheck = skipSlpCheck;
    }
    return _result;
  }
  factory BroadcastTxRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastTxRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastTxRequest clone() => BroadcastTxRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastTxRequest copyWith(void Function(BroadcastTxRequest) updates) => super.copyWith((message) => updates(message as BroadcastTxRequest)) as BroadcastTxRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastTxRequest create() => BroadcastTxRequest._();
  BroadcastTxRequest createEmptyInstance() => create();
  static $pb.PbList<BroadcastTxRequest> createRepeated() => $pb.PbList<BroadcastTxRequest>();
  @$core.pragma('dart2js:noInline')
  static BroadcastTxRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastTxRequest>(create);
  static BroadcastTxRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get rawTx => $_getN(0);
  @$pb.TagNumber(1)
  set rawTx($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRawTx() => $_has(0);
  @$pb.TagNumber(1)
  void clearRawTx() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get skipSlpCheck => $_getBF(1);
  @$pb.TagNumber(2)
  set skipSlpCheck($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSkipSlpCheck() => $_has(1);
  @$pb.TagNumber(2)
  void clearSkipSlpCheck() => clearField(2);
}

class BroadcastTxResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastTxResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  BroadcastTxResponse._() : super();
  factory BroadcastTxResponse({
    $core.List<$core.int>? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory BroadcastTxResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastTxResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastTxResponse clone() => BroadcastTxResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastTxResponse copyWith(void Function(BroadcastTxResponse) updates) => super.copyWith((message) => updates(message as BroadcastTxResponse)) as BroadcastTxResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastTxResponse create() => BroadcastTxResponse._();
  BroadcastTxResponse createEmptyInstance() => create();
  static $pb.PbList<BroadcastTxResponse> createRepeated() => $pb.PbList<BroadcastTxResponse>();
  @$core.pragma('dart2js:noInline')
  static BroadcastTxResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastTxResponse>(create);
  static BroadcastTxResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

class BroadcastTxsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastTxsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawTxs', $pb.PbFieldType.PY)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skipSlpCheck')
    ..hasRequiredFields = false
  ;

  BroadcastTxsRequest._() : super();
  factory BroadcastTxsRequest({
    $core.Iterable<$core.List<$core.int>>? rawTxs,
    $core.bool? skipSlpCheck,
  }) {
    final _result = create();
    if (rawTxs != null) {
      _result.rawTxs.addAll(rawTxs);
    }
    if (skipSlpCheck != null) {
      _result.skipSlpCheck = skipSlpCheck;
    }
    return _result;
  }
  factory BroadcastTxsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastTxsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastTxsRequest clone() => BroadcastTxsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastTxsRequest copyWith(void Function(BroadcastTxsRequest) updates) => super.copyWith((message) => updates(message as BroadcastTxsRequest)) as BroadcastTxsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastTxsRequest create() => BroadcastTxsRequest._();
  BroadcastTxsRequest createEmptyInstance() => create();
  static $pb.PbList<BroadcastTxsRequest> createRepeated() => $pb.PbList<BroadcastTxsRequest>();
  @$core.pragma('dart2js:noInline')
  static BroadcastTxsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastTxsRequest>(create);
  static BroadcastTxsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.List<$core.int>> get rawTxs => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get skipSlpCheck => $_getBF(1);
  @$pb.TagNumber(2)
  set skipSlpCheck($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSkipSlpCheck() => $_has(1);
  @$pb.TagNumber(2)
  void clearSkipSlpCheck() => clearField(2);
}

class BroadcastTxsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BroadcastTxsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txids', $pb.PbFieldType.PY)
    ..hasRequiredFields = false
  ;

  BroadcastTxsResponse._() : super();
  factory BroadcastTxsResponse({
    $core.Iterable<$core.List<$core.int>>? txids,
  }) {
    final _result = create();
    if (txids != null) {
      _result.txids.addAll(txids);
    }
    return _result;
  }
  factory BroadcastTxsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BroadcastTxsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BroadcastTxsResponse clone() => BroadcastTxsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BroadcastTxsResponse copyWith(void Function(BroadcastTxsResponse) updates) => super.copyWith((message) => updates(message as BroadcastTxsResponse)) as BroadcastTxsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BroadcastTxsResponse create() => BroadcastTxsResponse._();
  BroadcastTxsResponse createEmptyInstance() => create();
  static $pb.PbList<BroadcastTxsResponse> createRepeated() => $pb.PbList<BroadcastTxsResponse>();
  @$core.pragma('dart2js:noInline')
  static BroadcastTxsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BroadcastTxsResponse>(create);
  static BroadcastTxsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.List<$core.int>> get txids => $_getList(0);
}

class BlockchainInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BlockchainInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tipHash', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tipHeight', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  BlockchainInfo._() : super();
  factory BlockchainInfo({
    $core.List<$core.int>? tipHash,
    $core.int? tipHeight,
  }) {
    final _result = create();
    if (tipHash != null) {
      _result.tipHash = tipHash;
    }
    if (tipHeight != null) {
      _result.tipHeight = tipHeight;
    }
    return _result;
  }
  factory BlockchainInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockchainInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockchainInfo clone() => BlockchainInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockchainInfo copyWith(void Function(BlockchainInfo) updates) => super.copyWith((message) => updates(message as BlockchainInfo)) as BlockchainInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BlockchainInfo create() => BlockchainInfo._();
  BlockchainInfo createEmptyInstance() => create();
  static $pb.PbList<BlockchainInfo> createRepeated() => $pb.PbList<BlockchainInfo>();
  @$core.pragma('dart2js:noInline')
  static BlockchainInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockchainInfo>(create);
  static BlockchainInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get tipHash => $_getN(0);
  @$pb.TagNumber(1)
  set tipHash($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTipHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearTipHash() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get tipHeight => $_getIZ(1);
  @$pb.TagNumber(2)
  set tipHeight($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTipHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearTipHeight() => clearField(2);
}

class Tx extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Tx', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..pc<TxInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'inputs', $pb.PbFieldType.PM, subBuilder: TxInput.create)
    ..pc<TxOutput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: TxOutput.create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lockTime', $pb.PbFieldType.OU3)
    ..aOM<SlpTxData>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpTxData', subBuilder: SlpTxData.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpErrorMsg')
    ..aOM<BlockMetadata>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'block', subBuilder: BlockMetadata.create)
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeFirstSeen')
    ..e<Network>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'network', $pb.PbFieldType.OE, defaultOrMaker: Network.BCH, valueOf: Network.valueOf, enumValues: Network.values)
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'size', $pb.PbFieldType.OU3)
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isCoinbase')
    ..hasRequiredFields = false
  ;

  Tx._() : super();
  factory Tx({
    $core.List<$core.int>? txid,
    $core.int? version,
    $core.Iterable<TxInput>? inputs,
    $core.Iterable<TxOutput>? outputs,
    $core.int? lockTime,
    SlpTxData? slpTxData,
    $core.String? slpErrorMsg,
    BlockMetadata? block,
    $fixnum.Int64? timeFirstSeen,
    Network? network,
    $core.int? size,
    $core.bool? isCoinbase,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (version != null) {
      _result.version = version;
    }
    if (inputs != null) {
      _result.inputs.addAll(inputs);
    }
    if (outputs != null) {
      _result.outputs.addAll(outputs);
    }
    if (lockTime != null) {
      _result.lockTime = lockTime;
    }
    if (slpTxData != null) {
      _result.slpTxData = slpTxData;
    }
    if (slpErrorMsg != null) {
      _result.slpErrorMsg = slpErrorMsg;
    }
    if (block != null) {
      _result.block = block;
    }
    if (timeFirstSeen != null) {
      _result.timeFirstSeen = timeFirstSeen;
    }
    if (network != null) {
      _result.network = network;
    }
    if (size != null) {
      _result.size = size;
    }
    if (isCoinbase != null) {
      _result.isCoinbase = isCoinbase;
    }
    return _result;
  }
  factory Tx.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tx.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Tx clone() => Tx()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Tx copyWith(void Function(Tx) updates) => super.copyWith((message) => updates(message as Tx)) as Tx; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Tx create() => Tx._();
  Tx createEmptyInstance() => create();
  static $pb.PbList<Tx> createRepeated() => $pb.PbList<Tx>();
  @$core.pragma('dart2js:noInline')
  static Tx getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tx>(create);
  static Tx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<TxInput> get inputs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<TxOutput> get outputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get lockTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set lockTime($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLockTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearLockTime() => clearField(5);

  @$pb.TagNumber(6)
  SlpTxData get slpTxData => $_getN(5);
  @$pb.TagNumber(6)
  set slpTxData(SlpTxData v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSlpTxData() => $_has(5);
  @$pb.TagNumber(6)
  void clearSlpTxData() => clearField(6);
  @$pb.TagNumber(6)
  SlpTxData ensureSlpTxData() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get slpErrorMsg => $_getSZ(6);
  @$pb.TagNumber(7)
  set slpErrorMsg($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSlpErrorMsg() => $_has(6);
  @$pb.TagNumber(7)
  void clearSlpErrorMsg() => clearField(7);

  @$pb.TagNumber(8)
  BlockMetadata get block => $_getN(7);
  @$pb.TagNumber(8)
  set block(BlockMetadata v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasBlock() => $_has(7);
  @$pb.TagNumber(8)
  void clearBlock() => clearField(8);
  @$pb.TagNumber(8)
  BlockMetadata ensureBlock() => $_ensure(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get timeFirstSeen => $_getI64(8);
  @$pb.TagNumber(9)
  set timeFirstSeen($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTimeFirstSeen() => $_has(8);
  @$pb.TagNumber(9)
  void clearTimeFirstSeen() => clearField(9);

  @$pb.TagNumber(10)
  Network get network => $_getN(9);
  @$pb.TagNumber(10)
  set network(Network v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasNetwork() => $_has(9);
  @$pb.TagNumber(10)
  void clearNetwork() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get size => $_getIZ(10);
  @$pb.TagNumber(11)
  set size($core.int v) { $_setUnsignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSize() => $_has(10);
  @$pb.TagNumber(11)
  void clearSize() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get isCoinbase => $_getBF(11);
  @$pb.TagNumber(12)
  set isCoinbase($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasIsCoinbase() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsCoinbase() => clearField(12);
}

class Utxo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Utxo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOM<OutPoint>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outpoint', subBuilder: OutPoint.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockHeight', $pb.PbFieldType.O3)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isCoinbase')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..aOM<SlpMeta>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpMeta', subBuilder: SlpMeta.create)
    ..aOM<SlpToken>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpToken', subBuilder: SlpToken.create)
    ..e<Network>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'network', $pb.PbFieldType.OE, defaultOrMaker: Network.BCH, valueOf: Network.valueOf, enumValues: Network.values)
    ..hasRequiredFields = false
  ;

  Utxo._() : super();
  factory Utxo({
    OutPoint? outpoint,
    $core.int? blockHeight,
    $core.bool? isCoinbase,
    $fixnum.Int64? value,
    SlpMeta? slpMeta,
    SlpToken? slpToken,
    Network? network,
  }) {
    final _result = create();
    if (outpoint != null) {
      _result.outpoint = outpoint;
    }
    if (blockHeight != null) {
      _result.blockHeight = blockHeight;
    }
    if (isCoinbase != null) {
      _result.isCoinbase = isCoinbase;
    }
    if (value != null) {
      _result.value = value;
    }
    if (slpMeta != null) {
      _result.slpMeta = slpMeta;
    }
    if (slpToken != null) {
      _result.slpToken = slpToken;
    }
    if (network != null) {
      _result.network = network;
    }
    return _result;
  }
  factory Utxo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Utxo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Utxo clone() => Utxo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Utxo copyWith(void Function(Utxo) updates) => super.copyWith((message) => updates(message as Utxo)) as Utxo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Utxo create() => Utxo._();
  Utxo createEmptyInstance() => create();
  static $pb.PbList<Utxo> createRepeated() => $pb.PbList<Utxo>();
  @$core.pragma('dart2js:noInline')
  static Utxo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Utxo>(create);
  static Utxo? _defaultInstance;

  @$pb.TagNumber(1)
  OutPoint get outpoint => $_getN(0);
  @$pb.TagNumber(1)
  set outpoint(OutPoint v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOutpoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutpoint() => clearField(1);
  @$pb.TagNumber(1)
  OutPoint ensureOutpoint() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get blockHeight => $_getIZ(1);
  @$pb.TagNumber(2)
  set blockHeight($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBlockHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlockHeight() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isCoinbase => $_getBF(2);
  @$pb.TagNumber(3)
  set isCoinbase($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsCoinbase() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsCoinbase() => clearField(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get value => $_getI64(3);
  @$pb.TagNumber(5)
  set value($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(5)
  void clearValue() => clearField(5);

  @$pb.TagNumber(6)
  SlpMeta get slpMeta => $_getN(4);
  @$pb.TagNumber(6)
  set slpMeta(SlpMeta v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSlpMeta() => $_has(4);
  @$pb.TagNumber(6)
  void clearSlpMeta() => clearField(6);
  @$pb.TagNumber(6)
  SlpMeta ensureSlpMeta() => $_ensure(4);

  @$pb.TagNumber(7)
  SlpToken get slpToken => $_getN(5);
  @$pb.TagNumber(7)
  set slpToken(SlpToken v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasSlpToken() => $_has(5);
  @$pb.TagNumber(7)
  void clearSlpToken() => clearField(7);
  @$pb.TagNumber(7)
  SlpToken ensureSlpToken() => $_ensure(5);

  @$pb.TagNumber(9)
  Network get network => $_getN(6);
  @$pb.TagNumber(9)
  set network(Network v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasNetwork() => $_has(6);
  @$pb.TagNumber(9)
  void clearNetwork() => clearField(9);
}

class Token extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Token', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOM<SlpTxData>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpTxData', subBuilder: SlpTxData.create)
    ..aOM<TokenStats>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenStats', subBuilder: TokenStats.create)
    ..aOM<BlockMetadata>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'block', subBuilder: BlockMetadata.create)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeFirstSeen')
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'initialTokenQuantity', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'containsBaton')
    ..e<Network>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'network', $pb.PbFieldType.OE, defaultOrMaker: Network.BCH, valueOf: Network.valueOf, enumValues: Network.values)
    ..hasRequiredFields = false
  ;

  Token._() : super();
  factory Token({
    SlpTxData? slpTxData,
    TokenStats? tokenStats,
    BlockMetadata? block,
    $fixnum.Int64? timeFirstSeen,
    $fixnum.Int64? initialTokenQuantity,
    $core.bool? containsBaton,
    Network? network,
  }) {
    final _result = create();
    if (slpTxData != null) {
      _result.slpTxData = slpTxData;
    }
    if (tokenStats != null) {
      _result.tokenStats = tokenStats;
    }
    if (block != null) {
      _result.block = block;
    }
    if (timeFirstSeen != null) {
      _result.timeFirstSeen = timeFirstSeen;
    }
    if (initialTokenQuantity != null) {
      _result.initialTokenQuantity = initialTokenQuantity;
    }
    if (containsBaton != null) {
      _result.containsBaton = containsBaton;
    }
    if (network != null) {
      _result.network = network;
    }
    return _result;
  }
  factory Token.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Token.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Token clone() => Token()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Token copyWith(void Function(Token) updates) => super.copyWith((message) => updates(message as Token)) as Token; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Token create() => Token._();
  Token createEmptyInstance() => create();
  static $pb.PbList<Token> createRepeated() => $pb.PbList<Token>();
  @$core.pragma('dart2js:noInline')
  static Token getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Token>(create);
  static Token? _defaultInstance;

  @$pb.TagNumber(1)
  SlpTxData get slpTxData => $_getN(0);
  @$pb.TagNumber(1)
  set slpTxData(SlpTxData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSlpTxData() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlpTxData() => clearField(1);
  @$pb.TagNumber(1)
  SlpTxData ensureSlpTxData() => $_ensure(0);

  @$pb.TagNumber(2)
  TokenStats get tokenStats => $_getN(1);
  @$pb.TagNumber(2)
  set tokenStats(TokenStats v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTokenStats() => $_has(1);
  @$pb.TagNumber(2)
  void clearTokenStats() => clearField(2);
  @$pb.TagNumber(2)
  TokenStats ensureTokenStats() => $_ensure(1);

  @$pb.TagNumber(3)
  BlockMetadata get block => $_getN(2);
  @$pb.TagNumber(3)
  set block(BlockMetadata v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlock() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlock() => clearField(3);
  @$pb.TagNumber(3)
  BlockMetadata ensureBlock() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timeFirstSeen => $_getI64(3);
  @$pb.TagNumber(4)
  set timeFirstSeen($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimeFirstSeen() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeFirstSeen() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get initialTokenQuantity => $_getI64(4);
  @$pb.TagNumber(5)
  set initialTokenQuantity($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasInitialTokenQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearInitialTokenQuantity() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get containsBaton => $_getBF(5);
  @$pb.TagNumber(6)
  set containsBaton($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasContainsBaton() => $_has(5);
  @$pb.TagNumber(6)
  void clearContainsBaton() => clearField(6);

  @$pb.TagNumber(7)
  Network get network => $_getN(6);
  @$pb.TagNumber(7)
  set network(Network v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasNetwork() => $_has(6);
  @$pb.TagNumber(7)
  void clearNetwork() => clearField(7);
}

class BlockInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BlockInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hash', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prevHash', $pb.PbFieldType.OY)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nBits', $pb.PbFieldType.OU3)
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..a<$fixnum.Int64>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockSize', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numTxs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numInputs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numOutputs', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sumInputSats')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sumCoinbaseOutputSats')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sumNormalOutputSats')
    ..aInt64(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sumBurnedSats')
    ..hasRequiredFields = false
  ;

  BlockInfo._() : super();
  factory BlockInfo({
    $core.List<$core.int>? hash,
    $core.List<$core.int>? prevHash,
    $core.int? height,
    $core.int? nBits,
    $fixnum.Int64? timestamp,
    $fixnum.Int64? blockSize,
    $fixnum.Int64? numTxs,
    $fixnum.Int64? numInputs,
    $fixnum.Int64? numOutputs,
    $fixnum.Int64? sumInputSats,
    $fixnum.Int64? sumCoinbaseOutputSats,
    $fixnum.Int64? sumNormalOutputSats,
    $fixnum.Int64? sumBurnedSats,
  }) {
    final _result = create();
    if (hash != null) {
      _result.hash = hash;
    }
    if (prevHash != null) {
      _result.prevHash = prevHash;
    }
    if (height != null) {
      _result.height = height;
    }
    if (nBits != null) {
      _result.nBits = nBits;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (blockSize != null) {
      _result.blockSize = blockSize;
    }
    if (numTxs != null) {
      _result.numTxs = numTxs;
    }
    if (numInputs != null) {
      _result.numInputs = numInputs;
    }
    if (numOutputs != null) {
      _result.numOutputs = numOutputs;
    }
    if (sumInputSats != null) {
      _result.sumInputSats = sumInputSats;
    }
    if (sumCoinbaseOutputSats != null) {
      _result.sumCoinbaseOutputSats = sumCoinbaseOutputSats;
    }
    if (sumNormalOutputSats != null) {
      _result.sumNormalOutputSats = sumNormalOutputSats;
    }
    if (sumBurnedSats != null) {
      _result.sumBurnedSats = sumBurnedSats;
    }
    return _result;
  }
  factory BlockInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockInfo clone() => BlockInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockInfo copyWith(void Function(BlockInfo) updates) => super.copyWith((message) => updates(message as BlockInfo)) as BlockInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BlockInfo create() => BlockInfo._();
  BlockInfo createEmptyInstance() => create();
  static $pb.PbList<BlockInfo> createRepeated() => $pb.PbList<BlockInfo>();
  @$core.pragma('dart2js:noInline')
  static BlockInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockInfo>(create);
  static BlockInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get prevHash => $_getN(1);
  @$pb.TagNumber(2)
  set prevHash($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrevHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrevHash() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(3)
  set height($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get nBits => $_getIZ(3);
  @$pb.TagNumber(4)
  set nBits($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNBits() => $_has(3);
  @$pb.TagNumber(4)
  void clearNBits() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(4);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get blockSize => $_getI64(5);
  @$pb.TagNumber(6)
  set blockSize($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasBlockSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlockSize() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get numTxs => $_getI64(6);
  @$pb.TagNumber(7)
  set numTxs($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasNumTxs() => $_has(6);
  @$pb.TagNumber(7)
  void clearNumTxs() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get numInputs => $_getI64(7);
  @$pb.TagNumber(8)
  set numInputs($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasNumInputs() => $_has(7);
  @$pb.TagNumber(8)
  void clearNumInputs() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get numOutputs => $_getI64(8);
  @$pb.TagNumber(9)
  set numOutputs($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasNumOutputs() => $_has(8);
  @$pb.TagNumber(9)
  void clearNumOutputs() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get sumInputSats => $_getI64(9);
  @$pb.TagNumber(10)
  set sumInputSats($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSumInputSats() => $_has(9);
  @$pb.TagNumber(10)
  void clearSumInputSats() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get sumCoinbaseOutputSats => $_getI64(10);
  @$pb.TagNumber(11)
  set sumCoinbaseOutputSats($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSumCoinbaseOutputSats() => $_has(10);
  @$pb.TagNumber(11)
  void clearSumCoinbaseOutputSats() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get sumNormalOutputSats => $_getI64(11);
  @$pb.TagNumber(12)
  set sumNormalOutputSats($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSumNormalOutputSats() => $_has(11);
  @$pb.TagNumber(12)
  void clearSumNormalOutputSats() => clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get sumBurnedSats => $_getI64(12);
  @$pb.TagNumber(13)
  set sumBurnedSats($fixnum.Int64 v) { $_setInt64(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasSumBurnedSats() => $_has(12);
  @$pb.TagNumber(13)
  void clearSumBurnedSats() => clearField(13);
}

class BlockDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BlockDetails', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'merkleRoot', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nonce', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'medianTimestamp')
    ..hasRequiredFields = false
  ;

  BlockDetails._() : super();
  factory BlockDetails({
    $core.int? version,
    $core.List<$core.int>? merkleRoot,
    $fixnum.Int64? nonce,
    $fixnum.Int64? medianTimestamp,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    if (merkleRoot != null) {
      _result.merkleRoot = merkleRoot;
    }
    if (nonce != null) {
      _result.nonce = nonce;
    }
    if (medianTimestamp != null) {
      _result.medianTimestamp = medianTimestamp;
    }
    return _result;
  }
  factory BlockDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockDetails clone() => BlockDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockDetails copyWith(void Function(BlockDetails) updates) => super.copyWith((message) => updates(message as BlockDetails)) as BlockDetails; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BlockDetails create() => BlockDetails._();
  BlockDetails createEmptyInstance() => create();
  static $pb.PbList<BlockDetails> createRepeated() => $pb.PbList<BlockDetails>();
  @$core.pragma('dart2js:noInline')
  static BlockDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockDetails>(create);
  static BlockDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get merkleRoot => $_getN(1);
  @$pb.TagNumber(2)
  set merkleRoot($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMerkleRoot() => $_has(1);
  @$pb.TagNumber(2)
  void clearMerkleRoot() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nonce => $_getI64(2);
  @$pb.TagNumber(3)
  set nonce($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNonce() => $_has(2);
  @$pb.TagNumber(3)
  void clearNonce() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get medianTimestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set medianTimestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMedianTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearMedianTimestamp() => clearField(4);
}

class Block extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Block', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOM<BlockInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockInfo', subBuilder: BlockInfo.create)
    ..pc<Tx>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txs', $pb.PbFieldType.PM, subBuilder: Tx.create)
    ..aOM<BlockDetails>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockDetails', subBuilder: BlockDetails.create)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rawHeader', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  Block._() : super();
  factory Block({
    BlockInfo? blockInfo,
    $core.Iterable<Tx>? txs,
    BlockDetails? blockDetails,
    $core.List<$core.int>? rawHeader,
  }) {
    final _result = create();
    if (blockInfo != null) {
      _result.blockInfo = blockInfo;
    }
    if (txs != null) {
      _result.txs.addAll(txs);
    }
    if (blockDetails != null) {
      _result.blockDetails = blockDetails;
    }
    if (rawHeader != null) {
      _result.rawHeader = rawHeader;
    }
    return _result;
  }
  factory Block.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Block.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Block clone() => Block()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Block copyWith(void Function(Block) updates) => super.copyWith((message) => updates(message as Block)) as Block; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Block create() => Block._();
  Block createEmptyInstance() => create();
  static $pb.PbList<Block> createRepeated() => $pb.PbList<Block>();
  @$core.pragma('dart2js:noInline')
  static Block getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Block>(create);
  static Block? _defaultInstance;

  @$pb.TagNumber(1)
  BlockInfo get blockInfo => $_getN(0);
  @$pb.TagNumber(1)
  set blockInfo(BlockInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlockInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockInfo() => clearField(1);
  @$pb.TagNumber(1)
  BlockInfo ensureBlockInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Tx> get txs => $_getList(1);

  @$pb.TagNumber(3)
  BlockDetails get blockDetails => $_getN(2);
  @$pb.TagNumber(3)
  set blockDetails(BlockDetails v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlockDetails() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlockDetails() => clearField(3);
  @$pb.TagNumber(3)
  BlockDetails ensureBlockDetails() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<$core.int> get rawHeader => $_getN(3);
  @$pb.TagNumber(4)
  set rawHeader($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRawHeader() => $_has(3);
  @$pb.TagNumber(4)
  void clearRawHeader() => clearField(4);
}

class ScriptUtxos extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScriptUtxos', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputScript', $pb.PbFieldType.OY)
    ..pc<Utxo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'utxos', $pb.PbFieldType.PM, subBuilder: Utxo.create)
    ..hasRequiredFields = false
  ;

  ScriptUtxos._() : super();
  factory ScriptUtxos({
    $core.List<$core.int>? outputScript,
    $core.Iterable<Utxo>? utxos,
  }) {
    final _result = create();
    if (outputScript != null) {
      _result.outputScript = outputScript;
    }
    if (utxos != null) {
      _result.utxos.addAll(utxos);
    }
    return _result;
  }
  factory ScriptUtxos.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScriptUtxos.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScriptUtxos clone() => ScriptUtxos()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScriptUtxos copyWith(void Function(ScriptUtxos) updates) => super.copyWith((message) => updates(message as ScriptUtxos)) as ScriptUtxos; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScriptUtxos create() => ScriptUtxos._();
  ScriptUtxos createEmptyInstance() => create();
  static $pb.PbList<ScriptUtxos> createRepeated() => $pb.PbList<ScriptUtxos>();
  @$core.pragma('dart2js:noInline')
  static ScriptUtxos getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScriptUtxos>(create);
  static ScriptUtxos? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get outputScript => $_getN(0);
  @$pb.TagNumber(1)
  set outputScript($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOutputScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutputScript() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Utxo> get utxos => $_getList(1);
}

class TxHistoryPage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TxHistoryPage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..pc<Tx>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txs', $pb.PbFieldType.PM, subBuilder: Tx.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numPages', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  TxHistoryPage._() : super();
  factory TxHistoryPage({
    $core.Iterable<Tx>? txs,
    $core.int? numPages,
  }) {
    final _result = create();
    if (txs != null) {
      _result.txs.addAll(txs);
    }
    if (numPages != null) {
      _result.numPages = numPages;
    }
    return _result;
  }
  factory TxHistoryPage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TxHistoryPage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TxHistoryPage clone() => TxHistoryPage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TxHistoryPage copyWith(void Function(TxHistoryPage) updates) => super.copyWith((message) => updates(message as TxHistoryPage)) as TxHistoryPage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TxHistoryPage create() => TxHistoryPage._();
  TxHistoryPage createEmptyInstance() => create();
  static $pb.PbList<TxHistoryPage> createRepeated() => $pb.PbList<TxHistoryPage>();
  @$core.pragma('dart2js:noInline')
  static TxHistoryPage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TxHistoryPage>(create);
  static TxHistoryPage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Tx> get txs => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get numPages => $_getIZ(1);
  @$pb.TagNumber(2)
  set numPages($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNumPages() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumPages() => clearField(2);
}

class Utxos extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Utxos', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..pc<ScriptUtxos>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptUtxos', $pb.PbFieldType.PM, subBuilder: ScriptUtxos.create)
    ..hasRequiredFields = false
  ;

  Utxos._() : super();
  factory Utxos({
    $core.Iterable<ScriptUtxos>? scriptUtxos,
  }) {
    final _result = create();
    if (scriptUtxos != null) {
      _result.scriptUtxos.addAll(scriptUtxos);
    }
    return _result;
  }
  factory Utxos.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Utxos.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Utxos clone() => Utxos()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Utxos copyWith(void Function(Utxos) updates) => super.copyWith((message) => updates(message as Utxos)) as Utxos; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Utxos create() => Utxos._();
  Utxos createEmptyInstance() => create();
  static $pb.PbList<Utxos> createRepeated() => $pb.PbList<Utxos>();
  @$core.pragma('dart2js:noInline')
  static Utxos getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Utxos>(create);
  static Utxos? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ScriptUtxos> get scriptUtxos => $_getList(0);
}

class Blocks extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Blocks', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..pc<BlockInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blocks', $pb.PbFieldType.PM, subBuilder: BlockInfo.create)
    ..hasRequiredFields = false
  ;

  Blocks._() : super();
  factory Blocks({
    $core.Iterable<BlockInfo>? blocks,
  }) {
    final _result = create();
    if (blocks != null) {
      _result.blocks.addAll(blocks);
    }
    return _result;
  }
  factory Blocks.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Blocks.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Blocks clone() => Blocks()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Blocks copyWith(void Function(Blocks) updates) => super.copyWith((message) => updates(message as Blocks)) as Blocks; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Blocks create() => Blocks._();
  Blocks createEmptyInstance() => create();
  static $pb.PbList<Blocks> createRepeated() => $pb.PbList<Blocks>();
  @$core.pragma('dart2js:noInline')
  static Blocks getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Blocks>(create);
  static Blocks? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<BlockInfo> get blocks => $_getList(0);
}

class SlpTxData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SlpTxData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOM<SlpMeta>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpMeta', subBuilder: SlpMeta.create)
    ..aOM<SlpGenesisInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'genesisInfo', subBuilder: SlpGenesisInfo.create)
    ..hasRequiredFields = false
  ;

  SlpTxData._() : super();
  factory SlpTxData({
    SlpMeta? slpMeta,
    SlpGenesisInfo? genesisInfo,
  }) {
    final _result = create();
    if (slpMeta != null) {
      _result.slpMeta = slpMeta;
    }
    if (genesisInfo != null) {
      _result.genesisInfo = genesisInfo;
    }
    return _result;
  }
  factory SlpTxData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlpTxData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlpTxData clone() => SlpTxData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlpTxData copyWith(void Function(SlpTxData) updates) => super.copyWith((message) => updates(message as SlpTxData)) as SlpTxData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SlpTxData create() => SlpTxData._();
  SlpTxData createEmptyInstance() => create();
  static $pb.PbList<SlpTxData> createRepeated() => $pb.PbList<SlpTxData>();
  @$core.pragma('dart2js:noInline')
  static SlpTxData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlpTxData>(create);
  static SlpTxData? _defaultInstance;

  @$pb.TagNumber(1)
  SlpMeta get slpMeta => $_getN(0);
  @$pb.TagNumber(1)
  set slpMeta(SlpMeta v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSlpMeta() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlpMeta() => clearField(1);
  @$pb.TagNumber(1)
  SlpMeta ensureSlpMeta() => $_ensure(0);

  @$pb.TagNumber(2)
  SlpGenesisInfo get genesisInfo => $_getN(1);
  @$pb.TagNumber(2)
  set genesisInfo(SlpGenesisInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasGenesisInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearGenesisInfo() => clearField(2);
  @$pb.TagNumber(2)
  SlpGenesisInfo ensureGenesisInfo() => $_ensure(1);
}

class SlpMeta extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SlpMeta', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..e<SlpTokenType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenType', $pb.PbFieldType.OE, defaultOrMaker: SlpTokenType.FUNGIBLE, valueOf: SlpTokenType.valueOf, enumValues: SlpTokenType.values)
    ..e<SlpTxType>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txType', $pb.PbFieldType.OE, defaultOrMaker: SlpTxType.GENESIS, valueOf: SlpTxType.valueOf, enumValues: SlpTxType.values)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenId', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupTokenId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  SlpMeta._() : super();
  factory SlpMeta({
    SlpTokenType? tokenType,
    SlpTxType? txType,
    $core.List<$core.int>? tokenId,
    $core.List<$core.int>? groupTokenId,
  }) {
    final _result = create();
    if (tokenType != null) {
      _result.tokenType = tokenType;
    }
    if (txType != null) {
      _result.txType = txType;
    }
    if (tokenId != null) {
      _result.tokenId = tokenId;
    }
    if (groupTokenId != null) {
      _result.groupTokenId = groupTokenId;
    }
    return _result;
  }
  factory SlpMeta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlpMeta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlpMeta clone() => SlpMeta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlpMeta copyWith(void Function(SlpMeta) updates) => super.copyWith((message) => updates(message as SlpMeta)) as SlpMeta; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SlpMeta create() => SlpMeta._();
  SlpMeta createEmptyInstance() => create();
  static $pb.PbList<SlpMeta> createRepeated() => $pb.PbList<SlpMeta>();
  @$core.pragma('dart2js:noInline')
  static SlpMeta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlpMeta>(create);
  static SlpMeta? _defaultInstance;

  @$pb.TagNumber(1)
  SlpTokenType get tokenType => $_getN(0);
  @$pb.TagNumber(1)
  set tokenType(SlpTokenType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTokenType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTokenType() => clearField(1);

  @$pb.TagNumber(2)
  SlpTxType get txType => $_getN(1);
  @$pb.TagNumber(2)
  set txType(SlpTxType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTxType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxType() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get tokenId => $_getN(2);
  @$pb.TagNumber(3)
  set tokenId($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTokenId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTokenId() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get groupTokenId => $_getN(3);
  @$pb.TagNumber(4)
  set groupTokenId($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGroupTokenId() => $_has(3);
  @$pb.TagNumber(4)
  void clearGroupTokenId() => clearField(4);
}

class TokenStats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TokenStats', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalMinted')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalBurned')
    ..hasRequiredFields = false
  ;

  TokenStats._() : super();
  factory TokenStats({
    $core.String? totalMinted,
    $core.String? totalBurned,
  }) {
    final _result = create();
    if (totalMinted != null) {
      _result.totalMinted = totalMinted;
    }
    if (totalBurned != null) {
      _result.totalBurned = totalBurned;
    }
    return _result;
  }
  factory TokenStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TokenStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TokenStats clone() => TokenStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TokenStats copyWith(void Function(TokenStats) updates) => super.copyWith((message) => updates(message as TokenStats)) as TokenStats; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TokenStats create() => TokenStats._();
  TokenStats createEmptyInstance() => create();
  static $pb.PbList<TokenStats> createRepeated() => $pb.PbList<TokenStats>();
  @$core.pragma('dart2js:noInline')
  static TokenStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TokenStats>(create);
  static TokenStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get totalMinted => $_getSZ(0);
  @$pb.TagNumber(1)
  set totalMinted($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalMinted() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalMinted() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get totalBurned => $_getSZ(1);
  @$pb.TagNumber(2)
  set totalBurned($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalBurned() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalBurned() => clearField(2);
}

class TxInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TxInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOM<OutPoint>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prevOut', subBuilder: OutPoint.create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'inputScript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputScript', $pb.PbFieldType.OY)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sequenceNo', $pb.PbFieldType.OU3)
    ..aOM<SlpBurn>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpBurn', subBuilder: SlpBurn.create)
    ..aOM<SlpToken>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpToken', subBuilder: SlpToken.create)
    ..hasRequiredFields = false
  ;

  TxInput._() : super();
  factory TxInput({
    OutPoint? prevOut,
    $core.List<$core.int>? inputScript,
    $core.List<$core.int>? outputScript,
    $fixnum.Int64? value,
    $core.int? sequenceNo,
    SlpBurn? slpBurn,
    SlpToken? slpToken,
  }) {
    final _result = create();
    if (prevOut != null) {
      _result.prevOut = prevOut;
    }
    if (inputScript != null) {
      _result.inputScript = inputScript;
    }
    if (outputScript != null) {
      _result.outputScript = outputScript;
    }
    if (value != null) {
      _result.value = value;
    }
    if (sequenceNo != null) {
      _result.sequenceNo = sequenceNo;
    }
    if (slpBurn != null) {
      _result.slpBurn = slpBurn;
    }
    if (slpToken != null) {
      _result.slpToken = slpToken;
    }
    return _result;
  }
  factory TxInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TxInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TxInput clone() => TxInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TxInput copyWith(void Function(TxInput) updates) => super.copyWith((message) => updates(message as TxInput)) as TxInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TxInput create() => TxInput._();
  TxInput createEmptyInstance() => create();
  static $pb.PbList<TxInput> createRepeated() => $pb.PbList<TxInput>();
  @$core.pragma('dart2js:noInline')
  static TxInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TxInput>(create);
  static TxInput? _defaultInstance;

  @$pb.TagNumber(1)
  OutPoint get prevOut => $_getN(0);
  @$pb.TagNumber(1)
  set prevOut(OutPoint v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPrevOut() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrevOut() => clearField(1);
  @$pb.TagNumber(1)
  OutPoint ensurePrevOut() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get inputScript => $_getN(1);
  @$pb.TagNumber(2)
  set inputScript($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInputScript() => $_has(1);
  @$pb.TagNumber(2)
  void clearInputScript() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get outputScript => $_getN(2);
  @$pb.TagNumber(3)
  set outputScript($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOutputScript() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutputScript() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get value => $_getI64(3);
  @$pb.TagNumber(4)
  set value($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get sequenceNo => $_getIZ(4);
  @$pb.TagNumber(5)
  set sequenceNo($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSequenceNo() => $_has(4);
  @$pb.TagNumber(5)
  void clearSequenceNo() => clearField(5);

  @$pb.TagNumber(6)
  SlpBurn get slpBurn => $_getN(5);
  @$pb.TagNumber(6)
  set slpBurn(SlpBurn v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSlpBurn() => $_has(5);
  @$pb.TagNumber(6)
  void clearSlpBurn() => clearField(6);
  @$pb.TagNumber(6)
  SlpBurn ensureSlpBurn() => $_ensure(5);

  @$pb.TagNumber(7)
  SlpToken get slpToken => $_getN(6);
  @$pb.TagNumber(7)
  set slpToken(SlpToken v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasSlpToken() => $_has(6);
  @$pb.TagNumber(7)
  void clearSlpToken() => clearField(7);
  @$pb.TagNumber(7)
  SlpToken ensureSlpToken() => $_ensure(6);
}

class TxOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TxOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputScript', $pb.PbFieldType.OY)
    ..aOM<SlpToken>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'slpToken', subBuilder: SlpToken.create)
    ..aOM<OutPoint>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spentBy', subBuilder: OutPoint.create)
    ..hasRequiredFields = false
  ;

  TxOutput._() : super();
  factory TxOutput({
    $fixnum.Int64? value,
    $core.List<$core.int>? outputScript,
    SlpToken? slpToken,
    OutPoint? spentBy,
  }) {
    final _result = create();
    if (value != null) {
      _result.value = value;
    }
    if (outputScript != null) {
      _result.outputScript = outputScript;
    }
    if (slpToken != null) {
      _result.slpToken = slpToken;
    }
    if (spentBy != null) {
      _result.spentBy = spentBy;
    }
    return _result;
  }
  factory TxOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TxOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TxOutput clone() => TxOutput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TxOutput copyWith(void Function(TxOutput) updates) => super.copyWith((message) => updates(message as TxOutput)) as TxOutput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TxOutput create() => TxOutput._();
  TxOutput createEmptyInstance() => create();
  static $pb.PbList<TxOutput> createRepeated() => $pb.PbList<TxOutput>();
  @$core.pragma('dart2js:noInline')
  static TxOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TxOutput>(create);
  static TxOutput? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get value => $_getI64(0);
  @$pb.TagNumber(1)
  set value($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get outputScript => $_getN(1);
  @$pb.TagNumber(2)
  set outputScript($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOutputScript() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutputScript() => clearField(2);

  @$pb.TagNumber(3)
  SlpToken get slpToken => $_getN(2);
  @$pb.TagNumber(3)
  set slpToken(SlpToken v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSlpToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlpToken() => clearField(3);
  @$pb.TagNumber(3)
  SlpToken ensureSlpToken() => $_ensure(2);

  @$pb.TagNumber(4)
  OutPoint get spentBy => $_getN(3);
  @$pb.TagNumber(4)
  set spentBy(OutPoint v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSpentBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpentBy() => clearField(4);
  @$pb.TagNumber(4)
  OutPoint ensureSpentBy() => $_ensure(3);
}

class BlockMetadata extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BlockMetadata', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hash', $pb.PbFieldType.OY)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  BlockMetadata._() : super();
  factory BlockMetadata({
    $core.int? height,
    $core.List<$core.int>? hash,
    $fixnum.Int64? timestamp,
  }) {
    final _result = create();
    if (height != null) {
      _result.height = height;
    }
    if (hash != null) {
      _result.hash = hash;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    return _result;
  }
  factory BlockMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockMetadata clone() => BlockMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockMetadata copyWith(void Function(BlockMetadata) updates) => super.copyWith((message) => updates(message as BlockMetadata)) as BlockMetadata; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BlockMetadata create() => BlockMetadata._();
  BlockMetadata createEmptyInstance() => create();
  static $pb.PbList<BlockMetadata> createRepeated() => $pb.PbList<BlockMetadata>();
  @$core.pragma('dart2js:noInline')
  static BlockMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockMetadata>(create);
  static BlockMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get height => $_getIZ(0);
  @$pb.TagNumber(1)
  set height($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeight() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get hash => $_getN(1);
  @$pb.TagNumber(2)
  set hash($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearHash() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
}

class OutPoint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OutPoint', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outIdx', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  OutPoint._() : super();
  factory OutPoint({
    $core.List<$core.int>? txid,
    $core.int? outIdx,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (outIdx != null) {
      _result.outIdx = outIdx;
    }
    return _result;
  }
  factory OutPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OutPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OutPoint clone() => OutPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OutPoint copyWith(void Function(OutPoint) updates) => super.copyWith((message) => updates(message as OutPoint)) as OutPoint; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OutPoint create() => OutPoint._();
  OutPoint createEmptyInstance() => create();
  static $pb.PbList<OutPoint> createRepeated() => $pb.PbList<OutPoint>();
  @$core.pragma('dart2js:noInline')
  static OutPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OutPoint>(create);
  static OutPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get outIdx => $_getIZ(1);
  @$pb.TagNumber(2)
  set outIdx($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOutIdx() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutIdx() => clearField(2);
}

class SlpToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SlpToken', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isMintBaton')
    ..hasRequiredFields = false
  ;

  SlpToken._() : super();
  factory SlpToken({
    $fixnum.Int64? amount,
    $core.bool? isMintBaton,
  }) {
    final _result = create();
    if (amount != null) {
      _result.amount = amount;
    }
    if (isMintBaton != null) {
      _result.isMintBaton = isMintBaton;
    }
    return _result;
  }
  factory SlpToken.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlpToken.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlpToken clone() => SlpToken()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlpToken copyWith(void Function(SlpToken) updates) => super.copyWith((message) => updates(message as SlpToken)) as SlpToken; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SlpToken create() => SlpToken._();
  SlpToken createEmptyInstance() => create();
  static $pb.PbList<SlpToken> createRepeated() => $pb.PbList<SlpToken>();
  @$core.pragma('dart2js:noInline')
  static SlpToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlpToken>(create);
  static SlpToken? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get amount => $_getI64(0);
  @$pb.TagNumber(1)
  set amount($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isMintBaton => $_getBF(1);
  @$pb.TagNumber(2)
  set isMintBaton($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsMintBaton() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsMintBaton() => clearField(2);
}

class SlpBurn extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SlpBurn', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOM<SlpToken>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token', subBuilder: SlpToken.create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  SlpBurn._() : super();
  factory SlpBurn({
    SlpToken? token,
    $core.List<$core.int>? tokenId,
  }) {
    final _result = create();
    if (token != null) {
      _result.token = token;
    }
    if (tokenId != null) {
      _result.tokenId = tokenId;
    }
    return _result;
  }
  factory SlpBurn.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlpBurn.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlpBurn clone() => SlpBurn()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlpBurn copyWith(void Function(SlpBurn) updates) => super.copyWith((message) => updates(message as SlpBurn)) as SlpBurn; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SlpBurn create() => SlpBurn._();
  SlpBurn createEmptyInstance() => create();
  static $pb.PbList<SlpBurn> createRepeated() => $pb.PbList<SlpBurn>();
  @$core.pragma('dart2js:noInline')
  static SlpBurn getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlpBurn>(create);
  static SlpBurn? _defaultInstance;

  @$pb.TagNumber(1)
  SlpToken get token => $_getN(0);
  @$pb.TagNumber(1)
  set token(SlpToken v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
  @$pb.TagNumber(1)
  SlpToken ensureToken() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get tokenId => $_getN(1);
  @$pb.TagNumber(2)
  set tokenId($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTokenId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTokenId() => clearField(2);
}

class SlpGenesisInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SlpGenesisInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenTicker', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenName', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenDocumentUrl', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tokenDocumentHash', $pb.PbFieldType.OY)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'decimals', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  SlpGenesisInfo._() : super();
  factory SlpGenesisInfo({
    $core.List<$core.int>? tokenTicker,
    $core.List<$core.int>? tokenName,
    $core.List<$core.int>? tokenDocumentUrl,
    $core.List<$core.int>? tokenDocumentHash,
    $core.int? decimals,
  }) {
    final _result = create();
    if (tokenTicker != null) {
      _result.tokenTicker = tokenTicker;
    }
    if (tokenName != null) {
      _result.tokenName = tokenName;
    }
    if (tokenDocumentUrl != null) {
      _result.tokenDocumentUrl = tokenDocumentUrl;
    }
    if (tokenDocumentHash != null) {
      _result.tokenDocumentHash = tokenDocumentHash;
    }
    if (decimals != null) {
      _result.decimals = decimals;
    }
    return _result;
  }
  factory SlpGenesisInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlpGenesisInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlpGenesisInfo clone() => SlpGenesisInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlpGenesisInfo copyWith(void Function(SlpGenesisInfo) updates) => super.copyWith((message) => updates(message as SlpGenesisInfo)) as SlpGenesisInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SlpGenesisInfo create() => SlpGenesisInfo._();
  SlpGenesisInfo createEmptyInstance() => create();
  static $pb.PbList<SlpGenesisInfo> createRepeated() => $pb.PbList<SlpGenesisInfo>();
  @$core.pragma('dart2js:noInline')
  static SlpGenesisInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlpGenesisInfo>(create);
  static SlpGenesisInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get tokenTicker => $_getN(0);
  @$pb.TagNumber(1)
  set tokenTicker($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTokenTicker() => $_has(0);
  @$pb.TagNumber(1)
  void clearTokenTicker() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get tokenName => $_getN(1);
  @$pb.TagNumber(2)
  set tokenName($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTokenName() => $_has(1);
  @$pb.TagNumber(2)
  void clearTokenName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get tokenDocumentUrl => $_getN(2);
  @$pb.TagNumber(3)
  set tokenDocumentUrl($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTokenDocumentUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearTokenDocumentUrl() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get tokenDocumentHash => $_getN(3);
  @$pb.TagNumber(4)
  set tokenDocumentHash($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTokenDocumentHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearTokenDocumentHash() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get decimals => $_getIZ(4);
  @$pb.TagNumber(5)
  set decimals($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDecimals() => $_has(4);
  @$pb.TagNumber(5)
  void clearDecimals() => clearField(5);
}

class UtxoState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UtxoState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.O3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isConfirmed')
    ..e<UtxoStateVariant>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: UtxoStateVariant.UNSPENT, valueOf: UtxoStateVariant.valueOf, enumValues: UtxoStateVariant.values)
    ..hasRequiredFields = false
  ;

  UtxoState._() : super();
  factory UtxoState({
    $core.int? height,
    $core.bool? isConfirmed,
    UtxoStateVariant? state,
  }) {
    final _result = create();
    if (height != null) {
      _result.height = height;
    }
    if (isConfirmed != null) {
      _result.isConfirmed = isConfirmed;
    }
    if (state != null) {
      _result.state = state;
    }
    return _result;
  }
  factory UtxoState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UtxoState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UtxoState clone() => UtxoState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UtxoState copyWith(void Function(UtxoState) updates) => super.copyWith((message) => updates(message as UtxoState)) as UtxoState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UtxoState create() => UtxoState._();
  UtxoState createEmptyInstance() => create();
  static $pb.PbList<UtxoState> createRepeated() => $pb.PbList<UtxoState>();
  @$core.pragma('dart2js:noInline')
  static UtxoState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UtxoState>(create);
  static UtxoState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get height => $_getIZ(0);
  @$pb.TagNumber(1)
  set height($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeight() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isConfirmed => $_getBF(1);
  @$pb.TagNumber(2)
  set isConfirmed($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsConfirmed() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsConfirmed() => clearField(2);

  @$pb.TagNumber(3)
  UtxoStateVariant get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(UtxoStateVariant v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => clearField(3);
}

class Subscription extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Subscription', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptType')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'payload', $pb.PbFieldType.OY)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isSubscribe')
    ..hasRequiredFields = false
  ;

  Subscription._() : super();
  factory Subscription({
    $core.String? scriptType,
    $core.List<$core.int>? payload,
    $core.bool? isSubscribe,
  }) {
    final _result = create();
    if (scriptType != null) {
      _result.scriptType = scriptType;
    }
    if (payload != null) {
      _result.payload = payload;
    }
    if (isSubscribe != null) {
      _result.isSubscribe = isSubscribe;
    }
    return _result;
  }
  factory Subscription.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Subscription.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Subscription clone() => Subscription()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Subscription copyWith(void Function(Subscription) updates) => super.copyWith((message) => updates(message as Subscription)) as Subscription; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Subscription create() => Subscription._();
  Subscription createEmptyInstance() => create();
  static $pb.PbList<Subscription> createRepeated() => $pb.PbList<Subscription>();
  @$core.pragma('dart2js:noInline')
  static Subscription getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Subscription>(create);
  static Subscription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scriptType => $_getSZ(0);
  @$pb.TagNumber(1)
  set scriptType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasScriptType() => $_has(0);
  @$pb.TagNumber(1)
  void clearScriptType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get payload => $_getN(1);
  @$pb.TagNumber(2)
  set payload($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayload() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isSubscribe => $_getBF(2);
  @$pb.TagNumber(3)
  set isSubscribe($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsSubscribe() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsSubscribe() => clearField(3);
}

enum SubscribeMsg_MsgType {
  error, 
  addedToMempool, 
  removedFromMempool, 
  confirmed, 
  reorg, 
  blockConnected, 
  blockDisconnected, 
  notSet
}

class SubscribeMsg extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, SubscribeMsg_MsgType> _SubscribeMsg_MsgTypeByTag = {
    1 : SubscribeMsg_MsgType.error,
    2 : SubscribeMsg_MsgType.addedToMempool,
    3 : SubscribeMsg_MsgType.removedFromMempool,
    4 : SubscribeMsg_MsgType.confirmed,
    5 : SubscribeMsg_MsgType.reorg,
    6 : SubscribeMsg_MsgType.blockConnected,
    7 : SubscribeMsg_MsgType.blockDisconnected,
    0 : SubscribeMsg_MsgType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SubscribeMsg', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<Error>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'error', subBuilder: Error.create)
    ..aOM<MsgAddedToMempool>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'AddedToMempool', protoName: 'AddedToMempool', subBuilder: MsgAddedToMempool.create)
    ..aOM<MsgRemovedFromMempool>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RemovedFromMempool', protoName: 'RemovedFromMempool', subBuilder: MsgRemovedFromMempool.create)
    ..aOM<MsgConfirmed>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Confirmed', protoName: 'Confirmed', subBuilder: MsgConfirmed.create)
    ..aOM<MsgReorg>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Reorg', protoName: 'Reorg', subBuilder: MsgReorg.create)
    ..aOM<MsgBlockConnected>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockConnected', protoName: 'BlockConnected', subBuilder: MsgBlockConnected.create)
    ..aOM<MsgBlockDisconnected>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockDisconnected', protoName: 'BlockDisconnected', subBuilder: MsgBlockDisconnected.create)
    ..hasRequiredFields = false
  ;

  SubscribeMsg._() : super();
  factory SubscribeMsg({
    Error? error,
    MsgAddedToMempool? addedToMempool,
    MsgRemovedFromMempool? removedFromMempool,
    MsgConfirmed? confirmed,
    MsgReorg? reorg,
    MsgBlockConnected? blockConnected,
    MsgBlockDisconnected? blockDisconnected,
  }) {
    final _result = create();
    if (error != null) {
      _result.error = error;
    }
    if (addedToMempool != null) {
      _result.addedToMempool = addedToMempool;
    }
    if (removedFromMempool != null) {
      _result.removedFromMempool = removedFromMempool;
    }
    if (confirmed != null) {
      _result.confirmed = confirmed;
    }
    if (reorg != null) {
      _result.reorg = reorg;
    }
    if (blockConnected != null) {
      _result.blockConnected = blockConnected;
    }
    if (blockDisconnected != null) {
      _result.blockDisconnected = blockDisconnected;
    }
    return _result;
  }
  factory SubscribeMsg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscribeMsg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscribeMsg clone() => SubscribeMsg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscribeMsg copyWith(void Function(SubscribeMsg) updates) => super.copyWith((message) => updates(message as SubscribeMsg)) as SubscribeMsg; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubscribeMsg create() => SubscribeMsg._();
  SubscribeMsg createEmptyInstance() => create();
  static $pb.PbList<SubscribeMsg> createRepeated() => $pb.PbList<SubscribeMsg>();
  @$core.pragma('dart2js:noInline')
  static SubscribeMsg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeMsg>(create);
  static SubscribeMsg? _defaultInstance;

  SubscribeMsg_MsgType whichMsgType() => _SubscribeMsg_MsgTypeByTag[$_whichOneof(0)]!;
  void clearMsgType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Error get error => $_getN(0);
  @$pb.TagNumber(1)
  set error(Error v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);
  @$pb.TagNumber(1)
  Error ensureError() => $_ensure(0);

  @$pb.TagNumber(2)
  MsgAddedToMempool get addedToMempool => $_getN(1);
  @$pb.TagNumber(2)
  set addedToMempool(MsgAddedToMempool v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddedToMempool() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddedToMempool() => clearField(2);
  @$pb.TagNumber(2)
  MsgAddedToMempool ensureAddedToMempool() => $_ensure(1);

  @$pb.TagNumber(3)
  MsgRemovedFromMempool get removedFromMempool => $_getN(2);
  @$pb.TagNumber(3)
  set removedFromMempool(MsgRemovedFromMempool v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRemovedFromMempool() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemovedFromMempool() => clearField(3);
  @$pb.TagNumber(3)
  MsgRemovedFromMempool ensureRemovedFromMempool() => $_ensure(2);

  @$pb.TagNumber(4)
  MsgConfirmed get confirmed => $_getN(3);
  @$pb.TagNumber(4)
  set confirmed(MsgConfirmed v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasConfirmed() => $_has(3);
  @$pb.TagNumber(4)
  void clearConfirmed() => clearField(4);
  @$pb.TagNumber(4)
  MsgConfirmed ensureConfirmed() => $_ensure(3);

  @$pb.TagNumber(5)
  MsgReorg get reorg => $_getN(4);
  @$pb.TagNumber(5)
  set reorg(MsgReorg v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasReorg() => $_has(4);
  @$pb.TagNumber(5)
  void clearReorg() => clearField(5);
  @$pb.TagNumber(5)
  MsgReorg ensureReorg() => $_ensure(4);

  @$pb.TagNumber(6)
  MsgBlockConnected get blockConnected => $_getN(5);
  @$pb.TagNumber(6)
  set blockConnected(MsgBlockConnected v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasBlockConnected() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlockConnected() => clearField(6);
  @$pb.TagNumber(6)
  MsgBlockConnected ensureBlockConnected() => $_ensure(5);

  @$pb.TagNumber(7)
  MsgBlockDisconnected get blockDisconnected => $_getN(6);
  @$pb.TagNumber(7)
  set blockDisconnected(MsgBlockDisconnected v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasBlockDisconnected() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockDisconnected() => clearField(7);
  @$pb.TagNumber(7)
  MsgBlockDisconnected ensureBlockDisconnected() => $_ensure(6);
}

class MsgAddedToMempool extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgAddedToMempool', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  MsgAddedToMempool._() : super();
  factory MsgAddedToMempool({
    $core.List<$core.int>? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory MsgAddedToMempool.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgAddedToMempool.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgAddedToMempool clone() => MsgAddedToMempool()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgAddedToMempool copyWith(void Function(MsgAddedToMempool) updates) => super.copyWith((message) => updates(message as MsgAddedToMempool)) as MsgAddedToMempool; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgAddedToMempool create() => MsgAddedToMempool._();
  MsgAddedToMempool createEmptyInstance() => create();
  static $pb.PbList<MsgAddedToMempool> createRepeated() => $pb.PbList<MsgAddedToMempool>();
  @$core.pragma('dart2js:noInline')
  static MsgAddedToMempool getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgAddedToMempool>(create);
  static MsgAddedToMempool? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

class MsgRemovedFromMempool extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgRemovedFromMempool', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  MsgRemovedFromMempool._() : super();
  factory MsgRemovedFromMempool({
    $core.List<$core.int>? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory MsgRemovedFromMempool.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgRemovedFromMempool.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgRemovedFromMempool clone() => MsgRemovedFromMempool()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgRemovedFromMempool copyWith(void Function(MsgRemovedFromMempool) updates) => super.copyWith((message) => updates(message as MsgRemovedFromMempool)) as MsgRemovedFromMempool; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgRemovedFromMempool create() => MsgRemovedFromMempool._();
  MsgRemovedFromMempool createEmptyInstance() => create();
  static $pb.PbList<MsgRemovedFromMempool> createRepeated() => $pb.PbList<MsgRemovedFromMempool>();
  @$core.pragma('dart2js:noInline')
  static MsgRemovedFromMempool getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgRemovedFromMempool>(create);
  static MsgRemovedFromMempool? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

class MsgConfirmed extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgConfirmed', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  MsgConfirmed._() : super();
  factory MsgConfirmed({
    $core.List<$core.int>? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory MsgConfirmed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgConfirmed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgConfirmed clone() => MsgConfirmed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgConfirmed copyWith(void Function(MsgConfirmed) updates) => super.copyWith((message) => updates(message as MsgConfirmed)) as MsgConfirmed; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgConfirmed create() => MsgConfirmed._();
  MsgConfirmed createEmptyInstance() => create();
  static $pb.PbList<MsgConfirmed> createRepeated() => $pb.PbList<MsgConfirmed>();
  @$core.pragma('dart2js:noInline')
  static MsgConfirmed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgConfirmed>(create);
  static MsgConfirmed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

class MsgReorg extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgReorg', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  MsgReorg._() : super();
  factory MsgReorg({
    $core.List<$core.int>? txid,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory MsgReorg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgReorg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgReorg clone() => MsgReorg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgReorg copyWith(void Function(MsgReorg) updates) => super.copyWith((message) => updates(message as MsgReorg)) as MsgReorg; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgReorg create() => MsgReorg._();
  MsgReorg createEmptyInstance() => create();
  static $pb.PbList<MsgReorg> createRepeated() => $pb.PbList<MsgReorg>();
  @$core.pragma('dart2js:noInline')
  static MsgReorg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgReorg>(create);
  static MsgReorg? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);
}

class MsgBlockConnected extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgBlockConnected', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockHash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  MsgBlockConnected._() : super();
  factory MsgBlockConnected({
    $core.List<$core.int>? blockHash,
  }) {
    final _result = create();
    if (blockHash != null) {
      _result.blockHash = blockHash;
    }
    return _result;
  }
  factory MsgBlockConnected.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgBlockConnected.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgBlockConnected clone() => MsgBlockConnected()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgBlockConnected copyWith(void Function(MsgBlockConnected) updates) => super.copyWith((message) => updates(message as MsgBlockConnected)) as MsgBlockConnected; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgBlockConnected create() => MsgBlockConnected._();
  MsgBlockConnected createEmptyInstance() => create();
  static $pb.PbList<MsgBlockConnected> createRepeated() => $pb.PbList<MsgBlockConnected>();
  @$core.pragma('dart2js:noInline')
  static MsgBlockConnected getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgBlockConnected>(create);
  static MsgBlockConnected? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get blockHash => $_getN(0);
  @$pb.TagNumber(1)
  set blockHash($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlockHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockHash() => clearField(1);
}

class MsgBlockDisconnected extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MsgBlockDisconnected', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blockHash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  MsgBlockDisconnected._() : super();
  factory MsgBlockDisconnected({
    $core.List<$core.int>? blockHash,
  }) {
    final _result = create();
    if (blockHash != null) {
      _result.blockHash = blockHash;
    }
    return _result;
  }
  factory MsgBlockDisconnected.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MsgBlockDisconnected.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MsgBlockDisconnected clone() => MsgBlockDisconnected()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MsgBlockDisconnected copyWith(void Function(MsgBlockDisconnected) updates) => super.copyWith((message) => updates(message as MsgBlockDisconnected)) as MsgBlockDisconnected; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgBlockDisconnected create() => MsgBlockDisconnected._();
  MsgBlockDisconnected createEmptyInstance() => create();
  static $pb.PbList<MsgBlockDisconnected> createRepeated() => $pb.PbList<MsgBlockDisconnected>();
  @$core.pragma('dart2js:noInline')
  static MsgBlockDisconnected getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgBlockDisconnected>(create);
  static MsgBlockDisconnected? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get blockHash => $_getN(0);
  @$pb.TagNumber(1)
  set blockHash($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlockHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockHash() => clearField(1);
}

class Error extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Error', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'chronik'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorCode')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msg')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isUserError')
    ..hasRequiredFields = false
  ;

  Error._() : super();
  factory Error({
    $core.String? errorCode,
    $core.String? msg,
    $core.bool? isUserError,
  }) {
    final _result = create();
    if (errorCode != null) {
      _result.errorCode = errorCode;
    }
    if (msg != null) {
      _result.msg = msg;
    }
    if (isUserError != null) {
      _result.isUserError = isUserError;
    }
    return _result;
  }
  factory Error.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Error clone() => Error()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Error copyWith(void Function(Error) updates) => super.copyWith((message) => updates(message as Error)) as Error; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get errorCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isUserError => $_getBF(2);
  @$pb.TagNumber(3)
  set isUserError($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsUserError() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsUserError() => clearField(3);
}

