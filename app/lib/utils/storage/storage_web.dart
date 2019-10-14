library storage;

import 'dart:convert';
import 'dart:html';

import 'package:ginko/utils/storage/storage_base.dart';

/// Storage class
/// handles storage on web devices
class Storage extends StorageBase {
  @override
  // ignore: missing_return
  Future init() {}

  @override
  int getInt(String key) => window.localStorage.containsKey(key)
      ? int.tryParse(window.localStorage[key])
      : null;

  @override
  void setInt(String key, int value) => window.localStorage[key] = '$value';

  @override
  String getString(String key) =>
      window.localStorage.containsKey(key) ? window.localStorage[key] : null;

  @override
  void setString(String key, String value) =>
      window.localStorage[key] = '$value';

  @override
  bool getBool(String key) => window.localStorage.containsKey(key)
      ? window.localStorage[key] == 'true'
      : null;

  @override
  void setBool(String key, bool value) => window.localStorage[key] = '$value';

  @override
  Map<String, dynamic> getJSON(String key) => json.decode(getString(key));

  @override
  void setJSON(String key, Map<String, dynamic> value) =>
      setString(key, json.encode(value));

  @override
  bool has(String key) => window.localStorage[key] != null;
}
