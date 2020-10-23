import 'package:cashew/electrum/rpc.dart';

class ElectrumClient {
  RpcChannel channel;
  Stream<RpcRequest> notifications;
  int currentId = 0;

  ElectrumClient(this.channel, this.notifications, {this.currentId});

  ElectrumClient.connect(String url) {
    channel = RpcChannel.connect(url);
    notifications = channel.stream.where((response) => response.id != null);
  }

  Future<RpcResponse> sendRaw(String method, Object params) async {
    // Create request
    this.currentId += 1; // TODO: Make this atomic? fetch_and_add?
    final currentId = this.currentId;
    final fullRequest = RpcRequest(method, id: currentId, params: params);

    // Send down websocket
    this.channel.sink.add(fullRequest);

    return this.channel.stream.firstWhere(
        (response) => response.id == currentId); // TODO: Add timeout here
  }
}
