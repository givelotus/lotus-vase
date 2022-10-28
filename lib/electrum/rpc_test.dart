import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:test/test.dart';

import 'client.dart';
import 'rpc.dart';

class FakeElectrumParams {
  final SendPort? sendPort;
  final List<dynamic>? responses;
  FakeElectrumParams({this.sendPort, this.responses});
}

void runFakeElectrum(FakeElectrumParams params) async {
  var httpServer = await HttpServer.bind(InternetAddress.anyIPv4, 0);
  var url = Uri.parse('ws://${httpServer.address.host}:${httpServer.port}/');

  httpServer.serverHeader = 'Fake Electrum Server';

  httpServer.listen((HttpRequest request) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then((WebSocket socket) {
        socket.listen((dynamic msg) {
          final decodedResponse = jsonDecode(msg as String);
          final responses = params.responses!.where((response) =>
              response['id'] == decodedResponse['id'] ||
              response['method'] == decodedResponse['method']);
          for (final response in responses) {
            socket.add(jsonEncode(response));
          }
        }, onDone: () {
          print('Client disconnected');
        });
      });
    } else {
      print('Regular ${request.method} request for: ${request.uri.path}');
      request.response.statusCode = HttpStatus.forbidden;
      request.response.reasonPhrase = 'WebSocket connections only';
      request.response.close();
    }
  }, onError: (error) {
    print('some error');
    print(error);
  }, onDone: () {
    print('done');
  });

  params.sendPort!.send(url);
}

typedef RPCServerClientCallback = Future<void> Function(Uri? url);

Future<void> Function() withRPCServer(
    List<Object> responses, RPCServerClientCallback clientTest) {
  return () async {
    var receivePort = ReceivePort();
    var isolate = await Isolate.spawn(
        runFakeElectrum,
        FakeElectrumParams(
            sendPort: receivePort.sendPort, responses: responses));
    final url = await (receivePort.first as Future<Uri?>);
    try {
      await clientTest(url);
    } finally {
      isolate.kill();
    }
  };
}

void main() {
  test(
      'json rpc happy-path works',
      withRPCServer([
        {
          'id': 0,
          'result': ['poop']
        },
        {'id': 1, 'result': []}
      ], (Uri? url) async {
        final client = JSONRPCWebsocket();
        await client.connect(url!);
        final result = await client.call('poop', []);
        expect(result, ['poop']);
        client.dispose();
      }));

  test(
      'electrum client basic method works',
      withRPCServer([
        {
          'method': 'blockchain.scripthash.subscribe',
          'params': ['foo', 'bar']
        },
        {
          'method': 'blockchain.scripthash.subscribe',
          'params': ['bob', 'bar']
        },
        {'id': 0, 'result': 'some weird electrum hash'},
      ], (Uri? url) async {
        final client = ElectrumClient();
        await client.connect(url!);
        var currentCompleter = 0;
        var testTable = [
          {
            'completer': Completer(),
            'expectedResult': ['foo', 'bar'],
          },
          {
            'completer': Completer(),
            'expectedResult': ['bob', 'bar']
          }
        ];
        final result =
            await client.blockchainScripthashSubscribe('Test', (params) {
          final completer =
              testTable[currentCompleter++]['completer'] as Completer;
          completer.complete(params);
        });
        expect(result, 'some weird electrum hash');

        for (final tableEntry in testTable) {
          final completer = tableEntry['completer'] as Completer;
          final params = await completer.future;
          final expectedResult = tableEntry['expectedResult'];
          expect(params, expectedResult);
        }
        client.dispose();
      }));
}
