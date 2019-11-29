import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ginko/utils/theme.dart';
import 'package:ginko/views/substitution_plan/row.dart';
import 'package:models/models.dart';
import 'package:translations/translations_server.dart';

import 'utils.dart';

void main() {
  group('Replacement plan', () {
    group('Replacement plan row', () {
      testWidgets('Normal replacement plan row with card', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
        expect(
          find.byType(Card),
          findsOneWidget,
        );
      });

      testWidgets('Normal replacement plan row without card', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
          showCard: false,
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
        expect(
          find.byType(Card),
          findsNothing,
        );
      });

      testWidgets('Replacement plan row without unit', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
          showUnit: false,
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsNothing);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsNWidgets(2));
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Normal replacement plan row with info ', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              room: '525',
              teacher: 'KRA',
              info: 'LOL',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('LOL'), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Normal replacement plan row with info and subject',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'PK',
              room: '525',
              teacher: 'KRA',
              info: 'LOL',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(
          find.text('${ServerTranslations.subjects('en')['PK']} LOL'),
          findsOneWidget,
        );
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Normal replacement plan row with replaced type',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Normal replacement plan row with replaced type and info',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
              info: 'LOL',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('LOL'), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Normal replacement plan row with exam type', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.exam,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
        expect(
          find.text(ServerTranslations.substitutionPlanExam('en')),
          findsOneWidget,
        );
      });

      testWidgets('Normal replacement plan row with orange color',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
        var containers = find
            .byType(Container)
            .evaluate()
            .map((e) => e.widget)
            .toList()
            .cast<Container>();
        containers = containers
            .where((container) => container.decoration != null)
            .toList();
        expect(containers.length, 1);
        final BoxDecoration decoration = containers[0].decoration;
        expect(decoration.color, Colors.orange);
      });

      testWidgets('Normal replacement plan row with green color',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            type: ChangeTypes.freeLesson,
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(
          find.text(ServerTranslations.substitutionPlanFreeLesson('en')),
          findsOneWidget,
        );
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
        var containers = find
            .byType(Container)
            .evaluate()
            .map((e) => e.widget)
            .toList()
            .cast<Container>();
        containers = containers
            .where((container) => container.decoration != null)
            .toList();
        expect(containers.length, 1);
        final BoxDecoration decoration = containers[0].decoration;
        expect(decoration.color, theme.primaryColor);
      });

      testWidgets('Normal replacement plan row with red color', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            type: ChangeTypes.exam,
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(
          find.text(ServerTranslations.substitutionPlanExam('en')),
          findsOneWidget,
        );
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
        var containers = find
            .byType(Container)
            .evaluate()
            .map((e) => e.widget)
            .toList()
            .cast<Container>();
        containers = containers
            .where((container) => container.decoration != null)
            .toList();
        expect(containers.length, 1);
        final BoxDecoration decoration = containers[0].decoration;
        expect(decoration.color, Colors.red);
      });

      testWidgets('Replacement plan row without original subject',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: null,
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(find.text(''), findsNWidgets(2));
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Replacement plan row without original room', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: null,
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsNWidgets(2));
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsOneWidget);
      });

      testWidgets('Replacement plan row without original teacher',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: null,
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsNWidgets(2));
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Replacement plan row without changed subject',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              room: '525',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
      });

      testWidgets('Replacement plan row without changed room', (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              teacher: 'KRA',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsNWidgets(2));
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsOneWidget);
      });

      testWidgets('Replacement plan row without changed teacher',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(SubstitutionPlanRow(
          change: Change(
            unit: 0,
            date: DateTime(2019, 8, 9),
            changed: Changed(
              subject: 'EK',
              room: '525',
            ),
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            type: ChangeTypes.changed,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text(''), findsNWidgets(2));
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text('525'), findsNWidgets(2));
      });
    });
  });
}
