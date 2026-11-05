import 'package:drift/drift.dart';

/// App settings and user preferences key-value table.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

