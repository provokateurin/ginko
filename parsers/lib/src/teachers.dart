import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// TeachersParser class
/// handles all teachers parsing
class TeachersParser {
  /// Extract teachers
  static Teachers extract(List<TimetableForGrade> timetables) => Teachers(
        date: timetables.isNotEmpty
            ? timetables[0].date
            : DateTime.fromMillisecondsSinceEpoch(0),
        teachers: timetables
            .map((timetable) => timetable.days
                .map((day) => day.lessons
                    .map((lesson) =>
                        lesson.subjects.map((subject) => subject.teacher))
                    .expand((x) => x))
                .expand((x) => x))
            .expand((x) => x)
            .toSet()
            .where((a) => a != null && a.isNotEmpty)
            .toList()
              ..sort((a, b) => a.toString().compareTo(b.toString())),
      );
}
