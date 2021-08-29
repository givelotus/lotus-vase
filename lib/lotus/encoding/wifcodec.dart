class WIFCodec {
  bool compressed;

  WIFCodec.fromBase58(params, base58) {
    throw Exception('unimplemented');
  }

// Used by ECKey.getPrivateKeyEncoded()
  WIFCodec(params, List<int> keyBytes, bool compressed) {
    this.compressed = compressed;
  }

  static List<int> encode(List<int> keyBytes, bool compressed) {
    if (!compressed) {
      return keyBytes;
    } else {
      // Keys that have compressed public components have an extra 1 byte on the end in dumped form.
      var bytes = List.filled(33, 0);

      bytes.setRange(0, 32, keyBytes);
      bytes[32] = 1;
      return bytes;
    }
  }
}
