import 'dart:isolate';
import 'package:test/test.dart';
import 'dart:io';
import 'package:cashew/electrum/rpc.dart';

void runFakeElectrum(SendPort sendPort) async {
  HttpServer httpServer = await HttpServer.bind(InternetAddress.anyIPv4, 0);
  Uri url = Uri.parse('ws://${httpServer.address.host}:${httpServer.port}/');

  print("HttpServer listening...");
  httpServer.serverHeader = "PoopHeader";
  print(url);

  httpServer.listen((HttpRequest request) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then(handleWebSocket);
    } else {
      print("Regular ${request.method} request for: ${request.uri.path}");
      serveRequest(request);
    }
  }, onError: (error) {
    print('some error');
    print(error);
  }, onDone: () {
    print('done');
  });

  sendPort.send(url);
}

void handleWebSocket(WebSocket socket) {
  socket.listen((dynamic s) {
    socket.add('{"id": 0, "result": ["poop"], "jsonrpc": "2.0"}');
  }, onDone: () {
    print('Client disconnected');
  });
}

void serveRequest(HttpRequest request) {
  request.response.statusCode = HttpStatus.forbidden;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}

void main() {
  ReceivePort receivePort;
  Uri url;
  Isolate isolate;

  setUp(() async {
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(runFakeElectrum, receivePort.sendPort);
    url = await receivePort.first;
  });

  tearDown(() async {
    isolate.kill();
    url = null;
  });

  test('electrum rpcs are handled', () async {
    print(url);

    final client = JSONRPCWebsocket();
    await client.connect(url);
    final result = await client.sendMessage('echo', ['poop']);
    print(result);
    await Future.delayed(Duration(seconds: 10));
    client.dispose();
  });
}
