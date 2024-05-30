//transaction.dart
import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(max: 250)();
  IntColumn get categoryId => integer()(); // Mengubah dari category_id menjadi categoryId
  DateTimeColumn get transactionDate => dateTime()(); // Mengubah dari transaction_date menjadi transactionDate
  IntColumn get amount => integer()();

  DateTimeColumn get createdAt => dateTime()(); // Mengubah dari created_at menjadi createdAt
  DateTimeColumn get updatedAt => dateTime()(); // Mengubah dari updated_at menjadi updatedAt
  DateTimeColumn get deletedAt => dateTime().nullable()(); // Mengubah dari deleted_at menjadi deletedAt
}
