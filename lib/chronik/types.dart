/// Current state of the blockchain. */
class BlockchainInfo {
  /// Block hash of the current blockchain tip */
  final String tipHash;

  /// Current height of the blockchain */
  final int tipHeight;

  BlockchainInfo(this.tipHash, this.tipHeight);
}

/// A transaction on the blockchain or in the mempool. */
class Tx {
  /// Transaction ID.
  /// - On BCH, eCash and Ergon, this is the hash of the tx.
  /// - On Lotus, this is a special serialization, omitting the input scripts.
  final String txid;

  /// `version` field of the transaction. */
  final int version;

  /// Inputs of this transaction. */
  final List<TxInput> inputs;

  /// Outputs of this transaction. */
  final List<TxOutput> outputs;

  /// `locktime` field of the transaction, tx is not valid before this time. */
  final int lockTime;

  /// SLP data about this transaction, if valid. */
  final SlpTxData? slpTxData;

  /// A human-readable message as to why this tx is not an SLP transaction,
  /// unless trivially so. */
  final String? slpErrorMsg;

  /// Block data for this tx, or undefined if not mined yet. */
  final BlockMetadata? block;

  /// UNIX timestamp when this tx has first been seen in the mempool.
  /// 0 if unknown -> make sure to check.
  final String timeFirstSeen;

  /// Serialized size of the tx. */
  final int size;

  /// Whether this tx is a coinbase tx. */
  final bool isCoinbase;

  /// Which network this tx is on. */
  final Network network;

  Tx(
      this.txid,
      this.version,
      this.inputs,
      this.outputs,
      this.lockTime,
      this.slpTxData,
      this.slpErrorMsg,
      this.block,
      this.timeFirstSeen,
      this.size,
      this.isCoinbase,
      this.network);
}

/// An unspent transaction output (aka. UTXO, aka. "Coin") of a script. */
class Utxo {
  /// Outpoint of the UTXO. */
  final Outpoint outpoint;

  /// Which block this UTXO is in, or -1 if in the mempool. */
  final int blockHeight;

  /// Whether this UTXO is a coinbase UTXO
  /// (make sure it's buried 100 blocks before spending!) */
  final bool isCoinbase;

  /// Value of the UTXO in satoshis. */
  final String value;

  /// SLP data in this UTXO. */
  final SlpMeta? slpMeta;

  /// SLP token of this UTXO (i.e. SLP amount + whether it's a mfinal int baton). */
  final SlpToken? slpToken;

  /// Which network this UTXO is on. */
  final Network network;

  Utxo(this.outpoint, this.blockHeight, this.isCoinbase, this.value,
      this.slpMeta, this.slpToken, this.network);
}

/// Data and stats about an SLP token. */
class Token {
  /// SLP data of the GENESIS transaction. */
  final SlpTokenTxData slpTxData;

  /// Current stats about this token, e.g. mfinal inted and burned amount. */
  final TokenStats tokenStats;

  /// Block the GENESIS transaction has been mined in, or undefined if not mined yet. */
  final BlockMetadata? block;

  /// UNIX timestamp when the GENESIS transaction has first been seen in the mempool.
  /// 0 if unknown. */
  final String timeFirstSeen;

  /// How many tokens have been mined in the GENESIS transaction. */
  final String initialTokenQuantity;

  /// Whether the GENESIS transaction created a mfinal int baton.
  /// Note: This doesn't indicate whether the mfinal int baton is still alive. */
  final bool containsBaton;

  /// Which network this token is on. */
  final Network network;

  Token(this.slpTxData, this.tokenStats, this.block, this.timeFirstSeen,
      this.initialTokenQuantity, this.containsBaton, this.network);
}

/// Block info about a block */
class BlockInfo {
  /// Block hash of the block, in 'human-readable' (big-endian) hex encoding. */
  final String hash;

  /// Block hash of the previous block, in 'human-readable' (big-endian) hex
  /// encoding. */
  final String prevHash;

  /// Height of the block; Genesis block has height 0. */
  final int height;

  /// nBits field of the block, encodes the target compactly. */
  final int nBits;

  /// Timestamp of the block. Filled in by the miner, so might not be 100%
  /// precise. */
  final String timestamp;

  /// Block size of this block in bytes (including headers etc.). */
  final String blockSize;

  /// Number of txs in this block. */
  final String numTxs;

  /// Total number of tx inputs in block (including coinbase). */
  final String numInputs;

  /// Total number of tx output in block (including coinbase). */
  final String numOutputs;

  /// Total number of satoshis spent by tx inputs. */
  final String sumInputSats;

  /// Total block reward for this block. */
  final String sumCoinbaseOutputSats;

  /// Total number of satoshis in non-coinbase tx outputs. */
  final String sumNormalOutputSats;

  /// Total number of satoshis burned using OP_RETURN. */
  final String sumBurnedSats;

  BlockInfo(
      this.hash,
      this.prevHash,
      this.height,
      this.nBits,
      this.timestamp,
      this.blockSize,
      this.numTxs,
      this.numInputs,
      this.numOutputs,
      this.sumInputSats,
      this.sumCoinbaseOutputSats,
      this.sumNormalOutputSats,
      this.sumBurnedSats);
}

/// Additional details about a block. */
class BlockDetails {
  /// nVersion field of the block. */
  final int version;

  /// Merkle root of the block. */
  final String merkleRoot;

  /// Nonce of the block (32-bit on XEC, 64-bit on XPI). */
  final String nonce;

  /// Median-time-past (MTP) of the last 11 blocks. */
  final String medianTimestamp;

  BlockDetails(this.version, this.merkleRoot, this.nonce, this.medianTimestamp);
}

/// Block on the blockchain. */
class Block {
  /// Info about the block. */
  final BlockInfo blockInfo;

  /// Details about the block. */
  final BlockDetails blockDetails;

  /// Header encoded as hex. */
  final String rawHeader;

  /// Txs in this block, in canonical order
  /// (at least on all supported chains). */
  final List<Tx> txs;

  Block(this.blockInfo, this.blockDetails, this.rawHeader, this.txs);
}

/// Group of UTXOs by output script. */
class ScriptUtxos {
  /// Output script in hex. */
  final String outputScript;

  /// UTXOs of the output script. */
  final List<Utxo> utxos;

  ScriptUtxos(this.outputScript, this.utxos);
}

/// Page of the transaction history. */
class TxHistoryPage {
  /// Txs of this page. */
  final List<Tx> txs;

  /// Number of pages of the entire transaction history.
  /// This changes based on the `pageSize` provided. */
  final int numPages;

  TxHistoryPage(this.txs, this.numPages);
}

/// SLP data about an SLP transaction. */
class SlpTxData {
  /// SLP metadata. */
  final SlpMeta slpMeta;

  /// Genesis info, only present for GENESIS txs. */
  final SlpGenesisInfo? genesisInfo;

  SlpTxData(this.slpMeta, this.genesisInfo);
}

/// SLP data about an SLP transaction. */
class SlpTokenTxData {
  /// SLP metadata. */
  final SlpMeta slpMeta;

  /// Genesis info of the token. */
  final SlpGenesisInfo genesisInfo;

  SlpTokenTxData(this.slpMeta, this.genesisInfo);
}

/// Metadata about an SLP tx or UTXO. */
class SlpMeta {
  /// Whether this token is a normal fungible token, or an NFT or unknown. */
  final SlpTokenType tokenType;

  /// Whether this tx is a GENESIS, Mfinal int, SEND or UNKNOWN transaction. */
  final SlpTxType txType;

  /// Token ID of this tx/UTXO, in human-readable (big-endian) hex encoding. */
  final String tokenId;

  /// Group token ID of this tx/UTXO, NFT only, in human-readable
  /// (big-endian) hex encoding.
  /// This is the token ID of the token that went final into the GENESIS of this token
  /// as first input. */
  final String? groupTokenId;

  SlpMeta(this.tokenType, this.txType, this.tokenId, this.groupTokenId);
}

/// Stats about a token.
///
/// `totalMinted` and `totalBurned` don't fit in a 64-bit final integer, therefore we
/// use a final String with the decimal representation.
class TokenStats {
  /// Total number of tokens mfinal inted (including GENESIS). */
  final String totalMinted;

  /// Total number of tokens burned. */
  final String totalBurned;

  TokenStats(this.totalMinted, this.totalBurned);
}

/// Input of a tx, spends an output of a previous tx. */
class TxInput {
  /// Pofinal ints to an output spent by this input. */
  final Outpoint prevOut;

  /// Script unlocking the output, in hex encoding.
  /// Aka. `scriptSig` in bitcoind parlance. */
  final String inputScript;

  /// Script of the output, in hex encoding.
  /// Aka. `scriptPubKey` in bitcoind parlance. */
  final String? outputScript;

  /// Value of the output spent by this input, in satoshis. */
  final String value;

  /// `sequence` field of the input; can be used for relative time locking. */
  final int sequenceNo;

  /// SLP tokens burned by this input, or `undefined` if no burn occured. */
  final SlpBurn? slpBurn;

  /// SLP tokens spent by this input, or `undefined` if the tokens were burned
  /// or if there were no tokens in the output spent by this input. */
  final SlpToken? slpToken;

  TxInput(this.prevOut, this.inputScript, this.outputScript, this.value,
      this.sequenceNo, this.slpBurn, this.slpToken);
}

/// Output of a tx, creates new UTXOs. */
class TxOutput {
  /// Value of the output, in satoshis. */
  final String value;

  /// Script of this output, locking the coins.
  /// Aka. `scriptPubKey` in bitcoind parlance. */
  final String outputScript;

  /// SLP tokens locked up in this output, or `undefined` if no tokens were sent
  /// to this output. */
  final SlpToken? slpToken;

  /// Transaction & input index spending this output, or undefined if
  /// unspent. */
  final Outpoint? spentBy;

  TxOutput(this.value, this.outputScript, this.slpToken, this.spentBy);
}

/// Metadata of a block, used in transaction data. */
class BlockMetadata {
  /// Height of the block. */
  final int height;

  /// Hash of the block. */
  final String hash;

  /// Timestamp of the block; useful if `timeFirstSeen` of a transaction is
  /// unknown. */
  final String timestamp;

  BlockMetadata(this.height, this.hash, this.timestamp);
}

/// Outpoint referencing an output on the blockchain (or input for field
/// `spentBy`). */
class Outpoint {
  /// Transaction referenced by this outpoint. */
  final String txid;

  /// Index of the output in the tx referenced by this outpoint
  /// (or input index if used in field `spentBy`). */
  final int outIdx;

  Outpoint(this.txid, this.outIdx);
}

/// SLP amount or whether this is a mfinal int baton, for inputs and outputs. */
class SlpToken {
  /// SLP amount of the input or output, in base units. */
  final String amount;

  /// Whether this input/output is a mint baton. */
  final bool isMintBaton;

  SlpToken(this.amount, this.isMintBaton);
}

/// SLP burn; indicates burn of some tokens. */
class SlpBurn {
  /// SLP amount/mfinal int baton burned by this burn. */
  final SlpToken token;

  /// Token ID of the burned SLP tokens, in human-readable (big-endian) hex
  /// encoding. */
  final String tokenId;

  SlpBurn(this.token, this.tokenId);
}

/// SLP info about a GENESIS transaction. */
class SlpGenesisInfo {
  /// Ticker of the token, decoded as UTF-8. */
  final String tokenTicker;

  /// Name of the token, decoded as UTF-8. */
  final String tokenName;

  /// URL of the token, decoded as UTF-8. */
  final String tokenDocumentUrl;

  /// Document hash of the token, encoded in hex (byte order as occuring in the
  /// OP_RETURN). */
  final String tokenDocumentHash;

  /// Number of decimals of the GENESIS transaction. */
  final int decimals;

  SlpGenesisInfo(this.tokenTicker, this.tokenName, this.tokenDocumentUrl,
      this.tokenDocumentHash, this.decimals);
}

/// State of a UTXO (from `validateUtxos`). */
class UtxoState {
  /// Height of the UTXO. -1 if the tx doesn't exist or is unconfirmed.
  /// If it's confirmed (or if the output doesn't exist but the tx does),
  /// it's the height of the block confirming the tx. */
  final int height;

  /// Whether the UTXO or the transaction queried is confirmed. */
  final bool isConfirmed;

  /// State of the UTXO, can be unconfirmed, confirmed, tx doesn't exist or
  /// output doesn't exist. */
  final UtxoStateVariant state;

  UtxoState(this.height, this.isConfirmed, this.state);
}

/// Message returned from the WebSocket. */
enum SubscribeMsg {
  Error,
  MsgAddedToMempool,
  MsgRemovedFromMempool,
  MsgConfirmed,
  MsgReorg,
  MsgBlockConnected,
  MsgBlockDisconnected
}

/// A transaction has been added to the mempool. */
class MsgAddedToMempool {
  final type = "AddedToMempool";

  /// txid of the transaction, in 'human-readable' (big-endian) hex encoding. */
  final String txid;

  MsgAddedToMempool(this.txid);
}

/// A transaction has been removed from the mempool,
/// but not because of a confirmation (e.g. expiry, conflict, etc.).
class MsgRemovedFromMempool {
  final type = "RemovedFromMempool";

  /// txid of the transaction, in 'human-readable' (big-endian) hex encoding. */
  final String txid;

  MsgRemovedFromMempool(this.txid);
}

/// A transaction has been confirmed in a block. */
class MsgConfirmed {
  final type = "Confirmed";

  /// txid of the transaction, in 'human-readable' (big-endian) hex encoding. */
  final String txid;

  MsgConfirmed(this.txid);
}

/// A transaction used to be part of a block but now got re-orged.
/// Usually, unless something malicious occurs, a "Confirmed" message is sent
/// immediately afterwards.
class MsgReorg {
  final type = "Reorg";

  /// txid of the transaction, in 'human-readable' (big-endian) hex encoding. */
  final String txid;

  MsgReorg(this.txid);
}

/// A new block has been added to the chain. Sent regardless of subscriptions. */
class MsgBlockConnected {
  final type = "BlockConnected";

  /// block hash of the block, in 'human-readable' (big-endian) hex encoding. */
  final String blockHash;

  MsgBlockConnected(this.blockHash);
}

/// A block has been removed from the chain. Sent regardless of subscriptions. */
class MsgBlockDisconnected {
  final type = "BlockDisconnected";

  /// block hash of the block, in 'human-readable' (big-endian) hex encoding. */
  final String blockHash;

  MsgBlockDisconnected(this.blockHash);
}

/// Reports an error, e.g. when a subscription is malformed. */
class Error {
  final type = "Error";

  /// Code for this error, e.g. "tx-not-found". */
  final String errorCode;

  /// Human-readable message for this error. */
  final String msg;

  /// Whether this error is presentable to an end-user.
  /// This is somewhat subjective, but can be used as a good heuristic. */
  final bool isUserError;

  Error(this.errorCode, this.msg, this.isUserError);
}

/// Different networks of txs/blocks/UTXOs.
/// Supported are BCH, eCash, Lotus and Ergon. */
enum Network { BCH, XEC, XPI, XRG }

/// Which SLP tx type. */
enum SlpTxType { GENESIS, SEND, MINT, UNKNOWN_TX_TYPE }

/// Which SLP token type (normal fungible, NFT, unknown). */
enum SlpTokenType {
  FUNGIBLE,
  NFT1_GROUP,
  NFT1_CHILD,
  UNKNOWN_TOKEN_TYPE,
}

/// State of a transaction output.
/// - `UNSPENT`: The UTXO is unspent.
/// - `SPENT`: The output is spent and no longer part of the UTXO set.
/// - `NO_SUCH_TX`: The tx queried does not exist.
/// - `NO_SUCH_OUTPUT`: The output queried does not exist, but the tx does exist.
enum UtxoStateVariant {
  UNSPENT,
  SPENT,
  NO_SUCH_TX,
  NO_SUCH_OUTPUT,
}

/// Script type queried in the `script` method.
/// - `other`: Script type not covered by the standard script types; payload is
///   the raw hex.
/// - `p2pk`: Pay-to-Public-Key (`<pk> OP_CHECKSIG`), payload is the hex of the
///   pubkey (compressed (33 bytes) or uncompressed (65 bytes)).
/// - `p2pkh`: Pay-to-Public-Key-Hash
///   (`OP_DUP OP_HASH160 <pkh> OP_EQUALVERIFY OP_CHECKSIG`).
///   Payload is the 20 byte public key hash.
/// - `p2sh`: Pay-to-Script-Hash (`OP_HASH160 <sh> OP_EQUAL`).
///   Payload is the 20 byte script hash.
/// - `p2tr-commitment`: Pay-to-Taproot
///   (`OP_SCRIPTTYPE OP_1 <commitment> <state>?`), only on Lotus.
///   Queries by the commitment. Payload is the 33 byte commitment.
/// - `p2tr-state`: Pay-to-Taproot (`OP_SCRIPTTYPE OP_1 <commitment> <state>`),
///   only on Lotus. Queries by the state. Payload is the 32 byte state.
enum ScriptType { other, p2pk, p2pkh, p2sh, p2trCommitment, p2trState }
