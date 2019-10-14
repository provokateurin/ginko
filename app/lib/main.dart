import 'dart:convert';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ginko/aixformation.dart';
import 'package:ginko/cafetoria.dart';
import 'package:ginko/home.dart';
import 'package:ginko/loading.dart';
import 'package:ginko/login.dart';
import 'package:ginko/replacementplan.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/pwa/pwa.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/storage/storage.dart';
import 'package:ginko/utils/theme.dart';
import 'package:ginko/views/header.dart';
import 'package:ginko/views/unitplan/scan.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:translations/translation_locales_list.dart';
import 'package:translations/translations_app.dart';

Future main() async {
  if (Platform().isDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  WidgetsFlutterBinding.ensureInitialized();

  if (!await PWA().navigateLoadingIfNeeded()) {
    Static.storage = Storage();
    await Static.storage.init();

    runApp(MaterialApp(
      title: 'Ginko',
      theme: theme,
      localizationsDelegates: [
        AppTranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales:
          LocalesList.locales.map((locale) => Locale(locale)).toList(),
      routes: <String, WidgetBuilder>{
        '/': (context) => Scaffold(body: LoadingPage()),
        '/login': (context) => Scaffold(body: LoginPage()),
        '/home': (context) => Scaffold(body: App()),
      },
    ));
  }
}

/// App class
/// describes the home widget
class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

/// AppState class
/// describes the state of the home widget
class AppState extends State<App> with TickerProviderStateMixin {
  static final _channel = MethodChannel('de.ginko.app');

  final List<Page> _pages = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      setState(() {
        _pages.addAll(
          [
            Page(
              name: AppTranslations.of(context).pageStart,
              icon: Icons.home,
              child: HomePage(
                user: Data.user,
                unitPlan: Data.unitPlan,
                replacementPlan: Data.replacementPlan,
                calendar: Data.calendar,
                cafetoria: Data.cafetoria,
                updateUser: Data.updateUser,
              ),
            ),
            Page(
              name: AppTranslations.of(context).pageReplacementPlan,
              icon: Icons.format_list_numbered,
              child: ReplacementPlanPage(
                user: Data.user,
                replacementPlan: Data.replacementPlan,
              ),
            ),
            Page(
              name: AppTranslations.of(context).pageCafetoria,
              icon: Icons.restaurant,
              child: CafetoriaPage(
                user: Data.user,
                cafetoria: Data.cafetoria,
              ),
            ),
            Page(
              name: AppTranslations.of(context).pageAiXformation,
              icon: MdiIcons.newspaper,
              child: AiXformationPage(
                user: Data.user,
                posts: Data.posts,
              ),
            ),
          ],
        );
      });
      if (!Data.online) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(AppTranslations.of(context).homeOffline),
        ));
      }
      if (Platform().isMobile) {
        await updateTokens(context);
      }

      // Ask for scan
      if (isSeniorGrade(Data.user.grade.value) &&
          Platform().isMobile &&
          !(Static.storage.getBool(Keys.askedForScan) ?? false)) {
        Static.storage.setBool(Keys.askedForScan, true);
        var allDetected = true;
        for (final day in Data.unitPlan.days) {
          if (!allDetected) {
            break;
          }
          for (final lesson in day.lessons) {
            if (!allDetected) {
              break;
            }
            for (final weekA in [true, false]) {
              if (Selection.get(lesson.block, weekA) == null) {
                allDetected = false;
                break;
              }
            }
          }
        }
        if (!allDetected) {
          await showDialog(
            context: context,
            builder: (context) => ScanDialog(
              teachers: Data.teachers,
              unitPlan: Data.unitPlan,
            ),
          );
        }
      }
    });
    super.initState();
  }

  /// Update all tokens
  static Future updateTokens(BuildContext context) async {
    if (Platform().isMobile || Platform().isWeb) {
      final gotNullToken = await Data.firebaseMessaging.getToken() == 'null';
      await Data.firebaseMessaging.requestNotificationPermissions();
      Data.firebaseMessaging.configure(
        onLaunch: (data) async => _handleNotification(context, data),
        onResume: (data) async => _handleNotification(context, data),
        onMessage: (data) async => _handleNotification(context, data),
      );
      _channel.setMethodCallHandler((call) async {
        _handleNotification(context, json.decode(json.encode(call.arguments)));
      });

      // If the notification permissions were previously not granted
      // (means getting null as token) then get the token again and push it
      // to the server
      if (gotNullToken) {
        print('Got a token after requesting permissions');
        print('Updating tokens on server');
        await Data.updateUser();
      }
    }
  }

  static void _handleNotification(
      BuildContext context, Map<String, dynamic> data) {
    print(data);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(AppTranslations.of(context).homeNewReplacementPlan),
    ));
    if (Static.rebuildReplacementPlan != null) {
      Static.rebuildReplacementPlan();
    }
  }

  @override
  Widget build(BuildContext context) => Header(
        pages: _pages,
        user: Data.user,
      );
}
