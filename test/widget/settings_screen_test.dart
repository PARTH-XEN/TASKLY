import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/core/database/database_provider.dart';
import 'package:taskly/features/settings/presentation/settings_screen.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  Widget buildSettingsScreen(AppDatabase db) {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: SettingsScreen()),
    );
  }

  testWidgets('SettingsScreen renders all major sections and tiles', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(buildSettingsScreen(db));
    await tester.pumpAndSettle();

    // Verify Initial Visible Section Headers
    expect(find.text('VOICE PERSONALITIES (USP)'), findsOneWidget);
    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('ALARM & NOTIFICATION RELIABILITY'), findsOneWidget);

    // Scroll to check General Preferences & About sections
    await tester.scrollUntilVisible(
      find.text('GENERAL PREFERENCES'),
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('GENERAL PREFERENCES'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('ABOUT TASKLY'),
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('ABOUT TASKLY'), findsOneWidget);

    // Verify Specific Feature Tiles
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('Time Format'), findsOneWidget);
    expect(find.text('First Day of Week'), findsOneWidget);
    expect(find.text('Haptic Feedback'), findsOneWidget);

    await db.close();
  });

  testWidgets(
    'Theme Mode dialog allows selecting Dark Mode and updates setting',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = AppDatabase(NativeDatabase.memory());

      await tester.pumpWidget(buildSettingsScreen(db));
      await tester.pumpAndSettle();

      // Tap Theme Mode tile
      await tester.tap(find.text('Theme Mode'));
      await tester.pumpAndSettle();

      // Dialog appears with System Default, Dark Mode, Light Mode options
      expect(find.text('Choose Theme'), findsOneWidget);
      expect(
        find.widgetWithText(RadioListTile<ThemeMode>, 'System Default'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(RadioListTile<ThemeMode>, 'Dark Mode'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(RadioListTile<ThemeMode>, 'Light Mode'),
        findsOneWidget,
      );

      // Select Dark Mode
      await tester.tap(
        find.widgetWithText(RadioListTile<ThemeMode>, 'Dark Mode'),
      );
      await tester.pumpAndSettle();

      // Dialog closes
      expect(find.text('Choose Theme'), findsNothing);

      // Verify DB setting was persisted
      final setting = await db.select(db.appSettings).get();
      expect(
        setting.any((s) => s.key == 'theme_mode' && s.value == 'dark'),
        isTrue,
      );

      await db.close();
    },
  );

  testWidgets('Default Snooze Duration dialog allows selecting 15 minutes', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(buildSettingsScreen(db));
    await tester.pumpAndSettle();

    // Tap Default Snooze Duration tile
    await tester.tap(find.text('Default Snooze Duration'));
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.text('Default Snooze Duration'), findsWidgets);
    expect(find.text('5 minutes'), findsOneWidget);
    expect(find.text('15 minutes'), findsOneWidget);
    expect(find.text('20 minutes'), findsOneWidget);

    // Select 15 minutes
    await tester.tap(find.text('15 minutes'));
    await tester.pumpAndSettle();

    // Verify DB setting was persisted
    final setting = await db.select(db.appSettings).get();
    expect(
      setting.any((s) => s.key == 'default_snooze_minutes' && s.value == '15'),
      isTrue,
    );

    await db.close();
  });

  testWidgets(
    'Privacy & Offline Guarantee dialog displays full privacy commitment',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = AppDatabase(NativeDatabase.memory());

      await tester.pumpWidget(buildSettingsScreen(db));
      await tester.pumpAndSettle();

      // Scroll until Privacy tile is visible
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Privacy tile
      await tester.tap(find.text('Privacy & Offline Guarantee'));
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text('Privacy & Offline First'), findsOneWidget);
      expect(
        find.textContaining('100% offline-first architecture'),
        findsOneWidget,
      );

      // Tap Close / Dismiss
      await tester.tap(find.text('Understood'));
      await tester.pumpAndSettle();

      expect(find.text('Privacy & Offline First'), findsNothing);

      await db.close();
    },
  );
}
