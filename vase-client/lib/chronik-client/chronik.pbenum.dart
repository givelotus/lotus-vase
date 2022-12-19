///
//  Generated code. Do not modify.
//  source: chronik.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class SlpTokenType extends $pb.ProtobufEnum {
  static const SlpTokenType FUNGIBLE = SlpTokenType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FUNGIBLE');
  static const SlpTokenType NFT1_GROUP = SlpTokenType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NFT1_GROUP');
  static const SlpTokenType NFT1_CHILD = SlpTokenType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NFT1_CHILD');
  static const SlpTokenType UNKNOWN_TOKEN_TYPE = SlpTokenType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNKNOWN_TOKEN_TYPE');

  static const $core.List<SlpTokenType> values = <SlpTokenType> [
    FUNGIBLE,
    NFT1_GROUP,
    NFT1_CHILD,
    UNKNOWN_TOKEN_TYPE,
  ];

  static final $core.Map<$core.int, SlpTokenType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SlpTokenType? valueOf($core.int value) => _byValue[value];

  const SlpTokenType._($core.int v, $core.String n) : super(v, n);
}

class SlpTxType extends $pb.ProtobufEnum {
  static const SlpTxType GENESIS = SlpTxType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GENESIS');
  static const SlpTxType SEND = SlpTxType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SEND');
  static const SlpTxType MINT = SlpTxType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MINT');
  static const SlpTxType UNKNOWN_TX_TYPE = SlpTxType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNKNOWN_TX_TYPE');

  static const $core.List<SlpTxType> values = <SlpTxType> [
    GENESIS,
    SEND,
    MINT,
    UNKNOWN_TX_TYPE,
  ];

  static final $core.Map<$core.int, SlpTxType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SlpTxType? valueOf($core.int value) => _byValue[value];

  const SlpTxType._($core.int v, $core.String n) : super(v, n);
}

class Network extends $pb.ProtobufEnum {
  static const Network BCH = Network._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BCH');
  static const Network XEC = Network._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'XEC');
  static const Network XPI = Network._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'XPI');
  static const Network XRG = Network._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'XRG');

  static const $core.List<Network> values = <Network> [
    BCH,
    XEC,
    XPI,
    XRG,
  ];

  static final $core.Map<$core.int, Network> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Network? valueOf($core.int value) => _byValue[value];

  const Network._($core.int v, $core.String n) : super(v, n);
}

class UtxoStateVariant extends $pb.ProtobufEnum {
  static const UtxoStateVariant UNSPENT = UtxoStateVariant._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNSPENT');
  static const UtxoStateVariant SPENT = UtxoStateVariant._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SPENT');
  static const UtxoStateVariant NO_SUCH_TX = UtxoStateVariant._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NO_SUCH_TX');
  static const UtxoStateVariant NO_SUCH_OUTPUT = UtxoStateVariant._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NO_SUCH_OUTPUT');

  static const $core.List<UtxoStateVariant> values = <UtxoStateVariant> [
    UNSPENT,
    SPENT,
    NO_SUCH_TX,
    NO_SUCH_OUTPUT,
  ];

  static final $core.Map<$core.int, UtxoStateVariant> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UtxoStateVariant? valueOf($core.int value) => _byValue[value];

  const UtxoStateVariant._($core.int v, $core.String n) : super(v, n);
}

