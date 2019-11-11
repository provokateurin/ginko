import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';

/// SelectionHandler class
class SelectionHandler {
  // ignore: public_member_api_docs
  const SelectionHandler(MySqlConnection mySqlConnection)
      : _mySqlConnection = mySqlConnection;

  final MySqlConnection _mySqlConnection;

  /// Update the selection into the database
  Future<bool> updateSelection(
    LoginHandler login,
    HttpRequest request,
    String content,
  ) async {
    try {
      final user = await login.getUser(request);
      final selection = Selection.fromJSON(json.decode(content));
      for (final value in selection.selection) {
        final results = await _mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT date_time FROM users_selection WHERE username = \'${user.username}\' AND selection_key = \'${value.key}\';');
        if (results.toList().isNotEmpty) {
          final DateTime date = results.toList()[0][0];
          if (!value.modified.isAfter(date)) {
            continue;
          }
        }
        await _mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'INSERT INTO users_selection (username, selection_key, selection_value, date_time) VALUES (\'${user.username}\', \'${value.key}\', \'${value.value}\', \'${value.modified.toString().substring(0, value.modified.toString().length - 1)}\') ON DUPLICATE KEY UPDATE selection_value = \'${value.value}\', date_time = \'${value.modified.toString().substring(0, value.modified.toString().length - 1)}\';');
      }
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }

  /// Get the latest selection from the database
  Future<List<Map<String, dynamic>>> getSelection(
    LoginHandler login,
    HttpRequest request,
  ) async {
    final user = await login.getUser(request);
    final results = await _mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT selection_key, selection_value, date_time FROM users_selection WHERE username = \'${user.username}\';');
    return Selection(results
            .map((row) =>
                SelectionValue(row[0].toString(), row[1].toString(), row[2]))
            .toList()
            .cast<SelectionValue>()
            .toList())
        .toJSON();
  }
}
