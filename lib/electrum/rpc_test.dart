import 'package:test/test.dart';
import 'dart:io';
import 'package:cashew/electrum/rpc.dart';

void main() {
  HttpServer server;
  Uri url;
  setUp(() async {
    server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
    url = Uri.parse('ws://${server.address.host}:${server.port}');
    server.listen((HttpRequest request) {
      print(request);
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocketTransformer.upgrade(request).then(handleWebSocket);
      } else {
        print("Regular ${request.method} request for: ${request.uri.path}");
        serveRequest(request);
      }
    });
  });

  tearDown(() async {
    await server.close(force: true);
    server = null;
    url = null;
  });

  test('electrum rpcs are handled', () {
    print(url);

    final client = ElectrumRPCChannel();
    client.connect(url);
    sleep(const Duration(seconds: 1));
    client.sendMessage('hello world 2');
    sleep(const Duration(seconds: 60));
    print('hrm');
    client.dispose();
  });
}

void handleWebSocket(WebSocket socket) {
  print('Client connected!');
  socket.listen((dynamic s) {
    print('Client sent: $s');
    socket.add('echo: $s');
  }, onDone: () {
    print('Client disconnected');
  });
}

void serveRequest(HttpRequest request) {
  request.response.statusCode = HttpStatus.forbidden;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}
