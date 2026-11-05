import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/wishlist_repository.dart';
import 'widgets/create_edit_wishlist_sheet.dart';
import 'widgets/wishlist_item_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  void _showCreateEditSheet(BuildContext context, [WishlistItem? item]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEditWishlistSheet(itemToEdit: item),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedCategory = ref.watch(wishlistCategoryFilterProvider);
    final itemsAsync = ref.watch(filteredWishlistStreamProvider);

    final categories = [
      (null, 'All'),
      ('goal', 'Goals'),
      ('product', 'Products'),
      ('skill', 'Skills'),
      ('project', 'Projects'),
      ('travel', 'Travel'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist & Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add item',
            onPressed: () => _showCreateEditSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat.$1 ||
                    (selectedCategory == null && cat.$1 == null);
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: FilterChip(
                    label: Text(cat.$2),
                    selected: isSelected,
                    checkmarkColor: Colors.white,
                    selectedColor: AppColors.indigoLight,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.lightSurfaceElevated,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.indigoLight
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                    ),
                    onSelected: (_) {
                      ref.read(wishlistCategoryFilterProvider.notifier).state =
                          cat.$1;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Items list or empty state
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.warningLight.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bookmark_added_rounded,
                              size: 32,
                              color: AppColors.warningLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No items in your wishlist',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Add dream products, skills to learn, or life goals to stay inspired.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add Goal or Item'),
                            onPressed: () => _showCreateEditSheet(context),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xs,
                    bottom: AppSpacing.xxl * 2,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return WishlistItemCard(
                      item: item,
                      onToggleCompleted: (completed) {
                        ref
                            .read(wishlistRepositoryProvider)
                            .toggleWishlistCompleted(item.id, completed);
                      },
                      onTap: () => _showCreateEditSheet(context, item),
                      onDelete: () {
                        ref
                            .read(wishlistRepositoryProvider)
                            .deleteWishlistItem(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Deleted "${item.title}"'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text('Error loading wishlist: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'wishlist_screen_fab',
        onPressed: () => _showCreateEditSheet(context),
        backgroundColor: AppColors.indigoLight,
        foregroundColor: Colors.white,
        tooltip: 'Add to Wishlist',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
