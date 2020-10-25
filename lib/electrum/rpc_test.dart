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
  print('Client connected!');
  socket.listen((dynamic s) {
    print(' Client sent: $s');
    socket.add('echo: $s');
    print('Echo\'d');
    socket.add('hmm');
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

    final client = ElectrumRPCChannel();
    await client.connect(url);
    client.sendMessage('Here is a param');
    client.sendMessage('Here is another param');
    client.dispose();
  });
}
