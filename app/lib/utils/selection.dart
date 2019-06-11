import 'package:app/utils/data.dart';
import 'package:app/utils/storage.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// Selection class
/// handles all unit plan selections
class Selection {
  /// Load all selections from storage
  static void load() {
    if (Data.unitPlan != null) {
      for (final day in Data.unitPlan.days) {
        for (final lesson in day.lessons) {
          if (lesson.subjects.length == 1) {
            Storage.setString(Keys.selection('${lesson.block}-a'),
                lesson.subjects[0].identifier);
            Storage.setString(Keys.selection('${lesson.block}-b'),
                lesson.subjects[0].identifier);
          }
        }
      }
    }
  }

  /// Get the selection for a day and unit
  static String get(String block, bool weekA) =>
      Storage.getString(Keys.selection('$block-${weekA ? 'a' : 'b'}'));

  /// Get the selection for a day and unit
  static void set(String block, bool weekA, String identifier) {
    Storage.setString(
        Keys.selection('$block-${weekA ? 'a' : 'b'}'), identifier);
  }
}
