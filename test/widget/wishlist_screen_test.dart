import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/wishlist/data/wishlist_repository.dart';
import 'package:taskly/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:taskly/features/wishlist/presentation/wishlist_screen.dart';

void main() {
  testWidgets(
    'WishlistScreen displays header, category chips and empty state initially',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredWishlistStreamProvider.overrideWith(
              (ref) => Stream.value([]),
            ),
          ],
          child: const MaterialApp(home: WishlistScreen()),
        ),
      );

      await tester.pump();

      expect(find.text('Wishlist & Goals'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('No items in your wishlist'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    },
  );

  testWidgets('WishlistScreen renders WishlistItemCard when items exist', (
    tester,
  ) async {
    final sampleItem = WishlistItem(
      id: 'wish-test-1',
      title: 'Learn Flutter Animations',
      description: 'Master CustomPainter and Rive',
      category: 'skill',
      priority: 'high',
      targetDate: DateTime.now().add(const Duration(days: 45)),
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          filteredWishlistStreamProvider.overrideWith(
            (ref) => Stream.value([sampleItem]),
          ),
        ],
        child: const MaterialApp(home: WishlistScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Learn Flutter Animations'), findsOneWidget);
    expect(find.text('Master CustomPainter and Rive'), findsOneWidget);
    expect(find.text('SKILL'), findsOneWidget);
    expect(find.text('HIGH'), findsOneWidget);
    expect(find.byType(WishlistItemCard), findsOneWidget);
  });
}
