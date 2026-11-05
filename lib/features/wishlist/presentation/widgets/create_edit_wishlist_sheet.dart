import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/wishlist_repository.dart';

class CreateEditWishlistSheet extends ConsumerStatefulWidget {
  final WishlistItem? itemToEdit;

  const CreateEditWishlistSheet({super.key, this.itemToEdit});

  @override
  ConsumerState<CreateEditWishlistSheet> createState() =>
      _CreateEditWishlistSheetState();
}

class _CreateEditWishlistSheetState
    extends ConsumerState<CreateEditWishlistSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  late String _category;
  late String _priority;
  DateTime? _targetDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descController = TextEditingController(text: item?.description ?? '');
    _category = item?.category ?? 'goal';
    _priority = item?.priority ?? 'medium';
    _targetDate = item?.targetDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(wishlistRepositoryProvider);

      if (widget.itemToEdit != null) {
        await repo.updateWishlistItem(
          id: widget.itemToEdit!.id,
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          category: _category,
          priority: _priority,
          targetDate: _targetDate,
        );
      } else {
        await repo.createWishlistItem(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          category: _category,
          priority: _priority,
          targetDate: _targetDate,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.itemToEdit != null
                  ? 'Wishlist item updated'
                  : 'Wishlist item added',
            ),
            backgroundColor: AppColors.successLight,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save item: $e'),
            backgroundColor: AppColors.dangerLight,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.itemToEdit != null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Goal / Item' : 'New Wishlist Goal',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Title Input
                TextFormField(
                  controller: _titleController,
                  autofocus: !isEditing,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Goal or Item Title *',
                    hintText: 'e.g. Master Flutter Impeller Engine',
                    prefixIcon: Icon(Icons.bookmark_add_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Description Input
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'What makes this goal meaningful?',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Category & Priority
                Row(
                  children: [
                    // Category dropdown
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'goal', child: Text('Goal')),
                          DropdownMenuItem(value: 'product', child: Text('Product')),
                          DropdownMenuItem(value: 'skill', child: Text('Skill')),
                          DropdownMenuItem(value: 'project', child: Text('Project')),
                          DropdownMenuItem(value: 'travel', child: Text('Travel')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _category = val);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),

                    // Priority dropdown
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: _priority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'high', child: Text('High')),
                          DropdownMenuItem(value: 'medium', child: Text('Med')),
                          DropdownMenuItem(value: 'low', child: Text('Low')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _priority = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Target Date Picker
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.flag_circle_rounded, size: 18),
                        label: Text(
                          _targetDate == null
                              ? 'Target Date (Optional)'
                              : 'Target: ${DateFormat('MMM d, y').format(_targetDate!)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: _selectTargetDate,
                      ),
                    ),
                    if (_targetDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => setState(() => _targetDate = null),
                        tooltip: 'Clear Target Date',
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Save button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigoLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEditing ? 'Save Changes' : 'Add to Wishlist'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
