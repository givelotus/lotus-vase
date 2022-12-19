///
//  Generated code. Do not modify.
//  source: chronik.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use slpTokenTypeDescriptor instead')
const SlpTokenType$json = const {
  '1': 'SlpTokenType',
  '2': const [
    const {'1': 'FUNGIBLE', '2': 0},
    const {'1': 'NFT1_GROUP', '2': 1},
    const {'1': 'NFT1_CHILD', '2': 2},
    const {'1': 'UNKNOWN_TOKEN_TYPE', '2': 3},
  ],
};

/// Descriptor for `SlpTokenType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List slpTokenTypeDescriptor = $convert.base64Decode('CgxTbHBUb2tlblR5cGUSDAoIRlVOR0lCTEUQABIOCgpORlQxX0dST1VQEAESDgoKTkZUMV9DSElMRBACEhYKElVOS05PV05fVE9LRU5fVFlQRRAD');
@$core.Deprecated('Use slpTxTypeDescriptor instead')
const SlpTxType$json = const {
  '1': 'SlpTxType',
  '2': const [
    const {'1': 'GENESIS', '2': 0},
    const {'1': 'SEND', '2': 1},
    const {'1': 'MINT', '2': 2},
    const {'1': 'UNKNOWN_TX_TYPE', '2': 3},
  ],
};

/// Descriptor for `SlpTxType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List slpTxTypeDescriptor = $convert.base64Decode('CglTbHBUeFR5cGUSCwoHR0VORVNJUxAAEggKBFNFTkQQARIICgRNSU5UEAISEwoPVU5LTk9XTl9UWF9UWVBFEAM=');
@$core.Deprecated('Use networkDescriptor instead')
const Network$json = const {
  '1': 'Network',
  '2': const [
    const {'1': 'BCH', '2': 0},
    const {'1': 'XEC', '2': 1},
    const {'1': 'XPI', '2': 2},
    const {'1': 'XRG', '2': 3},
  ],
};

/// Descriptor for `Network`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List networkDescriptor = $convert.base64Decode('CgdOZXR3b3JrEgcKA0JDSBAAEgcKA1hFQxABEgcKA1hQSRACEgcKA1hSRxAD');
@$core.Deprecated('Use utxoStateVariantDescriptor instead')
const UtxoStateVariant$json = const {
  '1': 'UtxoStateVariant',
  '2': const [
    const {'1': 'UNSPENT', '2': 0},
    const {'1': 'SPENT', '2': 1},
    const {'1': 'NO_SUCH_TX', '2': 2},
    const {'1': 'NO_SUCH_OUTPUT', '2': 3},
  ],
};

/// Descriptor for `UtxoStateVariant`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List utxoStateVariantDescriptor = $convert.base64Decode('ChBVdHhvU3RhdGVWYXJpYW50EgsKB1VOU1BFTlQQABIJCgVTUEVOVBABEg4KCk5PX1NVQ0hfVFgQAhISCg5OT19TVUNIX09VVFBVVBAD');
@$core.Deprecated('Use validateUtxoRequestDescriptor instead')
const ValidateUtxoRequest$json = const {
  '1': 'ValidateUtxoRequest',
  '2': const [
    const {'1': 'outpoints', '3': 1, '4': 3, '5': 11, '6': '.chronik.OutPoint', '10': 'outpoints'},
  ],
};

/// Descriptor for `ValidateUtxoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateUtxoRequestDescriptor = $convert.base64Decode('ChNWYWxpZGF0ZVV0eG9SZXF1ZXN0Ei8KCW91dHBvaW50cxgBIAMoCzIRLmNocm9uaWsuT3V0UG9pbnRSCW91dHBvaW50cw==');
@$core.Deprecated('Use validateUtxoResponseDescriptor instead')
const ValidateUtxoResponse$json = const {
  '1': 'ValidateUtxoResponse',
  '2': const [
    const {'1': 'utxo_states', '3': 1, '4': 3, '5': 11, '6': '.chronik.UtxoState', '10': 'utxoStates'},
  ],
};

/// Descriptor for `ValidateUtxoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateUtxoResponseDescriptor = $convert.base64Decode('ChRWYWxpZGF0ZVV0eG9SZXNwb25zZRIzCgt1dHhvX3N0YXRlcxgBIAMoCzISLmNocm9uaWsuVXR4b1N0YXRlUgp1dHhvU3RhdGVz');
@$core.Deprecated('Use broadcastTxRequestDescriptor instead')
const BroadcastTxRequest$json = const {
  '1': 'BroadcastTxRequest',
  '2': const [
    const {'1': 'raw_tx', '3': 1, '4': 1, '5': 12, '10': 'rawTx'},
    const {'1': 'skip_slp_check', '3': 2, '4': 1, '5': 8, '10': 'skipSlpCheck'},
  ],
};

/// Descriptor for `BroadcastTxRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastTxRequestDescriptor = $convert.base64Decode('ChJCcm9hZGNhc3RUeFJlcXVlc3QSFQoGcmF3X3R4GAEgASgMUgVyYXdUeBIkCg5za2lwX3NscF9jaGVjaxgCIAEoCFIMc2tpcFNscENoZWNr');
@$core.Deprecated('Use broadcastTxResponseDescriptor instead')
const BroadcastTxResponse$json = const {
  '1': 'BroadcastTxResponse',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
  ],
};

/// Descriptor for `BroadcastTxResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastTxResponseDescriptor = $convert.base64Decode('ChNCcm9hZGNhc3RUeFJlc3BvbnNlEhIKBHR4aWQYASABKAxSBHR4aWQ=');
@$core.Deprecated('Use broadcastTxsRequestDescriptor instead')
const BroadcastTxsRequest$json = const {
  '1': 'BroadcastTxsRequest',
  '2': const [
    const {'1': 'raw_txs', '3': 1, '4': 3, '5': 12, '10': 'rawTxs'},
    const {'1': 'skip_slp_check', '3': 2, '4': 1, '5': 8, '10': 'skipSlpCheck'},
  ],
};

/// Descriptor for `BroadcastTxsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastTxsRequestDescriptor = $convert.base64Decode('ChNCcm9hZGNhc3RUeHNSZXF1ZXN0EhcKB3Jhd190eHMYASADKAxSBnJhd1R4cxIkCg5za2lwX3NscF9jaGVjaxgCIAEoCFIMc2tpcFNscENoZWNr');
@$core.Deprecated('Use broadcastTxsResponseDescriptor instead')
const BroadcastTxsResponse$json = const {
  '1': 'BroadcastTxsResponse',
  '2': const [
    const {'1': 'txids', '3': 1, '4': 3, '5': 12, '10': 'txids'},
  ],
};

/// Descriptor for `BroadcastTxsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastTxsResponseDescriptor = $convert.base64Decode('ChRCcm9hZGNhc3RUeHNSZXNwb25zZRIUCgV0eGlkcxgBIAMoDFIFdHhpZHM=');
@$core.Deprecated('Use blockchainInfoDescriptor instead')
const BlockchainInfo$json = const {
  '1': 'BlockchainInfo',
  '2': const [
    const {'1': 'tip_hash', '3': 1, '4': 1, '5': 12, '10': 'tipHash'},
    const {'1': 'tip_height', '3': 2, '4': 1, '5': 5, '10': 'tipHeight'},
  ],
};

/// Descriptor for `BlockchainInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockchainInfoDescriptor = $convert.base64Decode('Cg5CbG9ja2NoYWluSW5mbxIZCgh0aXBfaGFzaBgBIAEoDFIHdGlwSGFzaBIdCgp0aXBfaGVpZ2h0GAIgASgFUgl0aXBIZWlnaHQ=');
@$core.Deprecated('Use txDescriptor instead')
const Tx$json = const {
  '1': 'Tx',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
    const {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'inputs', '3': 3, '4': 3, '5': 11, '6': '.chronik.TxInput', '10': 'inputs'},
    const {'1': 'outputs', '3': 4, '4': 3, '5': 11, '6': '.chronik.TxOutput', '10': 'outputs'},
    const {'1': 'lock_time', '3': 5, '4': 1, '5': 13, '10': 'lockTime'},
    const {'1': 'slp_tx_data', '3': 6, '4': 1, '5': 11, '6': '.chronik.SlpTxData', '10': 'slpTxData'},
    const {'1': 'slp_error_msg', '3': 7, '4': 1, '5': 9, '10': 'slpErrorMsg'},
    const {'1': 'block', '3': 8, '4': 1, '5': 11, '6': '.chronik.BlockMetadata', '10': 'block'},
    const {'1': 'time_first_seen', '3': 9, '4': 1, '5': 3, '10': 'timeFirstSeen'},
    const {'1': 'size', '3': 11, '4': 1, '5': 13, '10': 'size'},
    const {'1': 'is_coinbase', '3': 12, '4': 1, '5': 8, '10': 'isCoinbase'},
    const {'1': 'network', '3': 10, '4': 1, '5': 14, '6': '.chronik.Network', '10': 'network'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode('CgJUeBISCgR0eGlkGAEgASgMUgR0eGlkEhgKB3ZlcnNpb24YAiABKAVSB3ZlcnNpb24SKAoGaW5wdXRzGAMgAygLMhAuY2hyb25pay5UeElucHV0UgZpbnB1dHMSKwoHb3V0cHV0cxgEIAMoCzIRLmNocm9uaWsuVHhPdXRwdXRSB291dHB1dHMSGwoJbG9ja190aW1lGAUgASgNUghsb2NrVGltZRIyCgtzbHBfdHhfZGF0YRgGIAEoCzISLmNocm9uaWsuU2xwVHhEYXRhUglzbHBUeERhdGESIgoNc2xwX2Vycm9yX21zZxgHIAEoCVILc2xwRXJyb3JNc2cSLAoFYmxvY2sYCCABKAsyFi5jaHJvbmlrLkJsb2NrTWV0YWRhdGFSBWJsb2NrEiYKD3RpbWVfZmlyc3Rfc2VlbhgJIAEoA1INdGltZUZpcnN0U2VlbhISCgRzaXplGAsgASgNUgRzaXplEh8KC2lzX2NvaW5iYXNlGAwgASgIUgppc0NvaW5iYXNlEioKB25ldHdvcmsYCiABKA4yEC5jaHJvbmlrLk5ldHdvcmtSB25ldHdvcms=');
@$core.Deprecated('Use utxoDescriptor instead')
const Utxo$json = const {
  '1': 'Utxo',
  '2': const [
    const {'1': 'outpoint', '3': 1, '4': 1, '5': 11, '6': '.chronik.OutPoint', '10': 'outpoint'},
    const {'1': 'block_height', '3': 2, '4': 1, '5': 5, '10': 'blockHeight'},
    const {'1': 'is_coinbase', '3': 3, '4': 1, '5': 8, '10': 'isCoinbase'},
    const {'1': 'value', '3': 5, '4': 1, '5': 3, '10': 'value'},
    const {'1': 'slp_meta', '3': 6, '4': 1, '5': 11, '6': '.chronik.SlpMeta', '10': 'slpMeta'},
    const {'1': 'slp_token', '3': 7, '4': 1, '5': 11, '6': '.chronik.SlpToken', '10': 'slpToken'},
    const {'1': 'network', '3': 9, '4': 1, '5': 14, '6': '.chronik.Network', '10': 'network'},
  ],
};

/// Descriptor for `Utxo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List utxoDescriptor = $convert.base64Decode('CgRVdHhvEi0KCG91dHBvaW50GAEgASgLMhEuY2hyb25pay5PdXRQb2ludFIIb3V0cG9pbnQSIQoMYmxvY2tfaGVpZ2h0GAIgASgFUgtibG9ja0hlaWdodBIfCgtpc19jb2luYmFzZRgDIAEoCFIKaXNDb2luYmFzZRIUCgV2YWx1ZRgFIAEoA1IFdmFsdWUSKwoIc2xwX21ldGEYBiABKAsyEC5jaHJvbmlrLlNscE1ldGFSB3NscE1ldGESLgoJc2xwX3Rva2VuGAcgASgLMhEuY2hyb25pay5TbHBUb2tlblIIc2xwVG9rZW4SKgoHbmV0d29yaxgJIAEoDjIQLmNocm9uaWsuTmV0d29ya1IHbmV0d29yaw==');
@$core.Deprecated('Use tokenDescriptor instead')
const Token$json = const {
  '1': 'Token',
  '2': const [
    const {'1': 'slp_tx_data', '3': 1, '4': 1, '5': 11, '6': '.chronik.SlpTxData', '10': 'slpTxData'},
    const {'1': 'token_stats', '3': 2, '4': 1, '5': 11, '6': '.chronik.TokenStats', '10': 'tokenStats'},
    const {'1': 'block', '3': 3, '4': 1, '5': 11, '6': '.chronik.BlockMetadata', '10': 'block'},
    const {'1': 'time_first_seen', '3': 4, '4': 1, '5': 3, '10': 'timeFirstSeen'},
    const {'1': 'initial_token_quantity', '3': 5, '4': 1, '5': 4, '10': 'initialTokenQuantity'},
    const {'1': 'contains_baton', '3': 6, '4': 1, '5': 8, '10': 'containsBaton'},
    const {'1': 'network', '3': 7, '4': 1, '5': 14, '6': '.chronik.Network', '10': 'network'},
  ],
};

/// Descriptor for `Token`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tokenDescriptor = $convert.base64Decode('CgVUb2tlbhIyCgtzbHBfdHhfZGF0YRgBIAEoCzISLmNocm9uaWsuU2xwVHhEYXRhUglzbHBUeERhdGESNAoLdG9rZW5fc3RhdHMYAiABKAsyEy5jaHJvbmlrLlRva2VuU3RhdHNSCnRva2VuU3RhdHMSLAoFYmxvY2sYAyABKAsyFi5jaHJvbmlrLkJsb2NrTWV0YWRhdGFSBWJsb2NrEiYKD3RpbWVfZmlyc3Rfc2VlbhgEIAEoA1INdGltZUZpcnN0U2VlbhI0ChZpbml0aWFsX3Rva2VuX3F1YW50aXR5GAUgASgEUhRpbml0aWFsVG9rZW5RdWFudGl0eRIlCg5jb250YWluc19iYXRvbhgGIAEoCFINY29udGFpbnNCYXRvbhIqCgduZXR3b3JrGAcgASgOMhAuY2hyb25pay5OZXR3b3JrUgduZXR3b3Jr');
@$core.Deprecated('Use blockInfoDescriptor instead')
const BlockInfo$json = const {
  '1': 'BlockInfo',
  '2': const [
    const {'1': 'hash', '3': 1, '4': 1, '5': 12, '10': 'hash'},
    const {'1': 'prev_hash', '3': 2, '4': 1, '5': 12, '10': 'prevHash'},
    const {'1': 'height', '3': 3, '4': 1, '5': 5, '10': 'height'},
    const {'1': 'n_bits', '3': 4, '4': 1, '5': 13, '10': 'nBits'},
    const {'1': 'timestamp', '3': 5, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'block_size', '3': 6, '4': 1, '5': 4, '10': 'blockSize'},
    const {'1': 'num_txs', '3': 7, '4': 1, '5': 4, '10': 'numTxs'},
    const {'1': 'num_inputs', '3': 8, '4': 1, '5': 4, '10': 'numInputs'},
    const {'1': 'num_outputs', '3': 9, '4': 1, '5': 4, '10': 'numOutputs'},
    const {'1': 'sum_input_sats', '3': 10, '4': 1, '5': 3, '10': 'sumInputSats'},
    const {'1': 'sum_coinbase_output_sats', '3': 11, '4': 1, '5': 3, '10': 'sumCoinbaseOutputSats'},
    const {'1': 'sum_normal_output_sats', '3': 12, '4': 1, '5': 3, '10': 'sumNormalOutputSats'},
    const {'1': 'sum_burned_sats', '3': 13, '4': 1, '5': 3, '10': 'sumBurnedSats'},
  ],
};

/// Descriptor for `BlockInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockInfoDescriptor = $convert.base64Decode('CglCbG9ja0luZm8SEgoEaGFzaBgBIAEoDFIEaGFzaBIbCglwcmV2X2hhc2gYAiABKAxSCHByZXZIYXNoEhYKBmhlaWdodBgDIAEoBVIGaGVpZ2h0EhUKBm5fYml0cxgEIAEoDVIFbkJpdHMSHAoJdGltZXN0YW1wGAUgASgDUgl0aW1lc3RhbXASHQoKYmxvY2tfc2l6ZRgGIAEoBFIJYmxvY2tTaXplEhcKB251bV90eHMYByABKARSBm51bVR4cxIdCgpudW1faW5wdXRzGAggASgEUgludW1JbnB1dHMSHwoLbnVtX291dHB1dHMYCSABKARSCm51bU91dHB1dHMSJAoOc3VtX2lucHV0X3NhdHMYCiABKANSDHN1bUlucHV0U2F0cxI3ChhzdW1fY29pbmJhc2Vfb3V0cHV0X3NhdHMYCyABKANSFXN1bUNvaW5iYXNlT3V0cHV0U2F0cxIzChZzdW1fbm9ybWFsX291dHB1dF9zYXRzGAwgASgDUhNzdW1Ob3JtYWxPdXRwdXRTYXRzEiYKD3N1bV9idXJuZWRfc2F0cxgNIAEoA1INc3VtQnVybmVkU2F0cw==');
@$core.Deprecated('Use blockDetailsDescriptor instead')
const BlockDetails$json = const {
  '1': 'BlockDetails',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'merkle_root', '3': 2, '4': 1, '5': 12, '10': 'merkleRoot'},
    const {'1': 'nonce', '3': 3, '4': 1, '5': 4, '10': 'nonce'},
    const {'1': 'median_timestamp', '3': 4, '4': 1, '5': 3, '10': 'medianTimestamp'},
  ],
};

/// Descriptor for `BlockDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockDetailsDescriptor = $convert.base64Decode('CgxCbG9ja0RldGFpbHMSGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhIfCgttZXJrbGVfcm9vdBgCIAEoDFIKbWVya2xlUm9vdBIUCgVub25jZRgDIAEoBFIFbm9uY2USKQoQbWVkaWFuX3RpbWVzdGFtcBgEIAEoA1IPbWVkaWFuVGltZXN0YW1w');
@$core.Deprecated('Use blockDescriptor instead')
const Block$json = const {
  '1': 'Block',
  '2': const [
    const {'1': 'block_info', '3': 1, '4': 1, '5': 11, '6': '.chronik.BlockInfo', '10': 'blockInfo'},
    const {'1': 'block_details', '3': 3, '4': 1, '5': 11, '6': '.chronik.BlockDetails', '10': 'blockDetails'},
    const {'1': 'raw_header', '3': 4, '4': 1, '5': 12, '10': 'rawHeader'},
    const {'1': 'txs', '3': 2, '4': 3, '5': 11, '6': '.chronik.Tx', '10': 'txs'},
  ],
};

/// Descriptor for `Block`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockDescriptor = $convert.base64Decode('CgVCbG9jaxIxCgpibG9ja19pbmZvGAEgASgLMhIuY2hyb25pay5CbG9ja0luZm9SCWJsb2NrSW5mbxI6Cg1ibG9ja19kZXRhaWxzGAMgASgLMhUuY2hyb25pay5CbG9ja0RldGFpbHNSDGJsb2NrRGV0YWlscxIdCgpyYXdfaGVhZGVyGAQgASgMUglyYXdIZWFkZXISHQoDdHhzGAIgAygLMgsuY2hyb25pay5UeFIDdHhz');
@$core.Deprecated('Use scriptUtxosDescriptor instead')
const ScriptUtxos$json = const {
  '1': 'ScriptUtxos',
  '2': const [
    const {'1': 'output_script', '3': 1, '4': 1, '5': 12, '10': 'outputScript'},
    const {'1': 'utxos', '3': 2, '4': 3, '5': 11, '6': '.chronik.Utxo', '10': 'utxos'},
  ],
};

/// Descriptor for `ScriptUtxos`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptUtxosDescriptor = $convert.base64Decode('CgtTY3JpcHRVdHhvcxIjCg1vdXRwdXRfc2NyaXB0GAEgASgMUgxvdXRwdXRTY3JpcHQSIwoFdXR4b3MYAiADKAsyDS5jaHJvbmlrLlV0eG9SBXV0eG9z');
@$core.Deprecated('Use txHistoryPageDescriptor instead')
const TxHistoryPage$json = const {
  '1': 'TxHistoryPage',
  '2': const [
    const {'1': 'txs', '3': 1, '4': 3, '5': 11, '6': '.chronik.Tx', '10': 'txs'},
    const {'1': 'num_pages', '3': 2, '4': 1, '5': 13, '10': 'numPages'},
  ],
};

/// Descriptor for `TxHistoryPage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txHistoryPageDescriptor = $convert.base64Decode('Cg1UeEhpc3RvcnlQYWdlEh0KA3R4cxgBIAMoCzILLmNocm9uaWsuVHhSA3R4cxIbCgludW1fcGFnZXMYAiABKA1SCG51bVBhZ2Vz');
@$core.Deprecated('Use utxosDescriptor instead')
const Utxos$json = const {
  '1': 'Utxos',
  '2': const [
    const {'1': 'script_utxos', '3': 1, '4': 3, '5': 11, '6': '.chronik.ScriptUtxos', '10': 'scriptUtxos'},
  ],
};

/// Descriptor for `Utxos`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List utxosDescriptor = $convert.base64Decode('CgVVdHhvcxI3CgxzY3JpcHRfdXR4b3MYASADKAsyFC5jaHJvbmlrLlNjcmlwdFV0eG9zUgtzY3JpcHRVdHhvcw==');
@$core.Deprecated('Use blocksDescriptor instead')
const Blocks$json = const {
  '1': 'Blocks',
  '2': const [
    const {'1': 'blocks', '3': 1, '4': 3, '5': 11, '6': '.chronik.BlockInfo', '10': 'blocks'},
  ],
};

/// Descriptor for `Blocks`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blocksDescriptor = $convert.base64Decode('CgZCbG9ja3MSKgoGYmxvY2tzGAEgAygLMhIuY2hyb25pay5CbG9ja0luZm9SBmJsb2Nrcw==');
@$core.Deprecated('Use slpTxDataDescriptor instead')
const SlpTxData$json = const {
  '1': 'SlpTxData',
  '2': const [
    const {'1': 'slp_meta', '3': 1, '4': 1, '5': 11, '6': '.chronik.SlpMeta', '10': 'slpMeta'},
    const {'1': 'genesis_info', '3': 2, '4': 1, '5': 11, '6': '.chronik.SlpGenesisInfo', '10': 'genesisInfo'},
  ],
};

/// Descriptor for `SlpTxData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slpTxDataDescriptor = $convert.base64Decode('CglTbHBUeERhdGESKwoIc2xwX21ldGEYASABKAsyEC5jaHJvbmlrLlNscE1ldGFSB3NscE1ldGESOgoMZ2VuZXNpc19pbmZvGAIgASgLMhcuY2hyb25pay5TbHBHZW5lc2lzSW5mb1ILZ2VuZXNpc0luZm8=');
@$core.Deprecated('Use slpMetaDescriptor instead')
const SlpMeta$json = const {
  '1': 'SlpMeta',
  '2': const [
    const {'1': 'token_type', '3': 1, '4': 1, '5': 14, '6': '.chronik.SlpTokenType', '10': 'tokenType'},
    const {'1': 'tx_type', '3': 2, '4': 1, '5': 14, '6': '.chronik.SlpTxType', '10': 'txType'},
    const {'1': 'token_id', '3': 3, '4': 1, '5': 12, '10': 'tokenId'},
    const {'1': 'group_token_id', '3': 4, '4': 1, '5': 12, '10': 'groupTokenId'},
  ],
};

/// Descriptor for `SlpMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slpMetaDescriptor = $convert.base64Decode('CgdTbHBNZXRhEjQKCnRva2VuX3R5cGUYASABKA4yFS5jaHJvbmlrLlNscFRva2VuVHlwZVIJdG9rZW5UeXBlEisKB3R4X3R5cGUYAiABKA4yEi5jaHJvbmlrLlNscFR4VHlwZVIGdHhUeXBlEhkKCHRva2VuX2lkGAMgASgMUgd0b2tlbklkEiQKDmdyb3VwX3Rva2VuX2lkGAQgASgMUgxncm91cFRva2VuSWQ=');
@$core.Deprecated('Use tokenStatsDescriptor instead')
const TokenStats$json = const {
  '1': 'TokenStats',
  '2': const [
    const {'1': 'total_minted', '3': 1, '4': 1, '5': 9, '10': 'totalMinted'},
    const {'1': 'total_burned', '3': 2, '4': 1, '5': 9, '10': 'totalBurned'},
  ],
};

/// Descriptor for `TokenStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tokenStatsDescriptor = $convert.base64Decode('CgpUb2tlblN0YXRzEiEKDHRvdGFsX21pbnRlZBgBIAEoCVILdG90YWxNaW50ZWQSIQoMdG90YWxfYnVybmVkGAIgASgJUgt0b3RhbEJ1cm5lZA==');
@$core.Deprecated('Use txInputDescriptor instead')
const TxInput$json = const {
  '1': 'TxInput',
  '2': const [
    const {'1': 'prev_out', '3': 1, '4': 1, '5': 11, '6': '.chronik.OutPoint', '10': 'prevOut'},
    const {'1': 'input_script', '3': 2, '4': 1, '5': 12, '10': 'inputScript'},
    const {'1': 'output_script', '3': 3, '4': 1, '5': 12, '10': 'outputScript'},
    const {'1': 'value', '3': 4, '4': 1, '5': 3, '10': 'value'},
    const {'1': 'sequence_no', '3': 5, '4': 1, '5': 13, '10': 'sequenceNo'},
    const {'1': 'slp_burn', '3': 6, '4': 1, '5': 11, '6': '.chronik.SlpBurn', '10': 'slpBurn'},
    const {'1': 'slp_token', '3': 7, '4': 1, '5': 11, '6': '.chronik.SlpToken', '10': 'slpToken'},
  ],
};

/// Descriptor for `TxInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txInputDescriptor = $convert.base64Decode('CgdUeElucHV0EiwKCHByZXZfb3V0GAEgASgLMhEuY2hyb25pay5PdXRQb2ludFIHcHJldk91dBIhCgxpbnB1dF9zY3JpcHQYAiABKAxSC2lucHV0U2NyaXB0EiMKDW91dHB1dF9zY3JpcHQYAyABKAxSDG91dHB1dFNjcmlwdBIUCgV2YWx1ZRgEIAEoA1IFdmFsdWUSHwoLc2VxdWVuY2Vfbm8YBSABKA1SCnNlcXVlbmNlTm8SKwoIc2xwX2J1cm4YBiABKAsyEC5jaHJvbmlrLlNscEJ1cm5SB3NscEJ1cm4SLgoJc2xwX3Rva2VuGAcgASgLMhEuY2hyb25pay5TbHBUb2tlblIIc2xwVG9rZW4=');
@$core.Deprecated('Use txOutputDescriptor instead')
const TxOutput$json = const {
  '1': 'TxOutput',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 3, '10': 'value'},
    const {'1': 'output_script', '3': 2, '4': 1, '5': 12, '10': 'outputScript'},
    const {'1': 'slp_token', '3': 3, '4': 1, '5': 11, '6': '.chronik.SlpToken', '10': 'slpToken'},
    const {'1': 'spent_by', '3': 4, '4': 1, '5': 11, '6': '.chronik.OutPoint', '10': 'spentBy'},
  ],
};

/// Descriptor for `TxOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txOutputDescriptor = $convert.base64Decode('CghUeE91dHB1dBIUCgV2YWx1ZRgBIAEoA1IFdmFsdWUSIwoNb3V0cHV0X3NjcmlwdBgCIAEoDFIMb3V0cHV0U2NyaXB0Ei4KCXNscF90b2tlbhgDIAEoCzIRLmNocm9uaWsuU2xwVG9rZW5SCHNscFRva2VuEiwKCHNwZW50X2J5GAQgASgLMhEuY2hyb25pay5PdXRQb2ludFIHc3BlbnRCeQ==');
@$core.Deprecated('Use blockMetadataDescriptor instead')
const BlockMetadata$json = const {
  '1': 'BlockMetadata',
  '2': const [
    const {'1': 'height', '3': 1, '4': 1, '5': 5, '10': 'height'},
    const {'1': 'hash', '3': 2, '4': 1, '5': 12, '10': 'hash'},
    const {'1': 'timestamp', '3': 3, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `BlockMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockMetadataDescriptor = $convert.base64Decode('Cg1CbG9ja01ldGFkYXRhEhYKBmhlaWdodBgBIAEoBVIGaGVpZ2h0EhIKBGhhc2gYAiABKAxSBGhhc2gSHAoJdGltZXN0YW1wGAMgASgDUgl0aW1lc3RhbXA=');
@$core.Deprecated('Use outPointDescriptor instead')
const OutPoint$json = const {
  '1': 'OutPoint',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
    const {'1': 'out_idx', '3': 2, '4': 1, '5': 13, '10': 'outIdx'},
  ],
};

/// Descriptor for `OutPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outPointDescriptor = $convert.base64Decode('CghPdXRQb2ludBISCgR0eGlkGAEgASgMUgR0eGlkEhcKB291dF9pZHgYAiABKA1SBm91dElkeA==');
@$core.Deprecated('Use slpTokenDescriptor instead')
const SlpToken$json = const {
  '1': 'SlpToken',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 1, '5': 4, '10': 'amount'},
    const {'1': 'is_mint_baton', '3': 2, '4': 1, '5': 8, '10': 'isMintBaton'},
  ],
};

/// Descriptor for `SlpToken`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slpTokenDescriptor = $convert.base64Decode('CghTbHBUb2tlbhIWCgZhbW91bnQYASABKARSBmFtb3VudBIiCg1pc19taW50X2JhdG9uGAIgASgIUgtpc01pbnRCYXRvbg==');
@$core.Deprecated('Use slpBurnDescriptor instead')
const SlpBurn$json = const {
  '1': 'SlpBurn',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 11, '6': '.chronik.SlpToken', '10': 'token'},
    const {'1': 'token_id', '3': 2, '4': 1, '5': 12, '10': 'tokenId'},
  ],
};

/// Descriptor for `SlpBurn`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slpBurnDescriptor = $convert.base64Decode('CgdTbHBCdXJuEicKBXRva2VuGAEgASgLMhEuY2hyb25pay5TbHBUb2tlblIFdG9rZW4SGQoIdG9rZW5faWQYAiABKAxSB3Rva2VuSWQ=');
@$core.Deprecated('Use slpGenesisInfoDescriptor instead')
const SlpGenesisInfo$json = const {
  '1': 'SlpGenesisInfo',
  '2': const [
    const {'1': 'token_ticker', '3': 1, '4': 1, '5': 12, '10': 'tokenTicker'},
    const {'1': 'token_name', '3': 2, '4': 1, '5': 12, '10': 'tokenName'},
    const {'1': 'token_document_url', '3': 3, '4': 1, '5': 12, '10': 'tokenDocumentUrl'},
    const {'1': 'token_document_hash', '3': 4, '4': 1, '5': 12, '10': 'tokenDocumentHash'},
    const {'1': 'decimals', '3': 5, '4': 1, '5': 13, '10': 'decimals'},
  ],
};

/// Descriptor for `SlpGenesisInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slpGenesisInfoDescriptor = $convert.base64Decode('Cg5TbHBHZW5lc2lzSW5mbxIhCgx0b2tlbl90aWNrZXIYASABKAxSC3Rva2VuVGlja2VyEh0KCnRva2VuX25hbWUYAiABKAxSCXRva2VuTmFtZRIsChJ0b2tlbl9kb2N1bWVudF91cmwYAyABKAxSEHRva2VuRG9jdW1lbnRVcmwSLgoTdG9rZW5fZG9jdW1lbnRfaGFzaBgEIAEoDFIRdG9rZW5Eb2N1bWVudEhhc2gSGgoIZGVjaW1hbHMYBSABKA1SCGRlY2ltYWxz');
@$core.Deprecated('Use utxoStateDescriptor instead')
const UtxoState$json = const {
  '1': 'UtxoState',
  '2': const [
    const {'1': 'height', '3': 1, '4': 1, '5': 5, '10': 'height'},
    const {'1': 'is_confirmed', '3': 2, '4': 1, '5': 8, '10': 'isConfirmed'},
    const {'1': 'state', '3': 3, '4': 1, '5': 14, '6': '.chronik.UtxoStateVariant', '10': 'state'},
  ],
};

/// Descriptor for `UtxoState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List utxoStateDescriptor = $convert.base64Decode('CglVdHhvU3RhdGUSFgoGaGVpZ2h0GAEgASgFUgZoZWlnaHQSIQoMaXNfY29uZmlybWVkGAIgASgIUgtpc0NvbmZpcm1lZBIvCgVzdGF0ZRgDIAEoDjIZLmNocm9uaWsuVXR4b1N0YXRlVmFyaWFudFIFc3RhdGU=');
@$core.Deprecated('Use subscriptionDescriptor instead')
const Subscription$json = const {
  '1': 'Subscription',
  '2': const [
    const {'1': 'script_type', '3': 1, '4': 1, '5': 9, '10': 'scriptType'},
    const {'1': 'payload', '3': 2, '4': 1, '5': 12, '10': 'payload'},
    const {'1': 'is_subscribe', '3': 3, '4': 1, '5': 8, '10': 'isSubscribe'},
  ],
};

/// Descriptor for `Subscription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionDescriptor = $convert.base64Decode('CgxTdWJzY3JpcHRpb24SHwoLc2NyaXB0X3R5cGUYASABKAlSCnNjcmlwdFR5cGUSGAoHcGF5bG9hZBgCIAEoDFIHcGF5bG9hZBIhCgxpc19zdWJzY3JpYmUYAyABKAhSC2lzU3Vic2NyaWJl');
@$core.Deprecated('Use subscribeMsgDescriptor instead')
const SubscribeMsg$json = const {
  '1': 'SubscribeMsg',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.chronik.Error', '9': 0, '10': 'error'},
    const {'1': 'AddedToMempool', '3': 2, '4': 1, '5': 11, '6': '.chronik.MsgAddedToMempool', '9': 0, '10': 'AddedToMempool'},
    const {'1': 'RemovedFromMempool', '3': 3, '4': 1, '5': 11, '6': '.chronik.MsgRemovedFromMempool', '9': 0, '10': 'RemovedFromMempool'},
    const {'1': 'Confirmed', '3': 4, '4': 1, '5': 11, '6': '.chronik.MsgConfirmed', '9': 0, '10': 'Confirmed'},
    const {'1': 'Reorg', '3': 5, '4': 1, '5': 11, '6': '.chronik.MsgReorg', '9': 0, '10': 'Reorg'},
    const {'1': 'BlockConnected', '3': 6, '4': 1, '5': 11, '6': '.chronik.MsgBlockConnected', '9': 0, '10': 'BlockConnected'},
    const {'1': 'BlockDisconnected', '3': 7, '4': 1, '5': 11, '6': '.chronik.MsgBlockDisconnected', '9': 0, '10': 'BlockDisconnected'},
  ],
  '8': const [
    const {'1': 'msg_type'},
  ],
};

/// Descriptor for `SubscribeMsg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeMsgDescriptor = $convert.base64Decode('CgxTdWJzY3JpYmVNc2cSJgoFZXJyb3IYASABKAsyDi5jaHJvbmlrLkVycm9ySABSBWVycm9yEkQKDkFkZGVkVG9NZW1wb29sGAIgASgLMhouY2hyb25pay5Nc2dBZGRlZFRvTWVtcG9vbEgAUg5BZGRlZFRvTWVtcG9vbBJQChJSZW1vdmVkRnJvbU1lbXBvb2wYAyABKAsyHi5jaHJvbmlrLk1zZ1JlbW92ZWRGcm9tTWVtcG9vbEgAUhJSZW1vdmVkRnJvbU1lbXBvb2wSNQoJQ29uZmlybWVkGAQgASgLMhUuY2hyb25pay5Nc2dDb25maXJtZWRIAFIJQ29uZmlybWVkEikKBVJlb3JnGAUgASgLMhEuY2hyb25pay5Nc2dSZW9yZ0gAUgVSZW9yZxJECg5CbG9ja0Nvbm5lY3RlZBgGIAEoCzIaLmNocm9uaWsuTXNnQmxvY2tDb25uZWN0ZWRIAFIOQmxvY2tDb25uZWN0ZWQSTQoRQmxvY2tEaXNjb25uZWN0ZWQYByABKAsyHS5jaHJvbmlrLk1zZ0Jsb2NrRGlzY29ubmVjdGVkSABSEUJsb2NrRGlzY29ubmVjdGVkQgoKCG1zZ190eXBl');
@$core.Deprecated('Use msgAddedToMempoolDescriptor instead')
const MsgAddedToMempool$json = const {
  '1': 'MsgAddedToMempool',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
  ],
};

/// Descriptor for `MsgAddedToMempool`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAddedToMempoolDescriptor = $convert.base64Decode('ChFNc2dBZGRlZFRvTWVtcG9vbBISCgR0eGlkGAEgASgMUgR0eGlk');
@$core.Deprecated('Use msgRemovedFromMempoolDescriptor instead')
const MsgRemovedFromMempool$json = const {
  '1': 'MsgRemovedFromMempool',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
  ],
};

/// Descriptor for `MsgRemovedFromMempool`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgRemovedFromMempoolDescriptor = $convert.base64Decode('ChVNc2dSZW1vdmVkRnJvbU1lbXBvb2wSEgoEdHhpZBgBIAEoDFIEdHhpZA==');
@$core.Deprecated('Use msgConfirmedDescriptor instead')
const MsgConfirmed$json = const {
  '1': 'MsgConfirmed',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
  ],
};

/// Descriptor for `MsgConfirmed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgConfirmedDescriptor = $convert.base64Decode('CgxNc2dDb25maXJtZWQSEgoEdHhpZBgBIAEoDFIEdHhpZA==');
@$core.Deprecated('Use msgReorgDescriptor instead')
const MsgReorg$json = const {
  '1': 'MsgReorg',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
  ],
};

/// Descriptor for `MsgReorg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgReorgDescriptor = $convert.base64Decode('CghNc2dSZW9yZxISCgR0eGlkGAEgASgMUgR0eGlk');
@$core.Deprecated('Use msgBlockConnectedDescriptor instead')
const MsgBlockConnected$json = const {
  '1': 'MsgBlockConnected',
  '2': const [
    const {'1': 'block_hash', '3': 1, '4': 1, '5': 12, '10': 'blockHash'},
  ],
};

/// Descriptor for `MsgBlockConnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgBlockConnectedDescriptor = $convert.base64Decode('ChFNc2dCbG9ja0Nvbm5lY3RlZBIdCgpibG9ja19oYXNoGAEgASgMUglibG9ja0hhc2g=');
@$core.Deprecated('Use msgBlockDisconnectedDescriptor instead')
const MsgBlockDisconnected$json = const {
  '1': 'MsgBlockDisconnected',
  '2': const [
    const {'1': 'block_hash', '3': 1, '4': 1, '5': 12, '10': 'blockHash'},
  ],
};

/// Descriptor for `MsgBlockDisconnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgBlockDisconnectedDescriptor = $convert.base64Decode('ChRNc2dCbG9ja0Rpc2Nvbm5lY3RlZBIdCgpibG9ja19oYXNoGAEgASgMUglibG9ja0hhc2g=');
@$core.Deprecated('Use errorDescriptor instead')
const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'error_code', '3': 1, '4': 1, '5': 9, '10': 'errorCode'},
    const {'1': 'msg', '3': 2, '4': 1, '5': 9, '10': 'msg'},
    const {'1': 'is_user_error', '3': 3, '4': 1, '5': 8, '10': 'isUserError'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode('CgVFcnJvchIdCgplcnJvcl9jb2RlGAEgASgJUgllcnJvckNvZGUSEAoDbXNnGAIgASgJUgNtc2cSIgoNaXNfdXNlcl9lcnJvchgDIAEoCFILaXNVc2VyRXJyb3I=');
