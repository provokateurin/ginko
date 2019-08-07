import 'dart:async';

import 'package:app/utils/data.dart';
import 'package:app/utils/static.dart';
import 'package:app/views/extra_information.dart';
import 'package:app/views/unitplan/progress_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform/flutter_platform.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translations/translations_app.dart';

/// Home class
/// describes the home widget
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

/// HomeState class
/// describes the state of the home widget
class HomeState extends State<Home> with TickerProviderStateMixin {
  PanelController _panelController;
  TabController _tabController;
  int _weekday;
  static final _channel = MethodChannel('de.ginko.app');
  Timer _timer;

  /// Get the date of the current selected tab
  DateTime get getDate => monday.add(Duration(days: _weekday));

  /// Get the Monday of the week
  /// Skips a week of weekend
  DateTime get monday {
    final now = DateTime.now();
    return now
        .subtract(Duration(
          days: now.weekday - 1,
          hours: now.hour,
          minutes: now.minute,
          seconds: now.second,
          milliseconds: now.millisecond,
          microseconds: now.microsecond,
        ))
        .add(Duration(days: now.weekday > 5 ? 7 : 0));
  }

  @override
  void initState() {
    _panelController = PanelController();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_weekday != _tabController.index) {
        setState(() {
          _weekday = _tabController.index;
        });
      }
    });
    _updateTab();
    _timer = Timer.periodic(Duration(minutes: 1), (a) => _updateTab());
    Static.rebuildUnitPlan = () => setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((a) {
      if (!Data.online) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(AppTranslations.of(context).homeOffline),
        ));
      }
      if (Platform().isAndroid) {
        Data.firebaseMessaging
          ..requestNotificationPermissions()
          ..configure(
            onLaunch: (message) async {
              print('onLaunch: $message');
            },
            onResume: (message) async {
              print('onResume: $message');
            },
          );
        _channel.setMethodCallHandler(_handleNotification);
      }
    });
    super.initState();
  }

  void _updateTab() {
    setState(() {
      _tabController.index = _weekday = indexTab;
    });
  }

  /// Get the index of the initial tab
  int get indexTab {
    var day = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (monday.isAfter(DateTime.now())) {
      day = monday;
    }
    final lessonCount = Data.unitPlan.days[day.weekday - 1]
        .userLessonsCount(Data.user, isWeekA(day));
    if (DateTime.now()
        .isAfter(day.add(Times.getUnitTimes(lessonCount - 1)[1]))) {
      day = day.add(Duration(days: 1));
    }
    if (day.weekday > 5) {
      day = day.add(Duration(days: 8 - day.weekday));
    }
    return day.weekday - 1;
  }

  Future _handleNotification(MethodCall call) async {
    print(call);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(AppTranslations.of(context).homeNewReplacementPlan),
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery.of(context).size.width < 600
      ? getHeaderView(
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 100,
                child: getUnitPlanView,
              ),
              SlidingUpPanel(
                controller: _panelController,
                parallaxEnabled: true,
                parallaxOffset: .1,
                maxHeight: MediaQuery.of(context).size.height * 0.75,
                minHeight: 30,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
                panelSnapping: true,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                panel: ExtraInformation(
                  date: getDate,
                  panelController: _panelController,
                ),
              ),
            ],
          ),
        )
      : Row(
          children: [
            Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width - 300,
              child: getHeaderView(getUnitPlanView),
            ),
            Container(
              height: double.infinity,
              width: 300,
              child: ExtraInformation(
                date: getDate,
                panelController: _panelController,
              ),
            ),
          ],
        );

  /// Get the view of the unit plan
  Widget get getUnitPlanView => TabBarView(
        controller: _tabController,
        children: List.generate(
          5,
          (weekday) {
            final start = monday.add(Duration(days: weekday));
            return ListView(
              shrinkWrap: true,
              children: Data.unitPlan.days[weekday].lessons
                  .map((lesson) => UnitPlanProgressRow(
                        lesson: lesson,
                        start: start,
                        weekday: weekday,
                      ))
                  .toList()
                  .cast<Widget>(),
            );
          },
        ).toList().cast<Widget>(),
      );

  /// Get the app bar and tab bar header view
  Widget getHeaderView(Widget body) => DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppTranslations.of(context).appName),
            bottom: TabBar(
                controller: _tabController,
                tabs: AppTranslations.of(context)
                    .weekdays
                    .sublist(0, 5)
                    .map(
                      (weekday) => Tab(
                        child: Text(weekday
                            .substring(
                                0,
                                AppTranslations.of(context)
                                            .locale
                                            .languageCode ==
                                        'de'
                                    ? 2
                                    : 3)
                            .toUpperCase()),
                      ),
                    )
                    .toList()),
          ),
          body: body,
        ),
      );
}
