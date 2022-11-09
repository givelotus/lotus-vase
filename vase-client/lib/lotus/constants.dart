const DEFAULT_NLOCKTIME = 0;
const MAX_BLOCK_SIZE = 1000000;

/// Minimum amount for an output for it not to be considered a dust output
final DUST_AMOUNT = BigInt.from(546);

/// Margin of error to allow fees in the vecinity of the expected value but doesn't allow a big difference
final FEE_SECURITY_MARGIN = BigInt.from(150);

/// max amount of satoshis in circulation
final MAX_MONEY = BigInt.from(21000000 * 1e8);

/// nlocktime limit to be considered block height rather than a timestamp
const NLOCKTIME_BLOCKHEIGHT_LIMIT = 5e8;

const DEFAULT_SEQNUMBER = 0xFFFFFFFF;
const DEFAULT_LOCKTIME_SEQNUMBER = DEFAULT_SEQNUMBER - 1;

/// Max value for an unsigned 32 bit value
const NLOCKTIME_MAX_VALUE = 4294967295;

/// Value used for fee estimation (satoshis per kilobyte)
const FEE_PER_KB = 2000;

/// Safe upper bound for change address script size in bytes
const CHANGE_OUTPUT_MAX_SIZE = 20 + 4 + 34 + 4;
const MAXIMUM_EXTRA_SIZE = 4 + 9 + 9 + 4;
const SCRIPT_MAX_SIZE = 149;
