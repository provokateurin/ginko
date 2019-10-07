import 'dart:convert';
import 'dart:io';

// ignore: avoid_classes_with_only_static_members
/// Config class
/// handles all config things
class Config {
  // ignore: public_member_api_docs
  static String username;

  // ignore: public_member_api_docs
  static String password;

  // ignore: public_member_api_docs
  static String replacementPlanPassword;

  // ignore: public_member_api_docs
  static String cafetoriaUsername;

  // ignore: public_member_api_docs
  static String cafetoriaPassword;

  // ignore: public_member_api_docs
  static String fcmServerKey;

  // ignore: public_member_api_docs
  static bool dev;

  // ignore: public_member_api_docs
  static Map<String, String> headers;

  // ignore: public_member_api_docs
  static Map<String, String> replacementPlanHeaders;

  /// Load all config from an object
  static void load(Map<String, dynamic> data) {
    username = data['username'];
    password = data['password'];
    replacementPlanPassword = data['replacementPlanPassword'];
    cafetoriaUsername = data['cafetoriaUsername'];
    cafetoriaPassword = data['cafetoriaPassword'];
    fcmServerKey = data['fcmServerKey'];
    dev = data['dev'];
    headers = {
      'authorization':
          // ignore: lines_longer_than_80_chars
          'Basic ${base64Encode(utf8.encode('${Config.username}:${Config.password}'))}',
    };
    replacementPlanHeaders = {
      'authorization':
          // ignore: lines_longer_than_80_chars
          'Basic ${base64Encode(utf8.encode('${Config.username}:${Config.replacementPlanPassword}'))}',
    };
  }

  /// Load all data from environment or from config file if exists
  static void loadFromDefault() {
    var environment = true;
    final configFile = File('config.json');
    if (configFile.existsSync()) {
      environment = false;
    }
    final Map<String, dynamic> data = environment
        ? Platform.environment
        : json.decode(configFile.readAsStringSync());
    load(data);
  }
}
