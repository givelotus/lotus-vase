import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SCHEMA_VERSION_KEY = 'schema_version';

const CURRENT_SCHEMA_VERSION = '0.1.0';

Future<String> readSchemaVersion() {
  final storage = FlutterSecureStorage();
  return storage.read(key: SCHEMA_VERSION_KEY);
}

Future<void> writeSchemaVersion() {
  final storage = FlutterSecureStorage();
  return storage.write(key: SCHEMA_VERSION_KEY, value: CURRENT_SCHEMA_VERSION);
}
