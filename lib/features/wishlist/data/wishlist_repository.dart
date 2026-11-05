import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return WishlistRepository(db);
});

final wishlistCategoryFilterProvider = StateProvider<String?>((ref) => null);

final filteredWishlistStreamProvider = StreamProvider<List<WishlistItem>>((
  ref,
) {
  final repo = ref.watch(wishlistRepositoryProvider);
  final category = ref.watch(wishlistCategoryFilterProvider);
  return repo.watchWishlistItems(category: category);
});

class WishlistRepository {
  final AppDatabase _db;

  WishlistRepository(this._db);

  Stream<List<WishlistItem>> watchWishlistItems({
    String? category,
    bool? isCompleted,
  }) {
    return _db.select(_db.wishlistItems).watch().map((items) {
      return items.where((item) {
        if (category != null && category.isNotEmpty && category != 'all') {
          if (item.category.toLowerCase() != category.toLowerCase()) {
            return false;
          }
        }
        if (isCompleted != null && item.isCompleted != isCompleted) {
          return false;
        }
        return true;
      }).toList()..sort((a, b) {
        // Incompleted first, then by priority, then by targetDate
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
        final pA = priorityOrder[a.priority.toLowerCase()] ?? 1;
        final pB = priorityOrder[b.priority.toLowerCase()] ?? 1;
        if (pA != pB) return pA.compareTo(pB);

        if (a.targetDate != null && b.targetDate != null) {
          return a.targetDate!.compareTo(b.targetDate!);
        }
        if (a.targetDate != null) return -1;
        if (b.targetDate != null) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
    });
  }

  Future<void> createWishlistItem({
    required String id,
    required String title,
    String? description,
    String category = 'goal',
    String priority = 'medium',
    DateTime? targetDate,
    String? imagePath,
  }) async {
    await _db
        .into(_db.wishlistItems)
        .insert(
          WishlistItemsCompanion.insert(
            id: id,
            title: title,
            description: Value(description),
            category: Value(category),
            priority: Value(priority),
            targetDate: Value(targetDate),
            imagePath: Value(imagePath),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> updateWishlistItem({
    required String id,
    required String title,
    String? description,
    String category = 'goal',
    String priority = 'medium',
    DateTime? targetDate,
    String? imagePath,
  }) async {
    await (_db.update(
      _db.wishlistItems,
    )..where((tbl) => tbl.id.equals(id))).write(
      WishlistItemsCompanion(
        title: Value(title),
        description: Value(description),
        category: Value(category),
        priority: Value(priority),
        targetDate: Value(targetDate),
        imagePath: Value(imagePath),
      ),
    );
  }

  Future<void> toggleWishlistCompleted(String id, bool isCompleted) async {
    await (_db.update(_db.wishlistItems)..where((tbl) => tbl.id.equals(id)))
        .write(WishlistItemsCompanion(isCompleted: Value(isCompleted)));
  }

  Future<void> deleteWishlistItem(String id) async {
    await (_db.delete(
      _db.wishlistItems,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
