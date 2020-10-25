import 'dart:isolate';
import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:cashew/electrum/rpc.dart';

class FakeElectrumParams {
  final SendPort sendPort;
  final List<Object> responses;
  FakeElectrumParams({this.sendPort, this.responses});
}

void runFakeElectrum(FakeElectrumParams params) async {
  HttpServer httpServer = await HttpServer.bind(InternetAddress.anyIPv4, 0);
  Uri url = Uri.parse('ws://${httpServer.address.host}:${httpServer.port}/');

  httpServer.serverHeader = "Fake Electrum Server";

  httpServer.listen((HttpRequest request) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then((WebSocket socket) {
        socket.listen((dynamic s) {
          socket.add('{"id": 0, "result": ["poop"], "jsonrpc": "2.0"}');
        }, onDone: () {
          print('Client disconnected');
        });
      });
    } else {
      print("Regular ${request.method} request for: ${request.uri.path}");
      request.response.statusCode = HttpStatus.forbidden;
      request.response.reasonPhrase = "WebSocket connections only";
      request.response.close();
    }
  }, onError: (error) {
    print('some error');
    print(error);
  }, onDone: () {
    print('done');
  });

  params.sendPort.send(url);
}

typedef Future<void> RPCServerClientCallback(Uri url);

withRPCServer(List<Object> responses, RPCServerClientCallback clientTest) {
  return () async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
        runFakeElectrum,
        FakeElectrumParams(
            sendPort: receivePort.sendPort, responses: responses));
    Uri url = await receivePort.first;
    try {
      await clientTest(url);
    } finally {
      isolate.kill();
    }
  };
}

void main() {
  test(
      'electrum rpcs are handled',
      withRPCServer([
        {
          "id": 0,
          "result": ["poop"]
        }
      ], (Uri url) async {
        final client = JSONRPCWebsocket();
        await client.connect(url);
        final result = await client.callMethod('echo', ['poop']);
        expect(result, ['poop']);
        client.dispose();
      }));
}
