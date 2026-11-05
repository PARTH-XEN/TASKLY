import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/wishlist/data/wishlist_repository.dart';

void main() {
  late AppDatabase db;
  late WishlistRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = WishlistRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('WishlistRepository Unit Tests', () {
    test(
      'createWishlistItem saves item and watchWishlistItems retrieves it',
      () async {
        await repository.createWishlistItem(
          id: 'wish-1',
          title: 'Master Advanced Flutter 3.x',
          description: 'Build robust enterprise apps with Impeller & Drift',
          category: 'skill',
          priority: 'high',
          targetDate: DateTime.now().add(const Duration(days: 30)),
        );

        final items = await repository.watchWishlistItems().first;
        expect(items.length, 1);
        expect(items.first.title, 'Master Advanced Flutter 3.x');
        expect(items.first.category, 'skill');
        expect(items.first.priority, 'high');
        expect(items.first.isCompleted, isFalse);
      },
    );

    test('toggleWishlistCompleted marks item as completed', () async {
      await repository.createWishlistItem(
        id: 'wish-2',
        title: 'Visit Kyoto in Spring',
        category: 'travel',
      );

      await repository.toggleWishlistCompleted('wish-2', true);
      final items = await repository.watchWishlistItems().first;
      expect(items.first.isCompleted, isTrue);
    });

    test('category filter isolates items by category accurately', () async {
      await repository.createWishlistItem(
        id: 'w-prod',
        title: 'Mechanical Keyboard',
        category: 'product',
      );
      await repository.createWishlistItem(
        id: 'w-travel',
        title: 'Swiss Alps Hiking',
        category: 'travel',
      );
      await repository.createWishlistItem(
        id: 'w-skill',
        title: 'Learn Rust Language',
        category: 'skill',
      );

      final productItems = await repository
          .watchWishlistItems(category: 'product')
          .first;
      expect(productItems.length, 1);
      expect(productItems.first.title, 'Mechanical Keyboard');

      final travelItems = await repository
          .watchWishlistItems(category: 'travel')
          .first;
      expect(travelItems.length, 1);
      expect(travelItems.first.title, 'Swiss Alps Hiking');
    });

    test('deleteWishlistItem removes item from database', () async {
      await repository.createWishlistItem(id: 'w-del', title: 'Old Goal');
      var items = await repository.watchWishlistItems().first;
      expect(items.length, 1);

      await repository.deleteWishlistItem('w-del');
      items = await repository.watchWishlistItems().first;
      expect(items, isEmpty);
    });
  });
}
