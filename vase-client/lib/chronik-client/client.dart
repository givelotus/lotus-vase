/// Client to access a Chronik instance.Plain object, without any
/// connections. */
class ChronikClient {
  private _url: string
  private _wsUrl: string

  /**
   * Create a new client. This just creates an object, without any connections.
   *
   * @param url Url of a Chronik instance, with schema and without trailing
   *            slash. E.g. https://chronik.be.cash/xec.
   */
  constructor(url: string) {
    this._url = url
    if (url.endsWith("/")) {
      throw new Error("`url` cannot end with '/', got: " + url)
    }
    if (url.startsWith("https://")) {
      this._wsUrl = "wss://" + url.substring("https://".length)
    } else if (url.startsWith("http://")) {
      this._wsUrl = "ws://" + url.substring("http://".length)
    } else {
      throw new Error(
        "`url` must start with 'https://' or 'http://', got: " + url,
      )
    }
  }

  /// Broadcasts the `rawTx` on the network.
  /// If `skipSlpCheck` is false, it will be checked that the tx doesn't burn
  /// any SLP tokens before broadcasting.
  public async broadcastTx(
    rawTx: Uint8Array | string,
    skipSlpCheck = false,
  ): Promise<{ txid: string }> {
    const request = proto.BroadcastTxRequest.encode({
      rawTx: typeof rawTx === "string" ? fromHex(rawTx) : rawTx,
      skipSlpCheck,
    }).finish()
    const data = await _post(this._url, "/broadcast-tx", request)
    const broadcastResponse = proto.BroadcastTxResponse.decode(data)
    return {
      txid: toHexRev(broadcastResponse.txid),
    }
  }

  /// Broadcasts the `rawTxs` on the network, only if all of them are valid.
  /// If `skipSlpCheck` is false, it will be checked that the txs don't burn
  /// any SLP tokens before broadcasting.
  public async broadcastTxs(
    rawTxs: (Uint8Array | string)[],
    skipSlpCheck = false,
  ): Promise<{ txids: string[] }> {
    const request = proto.BroadcastTxsRequest.encode({
      rawTxs: rawTxs.map(rawTx =>
        typeof rawTx === "string" ? fromHex(rawTx) : rawTx,
      ),
      skipSlpCheck,
    }).finish()
    const data = await _post(this._url, "/broadcast-txs", request)
    const broadcastResponse = proto.BroadcastTxsResponse.decode(data)
    return {
      txids: broadcastResponse.txids.map(toHexRev),
    }
  }

  /// Fetch current info of the blockchain, such as tip hash and height. */
  public async blockchainInfo(): Promise<BlockchainInfo> {
    const data = await _get(this._url, `/blockchain-info`)
    const blockchainInfo = proto.BlockchainInfo.decode(data)
    return convertToBlockchainInfo(blockchainInfo)
  }

  /// Fetch the block given hash or height. */
  public async block(hashOrHeight: string | number): Promise<Block> {
    const data = await _get(this._url, `/block/${hashOrHeight}`)
    const block = proto.Block.decode(data)
    return convertToBlock(block)
  }

  /// Fetch block info of a range of blocks. `startHeight` and `endHeight` are
  /// inclusive ranges. */
  public async blocks(
    startHeight: number,
    endHeight: number,
  ): Promise<BlockInfo[]> {
    const data = await _get(this._url, `/blocks/${startHeight}/${endHeight}`)
    const blocks = proto.Blocks.decode(data)
    return blocks.blocks.map(convertToBlockInfo)
  }

  /// Fetch tx details given the txid. */
  public async tx(txid: string): Promise<Tx> {
    const data = await _get(this._url, `/tx/${txid}`)
    const tx = proto.Tx.decode(data)
    return convertToTx(tx)
  }

  /// Fetch token info and stats given the tokenId. */
  public async token(tokenId: string): Promise<Token> {
    const data = await _get(this._url, `/token/${tokenId}`)
    const token = proto.Token.decode(data)
    return convertToToken(token)
  }

  /// Validate the given outpoints: whether they are unspent, spent or
  /// never existed. */
  public async validateUtxos(outpoints: OutPoint[]): Promise<UtxoState[]> {
    const request = proto.ValidateUtxoRequest.encode({
      outpoints: outpoints.map(outpoint => ({
        txid: fromHexRev(outpoint.txid),
        outIdx: outpoint.outIdx,
      })),
    }).finish()
    const data = await _post(this._url, "/validate-utxos", request)
    const validationStates = proto.ValidateUtxoResponse.decode(data)
    return validationStates.utxoStates.map(state => ({
      height: state.height,
      isConfirmed: state.isConfirmed,
      state: convertToUtxoStateVariant(state.state),
    }))
  }

  /// Create object that allows fetching script history or UTXOs. */
  public script(scriptType: ScriptType, scriptPayload: string): ScriptEndpoint {
    return new ScriptEndpoint(this._url, scriptType, scriptPayload)
  }

  /// Open a WebSocket connection to listen for updates. */
  public ws(config: WsConfig): WsEndpoint {
    return new WsEndpoint(`${this._wsUrl}/ws`, config)
  }
}

/// Allows fetching script history and UTXOs. */
class ScriptEndpoint {
  private _url: string
  private _scriptType: string
  private _scriptPayload: string

  constructor(url: string, scriptType: string, scriptPayload: string) {
    this._url = url
    this._scriptType = scriptType
    this._scriptPayload = scriptPayload
  }

  /// Fetches the tx history of this script, in anti-chronological order.
  /// This means it's ordered by first-seen first. If the tx hasn't been seen
  /// by the indexer before, it's ordered by the block timestamp.
  /// @param page Page index of the tx history.
  /// @param pageSize Number of txs per page.
  public async history(
    page?: number,
    pageSize?: number,
  ): Promise<TxHistoryPage> {
    const query =
      page !== undefined && pageSize !== undefined
        ? `?page=${page}&page_size=${pageSize}`
        : page !== undefined
        ? `?page=${page}`
        : pageSize !== undefined
        ? `?page_size=${pageSize}`
        : ""
    const data = await _get(
      this._url,
      `/script/${this._scriptType}/${this._scriptPayload}/history${query}`,
    )
    const historyPage = proto.TxHistoryPage.decode(data)
    return {
      txs: historyPage.txs.map(convertToTx),
      numPages: historyPage.numPages,
    }
  }

  /// Fetches the current UTXO set for this script.
  /// It is grouped by output script, in case a script type can match multiple
  /// different output scripts (e.g. Taproot on Lotus). */
  public async utxos(): Promise<ScriptUtxos[]> {
    const data = await _get(
      this._url,
      `/script/${this._scriptType}/${this._scriptPayload}/utxos`,
    )
    const utxos = proto.Utxos.decode(data)
    return utxos.scriptUtxos.map(scriptUtxos => ({
      outputScript: toHex(scriptUtxos.outputScript),
      utxos: scriptUtxos.utxos.map(convertToUtxo),
    }))
  }
}