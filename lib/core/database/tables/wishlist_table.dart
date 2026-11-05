import 'package:drift/drift.dart';

/// Wishlist and goals table schema.
class WishlistItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('goal'))();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

